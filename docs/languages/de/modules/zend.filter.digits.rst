.. EN-Revision: none
.. _zend.filter.set.digits:

Digits
======

Gibt den String ``$value`` zurück und entfernt alle ausser Ziffern.

.. _zend.filter.set.digits.options:

Unterstützte Optionen für Zend_Filter_Digits
--------------------------------------------

Es gibt keine zusätzlichen Optionen für ``Zend_Filter_Digits``.

.. _zend.filter.set.digits.basic:

Einfache Verwendung
-------------------

Ein einfaches Beispiel der Verwendung ist nachfolgend zu finden:

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_Digits();

   print $filter->filter('October 2009');

Dies gibt "2009" zurück.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_Digits();

   print $filter->filter('HTML 5 für Dummies');

Dies gibt "5" zurück.


