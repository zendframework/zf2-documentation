.. _zend.gdata.gapps:

Google Apps Provisioning の使用法
=============================

Google Apps はドメイン管理者向けのサービスで、Google の提供する
メールやカレンダー、Docs & Spreadsheets などをユーザに使用させることができます。
Provisioning *API* は、
これらのサービスをプログラム上から設定するためのインターフェイスです。
特に、この *API* を使用すると
ユーザアカウントやニックネーム、グループ、メーリングリストなどの追加、取得、
更新、削除ができるようになります。

このライブラリは Provisioning *API* バージョン 2.0 を実装しています。 Provisioning *API*
であなたのアカウントにアクセスできるようにするには、 Google Apps
コントロールパネル上で手動で有効にする必要があります。
この機能を利用できるのは、特定の種別のアカウントだけに限られます。

Google Apps Provisioning *API* の使用法や *API*
にアクセスできるようにするための方法については `Provisioning API V2.0 Reference`_
を参照ください。

.. note::

   **認証**

   Provisioning *API* は AuthSub による認証をサポートしておらず、
   匿名でのアクセスはできません。すべての *HTTP* 接続は ClientAuth
   で認証を済ませている必要があります。

.. _zend.gdata.gapps.domain:

現在のドメインの設定
----------

Provisioning *API* を使用するには、 すべてのリクエスト URI
で対象のドメインを指定する必要があります。 開発を楽に進めるために、この情報は
Gapps サービスクラスとクエリクラスの両方で保持するようにしています。

.. _zend.gdata.gapps.domain.service:

サービスクラスへのドメインの設定
^^^^^^^^^^^^^^^^

リクエスト対象のドメインをサービスクラスに設定するには、 ``setDomain()``
をコールするか、 あるいはサービスクラスのインスタンスの作成時に指定します。
たとえば次のようになります。

.. code-block:: php
   :linenos:

   $domain = "example.com";
   $gdata = new Zend_Gdata_Gapps($client, $domain);

.. _zend.gdata.gapps.domain.query:

クエリクラスへのドメインの設定
^^^^^^^^^^^^^^^

リクエスト対象のドメインをクエリクラスに設定する方法は、
サービスクラスの場合と同じです。 ``setDomain()`` をコールするか、
あるいはクエリの作成時に指定します。 たとえば次のようになります。

.. code-block:: php
   :linenos:

   $domain = "example.com";
   $query = new Zend_Gdata_Gapps_UserQuery($domain, $arg);

サービスクラスのファクトリメソッドでクエリを作成する際は、
サービスクラスが自動的にクエリクラスのドメインを設定します。
したがってこの場合は、
コンストラクタの引数でドメインを指定する必要がなくなります。

.. code-block:: php
   :linenos:

   $domain = "example.com";
   $gdata = new Zend_Gdata_Gapps($client, $domain);
   $query = $gdata->newUserQuery($arg);

.. _zend.gdata.gapps.users:

ユーザの操作
------

Google Apps がホストするドメイン上のユーザアカウントは、 ``Zend_Gdata_Gapps_UserEntry``
のインスタンスで表されます。 このクラスを使用すると、
アカウント名やユーザ名、パスワード、アクセス権限、
そして容量制限などすべての情報にアクセスできるようになります。

.. _zend.gdata.gapps.users.creating:

ユーザアカウントの作成
^^^^^^^^^^^

ユーザアカウントを作成するには、 ``createUser()`` メソッドを使用します。

.. code-block:: php
   :linenos:

   $gdata->createUser('foo', 'Random', 'User', '••••••••');

あるいは UserEntry のインスタンスから作成することもできます。
作成したインスタンスに対してユーザ名や姓、名、パスワードを設定し、
サービスオブジェクトの ``insertUser()``
をコールすることでそのエントリをサーバにアップロードします。

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

ユーザのパスワードは、通常はプレーンテキストで指定しなければなりません。
``login->passwordHashFunction`` を 'SHA-1' に設定した場合は、パスワードを SHA-1
ダイジェスト形式で指定することもできます。

.. _zend.gdata.gapps.users.retrieving:

ユーザアカウントの取得
^^^^^^^^^^^

