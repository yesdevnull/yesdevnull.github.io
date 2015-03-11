---
layout: post
title: OS X Server and Heartbleed
author: Dan Barrett
tags:
- OS X
- OS X Server
- Security
- SSL
---
![OS X Server and Heartbleed](/assets/2014/heartbleed_osx.png)

If you keep up with technical news you would've seen an abundance of articles on something called Heartbleed (or CVE-2014-0160). Essentially, it's a protocol implementation bug that affects newer versions of OpenSSL, which is used in a majority of Linux installations and can affect many services like Apache, nginx and even IMAP (just to name a few). I'm not going to go into the details because I'll leave that to the experts, but I highly recommend taking a look at the [Heartbleed](http://heartbleed.com/) website to learn more.

Now, when I saw this I got immediately worried about all my clients' (not to mention my own) installation of OS X Server. Thankfully, OS X has an older implementation of OpenSSL (on 10.9.2 it's 0.9.8y – found by doing this command in Terminal: `openssl version`) and according to the Heartbleed website, is not vulnerable. Just to make sure, I ran a Python script found online written by Jared Stafford ([download](http://pastebin.com/WmxzjkXJ)) and when against my server at home, I get the following:

{% highlight bash %}
Connecting...
Sending Client Hello...
Waiting for Server Hello...
... received message: type = 22, ver = 0301, length = 53
... received message: type = 22, ver = 0301, length = 2551
... received message: type = 22, ver = 0301, length = 525
... received message: type = 22, ver = 0301, length = 4
Sending heartbeat request...
... received message: type = 21, ver = 0302, length = 2
Received alert:
0000: 02 46                  .F
Server returned error, likely not vulnerable
{% endhighlight %}

Further testing on OS X has revealed that Heartbleed won't be exposing anything, which is a huge relief for me. Having said that, as this was undiscovered for 2 years, theoretically there's nothing stopping there being another vulnerability in the wild that could be causing the same (or more or less) damage as Heartbleed.

If you run the Python script and find you are affected, I urge you to patch your OpenSSL installation and regenerate your SSL certificates from scratch. As this vulnerability grabs 64KB worth of data from memory, it's possible your private key could be in that 64KB. This means you need more than just a CSR, you’ll need to start from the beginning. You can check yourself using an excellent service [by Filippo Valsorda](http://filippo.io/Heartbleed).

Good luck out there.