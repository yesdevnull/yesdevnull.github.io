---
layout: post
title: Backup Backup Backup
tags:
- Backups
- Carbon Copy Cloner
- CrashPlan
- OS X
- Time Machine
author: Dan Barrett
---

Today, on Backblaze's blog they posted [an excellent article](http://blog.backblaze.com/2013/11/12/how-long-do-disk-drives-last/) on the lifespan of a hard drive (or HDD for the cool cats).  Having spent the last three and a half years in a break/fix workshop I spend every day dealing with failing hard drives, and customers with no backups.  Years ago I would've felt sorry for people that have lost data because storage was relatively expensive and there wasn't a good range of software that made the backup process easier.  These days I find it hard to sympathise with people who lose data because there are so many cheap and easy ways to backup your drive.  I'm going to lay out how I manage my backups, and how it works for me.

### Time Machine

<!-- images -->

[Time Machine](http://www.apple.com/au/osx/apps/#timemachine) has been included in OS X since Leopard (10.5 / 2007 ) and has been getting better and better every OS X release.  Mountain Lion (10.8 / 2012) brought the biggest change with allowing you to have multiple Time Machine backup destinations, utilising a "round robin" system.  I use a multi-disk Time Machine backup where my first disk is a [2TB LaCie Porsche](http://www.lacie.com/au/products/product.htm?id=10559) which I manually plug into at home every few days, and my main Time Machine backup disk is done through Time Machine Server on my Mac mini Server at home, and stored on a Drobo which is connected via FireWire 800.  I probably wouldn't restore my entire machine from the networked Time Machine backup as it would take forever, but I would use it to restore some files and folders.  In the end it's really a safety net that I can fall back on just in case my drive(s) die, I can recover most of my data from the Carbon Copy Cloner backup, then recover any further files from Time Machine.

### Carbon Copy Cloner

<!-- images -->

[Carbon Copy Cloner](http://bombich.com/) has been one of the best tools in my arsenal of Mac diagnostics and repair for years now.  I was initially thrown out by the sudden minor version release where it went from a free program to costing $40, but I bought it straight away because I know how reliable it is, and how much work Mike Bombich puts into the application.  I have another [2TB LaCie Porsche](http://www.lacie.com/au/products/product.htm?id=10559) which also only gets connected every few days or so and I run a scheduled backup that clones all changes from my MacBook Pro to the LaCie Porsche every 2 hours.  I like having the CCC backup because unlike my other backups, this backup is bootable so if my machine goes down at the wrong time, I can boot from my backup quickly and finish off something before fitting a new drive.

### CrashPlan

<!-- images -->

Last (but certainly not least) is [CrashPlan](http://www.code42.com/crashplan/), the amazing cloud backup service that continuously backups your important stuff whenever you're connected to the internet.  I decided to get a family account and have set it up on some family and friends accounts where they can back up to CrashPlan's servers, along with my Mac mini Server that has some space on my Drobo dedicated for CrashPlan backups.  I really like CrashPlan because the frequency of versioned files is tuned to 15 minutes by default, so if I'm working on a document or coding and I make a huge mistake, I can go back to a good copy with CrashPlan - that strategy really has worked for me.  The backup for my personal MacBook Pro has two backup sets:

- **Local Backup:** the local backup set backs up to my local Mac mini Server and includes `/Applications` because I have some apps that I can't find download links for anymore, and I also backup `~` (or my home folder).  I also have a filename exclusion list that excludes specific file extensions like virtual machine files and movie files.  Uncompressed, this is just under 300GB.
- **Remote Backups:** the remote backup set backs up to CrashPlan Central and is a lot more limited than my local backup set because I don't want to seed 300GB of data to the U.S.!  In this backup set, only the home folder is backed up  and I exclude all audio/video file types, along with disk images and virtual machine files.  Overall, this backup set contains just under 100GB of data in total.

### Finale

All in all, I have three separate backup systems with five separate points of failure (or two if my house is completely destroyed and I'm not at home at the time).  I'm hoping that I won't have to use one of my backups to fully restore, but given that I'm running DIY Fusion Drive on an optibay-ed MacBook Pro, I'm expecting that one day an update will royally screw it.  Given that all the options I've mentioned are really really cheap, save yourself some pain and get a good backup routine going!

I gave Backblaze a try over a year ago but didn't like the fact that it automatically excluded (and wouldn't include) some folders that I wanted to have backed up so I stopped using the service.  I've re-signed and am going to giving it a second try - hopefully it works a little better for me.  I also found the app a little confusing, I was never sure if it had finished seeding, or what the status was at all.