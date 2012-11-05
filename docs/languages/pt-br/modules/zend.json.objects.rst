.. EN-Revision: none
.. _zend.json.advanced:

Uso Avançado do Zend_Json
=========================

.. _zend.json.advanced.objects1:

Objetos JSON
------------

Quando codificamos objetos *PHP* como *JSON*, todas as propriedades públicas desse objeto estarão codificadas em
um objeto *JSON*.

*JSON* não permite referências de objeto, por isso deve-se tomar cuidado para não codificar objetos com
referências recursivas. Se você tiver problemas com a recursividade, ``Zend\Json\Json::encode()`` e
``Zend\Json\Encoder::encode()`` permitem um segundo parâmetro opcional para verificar a recursividade; se um
objeto for serializado duplamente, uma exceção será lançada.

Descodificar objetos *JSON* traz uma ligeira dificuldade, entretanto, desde que os objetos do JavaScript
correspondam o mais próximo de uma matriz associativa do *PHP*. Alguns sugerem que um identificador da classe deve
ser passado, e um exemplo do objeto dessa classe deve ser criado e populado com os pares chave/valor do objeto
*JSON*; outros pensam que isto poderia gerar um risco substancial da segurança.

Por padrão, ``Zend_Json`` irá descodificar objetos *JSON* como matriz associativas. Entretanto, se você deseja
que o retorne um objeto, você pode especificar isto:

.. code-block:: php
   :linenos:

   // Descodifique objetos JSON como objetos PHP
   $phpNative = Zend\Json\Json::decode($encodedValue, Zend\Json\Json::TYPE_OBJECT);

Todos os objetos descodificados assim são retornados como objetos de *StdClass* com as propriedades que
correspondem aos pares chave/valor na notação de *JSON*.

A recomendação do Zend Framework é que o desenvolvedor deve decidir-se como descodificar objetos *JSON*. Se um
objeto de um tipo especificado for criado, pode ser criado no código do desenvolvedor e ser populado com os
valores descodificados usando ``Zend_Json``.

.. _zend.json.advanced.objects2:

Codificando Objetos PHP
-----------------------

Se você estiver codificando objetos *PHP* por padrão, o mecanismo de codificação só poderá acessar as
propriedades públicas desses objetos. Quando o método ``toJson()`` é implementado em um objeto para codificar,
``Zend_Json`` chama esse método e espera que o objeto retorne uma representação *JSON* de seu estado interno.

.. _zend.json.advanced.internal:

Codificador/Descodificador Interno
----------------------------------

``Zend_Json`` tem dois modos diferentes, dependendo se ext/json está habilitado em sua instalação do *PHP* ou
não. Se estiver instalado por padrão, ``json_encode()`` e ``json_decode()`` são utilizados para a codificação
e descodificação *JSON*. Se não estiver instalado, uma implementação do Zend Framework no código *PHP* é
usada para a codificação e descodificação. Este último é consideravelmente mais lento do que usando a
extensão do *PHP*, mas comporta-se exatamente da mesma forma.

Entretanto, você talvez queira usar o codificador/descodificador interno mesmo tendo o ext/json instalado. Você
pode conseguir isso chamando:

.. code-block:: php
   :linenos:

   Zend\Json\Json::$useBuiltinEncoderDecoder = true:

.. _zend.json.advanced.expr:

Expressões do JSON
------------------

Javascript faz uso pesado de funções de callback anônimas, que podem ser guardadas dentro de variáveis de
objeto *JSON*. Mesmo assim elas só funcionam se não forem devolvidas dentro aspas duplas, que ``Zend_Json``
naturalmente faz. Com o suporte à Expressão no ``Zend_Json``, você pode codificar objetos *JSON* com callbacks
de javascript válidos. Isso funciona tanto para ``json_encode()`` quanto para o codificador interno.

Um callback javascript é representado usando o objeto ``Zend\Json\Expr``. Ela implementa o padrão value object e
é imutável. Você pode definir a expressão javascript como o primeiro argumento do construtor. Por padrão
``Zend\Json\Json::encode`` não codifica callbacks de javascript, você deverá passar a opção *'enableJsonExprFinder'
= true* para a função *encode*. Se ativado, o suporte à expressão funcionará para todas as expressões
aninhadas em estruturas de grande porte. Um exemplo de uso seria parecido com:

.. code-block:: php
   :linenos:

   $data = array(
       'onClick' => new Zend\Json\Expr('function() {'
                 . 'alert("I am a valid javascript callback '
                 . 'created by Zend_Json"); }'),
       'other' => 'no expression',
   );
   $jsonObjectWithExpression = Zend\Json\Json::encode(
       $data,
       false,
       array('enableJsonExprFinder' => true)
   );


