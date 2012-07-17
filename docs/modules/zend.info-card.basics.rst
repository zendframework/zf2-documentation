
.. _zend.infocard.basics:

Introduction
============

The ``Zend_InfoCard`` component implements relying-party support for Information Cards. Information Cards are used for identity management on the internet and authentication of users to web sites. The web sites that the user ultimately authenticates to are called **relying-parties**.

Detailed information about information cards and their importance to the internet identity metasystem can be found on the `IdentityBlog`_.


.. _zend.infocard.basics.theory:

Basic Theory of Usage
---------------------

Usage of ``Zend_InfoCard`` can be done one of two ways: either as part of the larger ``Zend_Auth`` component via the ``Zend_InfoCard`` authentication adapter or as a stand-alone component. In both cases an information card can be requested from a user by using the following *HTML* block in your *HTML* login form:

.. code-block:: html
   :linenos:

   <form action="http://example.com/server" method="POST">
     <input type='image' src='/images/ic.png' align='center'
           width='120px' style='cursor:pointer' />
     <object type="application/x-informationCard"
             name="xmlToken">
      <param name="tokenType"
            value="urn:oasis:names:tc:SAML:1.0:assertion" />
      <param name="requiredClaims"
            value="http://.../claims/privatepersonalidentifier
            http://.../claims/givenname
            http://.../claims/surname" />
    </object>
   </form>

