---
layout: post
title: Using X-XSRF-TOKEN HTTP Headers for AJAX in Laravel 5 (Updated)
tags:
- Laravel
- AJAX
- PHP
- jQuery
- Security
author: Dan Barrett
---
**Update (24/02/2015):** Laravel 5.0.6 has been updated to support cleartext X-XSRF-TOKENs. As explained in the recent post [CSRF Protection in Laravel explained](http://barryvdh.nl/laravel/2015/02/21/csrf-protection-in-laravel-explained/) by Barry vd. Heuvel, Laravel can now process X-XSRF-TOKENs if they are transmitted in cleartext. Some would argue it’s still better to encrypt the CSRF token, but that’s for much smarter InfoSec people than me.

*The following article was written for Laravel 5.0.5 in mind, but is still relevant as of 5.0.6:*

If you’ve recently started using Laravel 5 and are trying to use `csrf_token()` with the header `X-XSRF-TOKEN` with your AJAX requests, you’ll notice that you get a HTTP Error code 500, rather than a 200 OK response. This is because the CSRF middleware is expecting the `csrf_token` via `X-XSRF-TOKEN` to be encrypted – Something the `Laravel documentation` doesn’t make clear *(note: about 10 days after this article was published the docs got updated with much clearer instructions.)*