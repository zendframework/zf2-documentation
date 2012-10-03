.. _zend.filter.set.camelcasetodash:

Word\\CamelCaseToDash
=====================

This filter modifies a given string such that 'CamelCaseWords' are converted to 'camel-case-words'.

.. _zend.filter.set.camelcasetodash.options:

Supported options for Zend\\Filter\\Word\\CamelCaseToDash
---------------------------------------------------------

There are no additional options for ``Zend\Filter\Word\CamelCaseToDash``:

.. _zend.filter.set.camelcasetodash.basic:

Basic usage
-----------

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Word\CamelCaseToDash();

   print $filter->filter('ThisIsMyContent');

The above example returns 'this-is-my-content'.
