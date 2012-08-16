.. EN-Revision: none
.. _zend.filter.set.stringtolower:

StringToLower
=============

Dieser Filter konvertiert alle Eingabe so das Sie kleingeschrieben sind.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_StringToLower();

   print $filter->filter('SAMPLE');
   // gibt "sample" zurück

Standardmäßig behandelt er nur Zeichen aus dem aktuellen Gebietsschema des eigenen Servers. Zeichen von anderen
Zeichensets werden ignoriert. Trotzdem ist es möglich auch diese, mit der mbstring Erweiterung, kleinzuschreiben
wenn diese in der eigenen Umgebung vorhanden ist. Es muß, bei der Initialisierung des ``StringToLower`` Filters,
einfach die gewünschte Kodierung angegeben werden. Oder man verwendet die ``setEncoding()`` Methode, um die
Kodierung im Nachhinein zu ändern.

.. code-block:: php
   :linenos:

   // Verwendung von UTF-8
   $filter = new Zend_Filter_StringToLower('UTF-8');

   // Oder ein Array angeben was bei der Verwendung einer
   // Konfiguration nützlich sein kann
   $filter = new Zend_Filter_StringToLower(array('encoding' => 'UTF-8'));

   // Oder im Nachinein
   $filter->setEncoding('ISO-8859-1');

.. note::

   **Falsche Kodierungen setzen**

   Man sollte darauf achten das man eine Exception bekommt wenn man eine Kodierung setzt, solange die mbstring
   Erweiterung in der eigenen Umgebung nicht vorhanden ist.

   Auch wenn man eine Kodierung setzt, welche von der mbstring Erweiterung nicht unterstützt wird, erhält man
   eine Exception.


