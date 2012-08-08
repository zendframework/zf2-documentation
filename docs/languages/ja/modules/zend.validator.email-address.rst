.. EN-Revision: none
.. _zend.validator.set.email_address:

メールアドレス
=======

``Zend_Validate_EmailAddress`` は、メールアドレスの検証を行います。
このバリデータは、まずメールアドレスを local-part @ hostname
に分割し、メールアドレスやホスト名の仕様にあわせて検証します。

.. _zend.validator.set.email_address.basic:

基本的な使用法
-------

基本的な使用法は、以下のようになります。

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_EmailAddress();
   if ($validator->isValid($email)) {
       // メールアドレスは正しい形式のようです
   } else {
       // 不正な形式なので、理由を表示します
       foreach ($validator->getMessages() as $message) {
           echo "$message\n";
       }
   }

これは、メールアドレス ``$email`` を検証し、失敗した場合は
その原因を表す便利なエラーメッセージを *$validator->getMessages()* で取得します。

.. _zend.validator.set.email_address.options:

メールアドレス検証のオプション
---------------

``Zend_Validate_EmailAddress``\ は、
開始時に関係するオプションを持つ配列を与えることによって、 または後で
``setOptions()`` を使って セットできるいくつかのオプションをサポートします。
下記のオプションがサポートされます。

- **allow**: ドメイン名のいずれのタイプを受付可能か定義します。
  このオプションは、ホスト名バリデータをセットするために hostname
  オプションとともに使われます。 このオプションで可能な値について詳しくは、
  :ref:`ホスト名 <zend.validator.set.hostname>`\ をご覧ください。 そして ``ALLOW``\ *
  定数が可能です。 既定値は ``ALLOW_DNS`` です。

- **deep**: サーバの MX レコードを強度のチェックで検証するべきかどうか定義します。
  このオプションが ``TRUE`` に設定されると、
  サーバがメールを受け付けるかどうか検証するために、 MX レコードに加えて A , A6
  及び ``AAAA`` レコードも使われます。 このオプションの既定値は ``FALSE`` です。

- **domain**: ドメインパートをチェックすべきかどうか定義します。 このオプションが
  ``FALSE`` に設定されると、
  メールアドレスのローカルパートのみがチェックされます。
  この場合、ホスト名バリデータは呼ばれません。 このオプションの既定値は ``TRUE``
  です。

- **hostname**: 検証される電子メール・アドレスのドメインパートで
  ホスト名バリデータをセットします。

- **mx**: サーバから MX レコードが検出されるべきかどうか定義します。
  もしこのオプションが ``TRUE`` と定義されると、
  サーバがメールを受け付けるかどうか検証するために MX レコードが使われます。
  このオプションの既定値は ``FALSE`` です。

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_EmailAddress();
   $validator->setOptions(array('domain' => false));

.. _zend.validator.set.email_address.complexlocal:

複雑なローカルパート
----------

``Zend_Validate_EmailAddress`` は、メールアドレスの検証を RFC2822
にもとづいて行います。たとえば、妥当な形式のメールアドレスとしては
*bob@domain.com*\ 、 *bob+jones@domain.us*\ 、 *"bob@jones"@domain.com* および *"bob jones"@domain.com*
などがあります。

かつて使われていたものの、現在は有効とはみなされないフォーマットもあります
(たとえば、メールアドレスに改行文字や "\\" を使用するなど)。

.. _zend.validator.set.email_address.purelocal:

ローカルパートのみの検証
------------

もしメールアドレスのローカルパートのみをチェックするために
``Zend_Validate_EmailAddress`` を必要として、 ホスト名の検証を無効にしたいなら、 ``domain``
オプションに ``FALSE`` を設定できます。 これにより、 ``Zend_Validate_EmailAddress`` が
メールアドレスのホスト名部分を検証しないようにします。

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_EmailAddress();
   $validator->setOptions(array('domain' => FALSE));

.. _zend.validator.set.email_address.hostnametype:

さまざまな形式のホスト名の検証
---------------

メールアドレスのホスト名部分の検証は、 :ref:`Zend_Validate_Hostname
<zend.validator.set.hostname>` で行います。デフォルトでは、 *domain.com* 形式の DNS
ホスト名のみが有効となります。しかし、 IP
アドレスやローカルホスト名も有効にしたいこともあるでしょう。

その場合は、 ``Zend_Validate_EmailAddress``
のインスタンスを作成する際にパラメータを渡さなければなりません。
このパラメータで、認めたいホスト名の形式を指定します。 詳細は
``Zend_Validate_Hostname`` を参照ください。 たとえば DNS
ホスト名およびローカルホスト名のどちらも許可するには、次のようにします。

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_EmailAddress(
                       Zend_Validate_Hostname::ALLOW_DNS |
                       Zend_Validate_Hostname::ALLOW_LOCAL);
   if ($validator->isValid($email)) {
       // メールアドレスは正しい形式のようです
   } else {
       // 不正な形式なので、理由を表示します
       foreach ($validator->getMessages() as $message) {
           echo "$message\n";
       }
   }

.. _zend.validator.set.email_address.checkacceptance:

そのホスト名が実際にメールを受け付けるかどうかのチェック
----------------------------

