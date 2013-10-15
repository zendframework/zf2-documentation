.. EN-Revision: none
.. _zend.gdata.clientlogin:

Authentification avec ClientLogin
=================================

Le mécanisme dit "ClientLogin" vous permet d'écrire des applications *PHP* qui récupèrent une authentification
vis à vis des services Google, en spécifiant des identifiants dans le client *HTTP*.

Voyez http://code.google.com/apis/accounts/AuthForInstalledApps.html pour plus d'informations sur
l'authentification ClientLogin de Google Data.

La documentation Google indique que le mécanisme ClientLogin est approprié dans le cas d'applications
embarquées, à la différence du mécanisme AuthSub, utilisé pour les applications Web ayant recours à une
authentification extérieure. AuthSub récupère des identifiant d'un utilisateur de l'application Web, et un
navigateur réagissant aux redirections est requis. Le processus ClientLogin, lui, utilise du code *PHP* tel
qu'écrit dans l'application elle-même. L'utilisateur de l'application n'entre pas en jeu pour fournir des
identifiants de manière interactive.

Les identifiants fournis au mécanisme ClientLogin doivent correspondre à des identifiants valides pour les
services Google, mais il n'est pas nécessaire qu'ils correspondent à ceux de l'utilisateur de l'application.

.. _zend.gdata.clientlogin.login:

Création d'un client HTTP "ClientLogin" authentifié
---------------------------------------------------

La création d'un client *HTTP*"ClientLogin" authentifié est un processus servi par la méthode statique
``ZendGData\ClientLogin::getHttpClient()``. Passez lui les identifiants Google services sous forme de texte (plain
text). La valeur de retour de cette méthode est un objet ``Zend\Http\Client``.

Le troisième paramètre optionnel est le nom du service Google Data. Par exemple, il peut être "cl" pour Google
Calendar. Par défaut il s'agit de "xapi", ce qui correspond au service générique de Google Data.

La quatrième paramètre optionnel est une instance de ``Zend\Http\Client``. Vous pouvez alors configurer votre
client à part (par exemple lui ajouter des options pour la gestion d'un Proxy). Si vous passez ``NULL`` à ce
paramètre, alors un client ``Zend\Http\Client`` générique est crée.

Le cinquième paramètre optionnel est le nom du client que les serveurs Google Data identifieront en interne. Par
défaut il s'agit de "Zend-ZendFramework".

Le sixième paramètre, toujours optionnel, est l'ID pour le challenge CAPTCHA(tm) retourné par le serveur. Ce
paramètre n'est nécessaire que si vous avez reçu un challenge lors d'un processus d'authentification passé, et
que vous le renvoyez pour résolution..

Le septième paramètre optionnel représente la réponse de l'utilisateur au challenge CAPTCHA(tm) précédemment
reçu. Il n'est donc nécessaire que si vous avez reçu un challenge CAPTCHA(tm) à résoudre.

Ci dessous, un exemple d'une application *PHP* qui s'authentifie auprès du service Google Calendar et crée un
objet client ``ZendGData`` utilisant l'objet ``Zend\Http\Client`` fraîchement authentifié :

.. code-block:: php
   :linenos:

   // identifiants de compte Google
   $email = 'johndoe@gmail.com';
   $passwd = 'xxxxxxxx';
   try {
      $client = ZendGData\ClientLogin::getHttpClient($email, $passwd, 'cl');
   } catch (ZendGData\App\CaptchaRequiredException $cre) {
       echo 'l'URL de l\'image CAPTCHA est: ' . $cre->getCaptchaUrl() . "\n";
       echo 'Token ID: ' . $cre->getCaptchaToken() . "\n";
   } catch (ZendGData\App\AuthException $ae) {
      echo 'Problème d'authentification : ' . $ae->exception() . "\n";
   }

   $cal = new ZendGData\Calendar($client);

.. _zend.gdata.clientlogin.terminating:

Fermer un client HTTP authentifié par ClientLogin
-------------------------------------------------

Il n'y a pas de méthode pour supprimer l'authentification effectuée via un ClientLogin, comme c'est le cas avec
le système de jeton du procédé AuthSub. Les identifiants dans le ClientLogin étant un identifiant et un mot de
passe de compte Google, ils ne peuvent être invalidés et sont utilisables de manière continue.



