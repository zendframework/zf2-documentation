.. _zend.exception.basic:

Grundsätzliche Verwendung
=========================

``Zend_Exception`` ist die Basisklasse für alle Exceptions die von Zend Framework geworfen werden. Diese Klasse
erweitert die grundsätzliche ``Exception`` Klasse von *PHP*.

.. _zend.exception.catchall.example:

.. rubric:: Alle Zend Framework Exceptions fangen

.. code-block:: php
   :linenos:

   try {
       // eigener Code
   } catch (Zend_Exception $e) {
       // mach was
   }

.. _zend.exception.catchcomponent.example:

.. rubric:: Exceptions fangen die von einer speziellen Komponente von Zend Framework geworfen werden

.. code-block:: php
   :linenos:

   try {
       // eigener Code
   } catch (Zend_Db_Exception $e) {
       // mach was
   }


