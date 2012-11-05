.. EN-Revision: none
.. _zend.service.strikeiron.bundled-services:

Zend\Service\StrikeIron: Mitgelieferte Services
===============================================

``Zend\Service\StrikeIron`` kommt mit Wrapper Klassen für drei populäre StrikeIron Services.

.. _zend.service.strikeiron.bundled-services.zip-code-information:

ZIP Code Informationen
----------------------

``Zend\Service_StrikeIron\ZipCodeInfo`` bietet einen Client für StrikeIron's Zip Code Informations Service. Für
mehr Informationen über dieses Service kann bei diesen StrikeIron Ressourcen nachgesehen werden:



   - `Zip Code Informations Service Seite`_

   - `Zip Code Informations Service WSDL`_

Das Service enthält eine ``getZipCode()`` Methode die Informationen über die Amerikanischen ZIP Codes oder
Kanadischen Post Codes enthält:

.. code-block:: php
   :linenos:

   $strikeIron = new Zend\Service\StrikeIron(array('username' => 'your-username',
                                                   'password' => 'your-password'));

   // Einen Client für das ZIP Code Informations Service erstellen
   $zipInfo = $strikeIron->getService(array('class' => 'ZipCodeInfo'));

   // Eine Zip Information für 95014 erhalten
   $response = $zipInfo->getZipCode(array('ZipCode' => 95014));
   $zips = $response->serviceResult;

   // Die Ergebnisse anzeigen
   if ($zips->count == 0) {
       echo 'Keine Ergebnisse gefunden';
   } else {
       // Ein Ergebnis mit einem einzelnen ZIP Code wurde als Objekt zurückgegeben
       // und nicht ein Array mit einem Element wie einige erwarten würden
       if (! is_array($zips->zipCodes)) {
           $zips->zipCodes = array($zips->zipCodes);
       }

       // Alle möglichen Ergebnisse ausgeben
       foreach ($zips->zipCodes as $z) {
           $info = $z->zipCodeInfo;

           // Alle Eigenschaften zeigen
           print_r($info);

           // oder nur den Städtenamen
           echo $info->preferredCityName;
       }
   }

   // Detailierte Statusinformationen
   // http://www.strikeiron.com/exampledata/StrikeIronZipCodeInformation_v3.pdf
   $status = $response->serviceStatus;

.. _zend.service.strikeiron.bundled-services.us-address-verification:

U.S. Address-Prüfung
--------------------

``Zend\Service_StrikeIron\USAddressVerification`` bietet einen Client für StrikeIron's U.S. Address-Prüfungs
Service. Für mehr Informationen über dieses Service kann bei diesen StrikeIron Ressourcen nachgesehen werden:



   - `U.S. Address-Prüfungs Service Seite`_

   - `U.S. Address-Prüfungs Service WSDL`_



Das Service enthält eine ``verifyAddressUSA()`` Methode die eine Adresse in den Vereinigten Staaten prüft:

.. code-block:: php
   :linenos:

   $strikeIron = new Zend\Service\StrikeIron(array('username' => 'your-username',
                                                   'password' => 'your-password'));

   // Einen Client für das ZIP Code Informations Service erstellen
   $verifier = $strikeIron->getService(array('class' => 'USAddressVerification'));

   // Adresse die geprüft werden soll. Nicht alle Felder werden benötigt aber es
   // sollten soviele wie möglich für das beste Ergebnis angegeben werden
   $address = array('firm'           => 'Zend Technologies',
                    'addressLine1'   => '19200 Stevens Creek Blvd',
                    'addressLine2'   => '',
                    'city_state_zip' => 'Cupertino CA 95014');

   // Adresse prüfen
   $result = $verifier->verifyAddressUSA($address);

   // Ergebnisse anzeigen
   if ($result->addressErrorNumber != 0) {
       echo $result->addressErrorNumber;
       echo $result->addressErrorMessage;
   } else {
       // Alle Eigenschaften zeigen
       print_r($result);

       // oder nur den Firmennamen
       echo $result->firm;

       // Gültige Adresse?
       $valid = ($result->valid == 'VALID');
   }

.. _zend.service.strikeiron.bundled-services.sales-use-tax-basic:

Verkaufs & Steuer Grundlagen
----------------------------

``Zend\Service_StrikeIron\SalesUseTaxBasic`` bietet einen Client für StrikeIron's Verkaufs & Steuer Grundlagen
Service. Für mehr Informationen über dieses Service kann bei diesen StrikeIron Ressourcen nachgesehen werden:



   - `Verkaufs & Steuer Grundlagen Service Seite`_

   - `Verkaufs & Steuer Grundlagen Service WSDL`_



Das Service enthält zwei Methoden, ``getTaxRateUSA()`` und ``getTaxRateCanada()``, die Verkaufs und Steuer Daten
für die Vereinigten Staaten und Kanada enthalten.

.. code-block:: php
   :linenos:

   $strikeIron = new Zend\Service\StrikeIron(array('username' => 'your-username',
                                                   'password' => 'your-password'));

   // Einen Client für das Verkaufs & Steuer Grundlagen Service erstellen
   $taxBasic = $strikeIron->getService(array('class' => 'SalesUseTaxBasic'));

   // Die Steuerrate für Ontario, Kanada abfragen
   $rateInfo = $taxBasic->getTaxRateCanada(array('province' => 'foo'));
   print_r($rateInfo);               // alle Eigenschaften zeigen
   echo $rateInfo->GST;              // oder nur die GST (Teile & Services Steuer)

   // Die Steuerrate für Cupertino, CA USA abfragen
   $rateInfo = $taxBasic->getTaxRateUS(array('zip_code' => 95014));
   print_r($rateInfo);               // alle Eigenschaften zeigen
   echo $rateInfo->state_sales_tax;  // oder nur die Staatenweise Verkaufssteuer



.. _`Zip Code Informations Service Seite`: http://www.strikeiron.com/ProductDetail.aspx?p=267
.. _`Zip Code Informations Service WSDL`: http://sdpws.strikeiron.com/zf1.StrikeIron/sdpZIPCodeInfo?WSDL
.. _`U.S. Address-Prüfungs Service Seite`: http://www.strikeiron.com/ProductDetail.aspx?p=198
.. _`U.S. Address-Prüfungs Service WSDL`: http://ws.strikeiron.com/zf1.StrikeIron/USAddressVerification4_0?WSDL
.. _`Verkaufs & Steuer Grundlagen Service Seite`: http://www.strikeiron.com/ProductDetail.aspx?p=351
.. _`Verkaufs & Steuer Grundlagen Service WSDL`: http://ws.strikeiron.com/zf1.StrikeIron/taxdatabasic4?WSDL
