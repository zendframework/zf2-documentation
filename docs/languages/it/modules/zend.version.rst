.. EN-Revision: none
.. _zend.version.reading:

Lettura della versione del Framework Zend
=========================================

La costante di classe *Zend\Version\Version::VERSION* contiene una stringa che identifica il numero di versione corrente
del framework Zend. Per esempio, "0.9.0beta".

Il metodo statico *Zend\Version\Version::compareVersion($version)* è basato sulla funzione PHP `version_compare()`_.
Restituisce -1 se la versione indicata da *$version* è più datata della versione del Framework Zend, 0 se è la
stessa e +1 se la versione indicata da *$version* è più recente.

.. _zend.version.reading.example:

.. rubric:: Esempio del metodo compareVersion()

.. code-block:: php
   :linenos:

   <?php
   // restituisce -1, 0 o 1
   $cmp = Zend\Version\Version::compareVersion('1.0.0');



.. _`version_compare()`: http://php.net/version_compare
