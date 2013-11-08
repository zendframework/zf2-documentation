.. _zendservice.developergarden:

ZendService\\DeveloperGarden
============================

.. _zendservice.developergarden.introduction:

Introduction to DeveloperGarden
-------------------------------

Developer Garden is the name of Deutsche Telekom’s developer community. Developer Garden offers you access to
core services of Deutsche Telekom, such as voice connections (Voice Call) or sending text messages (Send SMS) via
open interfaces (Open *API*\ s). You can access the Developer Garden services directly via *SOAP* or *REST*.

The family of ``ZendService\DeveloperGarden`` components provides a clean and simple interface to the `Developer
Garden APIs`_ and additionally offers functionality to improve handling and performance.

- :ref:`BaseUserService <zendservice.developergarden.baseuserservice>`: Class to manage *API* quota and user
  accounting details.

- :ref:`IPLocation <zendservice.developergarden.iplocation>`: Locale the given IP and returns geo coordinates.
  Works only with IPs allocated in the network of the Deutsche Telekom.

- :ref:`LocalSearch <zendservice.developergarden.localsearch>`: Allows you to search with options nearby or around
  a given geo coordinate or city.

- :ref:`SendSMS <zendservice.developergarden.sendsms>`: Send a SMS or Flash SMS to a given number.

- :ref:`SMSValidation <zendservice.developergarden.smsvalidation>`: You can validate a number to use it with
  SendSMS for also supply a back channel.

- :ref:`VoiceCall <zendservice.developergarden.voicecall>`: Initiates a call between two participants.

- :ref:`ConferenceCall <zendservice.developergarden.conferencecall>`: You can configure a whole conference room
  with participants for an adhoc conference or you can also schedule your conference.

The backend *SOAP* *API* is documented `here`_.

.. _zendservice.developergarden.account:

Sign Up for an Account
^^^^^^^^^^^^^^^^^^^^^^

Before you can start using the DeveloperGarden *API*, you first have to `sign up`_ for an account.

.. _zendservice.developergarden.environment:

The Environment
^^^^^^^^^^^^^^^

With the DeveloperGarden *API* you have the possibility to choose between 3 different development environments.

- **production**: In Production environment there are no usage limitations. You have to pay for calls, sms and
  other services with costs.

- **sandbox**: In the Sandbox mode you can use the same features (with limitations) as in the production without to
  paying for them. This environment is suitable for testing your prototype.

- **mock**: The Mock environment allows you to build your application and have results but you do not initiate any
  action on the *API* side. This environment is intended for testing during development.

For every environment and service, there are some special features (options) available for testing. Please look
`here`_ for details.

.. _zendservice.developergarden.config:

Your configuration
^^^^^^^^^^^^^^^^^^

You can pass to all classes an array of configuration values. Possible values are:

- **username**: Your DeveloperGarden *API* username.

- **password**: Your DeveloperGarden *API* password.

- **environment**: The environment that you selected.

.. _zendservice.developergarden.config.example:

.. rubric:: Configuration Example

.. code-block:: php
   :linenos:

   require_once 'ZendService/DeveloperGarden/SendSms.php';
   $config = array(
       'username'    => 'yourUsername',
       'password'    => 'yourPassword',
       'environment' => ZendService\DeveloperGarden\SendSms::ENV_PRODUCTION,
   );
   $service = new ZendService\DeveloperGarden\SendSms($config);

.. _zendservice.developergarden.baseuserservice:

BaseUserService
---------------

The class can be used to set and get quota values for the services and to fetch account details.

The ``getAccountBalance()`` method fetches an array of account id's with the current balance status (credits).

.. _zendservice.developergarden.baseuserservice.getaccountbalance.example:

.. rubric:: Get account balance example

.. code-block:: php
   :linenos:

   $service = new ZendService\DeveloperGarden\BaseUserService($config);
   print_r($service->getAccountBalance());

.. _zendservice.developergarden.baseuserservice.getquotainformation:

Get quota information
^^^^^^^^^^^^^^^^^^^^^

