.. _zend.filter.set.separatortoseparator:

SeparatorToSeparator
--------------------

This filter modifies a given string such that 'words with separators' are converted to 'words-with-separators'.

.. _zend.filter.set.separatortoseparator.options:

.. rubric:: Supported Options

The following options are supported for ``Zend\Filter\Word\SeparatorToSeparator``:

- **searchSeparator**: The search separator char. If this is not set the separator will be a space character.

- **replaceSeparator**: The replace separator char. If this is not set the separator will be a dash.

.. _zend.filter.set.separatortoseparator.basic:

.. rubric:: Basic Usage

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Word\SeparatorToSeparator(':', '+');

   print $filter->filter('this:is:my:content');

The above example returns 'this+is+my+content'.

.. rubric:: Default Behaviour

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Word\SeparatorToSeparator();

   print $filter->filter('this is my content');

The above example returns 'this-is-my-content'.

