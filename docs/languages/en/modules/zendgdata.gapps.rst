.. _zendgdata.gapps:

Using Google Apps Provisioning
==============================

Google Apps is a service which allows domain administrators to offer their users managed access to Google services
such as Mail, Calendar, and Docs & Spreadsheets. The Provisioning *API* offers a programmatic interface to
configure this service. Specifically, this *API* allows administrators the ability to create, retrieve, update, and
delete user accounts, nicknames, groups, and email lists.

This library implements version 2.0 of the Provisioning *API*. Access to your account via the Provisioning *API*
must be manually enabled for each domain using the Google Apps control panel. Only certain account types are able
to enable this feature.

For more information on the Google Apps Provisioning *API*, including instructions for enabling *API* access, refer
to the `Provisioning API V2.0 Reference`_.

.. note::

   **Authentication**

   The Provisioning *API* does not support authentication via AuthSub and anonymous access is not permitted. All
   *HTTP* connections must be authenticated using ClientAuth authentication.

.. _zendgdata.gapps.domain:

Setting the current domain
--------------------------

In order to use the Provisioning *API*, the domain being administered needs to be specified in all request *URI*\
s. In order to ease development, this information is stored within both the Gapps service and query classes to use
when constructing requests.

.. _zendgdata.gapps.domain.service:

Setting the domain for the service class
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To set the domain for requests made by the service class, either call ``setDomain()`` or specify the domain when
instantiating the service class. For example:

.. code-block:: php
   :linenos:

   $domain = "example.com";
   $gdata = new ZendGData\Gapps($client, $domain);

.. _zendgdata.gapps.domain.query:

Setting the domain for query classes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Setting the domain for requests made by query classes is similar to setting it for the service class-either call
``setDomain()`` or specify the domain when creating the query. For example:

.. code-block:: php
   :linenos:

   $domain = "example.com";
   $query = new ZendGData\Gapps\UserQuery($domain, $arg);

When using a service class factory method to create a query, the service class will automatically set the query's
domain to match its own domain. As a result, it is not necessary to specify the domain as part of the constructor
arguments.

.. code-block:: php
   :linenos:

   $domain = "example.com";
   $gdata = new ZendGData\Gapps($client, $domain);
   $query = $gdata->newUserQuery($arg);

.. _zendgdata.gapps.users:

Interacting with users
----------------------

Each user account on a Google Apps hosted domain is represented as an instance of ``ZendGData\Gapps\UserEntry``.
This class provides access to all account properties including name, username, password, access rights, and current
quota.

.. _zendgdata.gapps.users.creating:

Creating a user account
^^^^^^^^^^^^^^^^^^^^^^^

User accounts can be created by calling the ``createUser()`` convenience method:

.. code-block:: php
   :linenos:

   $gdata->createUser('foo', 'Random', 'User', '••••••••');

Users can also be created by instantiating UserEntry, providing a username, given name, family name, and password,
then calling ``insertUser()`` on a service object to upload the entry to the server.

.. code-block:: php
   :linenos:

   $user = $gdata->newUserEntry();
   $user->login = $gdata->newLogin();
   $user->login->username = 'foo';
   $user->login->password = '••••••••';
   $user->name = $gdata->newName();
   $user->name->givenName = 'Random';
   $user->name->familyName = 'User';
   $user = $gdata->insertUser($user);

The user's password should normally be provided as cleartext. Optionally, the password can be provided as an
*SHA-1* digest if ``login->passwordHashFunction`` is set to '``SHA-1``'.

.. _zendgdata.gapps.users.retrieving:

Retrieving a user account
^^^^^^^^^^^^^^^^^^^^^^^^^

Individual user accounts can be retrieved by calling the ``retrieveUser()`` convenience method. If the user is not
found, ``NULL`` will be returned.

.. code-block:: php
   :linenos:

   $user = $gdata->retrieveUser('foo');

   echo 'Username: ' . $user->login->userName . "\n";
   echo 'Given Name: ' . $user->name->givenName . "\n";
   echo 'Family Name: ' . $user->name->familyName . "\n";
   echo 'Suspended: ' . ($user->login->suspended ? 'Yes' : 'No') . "\n";
   echo 'Admin: ' . ($user->login->admin ? 'Yes' : 'No') . "\n"
   echo 'Must Change Password: ' .
        ($user->login->changePasswordAtNextLogin ? 'Yes' : 'No') . "\n";
   echo 'Has Agreed To Terms: ' .
        ($user->login->agreedToTerms ? 'Yes' : 'No') . "\n";

