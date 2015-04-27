---
layout: post
title: OS X Mavericks Server - Adding Groups
tags:
- Mavericks
- Open Directory
- OS X Server
author: Dan Barrett
---

Along with adding users to your OS X Mavericks Server's Open Directory you can also add groups to contain specific users to specific groups.  For example, your sales team might have their own group called sales that provides them specific file sharepoints, jabber group and even add a special group mailing list for all users in that group.  The group also allows you to specify different ACLs for each group.

First, I recommend following my guide ["Adding New Users"]({{ site.url }}/2013/10/os-x-mavericks-server-adding-new-users/) to add users to your Open Directory domain because groups are pretty useless without users!  Anyway, onwards and upwards.

{% include caption.html image="/assets/2013/groups_blank.jpg" text="Server: No Groups Yet." %}

Okay, jump over to the Server app and load up the Groups section.  If this is a base installation with Open Directory, you should only see one group in the `Local Network Groups` and it's called `Workgroup`.  By default, any user you add to the Open Directory domain will be added to this group.  Given that I'm still rolling with characters from The Office, I'll add some groups that relate to the users we added earlier.  Click the plus in the bottom-left corner to add a new group.

<!-- images -->

First off, I'm going to make a group called Accounting.  For the Full Name, enter `Accounting` and the Group Name will be `accounting`.  Once you've entered those details, go ahead and click the Create button to add the group.  Initially when you add the group there's hardly any configuration aside from the name.  Believe me, there's more configuration to be done once you've added the group!

You'll now be taken back to the list of groups, but now the group you just added will be in that list.  Hooray!  But we can't celebrate yet because our group has no one in it!  Let's change that.  Double click on your group to modify the settings and add/remove users.

<!-- images -->

Alrighty then, we can now modify some settings.  First thing you'll notice is that you can rename the "nice" name of the group, but you can't change the shortname.  Basically, if you didn't name your group correctly the first time and you want to change its name, just delete the damn thing and create a new one.  This may be more tedious if you've been using the group for a while, so make sure you do it right the first time.  Next thing is giving the group a special shared folder on the Server, which is located at `/Groups/<groupshortname>` on the server.  Enable this if you want that folder to be enabled, otherwise if you have your own folder structure you're following, you can just add this group to the folder's ACL.

Next is making the group members all buddies in Messages (or jabber).  Enable it if you want the members to automatically be friends if they have the Messages app set up.  If you're not using the inbuilt Messages server, this option won't need to be enabled.  For the curious, if you enter the following command into Terminal, you'll be shown all the groups and their Messages autobuddy status.

```
sudo serveradmin settings accounts
```

For example, if I were to enable or disable autobuddy via Terminal for the group accounting, I would enter the commands below:

```
sudo serveradmin settings accounts:GroupServices:EnableAutoBuddy:accounting = no # Disble autobuddy
sudo serveradmin settings accounts:GroupServices:EnableAutoBuddy:accounting = yes # Enable autobuddy
```

The next easy option is setting up a mailing list which, when email is sent to that address, will be sent to all the members of the group.  This email address is the group's short name.  For example, `accounting@pretendco.com` or `sales@pretendco.com`.  By default, only members of the group can send emails to that mailing list, otherwise, enable the "Allow mail from non-group members" to enable emails from anyone (yes, it's literally everyone - not just people in the Open Directory domain).

<!-- images -->

It's now time to add members to the group!  Not only can you add users to a group, but you can also add groups to other groups!  There's a very cool hierarchy that you can configure with users and groups, but don't over-complicate it otherwise your ACL precedence and inheritance are going to be very, very confusing.  When you click the plus you can either start typing in a user name or group name (and it will auto suggest then click on the user to add it), otherwise, start typing browse then select Browse to bring up a list of all applicable users and groups that can be added to the group.

{% include caption.html image="/assets/2013/groups_user_list.jpg" text="The Users and Groups Browse List." %}

As per usual, you can add keywords and notes for the group.  Once you're done editing the group, click OK to save your changes.

### Workgroup Manager

As with every other OS X Server release there has been a program called Workgroup Manager (internally I've heard the nickname Workgroup Mangler) which shows you all the users, groups, machines and machine groups for Open Directory domains.  First off, Workgroup Manager isn't distributed with Server so we need to download it seperately off Apple's website so [click here to download](http://support.apple.com/kb/DL1698).  Once you've downloaded and installed Workgroup Manager, open it up and connect to your server!  Go to Server then click Connect...

{% include caption.html image="/assets/2013/wm_connect_empty.jpg" text="Workgroup Manager: Connect to Server." %}

Enter details for your local server to connect.  For example, the address will be the FQDN (remember what that stands for?) so my server will be `mavericks.pretendco.com`.  If you want to make any edits you'll need to be logged in as the Master Directory Administrator (or any other user you've given Server administration rights to).  If you're just connecting to browse the Open Directory domain, log in as any admin user (for example, my Server Administrator login for the Server machine gives me read-only access to the Open Directory domain).  Next, enter the applicable password.  Hit Connect to... you know... connect.

