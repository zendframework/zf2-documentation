
.. _zend.filter.set.basename:

BaseName
========

``Zend_Filter_BaseName`` allows you to filter a string which contains the path to a file and it will return the base name of this file.


.. _zend.filter.set.basename.options:

Supported options for Zend_Filter_BaseName
------------------------------------------

There are no additional options for ``Zend_Filter_BaseName``.


.. _zend.filter.set.basename.basic:

Basic usage
-----------

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_BaseName();

   print $filter->filter('/vol/tmp/filename');

This will return 'filename'.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_BaseName();

   print $filter->filter('/vol/tmp/filename.txt');

This will return '``filename.txt``'.