Users can also be retrieved by creating an instance of ``ZendGData\Gapps\UserQuery``, setting its username
property to equal the username of the user that is to be retrieved, and calling ``getUserEntry()`` on a service
object with that query.

.. code-block:: php
   :linenos:

   $query = $gdata->newUserQuery('foo');
   $user = $gdata->getUserEntry($query);

   echo 'Username: ' . $user->login->userName . "\n";
   echo 'Given Name: ' . $user->login->givenName . "\n";
   echo 'Family Name: ' . $user->login->familyName . "\n";
   echo 'Suspended: ' . ($user->login->suspended ? 'Yes' : 'No') . "\n";
   echo 'Admin: ' . ($user->login->admin ? 'Yes' : 'No') . "\n"
   echo 'Must Change Password: ' .
        ($user->login->changePasswordAtNextLogin ? 'Yes' : 'No') . "\n";
   echo 'Has Agreed To Terms: ' .
        ($user->login->agreedToTerms ? 'Yes' : 'No') . "\n";

If the specified user cannot be located a ServiceException will be thrown with an error code of
``ZendGData\Gapps\Error::ENTITY_DOES_NOT_EXIST``. ServiceExceptions will be covered in :ref:`the exceptions
chapter <zendgdata.gapps.exceptions>`.

.. _zendgdata.gapps.users.retrievingAll:

Retrieving all users in a domain
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To retrieve all users in a domain, call the ``retrieveAllUsers()`` convenience method.

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveAllUsers();

   foreach ($feed as $user) {
       echo "  * " . $user->login->username . ' (' . $user->name->givenName .
           ' ' . $user->name->familyName . ")\n";
   }

This will create a ``ZendGData\Gapps\UserFeed`` object which holds each user on the domain.

Alternatively, call ``getUserFeed()`` with no options. Keep in mind that on larger domains this feed may be paged
by the server. For more information on paging, see :ref:`the paging chapter <zendgdata.introduction.paging>`.

.. code-block:: php
   :linenos:

   $feed = $gdata->getUserFeed();

   foreach ($feed as $user) {
       echo "  * " . $user->login->username . ' (' . $user->name->givenName .
           ' ' . $user->name->familyName . ")\n";
   }

.. _zendgdata.gapps.users.updating:

Updating a user account
^^^^^^^^^^^^^^^^^^^^^^^

The easiest way to update a user account is to retrieve the user as described in the previous sections, make any
desired changes, then call ``save()`` on that user. Any changes made will be propagated to the server.

.. code-block:: php
   :linenos:

   $user = $gdata->retrieveUser('foo');
   $user->name->givenName = 'Foo';
   $user->name->familyName = 'Bar';
   $user = $user->save();

.. _zendgdata.gapps.users.updating.resettingPassword:

Resetting a user's password
^^^^^^^^^^^^^^^^^^^^^^^^^^^

A user's password can be reset to a new value by updating the ``login->password`` property.

.. code-block:: php
   :linenos:

   $user = $gdata->retrieveUser('foo');
   $user->login->password = '••••••••';
   $user = $user->save();

Note that it is not possible to recover a password in this manner as stored passwords are not made available via
the Provisioning *API* for security reasons.

.. _zendgdata.gapps.users.updating.forcingPasswordChange:

Forcing a user to change their password
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A user can be forced to change their password at their next login by setting the
``login->changePasswordAtNextLogin`` property to ``TRUE``.

.. code-block:: php
   :linenos:

   $user = $gdata->retrieveUser('foo');
   $user->login->changePasswordAtNextLogin = true;
   $user = $user->save();

Similarly, this can be undone by setting the ``login->changePasswordAtNextLogin`` property to ``FALSE``.

.. _zendgdata.gapps.users.updating.suspendingAccount:

Suspending a user account
^^^^^^^^^^^^^^^^^^^^^^^^^

Users can be restricted from logging in without deleting their user account by instead **suspending** their user
account. Accounts can be suspended or restored by using the ``suspendUser()`` and ``restoreUser()`` convenience
methods:

.. code-block:: php
   :linenos:

   $gdata->suspendUser('foo');
   $gdata->restoreUser('foo');

Alternatively, you can set the UserEntry's ``login->suspended`` property to ``TRUE``.

