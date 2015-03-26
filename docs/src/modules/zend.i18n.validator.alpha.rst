.. _zend.validator.alpha:

Alpha Validator
===============

``Zend\I18n\Validator\Alpha`` allows you to validate if a given value contains only alphabetical characters. There is no
length limitation for the input you want to validate. This validator is related to the ``Zend\I18n\Validator\Alnum``
validator with the exception that it does not accept digits.

.. _zend.validator.alpha.options:

Supported options for Zend\\I18n\\Validator\\Alpha
--------------------------------------------------

The following options are supported for ``Zend\I18n\Validator\Alpha``:

- **allowWhiteSpace**: If whitespace characters are allowed. This option defaults to ``FALSE``

.. _zend.validator.alpha.basic:

Basic usage
-----------

A basic example is the following one:

.. code-block:: php
   :linenos:

   $validator = new Zend\I18n\Validator\Alpha();
   if ($validator->isValid('Abcd')) {
       // value contains only allowed chars
   } else {
       // false
   }

.. _zend.validator.alpha.whitespace:

Using whitespaces
-----------------

Per default whitespaces are not accepted because they are not part of the alphabet. Still, there is a way to accept
them as input. This allows to validate complete sentences or phrases.

To allow the usage of whitespaces you need to give the ``allowWhiteSpace`` option. This can be done while creating
an instance of the validator, or afterwards by using ``setAllowWhiteSpace()``. To get the actual state you can use
``getAllowWhiteSpace()``.

.. code-block:: php
   :linenos:

   $validator = new Zend\I18n\Validator\Alpha(array('allowWhiteSpace' => true));
   if ($validator->isValid('Abcd and efg')) {
       // value contains only allowed chars
   } else {
       // false
   }

.. _zend.validator.alpha.languages:

Using different languages
-------------------------

When using ``Zend\I18n\Validator\Alpha`` then the language which the user sets within his browser will be used to set
the allowed characters. This means when your user sets **de** for german then he can also enter characters like
**ä**, **ö** and **ü** additionally to the characters from the english alphabet.

Which characters are allowed depends completely on the used language as every language defines it's own set of
characters.

There are actually 3 languages which are not accepted in their own script. These languages are **korean**,
**japanese** and **chinese** because this languages are using an alphabet where a single character is build by
using multiple characters.

In the case you are using these languages, the input will only be validated by using the english alphabet.


