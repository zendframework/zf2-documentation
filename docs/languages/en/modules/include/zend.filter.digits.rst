.. _zend.filter.set.digits:

Digits
------

Returns the string ``$value``, removing all but digits.

.. _zend.filter.set.digits.options:

.. rubric:: Supported Options

There are no additional options for ``Zend\Filter\Digits``.

.. _zend.filter.set.digits.basic:

.. rubric:: Basic Usage

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Digits();

   print $filter->filter('October 2012');

This returns "2012".

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Digits();

   print $filter->filter('HTML 5 for Dummies');

This returns "5".


