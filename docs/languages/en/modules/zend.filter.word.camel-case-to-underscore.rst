.. _zend.filter.set.camelcasetounderscore:

Word\\CamelCaseToUnderscore
===========================

This filter modifies a given string such that 'CamelCaseWords' are converted to 'camel_case_words'.

.. _zend.filter.set.camelcasetounderscore.options:

Supported options for Zend\\Filter\\Word\\CamelCaseToUnderscore
---------------------------------------------------------------

There are no additional options for ``Zend\Filter\Word\CamelCaseToUnderscore``:

.. _zend.filter.set.camelcasetounderscore.basic:

Basic usage
-----------

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Word\CamelCaseToUnderscore();

   print $filter->filter('ThisIsMyContent');

The above example returns 'this_is_my_content'.
