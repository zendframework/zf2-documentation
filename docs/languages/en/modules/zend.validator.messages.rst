.. _zend.validator.messages:

Validation Messages
===================

Each validator which is based on ``Zend\Validator\ValidatorInterface`` provides one or multiple messages in the
case of a failed validation. You can use this information to set your own messages, or to translate existing
messages which a validator could return to something different.

These validation messages are constants which can be found at top of each validator class. Let's look into
``Zend\Validator\GreaterThan`` for an descriptive example:

.. code-block:: php
   :linenos:

   protected $messageTemplates = array(
       self::NOT_GREATER => "'%value%' is not greater than '%min%'",
   );

As you can see the constant ``self::NOT_GREATER`` refers to the failure and is used as key, and the message itself
is used as value of the message array.

You can retrieve all message templates from a validator by using the ``getMessageTemplates()`` method. It returns
you the above array which contains all messages a validator could return in the case of a failed validation.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\GreaterThan();
   $messages  = $validator->getMessageTemplates();

Using the ``setMessage()`` method you can set another message to be returned in case of the specified failure.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\GreaterThan();
   $validator->setMessage(
       'Please enter a lower value',
       Zend\Validator\GreaterThan::NOT_GREATER
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
``Zend\Validator\AbstractValidator`` using these resource files.

.. code-block:: php
   :linenos:

   $translator = new Zend\Mvc\I18n\Translator();
   $translator->addTranslationFile(
       'phpArray',
       'resources/languages/en/Zend_Validate.php', //or Zend_Captcha
       'default',
       'en_US'
   );
   Zend\Validator\AbstractValidator::setDefaultTranslator($translator);

.. note::

   **Supported languages**

   The amount of supported languages may not be complete. New languages will be
   added with each release. Additionally feel free to use the existing resource files to make your own
   translations.

   You could also use these resource files to rewrite existing translations. So you are not in need to create these
   files manually yourself.

.. _zend.validator.messages.limitation:

Limit the size of a validation message
--------------------------------------

Sometimes it is necessary to limit the maximum size a validation message can have. For example when your view
allows a maximum size of 100 chars to be rendered on one line. To simplify the usage,
``Zend\Validator\AbstractValidator`` is able to automatically limit the maximum returned size of a validation
message.

To get the actual set size use ``Zend\Validator\AbstractValidator::getMessageLength()``. If it is -1, then the
returned message will not be truncated. This is default behaviour.

To limit the returned message size use ``Zend\Validator\AbstractValidator::setMessageLength()``. Set it to any
integer size you need. When the returned message exceeds the set size, then the message will be truncated and the
string '**...**' will be added instead of the rest of the message.

.. code-block:: php
   :linenos:

   Zend\Validator\AbstractValidator::setMessageLength(100);

.. note::

   **Where is this parameter used?**

   The set message length is used for all validators, even for self defined ones, as long as they extend
   ``Zend\Validator\AbstractValidator``.


