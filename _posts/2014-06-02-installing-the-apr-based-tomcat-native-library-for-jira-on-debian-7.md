---
layout: post
title: Installing the APR-based Tomcat Native Library for Jira on Debian 7 (Updated)
author: Dan Barrett
tags:
- Apache
- Debian
- Jira
---
If you’re self-hosting [Jira](https://www.atlassian.com/software/jira) on Debian (or another platform, but this post is Debian specific) you might notice in the catalina.log file a line that reports something like this:

```
INFO: The APR based Apache Tomcat Native library which allows optimal performance in production environments was not found on the java.library.path: /usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib
```

While this message [isn’t a bug](https://confluence.atlassian.com/display/STASHKB/Stash+console+output%3A+INFO%3A+The+APR+based+Apache+Tomcat+Native+library+which+allows+optimal+performance+in+production+environments+was+not+found) per se, but if you’re a completist like me, you’ll want to get it installed to speed up performance for Jira.

First up, you’ll want to install [Apache Portable Runtime](http://apr.apache.org/) library along with OpenSSL, if you want to use SSL. Using the command line, we’ll install them with `apt-get`:

```
apt-get install libapr1-dev libssl-dev
```

Go through the process of installing the libraries by following the `apt` prompts. Note that the version of OpenSSL installed is 1.0.1e, but [is patched for CVE-2014-0160](http://www.debian.org/security/2014/dsa-2896) aka Heartbleed).

Next, we’ve got to grab the tomcat native library source tarball (tomcat-native.tar.gz) from Jira so we can compile from source. If you installed Jira from the .bin installer, Jira should be installed at `/opt/atlassian/jira`. From there, you’ll find the tomcat-native.tar.gz in the `bin/` folder (full path: `/opt/atlassian/jira/bin`). To keep the `bin` directory clean, we’ll extract the tarball to the home folder of the logged in user:

```
tar -xzvf tomcat-native.tar.gz -C ~
```

Now if you cd into the home directory (`cd` then `ls -la`) you’ll find a directory called `tomcat-native-1.1.29-src`. We’ll need to locate the `configure` script that is some where in that folder. Thankfully, I’ve already done the research for you and it’s in `jni/native`. `cd` to that location.

Now that we’ve got the configure script, we need to run the script with the appropriate configuration locations and files. At minimum, you should provide the APR location (`--with-apr`) and the JVM location (`--with-java-home`). If you installed APR with apt, the APR config binary will be in `/usr/bin/apr-1-config`.

Next, the JRE/JDK location. Jira comes with a bundled JRE, but it’s not sufficient for the Tomcat Native Library configurator. If you use the Jira JRE path of `/opt/atlassian/jira/jre` you’ll get the error `checking os_type directory... Cannot find jni_md.h in /opt/atlassian/jira/jre` when you run the configuration script. To rectify this, you’ll need the OpenJDK JRE for Linux. Once again, using apt we can install it with ease: `apt-get install openjdk-7-jre`. After that has completed, if you do `find / -name "jni_md.h"` you should get something like this:

```
/usr/lib/jvm/java-7-openjdk-amd64/include/jni_md.h
/usr/lib/jvm/java-7-openjdk-amd64/include/linux/jni_md.h
```

You can use either file, as a `diff` shows that both files are the same. With that in mind, our configuration variable `--with-java-home` can be set to `/usr/lib/jvm/java-7-openjdk-amd64`. Finally, with SSL support, you can safely set `--with-ssl` to `yes` as the configurator can guess the OpenSSL settings. With all that in mind, our final configure string will be as follows:

```
./configure --with-apr=/usr/bin/apr-1-config --with-java-home=/usr/lib/jvm/java-7-openjdk-amd64 --with-ssl=yes
```

Hit return and let the configure script finish. Now you can finish it off by making and installing by doing the following: `make && make install`. As we did not specify an installation prefix, the compiled library will be installed at `/usr/local/apr/lib`. Jira expects the library to be in one of these folders: `/usr/java/packages/lib/amd64`, `/usr/lib64`, `/lib64`, `/lib` or `/usr/lib`. I’m just going to copy them to `/usr/java/packages/lib/amd64`, do that like so:

```
cp /usr/lib/* /usr/java/packages/lib/amd64
```

Now you’re done. Simply start Jira using your prefered method and you should find that APR is being loaded correctly. You can verify this by doing `cat /opt/atlassian/jira/logs/catalina.out | grep -A 1 "AprLifecycleListener"` and you should see something like this:

```
Jun 02, 2014 4:23:11 PM org.apache.catalina.core.AprLifecycleListener init
INFO: Loaded APR based Apache Tomcat Native library 1.1.29 using APR version 1.4.6.
Jun 02, 2014 4:23:11 PM org.apache.catalina.core.AprLifecycleListener init
INFO: APR capabilities: IPv6 [true], sendfile [true], accept filters [false], random [true].
Jun 02, 2014 4:23:11 PM org.apache.catalina.core.AprLifecycleListener initializeSSL
INFO: OpenSSL successfully initialized (OpenSSL 1.0.1e 11 Feb 2013)
```

Hooray! Jira is running, and it’s loading the Tomcat Native Library with APR successfully!

# Updates
- **27/09/2014:** updated with newest package name and `cp` path.