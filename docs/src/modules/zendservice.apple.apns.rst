.. _zendservice.apple.apns:

ZendService\\Apple\\Apns
========================

.. _zendservice.apple.apns.introduction:

Introduction
------------

``ZendService\Apple\Apns`` provides a client for the Apple Push Notification Service.
``ZendService\Apple\Apns\Client`` allows you to send data from servers to your iOS Applications.

In order to leverage APNS you **must** follow the 
`Provisioning and deployments steps outlined by Apple <http://developer.apple.com/library/mac/#documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/ProvisioningDevelopment/ProvisioningDevelopment.html>`_.

The service is composed of 3 distinct parts:

* The Clients:

  * Feedback: ``ZendService\Apple\Apns\Client\Feedback``
  * Message: ``ZendService\Apple\Apns\Client\Message``

* The Message: ``ZendService\Apple\Apns\Message\Alert``
* The Responses:

  * Feedback: ``ZendService\Apple\Apns\Response\Feedback``
  * Message: ``ZendService\Apple\Apns\Response\Message``

The Clients is the broker that sends the message to the APNS server and returns the response.  The Message
is where you define all of the message specific data that you would like to send for the alert.  The Response
is the feedback given back from the APNS server.

.. _zendservice.apple.apns.quickstart:

Quick Start
------------

In order to send messages; you must have completed the provisioning and deployment steps mentioned above.  Once
you have your certificates in place you will be able to prepare to send messages to your iOS application.  Here
we will setup the client and prepare to send out messages.

.. code-block:: php
   :linenos:   

   use ZendService\Apple\Apns\Client\Message as Client;
   use ZendService\Apple\Apns\Message;
   use ZendService\Apple\Apns\Message\Alert;
   use ZendService\Apple\Apns\Response\Message as Response;
   use ZendService\Apple\Apns\Exception\RuntimeException;

   $client = new Client();
   $client->open(Client::SANDBOX_URI, '/path/to/push-certificate.pem', 'optionalPassPhrase');


So now that we have the client setup and available, it is time to define out the message that we intend to
send to our iOS tokens that have registered for push notifications on our server.  Note that many of
the methods specified are not required but are here to give an inclusive look into the message.

.. code-block:: php
   :linenos:

   $message = new Message();
   $message->setId('my_unique_id');
   $message->setToken('DEVICE_TOKEN');
   $message->setBadge(5);
   $message->setSound('bingbong.aiff');

   // simple alert:
   $message->setAlert('Bob wants to play poker');
   // complex alert:
   $alert = new Alert();
   $alert->setBody('Bob wants to play poker');
   $alert->setActionLocKey('PLAY');
   $alert->setLocKey('GAME_PLAY_REQUEST_FORMAT');
   $alert->setLocArgs(array('Jenna', 'Frank'));
   $alert->setLaunchImage('Play.png');
   $message->setAlert($alert);


Now that we have the message taken care of, all we need to do next is send out the message.  Each message
comes back with a set of data that allows us to understand what happened with our push notification as well
as throwing exceptions in the cases of server failures.

.. code-block:: php
   :linenos:

   try {
       $response = $client->send($message);
   } catch (RuntimeException $e) {
       echo $e->getMessage() . PHP_EOL;
       exit(1);
   }
   $client->close();

   if ($response->getCode() != Response::RESULT_OK) {
        switch ($response->getCode()) {
            case Response::RESULT_PROCESSING_ERROR:
                // you may want to retry
                break;
            case Response::RESULT_MISSING_TOKEN:
                // you were missing a token
                break;
            case Response::RESULT_MISSING_TOPIC:
                // you are missing a message id
                break;
            case Response::RESULT_MISSING_PAYLOAD:
                // you need to send a payload
                break;
            case Response::RESULT_INVALID_TOKEN_SIZE:
                // the token provided was not of the proper size
                break;
            case Response::RESULT_INVALID_TOPIC_SIZE:
                // the topic was too long
                break;
            case Response::RESULT_INVALID_PAYLOAD_SIZE:
                // the payload was too large
                break;
            case Response::RESULT_INVALID_TOKEN:
                // the token was invalid; remove it from your system
                break;
            case Response::RESULT_UNKNOWN_ERROR:
                // apple didn't tell us what happened
                break;
        }
   }

.. _zendservice.apple.apns.feedback-service:

Feedback Service
----------------

APNS has a feedback service that you *must* listen to. Apple states that they monitor providers to ensure
that they are listening to this service.

The feedback service simply returns an array of Feedback responses.  All tokens provided in the feedback
should not be sent to again; unless the device re-registers for push notification.  You can use the time
in the Feedback response to ensure that the device has not re-registered for push notifications since the
last send.

.. code-block:: php
   :linenos:   

   use ZendService\Apple\Apns\Client\Feedback as Client;
   use ZendService\Apple\Apns\Response\Feedback as Response;
   use ZendService\Apple\Apns\Exception\RuntimeException;

   $client = new Client();
   $client->open(Client::SANDBOX_URI, '/path/to/push-certificate.pem', 'optionalPassPhrase');
   $responses = $client->feedback();
   $client->close();

   foreach ($responses as $response) {
       echo $response->getTime() . ': ' . $response->getToken();
   }
