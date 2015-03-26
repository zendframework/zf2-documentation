.. _zendservice.strikeiron.advanced-uses:

ZendService\\StrikeIron: Advanced Uses
======================================

This section describes the more advanced uses of ``ZendService\StrikeIron\StrikeIron``.

.. _zendservice.strikeiron.advanced-uses.services-by-wsdl:

Using Services by WSDL
----------------------

Some StrikeIron services may have a *PHP* wrapper class available, such as those described in :ref:`Bundled
Services <zendservice.strikeiron.bundled-services>`. However, StrikeIron offers hundreds of services and many of
these may be usable even without creating a special wrapper class.

To try a StrikeIron service that does not have a wrapper class available, give the ``wsdl`` option to
``getService()`` instead of the ``class`` option:

.. code-block:: php
   :linenos:

   $strikeIron = new ZendService\StrikeIron\StrikeIron(array('username' => 'your-username',
                                                   'password' => 'your-password'));

   // Get a generic client to the Reverse Phone Lookup service
   $phone = $strikeIron->getService(
       array('wsdl' => 'http://ws.strikeiron.com/ReversePhoneLookup?WSDL')
   );

   $result = $phone->lookup(array('Number' => '(408) 253-8800'));
   echo $result->listingName;

   // Zend Technologies USA Inc

Using StrikeIron services from the WSDL will require at least some understanding of the WSDL files. StrikeIron has
many resources on its site to help with this. Also, `Jan Schneider`_ from the `Horde project`_ has written a `small
PHP routine`_ that will format a WSDL file into more readable *HTML*.

Please note that only the services described in the :ref:`Bundled Services
<zendservice.strikeiron.bundled-services>` section are officially supported.

.. _zendservice.strikeiron.viewing-soap-transactions:

Viewing SOAP Transactions
-------------------------

All communication with StrikeIron is done using the *SOAP* extension. It is sometimes useful to view the *XML*
exchanged with StrikeIron for debug purposes.

Every StrikeIron client (subclass of ``ZendService\StrikeIron\Base``) contains a ``getSoapClient()`` method to
return the underlying instance of ``SOAPClient`` used to communicate with StrikeIron.

*PHP*'`SOAPClient`_ has a ``trace`` option that causes it to remember the *XML* exchanged during the last
transaction. ``ZendService\StrikeIron\StrikeIron`` does not enable the ``trace`` option by default but this can easily by
changed by specifying the options that will be passed to the ``SOAPClient`` constructor.

To view a SOAP transaction, call the ``getSoapClient()`` method to get the ``SOAPClient`` instance and then call
the appropriate methods like `\__getLastRequest()`_ and `\__getLastRequest()`_:

.. code-block:: php
   :linenos:

   $strikeIron =
       new ZendService\StrikeIron\StrikeIron(array('username' => 'your-username',
                                         'password' => 'your-password',
                                         'options'  => array('trace' => true)));

   // Get a client for the Sales & Use Tax Basic service
   $taxBasic = $strikeIron->getService(array('class' => 'SalesUseTaxBasic'));

   // Perform a method call
   $taxBasic->getTaxRateCanada(array('province' => 'ontario'));

   // Get SOAPClient instance and view XML
   $soapClient = $taxBasic->getSoapClient();
   echo $soapClient->__getLastRequest();
   echo $soapClient->__getLastResponse();



.. _`Jan Schneider`: http://janschneider.de
.. _`Horde project`: http://horde.org
.. _`small PHP routine`: http://janschneider.de/news/25/268
.. _`SOAPClient`: http://www.php.net/manual/en/function.soap-soapclient-construct.php
.. _`\__getLastRequest()`: http://www.php.net/manual/en/function.soap-soapclient-getlastresponse.php
