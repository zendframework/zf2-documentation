.. EN-Revision: none
.. _zendpdf.interactive-features:

Interaktive Features
====================

.. _zendpdf.pages.interactive-features.destinations:

Ziele
-----

Ein Ziel definiert eine spezielle Sicht eines Dokuments, bestehend aus den folgenden Elementen:

- Die Seite des Dokuments das angezeigt werden soll.

- Der Ort des Dokumenten Fensters auf dieser Seite.

- Der Zoom Faktor der verwendet werden soll wenn die Seite angezeigt wird.

Ziele können mit Outline Elementen ((:ref:`Document Outline (bookmarks)
<zendpdf.pages.interactive-features.outlines>`), Hinweisen (:ref:`Annotations
<zendpdf.pages.interactive-features.annotations>`), oder Aktionen (:ref:`Actions
<zendpdf.pages.interactive-features.actions>`) verknüpft werden. In jedem Fall spezifiziert das Ziel die Sicht
des Dokuments welche dargestellt werden soll wenn das Outline Element oder der Hinweis geöffnet, oder die Aktion
durchgeführt werden soll. Zusätzlich kann eine optionale Dokument Öffnungs-Aktion spezifiziert werden.

.. _zendpdf.pages.interactive-features.destinations.types:

Unterstützte Zieltypen
^^^^^^^^^^^^^^^^^^^^^^

Die folgenden Typen werden von der ``ZendPdf`` Komponente unterstützt.

.. _zendpdf.pages.interactive-features.destinations.types.zoom:

ZendPdf\Destination\Zoom
^^^^^^^^^^^^^^^^^^^^^^^^^

Zeigt die spezifizierte Seite, mit den Koordinaten (Links, Oben) positioniert an der oberen-linken Ecke des
Fensters und dem Inhalt der Seite vergrößert auf den Zoom Faktor.

Zielobjekte können durch Verwendung der ``ZendPdf\Destination\Zoom::create($page, $left = null, $top = null,
$zoom = null)`` Methode erstellt werden.

Wobei:

- ``$page`` eine Zielseite ist (ein ``ZendPdf\Page`` Objekt oder eine Seitennummer).

- ``$left`` ist die linke Ecke der angezeigten Seite (float).

- ``$top`` ist eine obere Ecke der angezeigten Seite (float).

- ``$zoom`` ist ein Zoom Faktor (float).

``NULL``, wenn es für die ``$left``, ``$top`` or ``$zoom`` Parameter spezifiziert wird, heißt "aktueller Wert der
Viewer Anwendung".

Die ``ZendPdf\Destination\Zoom`` Klasse bietet die folgenden Methoden an:

- ``Float`` ``getLeftEdge()``;

- ``setLeftEdge(float $left)``;

- ``Float`` ``getTopEdge()``;

- ``setTopEdge(float $top)``;

- ``Float`` ``getZoomFactor()``;

- ``setZoomFactor(float $zoom)``;

.. _zendpdf.pages.interactive-features.destinations.types.fit:

ZendPdf\Destination\Fit
^^^^^^^^^^^^^^^^^^^^^^^^

Zeigt die spezifizierte Seite an, wobei der Inhalt soweit vergrössert wird, dass er auf die komplette Seite passt
sowohl Horizontal als auch Vertikal im Fenster. Wenn die benötigten horizontalen und vertikalen
Vergrösserungsfaktoren unterschiedlich sind, wird der kleinere der zwei verwendet, und die Seite im Fenster mit
der anderen Dimension zentriert.

Das Zielobjekt kann erstellt werden indem die ``ZendPdf\Destination\Fit::create($page)`` Methode verwendet wird.

Wobei ``$page`` eine Zielseite ist (ein ``ZendPdf\Page`` Objekt oder eine Seitennummer).

.. _zendpdf.pages.interactive-features.destinations.types.fit-horizontally:

ZendPdf\Destination\FitHorizontally
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Zeigt die spezifizierte Seite, mit den vertikalen Koordinaten an der oberen Ecke des Fensters positioniert, an und
den Inhalt der Seite gerade genug vergrössert damit die komplette Breite der Seite in das Fenster passt.

Das Zielobjekt kann erstellt werden indem die ``ZendPdf\Destination\FitHorizontally::create($page, $top)`` Methode
verwendet wird.

Wobei:

- ``$page`` ist eine Zielseite (ein ``ZendPdf\Page`` Objekt oder eine Seitenzahl).

- ``$top`` ist die obere Ecke der angezeigten Seite (float).

Die Klasse ``ZendPdf\Destination\FitHorizontally`` bietet auch die folgenden Methoden:

- ``Float`` ``getTopEdge()``;

- ``setTopEdge(float $top)``;

.. _zendpdf.pages.interactive-features.destinations.types.fit-vertically:

ZendPdf\Destination\FitVertically
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Zeigt die spezifizierte Seite, mit den horizontalen Koordinaten an der oberen Ecke des Fensters positioniert, an
und den Inhalt der Seite gerade genug vergrössert damit die komplette Höhe der Seite in das Fenster passt.

Das Zielobjekt kann erstellt werden indem die ``ZendPdf\Destination\FitVertically::create($page, $left)`` Methode
verwendet wird.

Wobei:

- ``$page`` ist eine Zielseite (ein ``ZendPdf\Page`` Objekt oder eine Seitenzahl).

- ``$left`` die linke Ecke der angezeigten Seite ist. (float).

Die Klasse ``ZendPdf\Destination\FitVertically`` bietet auch die folgenden Methoden:

- ``Float`` ``getLeftEdge()``;

- ``setLeftEdge(float $left)``;

.. _zendpdf.pages.interactive-features.destinations.types.fit-rectangle:

ZendPdf\Destination\FitRectangle
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Zeigt die spezifizierte Seite an, wobei der Inhalt gerade genug vergrössert ist damit er komplett in das Rechteck
passt das durch die Koordinaten links, unten, rechts und oben spezifiziert wird sowohl horizontal als auch
vertikal. Wenn die notwendigen horizontalen und vertikalen Vergrösserungsfaktoren unterschiedlich sind, wird der
kleinere der zwei verwendet, wobei das Rechteck im Fenster durch Verwendung der andern Dimension zentriert wird.

Das Zielobjekt kann erstellt werden indem die ``ZendPdf\Destination\FitRectangle::create($page, $left, $bottom,
$right, $top)`` Methode verwendet wird.

Wobei:

- ``$page`` ist eine Zielseite (ein ``ZendPdf\Page`` Objekt oder eine Seitenzahl).

- ``$left`` die linke Ecke der angezeigten Seite ist. (float).

- ``$bottom`` die untere Ecke der angezeigten Seite ist (float).

- ``$right`` die rechte Ecke der angezeigten Seite ist (float).

- ``$top`` die obere Ecke der angezeigten Seite ist (float).

Die Klasse ``ZendPdf\Destination\FitRectangle`` bietet auch die folgenden Methoden an:

- ``Float`` ``getLeftEdge()``;

- ``setLeftEdge(float $left)``;

- ``Float`` ``getBottomEdge()``;

- ``setBottomEdge(float $bottom)``;

- ``Float`` ``getRightEdge()``;

- ``setRightEdge(float $right)``;

- ``Float`` ``getTopEdge()``;

- ``setTopEdge(float $top)``;

.. _zendpdf.pages.interactive-features.destinations.types.fit-bounding-box:

ZendPdf\Destination\FitBoundingBox
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Zeigt die spezifizierte Seite an, wobei der Inhalt gerade genug vergrössert ist damit die Zeichenbox komplett in
das Fenster passt, sowohl horizontal als auch vertikal. Wenn die notwendigen horizontalen und vertikalen
Vergrösserungsfaktoren unterschiedlich sind, wird der kleinere der zwei verwendet, wobei die Zeichenbox im Fenster
durch Verwendung der andern Dimension zentriert wird.

Das Zielobjekt kann erstellt werden indem die ``ZendPdf\Destination\FitBoundingBox::create($page, $left, $bottom,
$right, $top)`` Methode verwendet wird.

Wobei ``$page`` eine Zielseite ist (ein ``ZendPdf\Page`` Objekt oder eine Seitenzahl).

.. _zendpdf.pages.interactive-features.destinations.types.fit-bounding-box-horizontally:

ZendPdf\Destination\FitBoundingBoxHorizontally
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Zeigt die spezifizierte Seite, mit den vertikalen Koordinaten an der oberen Ecke des Fensters positioniert, an und
den Inhalt der Seite gerade genug vergrössert damit die komplette Breite der Zeichenbox in das Fenster passt.

Das Zielobjekt kann erstellt werden indem die ``ZendPdf\Destination\FitBoundingBoxHorizontally::create($page,
$top)`` Methode verwendet wird.

Wobei

- ``$page`` eine Zielseite ist (ein ``ZendPdf\Page`` Objekt oder eine Seitenzahl).

- ``$top`` ist die obere Ecke der angezeigten Seite (float).

Die Klasse ``ZendPdf\Destination\FitBoundingBoxHorizontally`` bietet auch die folgenden Methoden:

- ``Float`` ``getTopEdge()``;

- ``setTopEdge(float $top)``;

.. _zendpdf.pages.interactive-features.destinations.types.fit-bounding-box-vertically:

ZendPdf\Destination\FitBoundingBoxVertically
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Zeigt die spezifizierte Seite, mit den horizontalen Koordinaten an der oberen Ecke des Fensters positioniert, an
und den Inhalt der Seite gerade genug vergrössert damit die komplette Höhe der Zeichenbox in das Fenster passt.

Das Zielobjekt kann erstellt werden indem die ``ZendPdf\Destination\FitBoundingBoxVertically::create($page,
$left)`` Methode verwendet wird.

Wobei

- ``$page`` eine Zielseite ist (ein ``ZendPdf\Page`` Objekt oder eine Seitenzahl).

- ``$left`` ist die linke Ecke der angezeigten Seite (float).

Die Klasse ``ZendPdf\Destination\FitBoundingBoxVertically`` bietet auch die folgenden Methoden:

- ``Float`` ``getLeftEdge()``;

- ``setLeftEdge(float $left)``;

.. _zendpdf.pages.interactive-features.destinations.types.named:

ZendPdf\Destination\Named
^^^^^^^^^^^^^^^^^^^^^^^^^^

Alle oben aufgeführten Ziele sind "Explizite Ziele".

Zusätzlich dazu können *PDF* Dokumente ein Verzeichnis solcher Ziele enthalten welche verwendet werden können um
nach ausserhalb des *PDF*'s zu referenzieren (z.B. '``http://www.mycompany.com/document.pdf#chapter3``').

``ZendPdf\Destination\Named`` Objekte erlauben es auf Ziele der benannten Zielverzeichnisse des Dokuments zu
referenzieren.

Benannte Zielobjekte können erstellt werden indem man die ``ZendPdf\Destination\Named::create(string $name)``
Methode verwendet.

Die Klasse ``ZendPdf\Destination\Named`` bietet eine einzige zusätzliche Methode:

``String`` ``getName()``;

.. _zendpdf.pages.interactive-features.destinations.processing:

Verarbeitung von Zielen auf Level des Dokuments
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die Klasse ``ZendPdf`` bietet ein Set von Methoden zur Verarbeitung von Zielen.

Jedes Zielobjekt (inklusive benannter Ziele) kann aufgelöst werden indem die Methode
``resolveDestination($destination)`` verwendet wird. Sie gibt ein passendes ``ZendPdf\Page`` Objekt zurück wenn
das Zielobjekt gefunden wurde, andernfalls ``NULL``.

Die Methode ``ZendPdf\PdfDocument::resolveDestination()`` nimmt auch einen optionalen booleschen Parameter
``$refreshPageCollectionHashes``, der standardmäßig ``TRUE`` ist. Er zwingt das ``ZendPdf`` Objekt die Hashes
der internen Kollektion der Seiten neu zu laden da die Liste der Seiten des Dokuments vom Benutzer aktualisiert
sein könnte indem die Eigenschaft ``ZendPdf\PdfDocument::$pages`` verwendet wird (:ref:`Arbeiten mit Seiten
<zendpdf.pages>`). Das kann aus Gründen der Performance ausgeschaltet werden, wenn bekannt ist das die Liste der
Seiten des Dokuments seit der letzten Anfragemethode nicht geändert wurde.

Die komplette Liste der benannten Ziele kann empfangen werden indem die Methode
``ZendPdf\PdfDocument::getNamedDestinations()`` verwendet wird. Sie gibt ein Array von ``ZendPdf\Target`` Objekten zurück,
welche entweder explizite Ziele oder eine GoTo Aktion sind (:ref:`Aktionen
<zendpdf.pages.interactive-features.actions>`).

Die Methode ``ZendPdf\PdfDocument::getNamedDestination(string $name)`` gibt spezifizierte benannte Ziele zurück (ein
explizites Ziel oder eine GoTo Aktion).

Das Verzeichnis der benannten Ziele des *PDF* Dokuments kann mit der Methode ``ZendPdf\PdfDocument::setNamedDestination(string
$name, $destination)`` aktualisiert werden, wobei ``$destination`` entweder ein explizites Ziel ist (jedes Ziel
ausser ``ZendPdf\Destination\Named``) oder eine GoTo Aktion.

Wenn ``NULL`` statt ``$destination`` spezifiziert ist, werden die spezifizierten benannten Ziele entfernt.

.. note::

   Benannte Ziele die nicht aufgelöst werden können, werden automatisch vom Dokument entfernt wenn das Dokument
   gespeichert wird.

.. _zendpdf.interactive-features.destinations.example-1:

.. rubric:: Beispiel für die Verwendung von Zielen

.. code-block:: php
   :linenos:

   $pdf = new ZendPdf\PdfDocument();
   $page1 = $pdf->newPage(ZendPdf\Page::SIZE_A4);
   $page2 = $pdf->newPage(ZendPdf\Page::SIZE_A4);
   $page3 = $pdf->newPage(ZendPdf\Page::SIZE_A4);
   // Erstellte Seiten, aber nicht in der Seitenliste enthalten

   $pdf->pages[] = $page1;
   $pdf->pages[] = $page2;

   $destination1 = ZendPdf\Destination\Fit::create($page2);
   $destination2 = ZendPdf\Destination\Fit::create($page3);

   // Gibt das $page2 Objekt zurück
   $page = $pdf->resolveDestination($destination1);

   // Gibt null zurück, die Seite 3 ist bis jetzt nicht im Dokument enthalten
   $page = $pdf->resolveDestination($destination2);

   $pdf->setNamedDestination('Page2', $destination1);
   $pdf->setNamedDestination('Page3', $destination2);

   // Gibt $destination2 zurück
   $destination = $pdf->getNamedDestination('Page3');

   // Gibt $destination1 zurück
   $pdf->resolveDestination(ZendPdf\Destination\Named::create('Page2'));

   // Gibt null zurück, die Seite 3 ist bis jetzt nicht im Dokument enthalten
   $pdf->resolveDestination(ZendPdf\Destination\Named::create('Page3'));

.. _zendpdf.pages.interactive-features.actions:

Aktionen
--------

Statt einfach zu einem Ziel im Dokument zu springen, kann ein Hinweis oder Outline Element eine Aktion für die
Viewer Anwendung spezifizieren die auszuführen ist, wie das starten einer Anwendung, das Abspielen eines Sounds,
oder der Änderung der Sichtweise des Hinweis Status.

.. _zendpdf.pages.interactive-features.actions.types:

Unterstützte Typen von Aktionen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die folgenden Typen von Aktionen werden beim Laden vom *PDF* Dokument erkannt:

- ``ZendPdf\Action\GoTo``- geht zu einem Ziel im aktuellen Dokument.

- ``ZendPdf\Action\GoToR``- geht zu einem Ziel in einem anderen Dokument.

- ``ZendPdf\Action\GoToE``- geht zu einem Ziel in einem eingebetteten Dokument.

- ``ZendPdf\Action\Launch``- startet eine Anwendung, öffnet oder druckt ein Dokument.

- ``ZendPdf\Action\Thread``- beginnt einen Artikel Thread zu lesen.

- ``ZendPdf\Action\URI``- löst ein *URI* auf.

- ``ZendPdf\Action\Sound``- spielt einen Sound.

- ``ZendPdf\Action\Movie``- spielt einen Film.

- ``ZendPdf\Action\Hide``- versteckt oder zeigt einen oder mehrere Hinweise auf dem Bildschirm.

- ``ZendPdf\Action\Named``- führt eine vordefinierte Aktion an der Viewer Anwendung aus:

  - **NextPage**- Geht zur nächsten Seite des Dokuments.

  - **PrevPage**- Geht zur vorhergehenden Seite des Dokuments.

  - **FirstPage**- Geht zur ersten Seite des Dokuments.

  - **LastPage**- Geht zur letzten Seite des Dokuments.

- ``ZendPdf\Action\SubmitForm``- sendet Daten zu einem eindeutigen Ressourcenziel.

- ``ZendPdf\Action\ResetForm``- setzt Felder mit Ihren Standardwerten.

- ``ZendPdf\Action\ImportData``- importiert Feldwerte von einer Datei.

- ``ZendPdf\Action\JavaScript``- führt ein JavaScript Skript aus.

- ``ZendPdf\Action\SetOCGState``- setzt den Status von einem oder mehreren optionalen Inhaltsgruppen.

- ``ZendPdf\Action\Rendition``- kontrolliert das Abspielen von Multimedia Inhalten (Beginnen, Stoppen, Pausieren
  oder Fortsetzen des Abspielens).

- ``ZendPdf\Action\Trans``- Aktualisiert das Display eines Dokuments indem ein Übersetzungsverzeichnis verwendet
  wird.

- ``ZendPdf\Action\GoTo3DView``- setzt die aktuelle Ansicht eines 3D Hinweises.

Nur ``ZendPdf\Action\GoTo`` und ``ZendPdf\Action\URI`` Aktionen können aktuell von Benutzern erstellt werden.

Goto Aktionen können erstellt werden indem die Methode ``ZendPdf\Action\GoTo::create($destination)`` verwendet
wird wobei ``$destination`` ein ``ZendPdf\Destination`` Objekt oder ein String ist der verwendet werden kann um
ein benanntes Ziel zu identifizieren.

Die Methode ``ZendPdf\Action\URI::create($uri[, $isMap])`` muss verwendet werden um eine URI Aktion zu erstellen
(siehe die *API* Dokumentation für Details). Der optionale ``$isMap`` Parameter wird standardmäßig auf ``FALSE``
gesetzt.

Es unterstützt auch die folgenden Methoden:

.. _zendpdf.pages.interactive-features.actions.chaining:

Verketten von Aktionen
^^^^^^^^^^^^^^^^^^^^^^

Aktions Objekte können verkettet werden indem die öffentliche Eigenschaft ``ZendPdf\Action::$next`` verwendet
wird.

Sie ist ein Array von ``ZendPdf\Action`` Objekten, welche auch Unter-Aktionen haben können.

Die ``ZendPdf\Action`` Klasse unterstützt das RecursiveIterator Interface damit Kinder-Aktionen iterativ
durchlaufen werden können:

.. code-block:: php
   :linenos:

   $pdf = new ZendPdf\PdfDocument();
   $page1 = $pdf->newPage(ZendPdf\Page::SIZE_A4);
   $page2 = $pdf->newPage(ZendPdf\Page::SIZE_A4);
   // Seite erstellt, aber nicht in der Seitenliste hinzugefügt
   $page3 = $pdf->newPage(ZendPdf\Page::SIZE_A4);

   $pdf->pages[] = $page1;
   $pdf->pages[] = $page2;

   $action1 = ZendPdf\Action\GoTo::create(
                               ZendPdf\Destination\Fit::create($page2));
   $action2 = ZendPdf\Action\GoTo::create(
                               ZendPdf\Destination\Fit::create($page3));
   $action3 = ZendPdf\Action\GoTo::create(
                               ZendPdf\Destination\Named::create('Chapter1'));
   $action4 = ZendPdf\Action\GoTo::create(
                               ZendPdf\Destination\Named::create('Chapter5'));

   $action2->next[] = $action3;
   $action2->next[] = $action4;

   $action1->next[] = $action2;

   $actionsCount = 1; // Achtung! Iteration enthält nicht die oberste Aktion und
                      // Arbeitet sich nur durch die Kinder
   $iterator = new RecursiveIteratorIterator(
                                           $action1,
                                           RecursiveIteratorIterator::SELF_FIRST);
   foreach ($iterator as $chainedAction) {
       $actionsCount++;
   }

   // Ausgabe 'Aktionen im Baum: 4'
   printf("Aktionen im Baum: %d\n", $actionsCount++);

.. _zendpdf.pages.interactive-features.actions.open-action:

Dokument Öffnen Aktion
^^^^^^^^^^^^^^^^^^^^^^

Eine spezielle Öffnen Aktion kann durch ein Ziel spezifiziert werden das angezeigt werden soll, oder eine Aktion
die ausgeführt werden soll wenn das Dokument geöffnet wird.

Die ``ZendPdf\Target ZendPdf\PdfDocument::getOpenAction()`` Methode gibt die aktuelle Dokument Öffnen Aktion zurück (oder
``NULL`` wenn die Öffnen Aktion nicht gesetzt ist).

Die ``setOpenAction(ZendPdf\Target $openAction = null)`` Methode setzt eine Dokument Öffnen Aktion oder löscht
diese wenn ``$openAction`` ``NULL`` ist.

.. _zendpdf.pages.interactive-features.outlines:

Dokument Outline (Bookmarks)
----------------------------

Ein PDF Dokument kann optional ein Dokument Outline am Schirm anzeigen, welcher es dem Benutzer erlaubt interaktiv
von einem Teil des Dokuments zu einem anderen zu navigieren. Der Outline besteht aus einer baum-strukturierten
Hierarchie von Outline Elementen (manchmal Bookmarks genannt), welche als visuelle Tabelle des Inhalts fungieren um
dem Benutzer die Struktur des Dokuments anzuzeigen. Der Benutzer kann individuelle Elemente interaktiv öffnen und
schließen indem er Sie mit der Maus anklickt. Wenn ein Element geöffnet ist, werden seine unmittelbaren Kinder in
der Hierarchie auf dem Schirm sichtbar; jedes Kind kann seinerseits geöffnet und geschlossen werden, das weitere
Teile der Hierarchie selektiv anzeigt oder versteckt. Wenn ein Element geschlossen wird, werden alle seine
abhängigen Elemente in der Hierarchie versteckt. Das Klicken auf einen Text von irgendeinem sichtbaren Element
aktiviert dieses Element, was dazu führt das die anzeigende Anwendung zum Ziel springt oder eine mit dem Element
assoziierte Aktion ausführt.

Die Klasse ``ZendPdf`` bietet eine öffentliche Eigenschaft ``$outlines`` welche ein Array von
``ZendPdf\Outline`` Objekten ist.

.. code-block:: php
   :linenos:

   $pdf = ZendPdf\PdfDocument::load($path);

   // Entfernt ein Outline Element
   unset($pdf->outlines[0]->childOutlines[1]);

   // Setzt Outline damit es Dick angezeigt wird
   $pdf->outlines[0]->childOutlines[3]->setIsBold(true);

   // Fügt den Outline Eintrag hinzu
   $pdf->outlines[0]->childOutlines[5]->childOutlines[] =
       ZendPdf\Outline::create('Chapter 2', 'chapter_2');

   $pdf->save($path, true);

Outline Attribute können mit Hilfe der folgenden Methoden empfangen oder gesetzt werden:

- ``string getTitle()``- holt den Titel des Outline Elements.

- ``setTitle(string $title)``- setzt den Titel des Outline Elements.

- ``boolean isOpen()``-``TRUE`` wenn Outline standardmäßig geöffnet ist.

- ``setIsOpen(boolean $isOpen)``- setzt den isOpen Status.

- ``boolean isItalic()``-``TRUE`` wenn das Outline Element schräg dargestellt wird.

- ``setIsItalic(boolean $isItalic)``- setzt den isItalic Status.

- ``boolean isBold()``-``TRUE`` wenn das Outline Element dick dargestellt wird.

- ``setIsBold(boolean $isBold)``- setzt den isBold Status.

- ``ZendPdf\Color\Rgb getColor()``- holt die Outline Text Farbe (``NULL`` bedeutet schwarz).

- ``setColor(ZendPdf\Color\Rgb $color)``- setzt die Outline Text Farbe (``NULL`` bedeutet schwarz).

- ``ZendPdf\Target getTarget()``- holt das Outline Ziel (eine Aktion oder ein benanntes Zielobjekt).

- ``setTarget(ZendPdf\Target|string $target)``- setzt ein Outline Ziel (Aktion oder Ziel). Ein String kann
  verwendet werden um ein benanntes Ziel zu identifizieren. ``NULL`` bedeutet 'kein Ziel'.

- ``array getOptions()``- holt die Outline Attribute als Array.

- ``setOptions(array $options)``- setzt Outline Optionen. Die folgenden Optionen werden erkannt: 'title', 'open',
  'color', 'italic', 'bold', und 'target'.

Ein neues Outline kann auf folgenden zwei Wegen erstellt werden:

- ``ZendPdf\Outline::create(string $title[, ZendPdf\Target|string $target])``

- ``ZendPdf\Outline::create(array $options)``

Jedes Outline Objekt kann Kinder-Outline Elemente haben die in der öffentlichen Eigenschaft
``ZendPdf\Outline::$childOutlines`` aufgelistet werden. Das ist ein Array von ``ZendPdf\Outline`` Objekten.
Deshalb sind Outlines als Baum organisiert.

Die Klasse ``ZendPdf\Outline`` implementiert das RecursiveArray Interface damit man durch Kinder-Outlines rekursiv
iterieren kann indem RecursiveIteratorIterator verwendet wird:

.. code-block:: php
   :linenos:

   $pdf = ZendPdf\PdfDocument::load($path);

   foreach ($pdf->outlines as $documentRootOutlineEntry) {
       $iterator = new RecursiveIteratorIterator(
                       $documentRootOutlineEntry,
                       RecursiveIteratorIterator::SELF_FIRST
                   );
       foreach ($iterator as $childOutlineItem) {
           $OutlineItemTarget = $childOutlineItem->getTarget();
           if ($OutlineItemTarget instanceof ZendPdf\Destination) {
               if ($pdf->resolveDestination($OutlineItemTarget) === null) {
                   // Markiert ein Outline Element dessen Ziel
                   // nicht auflösbar ist mit Roter Farbe
                   $childOutlineItem->setColor(new ZendPdf\Color\Rgb(1, 0, 0));
               }
           } else if ($OutlineItemTarget instanceof ZendPdf\Action\GoTo) {
               $OutlineItemTarget->setDestination();
               if ($pdf->resolveDestination($OutlineItemTarget) === null) {
                   // Markiert ein Outline Element dessen Ziel
                   // nicht auflösbar ist mit Roter Farbe
                   $childOutlineItem->setColor(new ZendPdf\Color\Rgb(1, 0, 0));
               }
           }
       }
   }

   $pdf->save($path, true);

.. note::

   Alle Outline Elemente mit unlösbaren Zielen (oder Zielen auf GoTo Aktionen) werden aktualisiert wärend das
   dokument gespeichert wird, indem dessen Ziele auf ``NULL`` gesetzt werden. Damit wird das Dokument nicht durch
   Entfernen von Seiten korrupiert auf die durch Outlines referenziert wird.

.. _zendpdf.pages.interactive-features.annotations:

Anhänge
-------

Ein Anhang assoziiert ein Objekt wie eine Notiz, einen Sound, oder einen Film mit einem Ort auf einer Seite in
einem PDF Dokument, oder bietet einen Weg um mit dem Benutzer zu interagieren, durch Verwendung von Maus und
Tastatur.

Alle Anhänge werden durch die abstrakte Klasse ``ZendPdf\Annotation`` repräsentiert.

Anhänge können einer Seite angehängt werden indem die Methode
``ZendPdf\Page::attachAnnotation(ZendPdf\Annotation $annotation)`` verwendet wird.

Aktuell können drei Typen von Anhängen von Benutzern erstellt werden:

- ``ZendPdf\Annotation\Link::create($x1, $y1, $x2, $y2, $target)`` wobei ``$target`` ein Aktionsobjekt oder ein
  Ziel oder ein String ist (welche für ein benanntes Zielobjekt verwendet werden kann).

- ``ZendPdf\Annotation\Text::create($x1, $y1, $x2, $y2, $text)``

- ``ZendPdf\Annotation\FileAttachment::create($x1, $y1, $x2, $y2, $fileSpecification)``

Ein Link-Anhang repräsentiert entweder einen Hypertext Link oder ein Ziel anderswo im Dokument oder eine Aktion
die ausgeführt werden soll.

Ein Text Anhang repräsentiert eine "schnelle Notiz" die an einem Punkt im PDF Dokument angehängt ist.

Ein File Anhang enthält eine Referenz zu einer Datei.

Die folgenden Methoden können von allen Typen von Anhängen verwendet werden:

- ``setLeft(float $left)``

- ``float getLeft()``

- ``setRight(float $right)``

- ``float getRight()``

- ``setTop(float $top)``

- ``float getTop()``

- ``setBottom(float $bottom)``

- ``float getBottom()``

- ``setText(string $text)``

- ``string getText()``

Die Text Anhang Eigenschaft ist ein Text der für den Anhang dargestellt wird oder, wenn dieser Typ von Anhang
keinen Text darstellt, eine alternative Beschreibung des Inhalts des Anhangs in einer menschlich lesbaren Form.

Link Anhangs Objekte bieten auch zwei zusätzliche Methoden:

- ``setDestination(ZendPdf\Target|string $target)``

- ``ZendPdf\Target getDestination()``


