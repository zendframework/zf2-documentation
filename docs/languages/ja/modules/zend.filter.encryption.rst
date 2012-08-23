.. EN-Revision: none
.. _zend.filter.set.encrypt:

Encrypt
=======

このフィルタは、指定した設定で任意の文字列を暗号化します。
暗号化の際に、アダプタを使用します。実際には、 *PHP* の ``Mcrypt`` および ``OpenSSL``
拡張モジュール用のアダプタを使用します。

これら 2 つの暗号化手法はまったく異なる方式なので、
アダプタの使用法もそれぞれ異なります。
フィルタを初期化する際に、どのアダプタを使うかを選ばなければなりません。

.. code-block:: php
   :linenos:

   // Mcrypt アダプタを使用します
   $filter1 = new Zend_Filter_Encrypt(array('adapter' => 'mcrypt'));

   // OpenSSL アダプタを使用します
   $filter2 = new Zend_Filter_Encrypt(array('adapter' => 'openssl'));

別のアダプタを設定するために ``setAdapter()`` を使用することもできます。また
``getAdapter()`` メソッドで、実際に設定されているアダプタを取得できます。

.. code-block:: php
   :linenos:

   // Mcrypt アダプタを使用します
   $filter = new Zend_Filter_Encrypt();
   $filter->setAdapter('openssl');

.. note::

   ``adapter`` オプションを指定しなかったり setAdapter
   を使用しなかったりした場合は、デフォルトで ``Mcrypt`` アダプタを使用します。

.. _zend.filter.set.encrypt.mcrypt:

Mcrypt での暗号化
------------

``Mcrypt`` 拡張モジュールをインストールすると、 ``Mcrypt``
アダプタが使えるようになります。
このアダプタは、初期化時のオプションとして以下をサポートしています。

- **key**: 暗号化用の鍵。 入力を暗号化する際に使用します。
  復号する際にも同じ鍵が必要です。

- **algorithm**: 使用するアルゴリズム。 `PHP マニュアルの mcrypt のページ`_
  であげられている暗号化アルゴリズムのいずれかでなければなりません。
  省略した場合のデフォルトは 'blowfish' です。

- **algorithm_directory**: アルゴリズムが存在するディレクトリ。
  省略した場合のデフォルトは、mcrypt 拡張モジュールで設定されているパスです。

- **mode**: 使用する暗号化モード。 `PHP マニュアルの mcrypt のページ`_
  であげられているモードのいずれかでなければなりません。
  省略した場合のデフォルトは 'cbc' です。

- **mode_directory**: モードが存在するディレクトリ。 省略した場合のデフォルトは、
  ``Mcrypt`` 拡張モジュールで設定されているパスです。

- **vector**: 使用する初期化ベクトル。
  省略した場合はランダムなベクトルとなります。

- **salt**: キーを salt 値として使用するかどうか。
  使用すると、暗号化に使用するキー自体も暗号化されます。 デフォルトは ``FALSE``
  です。

- **compression**: If the encrypted value should be compressed. Default is no compression. For details take a look
  into :ref:`compression for Openssl <zend.filter.set.encrypt.openssl.compressed>`.

配列ではなく文字列を指定した場合は、その文字列を鍵として使用します。

初期化した後で暗号化の値を取得したり設定したりするには、それぞれ
``getEncryption()`` および ``setEncryption()`` メソッドを使用します。

.. note::

   mcrypt 拡張モジュールが使用できない場合は例外が発生することに注意しましょう。

.. note::

   また、インスタンス作成時あるいは setEncryption()
   をコールした際にすべての設定がチェックされることにも注意しましょう。
   設定内容に問題があることを mcrypt が検知すると、例外がスローされます。

暗号化ベクトルの取得や設定には、それぞれ ``getVector()`` および ``setVector()``
を使用可能です。指定した文字列が、
そのアルゴリズムに必要なベクトルのサイズに応じて切り詰められたり伸ばされたりします。

.. note::

   自前のベクトル以外を使用する場合は、
   そのベクトルを取得してどこかに保存しておかなければならないことに注意しましょう。
   そうしないと、文字列が復号できなくなります。

.. code-block:: php
   :linenos:

   // デフォルト設定の blowfish を使用します
   $filter = new Zend_Filter_Encrypt('myencryptionkey');

   // 自前のベクトルを設定します。それ以外の場合は getVector()
   // をコールしてベクトルを保存しておかないと、後で復号できなくなります
   $filter->setVector('myvector');
   // $filter->getVector();

   $encrypted = $filter->filter('text_to_be_encoded');
   print $encrypted;

   // 復号の方法は Decrypt フィルタを参照ください

.. _zend.filter.set.encrypt.openssl:

OpenSSL での暗号化
-------------

``OpenSSL`` 拡張モジュールをインストールすると、 ``OpenSSL``
アダプタが使えるようになります。
このアダプタは、初期化時のオプションとして以下をサポートしています。

- **public**: 暗号化したコンテンツを渡したい相手の公開鍵。
  複数の公開鍵を指定するには、配列を使用します。
  鍵ファイルのパスとファイル名を指定するか、
  あるいは単に鍵ファイルの内容そのものを指定することもできます。

- **private**: コンテンツの暗号化に使用する、あなたの秘密鍵。
  鍵ファイルのパスとファイル名を指定するか、
  あるいは単に鍵ファイルの内容そのものを指定することもできます。

