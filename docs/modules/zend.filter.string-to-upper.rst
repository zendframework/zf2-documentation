
StringToUpper
=============

This filter converts any input to be uppercased.

.. _zend.filter.set.stringtoupper.options:

Supported options for Zend_Filter_StringToUpper
-----------------------------------------------

The following options are supported for ``Zend_Filter_StringToUpper`` :

    - encoding: This option can be used to
    - set an encoding which has to be used.


.. _zend.filter.set.stringtoupper.basic:

Basic usage
-----------

This is a basic example for using the ``StringToUpper`` filter:

.. code-block:: php
    :linenos:
    
    $filter = new Zend_Filter_StringToUpper();
    
    print $filter->filter('Sample');
    // returns "SAMPLE"
    

.. _zend.filter.set.stringtoupper.encoding:

Different encoded strings
-------------------------

Like the ``StringToLower`` filter, this filter handles only characters from the actual locale of your server. Using different character sets works the same as with ``StringToLower`` .

.. code-block:: php
    :linenos:
    
    $filter = new Zend_Filter_StringToUpper(array('encoding' => 'UTF-8'));
    
    // or do this afterwards
    $filter->setEncoding('ISO-8859-1');
    


