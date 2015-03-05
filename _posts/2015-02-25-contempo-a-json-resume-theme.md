---
layout: post
title: "Contempo — A JSON Resume Theme"
github_link: https://github.com/yesdevnull/jsonresume-theme-contempo
---
I recently started using [JSON Resume](https://jsonresume.org/) to make it easier to update my résumé and I found that I didn’t really like any of the themes that were available. So, I did what any person who had a few hours free would do and developed my own… \*drumroll\*

# Introducing Contempo

Now that was pretty anticlimactic. I’ve had the same résumé design for a few years now. I’ve loved its simple design, the lack of colour, and the clean layout. When it came to updating it however, it was a complete nuisance. All the horizontal rules in the template had to many adjusted each time I added a new line – to put it plainly, I hated updating my résumé! Something had to be done.

After fluffing around with Handlebars and CSS for a few hours (I’ve never used Handlebars before, I do quite like it though) I hacked together a theme that resembled my original Pages résumé document. The result is pretty close to my old résumé, my only issue is that there doesn’t appear to be a way to do footers reliably.

If you already have a published JSON Resume file you can do `http://registry.jsonresume.org/yourusername?theme=contempo` to preview the Contempo theme. Alternatively, `cd` into your JSON Resume directory then publish with `resume publish --theme contempo`. Last resort, if you don’t have a JSON Resume résumé, you can see [my hosted résumé on JSON Resume](http://registry.jsonresume.org/yesdevnull).

[![npm version](https://badge.fury.io/js/jsonresume-theme-contempo.svg)](http://badge.fury.io/js/jsonresume-theme-contempo) [![GitHub version](https://badge.fury.io/gh/yesdevnull%2Fjsonresume-theme-contempo.svg)](https://github.com/yesdevnull/jsonresume-theme-contempo)