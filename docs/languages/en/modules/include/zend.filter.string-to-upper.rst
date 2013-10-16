.. _zend.filter.set.stringtoupper:

StringToUpper
-------------

This filter converts any input to be uppercased.

.. _zend.filter.set.stringtoupper.options:

.. rubric:: Supported Options

The following options are supported for ``Zend\Filter\StringToUpper``:

- **encoding**: This option can be used to set an encoding which has to be used.

.. _zend.filter.set.stringtoupper.basic:

.. rubric:: Basic Usage

This is a basic example for using the ``StringToUpper`` filter:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\StringToUpper();

   print $filter->filter('Sample');
   // returns "SAMPLE"

.. _zend.filter.set.stringtoupper.encoding:

.. rubric:: Different Encoded Strings

Like the ``StringToLower`` filter, this filter handles only characters from the actual locale of your server. Using
different character sets works the same as with ``StringToLower``.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\StringToUpper(array('encoding' => 'UTF-8'));

   // or do this afterwards
   $filter->setEncoding('ISO-8859-1');


