.. _zend.filter.set.camelcasetoseparator:

CamelCaseToSeparator
--------------------

This filter modifies a given string such that 'CamelCaseWords' are converted to 'Camel Case Words'.

.. _zend.filter.set.camelcasetoseparator.options:

.. rubric:: Supported Options

The following options are supported for ``Zend\Filter\Word\CamelCaseToSeparator``:

- **separator**: A separator char. If this is not set the separator will be a space character.

.. _zend.filter.set.camelcasetoseparator.basic:

.. rubric:: Basic Usage

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Word\CamelCaseToSeparator(':');
   // or new Zend\Filter\Word\CamelCaseToSeparator(array('separator' => ':'));

   print $filter->filter('ThisIsMyContent');

The above example returns 'This:Is:My:Content'.

.. rubric:: Default Behavior

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Word\CamelCaseToSeparator();

   print $filter->filter('ThisIsMyContent');

The above example returns 'This Is My Content'.

