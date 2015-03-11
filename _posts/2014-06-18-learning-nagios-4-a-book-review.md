---
layout: post
title: Learning Nagios 4 - A Book Review
author: Dan Barrett
tags:
- GroundWork
- Nagios
---
As a longtime user of GroundWork, I’ve always had an abstraction layer between me and Nagios. I’d always thought that having a better understanding of the internals of GroundWork would make it easier for me to use, but I didn’t take the opportunity to learn about Nagios until now.

The book, [Learning Nagios 4](http://www.packtpub.com/learning-nagios-4/book), by Wojciech Kocjan, weighs in at 400 pages and is the second edition. I found the book to be very well written, and it contained a lot of good technical information that I thought was interesting and beneficial.

**Chapter 1** introduces Nagios to the unfamiliar user, and Wojciech gives good examples that ensure system administrators that Nagios is suitable for them. can provide IT staff with a very good system to check infrastructure and software to ensure it’s working correctly.

**Chapter 2** runs through installing and configuring Nagios. I was very pleased to see a book providing instructions on installing software from source, as it’s rather unusual in my experience to find books that don’t just provide installation by package manager. Going through common Nagios configurations was also interesting, as I learnt a few quirks about templates and precedence.

**Chapter 3** is all about the web interface that compliments Nagios. As a user of Nagios by proxy through GroundWork I was a little shocked at the Web GUI and how different it was to the interface I was used to, but it is nice to see Nagios 4 has implemented PHP support so there’s a bigger avenue for theme customisation.

**Chapter 4** talks about the basic plugins that are provided with Nagios. If you’re a follower of my blog you would’ve seen my Nagios plugins for OS X Server, some of which were co-authored with/by my friend Jedda Wignall. I learnt quite a bit about the inbuilt plugins that come with Nagios, including the plugins that can schedule package manager checks – very cool!

**Chapter 5** discusses advanced configuration details, mainly about templates and the nuances to inheritance, along with describing what flapping actually is. I thought the section on using multiple configurations (like OS type, location etc) to generate a configuration for a specific machine was quite interesting, and would allow the user to create advanced host settings with relative ease.

**Chapter 6** was a chapter that I found very interesting as it focused on alerts and contacts. As a former member of a very small team we were inundated by emails every day and it became hard to keep track of what was coming in. The authors example of constant email flooding was exactly what happened to us. It’s worth spending a bit more time setting up proper alerts to make sure the right information reaches the right people, rather than spamming everyone constantly.

**Chapter 7** talks about passive checks, and how they compare to the normal active checks. NCSA, or the Nagios Service Check Acceptor is also discussed, which is a daemon on the client end that can send check results back to the monitoring service securely. I’ve not used either types of passive checks, so learning about them was quite interesting. I’m looking forward to putting them into good use some time.

**Chapter 8** contains a ton of great information and detail about the remote server checks performed by SSH, and the Nagios Remote Plugin Executor (NRPE). The author provides good arguments for choosing either of the services, depending on your requirements. I hadn’t actually heard of NRPE before, but it looks to be quite powerful without the overhead of SSH connections by the host.

**Chapter 9** is all about SNMP and how it can interact with Nagios. In past experience I’ve only ever had bash scripts to process SNMP responses, but now I know how to implement it properly into Nagios without having a conduit processing script. I also never really knew much about SNMP, so it was good to learn about what SNMP actually is, not just how to interact with it, which can be an issue in some technical books where interacting is explained, but the source/destination isn’t.

**Chapter 10** starts off by covering getting Nagios working with Windows clients, which to me isn’t very applicable as I’m purely a Linux/Unix/OS X man myself so my eyes glazed over as I pushed through that section. Having said that, it’s good to know Nagios monitoring is fully supported in Windows with the appropriate software installed. Another concept that is looked at in Chapter 10 is the setup and configuration of a multi-server master/slave setup with multiple Nagios servers. Now, unfortunately (or fortunately, depending on which way you look at it) I’ve not been in a position where I’ve needed to have multiple Nagios servers performing checks, but it’s useful to know that it’s possible, and to have some instructions on getting it set up.

**Chapter 11** is probably my favourite chapter of the book because it’s all about programming Nagios plugins. The book has a multitude of examples written in different languages. I’ve always done my scripts in Bash, but had never even thought of writing plugins in PHP, which is my strongest language. Having seen code for a few languages (like Tcl) that I’ve heard of but not used, this book has encouraged me to try other languages for Nagios plugins, and not limit myself to Bash.

**Chapter 12**, the final chapter, talks about the query handler which is used for two-way communications with Nagios. There’s also a section on Nagios Event Radio Dispatcher (or NERD) which can be used for a real-time notification system for alerts.

Overall, I would highly recommend this book to any sysadmins looking to implement an excellent monitoring solution that is easy to set up, yet powerful enough through its extensive plugin collection and flexibility. After reading this book I’ve come away with a stronger knowledge of Nagios that will benefit my work in the future.

**Note:** I was provided with a free eBook to review this book, however, this review is 100% genuine and contains my true thoughts about the book.