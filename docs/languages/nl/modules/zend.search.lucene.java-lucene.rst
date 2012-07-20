.. _zend.search.lucene.java-lucene:

Interoperatie met Java Lucene
=============================

.. _zend.search.lucene.index-creation.file-formats:

Bestandsformaten
----------------

Het bestandsformaat van het Zend_Search_Lucene index bestand is binary compatible met Lucene versie 1.4 en hoger.

Een gedetailleerde beschrijving van dit formaat is beschikbaar op:
`http://lucene.apache.org/java/docs/fileformats.html`_.

.. _zend.search.lucene.index-creation.index-directory:

Index Map
---------

Na het aanmaken van de index zal de index map verschillende bestanden bevatten:

- het ``segments`` bestand is een lijst van index segmenten.

- ``*.cfs`` bestanden bevatten index segmenten. Nota! Een geoptimaliseerde index heeft altijd slechts één
  segment.

- het ``deletable`` bestand is een lijst bestanden die niet langer worden gebruikt door de index, maar niet konden
  worden verwijderd.

.. _zend.search.lucene.java-lucene.source-code:

Java Broncode
-------------

Het volgende Java programmavoorbeeld geeft een voorbeeld van hoe je een bestand indexeert via Java Lucene:

.. code-block::
   :linenos:

   /**
   * Aanmaak van de Index:
   */
   import org.apache.lucene.index.IndexWriter;
   import org.apache.lucene.document.*;

   import java.io.*

   ...

   IndexWriter indexWriter = new IndexWriter("/data/mijn_index",
                                             new SimpleAnalyzer(), true);

   ...

   String filename = "/pad/naar/bestand-dat-moet-worden-geindexeerd.txt"
   File f = new File(filename);

   Document doc = new Document();
   doc.add(Field.Text("path", filename));
   doc.add(Field.Keyword("modified",DateField.timeToString(f.lastModified())));
   doc.add(Field.Text("author", "unknown"));
   FileInputStream is = new FileInputStream(f);
   Reader reader = new BufferedReader(new InputStreamReader(is));
   doc.add(Field.Text("contents", reader));

   indexWriter.addDocument(doc);

.. _zend.search.lucene.java-lucene.jar:

LuceneIndexCreation.jar gebruiken
---------------------------------

Om snel te kunnen starten met Zend_Search_Lucene werd een JAR bestand (Java) aangemaakt dat je toelaat een index
vanaf de commandoregel aan te maken. Voor meer informatie over JAR bestanden kan je terecht op:
`http://java.sun.com/docs/books/tutorial/jar/basics/index.html`_.

LuceneIndexCreation.jar leest tekst bestanden door en maakt er een index voor aan. Gebruik:

.. code-block::
   :linenos:

       java -jar LuceneIndexCreation.jar [-c] [-s] <document_pad> <index_pad>
       -c   - dwing de index naar case sensitive
       -s   - inhoud in de index opslaan

Dit commando leest een map *<document_map>* door, inclusief alle onderliggende mappen, en maakt een Lucene index
aan. De index is een set bestanden die in een andere map, gespecificeerd door *<index_map>*, zullen worden
opgeslagen..

Voor elk document dat moet worden geïndexeerd maakt LuceneIndexCreation een documentobject aan met drie velden:
een **contents** veld dat de inhoud (body) van het document bevat en een **modifies** veld dat de
bestandswijzigingstijd bevat en tenslotte het *<path>* veld dat het volledige pad en de bestandsnaam bevat.

Indien de -c optie werd gespecificeerd zal de index tot case sensitive gedwongen worden. Indien niet, zullen alle
termen naar kleine letters worden geconverteerd voor ze aan de index worden toegevoegd.

Indien de -s optie werd gespecificeerd, zal de inhoud van het document ook in de index worden opgeslagen. Die kan
dan via de velden *path* en *modified* worden opgeroepen.

Anders worden alleen de *path* en *modified* velden opgeslagen, en het *contents* veld wordt slechts geïndexeerd.
In dat geval moet de documentinhoud vanaf een oorspronkelijke bron worden opgehaald via zijn *path*.

Wees voorzichtig, het gebruik van de -s optie vergroot de index ongeveer vijf maal.



.. _`http://lucene.apache.org/java/docs/fileformats.html`: http://lucene.apache.org/java/docs/fileformats.html
.. _`http://java.sun.com/docs/books/tutorial/jar/basics/index.html`: http://java.sun.com/docs/books/tutorial/jar/basics/index.html
