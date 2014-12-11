.. _zendgdata.exception:

Catching Gdata Exceptions
=========================

The ``ZendGData\App\Exception`` class is a base class for exceptions thrown by ``ZendGData``. You can catch any
exception thrown by ``ZendGData`` by catching ``ZendGData\App\Exception``.

.. code-block:: php
   :linenos:

   try {
       $client =
           ZendGData\ClientLogin::getHttpClient($username, $password);
   } catch(ZendGData\App\Exception $ex) {
       // Report the exception to the user
       die($ex->getMessage());
   }

The following exception subclasses are used by ``ZendGData``:



   - ``ZendGData\App\AuthException`` indicates that the user's account credentials were not valid.

   - ``ZendGData\App\BadMethodCallException`` indicates that a method was called for a service that does not
     support the method. For example, the CodeSearch service does not support ``post()``.

   - ``ZendGData\App\HttpException`` indicates that an *HTTP* request was not successful. Provides the ability to
     get the full ``Zend\Http\Response`` object to determine the exact cause of the failure in cases where
     ``$e->getMessage()`` does not provide enough details.

   - ``ZendGData\App\InvalidArgumentException`` is thrown when the application provides a value that is not valid
     in a given context. For example, specifying a Calendar visibility value of "banana", or fetching a Blogger
     feed without specifying any blog name.

   - ``ZendGData\App\CaptchaRequiredException`` is thrown when a ClientLogin attempt receives a CAPTCHA(tm)
     challenge from the authentication service. This exception contains a token ID and a *URL* to a CAPTCHA(tm)
     challenge image. The image is a visual puzzle that should be displayed to the user. After collecting the
     user's response to the challenge image, the response can be included with the next ClientLogin attempt.The
     user can alternatively be directed to this website: https://www.google.com/accounts/DisplayUnlockCaptcha
     Further information can be found in the :ref:`ClientLogin documentation <zendgdata.clientlogin>`.



You can use these exception subclasses to handle specific exceptions differently. See the *API* documentation for
information on which exception subclasses are thrown by which methods in ``ZendGData``.

.. code-block:: php
   :linenos:

   try {
       $client = ZendGData\ClientLogin::getHttpClient($username,
                                                       $password,
                                                       $service);
   } catch(ZendGData\App\AuthException $authEx) {
       // The user's credentials were incorrect.
       // It would be appropriate to give the user a second try.
       ...
   } catch(ZendGData\App\HttpException $httpEx) {
       // Google Data servers cannot be contacted.
       die($httpEx->getMessage);}



