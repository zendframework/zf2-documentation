.. _zend.filter.set.decrypt:

Decrypt
=======

このフィルタは、指定した文字列を指定した設定で復号します。
復号の際に、アダプタを使用します。実際には、 *PHP* の ``Mcrypt`` および ``OpenSSL``
拡張モジュール用のアダプタを使用します。

コンテンツの暗号化方法の詳細については ``Encrypt`` フィルタを参照ください。
基本的な内容は ``Encrypt`` フィルタで網羅されているので、
ここでは追加のメソッドや復号時に固有のことなどについてのみ説明します。

.. _zend.filter.set.decrypt.mcrypt:

Mcrypt の復号
----------

``Mcrypt`` で暗号化したコンテンツを復号するには、
暗号化を行った際に指定したオプションが必要です。

ここでひとつ暗号化時との大きな違いがあります。
暗号化の際にベクトルを指定しなかった場合は、コンテンツを暗号化した後で
フィルタの ``getVector()`` メソッドを使用してベクトルを取得する必要があります。
正しいベクトルがなければ、コンテンツを復号することはできません。

オプションを指定しさえすれば、復号は暗号化と同じくらい単純なことです。

.. code-block:: php
   :linenos:

   // デフォルト設定の blowfish を使用します
   $filter = new Zend_Filter_Decrypt('myencryptionkey');

   // コンテンツの暗号化用ベクトルを設定します
   $filter->setVector('myvector');

   $decrypted = $filter->filter('encoded_text_normally_unreadable');
   print $decrypted;

.. note::

   mcrypt 拡張モジュールが使用できない場合は例外が発生することに注意しましょう。

.. note::

   また、インスタンス作成時あるいは ``setEncryption()``
   をコールした際にすべての設定がチェックされることにも注意しましょう。
   設定内容に問題があることを mcrypt が検知すると、例外がスローされます。

.. _zend.filter.set.decrypt.openssl:

OpenSSL の復号
-----------

``OpenSSL`` での復号は、暗号化と同様にシンプルです。
しかし、コンテンツを暗号化した人からすべてのデータを受け取る必要があります。

``OpenSSL`` の復号には、以下が必要となります。

- **private**: コンテンツの復号に使用する秘密鍵。
  鍵ファイルのパスとファイル名を指定するか、
  あるいは単に鍵ファイルの内容そのものを指定することもできます。

- **envelope**: コンテンツを暗号化した人から受け取った、
  暗号化されたエンベロープ鍵。 鍵ファイルのパスとファイル名を指定するか、
  あるいは単に鍵ファイルの内容そのものを指定することもできます。  When the
  ``package`` option has been set, then you can omit this parameter.

- **package**: If the envelope key has been packed with the encrypted value. Defaults to ``FALSE``.

.. code-block:: php
   :linenos:

   // openssl を使用し、秘密鍵を指定します
   $filter = new Zend_Filter_Decrypt(array(
       'adapter' => 'openssl',
       'private' => '/path/to/mykey/private.pem'
   ));

   // もちろん、初期化時にエンベロープ鍵を指定することもできます
   $filter->setEnvelopeKey(array(
       '/key/from/encoder/first.pem',
       '/key/from/encoder/second.pem'
   ));

.. note::

   ``OpenSSL`` アダプタは、正しい鍵を渡さないと動作しないことに注意しましょう。

オプションで、パスフレーズを渡さなければ鍵を復号できないようにすることもできます。
そのために使用するのが ``setPassphrase()`` メソッドです。

.. code-block:: php
   :linenos:

   // openssl を使用し、秘密鍵を指定します
   $filter = new Zend_Filter_Decrypt(array(
       'adapter' => 'openssl',
       'private' => '/path/to/mykey/private.pem'
   ));

   // もちろん、初期化時にエンベロープ鍵を指定することもできます
   $filter->setEnvelopeKey(array(
       '/key/from/encoder/first.pem',
       '/key/from/encoder/second.pem'
   ));
   $filter->setPassphrase('mypassphrase');

最後に、コンテンツを復号します。
暗号化したコンテンツの復号を行う完全な例は、このようになります。

.. code-block:: php
   :linenos:

   // openssl を使用し、秘密鍵を指定します
   $filter = new Zend_Filter_Decrypt(array(
       'adapter' => 'openssl',
       'private' => '/path/to/mykey/private.pem'
   ));

   // もちろん、初期化時にエンベロープ鍵を指定することもできます
   $filter->setEnvelopeKey(array(
       '/key/from/encoder/first.pem',
       '/key/from/encoder/second.pem'
   ));
   $filter->setPassphrase('mypassphrase');

   $decrypted = $filter->filter('encoded_text_normally_unreadable');
   print $decrypted;


