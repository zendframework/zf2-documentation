.. EN-Revision: none
.. _zend.authentication.adapter.http:

Adaptateur d'authentification HTTP
==================================

.. _zend.authentication.adapter.http.introduction:

Introduction
------------

``Zend\Auth_Adapter\Http`` fournit une implémentation des authentifications *HTTP* `Basic`_\ et `Digest`_, au
regard de la norme `RFC-2617`_. Digest est une méthode d'authentification *HTTP* basée sur Basic, mais qui
augmente la sécurité en fournissant un moyen d'authentification sans transmettre le mot de passe en clair, sur le
réseau.

**Caractéristiques principales :**

- Support des méthodes Basic et Digest ;

- Propose tous les des schémas de challenge, le client peut répondre avec le schéma qu'il supporte ;

- Support de l'authentification Proxy ;

- Inclus le support d'authentification de type fichier, et fournit une interface pour créer son propre support,
  comme une base de données.

Il y a quelques caractéristiques de la *RFC-2617* qui ne sont pas encore supportées :

- Le "Nonce tracking", mécanisme qui évite les attaques par répétitions ;

- Authentification avec vérification d'intégrité ("auth-int") ;

- En-tête *HTTP*"Authentication-Info".

.. _zend.authentication.adapter.design_overview:

Fonctionnement
--------------

Cette adaptateur utilise 2 sous-composants, la classe d'authentification *HTTP* elle-même et des "Résolveurs." La
classe d'authentification *HTTP* encapsule la logique de commande des authentifications Basic et Digest. Elle
utilise aussi un résolveur pour chercher les identifiants sur un disque (fichier texte par défaut), et les
analyser. Ils sont alors comparés aux valeurs envoyées par le client pour déterminer une éventuelle
correspondance.

.. _zend.authentication.adapter.configuration_options:

Options de configuration
------------------------

La classe ``Zend\Auth_Adapter\Http`` requière un tableau de configuration lors de sa construction. Il y a
plusieurs options de configuration disponibles, dont certaines requises :

.. _zend.authentication.adapter.configuration_options.table:

.. table:: Liste des options de configuration

   +--------------+--------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Nom           |Requise (?)                                 |Description                                                                                                                                                         |
   +==============+============================================+====================================================================================================================================================================+
   |accept_schemes|Oui                                         |Détermine les schémas d'authentification que l'adaptateur va accepter du client. Ce doit être une liste séparée par des espaces, contenant 'basic' et / ou 'digest'.|
   +--------------+--------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |realm         |Oui                                         |Fournit le nom de l'authentification ("realm") ; chaque nom d'utilisateur doit être unique, par nom d'authentification.                                             |
   +--------------+--------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |digest_domains|Oui lorsque accept_schemes contient "digest"|Liste d'URI, séparées d'espace, pour lesquelles la même information d'authentification est valide. Les URI peuvent pointer vers différents serveurs.                |
   +--------------+--------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |nonce_timeout |Oui lorsque accept_schemes contient "digest"|Nombre de seconde pour la validité du jeton d'authentification. Voyez les notes ci-dessous.                                                                         |
   +--------------+--------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |proxy_auth    |Non                                         |Désactivé par défaut. Activez le pour effectuer une authentification via un Proxy.                                                                                  |
   +--------------+--------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. note::

   L'implémentation actuelle du ``nonce_timeout`` a des effets intéressants. Ce paramètre doit déterminer le
   temps de validité d'un jeton, autrement dit : le temps d'acceptation d'un client. Par exemple, une valeur de
   3600 aura pour effet de commander à l'adaptateur le rappel des informations d'identification du client, toutes
   les heures. Ce comportement sera changé lorsque le paramètre "nonce tracking" sera supporté.

.. _zend.authentication.adapter.http.resolvers:

Résolveurs
----------

Le travail du résolveur consiste à récupérer un nom d'utilisateur ("username") et un nom d'authentification
("realm") et retourner des identifiants. L'authentification Basic s'attend à recevoir une version encodée Base64
du mot de passe ("password"). L'authentification Digest, elle, attend un hash du "username", du "realm", et du
"password" (séparés par des deux-points). Actuellement le seul algorithme de hash supporté est *MD5*.

