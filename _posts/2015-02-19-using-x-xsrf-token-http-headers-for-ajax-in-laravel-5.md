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

### Option 1 - Encrypted CSRF Token

Our first option is to encrypt the CSRF token. As you may already know, you can access the CSRF token by using the function `csrf_token`. Load up your `routes.php` file so we can add the encrypted token to the views.

For each view you call, you'll need to append this method:

```php
withEncryptedCsrfToken(Crypt::encrypt(csrf_token()));
```

So, if you were calling a view for the home template, you'd do this:

```php
view('home')->withEncryptedCsrfToken(Crypt::encrypt(csrf_token()));
```

Terrific. In that template you can access the variable like below:

```php
{% raw %}
<meta name="csrf_token" ="{{ $encrypted_csrf_token }}" />
{% endraw %}
```

Chuck that in your main view in the `<head>` so your JavaScript framework of choice can gobble it up.  Just make sure to do `use Crypt;` if you're in a different namespace.

### Option 2 - Non-encrypted CSRF Token

Our second option is to alter the `VerifyCsrfToken` middleware to not expect an encrypted CSRF Token when transmitted via a HTTP Header.

Open up the `VerifyCsrfToken.php` middleware (located at `app/Http/Middleware/`) and we'll extend the method `tokensMatch`.

```php
protected function tokensMatch($request)
{
	$token = $request->session()->token();

	$header = $request->header('X-XSRF-TOKEN');
      
	return StringUtils::equals($token, $request->input('_token')) ||
		($header && StringUtils::equals($token, $header));
}
```

Essentially, what I've done is copied the method from `Illuminate/Foundation/Http/Middleware/VerifyCsrfToken.php` then removed the call to `$this->encrypter`. You'll also need to add a `use` at the top of `VerifyCsrfToken.php` like so:

```php
use Symfony\Component\Security\Core\Util\StringUtils;
```

Once you've done that, you can safely use plain old `csrf_token` in your `X-XSRF-TOKEN` header and get `200 - OK` with all your AJAX calls.  If you didn't quite figure out the middleware alteration, load up [this Gist to see how I modified the VerifyCsrfToken middleware](https://gist.github.com/yesdevnull/3f9ee445c5838add8905).

### Implementing in jQuery

If you happen to be using jQuery with Laravel, here's how you can add the HTTP Header to your AJAX requests.  As usual, there's a few different options.  If you're doing a heap of requests over the lifetime of the session, you'll want to set this token for all AJAX requests.  If not, you can do it inline with the AJAX call.

First up, the pre-filter to make this global for all `$.ajax` requests:

```javascript
$.ajaxPrefilter(function(options, originalOptions, xhr) {
	var token = $('meta[name="csrf_token"]').attr('content');

	if (token) {
		return xhr.setRequestHeader('X-XSRF-TOKEN', token);
	}
});
```

Good stuff.  Now, all `$.ajax` requests in the application lifecycle will use that prefilter with the token and HTTP Header.

If you just need the HTTP Header for one or two requests, here's how you can add it to the `$.ajax` call:

```javascript
$.ajax({
	url: 'http://example.com/api',
	beforeSend: function (xhr) {
		var token = $('meta[name="csrf_token"]').attr('content');

		if (token) {
			return xhr.setRequestHeader('X-XSRF-TOKEN', token);
		}
	},
	/* ... */
});
```

That "pre-filter" will be in effect for that `$.ajax` call only.

### Moving Forward

Now, it's entirely up to you how to proceed. Just to be safe, I've decided to go with Option 1 because I want to err on the side of caution, but if your Laravel 5 app is super simple and can't do much/any harm, I think it's OK for your CSRF Token to match in a string-to-string comparison, but not be valid JSON.

Only time will tell.

### Updates:

- **19/02/2015** - I originally had the CSRF Token encrypted in the boot method of the AppServiceProvider.  This was incorrect as `csrf_token` isn't set unless it's called from within a Route.  My mistake!
- **24/02/2015** - Updated with comments about Laravel 5.0.6 now supporting cleartext X-XSRF-TOKENs.