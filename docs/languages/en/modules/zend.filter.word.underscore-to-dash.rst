.. _zend.filter.set.underscoretodash:

Word\\UnderscoreToDash
----------------------

This filter modifies a given string such that 'words_with_underscores' are converted to 'words-with-underscores'.

.. _zend.filter.set.underscoretodash.options:

Supported options for Zend\\Filter\\Word\\UnderscoreToDash
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There are no additional options for ``Zend\Filter\Word\UnderscoreToDash``:

.. _zend.filter.set.underscoretodash.basic:

Basic usage
^^^^^^^^^^^

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Word\UnderscoreToDash();

   print $filter->filter('this_is_my_content');

The above example returns 'this-is-my-content'.
