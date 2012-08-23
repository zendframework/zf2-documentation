.. EN-Revision: none
.. _zend.server.introduction:

Introduction
============

La famille de classes ``Zend_Server`` fournit des fonctionnalités pour les différentes classes serveur, notamment
``Zend_XmlRpc_Server``, ``Zend_Rest_Server``, ``Zend_Json_Server`` et ``Zend_Soap_Wsdl``. ``Zend_Server_Interface``
fournit une interface qui imite la classe *SoapServer* de PHP5; toutes les classes serveur devraient implémenter
cette interface de manière à fournir une *API* serveur standard.

L'arbre ``Zend_Server_Reflection`` fournit un mécanisme standard permettant de réaliser l'introspection de
fonctions et de classes afin de s'en servir comme callback avec les classes serveur, et fournit des données
appropriées pour les méthodes ``getFunctions()`` et ``loadFunctions()`` de ``Zend_Server_Interface``.


