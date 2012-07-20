.. _zend.auth.adapter.openid:

Authentification OpenID
=======================

.. _zend.auth.adapter.openid.introduction:

Introduction
------------

``Zend_Auth_Adapter_OpenId`` permet l'authentification à travers un serveur distant OpenID. Une telle
authentification attend que l'utilisateur fournisse à l'application Web son identifiant OpenID. L'utilisateur est
alors redirigé vers un fournisseur de services OpenID, afin de s'identifier en rapport avec l'application Web
utilisée. Un mot de passe ou un autre procédé est utilisé, et celui-ci n'est jamais connu de l'application Web
originale.

L'identité OpenID est juste une *URI* qui pointe vers une page avec des informations décrivant le serveur à
utiliser et des informations sur l'utilisateur. Pour plus d'informations, consultez `le site officiel OpenID`_.

La classe ``Zend_Auth_Adapter_OpenId`` utilise ``Zend_OpenId_Consumer`` qui sert à gérer le protocole OpenID.

.. note::

   ``Zend_OpenId`` utilise `l'extension GMP`_, si disponible. L'utilisation de l'extension *GMP* est recommandée
   pour améliorer les performances de ``Zend_Auth_Adapter_OpenId``.

.. _zend.auth.adapter.openid.specifics:

Spécifications
--------------

Comme toute autre classe adaptateur de ``Zend_Auth``, ``Zend_Auth_Adapter_OpenId`` implémente
``Zend_Auth_Adapter_Interface``, qui définit une seule méthode : ``authenticate()``. Elle est utilisée pour
l'authentification elle-même, une fois que l'objet est prêt. La préparation d'un objet OpenID nécessite
quelques options à passer à ``Zend_OpenId``.

A la différence des autres adaptateurs ``Zend_Auth``, l'adaptateur ``Zend_Auth_Adapter_OpenId`` utilise une
authentification sur un serveur externe à l'application, et nécessitera donc deux requêtes *HTTP*. Ainsi
``Zend_Auth_Adapter_OpenId::authenticate()`` devra être appelée deux fois : d'abord pour rediriger l'utilisateur
vers le serveur OpenID (rien ne sera donc retourné par la méthode), qui lui-même redirigera l'utilisateur vers
l'application, où un deuxième appel de méthode ``Zend_Auth_Adapter_OpenId::authenticate()`` vérifiera la
signature et complétera le processus. Un objet ``Zend_Auth_Result`` sera alors cette fois-ci retourné.

L'exemple suivant montre l'utilisation de ``Zend_Auth_Adapter_OpenId``.
``Zend_Auth_Adapter_OpenId::authenticate()`` est appelée deux fois. La première fois juste après avoir envoyé
le formulaire *HTML*, lorsque ``$_POST['openid_action']`` vaut **"login"**, et la deuxième fois après la
redirection *HTTP* du serveur OpenID vers l'application, lorsque ``$_GET['openid_mode']`` ou
``$_POST['openid_mode']`` existe.

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
           $status = "You are logged-in as "
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
           $status = "You are logged-in as "
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

Il est possible de personnaliser le processus, pour par exemple demander une redirection du serveur OpenID vers
l'application, sur une page différente de la première. Ceci peut être fait avec des objets personnalisés
``Zend_OpenId_Consumer_Storage`` ou ``Zend_Controller_Response``. Vous pouvez aussi utiliser le procédé "Simple
Registration" pour récupérer les informations au sujet de l'utilisateur, en provenance du serveur OpenID. Toutes
ces possibilités sont écrites et détaillées dans le chapitre concernant ``Zend_OpenId_Consumer``.



.. _`le site officiel OpenID`: http://www.openid.net/
.. _`l'extension GMP`: http://www.php.net/manual/fr/ref.gmp.php
