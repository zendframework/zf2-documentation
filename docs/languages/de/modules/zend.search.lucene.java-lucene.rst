.. _zend.search.lucene.java-lucene:

Zusammenarbeit Mit Java Lucene
==============================

.. _zend.search.lucene.index-creation.file-formats:

Dateiformate
------------

``Zend_Search_Lucene`` Indexdateiformate sind binär kompatibel mit der Java Lucene Version 1.4 und größer.

Eine detaillierte Beschreibung dieses Formats ist hier erhältlich:
`http://lucene.apache.org/java/2_3_0/fileformats.html`_. [#]_.

.. _zend.search.lucene.index-creation.index-directory:

Indexverzeichnis
----------------

Nach der Indexerstellung wird das Indexverzeichnis verschiedene Dateien enthalten:

- Die ``segments`` Datei ist eine Liste der Indexsegmente.

- Die ``*.cfs`` Dateien enthalten die Indexsegmente. Beachte! Ein optimierter Index enthält immer nur ein Segment.

- Die ``deletable`` Datei ist eine Liste von Dateien, die vom Index nicht mehr verwendet werden, aber noch nicht
  gelöscht werden konnten.

.. _zend.search.lucene.java-lucene.source-code:

Java Quellcode
--------------

Das unten gelistete Java Programm stellt ein Beispiel für die Indizierung einer Datei mit Java Lucene dar:

.. code-block:: java
   :linenos:

   /**
   * Indexerstellung:
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

.. [#] Die aktuell unterstützte Version des Lucene Index Dateiformats ist 2.3 (beginnend mit Zend Framework 1.6).