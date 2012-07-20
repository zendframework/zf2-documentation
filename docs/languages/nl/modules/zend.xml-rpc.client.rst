.. _zend.xmlrpc.client:

Zend_XmlRpc_Client
==================

.. _zend.xmlrpc.client.introduction:

Inleiding
---------

Het gebruik van de *Zend_XmlRpc_Client* komt erg overeen met het gebruik van *SoapClient* objecten (`SOAP web
service extensie`_). Je kan gewoonweg de XML-RPC service procedures aanroepen als *Zend_XmlRpc_Client* methodes.
Specificeer het volledige adres van de service in de *Zend_XmlRpc_Client* constructor.

.. rubric:: Een basis XML-RPC verzoek

.. code-block::
   :linenos:
   <?php
   /**
   * Maak verbinding met de framework.zend.com server en krijg een array met de beschikbare methodes.
   */
   require_once 'Zend/XmlRpc/Client.php';

   $server = new Zend_XmlRpc_Client('http://framework.zend.com/xmlrpc');

   print_r( $server->system->listMethods() );
   ?>

.. note::

   De *Zend_XmlRpc_Client* probeert het op afstand aanroepen van methodes zoveel mogelijk als PHP-eigen methodes te
   laten lijken. Als een remote methode namespaces bevat zoals *system.listMethods()* hierboven, word de aanroep
   via "object chaining" gemaakt in PHP: *$server->system->listMethods()*.

.. _zend.xmlrpc.client.parameters:

Parameters gebruiken
--------------------

Sommige XML-RPC service procedures vereisen parameters. De benodigde parameters worden als parameters voor de
*Zend_XmlRpc-Client* methode doorgegeven. Parameters voor een XML-RPC procedure moeten van een bepaald XML-RPC type
zijn. Parameters kunnen op 2 manieren worden doorgegeven: als PHP-eigen variabelen of *Zend_XmlRpc_Value* objecten
die XML-RPC types voorstellen.

.. _zend.xmlrpc.client.parameters.php_native:

PHP-eigen variabelen als parameters doorgeven
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Parameters zoals een string, integer, float, boolean, array of object worden beschouwd als PHP-eigen variabelen en
zullen ook zo worden doorgegeven. In dit geval zal elk PHP-eigen type automatisch worden herkend en geconverteerd
in een van de overeenkomstige XML-RPC types aan de hand van de volgende tabel:

.. table:: PHP en XML-RPC type omzetting

   +-----------------+------------+
   |PHP Native type  |XML-RPC type|
   +=================+============+
   |integer          |int         |
   +-----------------+------------+
   |double           |double      |
   +-----------------+------------+
   |boolean          |boolean     |
   +-----------------+------------+
   |string           |string      |
   +-----------------+------------+
   |array            |array       |
   +-----------------+------------+
   |associative array|struct      |
   +-----------------+------------+
   |object           |array       |
   +-----------------+------------+

.. code-block::
   :linenos:
   <?php

   /** 2 parameters worden in deze procedure doorgegeven
    *    - De eerste parameter is een string die automatisch zal worden omgezet in een XML-RPC string type
    *    - De tweede parameter is een associatieve array die zal worden omgezet in een XML-RPC struct
    */

   $p1 = 'parameter 1';
   $p2 = array('name' => 'Joe', 'age' => 30);

   $service->serviceProcedure($p1, $p2);

   ?>

.. _zend.xmlrpc.client.parameters.xmlrpc_value:

Zend_XmlRpc_Value objecten als parameters doorgeven
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Je kan één van de volgende *Zend_XmlRpc_Value* instanties aanmaken om het preciese XML-RPC type van je parameters
aan te geven. De hoofdredenen om expliciet het type van de doorgegeven parameters aan te duiden zijn de volgende:

   - Wanneer je er zeker van wil zijn dat het juiste parameter type aan de procedure wordt doorgegevn (b.v.: de
     procedure eist een integer en het is mogelijk dat de parameter via de $_GET array als een string krijgt)

   - Indien de procedure een base64 of datetime.iso8601 type vereist (die bestaan niet als PHP-eigen types)

   - Als auto-conversie zou kunnen falen (b.v.: je wil een lege XML-RPC struct als parameter doorgeven. Lege
     structs worden als lege arrays voorgesteld in PHP. Indien je een lege array als parameter doorgeeft zal die
     worden omgezet in een XML-RPC array vermits het geen associatieve array is)



Er zijn 2 manieren waarop je een *Zend_XmlRpc_Value* object kan maken: expliciet (de constructor van het object
aanroepen) of door de statische functie *Zend_XmlRpc_Value::getXmlRpcValue()* met de vereiste XML-RPC type
constante aan te roepen.

