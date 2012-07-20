.. _zend.service.strikeiron.advanced-uses:

Zend_Service_StrikeIron: Erweiterte Verwendung
==============================================

Diese Sektion beschreibt die erweiterte Verwendung von ``Zend_Service_StrikeIron``.

.. _zend.service.strikeiron.advanced-uses.services-by-wsdl:

Die Services durch WSDL verwenden
---------------------------------

Für einige StrikeIron Services können *PHP* Wrapper Klassen vorhanden sein, so wie jene die in :ref:`Bundled
Services <zend.service.strikeiron.bundled-services>` beschrieben werden. Trotzdem bietet StrikeIron hunderte von
Services und viele von diesen können nicht verwendbar sein wenn keine spezielle Wrapper Klasse erstellt wird.

Um ein StrikeIron Service zu probieren für das keine Wrapper Klasse vorhanden ist, muß die ``wsdl`` Option statt
der ``class`` Option an ``getService()`` übergeben werden:

.. code-block:: php
   :linenos:

   $strikeIron = new Zend_Service_StrikeIron(
       array('username' => 'your-username', 'password' => 'your-password')
   );

   // Erhalte einen generellen Client zum Reverse Phone Lookup Service
   $phone = $strikeIron->getService(
       array('wsdl' => 'http://ws.strikeiron.com/ReversePhoneLookup?WSDL')
   );

   $result = $phone->lookup(array('Number' => '(408) 253-8800'));
   echo $result->listingName;

   // Zend Technologies USA Inc

Um StrikeIron Services durch WSDL zu verwenden wird zumindest ein Verständnis für WSDL Dateien benötigt.
StrikeIron hat viele Ressourcen auf Ihren Seiten die hierbei helfen. Auch `Jan Schneider`_ vom `Horde Projekt`_ hat
eine `kleine PHP Routine`_ geschrieben die eine WSDL Datei in lesbares *HTML* konvertiert.

Es ist zu beachten das nur die Services die in der :ref:`Mitgelieferten Services
<zend.service.strikeiron.bundled-services>` Sektion beschrieben werden auch offiziell unterstützt werden.

.. _zend.service.strikeiron.viewing-soap-transactions:

SOAP Transaktionen betrachten
-----------------------------

Die gesamte Kommunikation mit StrikeIron wird durch Verwenden der *SOAP* Erweiterung durchgeführt. Es kann
zeitweise nützlich sein das mit StrikeIron getauschte *XML* für Debugging Zwecke zu betrachten.

Jeder StrikeIron Client (Subklasse von ``Zend_Service_StrikeIron_Base``) enthält eine ``getSoapClient()`` Methode
um die darunterliegende Instanz von ``SOAPClient`` zu retournieren, die für die Kommunikation mit StrikeIron
verwendet wird.

*PHP*'s `SOAPClient`_ hat eine ``trace`` Option die dazu führt dass das *XML*, das wärend der letzten Transaktion
getauscht wurde, gemerkt wird. ``Zend_Service_StrikeIron`` aktiviert die ``trace`` Option nicht standardmäßig
aber das kann einfach getan werden durch Spezifizierung der Option die dazu verwendet wird den ``SOAPClient``
Konstruktor zu übergeben.

Um die SOAP Transaktion zu betrachten muß die ``getSoapClient()`` Methode aufgerufen werden um die ``SOAPClient``
Instanz zu erhalten und anschließend die entsprechenden Methoden wie `\__getLastRequest()`_ und
`\__getLastRequest()`_: aufzurufen:

.. code-block:: php
   :linenos:

   $strikeIron =
       new Zend_Service_StrikeIron(array('username' => 'your-username',
                                         'password' => 'your-password',
                                         'options'  => array('trace' => true)));

   // Erstelle einen Client für das Verkaufs & Verwende Steuer BasisService
   $taxBasic = $strikeIron->getService(array('class' => 'SalesUseTaxBasic'));

   // Einen Methodenaufruf durchführen
   $taxBasic->getTaxRateCanada(array('province' => 'ontario'));

   // Die SOAPClient Instanz holen und das XML ansehen
   $soapClient = $taxBasic->getSoapClient();
   echo $soapClient->__getLastRequest();
   echo $soapClient->__getLastResponse();



.. _`Jan Schneider`: http://janschneider.de
.. _`Horde Projekt`: http://horde.org
.. _`kleine PHP Routine`: http://janschneider.de/news/25/268
.. _`SOAPClient`: http://www.php.net/manual/de/function.soap-soapclient-construct.php
.. _`\__getLastRequest()`: http://www.php.net/manual/de/function.soap-soapclient-getlastresponse.php
