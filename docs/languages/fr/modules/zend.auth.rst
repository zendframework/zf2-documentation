.. _zend.auth.introduction:

Introduction
============

``Zend_Auth`` fournit une *API* pour l'authentification et inclut des adaptateurs concrets d'authentification pour
les cas les plus courants.

``Zend_Auth`` est uniquement concerné par **le processus d'authentification** et non pas par **le processus
d'autorisation**. L'authentification est définie de manière lâche (souple) afin de déterminer si une entité
donnée est bien celle qu'elle prétend être (c.-à-d. identification), sur la base d'identifiants fournis.
L'autorisation, l'action de décider si une entité donnée peut accéder à d'autres entités et / ou exécuter
des opérations sur celles-ci ne fait pas partie des prérogatives de ``Zend_Auth``. Pour plus d'informations sur
les autorisations et le contrôle d'accès via Zend Framework, voyez :ref:`Zend\Permissions\Acl <zend.permissions.acl>`.

.. note::

   La classe ``Zend_Auth`` inclut un singleton - uniquement une instance de la classe est disponible - à travers
   la méthode statique ``getInstance()``. Celle ci utilise un opérateur **new** et le mot-clé **clone** ne
   fonctionnera pas avec la classe ``Zend_Auth``, utilisez plutôt ``getInstance()``.

.. _zend.auth.introduction.adapters:

Adaptateurs
-----------

Un adaptateur ``Zend_Auth`` est utilisé pour authentifier via un service particulier d'authentification, comme
*LDAP*, *RDBMS* ou un stockage basé sur des fichiers. Les différents adaptateurs peuvent posséder des options et
des comportements très divers. Cependant, quelques méthodes de base leur sont communes. Par exemple, accepter des
éléments d'authentification (incluant une identité prétendue), authentifier et retourner un résultat sont des
éléments communs aux adaptateurs ``Zend_Auth``.

Chaque classe d'adaptateur ``Zend_Auth`` implémente ``Zend_Auth_Adapter_Interface``. Cette interface définit une
méthode, ``authenticate()``, celle-ci est implémentée par une classe adaptateur à fin de réaliser
l'authentification. Chaque classe adaptateur doit être préparée avant tout appel de ``authenticate()``. Cela
implique que chaque adaptateur fournisse la possibilité de définir des éléments d'authentification (par exemple
identifiant et mot de passe) et de définir des valeurs pour les options spécifiques de l'adaptateur, tels que les
paramètres de connexion à une base de données pour un adaptateur qui en fait usage.

L'exemple suivant est un adaptateur d'authentification qui requiert un identifiant et un mot de passe. D'autres
détails, tel que la manière d'interroger le service d'authentification, ont été omis par souci de clarté :

.. code-block:: php
   :linenos:

   class MonAdaptateurAuth implements Zend_Auth_Adapter_Interface
   {
       /**
        * Définition de l'identifiant et du mot de passe
        * pour authentification
        *
        * @return void
        */
       public function __construct($identifiant, $motdepasse)
       {
           // ...
       }

       /**
        * Réalise une tentative d'authentification
        *
        * @throws Zend_Auth_Adapter_Exception Si l'authentification
        *                                     ne peut pas être réalisée
        * @return Zend_Auth_Result
        */
       public function authenticate()
       {
           // ...
       }
   }

