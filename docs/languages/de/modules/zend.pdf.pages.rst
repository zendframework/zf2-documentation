.. EN-Revision: none
.. _zend.pdf.pages:

Arbeiten mit Seiten
===================

.. _zend.pdf.pages.creation:

Erstellen von Seiten
--------------------

Die Seiten in einem *PDF* Dokument werden durch ``Zend_Pdf_Page`` Instanzen in ``Zend_Pdf`` abgebildet.

*PDF* Seiten werden entweder aus einem vorhandenen *PDF* gelesen oder erstellt indem die *API* von ``Zend_Pdf``
verwendet wird.

Neue Seiten können durch die Instanzierung neuer ``Zend_Pdf_Page`` Objekte erstellt werden, entweder direkt oder
durch den Aufruf der ``Zend_Pdf::newPage()`` Methode, die ein ``Zend_Pdf_Page`` Objekt zurückgibt.
``Zend_Pdf::newPage()`` erstellt eine Seite die bereits an ein Dokument angehängt ist. Ungebundene Seiten können
nicht mit verschiedenen *PDF* Dokumenten verwendet werden, sind aber etwas schneller. [#]_

Die ``Zend_Pdf::newPage()`` Methode und der ``Zend_Pdf_Page`` Konstruktor benötigen die gleichen Parameter welche
die Größe der Seite spezifizieren. Sie können entweder die Seitengröße ($x, $y) in Punkten (1/72 Zoll) nehmen
oder eine vordefinierte Konstante, die den Seitentyp repräsentiert:



   - Zend_Pdf_Page::SIZE_A4

   - Zend_Pdf_Page::SIZE_A4_LANDSCAPE

   - Zend_Pdf_Page::SIZE_LETTER

   - Zend_Pdf_Page::SIZE_LETTER_LANDSCAPE



Dokumentseiten werden im öffentlichen ``$pages`` Attribut der ``Zend_Pdf`` Klasse abgelegt. Das Attribut enthält
ein Array mit ``Zend_Pdf_Page`` Objekten und definiert die komplette Instanz und die Reihenfolge der Seiten. Dieses
Array kann wie ein normales *PHP* Array verändert werden:

.. _zend.pdf.pages.example-1:

.. rubric:: Verwaltung von PDF Dokumentseiten

.. code-block:: php
   :linenos:

   ...
   // Umgekehrte Seitenreihenfolge
   $pdf->pages = array_reverse($pdf->pages);
   ...
   // Füge eine neue Seite hinzu
   $pdf->pages[] = new Zend_Pdf_Page(Zend_Pdf_Page::SIZE_A4);
   // Füge eine neue Seite hinzu
   $pdf->pages[] = $pdf->newPage(Zend_Pdf_Page::SIZE_A4);

   // Entferne eine bestimmte Seite
   unset($pdf->pages[$id]);

   ...

.. _zend.pdf.pages.cloning:

Klonen von Seiten
-----------------

Bestehende *PDF* Seiten können durch das Erstellen eines neuen ``Zend_Pdf_Page`` Objektes geklont werden indem
eine existierende Seite als Parameter angegeben wird:

.. _zend.pdf.pages.example-2:

.. rubric:: Klonen bestehender Seiten

.. code-block:: php
   :linenos:

   ...
   // Die Template Seite in einer separaten Variable speichern
   $template = $pdf->pages[$templatePageIndex];
   ...
   // Neue Seite hinzufügen
   $page1 = new Zend_Pdf_Page($template);
   $pdf->pages[] = $page1;
   ...

   // Andere Seite hinzufügen
   $page2 = new Zend_Pdf_Page($template);
   $pdf->pages[] = $page2;
   ...

   // Die Quell Template Seite von den Dokumenten entfernen
   unset($pdf->pages[$templatePageIndex]);

   ...

Das ist nützlich wenn verschiedene Seite mit Hilfe eines Templates erstellt werden sollen.

.. caution::

   Wichtig! Geklonte Seiten verwenden die gleichen *PDF* Ressourcen mit der Template Seite. Diese kann also nur
   innerhalb des gleichen Dokuments als Template Seite verwendet werden. Modifizierte Dokumente können als neue
   abgespeichert werden.



.. [#] Dies ist eine Einschränkung der aktuellen Zend Framework Version. Sie wird in zukünftigen Versionen
       beseitigt werden. Aber ungebundene Seiten werden immer ein besseres (also optimaleres) Ergebnis für
       gemeinsame Benutzung in Dokumenten liefern.