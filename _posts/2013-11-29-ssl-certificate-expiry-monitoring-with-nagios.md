---
layout: post
title: SSL Certificate Expiry Monitoring with Nagios
tags:
- GitHub
- GroundWork
- Nagios
- Security
- SSL
author: Dan Barrett
---

The expiration of an SSL certificate can render your secured service inoperable.  In late September, LightSpeed's SSL certificate for their activation server expired which made any install or update fail due to not being able to connect to said activation server via SSL.  This problem lasted two days and was a problem worldwide.  This could have been avoided by monitoring the SSL certificate using a monitoring solution like [GroundWork](http://www.gwos.com/).  We currently have a script that checks certificates, but it's only designed to look at certificates on OS X in `/etc/certificates`.  I've since written a bash script that will obtain any web-accessible certificate via openssl and check its start and end expiry dates.

The command I use to get the SSL certificate and its expiry is as follows:

```
echo "QUIT" | openssl s_client -connect apple.com:443 2>/dev/null | openssl x509 -noout -startdate 2>/dev/null
```

First, we echo QUIT and pipe it to the `openssl s_client -connect` command to send a QUIT command to the server so `openssl` will finish up neatly (and won't expect a ^C to quit the process).  Next, that result is piped to `openssl x509` which displays certificate information.  I also send the `noout` flag to not prevent the output of the encoded version of the certificate.  Finally, `startdate` or `enddate` depending on which date I want.  With both of the `openssl` commands I redirect `stderr` (standard error) output to `/dev/null` because I'd rather ignore any errors at this time.

The rest of the script performs regex searches of the output (using `grep`), then formats the timestamp with `date` before doing a differential of the expiration timestamp, and the current timestamp (both of these are in UNIX Epoch time).  Depending on how many you days in the expiration warning, if the number of seconds for the current Epoch time minus the expiration date is less than the expiration day count, a warning is thrown.

To use this script, all you need to specify is the address of the host, the port and number of days to throw a warning (e.g. specify 7 if you want a warning period of 7 days).  For example, to get the SSL certificate for `apple.com` on the port `443` you would enter:

```
./check_ssl_certificate.expiry -h apple.com -p 443 -e 7
```

And you should get something like below:

```
OK - Certificate expires in 338 days.
```

Not only does this script verify the end date of the certificate, but it also verifies the start date of the certificate.  For example, if your certificate was set to be valid from 30th December 2013, you might see something like the error below:

```
CRITICAL - Certificate is not valid for 30 days!
```

Or if your certificate has expired, you'll see something like below:

```
CRITICAL - Certificate expired 18 days ago!
```

Hopefully this script will prevent your certificates from expiring without your knowledge, and you won't have angry customers that can't access your service(s)!

[Check out the code on GitHub!](https://github.com/jedda/OSX-Monitoring-Tools/blob/master/check_ssl_certificate_expiry.sh)