---
layout: post
title: A Simple Way To Display Your Age In PHP
tags:
- PHP
author: Dan Barrett
---
I was quickly updating my website today when I thought of a handy snippet that could be useful for someone.  I realised last year when I turned 23 that my website wouldn't automatically change my age on my birthday (d'uh).  It's only until today that I thought I'd sit down and figure out how to do it in PHP.  Turns out, it's pretty easy.

To do this, we're going to use the [DateTime](http://php.net/manual/en/class.datetime.php) class (a minimum of PHP 5.3 is required because we're using the `diff` function which wasn't included in 5.2), which is included in PHP and does not require any extra extensions to be installed.

Open up your favourite text editor (in my case, [Coda 2](http://panic.com/coda/)).  Like I said, using the DateTime class we're going to create a DateTime object with our birthday, or in this example, the UNIX Epoch (1970-01-01).

```php
$birthday = new DateTime('1970-01-01');
```

Plainly put, this creates a new DateTime instance with the date `1970-01-01` as the date/time string.  Pretty simple so far huh.  Now let's grab the current date/time:

```php
$currentDate = new DateTime('now');
```

We're now storing the current date and time (`$currentDate`) in another DateTime instance.  Both of these dates will be calculated with the current PHP timezone, if you need to specify another timezone, you can add an extra parameter with the required timezone.  Now, let's calculate our difference:

```php
$interval = $birthday->diff($currentDate);
```

**Note:** you can also skip the current date variable and just enter `$interval = $birthday->diff(new DateTime('now'));`, but using the separate variable is a bit neater.

If you were to do a [print_r](http://php.net/print_r) of the `$interval` variable, you'd get the [DateInterval](http://php.net/manual/en/class.dateinterval.php) object:

```php
DateInterval Object
(
	[y] => 44
	[m] => 1
	[d] => 17
	[h] => 16
	[i] => 54
	[s] => 7
	[weekday] => 0
	[weekday_behavior] => 0
	[first_last_day_of] => 0
	[invert] => 0
	[days] => 16119
	[special_type] => 0
	[special_amount] => 0
	[have_weekday_relative] => 0
	[have_special_relative] => 0
)
```

Given that we're only interested in the year, we can go ahead and use the [format](http://php.net/manual/en/dateinterval.format.php) function to only output what we want.  Examining for PHP.net documentation page (or using the excellent app [Dash](http://kapeli.com/dash)) you'll see that there's a parameter for year, using `y`.

```php
echo $interval->format('%y')
```

And you'll see the following output:

```php
44
```

Pretty cool huh?  Another example, using the `$birthday` of `1986-04-20` would get you the result of `27`.

All in all, you're looking at pretty simple code:

```php
<?php

$birthday = new DateTime('1986-04-20'); // Enter your birthday in YYYY-MM-DD format
$currentDate = new DateTime('now');

$interval = $birthday->diff($currentDate);

echo $interval->format('%y');
```

And that's how you do it.