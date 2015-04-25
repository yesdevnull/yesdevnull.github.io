---
layout: post
title: yes > /dev/null 2.0 Released
tags:
- Website
author: Dan Barrett
---

{% include caption.html image="/assets/2014/yesdevnull-2.0.jpg" text="The website as it appears on a MacBook, iPhone and iPad." %}

Over the last month I've been thinking that my website was ermm... rather shocking on any screen that wasn't a laptop screen.  There was no support for phone or tablet displays, along with no support for retina/HiDPI displays that most smartphones are using these days.

I started off with rebuilding the template from scratch using a flexible and responsive [Sass](http://sass-lang.com/) template framework called [Gumby](http://gumbyframework.com/).  This is my first experience using a CSS preprocessor/framework and it was pretty fun to play around.  I am now very much into mixins and includes.

Next, all site iconography (from [Glyphicons](http://glyphicons.com/)) were converted to svg and then entered as code into CSS.  I figured that it would be quicker to make big up the CSS file size a bit more than have a few extra HTTP requests for a few small images.

I've spent a while testing the site on a staging environment so hopefully it's working ok for you readers!  If you see any issues with the site, please let me know on Twitter at [@yesdevnull](https://twitter.com/yesdevnull).