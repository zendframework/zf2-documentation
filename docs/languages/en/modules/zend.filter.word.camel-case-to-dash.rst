.. _zend.filter.set.camelcasetodash:

CamelCaseToDash
---------------

This filter modifies a given string such that 'CamelCaseWords' are converted to 'Camel-Case-Words'.

.. _zend.filter.set.camelcasetodash.options:

.. rubric:: Supported Options

There are no additional options for ``Zend\Filter\Word\CamelCaseToDash``:

.. _zend.filter.set.camelcasetodash.basic:

.. rubric:: Basic Usage

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Word\CamelCaseToDash();

   print $filter->filter('ThisIsMyContent');

The above example returns 'This-Is-My-Content'.
