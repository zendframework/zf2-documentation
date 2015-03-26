:orphan:

.. _zend.filter.set.null:

ToNull
------

This filter will change the given input to be ``NULL`` if it meets specific criteria. This is often necessary when
you work with databases and want to have a ``NULL`` value instead of a boolean or any other type.

.. _zend.filter.set.null.options:

Supported Options
^^^^^^^^^^^^^^^^^

The following options are supported for ``Zend\Filter\ToNull``:

- **type**: The variable type which should be supported.

.. _zend.filter.set.null.default:

Default Behavior
^^^^^^^^^^^^^^^^

Per default this filter works like *PHP*'s ``empty()`` method; in other words, if ``empty()`` returns a boolean
``TRUE``, then a ``NULL`` value will be returned.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\ToNull();
   $value  = '';
   $result = $filter->filter($value);
   // returns null instead of the empty string

This means that without providing any configuration, ``Zend\Filter\ToNull`` will accept all input types and return
``NULL`` in the same cases as ``empty()``.

Any other value will be returned as is, without any changes.

.. _zend.filter.set.null.types:

Changing the Default Behavior
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sometimes it's not enough to filter based on ``empty()``. Therefor ``Zend\Filter\ToNull`` allows you to configure
which type will be converted and which not.

The following types can be handled:

- **boolean**: Converts a boolean **FALSE** value to ``NULL``.

- **integer**: Converts an integer **0** value to ``NULL``.

- **empty_array**: Converts an empty **array** to ``NULL``.

- **float**: Converts an float **0.0** value to ``NULL``.

- **string**: Converts an empty string **''** to ``NULL``.

- **zero**: Converts a string containing the single character zero (**'0'**) to ``NULL``.

- **all**: Converts all above types to ``NULL``. (This is the default behavior.)

There are several ways to select which of the above types are filtered. You can give one or multiple types and add
them, you can give an array, you can use constants, or you can give a textual string. See the following examples:

.. code-block:: php
   :linenos:

   // converts false to null
   $filter = new Zend\Filter\ToNull(Zend\Filter\ToNull::BOOLEAN);

   // converts false and 0 to null
   $filter = new Zend\Filter\ToNull(
       Zend\Filter\ToNull::BOOLEAN + Zend\Filter\ToNull::INTEGER
   );

   // converts false and 0 to null
   $filter = new Zend\Filter\ToNull( array(
       Zend\Filter\ToNull::BOOLEAN,
       Zend\Filter\ToNull::INTEGER
   ));

   // converts false and 0 to null
   $filter = new Zend\Filter\ToNull(array(
       'boolean',
       'integer',
   ));

You can also give a Traversable or an array to set the wished types. To set types afterwards use
``setType()``.

Migration from 2.0-2.3 to 2.4+
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Version 2.4 adds support for PHP 7. In PHP 7, ``null`` is a reserved keyword,
which required renaming the ``Null`` filter. If you were using the ``Null`` filter
directly previously, you will now receive an ``E_USER_DEPRECATED`` notice on
instantiation. Please update your code to refer to the ``ToNull`` class instead.

Users pulling their ``Null`` filter instance from the filter plugin manager
receive a ``ToNull`` instance instead starting in 2.4.0.