.. code-block:: php
   :linenos:

   $user = $gdata->retrieveUser('foo');
   $user->login->suspended = true;
   $user = $user->save();

To restore the user's access, set the ``login->suspended`` property to ``FALSE``.

.. _zendgdata.gapps.users.updating.grantingAdminRights:

Granting administrative rights
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Users can be granted the ability to administer your domain by setting their ``login->admin`` property to ``TRUE``.

.. code-block:: php
   :linenos:

   $user = $gdata->retrieveUser('foo');
   $user->login->admin = true;
   $user = $user->save();

And as expected, setting a user's ``login->admin`` property to ``FALSE`` revokes their administrative rights.

.. _zendgdata.gapps.users.deleting:

Deleting user accounts
^^^^^^^^^^^^^^^^^^^^^^

Deleting a user account to which you already hold a UserEntry is a simple as calling ``delete()`` on that entry.

.. code-block:: php
   :linenos:

   $user = $gdata->retrieveUser('foo');
   $user->delete();

If you do not have access to a UserEntry object for an account, use the ``deleteUser()`` convenience method.

.. code-block:: php
   :linenos:

   $gdata->deleteUser('foo');

.. _zendgdata.gapps.nicknames:

Interacting with nicknames
--------------------------

Nicknames serve as email aliases for existing users. Each nickname contains precisely two key properties: its name
and its owner. Any email addressed to a nickname is forwarded to the user who owns that nickname.

Nicknames are represented as an instances of ``ZendGData\Gapps\NicknameEntry``.

.. _zendgdata.gapps.nicknames.creating:

Creating a nickname
^^^^^^^^^^^^^^^^^^^

Nicknames can be created by calling the ``createNickname()`` convenience method:

.. code-block:: php
   :linenos:

   $gdata->createNickname('foo', 'bar');

Nicknames can also be created by instantiating NicknameEntry, providing the nickname with a name and an owner, then
calling ``insertNickname()`` on a service object to upload the entry to the server.

.. code-block:: php
   :linenos:

   $nickname = $gdata->newNicknameEntry();
   $nickname->login = $gdata->newLogin('foo');
   $nickname->nickname = $gdata->newNickname('bar');
   $nickname = $gdata->insertNickname($nickname);

.. _zendgdata.gapps.nicknames.retrieving:

Retrieving a nickname
^^^^^^^^^^^^^^^^^^^^^

Nicknames can be retrieved by calling the ``retrieveNickname()`` convenience method. This will return ``NULL`` if a
user is not found.

.. code-block:: php
   :linenos:

   $nickname = $gdata->retrieveNickname('bar');

   echo 'Nickname: ' . $nickname->nickname->name . "\n";
   echo 'Owner: ' . $nickname->login->username . "\n";

Individual nicknames can also be retrieved by creating an instance of ``ZendGData\Gapps\NicknameQuery``, setting
its nickname property to equal the nickname that is to be retrieved, and calling ``getNicknameEntry()`` on a
service object with that query.

.. code-block:: php
   :linenos:

   $query = $gdata->newNicknameQuery('bar');
   $nickname = $gdata->getNicknameEntry($query);

   echo 'Nickname: ' . $nickname->nickname->name . "\n";
   echo 'Owner: ' . $nickname->login->username . "\n";

As with users, if no corresponding nickname is found a ServiceException will be thrown with an error code of
``ZendGData\Gapps\Error::ENTITY_DOES_NOT_EXIST``. Again, these will be discussed in :ref:`the exceptions chapter
<zendgdata.gapps.exceptions>`.

.. _zendgdata.gapps.nicknames.retrievingUser:

Retrieving all nicknames for a user
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To retrieve all nicknames associated with a given user, call the convenience method ``retrieveNicknames()``.

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveNicknames('foo');

   foreach ($feed as $nickname) {
       echo '  * ' . $nickname->nickname->name . "\n";
   }

This will create a ``ZendGData\Gapps\NicknameFeed`` object which holds each nickname associated with the specified
user.

Alternatively, create a new ``ZendGData\Gapps\NicknameQuery``, set its username property to the desired user, and
submit the query by calling ``getNicknameFeed()`` on a service object.

.. code-block:: php
   :linenos:

   $query = $gdata->newNicknameQuery();
   $query->setUsername('foo');
   $feed = $gdata->getNicknameFeed($query);

   foreach ($feed as $nickname) {
       echo '  * ' . $nickname->nickname->name . "\n";
   }

