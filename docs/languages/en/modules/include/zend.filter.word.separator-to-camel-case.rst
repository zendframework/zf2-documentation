.. _zend.filter.set.separatortocamelcase:

SeparatorToCamelCase
--------------------

This filter modifies a given string such that 'words with separators' are converted to 'WordsWithSeparators'.

.. _zend.filter.set.separatortocamelcase.options:

.. rubric:: Supported Options

The following options are supported for ``Zend\Filter\Word\SeparatorToCamelCase``:

- **separator**: A separator char. If this is not set the separator will be a space character.

.. _zend.filter.set.separatortocamelcase.basic:

.. rubric:: Basic Usage

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Word\SeparatorToCamelCase(':');
   // or new Zend\Filter\Word\SeparatorToCamelCase(array('separator' => ':'));

   print $filter->filter('this:is:my:content');

The above example returns 'ThisIsMyContent'.

.. rubric:: Default Behavior

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Word\SeparatorToCamelCase();

   print $filter->filter('this is my content');

The above example returns 'ThisIsMyContent'.

