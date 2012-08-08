.. EN-Revision: none
.. _zend.validator.messages:

検証メッセージ
=======

``Zend_Validate`` を継承したバリデータには、
検証に失敗したときに使用するメッセージが用意されています。 You can use this
information to set your own messages, or to translate existing messages which a validator could return to something
different.

These validation messages are constants which can be found at top of each validator class. Let's look into
``Zend_Validate_GreaterThan`` for an descriptive example:

.. code-block:: php
   :linenos:

   protected $_messageTemplates = array(
       self::NOT_GREATER => "'%value%' is not greater than '%min%'",
   );

As you can see the constant ``self::NOT_GREATER`` refers to the failure and is used as key, and the message itself
is used as value of the message array.

You can retrieve all message templates from a validator by using the ``getMessageTemplates()`` method. It returns
you the above array which contains all messages a validator could return in the case of a failed validation.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_GreaterThan();
   $messages  = $validator->getMessageTemplates();

Using the ``setMessage()`` method you can set another message to be returned in case of the specified failure.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_GreaterThan();
   $validator->setMessage(
       'Please enter a lower value',
       Zend_Validate_GreaterThan::NOT_GREATER
   );

The second parameter defines the failure which will be overridden. When you omit this parameter, then the given
message will be set for all possible failures of this validator.

.. _zend.validator.messages.pretranslated:

Using pre-translated validation messages
----------------------------------------

Zend Framework is shipped with more than 45 different validators with more than 200 failure messages. It can be a
tedious task to translate all of these messages. But for your convenience Zend Framework comes with already
pre-translated validation messages. You can find them within the path ``/resources/languages`` in your Zend
Framework installation.

.. note::

   **Used path**

   The resource files are outside of the library path because all of your translations should also be outside of
   this path.

So to translate all validation messages to German for example, all you have to do is to attach a translator to
``Zend_Validate`` using these resource files.

.. code-block:: php
   :linenos:

   $translator = new Zend_Translator(
       array(
           'adapter' => 'array',
           'content' => '/resources/languages',
           'locale'  => $language,
           'scan' => Zend_Translator::LOCALE_DIRECTORY
       )
   );
   Zend_Validate_Abstract::setDefaultTranslator($translator);

.. note::

   **Used translation adapter**

   As translation adapter Zend Framework chose the array adapter. It is simple to edit and created very fast.

.. note::

   **Supported languages**

   This feature is very young, so the amount of supported languages may not be complete. New languages will be
   added with each release. Additionally feel free to use the existing resource files to make your own
   translations.

   You could also use these resource files to rewrite existing translations. So you are not in need to create these
   files manually yourself.

.. _zend.validator.messages.limitation:

検証メッセージのサイズの制限
--------------

検証メッセージの最大サイズを制限しなければならないこともあるでしょう。
たとえば、1 行に 100
文字までしかレンダリングできないなどの制限がビューにある場合です。
このような場合のため、 ``Zend_Validate``
では自動的に検証メッセージの最大長を制限できるようになっています。

実際に設定されているサイズを取得するには ``Zend_Validate::getMessageLength()``
を使用します。 この結果が -1
の場合は、返されるメッセージが切り詰められることはありません。
これがデフォルトの挙動です。

返されるメッセージのサイズを制限するには ``Zend_Validate::setMessageLength()``
を使用します。 必要に応じて任意の整数値を設定します。
返されるメッセージのサイズがここで設定した長さを超えると、
メッセージが切り詰められて最後に文字列 '**...**' が付加されます。

.. code-block:: php
   :linenos:

   Zend_Validate::setMessageLength(100);

.. note::

   **このパラメータはどこで使われますか？**

   ここで設定したメッセージ長はすべてのバリデータで使われます。
   自前で定義したバリデータでさえも、それが ``Zend_Validate_Abstract``
   を継承したものである限りは同じです。


