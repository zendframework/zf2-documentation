.. _zend.validator.set.date:

Date
====

``Zend\Validator\Date`` allows you to validate if a given value contains a date. This validator validates also
localized input.

.. _zend.validator.set.date.options:

Supported options for Zend\\Validator\\Date
-------------------------------------------

The following options are supported for ``Zend\Validator\Date``:

- **format**: Sets the format which is used to write the date.

- **locale**: Sets the locale which will be used to validate date values.

.. _zend.validator.set.date.basic:

Default date validation
-----------------------

The easiest way to validate a date is by using the default date format. It is used when no locale and no format has
been given.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Date();

   $validator->isValid('2000-10-10');   // returns true
   $validator->isValid('10.10.2000'); // returns false

The default date format for ``Zend\Validator\Date`` is 'yyyy-MM-dd'.

.. _zend.validator.set.date.localized:

Localized date validation
-------------------------

``Zend\Validator\Date`` validates also dates which are given in a localized format. By using the ``locale`` option
you can define the locale which the date format should use for validation.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Date(array('locale' => 'de'));

   $validator->isValid('10.Feb.2010'); // returns true
   $validator->isValid('10.May.2010'); // returns false

The ``locale`` option sets the default date format. In the above example this is 'dd.MM.yyyy' which is defined as
default date format for 'de'.

.. _zend.validator.set.date.formats:

Self defined date validation
----------------------------

``Zend\Validator\Date`` supports also self defined date formats. When you want to validate such a date you can use
the ``format`` option.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Date(array('format' => 'yyyy'));

   $validator->isValid('2010'); // returns true
   $validator->isValid('May');  // returns false

Of course you can combine ``format`` and ``locale``. In this case you can also use localized month or day names.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Date(array('format' => 'yyyy MMMM', 'locale' => 'de));

   $validator->isValid('2010 Dezember'); // returns true
   $validator->isValid('2010 June');     // returns false


