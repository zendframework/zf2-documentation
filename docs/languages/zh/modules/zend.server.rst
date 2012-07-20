.. _zend.server.introduction:

简介
==

*Zend_Server* 类家族为各种各样的服务器类提供功能，包括 *Zend_XmlRpc_Server*\ 、
*Zend_Rest_Server*\ 、 *Zend_Json_Server* 和 *Zend_Soap_Wsdl*\ 。 *Zend_Server_Interface* 提供了一个模仿
PHP 5 的 *SoapServer* 类的接口；为了提供标准的服务器
API，所有的服务器类应该实现这个接口。

*Zend_Server_Reflection* 树提供了一个标准机制，在这个机制下，执行函数和类子定义（
introspection )被用做和服务器类一起的回调（callback）；也提供了适合与
*Zend_Server_Interface* 的 *getFunctions()* 和 *loadFunctions()* 方法一起使用的数据。


