.. _zend.server.introduction:

Einführung
==========

Die ``Zend_Server`` Klassenfamilie stellt Funktionalitäten für die verschiedenen Serverklassen bereit, inklusive
``Zend_XmlRpc_Server``, ``Zend_Rest_Server``, ``Zend_Json_Server`` und ``Zend_Soap_Wsdl``.
``Zend_Server_Interface`` stellt eine Interface bereit, welches *PHP* 5's ``SoapServer`` Klasse immitiert; alle
Server Klassen sollten dieses Interface implementieren, um eine Standard Server *API* bereit zu stellen.

Der ``Zend_Server_Reflection`` Baum stellt einen Standardmechanismus bereit, um Funktion und Klassen Introspektion
für die Verwendung als Rückfragen mit den Server Klassen bereit zu stellen und stellt Daten passend für die
Verwendung von ``Zend_Server_Interface``'s ``getFunctions()`` und ``loadFunctions()`` Methoden bereit.


