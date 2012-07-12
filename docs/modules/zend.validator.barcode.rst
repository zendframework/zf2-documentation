
Barcode
=======

``Zend\Validator\Barcode`` allows you to check if a given value can be represented as barcode.

``Zend\Validator\Barcode`` supports multiple barcode standards and can be extended with proprietary barcode implementations very easily. The following barcode standards are supported:

.. _zend.validator.set.barcode.options:

Supported options for Zend\\Validator\\Barcode
----------------------------------------------

The following options are supported for ``Zend\Validator\Barcode`` :

    - adapter: Sets the barcode adapter
    - which will be used. Supported are all above noted adapters. When using a self
    - defined adapter, then you have to set the complete class name.
    - checksum: TRUE
    - when the barcode should contain a checksum. The default value depends on the
    - used adapter. Note that some adapters don't allow to set this option.
    - options: Defines optional options for
    - a self written adapters.


.. _zend.validator.set.barcode.basic:

Basic usage
-----------

To validate if a given string is a barcode you just need to know its type. See the following example for an EAN13 barcode:

.. code-block:: php
    :linenos:
    
    $valid = new Zend\Validator\Barcode('EAN13');
    if ($valid->isValid($input)) {
        // input appears to be valid
    } else {
        // input is invalid
    }
    

.. _zend.validator.set.barcode.checksum:

Optional checksum
-----------------

Some barcodes can be provided with an optional checksum. These barcodes would be valid even without checksum. Still, when you provide a checksum, then you should also validate it. By default, these barcode types perform no checksum validation. By using the ``checksum`` option you can define if the checksum will be validated or ignored.

.. code-block:: php
    :linenos:
    
    $valid = new Zend\Validator\Barcode(array(
        'adapter'  => 'EAN13',
        'checksum' => false,
    ));
    if ($valid->isValid($input)) {
        // input appears to be valid
    } else {
        // input is invalid
    }
    

.. note::
    **Reduced security by disabling checksum validation**

    By switching off checksum validation you will also reduce the security of the used barcodes. Additionally you should note that you can also turn off the checksum validation for those barcode types which must contain a checksum value. Barcodes which would not be valid could then be returned as valid even if they are not.

.. _zend.validator.set.barcode.custom:

Writing custom adapters
-----------------------

You may write custom barcode validators for usage with ``Zend\Validator\Barcode`` ; this is often necessary when dealing with proprietary barcode types. To write your own barcode validator, you need the following information.

    - Length: The length your barcode must have. It can have one
    - of the following values:
    - Integer: A value greater 0, which means that the
    - barcode must have this length.
    - -1: There is no limitation for the length of this
    - barcode.
    - "even": The length of this barcode must have a
    - even amount of digits.
    - "odd": The length of this barcode must have a
    - odd amount of digits.
    - array: An array of integer values. The length of
    - this barcode must have one of the set array values.
    - Characters: A string which contains all allowed characters
    - for this barcode. Also the integer value 128 is allowed, which means the first
    - 128 characters of the ASCII table.
    - Checksum: A string which will be used as callback for a
    - method which does the checksum validation.


Your custom barcode validator must extend ``Zend\Validator\Barcode\AbstractAdapter`` or implement ``Zend\Validator\Barcode\AdapterInterface`` .

As an example, let's create a validator that expects an even number of characters that include all digits and the letters 'ABCDE', and which requires a checksum.

.. code-block:: php
    :linenos:
    
    class My\Barcode\MyBar extends Zend\Validator\Barcode\AbstractAdapter
    {
        protected $length     = 'even';
        protected $characters = '0123456789ABCDE';
        protected $checksum   = 'mod66';
    
        protected function mod66($barcode)
        {
            // do some validations and return a boolean
        }
    }
    
    $valid = new Zend\Validator\Barcode('My\Barcode\MyBar');
    if ($valid->isValid($input)) {
        // input appears to be valid
    } else {
        // input is invalid
    }
    


