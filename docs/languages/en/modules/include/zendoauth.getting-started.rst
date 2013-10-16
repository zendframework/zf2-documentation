.. _zendoauth.introduction.getting-started:

Getting Started
===============

With the OAuth protocol explained, let's show a simple example of it with source code. Our new Consumer will be
handling Twitter Status submissions. To do so, it will need to be registered with Twitter in order to receive an
OAuth Consumer Key and Consumer Secret. This are utilised to obtain an Access Token before we use the Twitter *API*
to post a status message.

Assuming we have obtained a key and secret, we can start the OAuth workflow by setting up a ``ZendOAuth\Consumer``
instance as follows passing it a configuration (either an array or ``Zend\Config\Config`` object).

.. code-block:: php
   :linenos:

   $config = array(
       'callbackUrl' => 'http://example.com/callback.php',
       'siteUrl' => 'http://twitter.com/oauth',
       'consumerKey' => 'gg3DsFTW9OU9eWPnbuPzQ',
       'consumerSecret' => 'tFB0fyWLSMf74lkEu9FTyoHXcazOWpbrAjTCCK48A'
   );
   $consumer = new ZendOAuth\Consumer($config);

The callbackUrl is the URI we want Twitter to request from our server when sending information. We'll look at this
later. The siteUrl is the base URI of Twitter's OAuth *API* endpoints. The full list of endpoints include
http://twitter.com/oauth/request_token, http://twitter.com/oauth/access_token, and
http://twitter.com/oauth/authorize. The base siteUrl utilises a convention which maps to these three OAuth
endpoints (as standard) for requesting a request token, access token or authorization. If the actual endpoints of
any service differ from the standard set, these three URIs can be separately set using the methods
``setRequestTokenUrl()``, ``setAccessTokenUrl()``, and ``setAuthorizeUrl()`` or the configuration fields
requestTokenUrl, accessTokenUrl and authorizeUrl.

The consumerKey and consumerSecret are retrieved from Twitter when your application is registered for OAuth access.
These also apply to any OAuth enabled service, so each one will provide a key and secret for your application.

All of these configuration options may be set using method calls simply by converting from, e.g. callbackUrl to
setCallbackUrl().

In addition, you should note several other configuration values not explicitly used: requestMethod and
requestScheme. By default, ``ZendOAuth\Consumer`` sends requests as POST (except for a redirect which uses
``GET``). The customised client (see later) also includes its authorization by way of a header. Some services may,
at their discretion, require alternatives. You can reset the requestMethod (which defaults to ZendOAuth\Oauth::POST) to
ZendOAuth\Oauth::GET, for example, and reset the requestScheme from its default of ZendOAuth\Oauth::REQUEST_SCHEME_HEADER to
one of ZendOAuth\Oauth::REQUEST_SCHEME_POSTBODY or ZendOAuth\Oauth::REQUEST_SCHEME_QUERYSTRING. Typically the defaults should
work fine apart from some exceptional cases. Please refer to the service provider's documentation for more details.

The second area of customisation is how *HMAC* operates when calculating/comparing them for all requests. This is
configured using the signatureMethod configuration field or ``setSignatureMethod()``. By default this is HMAC-SHA1.
You can set it also to a provider's preferred method including RSA-SHA1. For RSA-SHA1, you should also configure
RSA private and public keys via the rsaPrivateKey and rsaPublicKey configuration fields or the
``setRsaPrivateKey()`` and ``setRsaPublicKey()`` methods.

The first part of the OAuth workflow is obtaining a request token. This is accomplished using:

.. code-block:: php
   :linenos:

   $config = array(
       'callbackUrl' => 'http://example.com/callback.php',
       'siteUrl' => 'http://twitter.com/oauth',
       'consumerKey' => 'gg3DsFTW9OU9eWPnbuPzQ',
       'consumerSecret' => 'tFB0fyWLSMf74lkEu9FTyoHXcazOWpbrAjTCCK48A'
   );
   $consumer = new ZendOAuth\Consumer($config);

   // fetch a request token
   $token = $consumer->getRequestToken();

The new request token (an instance of ``ZendOAuth\Token\Request``) is unauthorized. In order to exchange it for an
authorized token with which we can access the Twitter *API*, we need the user to authorize it. We accomplish this
by redirecting the user to Twitter's authorize endpoint via:

