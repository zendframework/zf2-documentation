
Open ID Authentication
======================

.. _zend.auth.adapter.openid.introduction:

Introduction
------------

The ``Zend_Auth_Adapter_OpenId`` adapter can be used to authenticate users using remote OpenID servers. This authentication method assumes that the user submits only their OpenID identity to the web application. They are then redirected to their OpenID provider to prove identity ownership using a password or some other method. This password is never provided to the web application.

The OpenID identity is just a *URI* that points to a web site with information about a user, along with special tags that describes which server to use and which identity to submit there. You can read more about OpenID at the `OpenID official site`_ .

The ``Zend_Auth_Adapter_OpenId`` class wraps the ``Zend_OpenId_Consumer`` component, which implements the OpenID authentication protocol itself.

.. note::
    ****

     ``Zend_OpenId`` takes advantage of the `GMP extension`_ , where available. Consider enabling the *GMP* extension for better performance when using ``Zend_Auth_Adapter_OpenId`` .

.. _zend.auth.adapter.openid.specifics:

Specifics
---------

As is the case for all ``Zend_Auth`` adapters, the ``Zend_Auth_Adapter_OpenId`` class implements ``Zend_Auth_Adapter_Interface`` , which defines one method: ``authenticate()`` . This method performs the authentication itself, but the object must be prepared prior to calling it. Such adapter preparation includes setting up the OpenID identity and some other ``Zend_OpenId`` specific options.

However, as opposed to other ``Zend_Auth`` adapters, ``Zend_Auth_Adapter_OpenId`` performs authentication on an external server in two separate *HTTP* requests. So the ``Zend_Auth_Adapter_OpenId::authenticate()`` method must be called twice. On the first invocation the method won't return, but will redirect the user to their OpenID server. Then after the user is authenticated on the remote server, they will be redirected back and the script for this second request must call ``Zend_Auth_Adapter_OpenId::authenticate()`` again to verify the signature which comes with the redirected request from the server to complete the authentication process. On this second invocation, the method will return the ``Zend_Auth_Result`` object as expected.

The following example shows the usage of ``Zend_Auth_Adapter_OpenId`` . As previously mentioned, the ``Zend_Auth_Adapter_OpenId::authenticate()`` must be called two times. The first time is after the user submits the *HTML* form with the ``$_POST['openid_action']`` set to"login", and the second time is after the *HTTP* redirection from OpenID server with ``$_GET['openid_mode']`` or ``$_POST['openid_mode']`` set.

.. code-block:: php
    :linenos:
    
    <?php
    $status = "";
    $auth = Zend_Auth::getInstance();
    if ((isset($_POST['openid_action']) &&
         $_POST['openid_action'] == "login" &&
         !empty($_POST['openid_identifier'])) ||
        isset($_GET['openid_mode']) ||
        isset($_POST['openid_mode'])) {
        $result = $auth->authenticate(
            new Zend_Auth_Adapter_OpenId(@$_POST['openid_identifier']));
        if ($result->isValid()) {
            $status = "You are logged in as "
                    . $auth->getIdentity()
                    . "<br>\n";
        } else {
            $auth->clearIdentity();
            foreach ($result->getMessages() as $message) {
                $status .= "$message<br>\n";
            }
        }
    } else if ($auth->hasIdentity()) {
        if (isset($_POST['openid_action']) &&
            $_POST['openid_action'] == "logout") {
            $auth->clearIdentity();
        } else {
            $status = "You are logged in as "
                    . $auth->getIdentity()
                    . "<br>\n";
        }
    }
    ?>
    <html><body>
    <?php echo htmlspecialchars($status);?>
    <form method="post"><fieldset>
    <legend>OpenID Login</legend>
    <input type="text" name="openid_identifier" value="">
    <input type="submit" name="openid_action" value="login">
    <input type="submit" name="openid_action" value="logout">
    </fieldset></form></body></html>
    */
    

You may customize the OpenID authentication process in several way. You can, for example, receive the redirect from the OpenID server on a separate page, specifying the "root" of web site and using a custom ``Zend_OpenId_Consumer_Storage`` or a custom ``Zend_Controller_Response`` . You may also use the Simple Registration Extension to retrieve information about user from the OpenID server. All of these possibilities are described in more detail in the ``Zend_OpenId_Consumer`` chapter.


.. _`OpenID official site`: http://www.openid.net/
.. _`GMP extension`: http://php.net/gmp