You can fetch quota informations for a specific service module with the provided methods.

.. _zendservice.developergarden.baseuserservice.getquotainformation.example:

.. rubric:: Get quota information example

.. code-block:: php
   :linenos:

   $service = new ZendService\DeveloperGarden\BaseUserService($config);
   $result = $service->getSmsQuotaInformation(
       ZendService\DeveloperGarden\BaseUserService::ENV_PRODUCTION
   );
   echo 'Sms Quota:<br />';
   echo 'Max Quota: ', $result->getMaxQuota(), '<br />';
   echo 'Max User Quota: ', $result->getMaxUserQuota(), '<br />';
   echo 'Quota Level: ', $result->getQuotaLevel(), '<br />';

You get a ``result`` object that contains all the information you need, optional you can pass to the
``QuotaInformation`` method the environment constant to fetch the quota for the specific environment.

Here a list of all ``getQuotaInformation`` methods:

- ``getConferenceCallQuotaInformation()``

- ``getIPLocationQuotaInformation()``

- ``getLocalSearchQuotaInformation()``

- ``getSmsQuotaInformation()``

- ``getVoiceCallQuotaInformation()``

.. _zendservice.developergarden.baseuserservice.changequotainformation:

Change quota information
^^^^^^^^^^^^^^^^^^^^^^^^

To change the current quota use one of the ``changeQuotaPool`` methods. First parameter is the new pool value and
the second one is the environment.

.. _zendservice.developergarden.baseuserservice.changequotainformation.example:

.. rubric:: Change quota information example

.. code-block:: php
   :linenos:

   $service = new ZendService\DeveloperGarden\BaseUserService($config);
   $result = $service->changeSmsQuotaPool(
       1000,
       ZendService\DeveloperGarden\BaseUserService::ENV_PRODUCTION
   );
   if (!$result->hasError()) {
       echo 'updated Quota Pool';
   }

Here a list of all ``changeQuotaPool`` methods:

- ``changeConferenceCallQuotaPool()``

- ``changeIPLocationQuotaPool()``

- ``changeLocalSearchQuotaPool()``

- ``changeSmsQuotaPool()``

- ``changeVoiceCallQuotaPool()``

.. _zendservice.developergarden.iplocation:

IP Location
-----------

This service allows you to retrieve location information for a given IP address.

There are some limitations:

- The IP address must be in the T-Home network

- Just the next big city will be resolved

- IPv6 is not supported yet

.. _zendservice.developergarden.iplocation.locateip.example:

.. rubric:: Locate a given IP

.. code-block:: php
   :linenos:

   $service = new ZendService\DeveloperGarden\IpLocation($config);
   $service->setEnvironment(
       ZendService\DeveloperGarden\IpLocation::ENV_MOCK
   );
   $ip = new ZendService\DeveloperGarden\IpLocation\IpAddress('127.0.0.1');
   print_r($service->locateIp($ip));

.. _zendservice.developergarden.localsearch:

Local Search
------------

The Local Search service provides the location based search machine `suchen.de`_ via web service interface. For
more details, refer to `the documentation`_.

.. _zendservice.developergarden.localsearch.example:

.. rubric:: Locate a Restaurant

.. code-block:: php
   :linenos:

   $service = new ZendService\DeveloperGarden\LocalSearch($config);
   $search  = new ZendService\DeveloperGarden\LocalSearch\SearchParameters();
   /**
    * @see http://www.developergarden.com/static/docu/en/ch04s02s06s04.html
    */
   $search->setWhat('pizza')
          ->setWhere('jena');
   print_r($service->localSearch($search));

.. _zendservice.developergarden.sendsms:

Send SMS
--------

The Send SMS service is used to send normal and Flash SMS to any number.

The following restrictions apply to the use of the SMS service:

- An SMS or Flash SMS in the production environment must not be longer than 765 characters and must not be sent to
  more than 10 recipients.

- An SMS or Flash SMS in the sandbox environment is shortened and enhanced by a note from the DeveloperGarden. The
  maximum length of the message is 160 characters.

