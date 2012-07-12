
Boolean
=======

This filter changes a given input to be a ``BOOLEAN`` value. This is often useful when working with databases or when processing form values.

.. _zend.filter.set.boolean.options:

Supported options for Zend_Filter_Boolean
-----------------------------------------

The following options are supported for ``Zend_Filter_Boolean`` :

    - casting: When this option is set to
    - TRUE then any given input will be casted to boolean. This
    - option defaults to TRUE.
    - locale: This option sets the locale
    - which will be used to detect localized input.
    - type: The type
    - option sets the boolean type which should be used. Read the following for
    - details.


.. _zend.filter.set.boolean.default:

Default behaviour for Zend_Filter_Boolean
-----------------------------------------

By default, this filter works by casting the input to a ``BOOLEAN`` value; in other words, it operates in a similar fashion to calling ``(boolean) $value`` .

.. code-block:: php
    :linenos:
    
    $filter = new Zend_Filter_Boolean();
    $value  = '';
    $result = $filter->filter($value);
    // returns false
    

This means that without providing any configuration, ``Zend_Filter_Boolean`` accepts all input types and returns a ``BOOLEAN`` just as you would get by type casting to ``BOOLEAN`` .

.. _zend.filter.set.boolean.types:

Changing behaviour for Zend_Filter_Boolean
------------------------------------------

Sometimes casting with ``(boolean)`` will not suffice. ``Zend_Filter_Boolean`` allows you to configure specific types to convert, as well as which to omit.

The following types can be handled:

    - boolean: Returns a boolean value as is.
    - integer: Converts an integer 0 value
    - to FALSE.
    - float: Converts a float 0.0 value
    - to FALSE.
    - string: Converts an empty string '' to
    - FALSE.
    - zero: Converts a string containing the single character
    - zero ('0') to FALSE.
    - empty_array: Converts an empty array
    - to FALSE.
    - null: Converts a NULL value
    - to FALSE.
    - php: Converts values according to PHP
    - when casting them to BOOLEAN.
    - false_string: Converts a string containing the word "false"
    - to a boolean FALSE.
    - yes: Converts a localized string which contains the word
    - "no" to FALSE.
    - all: Converts all above types to
    - BOOLEAN.


All other given values will return ``TRUE`` by default.

There are several ways to select which of the above types are filtered. You can give one or multiple types and add them, you can give an array, you can use constants, or you can give a textual string. See the following examples:

.. code-block:: php
    :linenos:
    
    // converts 0 to false
    $filter = new Zend_Filter_Boolean(Zend_Filter_Boolean::INTEGER);
    
    // converts 0 and '0' to false
    $filter = new Zend_Filter_Boolean(
        Zend_Filter_Boolean::INTEGER + Zend_Filter_Boolean::ZERO
    );
    
    // converts 0 and '0' to false
    $filter = new Zend_Filter_Boolean(array(
        'type' => array(
            Zend_Filter_Boolean::INTEGER,
            Zend_Filter_Boolean::ZERO,
        ),
    ));
    
    // converts 0 and '0' to false
    $filter = new Zend_Filter_Boolean(array(
        'type' => array(
            'integer',
            'zero',
        ),
    ));
    

You can also give an instance of ``Zend_Config`` to set the desired types. To set types after instantiation, use the ``setType()`` method.

.. _zend.filter.set.boolean.localized:

Localized booleans
------------------

As mentioned previously, ``Zend_Filter_Boolean`` can also recognise localized "yes" and "no" strings. This means that you can ask your customer in a form for "yes" or "no" within his native language and ``Zend_Filter_Boolean`` will convert the response to the appropriate boolean value.

To set the desired locale, you can either use the ``locale`` option, or the method ``setLocale()`` .

.. code-block:: php
    :linenos:
    
    $filter = new Zend_Filter_Boolean(array(
        'type'   => Zend_Filter_Boolean::ALL,
        'locale' => 'de',
    ));
    
    // returns false
    echo $filter->filter('nein');
    
    $filter->setLocale('en');
    
    // returns true
    $filter->filter('yes');
    

.. _zend.filter.set.boolean.casting:

Disable casting
---------------

Sometimes it is necessary to recognise only ``TRUE`` or ``FALSE`` and return all other values without changes. ``Zend_Filter_Boolean`` allows you to do this by setting the ``casting`` option to ``FALSE`` .

In this case ``Zend_Filter_Boolean`` will work as described in the following table, which shows which values return ``TRUE`` or ``FALSE`` . All other given values are returned without change when ``casting`` is set to ``FALSE`` 

.. _zend.filter.set.boolean.casting.table:


Usage without casting
---------------------
+---------------------------------+------------------------------------+-----------------------------------+
|Type                             |True                                |False                              |
+=================================+====================================+===================================+
|Zend_Filter_Boolean::BOOLEAN     |TRUE                                |FALSE                              |
+---------------------------------+------------------------------------+-----------------------------------+
|Zend_Filter_Boolean::INTEGER     |0                                   |1                                  |
+---------------------------------+------------------------------------+-----------------------------------+
|Zend_Filter_Boolean::FLOAT       |0.0                                 |1.0                                |
+---------------------------------+------------------------------------+-----------------------------------+
|Zend_Filter_Boolean::STRING      |""                                  |                                   |
+---------------------------------+------------------------------------+-----------------------------------+
|Zend_Filter_Boolean::ZERO        |"0"                                 |"1"                                |
+---------------------------------+------------------------------------+-----------------------------------+
|Zend_Filter_Boolean::EMPTY_ARRAY |array()                             |                                   |
+---------------------------------+------------------------------------+-----------------------------------+
|Zend_Filter_Boolean::NULL        |NULL                                |                                   |
+---------------------------------+------------------------------------+-----------------------------------+
|Zend_Filter_Boolean::FALSE_STRING|"false" (case independently)        |"true" (case independently)        |
+---------------------------------+------------------------------------+-----------------------------------+
|Zend_Filter_Boolean::YES         |localized "yes" (case independently)|localized "no" (case independently)|
+---------------------------------+------------------------------------+-----------------------------------+


The following example shows the behaviour when changing the ``casting`` option:

.. code-block:: php
    :linenos:
    
    $filter = new Zend_Filter_Boolean(array(
        'type'    => Zend_Filter_Boolean::ALL,
        'casting' => false,
    ));
    
    // returns false
    echo $filter->filter(0);
    
    // returns true
    echo $filter->filter(1);
    
    // returns the value
    echo $filter->filter(2);
    