各ユーザアカウントを取得するには ``retrieveUser()`` メソッドをコールします。
ユーザが見つからない場合は ``NULL`` が返されます。

.. code-block:: php
   :linenos:

   $user = $gdata->retrieveUser('foo');

   echo 'ユーザ名: ' . $user->login->userName . "\n";
   echo '名前: ' . $user->name->givenName . "\n";
   echo '苗字: ' . $user->name->familyName . "\n";
   echo '凍結中？: ' . ($user->login->suspended ? 'Yes' : 'No') . "\n";
   echo '管理者？: ' . ($user->login->admin ? 'Yes' : 'No') . "\n"
   echo 'パスワードの変更が必要？: ' .
        ($user->login->changePasswordAtNextLogin ? 'Yes' : 'No') . "\n";
   echo '規約に同意した？: ' .
        ($user->login->agreedToTerms ? 'Yes' : 'No') . "\n";

もうひとつの方法は、まず ``Zend_Gdata_Gapps_UserQuery`` のインスタンスを作成して username
プロパティを (取得したいユーザのユーザ名に) 設定し、サービスオブジェクトの
``getUserEntry()`` をコールするものです。

.. code-block:: php
   :linenos:

   $query = $gdata->newUserQuery('foo');
   $user = $gdata->getUserEntry($query);

   echo 'ユーザ名: ' . $user->login->userName . "\n";
   echo '名前: ' . $user->login->givenName . "\n";
   echo '苗字: ' . $user->login->familyName . "\n";
   echo '凍結中？: ' . ($user->login->suspended ? 'Yes' : 'No') . "\n";
   echo '管理者？: ' . ($user->login->admin ? 'Yes' : 'No') . "\n"
   echo 'パスワードの変更が必要？: ' .
        ($user->login->changePasswordAtNextLogin ? 'Yes' : 'No') . "\n";
   echo '規約に同意した？: ' .
        ($user->login->agreedToTerms ? 'Yes' : 'No') . "\n";

指定したユーザが発見できない場合は ServiceException がスローされ、エラーコード
``Zend_Gdata_Gapps_Error::ENTITY_DOES_NOT_EXIST`` を返します。ServiceExceptions については :ref:`
<zend.gdata.gapps.exceptions>` を参照ください。

.. _zend.gdata.gapps.users.retrievingAll:

ドメイン内のすべてのユーザの取得
^^^^^^^^^^^^^^^^

ドメイン内のすべてのユーザを取得するには、 ``retrieveAllUsers()``
メソッドをコールします。

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveAllUsers();

   foreach ($feed as $user) {
       echo "  * " . $user->login->username . ' (' . $user->name->givenName .
           ' ' . $user->name->familyName . ")\n";
   }

これは ``Zend_Gdata_Gapps_UserFeed`` オブジェクトを作成します。
このオブジェクトは、ドメイン上の各ユーザの情報を保持しています。

あるいは、何もオプションを指定せずに ``getUserFeed()`` をコールする方法もあります。
大きなドメインでは、このフィードが
サーバ側で複数ページに分割される可能性があることに注意しましょう。
ページ分割についての詳細は :ref:` <zend.gdata.introduction.paging>` を参照ください。

.. code-block:: php
   :linenos:

   $feed = $gdata->getUserFeed();

   foreach ($feed as $user) {
       echo "  * " . $user->login->username . ' (' . $user->name->givenName .
           ' ' . $user->name->familyName . ")\n";
   }


.. _zend.gdata.gapps.users.updating:

ユーザアカウントの更新
^^^^^^^^^^^

ユーザアカウントを更新するいちばん簡単な方法は、
まず先ほどの方法でユーザを取得し、 必要な箇所を変更し、最後にそのユーザの
``save()`` をコールするというものです。
これにより、変更内容がサーバに反映されます。

.. code-block:: php
   :linenos:

   $user = $gdata->retrieveUser('foo');
   $user->name->givenName = 'Foo';
   $user->name->familyName = 'Bar';
   $user = $user->save();

.. _zend.gdata.gapps.users.updating.resettingPassword:

ユーザのパスワードのリセット
^^^^^^^^^^^^^^

