.. _zend.filter.set.basename:

BaseName
========

``Zend_Filter_BaseName`` erlaubt es einen String zu filtern welcher den Pfad zu einer Daten enthält und gibt den
Basisnamen dieser Datei zurück.

.. _zend.filter.set.basename.options:

Unterstützte Optionen für Zend_Filter_BaseName
----------------------------------------------

Es gibt keine zusätzlichen Optionen für ``Zend_Filter_BaseName``.

.. _zend.filter.set.basename.basic:

Einfache Verwendung
-------------------

Ein einfaches Beispiel der Verwendung ist nachfolgend zu finden:

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_BaseName();

   print $filter->filter('/vol/tmp/filename');

Das gibt 'filename' zurück.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_BaseName();

   print $filter->filter('/vol/tmp/filename.txt');

Das gibt '``filename.txt``' zurück.


