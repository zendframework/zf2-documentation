.. _zend.validator.set.int:

Int
===

``Zend\I18n\Validator\Int`` validates if a given value is an integer. Also localized integer values are recognised and
can be validated.

.. _zend.i18n.validator.int.options:

Supported options for Zend\\I18n\\Validator\\Int
------------------------------------------------

The following options are supported for ``Zend\I18n\Validator\Int``:

- **locale**: Sets the locale which will be used to validate localized integers.

.. _zend.validator.set.int.basic:

Simple integer validation
-------------------------

The simplest way to validate an integer is by using the system settings. When no option is used, the environment
locale is used for validation:

.. code-block:: php
   :linenos:

   $validator = new Zend\I18n\Validator\Int();

   $validator->isValid(1234);   // returns true
   $validator->isValid(1234.5); // returns false
   $validator->isValid('1,234'); // returns true

In the above example we expected that our environment is set to "en" as locale. As you can see in the third example
also grouping is recognised.

.. _zend.validator.set.int.localized:

Localized integer validation
----------------------------

Often it's useful to be able to validate also localized values. Integer values are often written different in other
countries. For example using english you can write "1234" or "1,234". Both are integer values but the grouping is
optional. In german for example you may write "1.234" and in french "1 234".

``Zend\I18n\Validator\Int`` is able to validate such notations. But it is limited to the locale you set. This means that
it not simply strips off the separator, it validates if the correct separator is used. See the following code:

.. code-block:: php
   :linenos:

   $validator = new Zend\I18n\Validator\Int(array('locale' => 'de'));

   $validator->isValid(1234); // returns true
   $validator->isValid("1,234"); // returns false
   $validator->isValid("1.234"); // returns true

As you can see, by using a locale, your input is validated localized. Using the english notation you get a
``FALSE`` when the locale forces a different notation.

The locale can also be set afterwards by using ``setLocale()`` and retrieved by using ``getLocale()``.


