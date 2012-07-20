.. _zend.filter.set.realpath:

RealPath
========

Dieser Filter löst gegebene Links und Pfadnamen auf und gibt kanonische absolute Pfadnamen zurück. Referenzen zu
'``/./``', '``/../``' und extra '``/``' Zeichen im Eingabepfad werden entfernt. Der Ergebnispfad hat keine
symbolischen Links, '``/./``' oder '``/../``' Zeichen mehr.

``Zend_Filter_RealPath`` gibt bei einem Fehler ``FALSE`` zurück, z.B. wenn die Datei nicht existiert. Auf *BSD*
Systemen schlägt ``Zend_Filter_RealPath`` nicht fehl wenn nur die letzte Komponente des Pfades nicht existiert,
wärend andere Systeme ``FALSE`` zurückgeben.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_RealPath();
   $path   = '/www/var/path/../../mypath';
   $filtered = $filter->filter($path);

   // Gibt '/www/mypath' zurück

Manchmal ist es auch nützlich einen Pfad zu erhalten wenn diese nicht existiert, z.B. wenn man den echten Pfad
für einen Pfad erhalten will den man erstellt. Man kann entweder ein ``FALSE`` bei der Initialisierung angeben,
oder ``setExists()`` verwenden um es zu setzen.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_RealPath(false);
   $path   = '/www/var/path/../../non/existing/path';
   $filtered = $filter->filter($path);

   // Gibt '/www/non/existing/path' zurück, selbst wenn
   // file_exists oder realpath false zurückgeben würden


