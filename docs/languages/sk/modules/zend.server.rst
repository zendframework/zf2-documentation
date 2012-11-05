.. EN-Revision: none
.. _zend.server.introduction:

Úvod
====

Skupina tried *Zend_Server* poskytuje funkcionalitu pre viaceré triedy, vrátane *Zend\XmlRpc\Server*,
*Zend\Rest\Server*, *Zend\Json\Server* and *Zend\Soap\Wsdl*. *Zend\Server\Interface* poskytuje rozhranie ktoré
napodobňuje *SoapServer* triedu v PHP5. Všetky servery by mali mať implementované toto rozhranie aby mohli
poskytovať štandardné API.

Skupina tried *Zend\Server\Reflection* poskytuje nástroje pre zisťovanie informácií o funkciách a triedach
ktoré sa používajú ako spätné volania v serverových triedach a poskytuje vhodné údaje pre použitie v
metódach rozhrania *Zend\Server\Interface* (*getFunctions()* a *loadFunctions()*).


