.. _zend.filter.set.underscoretocamelcase:

Word\\UnderscoreToCamelCase
===========================

This filter modifies a given string such that 'words_with_underscores' are converted to 'WordsWithUnderscores'.

.. _zend.filter.set.underscoretocamelcase.options:

Supported options for Zend\\Filter\\Word\\UnderscoreToCamelCase
---------------------------------------------------------------

There are no additional options for ``Zend\Filter\Word\UnderscoreToCamelCase``:

.. _zend.filter.set.underscoretocamelcase.basic:

Basic usage
-----------

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Word\UnderscoreToCamelCase();

   print $filter->filter('this_is_my_content');

The above example returns 'ThisIsMyContent'.