.. _zendgdata.gapps.nicknames.retrievingAll:

Retrieving all nicknames in a domain
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To retrieve all nicknames in a feed, simply call the convenience method ``retrieveAllNicknames()``

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveAllNicknames();

   foreach ($feed as $nickname) {
       echo '  * ' . $nickname->nickname->name . ' => ' .
           $nickname->login->username . "\n";
   }

This will create a ``ZendGData\Gapps\NicknameFeed`` object which holds each nickname on the domain.

Alternatively, call ``getNicknameFeed()`` on a service object with no arguments.

.. code-block:: php
   :linenos:

   $feed = $gdata->getNicknameFeed();

   foreach ($feed as $nickname) {
       echo '  * ' . $nickname->nickname->name . ' => ' .
           $nickname->login->username . "\n";
   }

.. _zendgdata.gapps.nicknames.deleting:

Deleting a nickname
^^^^^^^^^^^^^^^^^^^

Deleting a nickname to which you already hold a NicknameEntry for is a simple as calling ``delete()`` on that
entry.

.. code-block:: php
   :linenos:

   $nickname = $gdata->retrieveNickname('bar');
   $nickname->delete();

For nicknames which you do not hold a NicknameEntry for, use the ``deleteNickname()`` convenience method.

.. code-block:: php
   :linenos:

   $gdata->deleteNickname('bar');

.. _zendgdata.gapps.groups:

Interacting with groups
-----------------------

Google Groups allows people to post messages like an email list. Google is depreciating the Email List *API*.
Google Groups provides some neat features like nested groups and group owners. If you want to start a new email
lst, it is advisable to use Google Groups instead. Google's Email List is not compatible with Google Groups. So if
you create an email list, it will not show up as a group. The opposite is true as well.

Each group on a domain is represented as an instance of ``ZendGData\Gapps\GroupEntry``.

.. _zendgdata.gapps.groups.creating:

Creating a group
^^^^^^^^^^^^^^^^

Groups can be created by calling the ``createGroup()`` convenience method:

.. code-block:: php
   :linenos:

   $gdata->createGroup('friends', 'The Friends Group');

Groups can also be created by instantiating GroupEntry, providing a group id and name for the group, then calling
``insertGroup()`` on a service object to upload the entry to the server.

.. code-block:: php
   :linenos:

   $group = $gdata->newGroupEntry();

   $properties[0] = $this->newProperty();
   $properties[0]->name = 'groupId';
   $properties[0]->value = 'friends';
   $properties[1] = $this->newProperty();
   $properties[1]->name = 'groupName';
   $properties[1]->value = 'The Friends Group';

   $group->property = $properties;

   $group = $gdata->insertGroup($group);

.. _zendgdata.gapps.groups.retrieveGroup:

Retrieving an individual group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To retrieve an individual group, call the ``retrieveGroup()`` convenience method:

.. code-block:: php
   :linenos:

   $entry = $gdata->retrieveGroup('friends');

   foreach ($entry->property as $p) {
       echo "Property Name: " . $p->name;
       echo "\nProperty Value: " . $p->value . "\n\n";
   }

This will create a ``ZendGData\Gapps\GroupEntry`` object which holds the properties about the group.

Alternatively, create a new ``ZendGData\Gapps\GroupQuery``, set its groupId property to the desired group id, and
submit the query by calling ``getGroupEntry()`` on a service object.

.. code-block:: php
   :linenos:

   $query = $gdata->newGroupQuery();
   $query->setGroupId('friends');
   $entry = $gdata->getGroupEntry($query);

   foreach ($entry->property as $p) {
       echo "Property Name: " . $p->name;
       echo "\nProperty Value: " . $p->value . "\n\n";
   }

.. _zendgdata.gapps.groups.retrievingAll:

Retrieving all groups in a domain
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To retrieve all groups in a domain, call the convenience method ``retrieveAllGroups()``.

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveAllGroups();

   foreach ($feed->entry as $entry) {
       foreach ($entry->property as $p) {
           echo "Property Name: " . $p->name;
           echo "\nProperty Value: " . $p->value . "\n\n";
       }
       echo "\n\n";
   }

This will create a ``ZendGData\Gapps\GroupFeed`` object which holds each group on the domain.

Alternatively, call ``getGroupFeed()`` on a service object with no arguments.

