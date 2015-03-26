.. _zend.validator.lessthan:

LessThan Validator
==================

``Zend\Validator\LessThan`` allows you to validate if a given value is less than a maximum border value.

.. note::

   **Zend\\Validator\\LessThan supports only number validation**

   It should be noted that ``Zend\Validator\LessThan`` supports only the validation of numbers. Strings or dates
   can not be validated with this validator.

.. _zend.validator.lessthan.options:

Supported options for Zend\\Validator\\LessThan
-----------------------------------------------

The following options are supported for ``Zend\Validator\LessThan``:

- **inclusive**: Defines if the validation is inclusive the maximum border value or exclusive. It defaults to
  ``FALSE``.

- **max**: Sets the maximum allowed value.

.. _zend.validator.lessthan.basic:

Basic usage
-----------

To validate if a given value is less than a defined border simply use the following example.

.. code-block:: php
   :linenos:

   $valid  = new Zend\Validator\LessThan(array('max' => 10));
   $value  = 12;
   $return = $valid->isValid($value);
   // returns false

The above example returns ``TRUE`` for all values which are lower than 10.

.. _zend.validator.lessthan.inclusively:

Validation inclusive the border value
-------------------------------------

Sometimes it is useful to validate a value by including the border value. See the following example:

.. code-block:: php
   :linenos:

   $valid  = new Zend\Validator\LessThan(
       array(
           'max' => 10,
           'inclusive' => true
       )
   );
   $value  = 10;
   $result = $valid->isValid($value);
   // returns true

The example is almost equal to our first example but we included the border value. Now the value '10' is allowed
and will return ``TRUE``.


