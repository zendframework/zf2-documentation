.. _zendopenid.provider:

ZendOpenId\Provider
====================

``ZendOpenId\Provider`` can be used to implement OpenID servers. This chapter provides examples that demonstrate
how to build a very basic server. However, for implementation of a production OpenID server (such as
`www.myopenid.com`_) you may have to deal with more complex issues.

.. _zendopenid.provider.start:

Quick start
-----------

The following example includes code for creating a user account using ``ZendOpenId\Provider::register``. The link
element with ``rel="openid.server"`` points to our own server script. If you submit this identity to an
OpenID-enabled site, it will perform authentication on this server.

The code before the <html> tag is just a trick that automatically creates a user account. You won't need such code
when using real identities.

.. _zendopenid.provider.example-1:

.. rubric:: The Identity

.. code-block:: php
   :linenos:

   <?php
   // Set up test identity
   define("TEST_SERVER", ZendOpenId\OpenId::absoluteURL("example-8.php"));
   define("TEST_ID", ZendOpenId\OpenId::selfURL());
   define("TEST_PASSWORD", "123");
   $server = new ZendOpenId\Provider();
   if (!$server->hasUser(TEST_ID)) {
       $server->register(TEST_ID, TEST_PASSWORD);
   }
   ?>
   <html><head>
   <link rel="openid.server" href="<?php echo TEST_SERVER;?>" />
   </head><body>
   <?php echo TEST_ID;?>
   </body></html>

The following identity server script handles two kinds of requests from OpenID-enabled sites (for association and
authentication). Both of them are handled by the same method: ``ZendOpenId\Provider::handle``. The two arguments
to the ``ZendOpenId\Provider`` constructor are *URL*\ s of login and trust pages, which ask for input from the end
user.

On success, the method ``ZendOpenId\Provider::handle`` returns a string that should be passed back to the
OpenID-enabled site. On failure, it returns ``FALSE``. This example will return an *HTTP* 403 response if
``ZendOpenId\Provider::handle`` fails. You will get this response if you open this script with a web browser,
because it sends a non-OpenID conforming request.

.. _zendopenid.provider.example-2:

.. rubric:: Simple Identity Provider

.. code-block:: php
   :linenos:

   $server = new ZendOpenId\Provider("example-8-login.php",
                                      "example-8-trust.php");
   $ret = $server->handle();
   if (is_string($ret)) {
       echo $ret;
   } else if ($ret !== true) {
       header('HTTP/1.0 403 Forbidden');
       echo 'Forbidden';
   }

.. note::

   It is a good idea to use a secure connection (HTTPS) for these scripts- especially for the following interactive
   scripts- to prevent password disclosure.

The following script implements a login screen for an identity server using ``ZendOpenId\Provider`` and redirects
to this page when a required user has not yet logged in. On this page, a user will enter his password to login.

You should use the password "123" that was used in the identity script above.

On submit, the script calls ``ZendOpenId\Provider::login`` with the accepted user's identity and password, then
redirects back to the main identity provider's script. On success, the ``ZendOpenId\Provider::login`` establishes
a session between the user and the identity provider and stores the information about the user, who is now logged
in. All following requests from the same user won't require a login procedure- even if they come from another
OpenID enabled web site.

.. note::

   Note that this session is between end-user and identity provider only. OpenID enabled sites know nothing about
   it.

.. _zendopenid.provider.example-3:

.. rubric:: Simple Login Screen

.. code-block:: php
   :linenos:

   <?php
   $server = new ZendOpenId\Provider();

   if ($_SERVER['REQUEST_METHOD'] == 'POST' &&
       isset($_POST['openid_action']) &&
       $_POST['openid_action'] === 'login' &&
       isset($_POST['openid_identifier']) &&
       isset($_POST['openid_password'])) {
       $server->login($_POST['openid_identifier'],
                      $_POST['openid_password']);
       ZendOpenId\OpenId::redirect("example-8.php", $_GET);
   }
   ?>
   <html>
   <body>
   <form method="post">
   <fieldset>
   <legend>OpenID Login</legend>
   <table border=0>
   <tr>
   <td>Name:</td>
   <td>
   <input type="text"
          name="openid_identifier"
          value="<?php echo htmlspecialchars($_GET['openid_identity']);?>">
   </td>
   </tr>
   <tr>
   <td>Password:</td>
   <td>
   <input type="text"
          name="openid_password"
          value="">
   </td>
   </tr>
   <tr>
   <td> </td>
   <td>
   <input type="submit"
          name="openid_action"
          value="login">
   </td>
   </tr>
   </table>
   </fieldset>
   </form>
   </body>
   </html>

