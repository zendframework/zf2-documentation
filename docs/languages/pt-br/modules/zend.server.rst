.. EN-Revision: none
.. _zend.server.introduction:

Introdução
==========

A família de classes do ``Zend_Server`` fornece funcionalidades para as várias classes de servidores, incluindo
``Zend\XmlRpc\Server``, ``Zend\Rest\Server``, ``Zend\Json\Server`` e ``Zend\Soap\Wsdl``. ``Zend\Server\Interface``
fornece uma interface que imita a classe ``SoapServer`` do *PHP* 5; todas as classes de servidores deverão
implementar esta interface, a fim de fornecer uma *API* padrão de servidor.

A árvore ``Zend\Server\Reflection`` fornece um mecanismo padrão para executar introspecção de função e classe
para usar como chamadas de retorno com as classes de servidor, e fornecer dados adequados para uso com os métodos
``getFunctions()`` e ``loadFunctions()`` do ``Zend\Server\Interface``.


