.. EN-Revision: none
.. _zend.auth.adapter.digest:

ダイジェスト認証
========

.. _zend.auth.adapter.digest.introduction:

導入
--

`ダイジェスト認証`_ は、 `ベーシック認証`_ を改良した *HTTP* 認証方式です。
パスワードを平文テキストでネットワークに流すことなく認証を行えます。

このアダプタは、テキストファイルをもとにした認証を行います。
このテキストファイルには、ダイジェスト認証の基本要素が書かれています。

- "**joe.user**" のようなユーザ名。

- "**Administrative Area**" のようなレルム。

- ユーザ名、レルムおよびパスワードをコロンで区切った文字列の *MD5* ハッシュ。

それぞれの要素はコロンで区切り、たとえば次のようになります
(この例のパスワードは "**somePassword**") です。

.. code-block:: php
   :linenos:

   someUser:Some Realm:fde17b91c3a510ecbaf7dbd37f59d4f8

.. _zend.auth.adapter.digest.specifics:

使用
--

ダイジェスト認証アダプタ ``Zend\Auth_Adapter\Digest``
には、以下の入力パラメータが必要です。

- filename - 認証の問い合わせ先となるファイル名。

- realm - ダイジェスト認証のレルム。

- username - ダイジェスト認証のユーザ名。

- password - 指定したレルムにおける、ユーザのパスワード。

これらのパラメータは、 ``authenticate()``
をコールする前に設定しなければなりません。

.. _zend.auth.adapter.digest.identity:

ID
--

ダイジェスト認証アダプタは ``Zend\Auth\Result``
オブジェクトを返します。ここに、認証された ID の情報が
配列として含まれます。配列のキーは **realm** および **username** です。
これらのキーに対応する配列の値は、 ``authenticate()``
をコールする前に設定したものに対応します。

.. code-block:: php
   :linenos:

   $adapter = new Zend\Auth_Adapter\Digest($filename,
                                           $realm,
                                           $username,
                                           $password);

   $result = $adapter->authenticate();

   $identity = $result->getIdentity();

   print_r($identity);

   /*
   Array
   (
       [realm] => Some Realm
       [username] => someUser
   )
   */



.. _`ダイジェスト認証`: http://en.wikipedia.org/wiki/Digest_access_authentication
.. _`ベーシック認証`: http://ja.wikipedia.org/wiki/Basic%E8%AA%8D%E8%A8%BC
