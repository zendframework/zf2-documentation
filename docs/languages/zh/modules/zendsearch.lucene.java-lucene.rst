.. _zendsearch.lucene.java-lucene:

Interoperating with Java Lucene
===============================

.. _zendsearch.lucene.index-creation.file-formats:

File Formats
------------

``Zend\Search\Lucene`` index file formats are binary compatible with Java Lucene version 1.4 and greater.

A detailed description of this format is available here: http://lucene.apache.org/java/2_3_0/fileformats.html
[#]_.

.. _zendsearch.lucene.index-creation.index-directory:

Index Directory
---------------

After index creation, the index directory will contain several files:

- The ``segments`` file is a list of index segments.

- The ``*.cfs`` files contain index segments. Note! An optimized index always has only one segment.

- The ``deletable`` file is a list of files that are no longer used by the index, but which could not be deleted.

.. _zendsearch.lucene.java-lucene.source-code:

Java Source Code
----------------

The Java program listing below provides an example of how to index a file using Java Lucene:

.. code-block:: java
   :linenos:

   /**
   * Index creation:
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




.. [#] The currently supported Lucene index file format version is 2.3 (starting from Zend Framework 1.6).