ただ単にメールアドレスが正しい書式であるというだけでは、
そのアドレスが実際に存在するかどうかはわかりません。
この問題を解決するには、MX の検証を行います。
メールアドレスのホスト名に対応する DNS レコードに、MX (メール)
のエントリが存在するかどうかを調べるのです。
これは、そのホストがメールを受け付けているかどうかを教えてはくれますが、
そのメールアドレス自体が正しいものであるかどうかを知ることはできません。

MX のチェックはデフォルトでは無効です。 MX のチェックを有効にするには、
``Zend_Validate_EmailAddress`` コンストラクタの 2 番目のパラメータを渡します。

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_EmailAddress(
       array(
           'allow' => Zend_Validate_Hostname::ALLOW_DNS,
           'mx'    => true
       )
   );

.. note::

   **WindowsでのMX のチェック**

   Windows 環境の範囲内では、 MX のチェックは *PHP* 5.3
   かそれ以上を使う場合のみ可能です。 *PHP* 5.3 未満では MX
   のチェックはオプションで有効にされたとしても、 使われません。

あるいは、 ``TRUE`` または ``FALSE`` を *$validator->setValidateMx()* に渡すことで、 MX
の検証を有効あるいは無効にすることもできます。

この設定を有効にすると、ネットワーク関数を用いて
メールアドレスのホスト名部に対する MX レコードの存在チェックをします。
これにより、スクリプトの処理速度が低下することに気をつけてください。

しばしば MX レコードの検証は、メールが受け付けられたとしても ``FALSE``
を返します。 この振る舞いの背後にある理由は、サーバが MX
レコードを提供しなくてもサーバはメールを受付できることです。
この場合、サーバは A, A6 または ``AAAA`` レコードを提供します。
それらのほかのレコードでも ``Zend_Validate_EmailAddress``
がチェックできるようにするためには、 強度の MX 検証を設定する必要があります。
これは開始時に ``deep`` オプションを設定するか、 または ``setOptions()``
を使って行ないます。

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_EmailAddress(
       array(
           'allow' => Zend_Validate_Hostname::ALLOW_DNS,
           'mx'    => true,
           'deep'  => true
       )
   );

.. warning::

   **パフォーマンスの警告**

   MX チェックを有効にすると、使用されるネットワーク機能のせいで
   スクリプトが遅くなることに気づくでしょう。
   強度のチェックを有効にすると与えられたサーバで追加の３種類を探すため、
   さらにスクリプトが遅くなります。

.. note::

   **許可されないIPアドレス**

   MX 検証は外部のサーバでのみ受け付けられることを注意すべきです。 強度の MX
   検証が有効なとき、 ``192.168.*`` や ``169.254.*`` のような ローカル IP
   アドレスは受け付けません。

.. _zend.validator.set.email_address.validateidn:

国際化ドメイン名の検証
-----------

``Zend_Validate_EmailAddress``
は、ドメインの中に国際文字が使われている場合も処理できます。
このようなドメインは、国際化ドメイン名 (International Domain Name: IDN)
と呼ばれています。これはデフォルトで有効になっていますが、無効にすることも可能です。
無効にするには、 ``Zend_Validate_EmailAddress`` が内部で保持している ``Zend_Validate_Hostname``
オブジェクトの設定を変更します。

.. code-block:: php
   :linenos:

   $validator->getHostnameValidator()->setValidateIdn(false);

``setValidateIdn()`` の詳細な使用法は、 ``Zend_Validate_Hostname``
のドキュメントを参照ください。

IDN の検証は、DNS
ホスト名の検証を有効にしている場合にのみ行われることに注意しましょう。

.. _zend.validator.set.email_address.validatetld:

トップレベルドメインの検証
-------------

デフォルトでは、ホスト名の検証は既知の TLD の一覧に基づいて行われます。
これはデフォルトで有効になっていますが、無効にすることもできます。無効にするには、
無効にするには、 ``Zend_Validate_EmailAddress`` が内部で保持している ``Zend_Validate_Hostname``
オブジェクトの設定を変更します。

.. code-block:: php
   :linenos:

   $validator->getHostnameValidator()->setValidateTld(false);

``setValidateTld()`` の詳細な使用法は、 ``Zend_Validate_Hostname``
のドキュメントを参照ください。

TLD の検証は、DNS
ホスト名の検証を有効にしている場合にのみ行われることに注意しましょう。

.. _zend.validator.set.email_address.setmessage:

メッセージの設定
--------

``Zend_Validate_EmailAddress`` は、 ``Zend_Validate_Hostname``
を使用してメールアドレスのホスト名部分をチェックします。 Zend Framework 1.10 以降、
``Zend_Validate_Hostname`` 用のメッセージを ``Zend_Validate_EmailAddress``
から設定できるようになります。

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_EmailAddress();
   $validator->setMessages(
       array(
           Zend_Validate_Hostname::UNKNOWN_TLD => 'I don't know the TLD you gave'
       )
   );

Zend Framework 1.10 より前のバージョンでは、まず ``Zend_Validate_Hostname``
にメッセージをアタッチしてからそれを ``Zend_Validate_EmailAddress``
に設定しないと独自のメッセージを返せませんでした。


