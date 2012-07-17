
.. _zend.filter.set.stringtrim:

StringTrim
==========

This filter modifies a given string such that certain characters are removed from the beginning and end.


.. _zend.filter.set.stringtrim.options:

Supported options for Zend_Filter_StringTrim
--------------------------------------------

The following options are supported for ``Zend_Filter_StringTrim``:

- **charlist**: List of characters to remove from the beginning and end of the string. If this is not set or is null, the default behavior will be invoked, which is to remove only whitespace from the beginning and end of the string.


.. _zend.filter.set.stringtrim.basic:

Basic usage
-----------

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_StringTrim();

   print $filter->filter(' This is (my) content: ');

The above example returns 'This is (my) content:'. Notice that the whitespace characters have been removed.


.. _zend.filter.set.stringtrim.types:

Default behaviour for Zend_Filter_StringTrim
--------------------------------------------

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_StringTrim(':');
   // or new Zend_Filter_StringTrim(array('charlist' => ':'));

   print $filter->filter(' This is (my) content:');

The above example returns 'This is (my) content'. Notice that the whitespace characters and colon are removed. You can also provide an instance of ``Zend_Config`` or an array with a 'charlist' key. To set the desired character list after instantiation, use the ``setCharList()`` method. The ``getCharList()`` return the values set for charlist.


