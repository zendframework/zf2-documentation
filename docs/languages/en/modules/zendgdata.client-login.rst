.. _zendgdata.clientlogin:

Authenticating with ClientLogin
===============================

The ClientLogin mechanism enables you to write *PHP* application that acquire authenticated access to Google
Services, specifying a user's credentials in the *HTTP* Client.

See http://code.google.com/apis/accounts/AuthForInstalledApps.html for more information about Google Data
ClientLogin authentication.

The Google documentation says the ClientLogin mechanism is appropriate for "installed applications" whereas the
AuthSub mechanism is for "web applications." The difference is that AuthSub requires interaction from the user, and
a browser interface that can react to redirection requests. The ClientLogin solution uses *PHP* code to supply the
account credentials; the user is not required to enter her credentials interactively.

The account credentials supplied via the ClientLogin mechanism must be valid credentials for Google services, but
they are not required to be those of the user who is using the *PHP* application.

.. _zendgdata.clientlogin.login:

Creating a ClientLogin authenticated Http Client
------------------------------------------------

The process of creating an authenticated *HTTP* client using the ClientLogin mechanism is to call the static
function ``ZendGData\ClientLogin::getHttpClient()`` and pass the Google account credentials in plain text. The
return value of this function is an object of class ``Zend\Http\Client``.

The optional third parameter is the name of the Google Data service. For instance, this can be 'cl' for Google
Calendar. The default is "xapi", which is recognized by Google Data servers as a generic service name.

The optional fourth parameter is an instance of ``Zend\Http\Client``. This allows you to set options in the client,
such as proxy server settings. If you pass ``NULL`` for this parameter, a generic ``Zend\Http\Client`` object is
created.

The optional fifth parameter is a short string that Google Data servers use to identify the client application for
logging purposes. By default this is string "Zend-ZendFramework";

The optional sixth parameter is a string ID for a CAPTCHA(tm) challenge that has been issued by the server. It is
only necessary when logging in after receiving a CAPTCHA(tm) challenge from a previous login attempt.

The optional seventh parameter is a user's response to a CAPTCHA(tm) challenge that has been issued by the server.
It is only necessary when logging in after receiving a CAPTCHA(tm) challenge from a previous login attempt.

Below is an example of *PHP* code for a web application to acquire authentication to use the Google Calendar
service and create a ``ZendGData`` client object using that authenticated ``Zend\Http\Client``.

.. code-block:: php
   :linenos:

   // Enter your Google account credentials
   $email = 'johndoe@gmail.com';
   $passwd = 'xxxxxxxx';
   try {
      $client = ZendGData\ClientLogin::getHttpClient($email, $passwd, 'cl');
   } catch (ZendGData\App\CaptchaRequiredException $cre) {
       echo 'URL of CAPTCHA image: ' . $cre->getCaptchaUrl() . "\n";
       echo 'Token ID: ' . $cre->getCaptchaToken() . "\n";
   } catch (ZendGData\App\AuthException $ae) {
      echo 'Problem authenticating: ' . $ae->exception() . "\n";
   }

   $cal = new ZendGData\Calendar($client);

.. _zendgdata.clientlogin.terminating:

Terminating a ClientLogin authenticated Http Client
---------------------------------------------------

There is no method to revoke ClientLogin authentication as there is in the AuthSub token-based solution. The
credentials used in the ClientLogin authentication are the login and password to a Google account, and therefore
these can be used repeatedly in the future.



