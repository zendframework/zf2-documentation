.. _zend.filter.set.dir:

Dir
===

Given a string containing a path to a file, this function will return the name of the directory.

.. _zend.filter.set.dir.options:

Supported options for Zend\Filter\Dir
-------------------------------------

There are no additional options for ``Zend\Filter\Dir``.

.. _zend.filter.set.dir.basic:

Basic usage
-----------

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Dir();

   print $filter->filter('/etc/passwd');

This returns "``/etc``".

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Dir();

   print $filter->filter('C:/Temp/x');

This returns "``C:/Temp``".


