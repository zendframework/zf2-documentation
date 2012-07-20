.. _zend.filter.set.stringtoupper:

StringToUpper
=============

Dieser Filter konvertiert alle Eingaben so das Sie großgeschrieben sind.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_StringToUpper();

   print $filter->filter('Sample');
   // gibt "SAMPLE" zurück

So wie der ``StringToLower`` Filter, kann dieser Filter nur jene Zeichen behandeln welche vom aktuellen
Gebietsschema des eigenen Servers unterstützt werden. Die Verwendung anderer Zeichensets funktioniert genauso wie
bei ``StringToLower``.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_StringToUpper(array('encoding' => 'UTF-8'));

   // oder im Nachhinein
   $filter->setEncoding('ISO-8859-1');


