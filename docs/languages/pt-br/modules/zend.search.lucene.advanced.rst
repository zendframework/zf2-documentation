.. _zend.search.lucene.advanced:

Avançado
========

.. _zend.search.lucene.advanced.format_migration:

A partir da versão 1.6, manipulando as transformações no formato de índice
--------------------------------------------------------------------------

O componente ``Zend_Search_Lucene`` trabalha com os formatos de índice Java Lucene 1.4-1.9, 2.1 e 2.3.

O formato de índice corrente pode ser solicitado através da chamada *$index->getFormatVersion()*. Ela retorna um
dos seguintes valores:



   - ``Zend_Search_Lucene::FORMAT_PRE_2_1`` para o formato de índice Java Lucene 1.4-1.9.

   - ``Zend_Search_Lucene::FORMAT_2_1`` para o formato de índice Java Lucene 2.1 (também usado para Lucene 2.2).

   - ``Zend_Search_Lucene::FORMAT_2_3`` para o formato de índice Java Lucene 2.3.



As modificações no índice são realizadas **apenas** se qualquer atualização do índice for feita. Isso
acontece se um novo documento for adicionado a um índice ou uma otimização de índice for iniciada manualmente
através da chamada *$index->optimize()*.

Nesse caso, ``Zend_Search_Lucene`` pode converter o índice para a versão superior. Isso **sempre** acontece para
os índices no formato ``Zend_Search_Lucene::FORMAT_PRE_2_1``, que são automaticamente convertidos para o formato
2.1.

Você pode gerenciar o processo de conversão e atribuir o formato de índice de destino com
*$index->setFormatVersion()* que toma como parâmetro a constante ``Zend_Search_Lucene::FORMAT_2_1`` ou
``Zend_Search_Lucene::FORMAT_2_3``:



   - ``Zend_Search_Lucene::FORMAT_2_1`` na verdade não faz nada desde que os índices pré-2.1 são
     automaticamente convertidos para formato 2.1.

   - ``Zend_Search_Lucene::FORMAT_2_3`` força a conversão para o formato 2.3.



Conversões para versões anteriores de formatos não são suportadas.

.. note::

   **Importante!**

   Uma vez que o índice é convertido para a versão superior não pode ser convertido de volta. Por isso, faça
   um backup do seu índice quando você planejar a migração para a versão superior, mas querendo ter a
   possibilidade de converter para uma versão anterior.

.. _zend.search.lucene.advanced.static:

Usando o índice como propriedade estática
-----------------------------------------

The ``Zend_Search_Lucene`` object uses the destructor method to commit changes and clean up resources.

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
           self::$_index = Zend_Search_Lucene::open('path/to/index');
       }
   }

   Searcher::initIndex();

All the same, the destructor for static properties is correctly invoked at this point in the program's execution.

One potential problem is exception handling. Exceptions thrown by destructors of static objects don't have context,
because the destructor is executed after the script has already completed.

You might see a "Fatal error: Exception thrown without a stack frame in Unknown on line 0" error message instead of
exception description in such cases.

``Zend_Search_Lucene`` provides a workaround to this problem with the ``commit()`` method. It saves all unsaved
changes and frees memory used for storing new segments. You are free to use the commit operation any time- or even
several times- during script execution. You can still use the ``Zend_Search_Lucene`` object for searching, adding
or deleting document after the commit operation. But the ``commit()`` call guarantees that if there are no document
added or deleted after the call to ``commit()``, then the ``Zend_Search_Lucene`` destructor has nothing to do and
will not throw exception:

.. code-block:: php
   :linenos:

   class Searcher {
       private static $_index;

       public static function initIndex() {
           self::$_index = Zend_Search_Lucene::open('path/to/index');
       }

       ...

       public static function commit() {
           self::$_index->commit();
       }
   }

   Searcher::initIndex();

   ...

   // Rotina de desligamento do script
   ...
   Searcher::commit();
   ...


