.. EN-Revision: none
.. _zend.json.xml2json:

Conversão de XML para JSON
==========================

``Zend_Json`` fornece um conveniente método para transformar dados formatados em *XML* para o formato *JSON*. Este
recurso foi inspirado em um `artigo do IBM developerWorks`_.

``Zend_Json`` inclui uma função estática chamada ``Zend_Json::fromXml()``. Esta função irá gerar um *JSON* a
partir de uma entrada em *XML*. Esta função recebe qualquer string arbitrária em *XML* como um parâmetro de
entrada. Tem também um parâmetro de entrada opcional do tipo booleano que instrui a lógica de conversão para
ignorar ou não os atributos *XML* durante o processo de conversão. Se esse parâmetro de entrada opcional não é
dado, então o comportamento padrão é ignorar os atributos *XML*. Esta chamada de função é feita como mostrado
abaixo:

.. code-block:: php
   :linenos:

   // a função fromXml simplesmente recebe uma String contendo conteúdo
   // em XML como entrada.
   $jsonContents = Zend_Json::fromXml($xmlStringContents, true);

A função ``Zend_Json::fromXml()`` faz a conversão da string formata em *XML* do parâmetro de entrada e retorna
o equivalente como uma string formatada em *JSON*. No caso de qualquer erro de formatação do *XML* ou erro na
lógica de conversão, esta função irá lançar uma exceção. A lógica de conversão também utiliza técnicas
recursivas para percorrer a árvore *XML*. Ele suporta até 25 níveis de profundidade de recursão. Se passar
dessa profundidade, será lançado um ``Zend_Json_Exception``. Existem vários arquivos *XML* com vários graus de
complexidade fornecidos no diretório de testes de Zend Framework. Eles podem ser usados para testar a
funcionalidade do recurso xml2json.

O simples exemplo a seguir mostra uma string *XML* passada como entrada e uma string *JSON* de saída retornada
como resultado da função ``Zend_Json::fromXml()``. Este exemplo usa o parâmetro opcional da função para não
ignorar os atributos *XML* durante a conversão. Consequentemente, você pode notar que a string *JSON* resultante
inclui uma representação dos atributos *XML* presentes na string *XML* de entrada.

String *XML* passada como entrada para a função ``Zend_Json::fromXml()``:

.. code-block:: php
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <books>
       <book id="1">
           <title>Code Generation in Action</title>
           <author><first>Jack</first><last>Herrington</last></author>
           <publisher>Manning</publisher>
       </book>

       <book id="2">
           <title>PHP Hacks</title>
           <author><first>Jack</first><last>Herrington</last></author>
           <publisher>O'Reilly</publisher>
       </book>

       <book id="3">
           <title>Podcasting Hacks</title>
           <author><first>Jack</first><last>Herrington</last></author>
           <publisher>O'Reilly</publisher>
       </book>
   </books>

String *JSON* de saída retornada da função ``Zend_Json::fromXml()``:

.. code-block:: php
   :linenos:

   {
      "books" : {
         "book" : [ {
            "@attributes" : {
               "id" : "1"
            },
            "title" : "Code Generation in Action",
            "author" : {
               "first" : "Jack", "last" : "Herrington"
            },
            "publisher" : "Manning"
         }, {
            "@attributes" : {
               "id" : "2"
            },
            "title" : "PHP Hacks", "author" : {
               "first" : "Jack", "last" : "Herrington"
            },
            "publisher" : "O'Reilly"
         }, {
            "@attributes" : {
               "id" : "3"
            },
            "title" : "Podcasting Hacks", "author" : {
               "first" : "Jack", "last" : "Herrington"
            },
            "publisher" : "O'Reilly"
         }
      ]}
   }

Mais detalhes sobre o recurso xml2json podem ser encontrados na proposta original em si. Dê uma olhada na
`proposta Zend_xml2json`_.



.. _`artigo do IBM developerWorks`: http://www.ibm.com/developerworks/xml/library/x-xml2jsonphp/
.. _`proposta Zend_xml2json`: http://tinyurl.com/2tfa8z
