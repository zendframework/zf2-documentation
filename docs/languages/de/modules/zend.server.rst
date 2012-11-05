.. EN-Revision: none
.. _zend.server.introduction:

Einführung
==========

Die ``Zend_Server`` Klassenfamilie stellt Funktionalitäten für die verschiedenen Serverklassen bereit, inklusive
``Zend\XmlRpc\Server``, ``Zend\Rest\Server``, ``Zend\Json\Server`` und ``Zend\Soap\Wsdl``.
``Zend\Server\Interface`` stellt eine Interface bereit, welches *PHP* 5's ``SoapServer`` Klasse immitiert; alle
Server Klassen sollten dieses Interface implementieren, um eine Standard Server *API* bereit zu stellen.

Der ``Zend\Server\Reflection`` Baum stellt einen Standardmechanismus bereit, um Funktion und Klassen Introspektion
für die Verwendung als Rückfragen mit den Server Klassen bereit zu stellen und stellt Daten passend für die
Verwendung von ``Zend\Server\Interface``'s ``getFunctions()`` und ``loadFunctions()`` Methoden bereit.


