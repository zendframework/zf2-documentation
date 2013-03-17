.. EN-Revision: none
.. _zend.exception.using:

Uso de Excepciones
==================

``Zend_Exception`` es simplemente la clase base para todos los las excepciones lanzadas dentro de Zend Framework.

.. _zend.exception.using.example:

.. rubric:: Capturando una Excepcion

El siguiente listado de código muestra como capturar una excepción lanzado en Zend Framework:

.. code-block:: php
   :linenos:

   try {
       // Calling Zend\Loader\Loader::loadClass() with a non-existant class will cause
       // an exception to be thrown in Zend_Loader;
       Zend\Loader\Loader::loadClass('NonExistentClass');
   } catch (Zend_Exception $e) {
       echo "Caught exception: " . get_class($e) . "\n";
       echo "Message: " . $e->getMessage() . "\n";
       // Other code to recover from the error
   }

``Zend_Exception`` can be used as a catch-all exception class in a catch block to trap all exceptions thrown by
Zend Framework classes. This can be useful when the program can not recover by catching a specific exception type.

La documentación de cada componente y clase de Zend Framework contienen información específica sobre los
métodos que generan excepciones, las circunstancias en que puedes ser lanzadas, y los
diferentes tipos de excepciones que puede ser lanzadas.


