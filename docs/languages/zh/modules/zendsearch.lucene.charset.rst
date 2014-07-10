.. _zendsearch.lucene.charset:

Character Set
=============

.. _zendsearch.lucene.charset.description:

UTF-8 and single-byte character set support
-------------------------------------------

``Zend\Search\Lucene`` works with the UTF-8 charset internally. Index files store unicode data in Java's "modified
UTF-8 encoding". ``Zend\Search\Lucene`` core completely supports this encoding with one exception. [#]_

Actual input data encoding may be specified through ``Zend\Search\Lucene`` *API*. Data will be automatically
converted into UTF-8 encoding.

.. _zendsearch.lucene.charset.default_analyzer:

Default text analyzer
---------------------

However, the default text analyzer (which is also used within query parser) uses ctype_alpha() for tokenizing text
and queries.

ctype_alpha() is not UTF-8 compatible, so the analyzer converts text to 'ASCII//TRANSLIT' encoding before indexing.
The same processing is transparently performed during query parsing. [#]_

.. note::

   Default analyzer doesn't treats numbers as parts of terms. Use corresponding 'Num' analyzer if you don't want
   words to be broken by numbers.

.. _zendsearch.lucene.charset.utf_analyzer:

UTF-8 compatible text analyzers
-------------------------------

``Zend\Search\Lucene`` also contains a set of UTF-8 compatible analyzers:
``Zend\Search\Lucene\Analysis\Analyzer\Common\Utf8``, ``Zend\Search\Lucene\Analysis\Analyzer\Common\Utf8Num``,
``Zend\Search\Lucene\Analysis\Analyzer\Common\Utf8\CaseInsensitive``,
``Zend\Search\Lucene\Analysis\Analyzer\Common\Utf8Num\CaseInsensitive``.

Any of this analyzers can be enabled with the code like this:

.. code-block:: php
   :linenos:

   Zend\Search\Lucene\Analysis\Analyzer::setDefault(
       new Zend\Search\Lucene\Analysis\Analyzer\Common\Utf8());

.. warning::

   UTF-8 compatible analyzers were improved in Zend Framework 1.5. Early versions of analyzers assumed all
   non-ascii characters are letters. New analyzers implementation has more accurate behavior.

   This may need you to re-build index to have data and search queries tokenized in the same way, otherwise search
   engine may return wrong result sets.

All of these analyzers need PCRE (Perl-compatible regular expressions) library to be compiled with UTF-8 support
turned on. PCRE UTF-8 support is turned on for the PCRE library sources bundled with *PHP* source code
distribution, but if shared library is used instead of bundled with *PHP* sources, then UTF-8 support state may
depend on you operating system.

Use the following code to check, if PCRE UTF-8 support is enabled:

.. code-block:: php
   :linenos:

   if (@preg_match('/\pL/u', 'a') == 1) {
       echo "PCRE unicode support is turned on.\n";
   } else {
       echo "PCRE unicode support is turned off.\n";
   }

Case insensitive versions of UTF-8 compatible analyzers also need `mbstring`_ extension to be enabled.

If you don't want mbstring extension to be turned on, but need case insensitive search, you may use the following
approach: normalize source data before indexing and query string before searching by converting them to lowercase:

.. code-block:: php
   :linenos:

   // Indexing
   setlocale(LC_CTYPE, 'de_DE.iso-8859-1');

   ...

   Zend\Search\Lucene\Analysis\Analyzer::setDefault(
       new Zend\Search\Lucene\Analysis\Analyzer\Common\Utf8());

   ...

   $doc = new Zend\Search\Lucene\Document();

   $doc->addField(Zend\Search\Lucene\Field::UnStored('contents',
                                                     strtolower($contents)));

   // Title field for search through (indexed, unstored)
   $doc->addField(Zend\Search\Lucene\Field::UnStored('title',
                                                     strtolower($title)));

   // Title field for retrieving (unindexed, stored)
   $doc->addField(Zend\Search\Lucene\Field::UnIndexed('_title', $title));

.. code-block:: php
   :linenos:

   // Searching
   setlocale(LC_CTYPE, 'de_DE.iso-8859-1');

   ...

   Zend\Search\Lucene\Analysis\Analyzer::setDefault(
       new Zend\Search\Lucene\Analysis\Analyzer\Common\Utf8());

   ...

   $hits = $index->find(strtolower($query));



.. _`mbstring`: http://www.php.net/manual/en/ref.mbstring.php

.. [#] ``Zend\Search\Lucene`` supports only Basic Multilingual Plane (BMP) characters (from 0x0000 to 0xFFFF) and
       doesn't support "supplementary characters" (characters whose code points are greater than 0xFFFF)

       Java 2 represents these characters as a pair of char (16-bit) values, the first from the high-surrogates
       range (0xD800-0xDBFF), the second from the low-surrogates range (0xDC00-0xDFFF). Then they are encoded as
       usual UTF-8 characters in six bytes. Standard UTF-8 representation uses four bytes for supplementary
       characters.
.. [#] Conversion to 'ASCII//TRANSLIT' may depend on current locale and OS.