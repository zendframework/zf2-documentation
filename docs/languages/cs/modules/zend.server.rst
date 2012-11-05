.. EN-Revision: none
.. _zend.server.introduction:

Úvod
====

Rodina tříd *Zend_Server* poskytuje funkcionalitu pro různé serverové třídy včetně *Zend\XmlRpc\Server*,
*Zend\Rest\Server*, *Zend\Json\Server* a *Zend\Soap\Wsdl*. *Zend\Server\Interface* poskytuje rozhraní podobné
třídě *SoapServer* z PHP5; Všechny serverové třídy by implementují toto rozhraní, aby poskytovaly
standartní serverové API.

Strom tříd *Zend\Server\Reflection* poskytuje standartní mechanismus pro zkoumání funkcí a tříd
použitelných jako callback a poskytuje data použitelná s metodami *getFunctions()* a *loadFunctions()* z
*Zend\Server\Interface*


