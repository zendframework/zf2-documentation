.. EN-Revision: none
.. _zend.exception.previous:

Vorherige Exceptions
====================

Seit Zend Framework 1.10 implementiert ``Zend_Exception`` die Unterstützung von *PHP* 5.3 für vorgerige
Exceptions. Einfach gesagt, wenn man in einem ``catch`` ist, kann man eine neue Exception werfen welche auf die
vorherige Exception referenziert, was wiederum hilft indem zusätzlicher Kontext angeboten wird wenn man debuggt.
Indem diese Unterstützung im Zend Framework angeboten wird, ist der eigene Code jetzt vorwärts kompatibel mit
*PHP* 5.3.

Vorherige Exceptions werden als drittes Argument an den Contructor der Exceptions indiziert.

.. _zend.exception.previous.example:

.. rubric:: Vorherige Exceptions

.. code-block:: php
   :linenos:

   try {
       $db->query($sql);
   } catch (Zend\Db\Statement\Exception $e) {
       if ($e->getPrevious()) {
           echo '[' . get_class($e)
               . '] hat die vorherige Exception von ['
               . get_class($e->getPrevious())
               . ']' . PHP_EOL;
       } else {
           echo '[' . get_class($e)
               . '] hat keine vorherige Exception'
               . PHP_EOL;
       }

       echo $e;
       // zeigt alle Exceptions beginnend mit der ersten geworfenen
       // Exception wenn vorhanden.
   }


