.. EN-Revision: none
.. _zend.version.reading:

Citirea versiunii de Zend Framework
===================================

Constata de clasă *Zend_Version::VERSION* conţine un text care identifică numărul versiunii curente de Zend
Framework. De exemplu: „0.9.0beta”.

Metoda statică *Zend_Version::compareVersion($version)* se bazează pe funcţia PHP `version_compare()`_. Această
metodă întoarce -1 dacă versiunea *$version* specificată este mai veche decât versiunea de Zend Framework, 0
dacă sunt aceleaşi, şi +1 dacă versiunea *$version* specificată este mai nouă decât versiunea de Zend
Framework.

.. _zend.version.reading.example:

.. rubric:: Examplu pentru metoda compareVersion()

.. code-block:: php
   :linenos:

   <?php
   // returns -1, 0 or 1
   $cmp = Zend_Version::compareVersion('1.0.0');



.. _`version_compare()`: http://php.net/version_compare
