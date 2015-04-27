---
layout: post
title: Caching Server Nagios Script Updated for Mavericks
tags:
- Caching
- GitHub
- Mavericks
- OS X Server
- RRDtool
author: Dan Barrett
github_link: https://github.com/jedda/OSX-Monitoring-Tools/blob/master/check_osx_caching.sh
---

Just a quick heads up that [Jedda](http://jedda.me) and I's check_osx_caching monitoring script for Nagios and OS X has been updated to support OS X Mavericks Server.  Given that Caching Server 2 in 10.9 adds more verbosity to what content is taking up what space, I've added support for each content type and has been added to the performance data that is returned in the script.

As content usage is not tracked in Mountain Lion's Caching Server I had to do a check of the operating system to see what version the script is being run on.  To do this, I used the function `sw_vers` and added the flag `productVersion` to only have the product version returned.  Now, on a first release of the OS you'll get a clean float like `10.9` or `10.8` which makes it really easy to do a comparison using `bc` (a precision calculator language).  Where it becomes a problem is when you get numbers like `10.8.5` which, because they have two periods, mean they don't work with `bc`.  I decided I could either write a function that does a full comparison of the version numbers, or just get the major and minor release and do a standard mathematical float comparison.  Using grep I can pull the major and minor release information and assign it to a variable.  See below for the code:

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

Now, if the value of the expression is 0, we will now grab all the Mavericks Caching Server usage data, and assign it to a variable called `mavericksPerfData` which is appended to the end of the final return printf.

I'll be updating our RRDtool graph for the Caching Server 2 and will post the code soon!  Stay tuned.

[Check out the code on GitHub!](https://github.com/jedda/OSX-Monitoring-Tools/blob/master/check_osx_caching.sh)