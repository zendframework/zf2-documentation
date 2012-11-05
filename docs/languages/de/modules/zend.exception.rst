.. EN-Revision: none
.. _zend.exception.using:

Verwenden von Ausnahmen
=======================

``Zend_Exception`` ist einfach die Basisklasse für alle Exceptions die vom Zend Framework geworfen werden.

.. _zend.exception.using.example:

.. rubric:: Fangen einer Exception

Das folgende Code Beispiel demonstriert wie eine Exception gefangen werden kann die in einer Zend Framework Klasse
geworfen wird:

.. code-block:: php
   :linenos:

   try {
       // Der Aufruf von Zend\Loader\Loader::loadClass() mit einer nicht-existierenden
       // Klasse wird eine Exception in Zend_Loader werfen:
       Zend\Loader\Loader::loadClass('nonexistantclass');
   } catch (Zend_Exception $e) {
       echo "Gefangene Exception: " . get_class($e) . "\n";
       echo "Nachricht: " . $e->getMessage() . "\n";
       // anderer Code um den Fehler zu korrigieren.
   }

``Zend_Exception`` kann als fang-sie-alle Exception Klasse in einem Catch Block verwendet werden um alle
Exceptions, die von Zend Framework Klassen geworfen werden, zu fangen. Das kann nützlich sein wenn das Programm,
durch das Fangen eines speziellen Exception Typs, nicht wiederhergestellt werden kann.

Die Dokumentation der einzelnen Zend Framework Komponenten und Klassen enthält spezielle Informationen darüber
welche Methoden Exceptions werfen, die Gründe die dazu führen das eine Exception geworfen wird, und die
verschiedenen Exception Typen die geworfen werden können.


