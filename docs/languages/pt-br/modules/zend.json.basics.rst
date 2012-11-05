.. EN-Revision: none
.. _zend.json.basics:

Uso Básico
==========

O uso do ``Zend_Json`` envolve usar os dois métodos públicos estáticos disponíveis: ``Zend\Json\Json::encode()`` e
``Zend\Json\Json::decode()``.

.. code-block:: php
   :linenos:

   // Recupera um valor:
   $phpNative = Zend\Json\Json::decode($encodedValue);

   // Codifica para retornar ao cliente:
   $json = Zend\Json\Json::encode($phpNative);

.. _zend.json.basics.prettyprint:

Impressão Formatada do JSON
---------------------------

Pode ser difícil as vezes explorar os dados *JSON* gerados por ``Zend\Json\Json::encode()``, uma vez que não há
espaçamento ou recuo. A fim de facilitar, ``Zend_Json`` lhe permite formatar a impressão dos dados *JSON* em um
formato legível com ``Zend\Json\Json::prettyPrint()``.

.. code-block:: php
   :linenos:

   // Codificá-lo para retornar para o cliente:
   $json = Zend\Json\Json::encode($phpNative);
   if($debug) {
       echo Zend\Json\Json::prettyPrint($json, array("indent" => " "));
   }

O segundo argumento opcional de ``Zend\Json\Json::prettyPrint()`` é uma matriz de opções. A opção *indent* lhe
permite definir a string de recuo - por padrão é um único caractere de tabulação.


