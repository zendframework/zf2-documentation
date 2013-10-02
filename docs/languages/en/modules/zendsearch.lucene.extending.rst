.. _zendsearch.lucene.extending:

Extensibility
=============

.. _zendsearch.lucene.extending.analysis:

Text Analysis
-------------

The ``Zend\Search\Lucene\Analysis\Analyzer`` class is used by the indexer to tokenize document text fields.

The ``Zend\Search\Lucene\Analysis\Analyzer::getDefault()`` and *Zend\Search\Lucene\Analysis\Analyzer::setDefault()*
methods are used to get and set the default analyzer.

You can assign your own text analyzer or choose it from the set of predefined analyzers:
``Zend\Search\Lucene\Analysis\Analyzer\Common\Text`` and
``Zend\Search\Lucene\Analysis\Analyzer\Common\Text\CaseInsensitive`` (default). Both of them interpret tokens as
sequences of letters. ``Zend\Search\Lucene\Analysis\Analyzer\Common\Text\CaseInsensitive`` converts all tokens to
lower case.

To switch between analyzers:

.. code-block:: php
   :linenos:

   Zend\Search\Lucene\Analysis\Analyzer::setDefault(
       new Zend\Search\Lucene\Analysis\Analyzer\Common\Text());
   ...
   $index->addDocument($doc);

The ``Zend\Search\Lucene\Analysis\Analyzer\Common`` class is designed to be an ancestor of all user defined
analyzers. User should only define the ``reset()`` and ``nextToken()`` methods, which takes its string from the
$_input member and returns tokens one by one (a ``NULL`` value indicates the end of the stream).

The ``nextToken()`` method should call the ``normalize()`` method on each token. This will allow you to use token
filters with your analyzer.

Here is an example of a custom analyzer, which accepts words with digits as terms:



      .. _zendsearch.lucene.extending.analysis.example-1:

      .. rubric:: Custom text Analyzer

      .. code-block:: php
         :linenos:

         /**
          * Here is a custom text analyser, which treats words with digits as
          * one term
          */

         class My_Analyzer extends Zend\Search\Lucene\Analysis\Analyzer\Common
         {
             private $_position;

             /**
              * Reset token stream
              */
             public function reset()
             {
                 $this->_position = 0;
             }

             /**
              * Tokenization stream API
              * Get next token
              * Returns null at the end of stream
              *
              * @return Zend\Search\Lucene\Analysis\Token|null
              */
             public function nextToken()
             {
                 if ($this->_input === null) {
                     return null;
                 }

                 while ($this->_position < strlen($this->_input)) {
                     // skip white space
                     while ($this->_position < strlen($this->_input) &&
                            !ctype_alnum( $this->_input[$this->_position] )) {
                         $this->_position++;
                     }

                     $termStartPosition = $this->_position;

                     // read token
                     while ($this->_position < strlen($this->_input) &&
                            ctype_alnum( $this->_input[$this->_position] )) {
                         $this->_position++;
                     }

                     // Empty token, end of stream.
                     if ($this->_position == $termStartPosition) {
                         return null;
                     }

                     $token = new Zend\Search\Lucene\Analysis\Token(
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
                     // Continue if token is skipped
                 }

                 return null;
             }
         }

         Zend\Search\Lucene\Analysis\Analyzer::setDefault(
             new My_Analyzer());



.. _zendsearch.lucene.extending.filters:

Tokens Filtering
----------------

The ``Zend\Search\Lucene\Analysis\Analyzer\Common`` analyzer also offers a token filtering mechanism.

The ``Zend\Search\Lucene\Analysis\TokenFilter`` class provides an abstract interface for such filters. Your own
filters should extend this class either directly or indirectly.

Any custom filter must implement the ``normalize()`` method which may transform input token or signal that the
current token should be skipped.

There are three filters already defined in the analysis subpackage:



   - ``Zend\Search\Lucene\Analysis\TokenFilter\LowerCase``

   - ``Zend\Search\Lucene\Analysis\TokenFilter\ShortWords``

   - ``Zend\Search\Lucene\Analysis\TokenFilter\StopWords``



The *LowerCase* filter is already used for ``Zend\Search\Lucene\Analysis\Analyzer\Common\Text\CaseInsensitive``
analyzer by default.

The *ShortWords* and *StopWords* filters may be used with pre-defined or custom analyzers like this:

.. code-block:: php
   :linenos:

   $stopWords = array('a', 'an', 'at', 'the', 'and', 'or', 'is', 'am');
   $stopWordsFilter =
       new Zend\Search\Lucene\Analysis\TokenFilter\StopWords($stopWords);

   $analyzer =
       new Zend\Search\Lucene\Analysis\Analyzer\Common\TextNum\CaseInsensitive();
   $analyzer->addFilter($stopWordsFilter);

   Zend\Search\Lucene\Analysis\Analyzer::setDefault($analyzer);

.. code-block:: php
   :linenos:

   $shortWordsFilter = new Zend\Search\Lucene\Analysis\TokenFilter\ShortWords();

   $analyzer =
       new Zend\Search\Lucene\Analysis\Analyzer\Common\TextNum\CaseInsensitive();
   $analyzer->addFilter($shortWordsFilter);

   Zend\Search\Lucene\Analysis\Analyzer::setDefault($analyzer);

The ``Zend\Search\Lucene\Analysis\TokenFilter\StopWords`` constructor takes an array of stop-words as an input. But
stop-words may be also loaded from a file:

.. code-block:: php
   :linenos:

   $stopWordsFilter = new Zend\Search\Lucene\Analysis\TokenFilter\StopWords();
   $stopWordsFilter->loadFromFile($my_stopwords_file);

   $analyzer =
      new Zend\Search\Lucene\Analysis\Analyzer\Common\TextNum\CaseInsensitive();
   $analyzer->addFilter($stopWordsFilter);

   Zend\Search\Lucene\Analysis\Analyzer::setDefault($analyzer);

This file should be a common text file with one word in each line. The '#' character marks a line as a comment.

The ``Zend\Search\Lucene\Analysis\TokenFilter\ShortWords`` constructor has one optional argument. This is the word
length limit, set by default to 2.

.. _zendsearch.lucene.extending.scoring:

Scoring Algorithms
------------------

The score of a document ``d`` for a query ``q`` is defined as follows:

*score(q,d) = sum( tf(t in d) * idf(t) * getBoost(t.field in d) * lengthNorm(t.field in d) ) * coord(q,d) *
queryNorm(q)*

tf(t in d) -``Zend\Search\Lucene\Search\Similarity::tf($freq)``- a score factor based on the frequency of a term or
phrase in a document.

idf(t) -``Zend\Search\Lucene\Search\Similarity::idf($input, $reader)``- a score factor for a simple term with the
specified index.

getBoost(t.field in d) - the boost factor for the term field.

lengthNorm($term) - the normalization value for a field given the total number of terms contained in a field. This
value is stored within the index. These values, together with field boosts, are stored in an index and multiplied
into scores for hits on each field by the search code.

Matches in longer fields are less precise, so implementations of this method usually return smaller values when
numTokens is large, and larger values when numTokens is small.

coord(q,d) -``Zend\Search\Lucene\Search\Similarity::coord($overlap, $maxOverlap)``- a score factor based on the
fraction of all query terms that a document contains.

The presence of a large portion of the query terms indicates a better match with the query, so implementations of
this method usually return larger values when the ratio between these parameters is large and smaller values when
the ratio between them is small.

queryNorm(q) - the normalization value for a query given the sum of the squared weights of each of the query terms.
This value is then multiplied into the weight of each query term.

This does not affect ranking, but rather just attempts to make scores from different queries comparable.

The scoring algorithm can be customized by defining your own Similarity class. To do this extend the
``Zend\Search\Lucene\Search\Similarity`` class as defined below, then use the
``Zend\Search\Lucene\Search\Similarity::setDefault($similarity);`` method to set it as default.

.. code-block:: php
   :linenos:

   class MySimilarity extends Zend\Search\Lucene\Search\Similarity {
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
           return $overlap/(float) $maxOverlap;
       }
   }

   $mySimilarity = new MySimilarity();
   Zend\Search\Lucene\Search\Similarity::setDefault($mySimilarity);

