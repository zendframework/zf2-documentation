.. _zend.server.introduction:

Úvod
====

Skupina tried *Zend_Server* poskytuje funkcionalitu pre viaceré triedy, vrátane *Zend_XmlRpc_Server*,
*Zend_Rest_Server*, *Zend_Json_Server* and *Zend_Soap_Wsdl*. *Zend_Server_Interface* poskytuje rozhranie ktoré
napodobňuje *SoapServer* triedu v PHP5. Všetky servery by mali mať implementované toto rozhranie aby mohli
poskytovať štandardné API.

Skupina tried *Zend_Server_Reflection* poskytuje nástroje pre zisťovanie informácií o funkciách a triedach
ktoré sa používajú ako spätné volania v serverových triedach a poskytuje vhodné údaje pre použitie v
metódach rozhrania *Zend_Server_Interface* (*getFunctions()* a *loadFunctions()*).


