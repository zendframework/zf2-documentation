.. _zend.validator.callback:

Callback Validator
==================

``Zend\Validator\Callback`` allows you to provide a callback with which to validate a given value.

.. _zend.validator.callback.options:

Supported options for Zend\\Validator\\Callback
-----------------------------------------------

The following options are supported for ``Zend\Validator\Callback``:

- **callback**: Sets the callback which will be called for the validation.

- **options**: Sets the additional options which will be given to the callback.

.. _zend.validator.callback.basic:

Basic usage
-----------

The simplest usecase is to have a single function and use it as a callback. Let's expect we have the following
function.

.. code-block:: php
   :linenos:

   function myMethod($value)
   {
       // some validation
       return true;
   }

To use it within ``Zend\Validator\Callback`` you just have to call it this way:

.. code-block:: php
   :linenos:

   $valid = new Zend\Validator\Callback('myMethod');
   if ($valid->isValid($input)) {
       // input appears to be valid
   } else {
       // input is invalid
   }

.. _zend.validator.callback.closure:

Usage with closures
-------------------

*PHP* 5.3 introduces `closures`_, which are basically self-contained or **anonymous** functions. *PHP* considers
closures another form of callback, and, as such, may be used with ``Zend\Validator\Callback``. As an example:

.. code-block:: php
   :linenos:

   $valid = new Zend\Validator\Callback(function($value){
       // some validation
       return true;
   });

   if ($valid->isValid($input)) {
       // input appears to be valid
   } else {
       // input is invalid
   }

.. _zend.validator.callback.class:

Usage with class-based callbacks
--------------------------------

Of course it's also possible to use a class method as callback. Let's expect we have the following class method:

.. code-block:: php
   :linenos:

   class MyClass
   {
       public function myMethod($value)
       {
           // some validation
           return true;
       }
   }

The definition of the callback is in this case almost the same. You have just to create an instance of the class
before the method and create an array describing the callback:

.. code-block:: php
   :linenos:

   $object = new MyClass;
   $valid = new Zend\Validator\Callback(array($object, 'myMethod'));
   if ($valid->isValid($input)) {
       // input appears to be valid
   } else {
       // input is invalid
   }

You may also define a static method as a callback. Consider the following class definition and validator usage:

.. code-block:: php
   :linenos:

   class MyClass
   {
       public static function test($value)
       {
           // some validation
           return true;
       }
   }

   $valid = new Zend\Validator\Callback(array('MyClass', 'test'));
   if ($valid->isValid($input)) {
       // input appears to be valid
   } else {
       // input is invalid
   }

Finally, if you are using *PHP* 5.3, you may define the magic method ``__invoke()`` in your class. If you do so,
simply providing an instance of the class as the callback will also work:

.. code-block:: php
   :linenos:

   class MyClass
   {
       public function __invoke($value)
       {
           // some validation
           return true;
       }
   }

   $object = new MyClass();
   $valid = new Zend\Validator\Callback($object);
   if ($valid->isValid($input)) {
       // input appears to be valid
   } else {
       // input is invalid
   }

.. _zend.validator.callback.options2:

Adding options
--------------

``Zend\Validator\Callback`` also allows the usage of options which are provided as additional arguments to the
callback.

Consider the following class and method definition:

.. code-block:: php
   :linenos:

   class MyClass
   {
       function myMethod($value, $option)
       {
           // some validation
           return true;
       }

       //if a context is present
       function myMethod($value, $context, $option)
       {
           // some validation
           return true;
       }

   }

There are two ways to inform the validator of additional options: pass them in the constructor, or pass them to the
``setOptions()`` method.

To pass them to the constructor, you would need to pass an array containing two keys, "callback" and "options":

.. code-block:: php
   :linenos:

   $valid = new Zend\Validator\Callback(array(
       'callback' => array('MyClass', 'myMethod'),
       'options'  => $option,
   ));

   if ($valid->isValid($input)) {
       // input appears to be valid
   } else {
       // input is invalid
   }

Otherwise, you may pass them to the validator after instantiation:

.. code-block:: php
   :linenos:

   $valid = new Zend\Validator\Callback(array('MyClass', 'myMethod'));
   $valid->setOptions($option);

   if ($valid->isValid($input)) {
       // input appears to be valid
   } else {
       // input is invalid
   }

When there are additional values given to ``isValid()`` then these values will be added immediately after
``$value``.

.. code-block:: php
   :linenos:

   $valid = new Zend\Validator\Callback(array('MyClass', 'myMethod'));
   $valid->setOptions($option);

   if ($valid->isValid($input, $additional)) {
       // input appears to be valid
   } else {
       // input is invalid
   }

When making the call to the callback, the value to be validated will always be passed as the first argument to the
callback followed by all other values given to ``isValid()``; all other options will follow it. The amount and type
of options which can be used is not limited.



.. _`closures`: http://php.net/functions.anonymous
