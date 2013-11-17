.. _zend.validator.set.alnum:

Alnum
=====

``Zend\I18n\Validator\Alnum`` allows you to validate if a given value contains only alphabetical characters and digits.
There is no length limitation for the input you want to validate.

.. _zend.i18n.validator.alnum.options:

Supported options for Zend\I18n\Validator\Alnum
-----------------------------------------------

The following options are supported for ``Zend\I18n\Validator\Alnum``:

- **allowWhiteSpace**: If whitespace characters are allowed. This option defaults to ``FALSE``

.. _zend.validator.set.alnum.basic:

Basic usage
-----------

A basic example is the following one:

.. code-block:: php
   :linenos:

   $validator = new Zend\I18n\Validator\Alnum();
   if ($validator->isValid('Abcd12')) {
       // value contains only allowed chars
   } else {
       // false
   }

.. _zend.validator.set.alnum.whitespace:

Using whitespaces
-----------------

Per default whitespaces are not accepted because they are not part of the alphabet. Still, there is a way to accept
them as input. This allows to validate complete sentences or phrases.

To allow the usage of whitespaces you need to give the ``allowWhiteSpace`` option. This can be done while creating
an instance of the validator, or afterwards by using ``setAllowWhiteSpace()``. To get the actual state you can use
``getAllowWhiteSpace()``.

.. code-block:: php
   :linenos:

   $validator = new Zend\I18n\Validator\Alnum(array('allowWhiteSpace' => true));
   if ($validator->isValid('Abcd and 12')) {
       // value contains only allowed chars
   } else {
       // false
   }

.. _zend.validator.set.alnum.languages:

Using different languages
-------------------------

When using ``Zend\I18n\Validator\Alnum`` then the language which the user sets within his browser will be used to set
the allowed characters. This means when your user sets **de** for german then he can also enter characters like
**ä**, **ö** and **ü** additionally to the characters from the english alphabet.

Which characters are allowed depends completely on the used language as every language defines it's own set of
characters.

There are actually 3 languages which are not accepted in their own script. These languages are **korean**,
**japanese** and **chinese** because this languages are using an alphabet where a single character is build by
using multiple characters.

In the case you are using these languages, the input will only be validated by using the english alphabet.


