.. EN-Revision: none
.. _zendpdf.info:

Dokument Informationen und Metadaten
====================================

Ein *PDF* Dokument kann generelle Informationen wie den Titel, Author, und Erstellungs- sowie Modifikationsdatum
enthalten.

Historisch wird diese Information durch das Verwenden einer speziellen Info Struktur gespeichert. Diese struktur
kann als assoziatives Array mithilfe der öffentlichen ``properties`` Eigenschaft des ``ZendPdf`` Objektes gelesen
und geschrieben werden:

.. code-block:: php
   :linenos:

   $pdf = ZendPdf\Pdf::load($pdfPath);

   echo $pdf->properties['Title'] . "\n";
   echo $pdf->properties['Author'] . "\n";

   $pdf->properties['Title'] = 'Neuer Titel.';
   $pdf->save($pdfPath);

Die folgenden Schlüssel sind im *PDF* v1.4 (Acrobat 5) Standard definiert:



   - **Title**- String, optional, der Titel des Dokuments.

   - **Author**- String, optional, der Name der Person die das Dokument erstellt hat.

   - **Subject**- String, optional, was das Dokument beschreibt.

   - **Keywords**- String, optional, mit dem Dokument assoziierte Wörter.

   - **Creator**- String, optional, wenn das Dokument von einem anderen Format zu *PDF* konvertiert wurde, der Name
     der Anwendung (zum Beispiel, Adobe FrameMaker®) die das originale Dokument erstellt hat von dem es
     konvertiert wurde.

   - **Producer**- String, optional, wenn das Dokument von einem anderen Format zu *PDF* konvertiert wurde, der
     Name der Anwendung (zum Beispiel, Acrobat Distiller) die es zu *PDF* konvertiert hat.

   - **CreationDate**- Wtring, optional, Datum und Zeit der Erstellung des Dokumentes in der folgenden Form
     "D:YYYYMMDDHHmmSSOHH'mm'" wobei:



        - **YYYY** ist das Jahr.

        - **MM** ist der Monat.

        - **DD** ist der Tag (01–31).

        - **HH** ist die Stunde (00–23).

        - **mm**\ ist die Minute (00–59).

        - **SS** ist die Sekunde (00–59).

        - **O** ist die Relation der lokalen Zeit zur Univeral Zeit (UT), vorangestellt von einem der folgenden
          Zeichen +, -, oder Z (siehe anbei).

        - **HH** gefolgt von ' ist der absolute Wert des Offsets von UT in Stunden (00–23).

        - **mm** gefolgt von ' ist der absolute Wert des Offsets von UT in Minuten (00–59).

     Das Apostroph Zeichen (') nach HH und mm ist Teil der Syntax. Alle Felder nach dem Jahr sind optional. (Die
     Prefix D:, obwohl auch optional, wird dringend empfohlen.) Der Standardwert für MM und DD sind beide 01; alle
     anderen numerischen Felder sind standardmäßig 0. Ein Pluszeichen (+) als Wert des O Feldes bedeutet das die
     lokale Zeit später als UT ist, ein Minuszeiche das die lokale Zeit früher als UT ist, und das Zeichen Z das
     die lokale Zeit identisch mit UT ist. Wenn keine UT Information spezifiziert ist, wird die Relation der
     spezifizierten Zeit zu UT als unbekannt angenommen. Egal ob die Zeitzone bekannt ist oder nicht, sollte der
     Rest des Datums in lokaler Zeit spezifiziert werden.

     Zum Beispiel, 23. Dezember, 1998, um 19:52, U.S. Pazifik Standard Zeit, wird dargestellt durch den String
     "D:199812231952−08'00'".

   - **ModDate**- String, optional, das Datum und die Uhrzeit an dem das Dokument zuletzt geändert wurde, im
     selben Format wie **CreationDate**.

   - **Trapped**- bool, optional, zeigt ob das Dokument modifiziert wurde um eingeschlossene Informationen zu
     enthalten.



        - **TRUE**- Das Dokument wurde vollständig eingeschlossen; weiteres einschließen ist nicht notwendig.

        - **FALSE**- Das Dokument wurde bisher noch nicht eingeschlossen, wenn das Einschließen gewümscht wird
          muß es noch getan werden.

        - **NULL**- Entweder ist nicht bekannt ob das Dokument eingeschlossen wurde, oder es wurde bisher erst
          teilweise aber noch nicht vollständig eingeschlosssen; etwas zusätzliches Einschließen ist trotzdem
          noch notwendig.





Seit *PDF* v 1.6 können Metadaten in einem speziellen *XML* Dokument gespeichert werden das dem *PDF* angehängt
wird (XMP -`Extensible Metadata Platform`_).

Dieses *XML* Dokument kann empfangen und dem PDF mit der ``ZendPdf\Pdf::getMetadata()`` und der
``ZendPdf\Pdf::setMetadata($metadata)`` Methode wieder hinzugefügt werden:

.. code-block:: php
   :linenos:

   $pdf = ZendPdf\Pdf::load($pdfPath);
   $metadata = $pdf->getMetadata();
   $metadataDOM = new DOMDocument();
   $metadataDOM->loadXML($metadata);

   $xpath = new DOMXPath($metadataDOM);
   $pdfPreffixNamespaceURI = $xpath->query('/rdf:RDF/rdf:Description')
                                   ->item(0)
                                   ->lookupNamespaceURI('pdf');
   $xpath->registerNamespace('pdf', $pdfPreffixNamespaceURI);

   $titleNode = $xpath->query('/rdf:RDF/rdf:Description/pdf:Title')->item(0);
   $title = $titleNode->nodeValue;
   ...

   $titleNode->nodeValue = 'New title';
   $pdf->setMetadata($metadataDOM->saveXML());
   $pdf->save($pdfPath);

Übliche Eingenschaften von Dokumenten werden verdoppelt un din der Info Struktur und dem Metadaten Dokument (wenn
vorhanden) gespeichert. Die anwendung des Benutzer ist dafür verantwortlich das beide Synchron gehalten werden.



.. _`Extensible Metadata Platform`: http://www.adobe.com/products/xmp/