Comme indiqué dans la documentation "docblock", ``authenticate()`` doit retourner une instance de
``Zend_Auth_Result`` (ou d'une classe dérivée de ``Zend_Auth_Result``). Si pour quelque raison que ce soit, la
requête d'authentification ne peut pas être réalisée, ``authenticate()`` retournera une exception dérivée de
``Zend_Auth_Adapter_Exception``.

.. _zend.auth.introduction.results:

Résultats
---------

Les adaptateurs ``Zend_Auth`` retournent une instance de ``Zend_Auth_Result`` via ``authenticate()`` de manière à
présenter les résultats d'une tentative d'authentification. Les adaptateurs alimentent l'objet
``Zend_Auth_Result`` lors de sa construction, de manière à ce que les quatre méthodes suivantes fournissent de
base un lot d'opérations communes aux résultats des adaptateurs ``Zend_Auth``\  :

- ``isValid()``\  : retourne ``TRUE`` si et seulement si le résultat représente une tentative réussie
  d'authentification.

- ``getCode()``\  : retourne une constante ``Zend_Auth_Result`` qui détermine le type de retour accepté ou
  refusé (N.D.T. : voir tableau ci dessous). Cela peut être utilisé pour les développeurs voulant distinguer en
  amont les différents types de résultat. Il est possible d'avoir des statistiques détaillées, par exemple. Une
  autre utilisation est la personnalisation du message de retour au client. Attention cependant à ne pas trop
  donner de détails aux clients pour des raisons de sécurité. Pour plus de détails, consultez les notes
  ci-dessous.

- ``getIdentity()``\  : retourne l'identité de la tentative d'authentification.

- ``getMessages()``\  : retourne un tableau de messages relatifs à une tentative infructueuse d'authentification.

Un développeur peut connecter le résultat de l'authentification avec des opérations spécifiques. Certaines
opérations développées peuvent bloquer le compte après plusieurs refus du mot de passe, bannir une adresse IP
après plusieurs essais sur des comptes inexistants ou fournir un message spécifique à l'utilisateur final. Les
codes suivants sont disponibles :

.. code-block:: php
   :linenos:

   Zend_Auth_Result::SUCCESS
   Zend_Auth_Result::FAILURE
   Zend_Auth_Result::FAILURE_IDENTITY_NOT_FOUND
   Zend_Auth_Result::FAILURE_IDENTITY_AMBIGUOUS
   Zend_Auth_Result::FAILURE_CREDENTIAL_INVALID
   Zend_Auth_Result::FAILURE_UNCATEGORIZED

L'exemple suivant illustre comment utiliser le retour :

.. code-block:: php
   :linenos:

   // A l'intérieur de la méthode AuthController / loginAction
   $resultat = $this->_auth->authenticate($adapter);

   switch ($resultat->getCode()) {

       case Zend_Auth_Result::FAILURE_IDENTITY_NOT_FOUND:
           /** l'identifiant n'existe pas **/
           break;

       case Zend_Auth_Result::FAILURE_CREDENTIAL_INVALID:
           /** mauvaise authentification **/
           break;

       case Zend_Auth_Result::SUCCESS:
           /** authentification acceptée **/
           break;

       default:
           /** autres cas **/
           break;
   }

.. _zend.auth.introduction.persistence:

Persistance d'identité
----------------------

Authentifier une requête qui contient des paramètres d'authentification est utile en soi, mais il est également
important de permettre le maintien de l'identité authentifiée sans avoir à représenter ces paramètres
d'authentification à chaque requête.

*HTTP* est un protocole sans état, cependant, des techniques telles que les cookies ou les sessions ont été
développées de manière à faciliter le maintien d'un contexte lors de multiples requêtes dans les applications
Web.

.. _zend.auth.introduction.persistence.default:

Persistance par défaut dans une session PHP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Par défaut, ``Zend_Auth`` fournit un stockage persistant de l'identité, après une authentification réussie, via
les sessions *PHP*. Après une authentification réussie, ``Zend_Auth::authenticate()`` conserve l'identité
résultant de l'authentification dans un stockage persistant. A moins d'une configuration particulière,
``Zend_Auth`` utilise une classe de stockage nommée ``Zend_Auth_Storage_Session``, qui utilise :ref:`Zend_Session
<zend.session>`. Une classe personnalisée peut être utilisée pour fournir un objet implémentant
``Zend_Auth_Storage_Interface`` à ``Zend_Auth::setStorage()``.

.. note::

   Si la persistance automatique de l'identité n'est pas souhaitable dans un cas particulier, alors le
   développeur peut renoncer à utiliser la classe ``Zend_Auth`` et préférer utiliser directement une classe
   adaptateur.

.. _zend.auth.introduction.persistence.default.example:

.. rubric:: Changer l'espace de nommage de la session

``Zend_Auth_Storage_Session`` utilise un espace de nommage de ``Zend_Auth``. Cet espace peut être écrit en
passant les valeurs au constructeur de ``Zend_Auth_Storage_Session``, et ces valeurs sont passées en interne au
constructeur de ``Zend_Session_Namespace``. Cela doit être fait avant l'authentification, et avant que
``Zend_Auth::authenticate()`` ait accompli le stockage automatique de l'identité.

.. code-block:: php
   :linenos:

   // Sauver une référence du singleton, instance de Zend_Auth
   $auth = Zend_Auth::getInstance();

   // Utiliser 'unEspaceDeNommage' instance de 'Zend_Auth'
   $auth->setStorage(new Zend_Auth_Storage_Session('unEspaceDeNommage'));

   /**
    * @todo Paramètrage de l'adaptateur d'authentification :
    *       $authAdaptateur
    */

   // authentification, sauvegarde du résultat
   // et stockage du résultat en cas de succès
   $resultat = $auth->authenticate($authAdaptateur);

.. _zend.auth.introduction.persistence.custom:

Installer un stockage personnalisé
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Parfois les développeurs ont besoin d'utiliser un comportement de persistance d'identité différent de celui
fourni par ``Zend_Auth_Storage_Session``. Dans ces cas, les développeurs implémentent simplement
``Zend_Auth_Storage_Interface`` et fournissent t une instance de la classe à ``Zend_Auth::setStorage()``.

.. _zend.auth.introduction.persistence.custom.example:

.. rubric:: Utiliser une classe de stockage personnalisée

Pour utiliser une classe de stockage d'identité persistante autre que ``Zend_Auth_Storage_Session``, le
développeur commence par implémenter ``Zend_Auth_Storage_Interface``\  :

.. code-block:: php
   :linenos:

   class MonStockage implements Zend_Auth_Storage_Interface
   {
       /**
        * Retourne true si et seulement si le stockage est vide
        *
        * @throws Zend_Auth_Storage_Exception S'il est impossible de déterminer
        *                                     si le stockage est vide
        * @return boolean
        */
       public function isEmpty()
       {
           /**
            * @todo implémentation
            */
       }

       /**
        * Retourne le contenu du stockage
        *
        * Comportement à définir si le stockage est vide.
        *
        * @throws Zend_Auth_Storage_Exception Si la lecture du stockage
        *                                     est impossible
        * @return mixed
        */
       public function read()
       {
           /**
            * @todo implémentation
            */
       }

       /**
        * Ecrit $contents dans le stockage
        *
        * @param  mixed $contents
        * @throws Zend_Auth_Storage_Exception Si l'écriture de $contents
        *                                     est impossible
        * @return void
        */
       public function write($contents)
       {
           /**
            * @todo implementation
            */
       }

       /**
        * RAZ du stockage
        *
        * @throws Zend_Auth_Storage_Exception Si la remise à zéro (RAZ)
        *                                     est impossible
        * @return void
        */
       public function clear()
       {
           /**
            * @todo implementation
            */
       }

   }

Ensuite la classe personnalisée est invoquée, avant la requête d'authentification, avec
``Zend_Auth::setStorage()``\  :

.. code-block:: php
   :linenos:

   // Définit la classe personnalisée à utiliser
   Zend_Auth::getInstance()->setStorage(new MonStockage());

   /**
    * @todo Paramètrage de l'adaptateur d'authentification :
    *       $authAdaptateur
    */

   // Authentification, sauvegarde et
   // persistance du résultat en cas de succès.
   $result = Zend_Auth::getInstance()->authenticate($authAdaptateur);

.. _zend.auth.introduction.using:

Utilisation de Zend_Auth
------------------------

Deux manières d'utiliser les adaptateurs ``Zend_Auth`` sont proposées :

. indirectement, via ``Zend_Auth::authenticate()``\  ;

. directement, via la méthode ``authenticate()`` de l'adaptateur.

L'exemple suivant illustre la manière d'utiliser un adaptateur ``Zend_Auth`` de manière indirecte via
l'utilisation de la classe ``Zend_Auth``\  :

.. code-block:: php
   :linenos:

   // Obtention d'une référence de l'instance du Singleton de Zend_Auth
   $auth = Zend_Auth::getInstance();

   // Définition de l'adaptateur d'authentification
   $authAdaptateur = new MonAdaptateurAuth($identifiant, $motdepasse);

   // Tentative d'authentification et stockage du résultat
   $resultat = $auth->authenticate($authAdaptateur);

   if (!$resultat->isValid()) {
       // Echec de l'authentification ; afficher pourquoi
       foreach ($resultat->getMessages() as $message) {
           echo "$message\n";
       }
   } else {
       // Authentification réussie ; l'identité ($identifiant) est
       // stockée dans la session
       // $resultat->getIdentity() === $auth->getIdentity()
       // $resultat->getIdentity() === $identifiant
   }

Une fois la tentative d'authentification réalisée, tel que montré ci-dessus, il est très simple de vérifier si
une identité correctement authentifiée existe :

.. code-block:: php
   :linenos:

   $auth = Zend_Auth::getInstance();
   if ($auth->hasIdentity()) {
       // l'identité existe ; on la récupère
       $identite = $auth->getIdentity();
   }

Pour retirer une identité du stockage persistant, utilisez simplement la méthode ``clearIdentity()``. A utiliser
typiquement pour implémenter une opération de déconnexion d'une application :

.. code-block:: php
   :linenos:

   Zend_Auth::getInstance()->clearIdentity();

Quand l'utilisation automatique du stockage persistant n'est pas appropriée, le développeur peut simplement
contourner l'utilisation de la classe ``Zend_Auth`` en utilisant directement une classe adaptateur. L'usage direct
d'une classe adaptateur implique de configurer et préparer l'objet adaptateur et d'appeler ensuite sa méthode
``authenticate()``. Les détails spécifiques à un adaptateur sont décrits dans la documentation de chacun
d'entre-eux. L'exemple suivant utilise directement ``MonAdaptateurAuth``\  :

.. code-block:: php
   :linenos:

   // Définition de l'adaptateur d'authentification
   $authAdaptateur = new MonAdaptateurAuth($identifiant, $motdepasse);

   // Tentative d'authentification, stockage du résultat
   $resultat = $authAdaptateur->authenticate();

   if (!$resultat->isValid()) {
       // échec de l'authentification ; afficher pourquoi
       foreach ($resultat->getMessages() as $message) {
           echo "$message\n";
       }
   } else {
       // Authentification réussie
       // $resultat->getIdentity() === $identifiant
   }


