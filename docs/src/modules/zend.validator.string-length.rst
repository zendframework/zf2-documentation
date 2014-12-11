.. _zend.validator.stringlength:

StringLength Validator
======================

This validator allows you to validate if a given string is between a defined length.

.. note::

   **Zend\\Validator\\StringLength supports only string validation**

   It should be noted that ``Zend\Validator\StringLength`` supports only the validation of strings. Integers,
   floats, dates or objects can not be validated with this validator.

.. _zend.validator.stringlength.options:

Supported options for Zend\\Validator\\StringLength
---------------------------------------------------

The following options are supported for ``Zend\Validator\StringLength``:

- **encoding**: Sets the ``ICONV`` encoding which has to be used for this string.

- **min**: Sets the minimum allowed length for a string.

- **max**: Sets the maximum allowed length for a string.

.. _zend.validator.stringlength.basic:

Default behaviour for Zend\\Validator\\StringLength
---------------------------------------------------

Per default this validator checks if a value is between ``min`` and ``max``. But for ``min`` the default value is
**0** and for ``max`` it is **NULL** which means unlimited.

So per default, without giving any options, this validator only checks if the input is a string.

.. _zend.validator.stringlength.maximum:

Limiting the maximum allowed length of a string
-----------------------------------------------

To limit the maximum allowed length of a string you need to set the ``max`` property. It accepts an integer value
as input.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\StringLength(array('max' => 6));

   $validator->isValid("Test"); // returns true
   $validator->isValid("Testing"); // returns false

You can set the maximum allowed length also afterwards by using the ``setMax()`` method. And ``getMax()`` to
retrieve the actual maximum border.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\StringLength();
   $validator->setMax(6);

   $validator->isValid("Test"); // returns true
   $validator->isValid("Testing"); // returns false

.. _zend.validator.stringlength.minimum:

Limiting the minimal required length of a string
------------------------------------------------

To limit the minimal required length of a string you need to set the ``min`` property. It accepts also an integer
value as input.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\StringLength(array('min' => 5));

   $validator->isValid("Test"); // returns false
   $validator->isValid("Testing"); // returns true

You can set the minimal requested length also afterwards by using the ``setMin()`` method. And ``getMin()`` to
retrieve the actual minimum border.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\StringLength();
   $validator->setMin(5);

   $validator->isValid("Test"); // returns false
   $validator->isValid("Testing"); // returns true

.. _zend.validator.stringlength.both:

Limiting a string on both sides
-------------------------------

Sometimes it is required to get a string which has a maximal defined length but which is also minimal chars long.
For example when you have a textbox where a user can enter his name, then you may want to limit the name to maximum
30 chars but want to get sure that he entered his name. So you limit the minimum required length to 3 chars. See
the following example:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\StringLength(array('min' => 3, 'max' => 30));

   $validator->isValid("."); // returns false
   $validator->isValid("Test"); // returns true
   $validator->isValid("Testing"); // returns true

.. note::

   **Setting a lower maximum border than the minimum border**

   When you try to set a lower maximum value as the actual minimum value, or a higher minimum value as the actual
   maximum value, then an exception will be raised.

.. _zend.validator.stringlength.encoding:

Encoding of values
------------------

Strings are always using a encoding. Even when you don't set the encoding explicit, *PHP* uses one. When your
application is using a different encoding than *PHP* itself then you should set an encoding yourself.

You can set your own encoding at initiation with the ``encoding`` option, or by using the ``setEncoding()`` method.
We assume that your installation uses *ISO* and your application it set to *ISO*. In this case you will see the
below behaviour.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\StringLength(
       array('min' => 6)
   );
   $validator->isValid("Ärger"); // returns false

   $validator->setEncoding("UTF-8");
   $validator->isValid("Ärger"); // returns true

   $validator2 = new Zend\Validator\StringLength(
       array('min' => 6, 'encoding' => 'UTF-8')
   );
   $validator2->isValid("Ärger"); // returns true

So when your installation and your application are using different encodings, then you should always set an
encoding yourself.