.. code-block:: php
   :linenos:

   $feed = $gdata->getGroupFeed();

   foreach ($feed->entry as $entry) {
       foreach ($entry->property as $p) {
           echo "Property Name: " . $p->name;
           echo "\nProperty Value: " . $p->value . "\n\n";
       }
       echo "\n\n";
   }

.. _zendgdata.gapps.groups.deleting:

Deleting a group
^^^^^^^^^^^^^^^^

To delete a group, call the ``deleteGroup()`` convenience method:

.. code-block:: php
   :linenos:

   $gdata->deleteGroup('friends');

.. _zendgdata.gapps.groups.updating:

Updating a group
^^^^^^^^^^^^^^^^

Groups can be updated by calling the ``updateGroup()`` convenience method:

.. code-block:: php
   :linenos:

   $gdata->updateGroup('group-id-here', 'Group Name Here');

The first parameter is required. The second, third and fourth parameter, representing the group name, group
description, and email permission, respectively are optional. Setting any of these optional parameters to null
will not update that item.

.. _zendgdata.gapps.groups.retrieve:

Retrieving all groups to which a person is a member
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To retrieve all groups to which a particular person is a member, call the ``retrieveGroups()`` convenience method:

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveGroups('baz@somewhere.com');

   foreach ($feed->entry as $entry) {
       foreach ($entry->property as $p) {
           echo "Property Name: " . $p->name;
           echo "\nProperty Value: " . $p->value . "\n\n";
       }
       echo "\n\n";
   }

This will create a ``ZendGData\Gapps\GroupFeed`` object which holds each group associated with the specified
member.

Alternatively, create a new ``ZendGData\Gapps\GroupQuery``, set its member property to the desired email address,
and submit the query by calling ``getGroupFeed()`` on a service object.

.. code-block:: php
   :linenos:

   $query = $gdata->newGroupQuery();
   $query->setMember('baz@somewhere.com');
   $feed = $gdata->getGroupFeed($query);

   foreach ($feed->entry as $entry) {
       foreach ($entry->property as $p) {
           echo "Property Name: " . $p->name;
           echo "\nProperty Value: " . $p->value . "\n\n";
       }
       echo "\n\n";
   }

.. _zendgdata.gapps.groupMembers:

Interacting with group members
------------------------------

Each member subscribed to a group is represented by an instance of ``ZendGData\Gapps\MemberEntry``. Through this
class, individual recipients can be added and removed from groups.

.. _zendgdata.gapps.groupMembers.adding:

Adding a member to a group
^^^^^^^^^^^^^^^^^^^^^^^^^^

To add a member to a group, simply call the ``addMemberToGroup()`` convenience method:

.. code-block:: php
   :linenos:

   $gdata->addMemberToGroup('bar@somewhere.com', 'friends');

.. _zendgdata.gapps.groupMembers.check:

Check to see if member belongs to group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To check to see if member belongs to group, simply call the ``isMember()`` convenience method:

.. code-block:: php
   :linenos:

   $isMember = $gdata->isMember('bar@somewhere.com', 'friends');
   var_dump($isMember);

The method returns a boolean value. If the member belongs to the group specified, the method returns true, else it
returns false.

.. _zendgdata.gapps.groupMembers.removing:

Removing a member from a group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To remove a member from a group, call the ``removeMemberFromGroup()`` convenience method:

.. code-block:: php
   :linenos:

   $gdata->removeMemberFromGroup('baz', 'friends');

.. _zendgdata.gapps.groupMembers.retrieving:

Retrieving the list of members to a group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The convenience method ``retrieveAllMembers()`` can be used to retrieve the list of members of a group:

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveAllMembers('friends');

   foreach ($feed as $member) {
       foreach ($member->property as $p) {
           echo "Property Name: " . $p->name;
           echo "\nProperty Value: " . $p->value . "\n\n";
       }
   }

Alternatively, construct a new MemberQuery, set its groupId property to match the desired group id, and call
``getMemberFeed()`` on a service object.

.. code-block:: php
   :linenos:

   $query = $gdata->newMemberQuery();
   $query->setGroupId('friends');
   $feed = $gdata->getMemberFeed($query);

   foreach ($feed as $member) {
       foreach ($member->property as $p) {
           echo "Property Name: " . $p->name;
           echo "\nProperty Value: " . $p->value . "\n\n";
       }
   }

This will create a ``ZendGData\Gapps\MemberFeed`` object which holds each member for the selected group.

.. _zendgdata.gapps.groupOwners:

