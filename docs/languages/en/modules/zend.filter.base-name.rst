.. _zend.filter.set.basename:

BaseName
--------

``Zend\Filter\BaseName`` allows you to filter a string which contains the path to a file and it will return the
base name of this file.

.. _zend.filter.set.basename.options:

.. rubric:: Supported Options

There are no additional options for ``Zend\Filter\BaseName``.

.. _zend.filter.set.basename.basic:

.. rubric:: Basic Usage

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\BaseName();

   print $filter->filter('/vol/tmp/filename');

This will return 'filename'.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\BaseName();

   print $filter->filter('/vol/tmp/filename.txt');

This will return '``filename.txt``'.


