.. _zend.search.lucene.java-lucene:

Взаимодействие с Java Lucene
============================

.. _zend.search.lucene.index-creation.file-formats:

Форматы файлов
--------------

Форматы файлов индекса Zend_Search_Lucene являются совместимыми с Lucene
версии 1.4 и выше.

Подробное описание этого формата можно прочитать здесь:
`http://lucene.apache.org/java/docs/fileformats.html`_.

.. _zend.search.lucene.index-creation.index-directory:

Директория для индекса
----------------------

После создания индекса директория для индекса будет содержать
несколько файлов:

- файл ``segments`` является списком сегментов индекса.

- файлы ``*.cfs`` содержат сегменты индекса. Внимание!
  Оптимизированный индекс всегда имеет только один сегмент.

- файл ``deletable`` является списком файлов, которые больше не
  используются индексом, но которые нельзя было удалить.

.. _zend.search.lucene.java-lucene.source-code:

Исходный код Java
-----------------

Приведенный ниже листинг программы на Java представляет собой
пример того, как индексировать файл, используя Java Lucene:

.. code-block:: java
   :linenos:

   /**
   * Создание индекса:
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



.. _`http://lucene.apache.org/java/docs/fileformats.html`: http://lucene.apache.org/java/docs/fileformats.html
