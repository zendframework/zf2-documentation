.. EN-Revision: none
.. _zend.ldap.server:

LDAPサーバから情報を取得
==============

.. _zend.ldap.server.rootdse:

ルートDSE
------

与えられた *LDAP*\ サーバのためのルートDSEに含まれる属性についての
詳細は以下の文書をご覧下さい。

- `OpenLDAP`_

- `Microsoft ActiveDirectory`_

- `Novell eDirectory`_

.. _zend.ldap.server.rootdse.getting:

.. rubric:: ルートDSEを手に入れる

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend\Ldap\Ldap($options);
   $rootdse = $ldap->getRootDse();
   $serverType = $rootdse->getServerType();

.. _zend.ldap.server.schema:

参照するスキーマ
--------

.. _zend.ldap.server.schema.getting:

.. rubric:: サーバ・スキーマを手に入れる

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend\Ldap\Ldap($options);
   $schema = $ldap->getSchema();
   $classes = $schema->getObjectClasses();

.. _zend.ldap.server.schema.openldap:

OpenLDAP
^^^^^^^^



.. _zend.ldap.server.schema.activedirectory:

ActiveDirectory
^^^^^^^^^^^^^^^

.. note::

   **ActiveDirectoryサーバで参照するスキーマ**

   包括的探索ルーチンによって返される項目の数に関する Microsoft
   ActiveDirectoryサーバに対する制限のために、
   そして、ActiveDirectoryスキーマ・リポジトリの構造のために、 Microsoft
   ActiveDirectoryサーバでは、参照するスキーマは現在利用でき **ません**\ 。



.. _`OpenLDAP`: http://www.zytrax.com/books/ldap/ch3/#operational
.. _`Microsoft ActiveDirectory`: http://msdn.microsoft.com/en-us/library/ms684291(VS.85).aspx
.. _`Novell eDirectory`: http://www.novell.com/documentation/edir88/edir88/index.html?page=/documentation/edir88/edir88/data/ah59jqq.html
