.. EN-Revision: none
.. _zend.server.introduction:

Wprowadzenie
============

Rodzina klas *Zend_Server* zapewnia funkcjonalność dla różnych klas serwerów, włączając w to klasy
*Zend\XmlRpc\Server*, *Zend\Rest\Server*, *Zend\Json\Server* oraz *Zend\Soap\Wsdl*. *Zend\Server\Interface*
zapewnia interfejs który naśladuje klasę PHP5 *SoapServer*; wszystkie klasy serwerów powinny implementować ten
interfejs w celu zapewnienia standardowego API serwera.

Klasa *Zend\Server\Reflection* zapewnia standardowy mechanizm przeprowadzania introspekcji funkcji oraz klas dla
wywołań zwrotnych klas serwerów, i zapewnia dane odpowiednie do użycia z metodami *getFunctions()* oraz
*loadFunctions()* klasy *Zend\Server\Interface*.