The fact that the user is now logged in doesn't mean that the authentication must necessarily succeed. The user may
decide not to trust particular OpenID enabled sites. The following trust screen allows the end user to make that
choice. This choice may either be made only for current requests or forever. In the second case, information about
trusted/untrusted sites is stored in an internal database, and all following authentication requests from this site
will be handled automatically without user interaction.

.. _zendopenid.provider.example-4:

.. rubric:: Simple Trust Screen

.. code-block:: php
   :linenos:

   <?php
   $server = new ZendOpenId\Provider();

   if ($_SERVER['REQUEST_METHOD'] == 'POST' &&
       isset($_POST['openid_action']) &&
       $_POST['openid_action'] === 'trust') {

       if (isset($_POST['allow'])) {
           if (isset($_POST['forever'])) {
               $server->allowSite($server->getSiteRoot($_GET));
           }
           $server->respondToConsumer($_GET);
       } else if (isset($_POST['deny'])) {
           if (isset($_POST['forever'])) {
               $server->denySite($server->getSiteRoot($_GET));
           }
           ZendOpenId\OpenId::redirect($_GET['openid_return_to'],
                                 array('openid.mode'=>'cancel'));
       }
   }
   ?>
   <html>
   <body>
   <p>A site identifying as
   <a href="<?php echo htmlspecialchars($server->getSiteRoot($_GET));?>">
   <?php echo htmlspecialchars($server->getSiteRoot($_GET));?>
   </a>
   has asked us for confirmation that
   <a href="<?php echo htmlspecialchars($server->getLoggedInUser());?>">
   <?php echo htmlspecialchars($server->getLoggedInUser());?>
   </a>
   is your identity URL.
   </p>
   <form method="post">
   <input type="checkbox" name="forever">
   <label for="forever">forever</label><br>
   <input type="hidden" name="openid_action" value="trust">
   <input type="submit" name="allow" value="Allow">
   <input type="submit" name="deny" value="Deny">
   </form>
   </body>
   </html>

Production OpenID servers usually support the Simple Registration Extension that allows consumers to request some
information about the user from the provider. In this case, the trust page can be extended to allow entering
requested fields or selecting a specific user profile.

.. _zendopenid.provider.all:

Combined Provide Scripts
------------------------

It is possible to combine all provider functionality in one script. In this case login and trust *URL*\ s are
omitted, and ``ZendOpenId\Provider`` assumes that they point to the same page with the additional
"openid.action"``GET`` argument.

.. note::

   The following example is not complete. It doesn't provide GUI code for the user, instead performing an automatic
   login and trust relationship instead. This is done just to simplify the example; a production server should
   include some code from previous examples.

.. _zendopenid.provider.example-5:

.. rubric:: Everything Together

.. code-block:: php
   :linenos:

   $server = new ZendOpenId\Provider();

   define("TEST_ID", ZendOpenId\OpenId::absoluteURL("example-9-id.php"));
   define("TEST_PASSWORD", "123");

   if ($_SERVER['REQUEST_METHOD'] == 'GET' &&
       isset($_GET['openid_action']) &&
       $_GET['openid_action'] === 'login') {
       $server->login(TEST_ID, TEST_PASSWORD);
       unset($_GET['openid_action']);
       ZendOpenId\OpenId::redirect(ZendOpenId\OpenId::selfUrl(), $_GET);
   } else if ($_SERVER['REQUEST_METHOD'] == 'GET' &&
       isset($_GET['openid_action']) &&
       $_GET['openid_action'] === 'trust') {
       unset($_GET['openid_action']);
       $server->respondToConsumer($_GET);
   } else {
       $ret = $server->handle();
       if (is_string($ret)) {
           echo $ret;
       } else if ($ret !== true) {
           header('HTTP/1.0 403 Forbidden');
           echo 'Forbidden';
       }
   }

If you compare this example with previous examples split in to separate pages, you will see only the one difference
besides the dispatch code: ``unset($_GET['openid_action'])``. This call to ``unset()`` is necessary to route the
next request to main handler.

.. _zendopenid.provider.sreg:

Simple Registration Extension
-----------------------------