.. table:: Zend_XmlRpc_Value objecten die de XML-RPC types voorstelt

   +----------------+-------------------------------------------+--------------------------+
   |XML-RPC type    |Overeenkomstige Zend_XmlRpc_Value constante|Zend_XmlRpc_Value object  |
   +================+===========================================+==========================+
   |int             |Zend_XmlRpc_Value::XMLRPC_TYPE_INTEGER     |Zend_XmlRpc_Value_Integer |
   +----------------+-------------------------------------------+--------------------------+
   |double          |Zend_XmlRpc_Value::XMLRPC_TYPE_DOUBLE      |Zend_XmlRpc_Value_Double  |
   +----------------+-------------------------------------------+--------------------------+
   |boolean         |Zend_XmlRpc_Value::XMLRPC_TYPE_BOOLEAN     |Zend_XmlRpc_Value_Boolean |
   +----------------+-------------------------------------------+--------------------------+
   |string          |Zend_XmlRpc_Value::XMLRPC_TYPE_STRING      |Zend_XmlRpc_Value_String  |
   +----------------+-------------------------------------------+--------------------------+
   |base64          |Zend_XmlRpc_Value::XMLRPC_TYPE_BASE64      |Zend_XmlRpc_Value_Base64  |
   +----------------+-------------------------------------------+--------------------------+
   |dateTime.iso8601|Zend_XmlRpc_Value::XMLRPC_TYPE_DATETIME    |Zend_XmlRpc_Value_DateTime|
   +----------------+-------------------------------------------+--------------------------+
   |array           |Zend_XmlRpc_Value::XMLRPC_TYPE_ARRAY       |Zend_XmlRpc_Value_Array   |
   +----------------+-------------------------------------------+--------------------------+
   |struct          |Zend_XmlRpc_Value::XMLRPC_TYPE_STRUCT      |Zend_XmlRpc_Value_Struct  |
   +----------------+-------------------------------------------+--------------------------+

.. code-block::
   :linenos:
   <?php

   /** 2 parameters worden aan deze procedure doorgegeven
    *    - De eerste parameter is een XML-RPC base64 type dat werd gemaakt door de statische functie Zend_XmlRpc_Value::getXmlRpcValue() aan te roepen
    *    - De tweede parameter is een XML-RPC structuur die expliciet werd gemaakt
    */

   $p1 = Zend_XmlRpc_Value::getXmlRpcValue('encoded string', Zend_XmlRpc_Value::XMLRPC_TYPE_BASE64);
   $p2 = new Zend_XmlRpc_Value_Struct(array('name' => 'Joe', 'age' => 30));

   $service->serviceProcedure($p1, $p2);

   ?>

.. note::

   De waarde van de parameter word nog steeds als een PHP variabele gegeven maar zal worden omgezet naar het
   gespecifieerde type door de PHP conversietechnieken te gebruiken (b.v.: als een string als waarde aan het
   *Zend_XmlRpc_Value_Integer* object wordt gegeven zal het worden omgezet door *(int)$value*) toe te passen).

.. _zend.xmlrpc.client.parameters.as_xml:

Een XML string in een XML-RPC parameter "parsen"
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Deze methode van parameters doorgeven word intern in het *Zend_XmlRpc* pakket gebruikt en word niet aangeraden.

Indien je toch deze methode moet gebruiken zou je de statische functie *Zend_XmlRpc_Value::getXmlRpcValue()* moeten
gebruiken om een string in een *Zend_XmlRpc_Value* object te gieten die het overeenkomstige XML-RPC type voorstelt.
Je zou 2 parameters aan de *Zend_XmlRpc_Value::getXmlRpcValue()* functie moeten doorgeven: de XML string en de
*Zend_XmlRpc_Value::XML_STRING* constante.

.. _zend.xmlrpc.client.wsdl:

Hints geven voor parameter types
--------------------------------

Het voornaamste verschil tussen XML-RPC en SOAP web services is het WDSL bestand. Het SOAP protocol heeft meestal
een WDSL bestand dat de interface van de web service beschrijft. Aan de hand van deze interface weet de SOAP client
welke de benodigde parameter types zijn die naar de server moeten worden gestuurd en wat het type is van de
teruggegeven waarde. Zonder het WDSL bestand zou de gebruiker een probleem kunnen hebben de types te kennen.

De oplossing van het XML-RPC protocol is het gebruik van een speciale procedure van de service die
*system.methodSignature* word genoemd. Deze procedure krijgt een procedurenaam als parameter aangegeven en geeft
dan de handtekening van de gegeven procedure terug. De handtekening bevat het nodige type van de parameters en de
waarde die wordt teruggegeven door de procedure.

.. note::

   Niet alle XML-RPC server verstaan de speciale *system.methodSignature* procedure. Servers die dit niet verstaan
   bieden geen support voor het geven van hints voor types.