``Zend\Auth_Adapter\Http`` se fie a des objets implémentant ``Zend\Auth\Adapter\Http\Resolver\Interface``. Une
classe de résolution de fichier texte est inclue avec cet adaptateur, mais n'importe quelle classe peut être
écrite, grâce à l'interface.

.. _zend.authentication.adapter.http.resolvers.file:

Résolveur fichiers
^^^^^^^^^^^^^^^^^^

Cette classe est très simple. Son constructeur ne prend qu'un paramètre qui définit le nom du fichier cible. Un
accesseur existe aussi. Sa méthode ``resolve()`` traverse le fichier texte à la recherche de la ligne qui
correspond au "username" et au "realm". La syntaxe est similaire aux fichiers htpasswd d'Apache :

.. code-block:: text
   :linenos:

       <username>:<realm>:<credentials>\n

Chaque ligne se décompose en 3 champs - "username", "realm", et "credentials" - séparés par des deux-points. Le
résolveur ne fait que retourner la valeur de "credentials". Ainsi, avec Basic cette valeur devra être le mot de
passe en clair de l'utilisateur identifié par "username". En mode Digest, la valeur *MD5* de toute la chaîne
"username:realm:password" (avec les deux-points).

Pour créer des résolveurs de fichiers séparés, utilisez :

.. code-block:: php
   :linenos:

   $path     = 'files/passwd.txt';
   $resolver = new Zend\Auth\Adapter\Http\Resolver\File($path);

ou

.. code-block:: php
   :linenos:

   $path     = 'files/passwd.txt';
   $resolver = new Zend\Auth\Adapter\Http\Resolver\File();
   $resolver->setFile($path);

Si le chemin donné n'est pas lisible, une exception est envoyée.

.. _zend.authentication.adapter.http.basic_usage:

Usage général :
---------------

Tout d'abord, créez un tableau de configuration avec les options requises :

.. code-block:: php
   :linenos:

   $config = array(
       'accept_schemes' => 'basic digest',
       'realm'          => 'My Web Site',
       'digest_domains' => '/members_only /my_account',
       'nonce_timeout'  => 3600,
   );

Ce tableau va permettre d'accepter les modes Basic ou Digest et demandera une authentification pour les zones du
site situées sous ``/members_only`` et ``/my_account``. La valeur du "real" est en général affichée par le
navigateur dans la boite de dialogue. Le paramètre ``nonce_timeout``, fonctionne comme expliqué plus haut.

Ensuite, créez un objet de ``Zend\Auth_Adapter\Http``\  :

.. code-block:: php
   :linenos:

   $adapter = new Zend\Auth_Adapter\Http($config);

Comme nous supportons les 2 modes Basic et Digest, nous avons besoin de deux résolveurs différents :

.. code-block:: php
   :linenos:

   $basicResolver = new Zend\Auth\Adapter\Http\Resolver\File();
   $basicResolver->setFile('files/basicPasswd.txt');

   $digestResolver = new Zend\Auth\Adapter\Http\Resolver\File();
   $digestResolver->setFile('files/digestPasswd.txt');

   $adapter->setBasicResolver($basicResolver);
   $adapter->setDigestResolver($digestResolver);

Enfin, nous procédons à la demande d'authentification. L'adaptateur a besoin de deux objets "Request" et
"Response" :

.. code-block:: php
   :linenos:

   assert($request instanceof Zend\Controller_Request\Http);
   assert($response instanceof Zend\Controller_Response\Http);

   $adapter->setRequest($request);
   $adapter->setResponse($response);

   $result = $adapter->authenticate();
   if (!$result->isValid()) {
       // Mauvais username/password, ou action annulée
   }



.. _`Basic`: http://en.wikipedia.org/wiki/Basic_authentication_scheme
.. _`Digest`: http://en.wikipedia.org/wiki/Digest_access_authentication
.. _`RFC-2617`: http://tools.ietf.org/html/rfc2617
