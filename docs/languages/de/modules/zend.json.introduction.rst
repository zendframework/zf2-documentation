.. _zend.json.introduction:

Einführung
==========

``Zend_Json`` stellt komfortable Methoden für das Serialisieren von nativem *PHP* nach *JSON* und das Dekodieren
von *JSON* in natives *PHP* bereit. Für weitere Informationen zu *JSON* `besuche die Website des JSON Projekts`_.

*JSON*, JavaScript Object Notation, kann für den Datenaustausch zwischen Javascript und anderen Sprachen verwendet
werden. Da *JSON* direkt in Javascript ausgewertet werden kann, ist es ein effizienteres und leichtgewichtigeres
Format für den Datenaustausch mit Javascript Clients als *XML*.

Zusätzlich bietet ``Zend_Json`` einen nützlichen Weg um jeglichen willkürlichen *XML* formatierten String in
einem *JSON* formatierten String zu konvertieren. Dieses eingebaute Feature ermöglicht es *PHP* Entwicklern,
Enterprise Daten die im *XML* Format kodiert sind, in das *JSON* Format zu transformieren bevor es an Browser
basierende Ajax Client Anwendungen gesendet wird. Das bietet einen einfachen Weg um dynamisch Daten mit Server
seitigem Code zu konvertieren was unnötiges *XML* Parsen auf der Browser-seitigen Anwendung verhindert. Das
offeriert eine nette nützliche Funktion was wiederum in einfacheren Anwendungs-spezifischer Datenverarbeitungs
Techniken resultiert.



.. _`besuche die Website des JSON Projekts`: http://www.json.org/
