
.. _zend.validator.set.identical:

Identical
=========

``Zend\Validator\Identical`` allows you to validate if a given value is identical with an set haystack.


.. _zend.validator.set.identical.options:

Supported options for Zend\\Validator\\Identical
------------------------------------------------

The following options are supported for ``Zend\Validator\Identical``:

- **strict**: Defines if the validation should be done strict. The default value is ``TRUE``.

- **token**: Sets the token with which the input will be validated against.


.. _zend.validator.set.identical.basic:

Basic usage
-----------

To validate if two values are identical you need to set the origin value as haystack. See the following example which validates two strings.

.. code-block:: php
   :linenos:

   $valid = new Zend\Validator\Identical('origin');
   if ($valid->isValid($value) {
       return true;
   }

The validation will only then return ``TRUE`` when both values are 100% identical. In our example, when ``$value`` is 'origin'.

You can set the wished token also afterwards by using the method ``setToken()`` and ``getToken()`` to get the actual set token.


.. _zend.validator.set.identical.types:

Identical objects
-----------------

Of course ``Zend\Validator\Identical`` can not only validate strings, but also any other variable type like Boolean, Integer, Float, Array or even Objects. As already noted Haystack and Value must be identical.

.. code-block:: php
   :linenos:

   $valid = new Zend\Validator\Identical(123);
   if ($valid->isValid($input)) {
       // input appears to be valid
   } else {
       // input is invalid
   }

.. note::
   **Type comparison**

   You should be aware that also the type of a variable is used for validation. This means that the string **'3'** is not identical with the integer **3**. When you want such a non strict validation you must set the ``strict`` option.



.. _zend.validator.set.identical.formelements:

Form elements
-------------

``Zend\Validator\Identical`` supports also the comparison of form elements. This can be done by using the element's name as ``token``. See the following example:

.. code-block:: php
   :linenos:

   $form->addElement('password', 'elementOne');
   $form->addElement('password', 'elementTwo', array(
       'validators' => array(
           array('identical', false, array('token' => 'elementOne'))
       )
   ));

By using the elements name from the first element as ``token`` for the second element, the validator validates if the second element is equal with the first element. In the case your user does not enter two identical values, you will get an validation error.


.. _zend.validator.set.identical.strict:

Strict validation
-----------------

As mentioned before ``Zend\Validator\Identical`` validates tokens strict. You can change this behaviour by using the ``strict`` option. The default value for this property is ``TRUE``.

.. code-block:: php
   :linenos:

   $valid = new Zend\Validator\Identical(array('token' => 123, 'strict' => FALSE));
   $input = '123';
   if ($valid->isValid($input)) {
       // input appears to be valid
   } else {
       // input is invalid
   }

The difference to the previous example is that the validation returns in this case ``TRUE``, even if you compare a integer with string value as long as the content is identical but not the type.

For convenience you can also use ``setStrict()`` and ``getStrict()``.


.. _zend.validator.set.identical.configuration:

Configuration
-------------

As all other validators also ``Zend\Validator\Identical`` supports the usage of configuration settings as input parameter. This means that you can configure this validator with an ``Traversable`` instance.

But this adds one case which you have to be aware. When you are using an array as haystack then you should wrap it within an '``token``' key when it could contain only one element.

.. code-block:: php
   :linenos:

   $valid = new Zend\Validator\Identical(array('token' => 123));
   if ($valid->isValid($input)) {
       // input appears to be valid
   } else {
       // input is invalid
   }

The above example validates the integer 123. The reason for this special case is, that you can configure the token which has to be used by giving the '``token``' key.

So, when your haystack contains one element and this element is named '``token``' then you have to wrap it like shown in the example below.

.. code-block:: php
   :linenos:

   $valid = new Zend\Validator\Identical(array('token' => array('token' => 123)));
   if ($valid->isValid($input)) {
       // input appears to be valid
   } else {
       // input is invalid
   }


