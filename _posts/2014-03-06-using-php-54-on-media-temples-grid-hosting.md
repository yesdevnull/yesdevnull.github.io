---
layout: post
title: Using PHP 5.4 cli on Media Temple’s Grid Hosting
tags:
- Composer
- PHP
author: Dan Barrett
---
I recently ran into a problem on Media Temple’s grid hosting where I couldn’t get Composer to run any post-install-cmd scripts. I was racking my brains on why it would be failing, it was working on my dev environment OK!

{% include caption.html image="/assets/2014/composer_error.png" text="The Composer error in my Terminal" %}

The problem was that the PHP binary that is at `/usr/bin/php` via the cli is 5.3.27, which is below my minimum required version of 5.4. Luckily, a much newer version of PHP (5.5.6 at the time of writing, to be precise) is available at `/usr/bin/php-latest`. The solution was a two pronged approach.

First off, create a bash profile (or edit an existing one) to have an alias to link `php` to `php-latest`. You should SSH into your grid server and enter the following commands:

```bash
nano ~/.bash_profile
```

Now, we’ll add the alias:

```bash
alias php="/usr/bin/php-latest"
```

Exit out of nano by pressing `^X` (or Control+X), then hit `Y` to confirm the changes, then press `Return` to save your changes to the same filename. Finally, type in the command below to make those changes live (otherwise you’d have to log out/in again to see that alias change):

```bash
source ~/.bash_profile
```

You’ll now notice that if you do `php -v` you’ll be using the PHP 5.5.6 cli binary. Hooray! But, don’t celebrate yet. If you try to run a Composer post-*-cmd script that requires PHP 5.4 (or greater), it’ll fail. Unfortunately, the commands through Composer don’t seem to be able to pick up the bash alias so we’ll have to manually edit the composer.json file to update the binary paths. Once again, jump back to your SSH session (or you could edit it in a text editor).

Before I continue, the composer.json file I’m using is the one for `laravel/framework`. So, using `nano` I’m updating each instance of `php` in the scripts section of the composer.json file, and replacing them with `php-latest`.

```json
"scripts": {
    "post-install-cmd": [
        "php-latest artisan clear-compiled",
        "php-latest artisan optimize"
    ],
    "post-update-cmd": [
        "php-latest artisan clear-compiled",
        "php-latest artisan optimize"
    ],
    "post-create-project-cmd": [
        "php-latest artisan key:generate"
    ]
},
```

Save and edit, then enter `php composer.phar` update and watch as Composer downloads, installs and does its post-install optimisations, all withouts errors!

You can now safely kick back with the knowledge that your PHP cli will be running the latest version of PHP (as available from Media Temple).

Enjoy!