.. _zend.filter.set.underscoretoseparator:

Word\\UnderscoreToSeparator
===========================

This filter modifies a given string such that 'words_with_underscorees' are converted to 'words with underscorees'.

.. _zend.filter.set.underscoretoseparator.options:

Supported options for Zend\\Filter\\Word\\UnderscoreToSeparator
---------------------------------------------------------------

The following options are supported for ``Zend\Filter\Word\UnderscoreToSeparator``:

- **separator**: A separator char. If this is not set the separator will be a space character.

.. _zend.filter.set.underscoretoseparator.basic:

Basic usage
-----------

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Word\UnderscoreToSeparator('+');
   // or new Zend\Filter\Word\CamelCaseToSeparator(array('separator' => '+'));

   print $filter->filter('this_is_my_content');

The above example returns 'this+is+my+content'.

Default behaviour for Zend\\Filter\\Word\\UnderscoreToSeparator
---------------------------------------------------------------

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Word\UnderscoreToSeparator();

   print $filter->filter('this_is_my_content');

The above example returns 'this is my content'.

