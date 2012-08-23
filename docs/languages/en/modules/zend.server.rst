.. _zend.server.introduction:

Introduction
============

The ``Zend_Server`` family of classes provides functionality for the various server classes, including
``Zend_XmlRpc_Server``, ``Zend_Rest_Server``, ``Zend_Json_Server`` and ``Zend_Soap_Wsdl``.
``Zend_Server_Interface`` provides an interface that mimics *PHP* 5's ``SoapServer`` class; all server classes
should implement this interface in order to provide a standard server *API*.

The ``Zend_Server_Reflection`` tree provides a standard mechanism for performing function and class introspection
for use as callbacks with the server classes, and provides data suitable for use with ``Zend_Server_Interface``'s
``getFunctions()`` and ``loadFunctions()`` methods.


