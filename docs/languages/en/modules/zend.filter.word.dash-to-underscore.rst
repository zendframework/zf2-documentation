.. _zend.filter.set.dashtounderscore:

Word\\DashToUnderscore
======================

This filter modifies a given string such that 'words-with-dashes' are converted to 'words_with_dashes'.

.. _zend.filter.set.dashtounderscore.options:

Supported options for Zend\\Filter\\Word\\DashToUnderscore
----------------------------------------------------------

There are no additional options for ``Zend\Filter\Word\DashToUnderscore``:

.. _zend.filter.set.dashtounderscore.basic:

Basic usage
-----------

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Word\DashToUnderscore();

   print $filter->filter('this-is-my-content');

The above example returns 'this_is_my_content'.
