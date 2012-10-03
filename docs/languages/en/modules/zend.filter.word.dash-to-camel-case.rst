.. _zend.filter.set.dashtocamelcase:

Word\\DashToCamelCase
=====================

This filter modifies a given string such that 'words-with-dashes' are converted to 'WordsWithDashes'.

.. _zend.filter.set.dashtocamelcase.options:

Supported options for Zend\\Filter\\Word\\DashToCamelCase
---------------------------------------------------------

There are no additional options for ``Zend\Filter\Word\DashToCamelCase``:

.. _zend.filter.set.dashtocamelcase.basic:

Basic usage
-----------

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Word\DashToCamelCase();

   print $filter->filter('this-is-my-content');

The above example returns 'ThisIsMyContent'.
