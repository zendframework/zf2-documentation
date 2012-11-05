.. EN-Revision: none
.. _zend.exception.using:

Usando as Exceções
==================

``Zend_Exception`` é simplesmente a classe base para todas as exceções lançadas dentro do Zend Framework.

.. _zend.exception.using.example:

.. rubric:: Tratando uma Exceção

O código a seguir demonstra como tratar uma exceção lançada em uma classe do Zend Framework:

.. code-block:: php
   :linenos:

   try {
       // Chamar Zend\Loader\Loader::loadClass() com uma classe inexistente irá causar
       // uma exceção para ser lançada em Zend\Loader\Loader:
       Zend\Loader\Loader::loadClass('nonexistantclass');
   } catch (Zend_Exception $e) {
       echo "Tratando a exceção: " . get_class($e) . "\n";
       echo "Mensagem: " . $e->getMessage() . "\n";
       // Outro código para recuperar do erro
   }

``Zend_Exception`` pode ser usado como uma classe de exceção pega-tudo em um bloco de tratamento para capturar
todas as exceções lançadas pelas classes do Zend Framework. Isso pode ser útil quando o programa não consegue
se recuperar através do tratamento de um tipo específico de exceção.

A documentação de cada componente e classe do Zend Framework irá conter informações específicas sobre os
métodos para lançar exceções, as circunstâncias que fazem com que uma exceção seja lançada, e os diversos
tipos de exceção que podem ser lançadas.


