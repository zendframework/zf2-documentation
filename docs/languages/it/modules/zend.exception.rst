.. EN-Revision: none
.. _zend.exception.using:

Utilizzo delle eccezioni
========================

Tutte le eccezioni lanciate dalle classi del Framework Zend dovrebbero estendere la classe base Zend_Exception.

.. _zend.exception.using.example:

.. rubric:: Gestione di un'eccezione

Il codice seguente dimostra come gestire un'eccezione lanciata all'interno di una classe del Framework Zend:

.. code-block:: php
   :linenos:

   try {
       // La chiamata a Zend\Loader\Loader::loadClass() con una classe non esistente
       // causa il lancio di un'eccezione in Zend_Loader
       Zend\Loader\Loader::loadClass('classenonesistente');
   } catch (Zend_Exception $e) {
       echo "Catturata eccezione: " . get_class($e) . "\n";
       echo "Messaggio: " . $e->getMessage() . "\n";
       // Altro codice necessario per gestire l'errore
   }


The documentation for each Zend Framework component and class will contain specific information on which methods
throw exceptions, the circumstances that cause an exception to be thrown, and the class of all exceptions that may
be thrown.

La documentazione di ogni componente e classe del Framework Zend contiene informazioni specifiche su quali metodi
lanciano un'eccezione, le circostanze che possono causare l'errore e le classi per tutte le eccezioni che possono
essere lanciate.


