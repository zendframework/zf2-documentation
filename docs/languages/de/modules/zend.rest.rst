.. EN-Revision: none
.. _zend.rest.introduction:

Einführung
==========

REST Web Services verwenden ein service-spezifisches *XML* Format. Dieser ad-hoc Standard bedeutet, dass die Art
des Zugriffs auf einen REST Web Service, für jeden Service unterschiedlich ist. REST Web Services verwenden
typischerweise *URL* Parameter (``GET`` Daten) oder Pfad Informationen für die Anfrage von Daten und POST Daten
für das Senden von Daten.

Zend Framework bietet beide Möglichkeiten, Client und Server, welche, wenn Sie zusammen benutzt werden, eine viel
größere "logische" Interface Erfahrung über den Zugriff, auf virtuelle Objekt Eigenschaften erlauben. Die Server
Komponente bietet automatische Darstellung von Funktionen und Klassen und verwendet ein bedeutungsvolles und
einfaches *XML* Format. Beim Zugriff auf solche Services mit dem Client, ist es möglich, die zurückgegebenen
Daten vom Entfernten Aufruf einfachst zu erhalten. Sollte es gewünscht sein den Client mit einem
nicht-Zend\Rest\Server basierenden Service zu verwenden, bietet er immer noch vereinfachten Zugriff auf die Daten.

Zusätzlich zu den Komponenten ``Zend\Rest\Server`` und ``Zend\Rest\Client`` bieten die Klassen
:ref:`Zend\Rest\Route und Zend\Rest\Controller <zend.controller.router.routes.rest>` Hilfe beim Routen von REST
Anfragen zum Controller.