ユーザのパスワードをリセットして新しい値を設定するには、 ``login->password``
プロパティを変更します。

.. code-block:: php
   :linenos:

   $user = $gdata->retrieveUser('foo');
   $user->login->password = '••••••••';
   $user = $user->save();

現在のパスワードをこの方式で取得することはできません。
セキュリティ上の理由により、Provisioning *API*
では現在のパスワードを取得できないようになっているからです。

.. _zend.gdata.gapps.users.updating.forcingPasswordChange:

ユーザに強制的にパスワードを変更させる
^^^^^^^^^^^^^^^^^^^

次にログインしたときに強制的にパスワードを変更させるようにするには、
``login->changePasswordAtNextLogin`` を ``TRUE`` に設定します。

.. code-block:: php
   :linenos:

   $user = $gdata->retrieveUser('foo');
   $user->login->changePasswordAtNextLogin = true;
   $user = $user->save();

同様に、強制しないようにするなら ``login->changePasswordAtNextLogin`` を ``FALSE``
に設定します。

.. _zend.gdata.gapps.users.updating.suspendingAccount:

ユーザアカウントの凍結
^^^^^^^^^^^

ユーザのログインを制限したいがアカウント自体は残しておきたいという場合は、
そのアカウントを **凍結**\ します。
アカウントを凍結したり凍結を解除したりするには ``suspendUser()`` メソッドおよび
``restoreUser()`` メソッドを使用します。

.. code-block:: php
   :linenos:

   $gdata->suspendUser('foo');
   $gdata->restoreUser('foo');

あるいは、UserEntry のプロパティ ``login->suspended`` を ``TRUE`` に設定します。

.. code-block:: php
   :linenos:

   $user = $gdata->retrieveUser('foo');
   $user->login->suspended = true;
   $user = $user->save();

アクセス制限を解除するには、同様に ``login->suspended`` を ``FALSE`` に設定します。

.. _zend.gdata.gapps.users.updating.grantingAdminRights:

管理者権限の付与
^^^^^^^^

ユーザに対してドメインの管理者権限を付与するには、プロパティ ``login->admin`` を
``TRUE`` に設定します。

.. code-block:: php
   :linenos:

   $user = $gdata->retrieveUser('foo');
   $user->login->admin = true;
   $user = $user->save();

だいたい予想はつくでしょうが、 ``login->admin`` プロパティを ``FALSE``
に設定すれば管理者権限を剥奪できます。

.. _zend.gdata.gapps.users.deleting:

ユーザアカウントの削除
^^^^^^^^^^^

ユーザアカウントを削除するには、単純に UserEntry の ``delete()``
をコールするだけです。

.. code-block:: php
   :linenos:

   $user = $gdata->retrieveUser('foo');
   $user->delete();

そのアカウントの UserEntry オブジェクトが手元にないのなら、 ``deleteUser()``
メソッドを使用します。

.. code-block:: php
   :linenos:

   $gdata->deleteUser('foo');

.. _zend.gdata.gapps.nicknames:

ニックネームの操作
---------

ニックネームは、既存のユーザのメールアドレスのエイリアスとなります。
ニックネームには、name と owner のふたつのプロパティがあります。
あるニックネームあてに送信されたメールは、
そのニックネームの持ち主であるユーザに転送されます。

ニックネームは ``Zend_Gdata_Gapps_NicknameEntry`` のインスタンスで表されます。

.. _zend.gdata.gapps.nicknames.creating:

ニックネームの作成
^^^^^^^^^

ニックネームを作成するには ``createNickname()`` メソッドをコールします。

.. code-block:: php
   :linenos:

   $gdata->createNickname('foo', 'bar');

あるいは NicknameEntry のインスタンスから作成することもできます。
作成したインスタンスに対して名前と所有者を設定し、 サービスオブジェクトの
``insertNickname()`` をコールすることでそのエントリをサーバにアップロードします。

.. code-block:: php
   :linenos:

   $nickname = $gdata->newNicknameEntry();
   $nickname->login = $gdata->newLogin('foo');
   $nickname->nickname = $gdata->newNickname('bar');
   $nickname = $gdata->insertNickname($nickname);

.. _zend.gdata.gapps.nicknames.retrieving:

