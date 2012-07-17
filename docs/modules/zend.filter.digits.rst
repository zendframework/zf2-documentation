
.. _zend.filter.set.digits:

Digits
======

Returns the string ``$value``, removing all but digits.


.. _zend.filter.set.digits.options:

Supported options for Zend_Filter_Digits
----------------------------------------

There are no additional options for ``Zend_Filter_Digits``.


.. _zend.filter.set.digits.basic:

Basic usage
-----------

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_Digits();

   print $filter->filter('October 2009');

This returns "2009".

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_Digits();

   print $filter->filter('HTML 5 for Dummies');

This returns "5".


