---
layout: post
title: Time Machine Monitoring Nagios Script Updated for OS X Mavericks
tags:
- GitHub
- Mavericks
- Nagios
- OS X
- Time Machine
author: Dan Barrett
github_link: https://github.com/jedda/OSX-Monitoring-Tools/blob/master/check_time_machine_currency.sh
---

Just a quick heads up that the Nagios script for Time Machine written by [Jedda](http://jedda.me) (and updated by me) has been updated with support for OS X Mavericks (10.9).  Unfortunately the `.TimeMachine.Results` file no longer exists in Mavericks.  At first my thought was to enumerate through the arrays in `/Library/Preferences/com.apple.TimeMachine.plist` but that was going to be very complex, and very difficult to do in Bash.  In the end, `tmutil` ([Man Page Link](https://developer.apple.com/library/mac/documentation/Darwin/Reference/Manpages/man8/tmutil.8.html)) came to the rescue.

Along with the other Mavericks scripts, I do the quick check to see what OS is running before doing a if/then statement depending on the OS.  When running `tmutil latestbackup` you'll get the path to the latest backup (note that the disk(s) *must* be connected otherwise the command will fail).  The last folder in the path is the timestamp for the most recent backup.  Using `grep` we can pull out the timestamp from the path:

```
tmutil latestbackup | grep -E -o "[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{6}"
```

Next up, using the `date` command we can convert the timestamp to the time in Unix Epoch (number of seconds from 1st January, 1970).  Once the timestamp has been converted to the Unix timestamp, we get the current time in Unix time and measure the different between the two by subtracting the latest backup timestamp from the current timestamp.

This is a relatively minor update to the [OS X Monitoring Tools](https://github.com/jedda/OSX-Monitoring-Tools) codebase, but it's handy to have another script updated for OS X Mavericks (10.9).  As always, the code for the file is below:

[Check out the code on GitHub!](https://github.com/jedda/OSX-Monitoring-Tools/blob/master/check_time_machine_currency.sh)