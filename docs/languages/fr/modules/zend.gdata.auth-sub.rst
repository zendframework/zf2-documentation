.. EN-Revision: none
.. _zend.gdata.authsub:

Authentification par procédé AuthSub
====================================

Le mécanisme d'authentification AuthSub permet d'écrire des applications dans lesquelles il n'est pas nécessaire
de coder "en dur" des identifiants. L'application demande ces informations à l'utilisateur, pour ouvrir un session
de travail.

Voyez `http://code.google.com/apis/accounts/AuthForWebApps.html`_ pour plus d'informations sur l'authentification
AuthSub de Google Data.

La documentation Google indique que le mécanisme ClientLogin est approprié dans le cas d'applications
embarquées, à la différence du mécanisme AuthSub, utilisé pour les applications Web ayant recours à une
authentification extérieure. AuthSub récupère des identifiant d'un utilisateur de l'application Web, et un
navigateur réagissant aux redirections est requis. Le processus ClientLogin, lui, utilise du code *PHP* tel
qu'écrit dans l'application elle-même. L'utilisateur de l'application n'entre pas en jeu pour fournir des
identifiants de manière interactive.

Les identifiants utilisés par le processus AuthSub sont fournis par l'utilisateur de l'application, et non par
l'application elle-même.

.. note::

   **Jetons sécurisés et certificats**

   ``Zend_Gdata`` ne supporte pas actuellement l'utilisation de jetons sécurisés, car l'authentification AuthSub
   ne supporte pas les certificats permettant l'obtention de jetons sécurisés.

.. _zend.gdata.authsub.login:

Création d'un client HTTP authentifié avec AuthSub
--------------------------------------------------

Votre application *PHP* devrait fournir un lien *URL* vers le service d'authentification de Google. La méthode
statique ``Zend_Gdata_AuthSub::getAuthSubTokenUri()`` permet ceci. Elle prend un argument représentant l'URL de
votre application. De cette manière, le serveur Google pourra générer une réponse menant à une redirection
vers cette *URL*, une fois l'authentification passée.

Après que le serveur d'authentification de Google ait redirigé le navigateur de l'utilisateur vers votre
application, un paramètre ``GET`` est ajouté, il s'agit du *jeton* d'authentification. Ce jeton servira à
éviter de demander une authentification à chaque requête future.

Ensuite, utilisez le jeton avec un appel à la méthode ``Zend_Gdata_AuthSub::getHttpClient()``. Cette méthode
retournera alors un objet de type ``Zend_Http_Client``, qui sera peuplé des bons en-têtes permettant ainsi une
utilisation future sans nécessité de ré-authentification.

Ci-dessous un exemple d'une application *PHP* qui effectue une authentification afin d'utiliser le service Google
Calendar. Elle crée un objet client ``Zend_Gdata`` utilisant le client *HTTP* fraîchement authentifié.

.. code-block:: php
   :linenos:

   $my_calendar =
       'http://www.google.com/calendar/feeds/default/private/full';

   if (!isset($_SESSION['cal_token'])) {
       if (isset($_GET['token'])) {
           // Vous pouvez convertir le jeton unique en jeton de session.
           $session_token =
               Zend_Gdata_AuthSub::getAuthSubSessionToken($_GET['token']);
           // Enregistre le jeton de session, dans la session PHP.
           $_SESSION['cal_token'] = $session_token;
       } else {
           // Affiche le lien permettant la génération du jeton unique.
           $googleUri = Zend_Gdata_AuthSub::getAuthSubTokenUri(
               'http://'. $_SERVER['SERVER_NAME'] . $_SERVER['REQUEST_URI'],
               $my_calendar, 0, 1);
           echo "Cliquez <a href='$googleUri'>ici</a>"
              . " pour autoriser votre application.";
           exit();
       }
   }

   // Création d'un client HTTP authentifié
   // pour les échanges avec les serveurs Google.
   $client = Zend_Gdata_AuthSub::getHttpClient($_SESSION['cal_token']);

   // Création d'un objet Gdata utilisant le client HTTP authentifié :
   $cal = new Zend_Gdata_Calendar($client);

.. _zend.gdata.authsub.logout:

Destruction de l'authentification AuthSub
-----------------------------------------

Pour détruire la validité d'un jeton d'authentification, utilisez la méthode statique
``Zend_Gdata_AuthSub::AuthSubRevokeToken()``. Autrement, le jeton reste valide un certain temps.

.. code-block:: php
   :linenos:

   // construction sécurisée de la valeur.
   $php_self = htmlentities(substr($_SERVER['PHP_SELF'],
                                   0,
                                   strcspn($_SERVER['PHP_SELF'], "\n\r")),
                            ENT_QUOTES);

   if (isset($_GET['logout'])) {
       Zend_Gdata_AuthSub::AuthSubRevokeToken($_SESSION['cal_token']);
       unset($_SESSION['cal_token']);
       header('Location: ' . $php_self);
       exit();
   }

.. note::

   **Notes de sécurité**

   Le traitement effectué pour la variable ``$php_self`` dans l'exemple ci-dessus est une règle de sécurité
   générale, elle n'est pas spécifique à l'utilisation de ``Zend_Gdata``. Vous devriez systématiquement
   filtrer le contenu que vous envoyez en tant qu'en-tête *HTTP*.

   Au sujet de la destruction du jeton, elle est recommandée lorsque l'utilisateur en a terminé avec sa session
   Google. Même si la possibilité d'interception de ce jeton reste très faible, il s'agit d'une précaution
   faisant partie du bon sens et des bonnes pratiques.



.. _`http://code.google.com/apis/accounts/AuthForWebApps.html`: http://code.google.com/apis/accounts/AuthForWebApps.html
