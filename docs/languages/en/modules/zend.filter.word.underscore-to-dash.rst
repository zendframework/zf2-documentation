.. _zend.filter.set.underscoretodash:

UnderscoreToDash
----------------

This filter modifies a given string such that 'words_with_underscores' are converted to 'words-with-underscores'.

.. _zend.filter.set.underscoretodash.options:

.. rubric:: Supported Options

There are no additional options for ``Zend\Filter\Word\UnderscoreToDash``:

.. _zend.filter.set.underscoretodash.basic:

.. rubric:: Basic usage

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Word\UnderscoreToDash();

   print $filter->filter('this_is_my_content');

The above example returns 'this-is-my-content'.
