.. _zend.search.lucene.extending:

Extensibilidade
===============

.. _zend.search.lucene.extending.analysis:

Análise de Texto
----------------

A classe ``Zend_Search_Lucene_Analysis_Analyzer`` é usada pelo indexador para separar em tokens os campos de texto
do documento.

Os métodos ``Zend_Search_Lucene_Analysis_Analyzer::getDefault()`` e
*Zend_Search_Lucene_Analysis_Analyzer::setDefault()* são usados para obter e setar, respectivamente, o analisador
padrão.

Você pode atribuir o seu próprio analisador de textos ou selecioná-lo dentre uma lista de analisadores
pré-definidos: ``Zend_Search_Lucene_Analysis_Analyzer_Common_Text`` e
``Zend_Search_Lucene_Analysis_Analyzer_Common_Text_CaseInsensitive`` (padrão). Ambos interpretam os tokens como
sequências de letras. ``Zend_Search_Lucene_Analysis_Analyzer_Common_Text_CaseInsensitive`` converte todos os
tokens para minúsculas.

Para selecionar um analisador:

.. code-block:: php
   :linenos:

   Zend_Search_Lucene_Analysis_Analyzer::setDefault(
       new Zend_Search_Lucene_Analysis_Analyzer_Common_Text());
   ...
   $index->addDocument($doc);

A classe ``Zend_Search_Lucene_Analysis_Analyzer_Common`` foi projetada para ser um antepassado de todos os
analisadores definidos pelo usuário. O usuário só precisa definir os métodos ``reset()`` e ``nextToken()``, que
receberá a string do membro $_input e retornará os tokens um por um (um valor ``NULL`` indica o fim do fluxo).

O método ``nextToken()`` deve chamar o método ``normalize()`` em cada token. Isso te permite usar filtros de
token junto com o seu analisador.

Aqui está um exemplo de um analisador customizado, que aceita palavras contendo dígitos como termos:



      .. _zend.search.lucene.extending.analysis.example-1:

      .. rubric:: Analisador de Texto Customizado

      .. code-block:: php
         :linenos:

         /**
          * Aqui está um analisador de texto personalizado, que trata as palavras com
          * dígitos como um termo
          */

         class My_Analyzer extends Zend_Search_Lucene_Analysis_Analyzer_Common
         {
             private $_position;

             /**
              * Reinicia o fluxo do token
              */
             public function reset()
             {
                 $this->_position = 0;
             }

             /**
              * API do fluxo de separação de tokens
              * Obtém o próximo token
              * Retorna null no final do fluxo
              *
              * @return Zend_Search_Lucene_Analysis_Token|null
              */
             public function nextToken()
             {
                 if ($this->_input === null) {
                     return null;
                 }

                 while ($this->_position < strlen($this->_input)) {
                     // ignora os espaços em branco
                     while ($this->_position < strlen($this->_input) &&
                            !ctype_alnum( $this->_input[$this->_position] )) {
                         $this->_position++;
                     }

                     $termStartPosition = $this->_position;

                     // lê o token
                     while ($this->_position < strlen($this->_input) &&
                            ctype_alnum( $this->_input[$this->_position] )) {
                         $this->_position++;
                     }

                     // Token vazio, fim do fluxo.
                     if ($this->_position == $termStartPosition) {
                         return null;
                     }

                     $token = new Zend_Search_Lucene_Analysis_Token(
                                               substr($this->_input,
                                                      $termStartPosition,
                                                      $this->_position -
                                                      $termStartPosition),
                                               $termStartPosition,
                                               $this->_position);
                     $token = $this->normalize($token);
                     if ($token !== null) {
                         return $token;
                     }
                     // Continua se o token for ignorado
                 }

                 return null;
             }
         }

         Zend_Search_Lucene_Analysis_Analyzer::setDefault(
             new My_Analyzer());



.. _zend.search.lucene.extending.filters:

Filtragem de Tokens
-------------------

O analisador ``Zend_Search_Lucene_Analysis_Analyzer_Common`` também oferece um mecanismo de filtragem de token.

A classe ``Zend_Search_Lucene_Analysis_TokenFilter`` fornece uma interface abstrata para estes filtros. Seus
próprios filtros devem estender esta classe, diretamente ou indiretamente.

Qualquer filtro personalizado deve implementar o método ``normalize()`` que pode transformar o token de entrada ou
sinalizar que o token corrente deve ser ignorado.

Aí estão três filtros já definidos no subpacote de análise:



   - ``Zend_Search_Lucene_Analysis_TokenFilter_LowerCase``

   - ``Zend_Search_Lucene_Analysis_TokenFilter_ShortWords``

   - ``Zend_Search_Lucene_Analysis_TokenFilter_StopWords``