.. _zendsearch.lucene.extending.storage:

Storage Containers
------------------

The abstract class ``Zend\Search\Lucene\Storage\Directory`` defines directory functionality.

The ``Zend\Search\Lucene`` constructor uses either a string or a ``Zend\Search\Lucene\Storage\Directory`` object as
an input.

The ``Zend\Search\Lucene\Storage\Directory\Filesystem`` class implements directory functionality for a file system.

If a string is used as an input for the ``Zend\Search\Lucene`` constructor, then the index reader
(``Zend\Search\Lucene`` object) treats it as a file system path and instantiates the
``Zend\Search\Lucene\Storage\Directory\Filesystem`` class.

You can define your own directory implementation by extending the ``Zend\Search\Lucene\Storage\Directory`` class.

``Zend\Search\Lucene\Storage\Directory`` methods:

.. code-block:: php
   :linenos:

   abstract class Zend\Search\Lucene\Storage\Directory {
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
    * Returns a Zend\Search\Lucene\Storage\File object for a given
    * $filename in the directory.
    *
    * @param string $filename
    * @return Zend\Search\Lucene\Storage\File
    */
   abstract function getFileObject($filename);

   }

The ``getFileObject($filename)`` method of a ``Zend\Search\Lucene\Storage\Directory`` instance returns a
``Zend\Search\Lucene\Storage\File`` object.

The ``Zend\Search\Lucene\Storage\File`` abstract class implements file abstraction and index file reading
primitives.

You must also extend ``Zend\Search\Lucene\Storage\File`` for your directory implementation.

Only two methods of ``Zend\Search\Lucene\Storage\File`` must be overridden in your implementation:

.. code-block:: php
   :linenos:

   class MyFile extends Zend\Search\Lucene\Storage\File {
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


