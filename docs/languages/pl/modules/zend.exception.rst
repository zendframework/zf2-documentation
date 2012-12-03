.. EN-Revision: none
.. _zend.exception.using:

Użycie wyjątków
===============

Każdy wyjątek wyrzucany przez klasy Zend Framework powinien wyrzucać wyjątek, który rozszerza podstawową
klasę Zend_Exception.

.. _zend.exception.using.example:

.. rubric:: Przykład łapania wyjątku

.. code-block:: php
   :linenos:

   try {
       Zend\Loader\Loader::loadClass('NonExistentClass');
   } catch (Zend_Exception $e) {
       echo "Caught exception: " . get_class($e) . "\n";
       echo "Message: " . $e->getMessage() . "\n";
       // inny kod do obsługi błędu.
   }


Zobacz dokumentację dla poszczególnych komponentów Zend Framework aby uzyskać bardziej szczegółowe informacje
o tym, które metody wyrzucają wyjątki, jakie są okoliczności wyrzucenia wyjątku oraz które klasy wyjątków
pochodzą z klasy Zend_Exception.


