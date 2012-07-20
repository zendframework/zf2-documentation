.. _zend.ldap.tools:

ツール
===

.. _zend.ldap.tools.dn:

DN 文字列の作成及び変更
-------------



.. _zend.ldap.tools.filter:

検索フィルタを作成するためにフィルタAPIを使う
------------------------

.. rubric:: 単純なLDAPフィルタの作成

.. code-block:: php
   :linenos:

   $f1  = Zend_Ldap_Filter::equals('name', 'value');         // (name=value)
   $f2  = Zend_Ldap_Filter::begins('name', 'value');         // (name=value*)
   $f3  = Zend_Ldap_Filter::ends('name', 'value');           // (name=*value)
   $f4  = Zend_Ldap_Filter::contains('name', 'value');       // (name=*value*)
   $f5  = Zend_Ldap_Filter::greater('name', 'value');        // (name>value)
   $f6  = Zend_Ldap_Filter::greaterOrEqual('name', 'value'); // (name>=value)
   $f7  = Zend_Ldap_Filter::less('name', 'value');           // (name<value)
   $f8  = Zend_Ldap_Filter::lessOrEqual('name', 'value');    // (name<=value)
   $f9  = Zend_Ldap_Filter::approx('name', 'value');         // (name~=value)
   $f10 = Zend_Ldap_Filter::any('name');                     // (name=*)

.. rubric:: より複雑なLDAPフィルタの作成

.. code-block:: php
   :linenos:

   $f1 = Zend_Ldap_Filter::ends('name', 'value')->negate(); // (!(name=*value))

   $f2 = Zend_Ldap_Filter::equals('name', 'value');
   $f3 = Zend_Ldap_Filter::begins('name', 'value');
   $f4 = Zend_Ldap_Filter::ends('name', 'value');

   // (&(name=value)(name=value*)(name=*value))
   $f5 = Zend_Ldap_Filter::andFilter($f2, $f3, $f4);

   // (|(name=value)(name=value*)(name=*value))
   $f6 = Zend_Ldap_Filter::orFilter($f2, $f3, $f4);

.. _zend.ldap.tools.attribute:

属性APIを使用するLDAP項目の変更
-------------------




