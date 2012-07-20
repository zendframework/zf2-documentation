.. _zend.filter.set.stringtoupper:

StringToUpper
=============

Ce filtre convertit toute entrée vers une casse majuscule.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_StringToUpper();

   print $filter->filter('Sample');
   // retourne "SAMPLE"

Tout comme le filtre ``StringToLower``, seul le jeu de caractères de la locale en cours sera utilisé. Son
fonctionnement est le même que celui de ``StringToLower``.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_StringToUpper(array('encoding' => 'UTF-8'));

   // ou encore
   $filter->setEncoding('ISO-8859-1');


