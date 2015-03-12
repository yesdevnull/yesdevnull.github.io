---
layout: post
title: Last.fm Album Image Generator
tags:
- Laravel
- Last.fm
- PHP
- Website
github_link: https://github.com/yesdevnull/Lastfm-Album-Image-Generator
author: Dan Barrett
---
If you didn’t know already, I have run a [Last.fm](http://www.last.fm/) Album Image Generator on my old site for a couple of years now. Recently I started playing with [Laravel](http://laravel.com/) (Façade controversy ho!) and I’ve really loved it, so I decided to port my image generator over to Laravel, and to open source it.

{% include caption.html image="/assets/2014/lastfmalbumimagegenerator.jpg" text="The album artwork for Last.fm" %}

Using Laravel has allowed me to make the service a lot easier to develop, and also extend. I’m taking advantage of the logging and caching features in Laravel, along with using plenty of other fantastic packages from [Packagist](https://packagist.org/). Overall, I’ve found Laravel has a gentle learning curve (unlike ZF2) and is easy to get started with. I started with [Code Bright](https://leanpub.com/codebright) which was a really good read and gave me a very good head start in developing with Laravel. Of course, the [Laravel docs](http://laravel.com/docs) were very useful, along with my friend, Dr. [Google](http://google.com/).

If you go to [http://lastfmalbumimagegenerator.com](http://lastfmalbumimagegenerator.com/) (and don’t pass any variables in the query string) you’ll be directed to the generator where you can enter your Last.fm username then hit Generate! and you’ll be given BBCode to put on your Last.fm profile page. Pretty simple really!

Here’s an example of the BBCode you’ll get:

{% highlight bbcode %}
[url=http://lastfmalbumimagegenerator.com?user=yesdevnull&num=1&type=link][img]http://lastfmalbumimagegenerator.com?user=yesdevnull&num=1[/img][/url]
{% endhighlight %}

If you’re a developer, I invite you to [take a look at the code](https://github.com/yesdevnull/Lastfm-Album-Image-Generator) and submit any PRs for fixes, improvements, enhancements etc.

I hope this service works well for you!