- **compression**: If the encrypted value should be compressed. Default is no compression.

- **package**: If the envelope key should be packed with the encrypted value. Default is ``FALSE``.

後から公開鍵を取得あるいは設定するには、 ``getPublicKey()`` および ``setPublicKey()``
メソッドを使用します。 秘密鍵についても、 ``getPrivateKey()`` および ``setPrivateKey()``
メソッドで取得あるいは設定できます。

.. code-block:: php
   :linenos:

   // openssl を使用し、秘密鍵を指定します
   $filter = new Zend_Filter_Encrypt(array(
       'adapter' => 'openssl',
       'private' => '/path/to/mykey/private.pem'
   ));

   // もちろん、初期化時に公開鍵を指定することもできます
   $filter->setPublicKey(array(
       '/public/key/path/first.pem',
       '/public/key/path/second.pem'
   ));

.. note::

   ``OpenSSL`` アダプタは、正しい鍵を渡さないと動作しないことに注意しましょう。

鍵自体も暗号化したい場合は、パスフレーズを ``setPassphrase()`` メソッドで渡します。
パスフレーズつきで暗号化したコンテンツを復号したい場合は、 公開鍵だけではなく
(暗号化された鍵を復号するための) パスフレーズも必要となります。

.. code-block:: php
   :linenos:

   // openssl を使用し、秘密鍵を指定します
   $filter = new Zend_Filter_Encrypt(array(
       'adapter' => 'openssl',
       'private' => '/path/to/mykey/private.pem'
   ));

   // もちろん、初期化時に公開鍵を指定することもできます
   $filter->setPublicKey(array(
       '/public/key/path/first.pem',
       '/public/key/path/second.pem'
   ));
   $filter->setPassphrase('mypassphrase');

最後に、OpenSSL を使用した場合に受け手に渡す必要があるものをまとめます。
暗号化されたコンテンツ、パスフレーズを使用した場合はそのパスフレーズ、
そして復号用のエンベロープ鍵。これらが必要となります。

つまり、暗号化を終えたらエンベロープ鍵を取得する必要があるということです。
取得するには ``getEnvelopeKey()`` メソッドを使用します。

``OpenSSL`` でコンテンツの暗号化を行う完全な例は、このようになります。

.. code-block:: php
   :linenos:

   // openssl を使用し、秘密鍵を指定します
   $filter = new Zend_Filter_Encrypt(array(
       'adapter' => 'openssl',
       'private' => '/path/to/mykey/private.pem'
   ));

   // もちろん、初期化時に公開鍵を指定することもできます
   $filter->setPublicKey(array(
       '/public/key/path/first.pem',
       '/public/key/path/second.pem'
   ));
   $filter->setPassphrase('mypassphrase');

   $encrypted = $filter->filter('text_to_be_encoded');
   $envelope  = $filter->getEnvelopeKey();
   print $encrypted;

   // 復号の方法は Decrypt フィルタを参照ください

.. _zend.filter.set.encrypt.openssl.simplified:

Simplified usage with Openssl
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

As seen before, you need to get the envelope key to be able to decrypt the previous encrypted value. This can be
very annoying when you work with multiple values.

To have a simplified usage you can set the ``package`` option to ``TRUE``. The default value is ``FALSE``.

.. code-block:: php
   :linenos:

   // Use openssl and provide a private key
   $filter = new Zend_Filter_Encrypt(array(
       'adapter' => 'openssl',
       'private' => '/path/to/mykey/private.pem',
       'public'  => '/public/key/path/public.pem',
       'package' => true
   ));

   $encrypted = $filter->filter('text_to_be_encoded');
   print $encrypted;

   // For decryption look at the Decrypt filter

Now the returned value contains the encrypted value and the envelope. You don't need to get them after the
compression. But, and this is the negative aspect of this feature, the encrypted value can now only be decrypted by
using ``Zend_Filter_Encrypt``.

.. _zend.filter.set.encrypt.openssl.compressed:

Compressing the content
^^^^^^^^^^^^^^^^^^^^^^^

Based on the original value, the encrypted value can be a very large string. To reduce the value
``Zend_Filter_Encrypt`` allows the usage of compression.

The ``compression`` option can eighter be set to the name of a compression adapter, or to an array which sets all
wished options for the compression adapter.

.. code-block:: php
   :linenos:

   // Use basic compression adapter
   $filter1 = new Zend_Filter_Encrypt(array(
       'adapter'     => 'openssl',
       'private'     => '/path/to/mykey/private.pem',
       'public'      => '/public/key/path/public.pem',
       'package'     => true,
       'compression' => 'bz2'
   ));

   // Use basic compression adapter
   $filter2 = new Zend_Filter_Encrypt(array(
       'adapter'     => 'openssl',
       'private'     => '/path/to/mykey/private.pem',
       'public'      => '/public/key/path/public.pem',
       'package'     => true,
       'compression' => array('adapter' => 'zip', 'target' => '\usr\tmp\tmp.zip')
   ));

.. note::

   **Decryption with same settings**

   When you want to decrypt a value which is additionally compressed, then you need to set the same compression
   settings for decryption as for encryption. Otherwise the decryption will fail.



.. _`PHP マニュアルの mcrypt のページ`: http://php.net/mcrypt
