.. EN-Revision: none
.. _zend.filter.set.basename:

BaseName
========

``Zend\Filter\BaseName`` erlaubt es einen String zu filtern welcher den Pfad zu einer Daten enthält und gibt den
Basisnamen dieser Datei zurück.

.. _zend.filter.set.basename.options:

Unterstützte Optionen für Zend\Filter\BaseName
----------------------------------------------

Es gibt keine zusätzlichen Optionen für ``Zend\Filter\BaseName``.

.. _zend.filter.set.basename.basic:

Einfache Verwendung
-------------------

Ein einfaches Beispiel der Verwendung ist nachfolgend zu finden:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\BaseName();

   print $filter->filter('/vol/tmp/filename');

Das gibt 'filename' zurück.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\BaseName();

   print $filter->filter('/vol/tmp/filename.txt');

Das gibt '``filename.txt``' zurück.


