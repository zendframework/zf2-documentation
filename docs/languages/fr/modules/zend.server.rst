.. EN-Revision: none
.. _zend.server.introduction:

Introduction
============

La famille de classes ``Zend_Server`` fournit des fonctionnalités pour les différentes classes serveur, notamment
``Zend\XmlRpc\Server``, ``Zend\Rest\Server``, ``Zend\Json\Server`` et ``Zend\Soap\Wsdl``. ``Zend\Server\Interface``
fournit une interface qui imite la classe *SoapServer* de PHP5; toutes les classes serveur devraient implémenter
cette interface de manière à fournir une *API* serveur standard.

L'arbre ``Zend\Server\Reflection`` fournit un mécanisme standard permettant de réaliser l'introspection de
fonctions et de classes afin de s'en servir comme callback avec les classes serveur, et fournit des données
appropriées pour les méthodes ``getFunctions()`` et ``loadFunctions()`` de ``Zend\Server\Interface``.


