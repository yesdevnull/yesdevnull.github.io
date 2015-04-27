---
layout: post
title: Caching Server 2 and iOS 7 Confusion
tags:
- Caching
- Mavericks
- OS X Server
author: Dan Barrett
---

So it appears there is some confusion in the Apple community about whether Caching Server 2 actually caches iOS 7 app downloads.  Numerous posts have been popping up saying "No, you're wrong, it doesn't cache iOS 7 downloads!".  I'm here to say, no, you're wrong.  It **does**.  After some extensive testing, I will now elaborate.

First off, I'm going to install a program called [Charles](http://www.charlesproxy.com/) that acts as a proxy server.  Install Charles, set it up then have [your iOS device route requests through Charles](http://www.charlesproxy.com/documentation/faqs/using-charles-from-an-iphone/) so we can see exactly what's happening.  Now, before I continue, I must let you know that the app I am about to download was one that I had previously downloaded a week ago, but then deleted (my partner and I were using it for her university project) so it has already been cached on my Mavericks Caching Server.  This article isn't about the initial caching process, more about proof that it does in fact serve cached iOS App Store downloads.  I have a standard OS X Mavericks Server running on a 2010 Mac mini with healthy DNS and 1 subnet, and my iPhone is running iOS 7.0.3.

{% include caption.html image="/assets/2013/app_download.jpg" text="The App Download In Charles." %}

Right, so I load up the Purchases tab on my iPhone and tap on the app to download it.  Now this app in question is [Metronome](https://itunes.apple.com/au/app/metronome/id416443133?mt=8), a small app that is 18.7 MB in size.  Make sure you remember the size because it's important.  Just before I downloaded the app I opened up Charles and started a recording session.  The app downloads pretty quickly and I check out what Charles has captured.

{% include caption.html image="/assets/2013/uri-tree.png" text="The Caching Server's Proxy Tree." %}

So far, it looks good.  As you can sort of see by the image, my caching server at `10.1.125.254` on port `61090` responded to an App Store download request.  How is that possible when Caching Server 2 doesn't support iOS 7 app downloads?  Oh wait, it does.  My bad.  Let's investigate further:

{% include caption.html image="/assets/2013/response-size.png" text="My Caching Server's Response Size &mdash; Go Figure!" %}

Basically, that image shows that the response from my caching server was 18.72 MB in size.  Wow!  Didn't I say that the app was 18.7 MB in size?  Yep, I did.  But wait, that's not the only piece of evidence I'm going to use to prove that I'm right.  Next, I'm going straight to the source.  Caching Server 2 stores all of the cached metadata in a database called AssetInfo.db.  I'm going to copy that to the Desktop using Terminal (the folder it resides in isn't accessible by standard Finder means).

Okay, I've copied the AssetInfo.db from `/Library/Server/Caching/Data/` and opened it up in [Base](http://menial.co.uk/base/), which is a program to work with SQLite 3 databases.  After opening AssetInfo.db I loaded up the `ZASSET` table and export all rows as a CSV.  I then opened up the CSV in Excel (Oh Numbers?  We all know Numbers has _excellent_ CSV support...).  Next, copying the UUID from the URI in Charles, I pasted that into a search field in Excel, and to my surprise, a row was returned!  (I lie, it wasn't a surprise.  I expected it to return a result).  You could also do this in Terminal, like this:

```
sqlite3 /Library/Server/Caching/Data/AssetInfo.db 'SELECT * FROM ZASSET WHERE ZURI LIKE "%8bbfacac-c1ed-b397-e6cd-9110eb87001b%"'
```

Which gets me this beautiful result:

```
177|1|5|0|19624091||404215540.806059|daa32fb0fc47da467fd693e12262c318|6FCE511E-C2B2-4449-99E2-0B5EC9F919B4|Fri, 07 Dec 2012 03:15:24 GMT|/au/r1000/070/Purple/v4/8b/bf/ac/8bbfacac-c1ed-b397-e6cd-9110eb87001b/mzps1125351636230933757.D2.dpkg.ipa|
```

Now, one of those fields is the ZURI (aka the URI that Caching Server uses).  When examining the URI in Charles, you can see the URI is the same:

```
http://10.1.125.254:61090/au/r1000/070/Purple/v4/8b/bf/ac/8bbfacac-c1ed-b397-e6cd-9110eb87001b/mzps1125351636230933757.D2.dpkg.ipa?source=a954.phobos.apple.com
```

Of course you exclude the IP address as it's the caching server address on my LAN.   The URI matches the AssetInfo.db's ZURI field and guess what?  The `ZLASTMODIFIEDSTRING` is the exact same date that the last update for Metronome was published (7th December 2012).  I also found that the `ZTOTALBYTES` field, when converted to MB in Base-2, equals... 18.7 MB (which in itself is unusual, the rest of caching server calculates bytes in Base-10).  Also, doing a Get Info on the binary file reveals the exact same byte count as `ZTOTALBYTES`.

Further to that, when I navigate to the actual binary (stored at `/Library/Server/Caching/Data/<GUID>/0` by default) and enter `md5 /path/to/file` I get the same hash that is stored in `ZCHECKSUM`.  For example, the hash for Metronome in the `ZCHECKSUM` row is `daa32fb0fc47da467fd693e12262c318`.  Then, in Terminal I entered:

```
md5 /Library/Server/Caching/Data/6FCE511E-C2B2-4449-99E2-0B5EC9F919B4/0
```

Now, my result was `daa32fb0fc47da467fd693e12262c318`.  Let's compare them:

```
daa32fb0fc47da467fd693e12262c318 # ZCHECKSUM
daa32fb0fc47da467fd693e12262c318 # md5 Result in Terminal
```

Yep, they're identical.  Fact-based proof that OS X Mavericks Server's Caching Server provides cached iOS App Store downloads to iOS 7 devices.

Now, this article has come off very douchey, but I felt it was necessary to prove to people that Caching Server 2 in OS X Mavericks Server **does** cache iOS app downloads.