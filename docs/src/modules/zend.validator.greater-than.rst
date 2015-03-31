.. _zend.validator.greaterthan:

GreaterThan Validator
=====================

``Zend\Validator\GreaterThan`` allows you to validate if a given value is greater than a minimum border value.

.. note::

   **Zend\\Validator\\GreaterThan supports only number validation**

   It should be noted that ``Zend\Validator\GreaterThan`` supports only the validation of numbers. Strings or dates
   can not be validated with this validator.

.. _zend.validator.greaterthan.options:

Supported options for Zend\\Validator\\GreaterThan
--------------------------------------------------

The following options are supported for ``Zend\Validator\GreaterThan``:

- **inclusive**: Defines if the validation is inclusive the minimum border value or exclusive. It defaults to
  ``FALSE``.

- **min**: Sets the minimum allowed value.

.. _zend.validator.greaterthan.basic:

Basic usage
-----------

To validate if a given value is greater than a defined border simply use the following example.

.. code-block:: php
   :linenos:

   $valid  = new Zend\Validator\GreaterThan(array('min' => 10));
   $value  = 8;
   $return = $valid->isValid($value);
   // returns false

The above example returns ``TRUE`` for all values which are greater than 10.

.. _zend.validator.greaterthan.inclusively:

Validation inclusive the border value
-------------------------------------

Sometimes it is useful to validate a value by including the border value. See the following example:

.. code-block:: php
   :linenos:

   $valid  = new Zend\Validator\GreaterThan(
       array(
           'min' => 10,
           'inclusive' => true
       )
   );
   $value  = 10;
   $result = $valid->isValid($value);
   // returns true

The example is almost equal to our first example but we included the border value. Now the value '10' is allowed
and will return ``TRUE``.


