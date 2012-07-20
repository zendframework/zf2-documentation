.. _zend.search.lucene.java-lucene:

Interoperando com Java Lucene
=============================

.. _zend.search.lucene.index-creation.file-formats:

Formatos de Arquivo
-------------------

Os formatos de arquivos de índice do ``Zend_Search_Lucene`` são binários compatíveis com Java Lucene versão
1.4 e superior.

Uma descrição detalhada deste formato está disponível aqui:
`http://lucene.apache.org/java/2_3_0/fileformats.html`_ [#]_.

.. _zend.search.lucene.index-creation.index-directory:

Diretório Índice
----------------

Após a criação do índice, o diretório índice conterá alguns arquivos:

- O arquivo ``segments`` é uma lista de segmentos de índice.

- Os arquivos ``*.cfs`` contém segmentos de índice. Nota! Um índice otimizado sempre terá apenas um único
  segmento.

- O arquivo ``deletable`` é uma lista de arquivos que não são mais utilizados pelo índice, mas que não puderam
  ser removidos.

.. _zend.search.lucene.java-lucene.source-code:

Código Fonte Java
-----------------

O programa Java abaixo oferece um exemplo de como indexar um arquivo usando Java Lucene:

.. code-block:: java
   :linenos:

   /**
   * Criação do índice:
   */
   import org.apache.lucene.index.IndexWriter;
   import org.apache.lucene.document.*;

   import java.io.*

   ...

   IndexWriter indexWriter = new IndexWriter("/data/my_index",
                                             new SimpleAnalyzer(), true);

   ...

   String filename = "/path/to/file-to-index.txt"
   File f = new File(filename);

   Document doc = new Document();
   doc.add(Field.Text("path", filename));
   doc.add(Field.Keyword("modified",DateField.timeToString(f.lastModified())));
   doc.add(Field.Text("author", "unknown"));
   FileInputStream is = new FileInputStream(f);
   Reader reader = new BufferedReader(new InputStreamReader(is));
   doc.add(Field.Text("contents", reader));

   indexWriter.addDocument(doc);



.. _`http://lucene.apache.org/java/2_3_0/fileformats.html`: http://lucene.apache.org/java/2_3_0/fileformats.html

.. [#] A versão do formato de arquivo de índice Lucene suportado atualmente é a 2.3 (a partir do Zend Framework
       1.6).