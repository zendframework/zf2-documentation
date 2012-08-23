.. EN-Revision: none
.. _zend.pdf.create:

Erstellen und Laden von PDF Dokumenten
======================================

Die ``Zend_Pdf`` Klasse bildet das *PDF* Dokument ab und stellt Operationen auf Dokumentebene bereit.

Um ein neues Dokument zu stellen, sollte zuerst ein neues ``Zend_Pdf`` Objekt erstellt werden.

Die ``Zend_Pdf`` Klasse stellt zwei statische Methoden zum Laden von bestehenden *PDF* Dokumenten bereit. Dies sind
die ``Zend_Pdf::load()`` und ``Zend_Pdf::parse()`` Methoden. Beide geben als Ergebnis ``Zend_Pdf`` Objekte zurück
oder werfen eine Ausnahme, wenn ein Fehler auftritt.

.. _zend.pdf.create.example-1:

.. rubric:: Erstellen und Laden von PDF Dokumenten

.. code-block:: php
   :linenos:

   ...
   // Erstelle ein neues PDF Dokument
   $pdf1 = new Zend_Pdf();

   // Lade ein PDF Dokument aus einer Datei
   $pdf2 = Zend_Pdf::load($fileName);

   // Lade ein PDF Dokument aus einer Zeichenkette
   $pdf3 = Zend_Pdf::parse($pdfString);
   ...

Das *PDF* Datei Format unterstützt die schrittweise Aktualisierung von Dokumenten. Jedes Mal, wenn ein Dokument
aktualisiert wird, wird eine neue Revision des Dokuments erstellt. Die ``Zend_Pdf`` Komponente unterstützt die
Rückgabe einer vorgegebenen Revision des Dokuments.

Die Revision kann den Methoden ``Zend_Pdf::load()`` und ``Zend_Pdf::parse()`` als zweiter Parameter übergeben oder
durch Aufruf der ``Zend_Pdf::rollback()`` Methode. [#]_ Aufruf angefordert werden.

.. _zend.pdf.create.example-2:

.. rubric:: Rückgabe einer vorgegebenen Revision eines PDF Dokuments

.. code-block:: php
   :linenos:

   ...
   // Lade die vorherige Revision des PDF Dokuments
   $pdf1 = Zend_Pdf::load($fileName, 1);

   // Lade die vorherige Revision des PDF Dokuments
   $pdf2 = Zend_Pdf::parse($pdfString, 1);

   // Lade die erste Revision des PDF Dokuments
   $pdf3 = Zend_Pdf::load($fileName);
   $revisions = $pdf3->revisions();
   $pdf3->rollback($revisions - 1);
   ...



.. [#] Die ``Zend_Pdf::rollback()`` Methode muss vor einer Änderung eines Dokuments aufgerufen werden, andernfalls
       ist das Verhalten nicht definiert.