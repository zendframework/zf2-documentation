.. _zend.exception.using:

Práce s výjimkami
=================

Všechny výjimky vyhozené v Zend Frameworku by měly být odvozeny od hlavní třídy Zend_Exception.

.. _zend.exception.using.example:

.. rubric:: Příklad zachycení výjimky

.. code-block::
   :linenos:
   <?php
   try {
       Zend_Loader::loadClass('neexistujicitrida');
   } catch (Zend_Exception $e) {
       echo "Zachycená výjimka: " . get_class($e) . "\n";
       echo "Zpráva: " . $e->getMessage() . "\n";
       // další kód, který se vykoná při chybě
   }
   ?>
Pro více informací o výjimkách se podívejte do dokumentace k příslušné knihovně Zend Frameworku. Najdete
informace metodach, které výjimky vyhazují a za jakých okolností se tak děje a které výjimky jsou zděděny
z hlavní výjimky - Zend_Exception.