ニックネームの取得
^^^^^^^^^

ニックネームを取得するには ``retrieveNickname()`` メソッドをコールします。
ユーザが見つからない場合は ``NULL`` が返されます。

.. code-block:: php
   :linenos:

   $nickname = $gdata->retrieveNickname('bar');

   echo 'ニックネーム: ' . $nickname->nickname->name . "\n";
   echo '所有者: ' . $nickname->login->username . "\n";

もうひとつの方法は、まず ``Zend_Gdata_Gapps_NicknameQuery`` のインスタンスを作成して
nickname プロパティを (取得したいニックネームに) 設定し、サービスオブジェクトの
``getNicknameEntry()`` をコールするものです。

.. code-block:: php
   :linenos:

   $query = $gdata->newNicknameQuery('bar');
   $nickname = $gdata->getNicknameEntry($query);

   echo 'ニックネーム: ' . $nickname->nickname->name . "\n";
   echo '所有者: ' . $nickname->login->username . "\n";

ユーザの場合と同様、指定したニックネームが発見できない場合は ServiceException
がスローされ、エラーコード ``Zend_Gdata_Gapps_Error::ENTITY_DOES_NOT_EXIST``
を返します。ServiceExceptions については :ref:` <zend.gdata.gapps.exceptions>` を参照ください。

.. _zend.gdata.gapps.nicknames.retrievingUser:

あるユーザのすべてのニックネームの取得
^^^^^^^^^^^^^^^^^^^

指定したユーザのすべてのニックネームを取得するには、 ``retrieveNicknames()``
メソッドをコールします。

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveNicknames('foo');

   foreach ($feed as $nickname) {
       echo '  * ' . $nickname->nickname->name . "\n";
   }

これは ``Zend_Gdata_Gapps_NicknameFeed`` オブジェクトを作成します。
このオブジェクトは、指定したユーザのニックネームに関する情報を保持します。

あるいは、新しい ``Zend_Gdata_Gapps_NicknameQuery`` を作成して username
プロパティをそのユーザに設定し、 サービスオブジェクトの ``getNicknameFeed()``
をコールすることもできます。

.. code-block:: php
   :linenos:

   $query = $gdata->newNicknameQuery();
   $query->setUsername('foo');
   $feed = $gdata->getNicknameFeed($query);

   foreach ($feed as $nickname) {
       echo '  * ' . $nickname->nickname->name . "\n";
   }

.. _zend.gdata.gapps.nicknames.retrievingAll:

ドメイン内のすべてのニックネームの取得
^^^^^^^^^^^^^^^^^^^

フィード内のすべてのニックネームを取得するには、 ``retrieveAllNicknames()``
メソッドをコールします。

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveAllNicknames();

   foreach ($feed as $nickname) {
       echo '  * ' . $nickname->nickname->name . ' => ' .
           $nickname->login->username . "\n";
   }

これは ``Zend_Gdata_Gapps_NicknameFeed`` オブジェクトを作成します。
このオブジェクトは、ドメイン上の各ニックネームの情報を保持しています。

あるいは、サービスオブジェクトの ``getNicknameFeed()``
を引数なしでコールする方法もあります。

.. code-block:: php
   :linenos:

   $feed = $gdata->getNicknameFeed();

   foreach ($feed as $nickname) {
       echo '  * ' . $nickname->nickname->name . ' => ' .
           $nickname->login->username . "\n";
   }

.. _zend.gdata.gapps.nicknames.deleting:

ニックネームの削除
^^^^^^^^^

ニックネームを削除するには、単純に NicknameEntry の ``delete()``
をコールするだけです。

.. code-block:: php
   :linenos:

   $nickname = $gdata->retrieveNickname('bar');
   $nickname->delete();

そのニックネームの NicknameEntry オブジェクトが手元にないのなら、 ``deleteNickname()``
メソッドを使用します。

.. code-block:: php
   :linenos:

   $gdata->deleteNickname('bar');

.. _zend.gdata.gapps.groups:

Interacting with groups
-----------------------