Again, the code before the <html> tag is just a trick to demonstrate functionality. It creates a new user account
and associates it with a profile (nickname and password). Such tricks aren't needed in deployed providers where end
users register on OpenID servers and fill in their profiles. Implementing this GUI is out of scope for this manual.

.. _zendopenid.provider.example-6:

.. rubric:: Identity with Profile

.. code-block:: php
   :linenos:

   <?php
   define("TEST_SERVER", ZendOpenId\OpenId::absoluteURL("example-10.php"));
   define("TEST_ID", ZendOpenId\OpenId::selfURL());
   define("TEST_PASSWORD", "123");
   $server = new ZendOpenId\Provider();
   if (!$server->hasUser(TEST_ID)) {
       $server->register(TEST_ID, TEST_PASSWORD);
       $server->login(TEST_ID, TEST_PASSWORD);
       $sreg = new ZendOpenId\Extension\Sreg(array(
           'nickname' =>'test',
           'email' => 'test@test.com'
       ));
       $root = ZendOpenId\OpenId::absoluteURL(".");
       ZendOpenId\OpenId::normalizeUrl($root);
       $server->allowSite($root, $sreg);
       $server->logout();
   }
   ?>
   <html>
   <head>
   <link rel="openid.server" href="<?php echo TEST_SERVER;?>" />
   </head>
   <body>
   <?php echo TEST_ID;?>
   </body>
   </html>

You should now pass this identity to the OpenID-enabled web site (use the Simple Registration Extension example
from the previous section), and it should use the following OpenID server script.

This script is a variation of the script in the "Everything Together" example. It uses the same automatic login
mechanism, but doesn't contain any code for a trust page. The user already trusts the example scripts forever. This
trust was established by calling the ``ZendOpenId\Provider::allowSite()`` method in the identity script. The same
method associates the profile with the trusted *URL*. This profile will be returned automatically for a request
from the trusted *URL*.

To make Simple Registration Extension work, you must simply pass an instance of ``ZendOpenId\Extension\Sreg`` as
the second argument to the ``ZendOpenId\Provider::handle()`` method.

.. _zendopenid.provider.example-7:

.. rubric:: Provider with SREG

.. code-block:: php
   :linenos:

   $server = new ZendOpenId\Provider();
   $sreg = new ZendOpenId\Extension\Sreg();

   define("TEST_ID", ZendOpenId\OpenId::absoluteURL("example-10-id.php"));
   define("TEST_PASSWORD", "123");

   if ($_SERVER['REQUEST_METHOD'] == 'GET' &&
       isset($_GET['openid_action']) &&
       $_GET['openid_action'] === 'login') {
       $server->login(TEST_ID, TEST_PASSWORD);
       unset($_GET['openid_action']);
       ZendOpenId\OpenId::redirect(ZendOpenId\OpenId::selfUrl(), $_GET);
   } elseif ($_SERVER['REQUEST_METHOD'] == 'GET' &&
       isset($_GET['openid_action']) &&
       $_GET['openid_action'] === 'trust') {
      echo "UNTRUSTED DATA" ;
   } else {
       $ret = $server->handle(null, $sreg);
       if (is_string($ret)) {
           echo $ret;
       } else if ($ret !== true) {
           header('HTTP/1.0 403 Forbidden');
           echo 'Forbidden';
       }
   }

.. _zendopenid.provider.else:

Anything Else?
--------------

Building OpenID providers is much less common than building OpenID-enabled sites, so this manual doesn't cover all
``ZendOpenId\Provider`` features exhaustively, as was done for ``ZendOpenId\Consumer``.

To summarize, ``ZendOpenId\Provider`` contains:

- A set of methods to build an end-user GUI that allows users to register and manage their trusted sites and
  profiles

- An abstract storage layer to store information about users, their sites and their profiles. It also stores
  associations between the provider and OpenID-enabled sites. This layer is very similar to that of the
  ``ZendOpenId\Consumer`` class. It also uses file storage by default, but may used with another backend.

- An abstract user-association layer that may associate a user's web browser with a logged-in identity

The ``ZendOpenId\Provider`` class doesn't attempt to cover all possible features that can be implemented by OpenID
servers, e.g. digital certificates, but it can be extended easily using ``ZendOpenId\Extension``\ s or by standard
object-oriented extension.



.. _`www.myopenid.com`: http://www.myopenid.com
