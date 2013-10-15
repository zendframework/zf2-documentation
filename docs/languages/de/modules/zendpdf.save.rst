.. EN-Revision: none
.. _zendpdf.save:

Änderungen an PDF Dokumenten speichern
======================================

Es gibt zwei Methoden die Änderungen an *PDF* Dokumenten speichern: Die ``ZendPdf\Pdf::save()`` und
``ZendPdf\Pdf::render()`` Methoden.

Die ``ZendPdf\Pdf::save($filename, $updateOnly = false)`` Methode speichert das *PDF* Dokument in einer Datei. Wenn
$updateOnly auf ``TRUE`` gesetzt wird, wird das neue *PDF* Segment nur an die Datei angehängt, ansonsten wird die
Datei überschrieben.

Die ``ZendPdf\Pdf::render($newSegmentOnly = false)`` Methode gibt das *PDF* Dokument als Zeichenkette zurück. Wenn
$newSegmentOnly auf ``TRUE`` gesetzt wird, wird nur das neue *PDF* Dateisegment zurückgegeben.

.. _zendpdf.save.example-1:

.. rubric:: Speichern von PDF Dokumenten

.. code-block:: php
   :linenos:

   ...
   // Lade das PDF Dokument.
   $pdf = ZendPdf\Pdf::load($fileName);
   ...
   // Aktualisiere das PDF Dokument
   $pdf->save($fileName);
   // Speichere das Dokument in eine neue Datei
   $pdf->save($newFileName, true);

   // Gib das PDF Dokument in einer Zeichenkette zurück
   $pdfString = $pdf->render();

   ...