Google Groups allows people to post messages like an email list. Google is depreciating the Email List API. Google
Groups provides some neat features like nested groups and group owners. If you want to start a new email lst, it is
advisable to use Google Groups instead. Google's Email List is not compatible with Google Groups. So if you create
an email list, it will not show up as a group. The opposite is true as well.

Each group on a domain is represented as an instance of ``Zend_Gdata_Gapps_GroupEntry``.

.. _zend.gdata.gapps.groups.creating:

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

.. _zend.gdata.gapps.groups.retrieveGroup:

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

This will create a ``Zend_Gdata_Gapps_GroupEntry`` object which holds the properties about the group.

Alternatively, create a new ``Zend_Gdata_Gapps_GroupQuery``, set its groupId property to the desired group id, and
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

.. _zend.gdata.gapps.groups.retrievingAll:

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

This will create a ``Zend_Gdata_Gapps_GroupFeed`` object which holds each group on the domain.

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

.. _zend.gdata.gapps.groups.deleting:

Deleting a group
^^^^^^^^^^^^^^^^

To delete a group, call the deleteGroup() convenience method:

.. code-block:: php
   :linenos:

   $gdata->deleteGroup('friends');

.. _zend.gdata.gapps.groups.updating:

Updating a group
^^^^^^^^^^^^^^^^

Groups can be updated by calling the ``updateGroup()`` convenience method:

.. code-block:: php
   :linenos:

   $gdata->updateGroup('group-id-here', 'Group Name Here');

The first parameter is required. The second, third and fourth parameter, representing the group name, group
descscription, and email permission, respectively are optional. Setting any of these optional parameters to null
will not update that item.

.. _zend.gdata.gapps.groups.retrieve:

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

This will create a ``Zend_Gdata_Gapps_GroupFeed`` object which holds each group associated with the specified
member.

Alternatively, create a new ``Zend_Gdata_Gapps_GroupQuery``, set its member property to the desired email address,
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

.. _zend.gdata.gapps.groupMembers:

Interacting with group members
------------------------------

Each member subscribed to a group is represented by an instance of ``Zend_Gdata_Gapps_MemberEntry``. Through this
class, individual recipients can be added and removed from groups.

.. _zend.gdata.gapps.groupMembers.adding:

Adding a member to a group
^^^^^^^^^^^^^^^^^^^^^^^^^^

To add a member to a group, simply call the ``addMemberToGroup()`` convenience method:

.. code-block:: php
   :linenos:

   $gdata->addMemberToGroup('bar@somewhere.com', 'friends');

.. _zend.gdata.gapps.groupMembers.check:

Check to see if member belongs to group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To check to see if member belongs to group, simply call the ``isMember()`` convenience method:

.. code-block:: php
   :linenos:

   $isMember = $gdata->isMember('bar@somewhere.com', 'friends');
   var_dump($isMember);

The method returns a boolean value. If the member belongs to the group specified, the method returns true, else it
returns false.

.. _zend.gdata.gapps.groupMembers.removing:

Removing a member from a group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To remove a member from a group, call the ``removeMemberFromGroup()`` convenience method:

.. code-block:: php
   :linenos:

   $gdata->removeMemberFromGroup('baz', 'friends');

.. _zend.gdata.gapps.groupMembers.retrieving:

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

This will create a ``Zend_Gdata_Gapps_MemberFeed`` object which holds each member for the selected group.

.. _zend.gdata.gapps.groupOwners:

Interacting with group owners
-----------------------------

Each owner associated with a group is represented by an instance of ``Zend_Gdata_Gapps_OwnerEntry``. Through this
class, individual owners can be added and removed from groups.

.. _zend.gdata.gapps.groupOwners.adding:

Adding an owner to a group
^^^^^^^^^^^^^^^^^^^^^^^^^^

To add an owner to a group, simply call the ``addOwnerToGroup()`` convenience method:

.. code-block:: php
   :linenos:

   $gdata->addOwnerToGroup('bar@somewhere.com', 'friends');

.. _zend.gdata.gapps.groupOwners.retrieving:

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

This will create a ``Zend_Gdata_Gapps_OwnerFeed`` object which holds each member for the selected group.

.. _zend.gdata.gapps.groupOwners.check:

Check to see if an email is the owner of a group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To check to see if an email is the owner of a group, simply call the ``isOwner()`` convenience method:

