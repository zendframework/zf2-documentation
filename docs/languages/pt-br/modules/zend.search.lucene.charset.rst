.. _zend.search.lucene.charset:

Conjunto de Caracteres
======================

.. _zend.search.lucene.charset.description:

Suporte aos conjuntos de caracteres UTF-8 e single-byte
-------------------------------------------------------

``Zend_Search_Lucene`` trabalha internamente com o conjunto de caracteres UTF-8. Arquivos de índice armazenam
dados unicode no formato de codificação "UTF-8 modificado" usado pelo Java. O núcleo do ``Zend_Search_Lucene``
suporta esta codificação plenamente, com uma exceção. [#]_

A codificação dos dados de entrada pode ser especificada através da *API* de ``Zend_Search_Lucene``. Os dados
serão convertidos automaticamente na codificação UTF-8.

.. _zend.search.lucene.charset.default_analyzer:

Analisador de texto padrão
--------------------------

De qualquer modo, o analisador de texto padrão (que também é usado no analisador de consultas) utiliza
ctype_alpha() para a separação de texto e consultas em tokens.

ctype_alpha() não é compatível com UTF-8, por isso o analisador converte o texto para a codificação
'ASCII//TRANSLIT' antes da indexação. O mesmo processo é realizado transparentemente durante a análise da
consulta. [#]_

.. note::

   O analisador padrão não trata os números como parte de termos. Utilize o analisador 'Num' correspondente se
   você não quer que palavras sejam quebradas por números.

.. _zend.search.lucene.charset.utf_analyzer:

Analisadores de texto compatíveis com UTF-8
-------------------------------------------

``Zend_Search_Lucene`` também contém um conjunto de analisadores compatíveis com UTF-8:
``Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8``, ``Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8Num``,
``Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8_CaseInsensitive``,
``Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8Num_CaseInsensitive``.

Qualquer um desses analisadores pode ser ativado como o código a seguir:

.. code-block:: php
   :linenos:

   Zend_Search_Lucene_Analysis_Analyzer::setDefault(
       new Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8());

.. warning::

   Os analisadores compatíveis com UTF-8 foram melhorados no Zend Framework 1.5. As primeiras versões dos
   analisadores assumiam como sendo letras todos os caracteres que não fossem ASCII. A implementação dos novos
   analisadores possui um comportamento mais correto.

   Isso pode exigir que você reconstrua o índice para ter os dados e as consultas de pesquisas separados em
   tokens do mesmo formato, caso contrário o motor de busca pode retornar conjuntos de resultados errados.

Todos estes analisadores necessitam da biblioteca PCRE (Perl-compatible regular expressions) compilada com suporte
à UTF-8 ativado. O suporte à UTF-8 do PCRE está ativado nas fontes da biblioteca PCRE fornecidas com o código
fonte do *PHP*, mas se uma biblioteca compartilhada é usada em vez do pacote com as fontes do *PHP*, então o
estado do suporte à UTF-8 vai depender de seu sistema operacional.

Use o seguinte código para verificar, se o PCRE com suporte à UTF-8 está habilitado:

.. code-block:: php
   :linenos:

   if (@preg_match('/\pL/u', 'a') == 1) {
       echo "PCRE com suporte a Unicode está ativado.\n";
   } else {
       echo "PCRE com suporte a Unicode está desativado.\n";
   }

Versões dos analisadores compatíveis com UTF-8 insensíveis a maiúsculas e minúsculas precisam também da
extensão `mbstring`_ habilitada.

Se você não quer ativar a extensão mbstring, mas precisa de buscas sem diferenciação de maiúsculas e
minúsculas, pode-se usar a seguinte abordagem: normalizar os dados antes da indexação e a string de consulta
antes de pesquisar, convertendo-os em minúsculas:

.. code-block:: php
   :linenos:

   // Indexando
   setlocale(LC_CTYPE, 'de_DE.iso-8859-1');

   ...

   Zend_Search_Lucene_Analysis_Analyzer::setDefault(
       new Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8());

   ...

   $doc = new Zend_Search_Lucene_Document();

   $doc->addField(Zend_Search_Lucene_Field::UnStored('contents',
                                                     strtolower($contents)));

   // Título de campo para pesquisa direta (indexado, não armazenado)
   $doc->addField(Zend_Search_Lucene_Field::UnStored('title',
                                                     strtolower($title)));

   // Título de campo para recuperação (não indexado, armazenado)
   $doc->addField(Zend_Search_Lucene_Field::UnIndexed('_title', $title));

.. code-block:: php
   :linenos:

   // Buscando
   setlocale(LC_CTYPE, 'de_DE.iso-8859-1');

   ...

   Zend_Search_Lucene_Analysis_Analyzer::setDefault(
       new Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8());

   ...

   $hits = $index->find(strtolower($query));



.. _`mbstring`: http://www.php.net/manual/en/ref.mbstring.php

.. [#] ``Zend_Search_Lucene`` suporta somente os caracteres do Plano Multilingual Básico (BMP) (de 0x0000 a
       0xFFFF), não suportando os caracteres suplementares (caracteres acima de 0xFFFF)

       O Java 2 representa estes caracteres como um par de valores do tipo char (16 bits), o primeiro vem da faixa
       superior (0xD800-0xDBFF), o segundo, da faixa inferior (0xDC00-0xDFFF). Logo eles são codificados como
       caracteres usuais UTF-8 em seis bytes. A representação padrão UTF-8 utiliza quatro bytes para caracteres
       suplementares.
.. [#] A conversão para 'ASCII//TRANSLIT' depende da localidade atual e do SO.