*Zend_XmlRpc_Client* implementeert een soort van 'WSDL' type bestand voor XML-RPC server die de
*system.methodSignature* procedure gebruiken. Indien gevraagd zal *Zend_XmlRpc_Client* een lijst van alle
procedures van een XML-RPC server aanvragen en alle handtekeningen van die procedures en zal die data opslaan in
een XML bestand (gelijk aan het SOAP WSDL bestand). Als je dan dezelfde XML-RPC server opnieuw gebruikt kan je het
XML bestand doorgeven en *Zend_XmlRpc_Client* zal hints geven voor het type van alle parameters voor de
aangevraagde procedure aan de hand van de handtekening ervan.

Het XML bestand met de procedurehandtekeningen wordt gemaakt door de *Zend_XmlRpc_Client::__getMethodsXml()*
functie aan te roepen. Die geeft een XML string terug die alle data van de handtekening bevat. Om een bestaand
handtekening XML bestand aan te duiden kan de gebruiker de XML data als parameter aan de contructor van
*Zend_XmlRpc_Client* doorgeven of de *Zend_XmlRpc_Client::__setMethodsXml()* functie aanroepen.

.. rubric:: Een XML-RPC service aanroepen met type hints

.. code-block::
   :linenos:
   <?php

   /**
    * Verbinden met een XML-RPC server, en zijn handtekening bestand opslaan (het equivalent
    * van een SOAP WSDL bestand)
    */
   require_once 'Zend/XmlRpc/Client.php';

   $service = new Zend_XmlRpc_Client('http://www.example.org/xmlrpc');

   file_put_contents('/tmp/xmlrpc-signatures/example.xml', $service->__getMethodsXml());

   /* Het $service object bevat alle handtekeningen van de XML-RPC server. Wanneer de serviceProcedure word opgeroepen zal zijn parameter ($param) naar het juiste type worden omgezet aan de hand van de handtekening van de procedure.
   */
   $service->serviceProcedure($param);

   ?>

.. code-block::
   :linenos:
   <?php

   /**
    * Verbinden met een XML-RPC server, gebruik makend van een bestaand handtekeningbestand. Zo verzekeren
    * we ons ervan dat de doorgegeven parameters van het juiste type zijn.
    */
   require_once 'Zend/XmlRpc/Client.php';

   $signature_file_xml = file_get_contents('/tmp/xmlrpc-signatures/example.xml');
   $service = new Zend_XmlRpc_Client('http://www.example.org/xmlrpc', 'namespace', $signature_file_xml);

   /* Het $service object bevat alle handtekeningen van de XML-RPC server. Wanneer de serviceProcedure word opgeroepen zal zijn parameter ($param) naar het juiste type worden omgezet aan de hand van de handtekening van de procedure.
   */
   $service->serviceProcedure($param);

   ?>

.. _zend.xmlrpc.client.response:

Het antwoord terugkrijgen
-------------------------

De XML-RPC procedure geeft een waarde terug met een XML-RPC type. De *Zend_XmlRpc_Client* methode die een XML-RPC
procedure aanroept geeft een waarde terug met een PHP-eigen type die werd verkregen vanaf het teruggegeven XML-RPC
type.

Je kan de *Zend_XmlRpc_Client::__getResponse()* functie gebruiken om de teruggegeven waarde te verkrijgen van de
aangevraagde procedure. De *__getResponse()* functie krijgt een parameter die het type van de teruggegeven waarde
aanduidt. De antwoordopties zijn:

   - *Zend_XmlRpc_Client::RESPONSE_PHP_NATIVE*- Geef de terugegeven waarde van de procedure als een PHP-eigen
     waarde terug (zet het XML-RPC type om naar een PHP type).

   - *Zend_XmlRpc_Client::RESPONSE_XML_STRING*- Geef de XML string voorstelling van het XML-RPC antwoord terug.

   - *Zend_XmlRpc_Client::RESPONSE_ZXMLRPC_OBJECT*- Geef een *Zend_XmlRpc_Value* object terug die het teruggegeven
     XML-RPC type voorstelt.



.. code-block::
   :linenos:
   <?php

   $service->serviceProcedure();

   $response = $service->__getResponse();
   // $response is de PHP variabele omgezet van het type van de teruggegeven XML-RPC waarde

   $response = $service->__getResponse(ZXmlRpcClient::RESPONSE_XML_STRING);
   // $response is een string die de XML bevat die de door de procedure teruggegeven waarde voorstelt

   $response = $service->__getResponse(ZXmlRpcClient::RESPONSE_ZXMLRPC_OBJECT);
   // $response is een Zend_XmlRpc_Value instantie die de door de procedure teruggegeven waarde voorstelt

   ?>



.. _`SOAP web service extensie`: http://www.php.net/soap
