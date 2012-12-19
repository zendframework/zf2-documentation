.. _zend.filter.set.camelcasetounderscore:

CamelCaseToUnderscore
---------------------

This filter modifies a given string such that 'CamelCaseWords' are converted to 'camel_case_words'.

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

The above example returns 'this_is_my_content'.
