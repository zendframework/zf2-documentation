
Int
===

``Zend_Filter_Int`` allows you to transform a sclar value which contains into an integer.

.. _zend.filter.set.int.options:

Supported options for Zend_Filter_Int
-------------------------------------

There are no additional options for ``Zend_Filter_Int`` .

.. _zend.filter.set.int.basic:

Basic usage
-----------

A basic example of usage is below:

.. code-block:: php
    :linenos:
    
    $filter = new Zend_Filter_Int();
    
    print $filter->filter('-4 is less than 0');
    

This will return '-4'.


