.. _zend.filter.set.stripnewlines:

StripNewLines
=============

This filter modifies a given string and removes all new line characters within that string.

.. _zend.filter.set.stripnewlines.options:

Supported options for Zend\\Filter\\StripNewLines
-------------------------------------------------

There are no additional options for ``Zend\Filter\StripNewLines``:

.. _zend.filter.set.stripnewlines.basic:

Basic usage
-----------

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\StripNewLines();

   print $filter->filter(' This is (my)``\n\r``content: ');

The above example returns 'This is (my) content:'. Notice that all newline characters have been removed.

