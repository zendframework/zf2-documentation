.. EN-Revision: none
.. _zend.server.introduction:

Introdução
==========

A família de classes do ``Zend_Server`` fornece funcionalidades para as várias classes de servidores, incluindo
``Zend_XmlRpc_Server``, ``Zend_Rest_Server``, ``Zend_Json_Server`` e ``Zend_Soap_Wsdl``. ``Zend_Server_Interface``
fornece uma interface que imita a classe ``SoapServer`` do *PHP* 5; todas as classes de servidores deverão
implementar esta interface, a fim de fornecer uma *API* padrão de servidor.

A árvore ``Zend_Server_Reflection`` fornece um mecanismo padrão para executar introspecção de função e classe
para usar como chamadas de retorno com as classes de servidor, e fornecer dados adequados para uso com os métodos
``getFunctions()`` e ``loadFunctions()`` do ``Zend_Server_Interface``.


