.. _zend.server.introduction:

Úvod
====

Rodina tříd *Zend_Server* poskytuje funkcionalitu pro různé serverové třídy včetně *Zend_XmlRpc_Server*,
*Zend_Rest_Server*, *Zend_Json_Server* a *Zend_Soap_Wsdl*. *Zend_Server_Interface* poskytuje rozhraní podobné
třídě *SoapServer* z PHP5; Všechny serverové třídy by implementují toto rozhraní, aby poskytovaly
standartní serverové API.

Strom tříd *Zend_Server_Reflection* poskytuje standartní mechanismus pro zkoumání funkcí a tříd
použitelných jako callback a poskytuje data použitelná s metodami *getFunctions()* a *loadFunctions()* z
*Zend_Server_Interface*


