.. EN-Revision: none
.. _zend.pdf.introduction:

Einführung
==========

Die Komponente ``Zend_Pdf`` ist eine Manipulations Engine für *PDF* (Portable Document Format). Es kann Dokumente
laden, erstellen, verändern und speichern. Deswegen kann es jeder *PHP* Anwendung helfen *PDF* Dokumente dynamisch
zu erstellen indem bestehende Dokumente verändert oder neue von Grund auf erzeugt werden. ``Zend_Pdf`` bietet die
folgenden Features:



   - Erstellen von neuen Dokumenten oder Laden von vorhandenen Dokumenten. [#]_

   - Rückgabe einer vorgegebenen Revision eines Dokuments.

   - Verändern von Seiten innerhalb eines Dokuments. Ändern der Seitensortierung, Hinzufügen von neuen Seiten,
     Entfernen von Seiten aus einem Dokument.

   - Verschiedene einfache Grafikelemente (Linien, Rechtecke, Polygon, Kreise, Ellipsen und Kreisausschnitte).

   - Zeichnen von Texten unter Verwendung eines von 14 eingebauten Standard Zeichensätzen oder deiner eigenen
     TrueType Zeichensätze.

   - Drehungen.

   - Zeichnen von Grafiken. [#]_

   - Schrittweise Aktualisierung von *PDF* Dateien.





.. [#] Das Laden von *PDF* V1.4 (Acrobat 5) Dokumenten wird derzeit unterstützt.
.. [#] JPG, PNG [Bis zu 8bit per channel+Alpha] und TIFF Grafiken werden unterstützt.