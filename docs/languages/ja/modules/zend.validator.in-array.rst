.. EN-Revision: none
.. _zend.validator.set.in_array:

InArray
=======

任意の値が配列の中で含まれるかどうか、 ``Zend\Validate\InArray``\ で検証できます。
それは、多次元配列を確認することもできます。

.. _zend.validator.set.in_array.options:

Supported options for Zend\Validate\InArray
-------------------------------------------

The following options are supported for ``Zend\Validate\InArray``:

- **haystack**: Sets the haystack for the validation.

- **recursive**: Defines if the validation should be done recursive. This option defaults to ``FALSE``.

- **strict**: Defines if the validation should be done strict. This option defaults to ``FALSE``.

.. _zend.validator.set.in_array.basic:

単純な配列の検証
--------

最も単純な方法は、初期化の際に検索される配列を与えることがまさにそうです。

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\InArray(array('key' => 'value',
                                                'otherkey' => 'othervalue'));
   if ($validator->isValid('value')) {
       // 値が見つかりました
   } else {
       // 値が見つかりません
   }

これは、ちょうど *PHP*\ の ``in_array()`` メソッドのようにふるまいます

.. note::

   デフォルトでは、この検証は厳格ではありませんし、
   それは多次元配列を検証することができません。

もちろん、 ``setHaystack()``\ メソッドを用いてその後また、
検証する配列を与えることができます。 ``getHaystack()``
は、実際に設定されている配列を返します。

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\InArray();
   $validator->setHaystack(array('key' => 'value', 'otherkey' => 'othervalue'));

   if ($validator->isValid('value')) {
       // 値が見つかりました
   } else {
       // 値が見つかりません
   }

.. _zend.validator.set.in_array.strict:

厳密な配列の検証
--------

上述のように、配列の中で厳密な検証をすることもできます。
デフォルトでは、整数値 **0**\ と文字列 **"0"**\ の違いがありません。
厳密な検証をするときは、この違いも検証されます。そして、同じ型だけが受け入れられます。

厳密な検証は、異なる２つの方法を用いて行なうこともできます。
初期化で、及びメソッドを用いて。
初期化では、以下の構造で配列を与えなければなりません。

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\InArray(
       array(
           'haystack' => array('key' => 'value', 'otherkey' => 'othervalue'),
           'strict'   => true
       )
   );

   if ($validator->isValid('value')) {
       // 値が見つかりました
   } else {
       // 値が見つかりません
   }

**haystack**\ キーは、検証する配列を含みます。 そして **strict**\ キーを ``TRUE``\
に設定することにより、 検証は厳密な型チェックを用いてなされます。

もちろん、その後この設定値を変えるために、 ``setStrict()``\
メソッドを使うこともできます。 また、 ``getStrict()``
で実際に設定されている内容を取得することもできます。

.. note::

   **strict**\ 設定は、 デフォルトでは ``FALSE``\ であることに注意してください。

.. _zend.validator.set.in_array.recursive:

再帰的な配列の検証
---------

*PHP*\ の ``in_array()``\ メソッド
に加えて、このバリデータは、多次元配列を検証するために使うこともできます。

多次元配列を検証するためには、 **recursive**\
オプションを設定しなければなりません。

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\InArray(
       array(
           'haystack' => array(
               'firstDimension' => array('key' => 'value',
                                         'otherkey' => 'othervalue'),
               'secondDimension' => array('some' => 'real',
                                          'different' => 'key')),
           'recursive' => true
       )
   );

   if ($validator->isValid('value')) {
       // 値が見つかりました
   } else {
       // 値が見つかりません
   }

それにより、任意の値が含まれるかどうか配列が再帰的に検証されます。 さらに、
``setRecursive()`` を使って後からこのオプションを設定したり ``getRecursive()``
で設定を取得したりすることもできます。

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\InArray(
       array(
           'firstDimension' => array('key' => 'value',
                                     'otherkey' => 'othervalue'),
           'secondDimension' => array('some' => 'real',
                                      'different' => 'key')
       )
   );
   $validator->setRecursive(true);

   if ($validator->isValid('value')) {
       // 値が見つかりました
   } else {
       // 値が見つかりません
   }

.. note::

   **再帰的な検証のデフォルト設定**

   デフォルトでは再帰的な検証は無効となります。

.. note::

   **配列内でのオプションキー**

   '``haystack``' や '``strict``'、'``recursive``' といったキーを配列内で使う場合は、
   ``haystack`` キーをラップしなければなりません。


