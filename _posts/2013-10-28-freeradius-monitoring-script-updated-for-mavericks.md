---
layout: post
title: FreeRADIUS Monitoring Script Updated for Mavericks
tags:
- Mavericks
- Nagios
- OS X Server
- RADIUS
author: Dan Barrett
---

I've updated the FreeRADIUS monitoring script for Nagios with support for OS X Mavericks Server.  Mavericks changed the way the FreeRADIUS server is started, along with the paths of execution and storage.

Like the update to the [Caching Server 2](/2013/10/caching-server-nagios-script-updated-for-mavericks/) monitoring script, I had to write a check to see if the current OS is running 10.9, and if it is, perform a Mavericks-specific check.  Like I mentioned in the other article, doing a version check and comparison isn't particularly easy in Bash, but thankfully, I only have the compare the major and minor release numbers which is nice given that it's also a float.  Using `bc` (the arbitrary precision calculator language - _I should get that on a shirt!_) I can quite easily calculate the difference between 10.8 and 10.9.  Anyway, check the code below for how I get the version number.

```
sw_vers -productVersion | grep -E -o "[0-9]+\.[0-9]"
```

Next, the comparison is performed to see whether the current OS is less than `10.9`.  If the current OS is less than `10.9`, 1 is returned.  If it's the same (or greater), the result is 0.  This code is below:

```
echo $osVersion '< 10.9' | bc -l
```

Note that the above example requires the variable `$osVersion`.  If you were hard coding the values, you could do something like below:

```
echo '10.8 < 10.9' | bc -l
```

The major difference in my script for OS X Mavericks is now there's actually a process running called `radiusd`!  Using `ps` and `grep` I now check to see if the FreeRADIUS server is running by doing this:

```
ps -ef | grep radiusd
```

Which, if the FreeRADIUS (or radiusd) is running, will return a non-empty string.  If you run that and get an empty string (or nothing) back then your FreeRADIUS server _isn't_ running.  Shit.  I recommend doing `radiusd -X` to start your RADIUS server in debug mode.  That or you forgot to get RADIUS added to launchd by entering `radiusconfig -start`.  Anyway, that's enough chit-chat, just get the damn code from the link below:

[Check out the code on GitHub!](https://github.com/jedda/OSX-Monitoring-Tools/blob/master/check_radius.sh)