Interacting with group owners
-----------------------------

Each owner associated with a group is represented by an instance of ``ZendGData\Gapps\OwnerEntry``. Through this
class, individual owners can be added and removed from groups.

.. _zendgdata.gapps.groupOwners.adding:

Adding an owner to a group
^^^^^^^^^^^^^^^^^^^^^^^^^^

To add an owner to a group, simply call the ``addOwnerToGroup()`` convenience method:

.. code-block:: php
   :linenos:

   $gdata->addOwnerToGroup('bar@somewhere.com', 'friends');

.. _zendgdata.gapps.groupOwners.retrieving:

Retrieving the list of the owner of a group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The convenience method ``retrieveGroupOwners()`` can be used to retrieve the list of the owners of a group:

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveGroupOwners('friends');

   foreach ($feed as $owner) {
       foreach ($owner->property as $p) {
           echo "Property Name: " . $p->name;
           echo "\nProperty Value: " . $p->value . "\n\n";
       }
   }

Alternatively, construct a new OwnerQuery, set its groupId property to match the desired group id, and call
``getOwnerFeed()`` on a service object.

.. code-block:: php
   :linenos:

   $query = $gdata->newOwnerQuery();
   $query->setGroupId('friends');
   $feed = $gdata->getOwnerFeed($query);

   foreach ($feed as $owner) {
       foreach ($owner->property as $p) {
           echo "Property Name: " . $p->name;
           echo "\nProperty Value: " . $p->value . "\n\n";
       }
   }

This will create a ``ZendGData\Gapps\OwnerFeed`` object which holds each member for the selected group.

.. _zendgdata.gapps.groupOwners.check:

Check to see if an email is the owner of a group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To check to see if an email is the owner of a group, simply call the ``isOwner()`` convenience method:

.. code-block:: php
   :linenos:

   $isOwner = $gdata->isOwner('bar@somewhere.com', 'friends');
   var_dump($isOwner);

The method returns a boolean value. If the email is the owner of the group specified, the method returns true, else
it returns false.

.. _zendgdata.gapps.groupOwners.removing:

Removing an owner from a group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To remove an owner from a group, call the ``removeOwnerFromGroup()`` convenience method:

.. code-block:: php
   :linenos:

   $gdata->removeOwnerFromGroup('baz@somewhere.com', 'friends');

.. _zendgdata.gapps.emailLists:

Interacting with email lists
----------------------------

Email lists allow several users to retrieve email addressed to a single email address. Users do not need to be a
member of this domain in order to subscribe to an email list provided their complete email address (including
domain) is used.

Each email list on a domain is represented as an instance of ``ZendGData\Gapps\EmailListEntry``.

.. _zendgdata.gapps.emailLists.creating:

Creating an email list
^^^^^^^^^^^^^^^^^^^^^^

Email lists can be created by calling the ``createEmailList()`` convenience method:

.. code-block:: php
   :linenos:

   $gdata->createEmailList('friends');

Email lists can also be created by instantiating EmailListEntry, providing a name for the list, then calling
``insertEmailList()`` on a service object to upload the entry to the server.

.. code-block:: php
   :linenos:

   $list = $gdata->newEmailListEntry();
   $list->emailList = $gdata->newEmailList('friends');
   $list = $gdata->insertEmailList($list);

.. _zendgdata.gapps.emailList.retrieve:

Retrieving all email lists to which a recipient is subscribed
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To retrieve all email lists to which a particular recipient is subscribed, call the ``retrieveEmailLists()``
convenience method:

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveEmailLists('baz@somewhere.com');

   foreach ($feed as $list) {
       echo '  * ' . $list->emailList->name . "\n";
   }

This will create a ``ZendGData\Gapps\EmailListFeed`` object which holds each email list associated with the
specified recipient.

Alternatively, create a new ``ZendGData\Gapps\EmailListQuery``, set its recipient property to the desired email
address, and submit the query by calling ``getEmailListFeed()`` on a service object.

.. code-block:: php
   :linenos:

   $query = $gdata->newEmailListQuery();
   $query->setRecipient('baz@somewhere.com');
   $feed = $gdata->getEmailListFeed($query);

   foreach ($feed as $list) {
       echo '  * ' . $list->emailList->name . "\n";
   }

.. _zendgdata.gapps.emailLists.retrievingAll:

