:orphan:

.. _zend.filter.set.stripnewlines:

StripNewlines
-------------

This filter modifies a given string and removes all new line characters within that string.

.. _zend.filter.set.stripnewlines.options:

Supported Options
^^^^^^^^^^^^^^^^^

There are no additional options for ``Zend\Filter\StripNewlines``:

.. _zend.filter.set.stripnewlines.basic:

Basic Usage
^^^^^^^^^^^

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\StripNewlines();

   print $filter->filter(' This is (my)``\n\r``content: ');

The above example returns 'This is (my) content:'. Notice that all newline characters have been removed.

