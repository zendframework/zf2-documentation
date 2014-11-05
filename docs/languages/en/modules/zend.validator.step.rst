:orphan:

.. _zend.validate.set.step:

Step Validator
==============

``Zend\Validator\Step`` allows you to validate if a given value is a valid step value. This validator requires the
value to be a numeric value (either string, int or float).

.. _zend.validate.set.step.options:

Supported options for Zend\\Validator\\Step
-------------------------------------------

The following options are supported for ``Zend\Validator\Step``:

- **baseValue**: This is the base value from which the step should be computed. This option defaults to ``0``

- **step**: This is the step value. This option defaults to ``1``

.. _zend.validate.set.step.basic:

Basic usage
-----------

A basic example is the following one:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Step();

   if ($validator->isValid(1)) {
       // value is a valid step value
   } else {
       // false
   }

.. _zend.validate.set.step.floatingvalues:

Using floating-point values
---------------------------

This validator also supports floating-point base value and step value. Here is a basic example of this feature:



.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Step(
       array(
           'baseValue' => 1.1,
           'step'      => 2.2,
       )
   );

   echo $validator->isValid(1.1); // prints true
   echo $validator->isValid(3.3); // prints true
   echo $validator->isValid(3.35); // prints false
   echo $validator->isValid(2.2); // prints false


