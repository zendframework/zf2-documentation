.. _zend.i18n.validator.set.int:

IsInt
-----

``Zend\I18n\Validator\IsInt`` validates if a given value is an integer. Also localized integer values are recognised and
can be validated.

.. _zend.i18n.validator.int.options:

Supported Options
^^^^^^^^^^^^^^^^^

The following options are supported for ``Zend\I18n\Validator\IsInt``:

- **locale**: Sets the locale which will be used to validate localized integers.

.. _zend.i18n.validator.set.int.basic:

Simple integer validation
^^^^^^^^^^^^^^^^^^^^^^^^^

The simplest way to validate an integer is by using the system settings. When no option is used, the environment
locale is used for validation:

.. code-block:: php
   :linenos:

   $validator = new Zend\I18n\Validator\IsInt();

   $validator->isValid(1234);   // returns true
   $validator->isValid(1234.5); // returns false
   $validator->isValid('1,234'); // returns true

In the above example we expected that our environment is set to "en" as locale. As you can see in the third example
also grouping is recognised.

.. _zend.i18n.validator.set.int.localized:

Localized integer validation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Often it's useful to be able to validate also localized values. Integer values are often written different in other
countries. For example using english you can write "1234" or "1,234". Both are integer values but the grouping is
optional. In german for example you may write "1.234" and in french "1 234".

``Zend\I18n\Validator\IsInt`` is able to validate such notations. But it is limited to the locale you set. This means that
it not simply strips off the separator, it validates if the correct separator is used. See the following code:

.. code-block:: php
   :linenos:

   $validator = new Zend\I18n\Validator\IsInt(array('locale' => 'de'));

   $validator->isValid(1234); // returns true
   $validator->isValid("1,234"); // returns false
   $validator->isValid("1.234"); // returns true

As you can see, by using a locale, your input is validated localized. Using the english notation you get a
``FALSE`` when the locale forces a different notation.

The locale can also be set afterwards by using ``setLocale()`` and retrieved by using ``getLocale()``.

Migration from 2.0-2.3 to 2.4+
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Version 2.4 adds support for PHP 7. In PHP 7, ``int`` is a reserved keyword,
which required renaming the ``Int`` validator. If you were using the ``Int`` validator
directly previously, you will now receive an ``E_USER_DEPRECATED`` notice on
instantiation. Please update your code to refer to the ``IsInt`` class instead.

Users pulling their ``Int`` validator instance from the validator plugin manager
receive an ``IsInt`` instance instead starting in 2.4.0.

