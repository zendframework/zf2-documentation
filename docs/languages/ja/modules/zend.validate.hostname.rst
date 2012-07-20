.. _zend.validate.set.hostname:

ホスト名
====

``Zend_Validate_Hostname`` は、ホスト名が仕様を満たしているかどうかの検証を行います。
三種類の形式のホスト名、つまり *DNS* ホスト名 (たとえば domain.com)、IP アドレス
(たとえば 1.2.3.4) そしてローカルホスト名 (たとえば localhost) の検証が可能です。
デフォルトでは *DNS* ホスト名のみが有効となります。

.. _zend.validate.set.hostname.options:

Supported options for Zend_Validate_Hostname
--------------------------------------------

The following options are supported for ``Zend_Validate_Hostname``:

- **allow**: Defines the sort of hostname which is allowed to be used. See :ref:`Hostname types
  <zend.validate.set.hostname.types>` for details.

- **idn**: Defines if *IDN* domains are allowed or not. This option defaults to ``TRUE``.

- **ip**: Allows to define a own IP validator. This option defaults to a new instance of ``Zend_Validate_Ip``.

- **tld**: Defines if *TLD*\ s are validated. This option defaults to ``TRUE``.

.. _zend.validate.set.hostname.basic:

基本的な使用法
-------

基本的な使用法は、以下のようになります。

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Hostname();
   if ($validator->isValid($hostname)) {
       // ホスト名は正しい形式のようです
   } else {
       // 不正な形式なので、理由を表示します
       foreach ($validator->getMessages() as $message) {
           echo "$message\n";
       }
   }

これは、ホスト名 ``$hostname`` を検証し、失敗した場合は
その原因を表す便利なエラーメッセージを ``$validator->getMessages()`` で取得します。

.. _zend.validate.set.hostname.types:

さまざまな形式のホスト名を検証
---------------

IP
アドレスやローカルホスト名、あるいはその両方を正しいホスト名として認めたいこともあるでしょう。
その場合は、 ``Zend_Validate_Hostname``
のインスタンスを作成する際にパラメータを渡します。
このパラメータには、どの形式のホスト名を許可するのかを表す整数値を指定しなければなりません。
できるだけ、 ``Zend_Validate_Hostname`` の定数を使用するようにしましょう。

``Zend_Validate_Hostname`` の定数は次のとおりです。 ``ALLOW_DNS`` は *DNS*
ホスト名のみを許可し、 ``ALLOW_IP`` は IP アドレスを許可します。また ``ALLOW_LOCAL``
はローカルネットワーク名を許可し、 ``ALLOW_ALL``
はこれら三種類をすべて許可します。 IP
アドレスだけをチェックするには、以下の例のようにします。

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Hostname(Zend_Validate_Hostname::ALLOW_IP);
   if ($validator->isValid($hostname)) {
       // ホスト名は正しい形式のようです
   } else {
       // 不正な形式なので、理由を表示します
       foreach ($validator->getMessages() as $message) {
           echo "$message\n";
       }
   }

``ALLOW_ALL`` を使用してすべての形式を許可するほかに、
これらの形式を組み合わせることもできます。 たとえば、 *DNS*
およびローカルホスト名を許可するには、 ``Zend_Validate_Hostname``
のインスタンスを次のように作成します。

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Hostname(Zend_Validate_Hostname::ALLOW_DNS | Zend_Validate_Hostname::ALLOW_IP);
.. _zend.validate.set.hostname.idn:

国際化ドメイン名を検証
-----------

国別コードトップレベルドメイン (Country Code Top Level Domains: ccTLDs) の一部、たとえば
'de' (ドイツ) などでは、ドメイン名の中に国際化文字の使用をサポートしています。
これは、国際化ドメイン名 (International Domain Names: *IDN*) といわれるものです。
これらのドメインについても、 ``Zend_Validate_Hostname``
の検証プロセスで使用する文字を拡張することで検証できます。

.. note::

   **IDN ドメイン**

   これまでに、50以上の ccTLD が *IDN* ドメインをサポートします。

*IDN*
ドメインに対するマッチングを行う方法は、通常のホスト名の場合とまったく同じです。
というのも、 *IDN* のマッチングはデフォルトで有効になっているからです。 *IDN*
の検証を無効にしたい場合は、 ``Zend_Validate_Hostname``
のコンストラクタにパラメータを渡すか、あるいは ``setValidateIdn()``
メソッドを使用します。

*IDN* の検証を無効にするには、 ``Zend_Validate_Hostname``
のコンストラクタに二番目のパラメータを次のように渡します。

.. code-block:: php
   :linenos:

   $validator =
       new Zend_Validate_Hostname(
           array(
               'allow' => Zend_Validate_Hostname::ALLOW_DNS,
               'idn'   => false
           )
       );

あるいは、 ``TRUE`` または ``FALSE`` を ``setValidateIdn()`` に渡すことで、 *IDN*
の検証を有効あるいは無効にすることもできます。 現在サポートされていない *IDN*
ホスト名に対するマッチングを行おうとすると、
国際化文字が含まれている場合に検証に失敗します。 追加の文字を指定した ccTLD
ファイルが ``Zend/Validate/Hostname``
に存在しない場合は、通常のホスト名の検証を行います。

.. note::

   **IDN 検証**

   *IDN* の検証は、 *DNS*
   ホスト名の検証を有効にしている場合にのみ行われることに注意しましょう。

.. _zend.validate.set.hostname.tld:

トップレベルドメインを検証
-------------

デフォルトでは、ホスト名の検証は既知の *TLD* の一覧に基づいて行われます。
この機能が不要な場合は、 *IDN*
サポートを無効にするのと同じ方法で無効にできます。 *TLD*
の検証を無効にするには、 ``Zend_Validate_Hostname``
のコンストラクタに三番目のパラメータを渡します。 以下の例では、 *IDN*
の検証は二番目のパラメータで有効にしています。

.. code-block:: php
   :linenos:

   $validator =
       new Zend_Validate_Hostname(
           array(
               'allow' => Zend_Validate_Hostname::ALLOW_DNS,
               'idn'   => true,
               'tld'   => false
           )
       );

あるいは、 ``TRUE`` または ``FALSE`` を ``setValidateIdn()`` に渡すことで、 *TLD*
の検証を有効あるいは無効にすることもできます。

.. note::

   **TLD 検証**

   *TLD* の検証は、 *DNS*
   ホスト名の検証を有効にしている場合にのみ行われることに注意しましょう。