O filtro *LowerCase* já é utilizado pelo analisador
``Zend_Search_Lucene_Analysis_Analyzer_Common_Text_CaseInsensitive`` por padrão.

Os filtros *ShortWords* e *StopWords* podem ser utilizados com analisadores pré-definidos ou personalizados desta
forma:

.. code-block:: php
   :linenos:

   $stopWords = array('a', 'an', 'at', 'the', 'and', 'or', 'is', 'am');
   $stopWordsFilter =
       new Zend_Search_Lucene_Analysis_TokenFilter_StopWords($stopWords);

   $analyzer =
       new Zend_Search_Lucene_Analysis_Analyzer_Common_TextNum_CaseInsensitive();
   $analyzer->addFilter($stopWordsFilter);

   Zend_Search_Lucene_Analysis_Analyzer::setDefault($analyzer);

.. code-block:: php
   :linenos:

   $shortWordsFilter = new Zend_Search_Lucene_Analysis_TokenFilter_ShortWords();

   $analyzer =
       new Zend_Search_Lucene_Analysis_Analyzer_Common_TextNum_CaseInsensitive();
   $analyzer->addFilter($shortWordsFilter);

   Zend_Search_Lucene_Analysis_Analyzer::setDefault($analyzer);

O construtor ``Zend_Search_Lucene_Analysis_TokenFilter_StopWords`` recebe uma matriz de stop-words como uma
entrada. Mas as stop-words podem também ser carregadas a partir de um arquivo:

.. code-block:: php
   :linenos:

   $stopWordsFilter = new Zend_Search_Lucene_Analysis_TokenFilter_StopWords();
   $stopWordsFilter->loadFromFile($my_stopwords_file);

   $analyzer =
      new Zend_Search_Lucene_Analysis_Analyzer_Common_TextNum_CaseInsensitive();
   $analyzer->addFilter($stopWordsFilter);

   Zend_Search_Lucene_Analysis_Analyzer::setDefault($analyzer);

Este arquivo deve ser um arquivo de texto comum com uma palavra em cada linha. O caractere '#' marca uma linha como
um comentário.

O construtor ``Zend_Search_Lucene_Analysis_TokenFilter_ShortWords`` é um argumento opcional. Este é o limite do
comprimento de palavra, definido por padrão para 2.

.. _zend.search.lucene.extending.scoring:

Algoritmos de Pontuação
-----------------------

A pontuação de um documento ``d`` para uma consulta ``q`` é definida como segue:

*score(q,d) = sum( tf(t in d) * idf(t) * getBoost(t.field in d) * lengthNorm(t.field in d) ) * coord(q,d) *
queryNorm(q)*

tf(t in d) -``Zend_Search_Lucene_Search_Similarity::tf($freq)``- um fator de pontuação baseado na frequência de
um termo ou frase em um documento.

idf(t) -``Zend_Search_Lucene_Search_Similarity::idf($input, $reader)``- um fator de pontuação para um termo
simples com o índice especificado.

getBoost(t.field in d) - o fator de reforço para o campo.

lengthNorm($term) - O valor de normalização para um campo, dado o número total de termos contido nele. Este
valor é armazenado junto com o índice. Estes valores, juntamente com os campos de reforço, são armazenados em
um índice e multiplicados nas pontuações de acerto em cada campo, pelo código de busca.

Comparações em campos longos são menos precisas, e implementações deste método usualmente retornam valores
pequenos quando o número de "tokens" é grande, e valores grandes quando o número de "tokens" for pequeno.

coord(q,d) -``Zend_Search_Lucene_Search_Similarity::coord($overlap, $maxOverlap)``- um fator de pontuação baseado
no quociente de todos os termos de busca que um documento contém.

A existência de uma grande quantidade de termos de busca indica um grau maior de comparação. As implementações
deste método usualmente retornam valores significativos quando a razão entre estes parâmetros é grande e vice
versa.

queryNorm(q) - o valor de normalização para uma consulta dado a soma das relevâncias ao quadrado de cada termo
da consulta. Este valor é então multiplicado pela relevância de cada item da consulta.

Isto não afeta a pontuação, mas a quantidade de tentativas para gerar pontuações em comparações entre
consultas.

O algoritmo de pontuação pode ser customizado pela implementação da sua própria classe de similaridade. Para
isso crie uma classe descendente de ``Zend_Search_Lucene_Search_Similarity`` como mostrado abaixo, então use o
método ``Zend_Search_Lucene_Search_Similarity::setDefault($similarity);`` para defini-la como padrão.

