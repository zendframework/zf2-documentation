.. _zend.filter.set.stringtolower:

StringToLower
-------------

This filter converts any input to be lowercased.

.. _zend.filter.set.stringtolower.options:

.. rubric:: Supported Options

The following options are supported for ``Zend\Filter\StringToLower``:

- **encoding**: This option can be used to set an encoding which has to be used.

.. _zend.filter.set.stringtolower.basic:

.. rubric:: Basic Usage

This is a basic example:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\StringToLower();

   print $filter->filter('SAMPLE');
   // returns "sample"

.. _zend.filter.set.stringtolower.encoding:

.. rubric:: Different Encoded Strings

Per default it will only handle characters from the actual locale of your server. Characters from other charsets
would be ignored. Still, it's possible to also lowercase them when the mbstring extension is available in your
environment. Simply set the wished encoding when initiating the ``StringToLower`` filter. Or use the
``setEncoding()`` method to change the encoding afterwards.

.. code-block:: php
   :linenos:

   // using UTF-8
   $filter = new Zend\Filter\StringToLower('UTF-8');

   // or give an array which can be useful when using a configuration
   $filter = new Zend\Filter\StringToLower(array('encoding' => 'UTF-8'));

   // or do this afterwards
   $filter->setEncoding('ISO-8859-1');

.. note::

   **Setting wrong encodings**

   Be aware that you will get an exception when you want to set an encoding and the mbstring extension is not
   available in your environment.

   Also when you are trying to set an encoding which is not supported by your mbstring extension you will get an
   exception.


