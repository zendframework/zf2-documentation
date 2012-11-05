.. EN-Revision: none
.. _zend.exception.using:

Использование исключений
========================

Все исключения, бросаемые классами Zend Framework, должны быть
наследниками основного класса Zend_Exception.

.. _zend.exception.using.example:

.. rubric:: Пример отлова исключения

.. code-block:: php
   :linenos:

   try {
       Zend\Loader\Loader::loadClass('nonexistantclass');
   } catch (Zend_Exception $e) {
       echo "Caught exception: " . get_class($e) . "\n";
       echo "Message: " . $e->getMessage() . "\n";
       // other code to recover from the failure.
   }


Более детальную информацию о том, какие методы могут бросать
исключения, условия, при которых бросаются исключения, и о том,
какие классы исключений наследуют от Zend_Exception, можно найти в
документации по соответсвующей компоненте Zend Framework.


