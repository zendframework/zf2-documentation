.. EN-Revision: none
.. _zend.exception.using:

Používanie výnimiek
===================

Všetky výnimky generované triedami Zend Framework mali by byť odvodené od základnej triedy Zend_Exception.

.. _zend.exception.using.example:

.. rubric:: Príklad odchytenia výnimky

.. code-block:: php
   :linenos:

   <?php

   try {
       Zend\Loader\Loader::loadClass('NonExistentClass');
   } catch (Zend_Exception $e) {
       echo "Caught exception: " . get_class($e) . "\n";
       echo "Message: " . $e->getMessage() . "\n";
       // pokračovanie kódu pre zotavenie sa z chyby
   }

   ?>
Ku každej časti Zend Framework sú v dokumentácii uvedené informácie o metódach ktoré používajú výnimky,
informácie o dôvodoch generovania výnimiek a názvy tried ktoré sú odvodené od Zend_Exception.


