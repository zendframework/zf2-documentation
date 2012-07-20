.. _zend.filter.set.dir:

Dir
===

Ein angegebener String welcher den Pfad zu einer Datei enthält wird von dieser Funktion nur den Namen des
Verzeichnisses zurückgeben.

.. _zend.filter.set.dir.options:

Unterstützte Optionen für Zend_Filter_Dir
-----------------------------------------

Es gibt keine zusätzlichen Optionen für ``Zend_Filter_Dir``.

.. _zend.filter.set.dir.basic:

Einfache Verwendung
-------------------

Ein einfaches Beispiel der Verwendung ist nachfolgend zu finden:

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_Dir();

   print $filter->filter('/etc/passwd');

Dies gibt "``/etc``" zurück.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_Dir();

   print $filter->filter('C:/Temp/x');

Dies gibt "``C:/Temp``" zurück.