.. code-block:: php
   :linenos:

   $isOwner = $gdata->isOwner('bar@somewhere.com', 'friends');
   var_dump($isOwner);

The method returns a boolean value. If the email is the owner of the group specified, the method returns true, else
it returns false.

.. _zend.gdata.gapps.groupOwners.removing:

Removing an owner from a group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To remove an owner from a group, call the ``removeOwnerFromGroup()`` convenience method:

.. code-block:: php
   :linenos:

   $gdata->removeOwnerFromGroup('baz@somewhere.com', 'friends');

.. _zend.gdata.gapps.emailLists:

メーリングリストの操作
-----------

メーリングリストは、複数のユーザのメールアドレスを
ひとつのメールアドレスに対応させるものです。
このドメインのメンバー以外であっても、 メーリングリストに参加できます。

ドメイン上のメーリングリストの情報は、 ``Zend_Gdata_Gapps_EmailListEntry``
のインスタンスとして表されます。

.. _zend.gdata.gapps.emailLists.creating:

メーリングリストの作成
^^^^^^^^^^^

メーリングリストを作成するには ``createEmailList()`` メソッドを使用します。

.. code-block:: php
   :linenos:

   $gdata->createEmailList('friends');

あるいは EmailListEntry のインスタンスから作成することもできます。
作成したインスタンスに対してメーリングリストの名前を設定し、
サービスオブジェクトの ``insertEmailList()``
をコールすることでそのエントリをサーバにアップロードします。

.. code-block:: php
   :linenos:

   $list = $gdata->newEmailListEntry();
   $list->emailList = $gdata->newEmailList('friends');
   $list = $gdata->insertEmailList($list);

.. _zend.gdata.gapps.emailList.retrieve:

あるアカウントが購読しているすべてのメーリングリストの取得
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

特定の参加者が購読しているすべてのメーリングリストを取得するには
``retrieveEmailLists()`` メソッドをコールします。

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveEmailLists('baz@somewhere.com');

   foreach ($feed as $list) {
       echo '  * ' . $list->emailList->name . "\n";
   }

これは ``Zend_Gdata_Gapps_EmailListFeed`` オブジェクトを作成します。
このオブジェクトは、指定した参加者に関連するメーリングリストの情報を保持します。

あるいは、新しい ``Zend_Gdata_Gapps_EmailListQuery`` を作成して recipient
プロパティをそのメールアドレスに設定し、 サービスオブジェクトの
``getEmailListFeed()`` をコールすることもできます。

.. code-block:: php
   :linenos:

   $query = $gdata->newEmailListQuery();
   $query->setRecipient('baz@somewhere.com');
   $feed = $gdata->getEmailListFeed($query);

   foreach ($feed as $list) {
       echo '  * ' . $list->emailList->name . "\n";
   }

.. _zend.gdata.gapps.emailLists.retrievingAll:

ドメイン内のすべてのメーリングリストの取得
^^^^^^^^^^^^^^^^^^^^^

ドメイン内のすべてのメーリングリストを取得するには ``retrieveAllEmailLists()``
メソッドをコールします。

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveAllEmailLists();

   foreach ($feed as $list) {
       echo '  * ' . $list->emailList->name . "\n";
   }

これは ``Zend_Gdata_Gapps_EmailListFeed`` オブジェクトを作成します。
このオブジェクトは、ドメイン上の各メーリングリストに関する情報を保持します。

あるいは、サービスオブジェクトの ``getEmailListFeed()``
を引数なしでコールする方法もあります。

.. code-block:: php
   :linenos:

   $feed = $gdata->getEmailListFeed();

   foreach ($feed as $list) {
       echo '  * ' . $list->emailList->name . "\n";
   }

.. _zend.gdata.gapps.emailList.deleting:

メーリングリストの削除
^^^^^^^^^^^

メーリングリストを削除するには deleteEmailList() メソッドをコールします。

.. code-block:: php
   :linenos:

   $gdata->deleteEmailList('friends');

.. _zend.gdata.gapps.emailListRecipients:

メーリングリストの参加者の操作
---------------