{% include caption.html image="/assets/2013/wm_connect.jpg" text="Workgroup Manager: Connect to mavericks.pretendco.com" %}

If all goes well and you've entered the correct details you should now be shown a list of all the users in your Open Directory domain!  Hooray!

<!-- images -->

You'll notice that in the list of users, any user that has a pencil in their icon means that they have administration rights for the Open Directory domain you've connected to.  Anyway, just above the list of users are four icons, the second one from the left is Groups - click it.

<!-- images -->

Excellent, we can now see all the groups in the Open Directory domain.  Clicking on any group will show you the basic settings for the group, you can also change memberships for the group and even the Group Folder.  Have a look around in Workgroup Manager, but make sure you know what changes you're making, you could permanently damage a user or group by making the wrong change (word of advice, don't change short names or IDs).

### Command Line Goodness

Accessible via Terminal is the very powerful command `dseditgroup` which as you might guess, allow you to edit directory service groups.  The name of the command however is a bit of a misnomer given that you can do more than just edit the group.  I personally think the command should be called `dsgroup` but that's just me.  Anyway, now onto the usefulness of this command.  Given that we've been playing with the group `accounting`, let's use this command to show us details about the group!

```
dseditgroup -o list accounting
```

Essentially what we're doing here is using the `-o` flag (otherwise known as _operation_), we specify that we're requesting a list of the accounting group.  Here's the output of dseditgroup for the group accounting on my system:

```
dsAttrTypeStandard:GroupMembership -
	aschrute
	kmalone
	omartinez
dsAttrTypeStandard:Member -
	aschrute
	kmalone
	omartinez
dsAttrTypeStandard:GeneratedUID -
	B6131BAA-B8CE-4828-8BE3-3BA03A8EAF43
dsAttrTypeStandard:OwnerGUID -
	DC18DEB1-35C6-44AA-80E2-E9EC8ABB52E3
dsAttrTypeStandard:AppleMetaRecordName -
	cn=accounting,cn=groups,dc=mavericks,dc=pretendco,dc=com
dsAttrTypeStandard:AppleMetaNodeLocation -
	LDAPv3/127.0.0.1<
dsAttrTypeStandard:RecordType -
	dsRecTypeStandard:Groups
dsAttrTypeStandard:GroupMembers -
	40013EA2-8EC9-46AE-9C50-440B26D67E53
	44781E25-B92D-48FF-AFB7-34254D3FBC34
	288217B9-EA79-40D7-ACAF-AA24D4F1FA62
dsAttrTypeStandard:PrimaryGroupID -
	1029
dsAttrTypeStandard:RealName -
	Accounting
dsAttrTypeStandard:RecordName -
	accounting
```

Another useful command if you just want to check to see if a particular user is a member of a particular group, you can enter the following:

```
dseditgroup -o checkmember -m <usershortname> <groupshortname>
```

For example, if I want to check to see if Oscar Martinez is a member of Accounting, I can enter this:

```
dseditgroup -o checkmember -m omartinez accounting
```

You should get the response below:

```
yes omartinez is a member of accounting
```

Or if if the user isn't a member of the group, you'll get the following response:

```
no jhalpert is NOT a member of accounting
```

Finally, another way of looking up groups via the command line is by using `dscl`, or the **D**irectory **S**ervice **c**ommand **l**ine utility.  To get a list of all the groups in the local Open Directory domain, you would use the command below:

```
dscl /LDAPv3/127.0.0.1/ -list /Groups
```

This give you the shortname of each group:

```
accounting
admin
administration
com.apple.limited_admin
management
sales
staff
workgroup
```

If you prefer to get a little bit more information, you can also request a specific value like `GeneratedUID`, `RealName`, `AppleMetaRecordName` or `Member`.  If I wanted to get a list of the shortnames of members for each group I could enter something like below:

```
dscl /LDAPv3/127.0.0.1 -list /Groups Member
```

Which will in turn show me all the groups and their members (as requested):

```
accounting		aschrute kmalone omartinez
admin 			masterdiradmin mscott
administration	omartinez cbratton mpalmer kmalone dphilbin ehannon aschrute tflenderson kkapoor
management 		mscott phalpert
sales 			abernard jhalpert dschrute shudson phalpert rhoward plapinvance
staff 			root
workgroup 		jhalpert mscott phalpert dschrute rhoward abernard aschrute kkapoor omartinez dphilbin ehannon tflenderson kmalone plapinvance shudson mpalmer cbratton ictadmin
```