- In the sandbox environment, a maximum of 10 SMS can be sent per day.

- The following characters are counted twice: ``| ^ € { } [ ] ~ \ LF`` (line break)

- If a SMS or Flash SMS is longer than 160 characters, one message is charged for each 153 characters (quota and
  credit).

- Delivery cannot be guaranteed for SMS or Flash SMS to landline numbers.

- The sender can be a maximum of 11 characters. Permitted characters are letters and numbers.

- The specification of a phone number as the sender is only permitted if the phone number has been validated. (See:
  :ref:`SMS Validation <zendservice.developergarden.smsvalidation>`)

.. _zendservice.developergarden.sendsms.example:

.. rubric:: Sending an SMS

.. code-block:: php
   :linenos:

   $service = new ZendService\DeveloperGarden\SendSms($config);
   $sms = $service->createSms(
       '+49-172-123456; +49-177-789012',
       'your test message',
       'yourname'
   );
   print_r($service->send($sms));
.. _zendservice.developergarden.smsvalidation:

SMS Validation
--------------

The SMS Validation service allows the validation of physical phone number to be used as the sender of an SMS.

First, call ``setValidationKeyword()`` to receive an SMS with a keyword.

After you get your keyword, you have to use the ``validate()`` to validate your number with the keyword against the
service.

With the method ``getValidatedNumbers()``, you will get a list of all already validated numbers and the status of
each.

.. _zendservice.developergarden.smsvalidation.request.example:

.. rubric:: Request validation keyword

.. code-block:: php
   :linenos:

   $service = new ZendService\DeveloperGarden\SmsValidation($config);
   print_r($service->sendValidationKeyword('+49-172-123456'));

.. _zendservice.developergarden.smsvalidation.validate.example:

.. rubric:: Validate a number with a keyword

.. code-block:: php
   :linenos:

   $service = new ZendService\DeveloperGarden\SmsValidation($config);
   print_r($service->validate('TheKeyWord', '+49-172-123456'));

To invalidate a validated number, call the method ``inValidate()``.

.. _zendservice.developergarden.voicecall:

Voice Call
----------

The Voice Call service can be used to set up a voice connection between two telephone connections. For specific
details please read the `API Documentation`_.

Normally the Service works as followed:

- Call the first participant.

- If the connection is successful, call the second participant.

- If second participant connects successfully, both participants are connected.

- The call is open until one of the participants hangs up or the expire mechanism intercepts.

.. _zendservice.developergarden.voicecall.call.example:

.. rubric:: Call two numbers

.. code-block:: php
   :linenos:

   $service = new ZendService\DeveloperGarden\VoiceCall($config);
   $aNumber = '+49-30-000001';
   $bNumber = '+49-30-000002';
   $expiration  = 30;  // seconds
   $maxDuration = 300; // 5 mins
   $newCall = $service->newCall($aNumber, $bNumber, $expiration, $maxDuration);
   echo $newCall->getSessionId();

If the call is initiated, you can ask the result object for the session ID and use this session ID for an
additional call to the ``callStatus`` or ``tearDownCall()`` methods. The second parameter on the ``callStatus()``
method call extends the expiration for this call.

.. _zendservice.developergarden.voicecall.teardown.example:

.. rubric:: Call two numbers, ask for status, and cancel

.. code-block:: php
   :linenos:

   $service = new ZendService\DeveloperGarden\VoiceCall($config);
   $aNumber = '+49-30-000001';
   $bNumber = '+49-30-000002';
   $expiration  = 30; // seconds
   $maxDuration = 300; // 5 mins

   $newCall = $service->newCall($aNumber, $bNumber, $expiration, $maxDuration);

   $sessionId = $newCall->getSessionId();

   $service->callStatus($sessionId, true); // extend the call

   sleep(10); // sleep 10s and then tearDown

   $service->tearDownCall($sessionId);

.. _zendservice.developergarden.conferencecall:

ConferenceCall
--------------

Conference Call allows you to setup and start a phone conference.

The following features are available:

- Conferences with an immediate start

- Conferences with a defined start date