Retrieving all email lists in a domain
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To retrieve all email lists in a domain, call the convenience method ``retrieveAllEmailLists()``.

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveAllEmailLists();

   foreach ($feed as $list) {
       echo '  * ' . $list->emailList->name . "\n";
   }

This will create a ``ZendGData\Gapps\EmailListFeed`` object which holds each email list on the domain.

Alternatively, call ``getEmailListFeed()`` on a service object with no arguments.

.. code-block:: php
   :linenos:

   $feed = $gdata->getEmailListFeed();

   foreach ($feed as $list) {
       echo '  * ' . $list->emailList->name . "\n";
   }

.. _zendgdata.gapps.emailList.deleting:

Deleting an email list
^^^^^^^^^^^^^^^^^^^^^^

To delete an email list, call the ``deleteEmailList()`` convenience method:

.. code-block:: php
   :linenos:

   $gdata->deleteEmailList('friends');

.. _zendgdata.gapps.emailListRecipients:

Interacting with email list recipients
--------------------------------------

Each recipient subscribed to an email list is represented by an instance of
``ZendGData\Gapps\EmailListRecipient``. Through this class, individual recipients can be added and removed from
email lists.

.. _zendgdata.gapps.emailListRecipients.adding:

Adding a recipient to an email list
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To add a recipient to an email list, simply call the ``addRecipientToEmailList()`` convenience method:

.. code-block:: php
   :linenos:

   $gdata->addRecipientToEmailList('bar@somewhere.com', 'friends');

.. _zendgdata.gapps.emailListRecipients.retrieving:

Retrieving the list of subscribers to an email list
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The convenience method ``retrieveAllRecipients()`` can be used to retrieve the list of subscribers to an email
list:

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveAllRecipients('friends');

   foreach ($feed as $recipient) {
       echo '  * ' . $recipient->who->email . "\n";
   }

Alternatively, construct a new EmailListRecipientQuery, set its emailListName property to match the desired email
list, and call ``getEmailListRecipientFeed()`` on a service object.

.. code-block:: php
   :linenos:

   $query = $gdata->newEmailListRecipientQuery();
   $query->setEmailListName('friends');
   $feed = $gdata->getEmailListRecipientFeed($query);

   foreach ($feed as $recipient) {
       echo '  * ' . $recipient->who->email . "\n";
   }

This will create a ``ZendGData\Gapps\EmailListRecipientFeed`` object which holds each recipient for the selected
email list.

.. _zendgdata.gapps.emailListRecipients.removing:

Removing a recipient from an email list
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To remove a recipient from an email list, call the ``removeRecipientFromEmailList()`` convenience method:

.. code-block:: php
   :linenos:

   $gdata->removeRecipientFromEmailList('baz@somewhere.com', 'friends');

.. _zendgdata.gapps.exceptions:

Handling errors
---------------

In addition to the standard suite of exceptions thrown by ``ZendGData``, requests using the Provisioning *API* may
also throw a ``ZendGData\Gapps\ServiceException``. These exceptions indicate that a *API* specific error occurred
which prevents the request from completing.

Each ServiceException instance may hold one or more Error objects. Each of these objects contains an error code,
reason, and (optionally) the input which triggered the exception. A complete list of known error codes is provided
in Zend Framework's *API* documentation under ``ZendGData\Gapps\Error``. Additionally, the authoritative error
list is available online at `Google Apps Provisioning API V2.0 Reference: Appendix D`_.

While the complete list of errors received is available within ServiceException as an array by calling
``getErrors()``, often it is convenient to know if one specific error occurred. For these cases the presence of an
error can be determined by calling ``hasError()``.

The following example demonstrates how to detect if a requested resource doesn't exist and handle the fault
gracefully:

.. code-block:: php
   :linenos:

   function retrieveUser ($username) {
       $query = $gdata->newUserQuery($username);
       try {
           $user = $gdata->getUserEntry($query);
       } catch (ZendGData\Gapps\ServiceException $e) {
           // Set the user to null if not found
           if ($e->hasError(ZendGData\Gapps\Error::ENTITY_DOES_NOT_EXIST)) {
               $user = null;
           } else {
               throw $e;
           }
       }
       return $user;
   }



.. _`Provisioning API V2.0 Reference`: http://code.google.com/apis/apps/gdata_provisioning_api_v2.0_reference.html
.. _`Google Apps Provisioning API V2.0 Reference: Appendix D`: http://code.google.com/apis/apps/gdata_provisioning_api_v2.0_reference.html#appendix_d
