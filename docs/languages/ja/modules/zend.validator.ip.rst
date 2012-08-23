.. EN-Revision: none
.. _zend.validator.set.ip:

Ip
==

``Zend_Validate_Ip`` は、与えられた値が IP アドレスかどうか検証できるようにします。
これは IPv4 及び IPv6 標準をサポートします。

.. _zend.validator.set.ip.options:

Supported options for Zend_Validate_Ip
--------------------------------------

The following options are supported for ``Zend_Validate_Ip``:

- **allowipv4**: Defines if the validator allows IPv4 adresses. This option defaults to ``TRUE``.

- **allowipv6**: Defines if the validator allows IPv6 adresses. This option defaults to ``TRUE``.

.. _zend.validator.set.ip.basic:

基本的な使用法
-------

基本的な使用法は、以下のようになります。

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Ip();
   if ($validator->isValid($ip)) {
       // ip は正しい形式のようです
   } else {
       // ip が不正なので、理由を表示します
   }

.. note::

   **IP アドレスの検証**

   ``Zend_Validate_Ip`` は IP アドレスだけを検証することを記憶にとどめてください。
   '``mydomain.com``' や '``192.168.50.1/index.html``' のようなアドレスは、有効な IP
   アドレスではありません。 それらは IP アドレスではなく、 hostname または 有効な
   *URL* です。

.. note::

   **IPv6 の検証**

   ``Zend_Validate_Ip`` は正規表現で IPv6 アドレスを検証します。 それは、 *PHP*
   自身のフィルターやメソッドが *RFC* に準拠していないからです。
   他の多くの利用可能なクラスもまた、それに準拠しません。

.. _zend.validator.set.ip.singletype:

IPv4 または IPV6 だけを検証
-------------------

しばしば、サポートされる形式のうちの１つだけを検証するために役立ちます。
たとえば、ネットワークが IPv4 だけをサポートするときです。
この場合、このバリデータ内で IPv6 を受け付けることは無駄でしょう。

``Zend_Validate_Ip`` をプロトコル１つに制限するために、 オプション ``allowipv4`` または
``allowipv6`` を ``FALSE`` に設定できます。
これは、コンストラクタにオプションを与えることによって、 または、その後
``setOptions()`` を用いて行なえます。

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Ip(array('allowipv6' => false);
   if ($validator->isValid($ip)) {
       // ip は正しい ip4v アドレスのようです
   } else {
       // ip は ipv4 アドレスではありません
   }

.. note::

   **既定の動作**

   ``Zend_Validate_Ip`` が従う既定の動作は 両方の標準を受け付ける、です。


