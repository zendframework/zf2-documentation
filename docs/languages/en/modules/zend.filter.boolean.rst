.. _zend.filter.set.boolean:

Boolean
-------

This filter changes a given input to be a ``BOOLEAN`` value. This is often useful when working with databases or
when processing form values.

.. _zend.filter.set.boolean.options:

.. rubric:: Supported Options

The following options are supported for ``Zend\Filter\Boolean``:

- **casting**: When this option is set to ``TRUE`` then any given input will be casted to boolean. This option
  defaults to ``TRUE``.

- **locale**: This option sets the locale which will be used to detect localized input.

- **type**: The ``type`` option sets the boolean type which should be used. Read the following for details.

.. _zend.filter.set.boolean.default:

.. rubric:: Default Behavior

By default, this filter works by casting the input to a ``BOOLEAN`` value; in other words, it operates in a similar
fashion to calling ``(boolean) $value``.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Boolean();
   $value  = '';
   $result = $filter->filter($value);
   // returns false

This means that without providing any configuration, ``Zend\Filter\Boolean`` accepts all input types and returns a
``BOOLEAN`` just as you would get by type casting to ``BOOLEAN``.

.. _zend.filter.set.boolean.types:

.. rubric:: Changing the Default Behavior

Sometimes casting with ``(boolean)`` will not suffice. ``Zend\Filter\Boolean`` allows you to configure specific
types to convert, as well as which to omit.

The following types can be handled:

- **boolean**: Returns a boolean value as is.

- **integer**: Converts an integer **0** value to ``FALSE``.

- **float**: Converts a float **0.0** value to ``FALSE``.

- **string**: Converts an empty string **''** to ``FALSE``.

- **zero**: Converts a string containing the single character zero (**'0'**) to ``FALSE``.

- **empty_array**: Converts an empty **array** to ``FALSE``.

- **null**: Converts a ``NULL`` value to ``FALSE``.

- **php**: Converts values according to *PHP* when casting them to ``BOOLEAN``.

- **false_string**: Converts a string containing the word "false" to a boolean ``FALSE``.

- **yes**: Converts a localized string which contains the word "no" to ``FALSE``.

- **all**: Converts all above types to ``BOOLEAN``.

All other given values will return ``TRUE`` by default.

There are several ways to select which of the above types are filtered. You can give one or multiple types and add
them, you can give an array, you can use constants, or you can give a textual string. See the following examples:

.. code-block:: php
   :linenos:

   // converts 0 to false
   $filter = new Zend\Filter\Boolean(Zend\Filter\Boolean::INTEGER);

   // converts 0 and '0' to false
   $filter = new Zend\Filter\Boolean(
       Zend\Filter\Boolean::INTEGER + Zend\Filter\Boolean::ZERO
   );

   // converts 0 and '0' to false
   $filter = new Zend\Filter\Boolean(array(
       'type' => array(
           Zend\Filter\Boolean::INTEGER,
           Zend\Filter\Boolean::ZERO,
       ),
   ));

   // converts 0 and '0' to false
   $filter = new Zend\Filter\Boolean(array(
       'type' => array(
           'integer',
           'zero',
       ),
   ));

You can also give an instance of ``Zend\Config\Config`` to set the desired types. To set types after instantiation,
use the ``setType()`` method.

.. _zend.filter.set.boolean.localized:

.. rubric:: Localized Booleans

As mentioned previously, ``Zend\Filter\Boolean`` can also recognise localized "yes" and "no" strings. This means
that you can ask your customer in a form for "yes" or "no" within his native language and ``Zend\Filter\Boolean``
will convert the response to the appropriate boolean value.

To set the desired locale, you can either use the ``locale`` option, or the method ``setLocale()``.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Boolean(array(
       'type'   => Zend\Filter\Boolean::ALL,
       'locale' => 'de',
   ));

   // returns false
   echo $filter->filter('nein');

   $filter->setLocale('en');

   // returns true
   $filter->filter('yes');

.. _zend.filter.set.boolean.casting:

.. rubric:: Disable Casting

Sometimes it is necessary to recognise only ``TRUE`` or ``FALSE`` and return all other values without changes.
``Zend\Filter\Boolean`` allows you to do this by setting the ``casting`` option to ``FALSE``.

In this case ``Zend\Filter\Boolean`` will work as described in the following table, which shows which values return
``TRUE`` or ``FALSE``. All other given values are returned without change when ``casting`` is set to ``FALSE``

.. _zend.filter.set.boolean.casting.table:

.. table:: Usage without casting

   +-----------------------------------+------------------------------------+-----------------------------------+
   |Type                               |True                                |False                              |
   +===================================+====================================+===================================+
   |Zend\\Filter\\Boolean::BOOLEAN     |TRUE                                |FALSE                              |
   +-----------------------------------+------------------------------------+-----------------------------------+
   |Zend\\Filter\\Boolean::INTEGER     |0                                   |1                                  |
   +-----------------------------------+------------------------------------+-----------------------------------+
   |Zend\\Filter\\Boolean::FLOAT       |0.0                                 |1.0                                |
   +-----------------------------------+------------------------------------+-----------------------------------+
   |Zend\\Filter\\Boolean::STRING      |""                                  |                                   |
   +-----------------------------------+------------------------------------+-----------------------------------+
   |Zend\\Filter\\Boolean::ZERO        |"0"                                 |"1"                                |
   +-----------------------------------+------------------------------------+-----------------------------------+
   |Zend\\Filter\\Boolean::EMPTY_ARRAY |array()                             |                                   |
   +-----------------------------------+------------------------------------+-----------------------------------+
   |Zend\\Filter\\Boolean::NULL        |NULL                                |                                   |
   +-----------------------------------+------------------------------------+-----------------------------------+
   |Zend\\Filter\\Boolean::FALSE_STRING|"false" (case independently)        |"true" (case independently)        |
   +-----------------------------------+------------------------------------+-----------------------------------+
   |Zend\\Filter\\Boolean::YES         |localized "yes" (case independently)|localized "no" (case independently)|
   +-----------------------------------+------------------------------------+-----------------------------------+

The following example shows the behaviour when changing the ``casting`` option:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Boolean(array(
       'type'    => Zend\Filter\Boolean::ALL,
       'casting' => false,
   ));

   // returns false
   echo $filter->filter(0);

   // returns true
   echo $filter->filter(1);

   // returns the value
   echo $filter->filter(2);


