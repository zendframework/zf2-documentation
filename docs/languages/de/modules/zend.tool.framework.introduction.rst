.. _zend.tool.framework.introduction:

Einführung
==========

``Zend_Tool_Framework`` ist ein Framework für die Durchführung von üblichen Funktionalitäten wie die Erstellung
von Projekt Scaffolds, Code Erzeugung, Index Erzeugung für die Suche, und vielem mehr. Funktionalität kann über
*PHP* Klassen geschrieben und ausgeführt werden die über den ``include_path`` von *PHP* eingeworfen werden, und
bieten daher eine aussergewöhnliche Flexibilität der Implementation. Die Funktionalität kann durch das Schreiben
einer Implementation und/oder einers protokoll-spezifischen Clients aufgerufen werden -- wir einen Consolen Client,
*XML-RPC*, *SOAP* und viele mehr.

``Zend_Tool_Framework`` bietet das folgende an:

- **Übliche Interfaces und Abstraktes** welche es Entwicklern erlauben Funktionalitäten und Möglichkeiten zu
  erstellen die von Tool-Clients ausgeführt werden können.

- **Basis Client Funktionalität** und eine konkrete Consolen Implementation die externe Tools und Interfaces zu
  ``Zend_Tool_Framework`` verbindet. Der Consolen Client kann in *CLI* Umgebungen wie Unix Shells und der Windows
  Console verwendet werden.

- **"Provider" und "Manifest" Interfaces** die vom Tooling System verwendet werden können. "Provider"
  repräsentieren den funktionalen Aspekt des Frameworks, und definieren die Aktionen die Tooling Clients aufrufen
  können. "Manifeste" agieren als Registrierung für Metadaten die zusätzlichen Kontext für die verschiedenen
  definierten Provider bieten.

- **Ein introspektives Ladesystem** das die Umgebung nach Providern scannt und erkennt was notwendig ist um Sie
  auszuführen.

- **Ein Standardset von System Providern** die es dem System erlauben zu berichten, was die kompletten
  Möglichkeiten des Systems sind, sowie dem Anbieten von nützlichem Feedback. Das enthält auch ein
  vollständiges "Hilfe System".

Nachfolgend sind Definitionen bei denen man sich in diesem Handbuch in Bezug auf ``Zend_Tool_Framework`` vorsehen
sollte:

- ``Zend_Tool_Framework``- Der Framework der die Tooling Möglichkeiten anbietet.

- **Tooling Client**- Ein Entwickler Tool das sich zu ``Zend_Tool_Framework`` verbindet und es verwendet.

- **Client**- Das Untersystem vom ``Zend_Tool_Framework`` das ein Interface anbietet auf welches sich Tooling
  Clients verbinden, und abfragen , sowie Kommandos ausführen können.

- **Console Client / Command Line Interface / zf.php**- Der Tooling Client für die Komandozeile.

- **Provider**- Ein Subsystem und eine Kollektion von eingebauten Funktionalitäten die der Framework exportiert.

- **Manifest**- Ein Untersystem für das Definieren, die Organisation und die Verbreitung von notwendigen
  Providerdaten.

- ``Zend_Tool_Project`` Provider - Ein Set von Providern speziell für die Erstellung und das Maintaining von
  Zend_Framework basierenden Projekten.


