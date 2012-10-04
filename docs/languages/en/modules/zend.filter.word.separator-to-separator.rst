.. _zend.filter.set.separatortoseparator:

Word\\SeparatorToSeparator
==========================

This filter modifies a given string such that 'words with separators' are converted to 'words-with-separators'.

.. _zend.filter.set.separatortoseparator.options:

Supported options for Zend\\Filter\\Word\\SeparatorToSeparator
--------------------------------------------------------------

The following options are supported for ``Zend\Filter\Word\SeparatorToSeparator``:

- **searchSeparator**: The search separator char. If this is not set the separator will be a space character.

- **replaceSeparator**: The replace separator char. If this is not set the separator will be a dash.

.. _zend.filter.set.separatortoseparator.basic:

Basic usage
-----------

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Word\SeparatorToSeparator(':', '+');

   print $filter->filter('this:is:my:content');

The above example returns 'this+is+my+content'.

Default behaviour for Zend\\Filter\\Word\\SeparatorToSeparator
--------------------------------------------------------------

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Word\SeparatorToSeparator();

   print $filter->filter('this is my content');

The above example returns 'this-is-my-content'.

