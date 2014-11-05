.. _zend.validator.post_code:

PostCode Validator
==================

``Zend\I18n\Validator\PostCode`` allows you to determine if a given value is a valid postal code. Postal codes are
specific to cities, and in some locales termed *ZIP* codes.

``Zend\I18n\Validator\PostCode`` knows more than 160 different postal code formats. To select the correct format there
are 2 ways. You can either use a fully qualified locale or you can set your own format manually.

Using a locale is more convenient as Zend Framework already knows the appropriate postal code format for each
locale; however, you need to use the fully qualified locale (one containing a region specifier) to do so. For
instance, the locale "de" is a locale but could not be used with ``Zend\I18n\Validator\PostCode`` as it does not include
the region; "de_AT", however, would be a valid locale, as it specifies the region code ("AT", for Austria).

.. code-block:: php
   :linenos:

   $validator = new Zend\I18n\Validator\PostCode('de_AT');

When you don't set a locale yourself, then ``Zend\I18n\Validator\PostCode`` will use the application wide set locale,
or, when there is none, the locale returned by ``Locale``.

.. code-block:: php
   :linenos:

   // application wide locale within your bootstrap
   Locale::setDefault('de_AT');

   $validator = new Zend\I18n\Validator\PostCode();

You can also change the locale afterwards by calling ``setLocale()``. And of course you can get the actual used
locale by calling ``getLocale()``.

.. code-block:: php
   :linenos:

   $validator = new Zend\I18n\Validator\PostCode('de_AT');
   $validator->setLocale('en_GB');

Postal code formats are simply regular expression strings. When the international postal code format, which is used
by setting the locale, does not fit your needs, then you can also manually set a format by calling ``setFormat()``.

.. code-block:: php
   :linenos:

   $validator = new Zend\I18n\Validator\PostCode('de_AT');
   $validator->setFormat('AT-\d{5}');

.. note::

   **Conventions for self defined formats**

   When using self defined formats you should omit the starting (``'/^'``) and ending tags (``'$/'``). They are
   attached automatically.

   You should also be aware that postcode values are always be validated in a strict way. This means that they have
   to be written standalone without additional characters when they are not covered by the format.

.. _zend.validator.post_code.constructor:

Constructor options
-------------------

At it's most basic, you may pass a string representing a fully qualified locale to the constructor of
``Zend\I18n\Validator\PostCode``.

.. code-block:: php
   :linenos:

   $validator = new Zend\I18n\Validator\PostCode('de_AT');
   $validator = new Zend\I18n\Validator\PostCode($locale);

Additionally, you may pass either an array or a ``Traversable`` instance to the constructor. When you do so, you
must include either the key "locale" or "format"; these will be used to set the appropriate values in the validator
object.

.. code-block:: php
   :linenos:

   $validator = new Zend\I18n\Validator\PostCode(array(
       'locale' => 'de_AT',
       'format' => 'AT_\d+'
   ));

.. _zend.validator.post_code.options:

Supported options for Zend\\Validator\\PostCode
-----------------------------------------------

The following options are supported for ``Zend\I18n\Validator\PostCode``:

- **format**: Sets a postcode format which will be used for validation of the input.

- **locale**: Sets a locale from which the postcode will be taken from.


