.. EN-Revision: none
.. _zend.ldap.usage:

利用シナリオ
======

.. _zend.ldap.usage.authentication:

認証シナリオ
------

.. _zend.ldap.usage.authentication.openldap:

OpenLDAP
^^^^^^^^



.. _zend.ldap.usage.authentication.activedirectory:

ActiveDirectory
^^^^^^^^^^^^^^^



.. _zend.ldap.usage.basic:

基本的なCRUD操作
----------

.. _zend.ldap.usage.basic.retrieve:

LDAPからデータを取得
^^^^^^^^^^^^

.. _zend.ldap.usage.basic.retrieve.dn:

.. rubric:: そのDNで項目を取得

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $ldap->bind();
   $hm = $ldap->getEntry('cn=Hugo Müller,ou=People,dc=my,dc=local');
   /*
   $hm は下記の構造の配列
   array(
       'dn'          => 'cn=Hugo Müller,ou=People,dc=my,dc=local',
       'cn'          => array('Hugo Müller'),
       'sn'          => array('Müller'),
       'objectclass' => array('inetOrgPerson', 'top'),
       ...
   )
   */

.. _zend.ldap.usage.basic.retrieve.exists:

.. rubric:: 与えられたDNが存在するかチェック

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $ldap->bind();
   $isThere = $ldap->exists('cn=Hugo Müller,ou=People,dc=my,dc=local');

.. _zend.ldap.usage.basic.retrieve.counting-children:

.. rubric:: 与えられたDNの子供を数える

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $ldap->bind();
   $childrenCount = $ldap->countChildren(
                               'cn=Hugo Müller,ou=People,dc=my,dc=local');

.. _zend.ldap.usage.basic.retrieve.search:

.. rubric:: LDAPツリーを検索

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $ldap->bind();
   $result = $ldap->search('(objectclass=*)',
                           'ou=People,dc=my,dc=local',
                           Zend_Ldap_Ext::SEARCH_SCOPE_ONE);
   foreach ($result as $item) {
       echo $item["dn"] . ': ' . $item['cn'][0] . PHP_EOL;
   }

.. _zend.ldap.usage.basic.add:

LDAPにデータを追加
^^^^^^^^^^^

.. rubric:: LDAPに新規項目を追加

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $ldap->bind();
   $entry = array();
   Zend_Ldap_Attribute::setAttribute($entry, 'cn', 'Hans Meier');
   Zend_Ldap_Attribute::setAttribute($entry, 'sn', 'Meier');
   Zend_Ldap_Attribute::setAttribute($entry, 'objectClass', 'inetOrgPerson');
   $ldap->add('cn=Hans Meier,ou=People,dc=my,dc=local', $entry);

.. _zend.ldap.usage.basic.delete:

LDAPからデータを削除
^^^^^^^^^^^^

.. rubric:: LDAPから存在する項目を削除

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $ldap->bind();
   $ldap->delete('cn=Hans Meier,ou=People,dc=my,dc=local');

.. _zend.ldap.usage.basic.update:

LDAPを更新
^^^^^^^

.. rubric:: LDAPに存在する項目を更新

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $ldap->bind();
   $hm = $ldap->getEntry('cn=Hugo Müller,ou=People,dc=my,dc=local');
   Zend_Ldap_Attribute::setAttribute($hm, 'mail', 'mueller@my.local');
   Zend_Ldap_Attribute::setPassword($hm,
                                    'newPa$$w0rd',
                                    Zend_Ldap_Attribute::PASSWORD_HASH_SHA1);
   $ldap->update('cn=Hugo Müller,ou=People,dc=my,dc=local', $hm);

.. _zend.ldap.usage.extended:

拡張された操作
-------

.. _zend.ldap.usage.extended.copy-and-move:

LDAPで項目をコピーまたは移動
^^^^^^^^^^^^^^^^

.. _zend.ldap.usage.extended.copy-and-move.copy:

.. rubric:: LDAP項目をその全ての派生物と共に再帰的にコピー

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $ldap->bind();
   $ldap->copy('cn=Hugo Müller,ou=People,dc=my,dc=local',
               'cn=Hans Meier,ou=People,dc=my,dc=local',
               true);

.. _zend.ldap.usage.extended.copy-and-move.move-to-subtree:

.. rubric:: LDAP項目をその全ての派生物と共に再帰的に異なるサブツリーに移動

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $ldap->bind();
   $ldap->moveToSubtree('cn=Hugo Müller,ou=People,dc=my,dc=local',
                        'ou=Dismissed,dc=my,dc=local',
                        true);


