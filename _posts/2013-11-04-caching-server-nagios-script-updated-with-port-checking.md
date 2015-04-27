---
layout: post
title: Caching Server Nagios Script Updated With Port Checking
tags:
- Caching
- Nagios
- OS X Server
author: Dan Barrett
---

I've just updated the Nagios script for OS X Server's Caching Server with support for ensuring Caching Server is running on a specific port.

In a normal setup of Caching Server, it has the ability to change ports during reboots, and if you have a restrictive firewall, you'll have to specify a port for Caching Server via the command line.  You can specify the port via the `serveradmin` command (make sure you stop the service first):

```
sudo serveradmin settings caching:Port = xxx
```

The `xxx` is the port you want to use for Caching Server.  Normally, Caching Server will use `69010`, but depending on your environment, that port may be taken by another service and so Caching Server will pick another port.  Using that command above will get Caching Server to attempt to map to the specified port, but if it can't it will fall back to finding another available port.

The script checks the port as defined in `serveradmin settings caching:Port` and cross-references it with `serveradmin fullstatus caching:Port`.  If they are the same, we'll continue through the script, but if it doesn't I'll throw a warning.  Naturally, if `serveradmin settings caching:Port` returns `0`, I skip any further port checks because a `0` port means randomly assign a port.

[Check out the code on GitHub](https://github.com/jedda/OSX-Monitoring-Tools/blob/master/check_osx_caching.sh)