.. _zend.filter.set.separatortodash:

SeparatorToDash
---------------

This filter modifies a given string such that 'words with separators' are converted to 'words-with-separators'.

.. _zend.filter.set.separatortodash.options:

.. rubric:: Supported Options

The following options are supported for ``Zend\Filter\Word\SeparatorToDash``:

- **separator**: A separator char. If this is not set the separator will be a space character.

.. _zend.filter.set.separatortodash.basic:

.. rubric:: Basic Usage

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Word\SeparatorToDash(':');
   // or new Zend\Filter\Word\SeparatorToDash(array('separator' => ':'));

   print $filter->filter('this:is:my:content');

The above example returns 'this-is-my-content'.

.. rubric:: Default Behavior

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Word\SeparatorToDash();

   print $filter->filter('this is my content');

The above example returns 'this-is-my-content'.

