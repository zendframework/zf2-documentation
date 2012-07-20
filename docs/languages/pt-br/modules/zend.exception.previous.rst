.. _zend.exception.previous:

Exceções Precedentes
====================

Desde o Zend Framework 1.10, ``Zend_Exception`` implementa às exceções precedentes do *PHP* 5.3. Simplificando,
em um bloco ``catch()``, você pode lançar uma nova exceção que faz referência à exceção original, ajudando
a fornecer contexto adicional na depuração. Ao fornecer este suporte no Zend Framework, seu código agora poderá
avançar na compatibilidade com o *PHP* 5.3.

Exceções precedentes são indicadas como o terceiro argumento para um construtor de exceção.

.. _zend.exception.previous.example:

.. rubric:: Exceções precedentes

.. code-block:: php
   :linenos:

   try {
       $db->query($sql);
   } catch (Zend_Db_Statement_Exception $e) {
       if ($e->getPrevious()) {
           echo '[' . get_class($e)
               . '] possui a exceção precedente de ['
               . get_class($e->getPrevious())
               . ']' . PHP_EOL;
       } else {
           echo '[' . get_class($e)
               . '] não possui uma exceção precedente'
               . PHP_EOL;
       }

       echo $e;
       // exibe todas as exceções começando pela primeira
       // exceção lançada, se disponível.
   }


