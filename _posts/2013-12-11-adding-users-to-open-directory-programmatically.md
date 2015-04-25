---
layout: post
title: Adding Users to Open Directory Programmatically
tags:
- dscl
- Mavericks
- Open Directory
- OS X Server
author: Dan Barrett
---

Recently I had someone contact me because they were looking for a script that would pull users from a CSV, and then import them into Open Directory on OS X Mavericks Server.  Always up for a challenge I wrote a bash script to grab the users then send them to the Open Directory domain.

[Check out the code on GitHub Gist!](https://gist.github.com/yesdevnull/7908795)

This script brings in the first name, surname, student ID and password from a CSV (the path can be specified in the only argument the script requires, which is the path to the CSV).  The shortname is derived from the first name, surname and student ID.  For example, Steve Miller with the Student ID of 654321 becomes `sm654321`.

To run the script, you would enter something like this:

```
./import_users.sh Users.csv
```

And, using the example Users.csv provided in the Gist (please bear in mind that the Gist automatically removes the trailing blank line, please add it before running the script), you would expect something like below:

```
2013-12-11 21:49:03: Added Joe Smith (js123456) to /LDAPv3/127.0.0.1.
2013-12-11 21:49:06: Added Bill Jones (bj987654) to /LDAPv3/127.0.0.1.
2013-12-11 21:49:09: Added Steve Miller (sm654321) to /LDAPv3/127.0.0.1.
```

For each user, the commands take between 3 to 4 seconds.  That includes creating the user along with adding them to the groups.  As noted in the bash script, you must ensure your CSV has Unix (CRLF) line endings, and a blank line at the end of the script.  If it doesn't have the correct line endings, it'll fail completely.  If you don't have a blank line at the end, the last person in the list won't be added.

Thankfully, adding this user through `dscl` creates the proper AuthenticationAuthority so the user is set up with Kerberos v5 and Apple Password Server.  By default, the user will be added to the local groups `com.apple.access_radius`, `com.apple.access_afp` and `com.apple.access_addressbook`, and the network group `workgroup`.

Here's a dump of a user created through this script:

```
dsAttrTypeNative:objectClass: person inetOrgPerson organizationalPerson posixAccount shadowAccount top extensibleObject apple-user
AltSecurityIdentities: Kerberos:sm654321@MAVERICKS.PRETENDCO.COM
AppleMetaNodeLocation: /LDAPv3/127.0.0.1
AppleMetaRecordName: uid=sm654321,cn=users,dc=mavericks,dc=pretendco,dc=com
AuthenticationAuthority:
&nbsp;;ApplePasswordServer;0xdb945916625111e39e62000c2928b48d,1024 65537 128972542829193592982355741981221062100920762016712038819623846465209128342622049783124389838185059988320142773235291480753225648977678597461748953848863734839600213928074142175413820927534135441280785829108224574601521657224863604777924988844508041132576614047193318182335513084715122081757952216834576233343 root@mavericks.pretendco.com:10.1.125.120
&nbsp;;Kerberosv5;;sm654321@MAVERICKS.PRETENDCO.COM;MAVERICKS.PRETENDCO.COM;
Comment:
&nbsp;Student ID: 654321
EMailAddress: sm654321@pretendco.com
FirstName: Steve
GeneratedUID: FECF06E0-6654-4583-8471-B88AC4AC7D41
Keywords: students
LastName: Miller
NFSHomeDirectory: /dev/null
Password: ********
PrimaryGroupID: 20
RealName:
&nbsp;Steve Miller
RecordName: sm654321
RecordType: dsRecTypeStandard:Users
UniqueID: 1052
UserShell: /usr/bin/false
```

[Check out the code on GitHub Gist!](https://gist.github.com/yesdevnull/7908795)

_*Note:* I've tested this script a fair bit, but don't blame me if your Open Directory screws up!  Always ensure you have a known-good backup before running a script you got off the internet.  I've tried to get this script as perfect as possible, but there's always bugs because not every environment is the same._