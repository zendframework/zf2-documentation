.. EN-Revision: none
.. _zendservice.windowsazure:

ZendService\WindowsAzure\WindowsAzure
=========================

.. _zendservice.windowsazure.introduction:

Einführung
----------

Windows Azure ist der Name von Microsoft's Software + Service Plattform, einem Betriebssystem in einem Cloud
anbietenden Services für das Hosten, Managen von skalierbaren Speichern mit Unterstützung für einfache Blobs,
Tabellen und Queues, sowie als Management Infrastruktur für provisionierte und geo-verteilte Cloud-basierte
Services, und eine Entwicklerplattform für den Azure Service Layer.

.. _zendservice.windowsazure.sdk:

Installieren der Windows Azure SDK
----------------------------------

Es gibt zwei Entwicklungs Szenarien wenn man mit Windows Azure arbeitet.

- Man kann eigene Anwendungen entwickeln indem ``ZendService\WindowsAzure\WindowsAzure`` und die Windows Azure *SDK* verwendet
  wird, welche eine lokale Entwicklungsumgebung der von der Windows Azure Cloud Infrastruktur angebotenen Services
  anbietet.

- Man kann eine Anwendung entwickeln indem ``ZendService\WindowsAzure\WindowsAzure`` verwendet, und direkt mit der Windows
  Azure Cloud Infrastruktur gearbeitet wird.

Der erste Fall benötigt die Installation der `Windows Azure SDK`_ auf der Entwicklungsmaschine. Sie ist aktuell
nur für Windows Umgebungen vorhanden; es gibt Fortschritte für eine Java-basierende Version der *SDK* welche auf
jeder Plattform ausgeführt werden kann.

Der letztere Fall benötigt einen Account bei `Azure.com`_.

.. _zendservice.windowsazure.apiDocumentation:

API Dokumentation
-----------------

Die Klasse ``ZendService\WindowsAzure\WindowsAzure`` bietet den *PHP* Wrapper zum Windows Azure *REST* Interface. Man sollte
die `REST Dokumentation`_ für eine detailiertere Beschreibung des Services konsultieren. Man sollte mit den
grundsätzlichen Konzepten vertraut sein um diesen Service zu verwenden.

.. _zendservice.windowsazure.features:

Features
--------

``ZendService\WindowsAzure\WindowsAzure`` bietet die folgende Funktionalität:

- *PHP* Klassen für Windows Azure Blobs, Tabellen und Queues (für *CRUD* Operationen)

- Helfer Klassen für *HTTP* Transport, AuthN/AuthZ, *REST* und Fehlermanagement

- Managebarkeit, Instrumentierbarkeit und Logging Support

.. _zendservice.windowsazure.architecture:

Architektur
-----------

``ZendService\WindowsAzure\WindowsAzure`` bietet Zugriff zu Windows Azure's Speicher, Berechnungs und Management Interfaces
durch Abstrahierung des *REST*-*XML* Interfaces welches Windows Azure bietet in einer einfachen *PHP* *API*.

Eine Anwendung welche durch Verwendung von ``ZendService\WindowsAzure\WindowsAzure`` gebaut wurde kann auf die Features von
Windows Azure zugreifen, unabhängig davon ob Sie auf der Windows Azure Plattform oder auf einem unabhängigen Web
Server gehostet wird.



.. _`Windows Azure SDK`: http://www.microsoft.com/downloads/details.aspx?FamilyID=6967ff37-813e-47c7-b987-889124b43abd&displaylang=en
.. _`Azure.com`: http://www.azure.com
.. _`REST Dokumentation`: http://msdn.microsoft.com/en-us/library/dd179355.aspx
