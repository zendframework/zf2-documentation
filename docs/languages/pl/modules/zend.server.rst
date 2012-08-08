.. EN-Revision: none
.. _zend.server.introduction:

Wprowadzenie
============

Rodzina klas *Zend_Server* zapewnia funkcjonalność dla różnych klas serwerów, włączając w to klasy
*Zend_XmlRpc_Server*, *Zend_Rest_Server*, *Zend_Json_Server* oraz *Zend_Soap_Wsdl*. *Zend_Server_Interface*
zapewnia interfejs który naśladuje klasę PHP5 *SoapServer*; wszystkie klasy serwerów powinny implementować ten
interfejs w celu zapewnienia standardowego API serwera.

Klasa *Zend_Server_Reflection* zapewnia standardowy mechanizm przeprowadzania introspekcji funkcji oraz klas dla
wywołań zwrotnych klas serwerów, i zapewnia dane odpowiednie do użycia z metodami *getFunctions()* oraz
*loadFunctions()* klasy *Zend_Server_Interface*.


