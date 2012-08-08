.. EN-Revision: none
.. _learning.lucene.index-opening:

Indezes öffnen und erstellen
============================

Alle Index Operationen (z.B. Erstellung eines neuen Index, hinzufügen eines Dokuments zum Index, löschen eines
Dokuments, suchen durch den Index) benötigen ein Index Objekt. Es kann empfangen werden indem eine der folgenden
zwei Methoden verwendet wird.

.. _learning.lucene.index-opening.creation:

.. rubric:: Lucene Index Erstellung

.. code-block:: php
   :linenos:

   $index = Zend_Search_Lucene::create($indexPath);

.. _learning.lucene.index-opening.opening:

.. rubric:: Lucene Index Öffnen

.. code-block:: php
   :linenos:

   $index = Zend_Search_Lucene::open($indexPath);


