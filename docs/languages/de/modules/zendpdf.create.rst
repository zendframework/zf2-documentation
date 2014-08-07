.. EN-Revision: none
.. _zendpdf.create:

Erstellen und Laden von PDF Dokumenten
======================================

Die ``ZendPdf`` Klasse bildet das *PDF* Dokument ab und stellt Operationen auf Dokumentebene bereit.

Um ein neues Dokument zu stellen, sollte zuerst ein neues ``ZendPdf`` Objekt erstellt werden.

Die ``ZendPdf`` Klasse stellt zwei statische Methoden zum Laden von bestehenden *PDF* Dokumenten bereit. Dies sind
die ``ZendPdf\PdfDocument::load()`` und ``ZendPdf\PdfDocument::parse()`` Methoden. Beide geben als Ergebnis ``ZendPdf`` Objekte zurück
oder werfen eine Ausnahme, wenn ein Fehler auftritt.

.. _zendpdf.create.example-1:

.. rubric:: Erstellen und Laden von PDF Dokumenten

.. code-block:: php
   :linenos:

   ...
   // Erstelle ein neues PDF Dokument
   $pdf1 = new ZendPdf\PdfDocument();

   // Lade ein PDF Dokument aus einer Datei
   $pdf2 = ZendPdf\PdfDocument::load($fileName);

   // Lade ein PDF Dokument aus einer Zeichenkette
   $pdf3 = ZendPdf\PdfDocument::parse($pdfString);
   ...

Das *PDF* Datei Format unterstützt die schrittweise Aktualisierung von Dokumenten. Jedes Mal, wenn ein Dokument
aktualisiert wird, wird eine neue Revision des Dokuments erstellt. Die ``ZendPdf`` Komponente unterstützt die
Rückgabe einer vorgegebenen Revision des Dokuments.

Die Revision kann den Methoden ``ZendPdf\PdfDocument::load()`` und ``ZendPdf\PdfDocument::parse()`` als zweiter Parameter übergeben oder
durch Aufruf der ``ZendPdf\PdfDocument::rollback()`` Methode. [#]_ Aufruf angefordert werden.

.. _zendpdf.create.example-2:

.. rubric:: Rückgabe einer vorgegebenen Revision eines PDF Dokuments

.. code-block:: php
   :linenos:

   ...
   // Lade die vorherige Revision des PDF Dokuments
   $pdf1 = ZendPdf\PdfDocument::load($fileName, 1);

   // Lade die vorherige Revision des PDF Dokuments
   $pdf2 = ZendPdf\PdfDocument::parse($pdfString, 1);

   // Lade die erste Revision des PDF Dokuments
   $pdf3 = ZendPdf\PdfDocument::load($fileName);
   $revisions = $pdf3->revisions();
   $pdf3->rollback($revisions - 1);
   ...



.. [#] Die ``ZendPdf\PdfDocument::rollback()`` Methode muss vor einer Änderung eines Dokuments aufgerufen werden, andernfalls
       ist das Verhalten nicht definiert.