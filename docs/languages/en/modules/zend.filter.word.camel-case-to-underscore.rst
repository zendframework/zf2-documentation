.. _zend.filter.set.camelcasetounderscore:

CamelCaseToUnderscore
---------------------

This filter modifies a given string such that 'CamelCaseWords' are converted to 'Camel_Case_Words'.

.. _zend.filter.set.camelcasetounderscore.options:

.. rubric:: Supported Options

There are no additional options for ``Zend\Filter\Word\CamelCaseToUnderscore``:

.. _zend.filter.set.camelcasetounderscore.basic:

.. rubric:: Basic usage

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Word\CamelCaseToUnderscore();

   print $filter->filter('ThisIsMyContent');

The above example returns 'This_Is_My_Content'.
