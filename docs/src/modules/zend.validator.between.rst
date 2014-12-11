.. _zend.validator.between:

Between Validator
=================

``Zend\Validator\Between`` allows you to validate if a given value is between two other values.

.. note::

   **Zend\\Validator\\Between supports only number validation**

   It should be noted that ``Zend\Validator\Between`` supports only the validation of numbers. Strings or dates can
   not be validated with this validator.

.. _zend.validator.between.options:

Supported options for Zend\\Validator\\Between
----------------------------------------------

The following options are supported for ``Zend\Validator\Between``:

- **inclusive**: Defines if the validation is inclusive the minimum and maximum border values or exclusive. It
  defaults to ``TRUE``.

- **max**: Sets the maximum border for the validation.

- **min**: Sets the minimum border for the validation.

.. _zend.validator.between.basic:

Default behaviour for Zend\\Validator\\Between
----------------------------------------------

Per default this validator checks if a value is between ``min`` and ``max`` where both border values are allowed as
value.

.. code-block:: php
   :linenos:

   $valid  = new Zend\Validator\Between(array('min' => 0, 'max' => 10));
   $value  = 10;
   $result = $valid->isValid($value);
   // returns true

In the above example the result is ``TRUE`` due to the reason that per default the search is inclusively the border
values. This means in our case that any value from '0' to '10' is allowed. And values like '-1' and '11' will
return ``FALSE``.

.. _zend.validator.between.inclusively:

Validation exclusive the border values
--------------------------------------

Sometimes it is useful to validate a value by excluding the border values. See the following example:

.. code-block:: php
   :linenos:

   $valid  = new Zend\Validator\Between(
       array(
           'min' => 0,
           'max' => 10,
           'inclusive' => false
       )
   );
   $value  = 10;
   $result = $valid->isValid($value);
   // returns false

The example is almost equal to our first example but we excluded the border value. Now the values '0' and '10' are
no longer allowed and will return ``FALSE``.