.. code-block:: php
   :linenos:

   class MySimilarity extends Zend_Search_Lucene_Search_Similarity {
       public function lengthNorm($fieldName, $numTerms) {
           return 1.0/sqrt($numTerms);
       }

       public function queryNorm($sumOfSquaredWeights) {
           return 1.0/sqrt($sumOfSquaredWeights);
       }

       public function tf($freq) {
           return sqrt($freq);
       }

       /**
        * It's not used now. Computes the amount of a sloppy phrase match,
        * based on an edit distance.
        */
       public function sloppyFreq($distance) {
           return 1.0;
       }

       public function idfFreq($docFreq, $numDocs) {
           return log($numDocs/(float)($docFreq+1)) + 1.0;
       }

       public function coord($overlap, $maxOverlap) {
           return $overlap/(float)$maxOverlap;
       }
   }

   $mySimilarity = new MySimilarity();
   Zend_Search_Lucene_Search_Similarity::setDefault($mySimilarity);

.. _zend.search.lucene.extending.storage:

Recipientes de Armazenagem
--------------------------

A classe abstrata ``Zend_Search_Lucene_Storage_Directory`` define a funcionalidade de diretório.

O construtor do ``Zend_Search_Lucene`` usa como entrada uma string ou um objeto da classe
``Zend_Search_Lucene_Storage_Directory``.

A classe ``Zend_Search_Lucene_Storage_Directory_Filesystem`` implementa a funcionalidade de diretório para o
sistema de arquivos.

Se uma string for usada como entrada para o construtor do ``Zend_Search_Lucene``, então o leitor do índice (um
objeto ``Zend_Search_Lucene``) a tratará como um caminho para o sistema de arquivos e instanciará um objeto
``Zend_Search_Lucene_Storage_Directory_Filesystem``.

Você pode definir a sua própria implementação de diretório estendendo a classe
``Zend_Search_Lucene_Storage_Directory``.

Métodos de ``Zend_Search_Lucene_Storage_Directory``:

.. code-block:: php
   :linenos:

   abstract class Zend_Search_Lucene_Storage_Directory {
   /**
    * Closes the store.
    *
    * @return void
    */
   abstract function close();

   /**
    * Creates a new, empty file in the directory with the given $filename.
    *
    * @param string $name
    * @return void
    */
   abstract function createFile($filename);

   /**
    * Removes an existing $filename in the directory.
    *
    * @param string $filename
    * @return void
    */
   abstract function deleteFile($filename);

   /**
    * Returns true if a file with the given $filename exists.
    *
    * @param string $filename
    * @return boolean
    */
   abstract function fileExists($filename);

   /**
    * Returns the length of a $filename in the directory.
    *
    * @param string $filename
    * @return integer
    */
   abstract function fileLength($filename);

   /**
    * Returns the UNIX timestamp $filename was last modified.
    *
    * @param string $filename
    * @return integer
    */
   abstract function fileModified($filename);

   /**
    * Renames an existing file in the directory.
    *
    * @param string $from
    * @param string $to
    * @return void
    */
   abstract function renameFile($from, $to);

   /**
    * Sets the modified time of $filename to now.
    *
    * @param string $filename
    * @return void
    */
   abstract function touchFile($filename);

   /**
    * Returns a Zend_Search_Lucene_Storage_File object for a given
    * $filename in the directory.
    *
    * @param string $filename
    * @return Zend_Search_Lucene_Storage_File
    */
   abstract function getFileObject($filename);

   }

O método ``getFileObject($filename)`` de uma instância ``Zend_Search_Lucene_Storage_Directory`` retorna um objeto
``Zend_Search_Lucene_Storage_File``.

A classe abstrata ``Zend_Search_Lucene_Storage_File`` implementa a abstração de arquivo e as primitivas de
leitura de arquivos de índice.

Se fizer isso, você também terá que estender ``Zend_Search_Lucene_Storage_File`` para a sua implementação de
diretório.

Somente dois métodos de ``Zend_Search_Lucene_Storage_File`` devem ser substituídos em sua implementação:

.. code-block:: php
   :linenos:

   class MyFile extends Zend_Search_Lucene_Storage_File {
       /**
        * Sets the file position indicator and advances the file pointer.
        * The new position, measured in bytes from the beginning of the file,
        * is obtained by adding offset to the position specified by whence,
        * whose values are defined as follows:
        * SEEK_SET - Set position equal to offset bytes.
        * SEEK_CUR - Set position to current location plus offset.
        * SEEK_END - Set position to end-of-file plus offset. (To move to
        * a position before the end-of-file, you need to pass a negative value
        * in offset.)
        * Upon success, returns 0; otherwise, returns -1
        *
        * @param integer $offset
        * @param integer $whence
        * @return integer
        */
       public function seek($offset, $whence=SEEK_SET) {
           ...
       }

       /**
        * Read a $length bytes from the file and advance the file pointer.
        *
        * @param integer $length
        * @return string
        */
       protected function _fread($length=1) {
           ...
       }
   }


