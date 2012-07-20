.. _zend.server.introduction:

導入
==

``Zend_Server`` 系のクラス群は、さまざまなサーバクラスの機能を提供します。
たとえば ``Zend_XmlRpc_Server``\ 、 ``Zend_Rest_Server``\ 、 ``Zend_Json_Server`` そして
``Zend_Soap_Wsdl`` などがあります。 ``Zend_Server_Interface`` は、 *PHP* 5 の *SoapServer*
クラスをまねたものです。すべてのサーバクラスは、
このインターフェイスを実装することで標準のサーバ *API* を提供しています。

``Zend_Server_Reflection`` は、
関数やクラスの内容を知るための標準的な仕組みを提供するもので、
サーバクラス群でのコールバックのために使用します。また、 ``Zend_Server_Interface`` の
``getFunctions()`` や ``loadFunctions()`` で使用できる形式のデータを提供します。