メーリングリストの各参加者は、 ``Zend_Gdata_Gapps_EmailListRecipient``
のインスタンスとして表されます。
このクラスを使用すると、メーリングリストにメンバーを追加したり、
そこからメンバーを削除したりできます。

.. _zend.gdata.gapps.emailListRecipients.adding:

メーリングリストへの参加者の追加
^^^^^^^^^^^^^^^^

メーリングリストにメンバーを追加するには ``addRecipientToEmailList()``
メソッドをコールします。

.. code-block:: php
   :linenos:

   $gdata->addRecipientToEmailList('bar@somewhere.com', 'friends');

.. _zend.gdata.gapps.emailListRecipients.retrieving:

メーリングリストの参加者一覧の取得
^^^^^^^^^^^^^^^^^

``retrieveAllRecipients()``
メソッドを使用すると、メーリングリストの参加者一覧を取得できます。

.. code-block:: php
   :linenos:

   $feed = $gdata->retrieveAllRecipients('friends');

   foreach ($feed as $recipient) {
       echo '  * ' . $recipient->who->email . "\n";
   }

あるいは、新しい EmailListRecipientQuery を作成して emailListName
プロパティをそのメーリングリストに設定し、 サービスオブジェクトの
``getEmailListRecipientFeed()`` をコールすることもできます。

.. code-block:: php
   :linenos:

   $query = $gdata->newEmailListRecipientQuery();
   $query->setEmailListName('friends');
   $feed = $gdata->getEmailListRecipientFeed($query);

   foreach ($feed as $recipient) {
       echo '  * ' . $recipient->who->email . "\n";
   }

これは ``Zend_Gdata_Gapps_EmailListRecipientFeed`` オブジェクトを作成します。
このオブジェクトは、指定したメーリングリストの各参加者に関する情報を保持します。

.. _zend.gdata.gapps.emailListRecipients.removing:

ある参加者のメーリングリストからの削除
^^^^^^^^^^^^^^^^^^^

メーリングリストからメンバーを削除するには ``removeRecipientFromEmailList()``
メソッドをコールします。

.. code-block:: php
   :linenos:

   $gdata->removeRecipientFromEmailList('baz@somewhere.com', 'friends');

.. _zend.gdata.gapps.exceptions:

エラー処理
-----

``Zend_Gdata`` が標準でスローする例外に加えて、 Provisioning *API* によるリクエストでは
``Zend_Gdata_Gapps_ServiceException`` がスローされる可能性があります。これらの例外は、
*API* 固有のエラーが原因でリクエストが失敗したことを表します。

ServiceException のインスタンスには、 ひとつあるいは複数の Error
オブジェクトが含まれます。
これらのオブジェクトにはエラーコードとエラーの原因、そして (オプションで)
その例外を引き起こした入力が含まれます。 エラーコードの完全な一覧は、Zend
Framework *API* ドキュメントで ``Zend_Gdata_Gapps_Error`` の部分を参照ください。
さらに、正式なエラーの一覧は `Google Apps Provisioning API V2.0 Reference: Appendix D`_
で見ることができます。

ServiceException に含まれるすべてのエラーの一覧は ``getErrors()``
で配列として取得できますが、
特定のエラーが発生したのかどうかだけを知りたいこともあります。
そのような場合には ``hasError()`` をコールします。

以下の例は、 リクエストしたリソースが存在しなかった場合を検出し、
適切に処理するものです。

.. code-block:: php
   :linenos:

   function retrieveUser ($username) {
       $query = $gdata->newUserQuery($username);
       try {
           $user = $gdata->getUserEntry($query);
       } catch (Zend_Gdata_Gapps_ServiceException $e) {
           // ユーザが見つからなかった場合は null を設定します
           if ($e->hasError(Zend_Gdata_Gapps_Error::ENTITY_DOES_NOT_EXIST)) {
               $user = null;
           } else {
               throw $e;
           }
       }
       return $user;
   }



.. _`Provisioning API V2.0 Reference`: http://code.google.com/apis/apps/gdata_provisioning_api_v2.0_reference.html
.. _`Google Apps Provisioning API V2.0 Reference: Appendix D`: http://code.google.com/apis/apps/gdata_provisioning_api_v2.0_reference.html#appendix_d
