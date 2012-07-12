
Catching Gdata Exceptions
=========================

The ``Zend_Gdata_App_Exception`` class is a base class for exceptions thrown by ``Zend_Gdata`` . You can catch any exception thrown by ``Zend_Gdata`` by catching ``Zend_Gdata_App_Exception`` .

.. code-block:: php
    :linenos:
    
    try {
        $client =
            Zend_Gdata_ClientLogin::getHttpClient($username, $password);
    } catch(Zend_Gdata_App_Exception $ex) {
        // Report the exception to the user
        die($ex->getMessage());
    }
    

The following exception subclasses are used by ``Zend_Gdata`` :
    - Zend_Gdata_App_AuthException
    - indicates that the user's account credentials were not valid.
    - Zend_Gdata_App_BadMethodCallException
    - indicates that a method was called for a service
    - that does not support the method. For example,
    - the CodeSearch service does not support post().
    - Zend_Gdata_App_HttpException
    - indicates that an HTTP request was not successful.
    - Provides the ability to get the full Zend_Http_Response
    - object to determine the exact cause of the failure in
    - cases where $e->getMessage() does not provide
    - enough details.
    - Zend_Gdata_App_InvalidArgumentException
    - is thrown when the application provides a value that
    - is not valid in a given context. For example,
    - specifying a Calendar visibility value of "banana",
    - or fetching a Blogger feed without specifying
    - any blog name.
    - Zend_Gdata_App_CaptchaRequiredException
    - is thrown when a ClientLogin attempt receives a
    - CAPTCHA challenge from the
    - authentication service. This exception contains a token
    - ID and a URL to a CAPTCHA
    - challenge image. The image is a visual puzzle that
    - should be displayed to the user. After
    - collecting the user's response to the challenge
    - image, the response can be included with the next
    - ClientLogin attempt.The user can alternatively be
    - directed to this website:
    - https://www.google.com/accounts/DisplayUnlockCaptcha
    - Further information can be found in the
    - ClientLogin documentation.



You can use these exception subclasses to handle specific exceptions differently. See the *API* documentation for information on which exception subclasses are thrown by which methods in ``Zend_Gdata`` .

.. code-block:: php
    :linenos:
    
    try {
        $client = Zend_Gdata_ClientLogin::getHttpClient($username,
                                                        $password,
                                                        $service);
    } catch(Zend_Gdata_App_AuthException $authEx) {
        // The user's credentials were incorrect.
        // It would be appropriate to give the user a second try.
        ...
    } catch(Zend_Gdata_App_HttpException $httpEx) {
        // Google Data servers cannot be contacted.
        die($httpEx->getMessage);}
    