.. code-block:: php
   :linenos:

   $config = array(
       'callbackUrl' => 'http://example.com/callback.php',
       'siteUrl' => 'http://twitter.com/oauth',
       'consumerKey' => 'gg3DsFTW9OU9eWPnbuPzQ',
       'consumerSecret' => 'tFB0fyWLSMf74lkEu9FTyoHXcazOWpbrAjTCCK48A'
   );
   $consumer = new ZendOAuth\Consumer($config);

   // fetch a request token
   $token = $consumer->getRequestToken();

   // persist the token to storage
   $_SESSION['TWITTER_REQUEST_TOKEN'] = serialize($token);

   // redirect the user
   $consumer->redirect();

The user will now be redirected to Twitter. They will be asked to authorize the request token attached to the
redirect URI's query string. Assuming they agree, and complete the authorization, they will be again redirected,
this time to our Callback URL as previously set (note that the callback URL is also registered with Twitter when we
registered our application).

Before redirecting the user, we should persist the request token to storage. For simplicity I'm just using the
user's session, but you can easily use a database for the same purpose, so long as you tie the request token to the
current user so it can be retrieved when they return to our application.

The redirect URI from Twitter will contain an authorized Access Token. We can include code to parse out this access
token as follows - this source code would exist within the executed code of our callback URI. Once parsed we can
discard the previous request token, and instead persist the access token for future use with the Twitter *API*.
Again, we're simply persisting to the user session, but in reality an access token can have a long lifetime so it
should really be stored to a database.

.. code-block:: php
   :linenos:

   $config = array(
       'callbackUrl' => 'http://example.com/callback.php',
       'siteUrl' => 'http://twitter.com/oauth',
       'consumerKey' => 'gg3DsFTW9OU9eWPnbuPzQ',
       'consumerSecret' => 'tFB0fyWLSMf74lkEu9FTyoHXcazOWpbrAjTCCK48A'
   );
   $consumer = new ZendOAuth\Consumer($config);

   if (!empty($_GET) && isset($_SESSION['TWITTER_REQUEST_TOKEN'])) {
       $token = $consumer->getAccessToken(
                    $_GET,
                    unserialize($_SESSION['TWITTER_REQUEST_TOKEN'])
                );
       $_SESSION['TWITTER_ACCESS_TOKEN'] = serialize($token);

       // Now that we have an Access Token, we can discard the Request Token
       $_SESSION['TWITTER_REQUEST_TOKEN'] = null;
   } else {
       // Mistaken request? Some malfeasant trying something?
       exit('Invalid callback request. Oops. Sorry.');
   }

Success! We have an authorized access token - so it's time to actually use the Twitter *API*. Since the access
token must be included with every single *API* request, ``ZendOAuth\Consumer`` offers a ready-to-go *HTTP* client
(a subclass of ``Zend\Http\Client``) to use either by itself or by passing it as a custom *HTTP* Client to another
library or component. Here's an example of using it standalone. This can be done from anywhere in your application,
so long as you can access the OAuth configuration and retrieve the final authorized access token.

.. code-block:: php
   :linenos:

   $config = array(
       'callbackUrl' => 'http://example.com/callback.php',
       'siteUrl' => 'http://twitter.com/oauth',
       'consumerKey' => 'gg3DsFTW9OU9eWPnbuPzQ',
       'consumerSecret' => 'tFB0fyWLSMf74lkEu9FTyoHXcazOWpbrAjTCCK48A'
   );

   $statusMessage = 'I\'m posting to Twitter using ZendOAuth!';

   $token = unserialize($_SESSION['TWITTER_ACCESS_TOKEN']);
   $client = $token->getHttpClient($configuration);
   $client->setUri('http://twitter.com/statuses/update.json');
   $client->setMethod(Zend\Http\Client::POST);
   $client->setParameterPost('status', $statusMessage);
   $response = $client->request();

   $data = Zend\Json\Json::decode($response->getBody());
   $result = $response->getBody();
   if (isset($data->text)) {
       $result = 'true';
   }
   echo $result;

As a note on the customised client, this can be passed to most Zend Framework service or other classes using
``Zend\Http\Client`` displacing the default client they would otherwise use.