In the example above, the ``requiredClaims`` <param> tag is used to identify pieces of information known as claims (i.e. person's first name, last name) which the web site (a.k.a "relying party") needs in order a user to authenticate using an information card. For your reference, the full *URI* (for instance the **givenname** claim) is as follows: ``http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname``

When the above *HTML* is activated by a user (clicks on it), the browser will bring up a card selection program which not only shows them which information cards meet the requirements of the site, but also allows them to select which information card to use if multiple meet the criteria. This information card is transmitted as an *XML* document to the specified POST *URL* and is ready to be processed by the ``Zend_InfoCard`` component.

Note, Information cards can only be *HTTP* *POST*\ ed to *SSL*-encrypted *URL*\ s. Please consult your web server's documentation on how to set up *SSL* encryption.


.. _zend.infocard.basics.auth:

Using as part of Zend_Auth
--------------------------

In order to use the component as part of the ``Zend_Auth`` authentication system, you must use the provided ``Zend_Auth_Adapter_InfoCard`` to do so (not available in the standalone ``Zend_InfoCard`` distribution). An example of its usage is shown below:

.. code-block:: php
   :linenos:

   <?php
   if (isset($_POST['xmlToken'])) {

       $adapter = new Zend_Auth_Adapter_InfoCard($_POST['xmlToken']);

       $adapter->addCertificatePair('/usr/local/Zend/apache2/conf/server.key',
                                    '/usr/local/Zend/apache2/conf/server.crt');

       $auth = Zend_Auth::getInstance();

       $result = $auth->authenticate($adapter);

       switch ($result->getCode()) {
           case Zend_Auth_Result::SUCCESS:
               $claims = $result->getIdentity();
               print "Given Name: {$claims->givenname}<br />";
               print "Surname: {$claims->surname}<br />";
               print "Email Address: {$claims->emailaddress}<br />";
               print "PPI: {$claims->getCardID()}<br />";
               break;
           case Zend_Auth_Result::FAILURE_CREDENTIAL_INVALID:
               print "The Credential you provided did not pass validation";
               break;
           default:
           case Zend_Auth_Result::FAILURE:
               print "There was an error processing your credentials.";
               break;
       }

       if (count($result->getMessages()) > 0) {
           print "<pre>";
           var_dump($result->getMessages());
           print "</pre>";
       }

   }
   ?>
   <hr />
   <div id="login" style="font-family: arial; font-size: 2em;">
   <p>Simple Login Demo</p>
    <form method="post">
     <input type="submit" value="Login" />
      <object type="application/x-informationCard" name="xmlToken">
       <param name="tokenType"
             value="urn:oasis:names:tc:SAML:1.0:assertion" />
       <param name="requiredClaims"
             value="http://.../claims/givenname
                    http://.../claims/surname
                    http://.../claims/emailaddress
                    http://.../claims/privatepersonalidentifier" />
     </object>
    </form>
   </div>

In the example above, we first create an instance of the ``Zend_Auth_Adapter_InfoCard`` and pass the *XML* data posted by the card selector into it. Once an instance has been created you must then provide at least one *SSL* certificate public/private key pair used by the web server that received the *HTTP* *POST*. These files are used to validate the destination of the information posted to the server and are a requirement when using Information Cards.

Once the adapter has been configured, you can then use the standard ``Zend_Auth`` facilities to validate the provided information card token and authenticate the user by examining the identity provided by the ``getIdentity()`` method.


.. _zend.infocard.basics.standalone:

Using the Zend_InfoCard component standalone
--------------------------------------------

It is also possible to use the ``Zend_InfoCard`` component as a standalone component by interacting with the ``Zend_InfoCard`` class directly. Using the ``Zend_InfoCard`` class is very similar to its use with the ``Zend_Auth`` component. An example of its use is shown below:

.. code-block:: php
   :linenos:

   <?php
   if (isset($_POST['xmlToken'])) {
       $infocard = new Zend_InfoCard();
       $infocard->addCertificatePair('/usr/local/Zend/apache2/conf/server.key',
                                     '/usr/local/Zend/apache2/conf/server.crt');

       $claims = $infocard->process($_POST['xmlToken']);

       if($claims->isValid()) {
           print "Given Name: {$claims->givenname}<br />";
           print "Surname: {$claims->surname}<br />";
           print "Email Address: {$claims->emailaddress}<br />";
           print "PPI: {$claims->getCardID()}<br />";
       } else {
           print "Error Validating identity: {$claims->getErrorMsg()}";
       }
   }
   ?>
   <hr />
   <div id="login" style="font-family: arial; font-size: 2em;">
    <p>Simple Login Demo</p>
    <form method="post">
     <input type="submit" value="Login" />
      <object type="application/x-informationCard" name="xmlToken">
       <param name="tokenType"
             value="urn:oasis:names:tc:SAML:1.0:assertion" />
       <param name="requiredClaims"
             value="http://.../claims/givenname
                    http://.../claims/surname
                    http://.../claims/emailaddress
                    http://.../claims/privatepersonalidentifier" />
      </object>
    </form>
   </div>

In the example above, we use the ``Zend_InfoCard`` component independently to validate the token provided by the user. As was the case with the ``Zend_Auth_Adapter_InfoCard``, we create an instance of ``Zend_InfoCard`` and then set one or more *SSL* certificate public/private key pairs used by the web server. Once configured, we can use the ``process()`` method to process the information card and return the results.


.. _zend.infocard.basics.claims:

Working with a Claims object
----------------------------

Regardless of whether the ``Zend_InfoCard`` component is used as a standalone component or as part of ``Zend_Auth`` via ``Zend_Auth_Adapter_InfoCard``, the ultimate result of the processing of an information card is a ``Zend_InfoCard_Claims`` object. This object contains the assertions (a.k.a. claims) made by the submitting user based on the data requested by your web site when the user authenticated. As shown in the examples above, the validity of the information card can be ascertained by calling the ``Zend_InfoCard_Claims::isValid()`` method. Claims themselves can either be retrieved by simply accessing the identifier desired (i.e. ``givenname``) as a property of the object or through the ``getClaim()`` method.

In most cases you will never need to use the ``getClaim()`` method. However, if your ``requiredClaims`` mandate that you request claims from multiple different sources/namespaces then you will need to extract them explicitly using this method (simply pass it the full *URI* of the claim to retrieve its value from within the information card). Generally speaking however, the ``Zend_InfoCard`` component will set the default *URI* for claims to be the one used the most frequently within the information card itself and the simplified property-access method can be used.

As part of the validation process, it is the developer's responsibility to examine the issuing source of the claims contained within the information card and to decide if that source is a trusted source of information. To do so, the ``getIssuer()`` method is provided within the ``Zend_InfoCard_Claims`` object which returns the *URI* of the issuer of the information card claims.


.. _zend.infocard.basics.attaching:

Attaching Information Cards to existing accounts
------------------------------------------------

It is possible to add support for information cards to an existing authentication system by storing the private personal identifier (PPI) to a previously traditionally-authenticated account and including at least the ``http://schemas.xmlsoap.org/ws/2005/05/identity/claims/privatepersonalidentifier`` claim as part of the ``requiredClaims`` of the request. If this claim is requested then the ``Zend_InfoCard_Claims`` object will provide a unique identifier for the specific card that was submitted by calling the ``getCardID()`` method.

An example of how to attach an information card to an existing traditional-authentication account is shown below:

.. code-block:: php
   :linenos:

   // ...
   public function submitinfocardAction()
   {
       if (!isset($_REQUEST['xmlToken'])) {
           throw new ZBlog_Exception('Expected an encrypted token ' .
                                     'but was not provided');
       }

       $infoCard = new Zend_InfoCard();
       $infoCard->addCertificatePair(SSL_CERTIFICATE_PRIVATE,
                                     SSL_CERTIFICATE_PUB);

       try {
           $claims = $infoCard->process($request['xmlToken']);
       } catch(Zend_InfoCard_Exception $e) {
           // TODO Error processing your request
           throw $e;
       }

       if ($claims->isValid()) {
           $db = ZBlog_Data::getAdapter();

           $ppi = $db->quote($claims->getCardID());
           $fullname = $db->quote("{$claims->givenname} {$claims->surname}");

           $query = "UPDATE blogusers
                        SET ppi = $ppi,
                            real_name = $fullname
                      WHERE username='administrator'";

           try {
               $db->query($query);
           } catch(Exception $e) {
               // TODO Failed to store in DB
           }

           $this->view->render();
           return;
       } else {
           throw new
               ZBlog_Exception("Infomation card failed security checks");
       }
   }


.. _zend.infocard.basics.adapters:

Creating Zend_InfoCard Adapters
-------------------------------

The ``Zend_InfoCard`` component was designed to allow for growth in the information card standard through the use of a modular architecture. At this time, many of these hooks are unused and can be ignored, but there is one class that should be written for any serious information card implementation: the ``Zend_InfoCard`` adapter.

The ``Zend_InfoCard`` adapter is used as a callback mechanism within the component to perform various tasks, such as storing and retrieving Assertion IDs for information cards when they are processed by the component. While storing the assertion IDs of submitted information cards is not necessary, failing to do so opens up the possibility of the authentication scheme being compromised through a replay attack.

To prevent this, one must implement the ``Zend_InfoCard_Adapter_Interface`` and set an instance of this interface prior to calling either the ``process()`` (standalone) or ``authenticate()`` method as a ``Zend_Auth`` adapter. To set this interface, the ``setAdapter()`` method should be used. In the example below, we set a ``Zend_InfoCard`` adapter and use it in our application:

.. code-block:: php
   :linenos:

   class myAdapter implements Zend_InfoCard_Adapter_Interface
   {
       public function storeAssertion($assertionURI,
                                      $assertionID,
                                      $conditions)
       {
           /* Store the assertion and its conditions by ID and URI */
       }

       public function retrieveAssertion($assertionURI, $assertionID)
       {
           /* Retrieve the assertion by URI and ID */
       }

       public function removeAssertion($assertionURI, $assertionID)
       {
           /* Delete a given assertion by URI/ID */
       }
   }

   $adapter  = new myAdapter();

   $infoCard = new Zend_InfoCard();
   $infoCard->addCertificatePair(SSL_PRIVATE, SSL_PUB);
   $infoCard->setAdapter($adapter);

   $claims = $infoCard->process($_POST['xmlToken']);



.. _`IdentityBlog`: http://www.identityblog.com/
