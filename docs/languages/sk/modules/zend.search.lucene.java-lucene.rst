.. _zend.search.lucene.java-lucene:

Spolupráca s Java Lucene
=========================

.. _zend.search.lucene.index-creation.file-formats:

Formáty súborov
-----------------

Indexový súbor Zend_Search_Lucene je binárne kompatibilný s verziou Lucene 1.4 a vyššou.

Detailný `popis formátu`_ je k dispozícii na stránke projektu Lucene [#]_

.. _zend.search.lucene.index-creation.index-directory:

Adresár indexu
---------------

Po vytvorení indexu obsahuje adresár niekoľko súborov:

- ``segments`` je súbor, ktorý obsahuje zoznam segmentov indexu.

- ``*.cfs`` súbory ktoré obsahujú segmenty indexu. Optimalizovaný index vždy obsahuje iba jeden segment!

- ``deletable`` súbor ktorý obsahuje zoznam súborov ktoré sa už nepoužívajú indexom, ale nemohli byť
  zmazané.

.. _zend.search.lucene.java-lucene.source-code:

Zdrojový kód v Java
---------------------

Nasledujúci Java kód poskytuje príklad ako indexovať súbor s použitím Java Lucene:

.. code-block::
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



.. _`popis formátu`: http://lucene.apache.org/java/2_0_0/fileformats.html

.. [#] Aktuálne podporovaná verzia indexového súboru je v2.0.