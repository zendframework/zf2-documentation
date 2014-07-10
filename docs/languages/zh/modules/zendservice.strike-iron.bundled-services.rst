.. _zendservice.strikeiron.bundled-services:

ZendService\\StrikeIron: Bundled Services
=========================================

``ZendService\StrikeIron\StrikeIron`` comes with wrapper classes for three popular StrikeIron services.

.. _zendservice.strikeiron.bundled-services.zip-code-information:

ZIP Code Information
--------------------

``ZendService\StrikeIron\ZipCodeInfo`` provides a client for StrikeIron's Zip Code Information Service. For more
information on this service, visit these StrikeIron resources:



   - `Zip Code Information Service Page`_

   - `Zip Code Information Service WSDL`_

The service contains a ``getZipCode()`` method that will retrieve information about a United States ZIP code or
Canadian postal code:

.. code-block:: php
   :linenos:

   $strikeIron = new ZendService\StrikeIron\StrikeIron(array('username' => 'your-username',
                                                   'password' => 'your-password'));

   // Get a client for the Zip Code Information service
   $zipInfo = $strikeIron->getService(array('class' => 'ZipCodeInfo'));

   // Get the Zip information for 95014
   $response = $zipInfo->getZipCode(array('ZipCode' => 95014));
   $zips = $response->serviceResult;

   // Display the results
   if ($zips->count == 0) {
       echo 'No results found';
   } else {
       // a result with one single zip code is returned as an object,
       // not an array with one element as one might expect.
       if (! is_array($zips->zipCodes)) {
           $zips->zipCodes = array($zips->zipCodes);
       }

       // print all of the possible results
       foreach ($zips->zipCodes as $z) {
           $info = $z->zipCodeInfo;

           // show all properties
           print_r($info);

           // or just the city name
           echo $info->preferredCityName;
       }
   }

   // Detailed status information
   // http://www.strikeiron.com/exampledata/StrikeIronZipCodeInformation_v3.pdf
   $status = $response->serviceStatus;

.. _zendservice.strikeiron.bundled-services.us-address-verification:

U.S. Address Verification
-------------------------

``ZendService\StrikeIron\USAddressVerification`` provides a client for StrikeIron's U.S. Address Verification
Service. For more information on this service, visit these StrikeIron resources:



   - `U.S. Address Verification Service Page`_

   - `U.S. Address Verification Service WSDL`_



The service contains a ``verifyAddressUSA()`` method that will verify an address in the United States:

.. code-block:: php
   :linenos:

   $strikeIron = new ZendService\StrikeIron\StrikeIron(array('username' => 'your-username',
                                                   'password' => 'your-password'));

   // Get a client for the Zip Code Information service
   $verifier = $strikeIron->getService(array('class' => 'USAddressVerification'));

   // Address to verify. Not all fields are required but
   // supply as many as possible for the best results.
   $address = array('firm'           => 'Zend Technologies',
                    'addressLine1'   => '19200 Stevens Creek Blvd',
                    'addressLine2'   => '',
                    'city_state_zip' => 'Cupertino CA 95014');

   // Verify the address
   $result = $verifier->verifyAddressUSA($address);

   // Display the results
   if ($result->addressErrorNumber != 0) {
       echo $result->addressErrorNumber;
       echo $result->addressErrorMessage;
   } else {
       // show all properties
       print_r($result);

       // or just the firm name
       echo $result->firm;

       // valid address?
       $valid = ($result->valid == 'VALID');
   }

.. _zendservice.strikeiron.bundled-services.sales-use-tax-basic:

Sales & Use Tax Basic
---------------------

``ZendService\StrikeIron\SalesUseTaxBasic`` provides a client for StrikeIron's Sales & Use Tax Basic service. For
more information on this service, visit these StrikeIron resources:



   - `Sales & Use Tax Basic Service Page`_

   - `Sales & Use Tax Basic Service WSDL`_



The service contains two methods, ``getTaxRateUSA()`` and ``getTaxRateCanada()``, that will retrieve sales and use
tax data for the United States and Canada, respectively.

.. code-block:: php
   :linenos:

   $strikeIron = new ZendService\StrikeIron\StrikeIron(array('username' => 'your-username',
                                                   'password' => 'your-password'));

   // Get a client for the Sales & Use Tax Basic service
   $taxBasic = $strikeIron->getService(array('class' => 'SalesUseTaxBasic'));

   // Query tax rate for Ontario, Canada
   $rateInfo = $taxBasic->getTaxRateCanada(array('province' => 'foo'));
   print_r($rateInfo);               // show all properties
   echo $rateInfo->GST;              // or just the GST (Goods & Services Tax)

   // Query tax rate for Cupertino, CA USA
   $rateInfo = $taxBasic->getTaxRateUS(array('zip_code' => 95014));
   print_r($rateInfo);               // show all properties
   echo $rateInfo->state_sales_tax;  // or just the state sales tax



.. _`Zip Code Information Service Page`: http://www.strikeiron.com/ProductDetail.aspx?p=267
.. _`Zip Code Information Service WSDL`: http://sdpws.strikeiron.com/zf1.StrikeIron/sdpZIPCodeInfo?WSDL
.. _`U.S. Address Verification Service Page`: http://www.strikeiron.com/ProductDetail.aspx?p=198
.. _`U.S. Address Verification Service WSDL`: http://ws.strikeiron.com/zf1.StrikeIron/USAddressVerification4_0?WSDL
.. _`Sales & Use Tax Basic Service Page`: http://www.strikeiron.com/ProductDetail.aspx?p=351
.. _`Sales & Use Tax Basic Service WSDL`: http://ws.strikeiron.com/zf1.StrikeIron/taxdatabasic4?WSDL
