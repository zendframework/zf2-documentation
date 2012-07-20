.. _zend.exception.basic:

Uso básico
==========

``Zend_Exception`` é a classe base para todas as exceções lançadas pelo Zend Framework. Esta classe estende a
parte essencial da classe ``Exception`` do *PHP*.

.. _zend.exception.catchall.example:

.. rubric:: Tratando todas as exceções do Zend Framework

.. code-block:: php
   :linenos:

   try {
       // seu código
   } catch (Zend_Exception $e) {
       // faça alguma coisa
   }

.. _zend.exception.catchcomponent.example:

.. rubric:: Tratando as excepções lançadas por um componente específico do Zend Framework

.. code-block:: php
   :linenos:

   try {
       // seu código
   } catch (Zend_Db_Exception $e) {
       // faça alguma coisa
   }


