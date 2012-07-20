.. _zend.ldap.node:

Zend_Ldap_Nodeを使用してLDAPツリーへのオブジェクト指向アクセス
========================================

.. _zend.ldap.node.basic:

CRUD基本操作
--------

.. _zend.ldap.node.basic.retrieve:

LDAPからデータを取得
^^^^^^^^^^^^

.. _zend.ldap.node.basic.retrieve.dn:

DNでノードを取得
^^^^^^^^^



.. _zend.ldap.node.basic.retrieve.search:

ノードのサブツリーを検索
^^^^^^^^^^^^



.. _zend.ldap.node.basic.add:

LDAPに新規ノードを追加
^^^^^^^^^^^^^



.. _zend.ldap.node.basic.delete:

LDAPからノードを削除
^^^^^^^^^^^^



.. _zend.ldap.node.basic.update:

LDAP上のノードを更新
^^^^^^^^^^^^



.. _zend.ldap.node.extended:

派生的な操作
------

.. _zend.ldap.node.extended.copy-and-move:

LDAPでノードをコピーまたは移動
^^^^^^^^^^^^^^^^^



.. _zend.ldap.node.traversal:

ツリーの走査
------

.. rubric:: LDAPツリーを再帰的に走査

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $ldap->bind();
   $ri = new RecursiveIteratorIterator($ldap->getBaseNode(),
                                       RecursiveIteratorIterator::SELF_FIRST);
   foreach ($ri as $rdn => $n) {
       var_dump($n);
   }


