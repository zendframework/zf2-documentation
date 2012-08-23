.. EN-Revision: none
.. _zend.filter.set.int:

Int
===

``Zend_Filter_Int`` erlaubt es einen skalaren Wert in einen Integer Wert zu konvertieren.

.. _zend.filter.set.int.options:

Unterstützte Optionen für Zend_Filter_Int
-----------------------------------------

Es gibt keine zusätzlichen Optionen für ``Zend_Filter_Int``.

.. _zend.filter.set.int.basic:

Einfache Verwendung
-------------------

Ein einfaches Beispiel der Verwendung ist nachfolgend zu finden:

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_Int();

   print $filter->filter('-4 ist weniger als 0');

Das gibt '-4' zurück.


