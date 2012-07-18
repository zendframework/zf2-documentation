.. _zend.validator.set.in_array:

InArray
=======

``Zend\Validator\InArray`` allows you to validate if a given value is contained within an array. It is also able to
validate multidimensional arrays.

.. _zend.validator.set.in_array.options:

Supported options for Zend\\Validator\\InArray
----------------------------------------------

The following options are supported for ``Zend\Validator\InArray``:

- **haystack**: Sets the haystack for the validation.

- **recursive**: Defines if the validation should be done recursive. This option defaults to ``FALSE``.

- **strict**: Defines if the validation should be done strict. This option defaults to ``FALSE``.

.. _zend.validator.set.in_array.basic:

Simple array validation
-----------------------

The simplest way, is just to give the array which should be searched against at initiation:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\InArray(array('key' => 'value',
                                                'otherkey' => 'othervalue'));
   if ($validator->isValid('value')) {
       // value found
   } else {
       // no value found
   }

This will behave exactly like *PHP*'s ``in_array()`` method.

.. note::

   Per default this validation is not strict nor can it validate multidimensional arrays.

Of course you can give the array to validate against also afterwards by using the ``setHaystack()`` method.
``getHaystack()`` returns the actual set haystack array.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\InArray();
   $validator->setHaystack(array('key' => 'value', 'otherkey' => 'othervalue'));

   if ($validator->isValid('value')) {
       // value found
   } else {
       // no value found
   }

.. _zend.validator.set.in_array.strict:

Strict array validation
-----------------------

As mentioned before you can also do a strict validation within the array. Per default there would be no difference
between the integer value **0** and the string **"0"**. When doing a strict validation this difference will also be
validated and only same types are accepted.

A strict validation can also be done by using two different ways. At initiation and by using a method. At
initiation you have to give an array with the following structure:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\InArray(
       array(
           'haystack' => array('key' => 'value', 'otherkey' => 'othervalue'),
           'strict'   => true
       )
   );

   if ($validator->isValid('value')) {
       // value found
   } else {
       // no value found
   }

The **haystack** key contains your array to validate against. And by setting the **strict** key to ``TRUE``, the
validation is done by using a strict type check.

Of course you can also use the ``setStrict()`` method to change this setting afterwards and ``getStrict()`` to get
the actual set state.

.. note::

   Note that the **strict** setting is per default ``FALSE``.

.. _zend.validator.set.in_array.recursive:

Recursive array validation
--------------------------

In addition to *PHP*'s ``in_array()`` method this validator can also be used to validate multidimensional arrays.

To validate multidimensional arrays you have to set the **recursive** option.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\InArray(
       array(
           'haystack' => array(
               'firstDimension' => array('key' => 'value',
                                         'otherkey' => 'othervalue'),
               'secondDimension' => array('some' => 'real',
                                          'different' => 'key')),
           'recursive' => true
       )
   );

   if ($validator->isValid('value')) {
       // value found
   } else {
       // no value found
   }

Your array will then be validated recursive to see if the given value is contained. Additionally you could use
``setRecursive()`` to set this option afterwards and ``getRecursive()`` to retrieve it.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\InArray(
       array(
           'firstDimension' => array('key' => 'value',
                                     'otherkey' => 'othervalue'),
           'secondDimension' => array('some' => 'real',
                                      'different' => 'key')
       )
   );
   $validator->setRecursive(true);

   if ($validator->isValid('value')) {
       // value found
   } else {
       // no value found
   }

.. note::

   **Default setting for recursion**

   Per default the recursive validation is turned off.

.. note::

   **Option keys within the haystack**

   When you are using the keys '``haystack``', '``strict``' or '``recursive``' within your haystack, then you must
   wrap the ``haystack`` key.


