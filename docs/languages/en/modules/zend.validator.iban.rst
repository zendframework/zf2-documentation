.. _zend.validator.iban:

Iban Validator
==============

``Zend\Validator\Iban`` validates if a given value could be a *IBAN* number. *IBAN* is the abbreviation for
"International Bank Account Number".

.. _zend.validator.iban.options:

Supported options for Zend\\Validator\\Iban
-------------------------------------------

The following options are supported for ``Zend\Validator\Iban``:

- **country_code**: Sets the country code which is used to get the *IBAN* format for validation.

.. _zend.validator.iban.basic:

IBAN validation
---------------

*IBAN* numbers are always related to a country. This means that different countries use different formats for their
*IBAN* numbers. This is the reason why *IBAN* numbers always need a country code. By knowing this we already know how to
use ``Zend\Validator\Iban``.

.. _zend.validator.iban.basic.false:

Ungreedy IBAN validation
^^^^^^^^^^^^^^^^^^^^^^^^

Sometime it is useful, just to validate if the given value **is** a *IBAN* number or not. This means that you don't
want to validate it against a defined country. This can be done by using a ``FALSE`` as locale.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Iban(array('country_code' => false));
   // Note: you can also set a FALSE as single parameter

   if ($validator->isValid('AT611904300234573201')) {
       // IBAN appears to be valid
   } else {
       // IBAN is not valid
   }

So **any** *IBAN* number will be valid. Note that this should not be done when you accept only accounts from a
single country.

.. _zend.validator.iban.basic.aware:

Region aware IBAN validation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To validate against a defined country, you just need to give the wished country code. You can do this by the option
``country_code`` and also afterwards by using ``setCountryCode()``.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Iban(array('country_code' => 'AT'));

   if ($validator->isValid('AT611904300234573201')) {
       // IBAN appears to be valid
   } else {
       // IBAN is not valid
   }
