.. _zend.validator.notempty:

NotEmpty Validator
==================

This validator allows you to validate if a given value is not empty. This is often useful when working with form
elements or other user input, where you can use it to ensure required elements have values associated with them.

.. _zend.validator.notempty.options:

Supported options for Zend\\Validator\\NotEmpty
-----------------------------------------------

The following options are supported for ``Zend\Validator\NotEmpty``:

- **type**: Sets the type of validation which will be processed. For details take a look into :ref:`this section
  <zend.validator.notempty.types>`.

.. _zend.validator.notempty.default:

Default behaviour for Zend\\Validator\\NotEmpty
-----------------------------------------------

By default, this validator works differently than you would expect when you've worked with *PHP*'s ``empty()``
function. In particular, this validator will evaluate both the integer **0** and string '**0**' as empty.

.. code-block:: php
   :linenos:

   $valid = new Zend\Validator\NotEmpty();
   $value  = '';
   $result = $valid->isValid($value);
   // returns false

.. note::

   **Default behaviour differs from PHP**

   Without providing configuration, ``Zend\Validator\NotEmpty``'s behaviour differs from *PHP*.

.. _zend.validator.notempty.types:

Changing behaviour for Zend\\Validator\\NotEmpty
------------------------------------------------

Some projects have differing opinions of what is considered an "empty" value: a string with only whitespace might
be considered empty, or **0** may be considered non-empty (particularly for boolean sequences). To accommodate
differing needs, ``Zend\Validator\NotEmpty`` allows you to configure which types should be validated as empty and
which not.

The following types can be handled:

- **boolean**: Returns ``FALSE`` when the boolean value is ``FALSE``.

- **integer**: Returns ``FALSE`` when an integer **0** value is given. Per default this validation is not activated
  and returns ``TRUE`` on any integer values.

- **float**: Returns ``FALSE`` when an float **0.0** value is given. Per default this validation is not activated
  and returns ``TRUE`` on any float values.

- **string**: Returns ``FALSE`` when an empty string **''** is given.

- **zero**: Returns ``FALSE`` when the single character zero (**'0'**) is given.

- **empty_array**: Returns ``FALSE`` when an empty **array** is given.

- **null**: Returns ``FALSE`` when an ``NULL`` value is given.

- **php**: Returns ``FALSE`` on the same reasons where *PHP* method ``empty()`` would return ``TRUE``.

- **space**: Returns ``FALSE`` when an string is given which contains only whitespaces.

- **object**: Returns ``TRUE``. ``FALSE`` will be returned when ``object`` is not allowed but an object is given.

- **object_string**: Returns ``FALSE`` when an object is given and it's ``__toString()`` method returns an empty
  string.

- **object_count**: Returns ``FALSE`` when an object is given, it has an ``Countable`` interface and it's count is
  0.

- **all**: Returns ``FALSE`` on all above types.

All other given values will return ``TRUE`` per default.

There are several ways to select which of the above types are validated. You can give one or multiple types and add
them, you can give an array, you can use constants, or you can give a textual string. See the following examples:

.. code-block:: php
   :linenos:

   // Returns false on 0
   $validator = new Zend\Validator\NotEmpty(Zend\Validator\NotEmpty::INTEGER);

   // Returns false on 0 or '0'
   $validator = new Zend\Validator\NotEmpty(
       Zend\Validator\NotEmpty::INTEGER + Zend\Validator\NotEmpty::ZERO
   );

   // Returns false on 0 or '0'
   $validator = new Zend\Validator\NotEmpty(array(
       Zend\Validator\NotEmpty::INTEGER,
       Zend\Validator\NotEmpty::ZERO
   ));

   // Returns false on 0 or '0'
   $validator = new Zend\Validator\NotEmpty(array(
       'integer',
       'zero',
   ));

You can also provide an instance of ``Traversable`` to set the desired types. To set types after instantiation, use
the ``setType()`` method.


