.. EN-Revision: none
.. _zend.exception.using:

Uitzonderingen gebruiken
========================

Alle uitzonderingen gegooid door een Zend Framework klasse zouden een uitzondering moeten gooien die afstamt van de
basis klasse Zend_Exception.

.. _zend.exception.using.example:

.. rubric:: Voorbeeld van het vangen van een uitzondering

.. code-block:: php
   :linenos:

   <?php

   try {
       Zend\Loader\Loader::loadClass('nietbestaandeklasse');
   } catch (Zend_Exception $e) {
       echo "Gevangen uitzondering: " . get_class($e) . "\n";
       echo "Bericht: " . $e->getMessage() . "\n";
       // andere code om the herstellen van deze fout
   }
Zie de documentatie van elk Zend Framework component voor meer specifieke informatie over welke methodes
uitzonderingen gooien, de omstandigheden van de uitzondering en welke uitzondering klasse afstamt van
Zend_Exception.


