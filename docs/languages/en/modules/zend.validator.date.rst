.. _zend.validator.date:

Date Validator
==============

``Zend\Validator\Date`` allows you to validate if a given value contains a date.

.. _zend.validator.date.options:

Supported options for Zend\\Validator\\Date
-------------------------------------------

The following options are supported for ``Zend\Validator\Date``:

- **format**: Sets the format which is used to write the date.

- **locale**: Sets the locale which will be used to validate date values.

.. _zend.validator.date.basic:

Default date validation
-----------------------

The easiest way to validate a date is by using the default date format. It is used when no format has
been given.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Date();

   $validator->isValid('2000-10-10');   // returns true
   $validator->isValid('10.10.2000'); // returns false

The default date format for ``Zend\Validator\Date`` is 'yyyy-MM-dd'.

.. _zend.validator.date.formats:

Self defined date validation
----------------------------

``Zend\Validator\Date`` supports also self defined date formats. When you want to validate such a date you can use
the ``format`` option. This option accepts format as specified in the standard PHP function `date() <http://php.net/manual/en/function.date.php>`_.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Date(array('format' => 'Y'));

   $validator->isValid('2010'); // returns true
   $validator->isValid('May');  // returns false


