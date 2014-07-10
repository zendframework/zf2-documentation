.. _zendgdata.authsub:

Authenticating with AuthSub
===========================

The AuthSub mechanism enables you to write web applications that acquire authenticated access Google Data services,
without having to write code that handles user credentials.

See http://code.google.com/apis/accounts/AuthForWebApps.html for more information about Google Data AuthSub
authentication.

The Google documentation says the ClientLogin mechanism is appropriate for "installed applications" whereas the
AuthSub mechanism is for "web applications." The difference is that AuthSub requires interaction from the user, and
a browser interface that can react to redirection requests. The ClientLogin solution uses *PHP* code to supply the
account credentials; the user is not required to enter her credentials interactively.

The account credentials supplied via the AuthSub mechanism are entered by the user of the web application.
Therefore they must be account credentials that are known to that user.

.. note::

   **Registered applications**

   ``ZendGData`` currently does not support use of secure tokens, because the AuthSub authentication does not
   support passing a digital certificate to acquire a secure token.

.. _zendgdata.authsub.login:

Creating an AuthSub authenticated Http Client
---------------------------------------------

Your *PHP* application should provide a hyperlink to the Google *URL* that performs authentication. The static
function ``ZendGData\AuthSub::getAuthSubTokenUri()`` provides the correct *URL*. The arguments to this function
include the *URL* to your *PHP* application so that Google can redirect the user's browser back to your application
after the user's credentials have been verified.

After Google's authentication server redirects the user's browser back to the current application, a ``GET``
request parameter is set, called **token**. The value of this parameter is a single-use token that can be used for
authenticated access. This token can be converted into a multi-use token and stored in your session.

Then use the token value in a call to ``ZendGData\AuthSub::getHttpClient()``. This function returns an instance of
``Zend\Http\Client``, with appropriate headers set so that subsequent requests your application submits using that
*HTTP* Client are also authenticated.

Below is an example of *PHP* code for a web application to acquire authentication to use the Google Calendar
service and create a ``ZendGData`` client object using that authenticated *HTTP* Client.

.. code-block:: php
   :linenos:

   $my_calendar = 'http://www.google.com/calendar/feeds/default/private/full';

   if (!isset($_SESSION['cal_token'])) {
       if (isset($_GET['token'])) {
           // You can convert the single-use token to a session token.
           $session_token =
               ZendGData\AuthSub::getAuthSubSessionToken($_GET['token']);
           // Store the session token in our session.
           $_SESSION['cal_token'] = $session_token;
       } else {
           // Display link to generate single-use token
           $googleUri = ZendGData\AuthSub::getAuthSubTokenUri(
               'http://'. $_SERVER['SERVER_NAME'] . $_SERVER['REQUEST_URI'],
               $my_calendar, 0, 1);
           echo "Click <a href='$googleUri'>here</a> " .
                "to authorize this application.";
           exit();
       }
   }

   // Create an authenticated HTTP Client to talk to Google.
   $client = ZendGData\AuthSub::getHttpClient($_SESSION['cal_token']);

   // Create a Gdata object using the authenticated Http Client
   $cal = new ZendGData\Calendar($client);

.. _zendgdata.authsub.logout:

Revoking AuthSub authentication
-------------------------------

To terminate the authenticated status of a given token, use the ``ZendGData\AuthSub::AuthSubRevokeToken()`` static
function. Otherwise, the token is still valid for some time.

.. code-block:: php
   :linenos:

   // Carefully construct this value to avoid application security problems.
   $php_self = htmlentities(substr($_SERVER['PHP_SELF'],
                            0,
                            strcspn($_SERVER['PHP_SELF'], "\n\r")),
                            ENT_QUOTES);

   if (isset($_GET['logout'])) {
       ZendGData\AuthSub::AuthSubRevokeToken($_SESSION['cal_token']);
       unset($_SESSION['cal_token']);
       header('Location: ' . $php_self);
       exit();
   }

.. note::

   **Security notes**

   The treatment of the ``$php_self`` variable in the example above is a general security guideline, it is not
   specific to ``ZendGData``. You should always filter content you output to *HTTP* headers.

   Regarding revoking authentication tokens, it is recommended to do this when the user is finished with her Google
   Data session. The possibility that someone can intercept the token and use it for malicious purposes is very
   small, but nevertheless it is a good practice to terminate authenticated access to any service.



