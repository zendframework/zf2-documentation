:orphan:

.. _zend.i18n.validator.float:

IsFloat
=======

``Zend\I18n\Validator\IsFloat`` allows you to validate if a given value contains a floating-point value. This validator
validates also localized input.

.. _zend.i18n.validator.float.options:

Supported options for Zend\\I18n\\Validator\\IsFloat
----------------------------------------------------

The following options are supported for ``Zend\I18n\Validator\IsFloat``:

- **locale**: Sets the locale which will be used to validate localized float values.

.. _zend.i18n.validator.float.basic:

Simple float validation
-----------------------

The simplest way to validate a float is by using the system settings. When no option is used, the environment
locale is used for validation:

.. code-block:: php
   :linenos:

   $validator = new Zend\I18n\Validator\IsFloat();

   $validator->isValid(1234.5);   // returns true
   $validator->isValid('10a01'); // returns false
   $validator->isValid('1,234.5'); // returns true

In the above example we expected that our environment is set to "en" as locale.

.. _zend.i18n.validator.float.localized:

Localized float validation
--------------------------

Often it's useful to be able to validate also localized values. Float values are often written different in other
countries. For example using english you will write "1.5". In german you may write "1,5" and in other languages you
may use grouping.

``Zend\I18n\Validator\IsFloat`` is able to validate such notations. However,it is limited to the locale you set. See the
following code:

.. code-block:: php
   :linenos:

   $validator = new Zend\I18n\Validator\IsFloat(array('locale' => 'de'));

   $validator->isValid(1234.5); // returns true
   $validator->isValid("1 234,5"); // returns false
   $validator->isValid("1.234"); // returns true

As you can see, by using a locale, your input is validated localized. Using a different notation you get a
``FALSE`` when the locale forces a different notation.

The locale can also be set afterwards by using ``setLocale()`` and retrieved by using ``getLocale()``.

Migration from 2.0-2.3 to 2.4+
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Version 2.4 adds support for PHP 7. In PHP 7, ``float`` is a reserved keyword,
which required renaming the ``Float`` validator. If you were using the ``Float`` validator
directly previously, you will now receive an ``E_USER_DEPRECATED`` notice on
instantiation. Please update your code to refer to the ``IsFloat`` class instead.

Users pulling their ``Float`` validator instance from the validator plugin manager
receive an ``IsFloat`` instance instead starting in 2.4.0.

