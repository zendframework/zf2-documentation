.. _zendsearch.lucene.advanced:

Advanced
========

.. _zendsearch.lucene.advanced.format_migration:

Starting from 1.6, handling index format transformations
--------------------------------------------------------

``Zend\Search\Lucene`` component works with Java Lucene 1.4-1.9, 2.1 and 2.3 index formats.

Current index format may be requested using *$index->getFormatVersion()* call. It returns one of the following
values:



   - ``Zend\Search\Lucene::FORMAT_PRE_2_1`` for Java Lucene 1.4-1.9 index format.

   - ``Zend\Search\Lucene::FORMAT_2_1`` for Java Lucene 2.1 index format (also used for Lucene 2.2).

   - ``Zend\Search\Lucene::FORMAT_2_3`` for Java Lucene 2.3 index format.



Index modifications are performed **only** if any index update is done. That happens if a new document is added to
an index or index optimization is started manually by *$index->optimize()* call.

In a such case ``Zend\Search\Lucene`` may convert index to the higher format version. That **always** happens for
the indices in ``Zend\Search\Lucene::FORMAT_PRE_2_1`` format, which are automatically converted to 2.1 format.

You may manage conversion process and assign target index format by *$index->setFormatVersion()* which takes
``Zend\Search\Lucene::FORMAT_2_1`` or ``Zend\Search\Lucene::FORMAT_2_3`` constant as a parameter:



   - ``Zend\Search\Lucene::FORMAT_2_1`` actually does nothing since pre-2.1 indices are automatically converted to
     2.1 format.

   - ``Zend\Search\Lucene::FORMAT_2_3`` forces conversion to the 2.3 format.



Backward conversions are not supported.

.. note::

   **Important!**

   Once index is converted to upper version it can't be converted back. So make a backup of your index when you
   plan migration to upper version, but want to have possibility to go back.

.. _zendsearch.lucene.advanced.static:

Using the index as static property
----------------------------------

The ``Zend\Search\Lucene`` object uses the destructor method to commit changes and clean up resources.

It stores added documents in memory and dumps new index segment to disk depending on *MaxBufferedDocs* parameter.

If *MaxBufferedDocs* limit is not reached then there are some "unsaved" documents which are saved as a new segment
in the object's destructor method. The index auto-optimization procedure is invoked if necessary depending on the
values of the *MaxBufferedDocs*, *MaxMergeDocs* and *MergeFactor* parameters.

Static object properties (see below) are destroyed **after** the last line of the executed script.

.. code-block:: php
   :linenos:

   class Searcher {
       private static $_index;

       public static function initIndex() {
           self::$_index = Zend\Search\Lucene::open('path/to/index');
       }
   }

   Searcher::initIndex();

All the same, the destructor for static properties is correctly invoked at this point in the program's execution.

One potential problem is exception handling. Exceptions thrown by destructors of static objects don't have context,
because the destructor is executed after the script has already completed.

You might see a "Fatal error: Exception thrown without a stack frame in Unknown on line 0" error message instead of
exception description in such cases.

``Zend\Search\Lucene`` provides a workaround to this problem with the ``commit()`` method. It saves all unsaved
changes and frees memory used for storing new segments. You are free to use the commit operation any time- or even
several times- during script execution. You can still use the ``Zend\Search\Lucene`` object for searching, adding
or deleting document after the commit operation. But the ``commit()`` call guarantees that if there are no document
added or deleted after the call to ``commit()``, then the ``Zend\Search\Lucene`` destructor has nothing to do and
will not throw exception:

.. code-block:: php
   :linenos:

   class Searcher {
       private static $_index;

       public static function initIndex() {
           self::$_index = Zend\Search\Lucene::open('path/to/index');
       }

       ...

       public static function commit() {
           self::$_index->commit();
       }
   }

   Searcher::initIndex();

   ...

   // Script shutdown routine
   ...
   Searcher::commit();
   ...


