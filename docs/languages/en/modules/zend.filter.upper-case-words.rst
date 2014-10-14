:orphan:

.. _zend.filter.set.uppercasewords:

UpperCaseWords
-------------

This filter converts any input to uppercase the first character of each word.

.. _zend.filter.set.uppercasewords.options:

Supported Options
^^^^^^^^^^^^^^^^^

The following options are supported for ``Zend\Filter\UpperCaseWords``:

- **encoding**: This option can be used to set an encoding which has to be used.

.. _zend.filter.set.uppercasewords.basic:

Basic Usage
^^^^^^^^^^^

This is a basic example for using the ``UpperCaseWords`` filter:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\UpperCaseWords();

   print $filter->filter('sample of title');
   // returns "Sample Of Title"

.. _zend.filter.set.uppercasewords.encoding:

Different Encoded Strings
^^^^^^^^^^^^^^^^^^^^^^^^^

Like the ``StringToLower`` filter, this filter handles only characters from the actual locale of your server. Using
different character sets works the same as with ``StringToLower``.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\UpperCaseWords(array('encoding' => 'UTF-8'));

   // or do this afterwards
   $filter->setEncoding('ISO-8859-1');


