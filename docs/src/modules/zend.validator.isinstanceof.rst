.. _zend.validator.isinstanceof:

IsInstanceOf Validator
=============

``Zend\Validator\IsInstanceOf`` allows you to validate whether a given object is an instance of a specific class
or interface.

.. _zend.validator.isinstanceof.options:

Supported options
-----------------

The following options are supported for ``Zend\Validator\IsInstanceOf``:

- **className**: Defines the fully-qualified class name which objects must be an instance of.

.. _zend.validator.isinstanceof.basic:

Basic usage
-----------

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\IsInstanceOf([
       'className' => 'Zend\Validator\Digits'
   ]);
   $object = new Zend\Validator\Digits();

   if ($validator->isValid($object)) {
       // $object is an instance of Zend\Validator\Digits
   } else {
       // false. You can use $validator->getMessages() to retrieve error messages
   }
   
If a string argument is passed to the constructor of ``Zend\Validator\IsInstanceOf`` then that value will be used 
as the class name:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\IsInstanceOf('Zend\Validator\Digits');
   $object = new Zend\Validator\Digits();

   if ($validator->isValid($object)) {
       // $object is an instance of Zend\Validator\Digits
   } else {
       // false. You can use $validator->getMessages() to retrieve error messages
   }
   