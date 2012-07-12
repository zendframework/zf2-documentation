
Iban
====

``Zend\Validator\Iban`` validates if a given value could be a *IBAN* number. *IBAN* is the abbreviation for "International Bank Account Number".

.. _zend.validator.set.iban.options:

Supported options for Zend\\Validator\\Iban
-------------------------------------------

The following options are supported for ``Zend\Validator\Iban`` :

    - locale: Sets the locale which is used
    - to get the IBAN format for validation.


.. _zend.validator.set.iban.basic:

IBAN validation
---------------

*IBAN* numbers are always related to a country. This means that different countries use different formats for their *IBAN* numbers. This is the reason why *IBAN* numbers always need a locale. By knowing this we already know how to use ``Zend\Validator\Iban`` .

.. _zend.validator.set.iban.basic.application:

Application wide locale
-----------------------

We could use the application wide locale. This means that when no option is given at initiation, ``Zend\Validator\Iban`` searches for the application wide locale. See the following code snippet:

.. code-block:: php
    :linenos:
    
    // within bootstrap
    Locale::setDefault('de_AT');
    
    // within the module
    $validator = new Zend\Validator\Iban();
    
    if ($validator->isValid('AT611904300234573201')) {
        // IBAN appears to be valid
    } else {
        // IBAN is not valid
    }
    

.. note::
    **Application wide locale**

    Of course this works only when an application wide locale was set within the registry previously. Otherwise ``Locale`` will try to use the locale which the client sends or, when non has been send, it uses the environment locale. Be aware that this can lead to unwanted behaviour within the validation.

.. _zend.validator.set.iban.basic.false:

Ungreedy IBAN validation
------------------------

Sometime it is useful, just to validate if the given valueisa *IBAN* number or not. This means that you don't want to validate it against a defined country. This can be done by using a ``FALSE`` as locale.

.. code-block:: php
    :linenos:
    
    $validator = new Zend\Validator\Iban(array('locale' => false));
    // Note: you can also set a FALSE as single parameter
    
    if ($validator->isValid('AT611904300234573201')) {
        // IBAN appears to be valid
    } else {
        // IBAN is not valid
    }
    

Soany *IBAN* number will be valid. Note that this should not be done when you accept only accounts from a single country.

.. _zend.validator.set.iban.basic.aware:

Region aware IBAN validation
----------------------------

To validate against a defined country, you just need to give the wished locale. You can do this by the option ``locale`` and also afterwards by using ``setLocale()`` .

.. code-block:: php
    :linenos:
    
    $validator = new Zend\Validator\Iban(array('locale' => 'de_AT'));
    
    if ($validator->isValid('AT611904300234573201')) {
        // IBAN appears to be valid
    } else {
        // IBAN is not valid
    }
    

.. note::
    **Use full qualified locales**

    You must give a full qualified locale, otherwise the country could not be detected correct because languages are spoken in multiple countries.


