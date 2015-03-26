.. _zend.filter.set.int:

ToInt
-----

``Zend\Filter\ToInt`` allows you to transform a scalar value which contains into an integer.

.. _zend.filter.set.int.options:

Supported Options
^^^^^^^^^^^^^^^^^

There are no additional options for ``Zend\Filter\ToInt``.

.. _zend.filter.set.int.basic:

Basic Usage
^^^^^^^^^^^

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\ToInt();

   print $filter->filter('-4 is less than 0');

This will return '-4'.

Migration from 2.0-2.3 to 2.4+
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Version 2.4 adds support for PHP 7. In PHP 7, ``int`` is a reserved keyword,
which required renaming the ``Int`` filter. If you were using the ``Int`` filter
directly previously, you will now receive an ``E_USER_DEPRECATED`` notice on
instantiation. Please update your code to refer to the ``ToInt`` class instead.

Users pulling their ``Int`` filter instance from the filter plugin manager
receive a ``ToInt`` instance instead starting in 2.4.0.