- Recurring conference series

- Adding, removing, and muting of participants from a conference

- Templates for conferences

Here is a list of currently implemented *API* methods:

- ``createConference()`` creates a new conference

- ``updateConference()`` updates an existing conference

- ``commitConference()`` saves the conference, and, if no date is configured, immediately starts the conference

- ``removeConference()`` removes a conference

- ``getConferenceList()`` returns a list of all configured conferences

- ``getConferenceStatus()`` displays information for an existing conference

- ``getParticipantStatus()`` displays status information about a conference participant

- ``newParticipant()`` creates a new participant

- ``addParticipant()`` adds a participant to a conference

- ``updateParticipant()`` updates a participant, usually to mute or redial the participant

- ``removeParticipant()`` removes a participant from a conference

- ``getRunningConference()`` requests the running instance of a planned conference

- ``createConferenceTemplate()`` creates a new conference template

- ``getConferenceTemplate()`` requests an existing conference template

- ``updateConferenceTemplate()`` updates existing conference template details

- ``removeConferenceTemplate()`` removes a conference template

- ``getConferenceTemplateList()`` requests all conference templates of an owner

- ``addConferenceTemplateParticipant()`` adds a conference participant to conference template

- ``getConferenceTemplateParticipant()`` displays details of a participant of a conference template

- ``updateConferenceTemplateParticipant()`` updates participant details within a conference template

- ``removeConferenceTemplateParticipant()`` removes a participant from a conference template

.. _zendservice.developergarden.conferencecall.example:

.. rubric:: Ad-Hoc conference

.. code-block:: php
   :linenos:

   $client = new ZendService\DeveloperGarden\ConferenceCall($config);

   $conferenceDetails =
       new ZendService\DeveloperGarden\ConferenceCall\ConferenceDetail(
           'Zend-Conference',                    // name for the conference
           'this is my private zend conference', // description
           60                                    // duration in seconds
       );

   $conference = $client->createConference('MyName', $conferenceDetails);

   $part1 = new ZendService\DeveloperGarden\ConferenceCall\ParticipantDetail(
       'Jon',
       'Doe',
       '+49-123-4321',
       'your.name@example.com',
       true
   );

   $client->newParticipant($conference->getConferenceId(), $part1);
   // add a second, third ... participant

   $client->commitConference($conference->getConferenceId());

.. _zendservice.developergarden.performance:

Performance and Caching
-----------------------

You can setup various caching options to improve the performance for resolving WSDL and authentication tokens.

First of all, you can setup the internal SoapClient (PHP) caching values.

.. _zendservice.developergarden.performance.wsdlcache.example:

.. rubric:: WSDL cache options

.. code-block:: php
   :linenos:

   ZendService\DeveloperGarden\SecurityTokenServer\Cache::setWsdlCache(
       [PHP CONSTANT]
   );

The ``[PHP CONSTANT]`` can be one of the following values:

- ``WSDL_CACHE_DISC``: enabled disc caching

- ``WSDL_CACHE_MEMORY``: enabled memory caching

- ``WSDL_CACHE_BOTH``: enabled disc and memory caching

- ``WSDL_CACHE_NONE``: disabled both caching

If you also want to cache the result for calls to the SecurityTokenServer you can setup a ``Zend_Cache`` instance
and pass it to the ``setCache()``.

.. _zendservice.developergarden.performance.cache.example:

.. rubric:: SecurityTokenServer cache option

.. code-block:: php
   :linenos:

   $cache = Zend_Cache::factory('Core', ...);
   ZendService\DeveloperGarden\SecurityTokenServer\Cache::setCache($cache);



.. _`Developer Garden APIs`: http://www.developergarden.com
.. _`here`: http://www.developergarden.com/openapi/dokumentation/
.. _`sign up`: http://www.developergarden.com/register
.. _`suchen.de`: http://www.suchen.de
.. _`the documentation`: http://www.developergarden.com/static/docu/en/ch04s02s06.html
.. _`API Documentation`: http://www.developergarden.com/static/docu/en/ch04s02.html
