.. EN-Revision: none
.. _zend.server.introduction:

導入
==

``Zend_Server`` 系のクラス群は、さまざまなサーバクラスの機能を提供します。
たとえば ``Zend\XmlRpc\Server``\ 、 ``Zend\Rest\Server``\ 、 ``Zend\Json\Server`` そして
``Zend\Soap\Wsdl`` などがあります。 ``Zend\Server\Interface`` は、 *PHP* 5 の *SoapServer*
クラスをまねたものです。すべてのサーバクラスは、
このインターフェイスを実装することで標準のサーバ *API* を提供しています。

``Zend\Server\Reflection`` は、
関数やクラスの内容を知るための標準的な仕組みを提供するもので、
サーバクラス群でのコールバックのために使用します。また、 ``Zend\Server\Interface`` の
``getFunctions()`` や ``loadFunctions()`` で使用できる形式のデータを提供します。


