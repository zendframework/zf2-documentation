.. EN-Revision: none
.. _zend.session.global_session_management:

Gestion générale de la session
==============================

Le comportement des sessions peut être modifié en utilisant les méthodes statiques de la classe Zend_Session. Il
s'agit du comportement global des sessions dans toute l'application, incluant la configuration des `options
usuelles offertes par ext/session`_, ceci en utilisant ``Zend_Session::setOptions()``. Ainsi, des problèmes de
sécurité peuvent apparaître si vous utilisez mal le support de stockage des sessions *save_path* ou encore si
vous négligez le cookie utilisé par ext/session.

.. _zend.session.global_session_management.configuration_options:

Options de configuration
------------------------

Lors de la création du premier namespace de session, Zend_Session va automatiquement démarrer la session *PHP*,
sauf si celle-ci a été démarrée avec :ref:`Zend_Session::start()
<zend.session.advanced_usage.starting_a_session>` auparavant. La session *PHP* résultante utilisera les options de
configuration par défaut de Zend_Session, sauf si ceux-ci ont été modifiés à l'aide de
``Zend_Session::setOptions()``.

Pour assigner une option de configuration, passez son nom (la partie qui suit "*session.*" dans les options de
configuration de ext/session) comme clé au tableau passé à ``Zend_Session::setOptions()``. La valeur
correspondante dans le tableau sera alors utilisée comme valeur de l'option. Si vous omettez une option, alors
celles par défaut recommandées par Zend_Session seront utilisées, sinon si elles n'existent pas, les valeurs par
défaut de php.ini. Les retours et les idées quant aux "options recommandées" sont appréciées et peuvent être
envoyées à `fw-auth@lists.zend.com`_.

.. _zend.session.global_session_management.setoptions.example:

.. rubric:: Utiliser Zend_Config pour configurer Zend_Session

Pour configurer le composant en utilisant un objet :ref:`Zend_Config_Ini <zend.config.adapters.ini>`, ajoutez ces
paramètres au fichier *INI* en question:

.. code-block:: ini
   :linenos:

   ; Paramètres de production
   [production]
   ; bug_compat_42
   ; bug_compat_warn
   ; cache_expire
   ; cache_limiter
   ; cookie_domain
   ; cookie_lifetime
   ; cookie_path
   ; cookie_secure
   ; entropy_file
   ; entropy_length
   ; gc_divisor
   ; gc_maxlifetime
   ; gc_probability
   ; hash_bits_per_character
   ; hash_function
   ; name doit être unique pour chaque application partageant le même nom de domaine
   name = UNIQUE_NAME
   ; referer_check
   ; save_handler
   ; save_path
   ; serialize_handler
   ; use_cookies
   ; use_only_cookies
   ; use_trans_sid

   ; remember_me_seconds = <integer seconds>
   ; strict = on|off

   ; Development hérite de production, mais redéfinit certaines valeurs
   [development : production]
   ; N'oubliez pas de créer ce dossier et d'attribuer à PHP les droits 'rwx'.
   save_path = /home/myaccount/zend_sessions/myapp
   use_only_cookies = on
   ; Le cookie de session durera 10 jours
   remember_me_seconds = 864000

Ensuite, chargez ce fichier de configuration, et passez sa représentation tableau à
``Zend_Session::setOptions()``:

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Ini('myapp.ini', 'development');

   require_once 'Zend/Session.php';
   Zend_Session::setOptions($config->toArray());

La plupart des options ne nécessitent pas d'explications étant donné qu'elles font parti des options de
ext/session, documentées dans le manuel officiel de *PHP*, cependant les options particulières méritent une
description:

   - bool *strict*: désactive le démarrage automatique de ``Zend_Session`` lorsque *new Zend_Session_Namespace()*
     est utilisé.

   - int *remember_me_seconds*: temps de vie du cookie de session, une fois le navigateur client fermé.

   - string *save_path*: Cette valeur est dépendante du système sur lequel *PHP* est lancé. Un **chemin absolu**
     vers un dossier lisible et écrivable à *PHP* devrait être utilisé (dans le cas d'utilisation d'un dossier
     pour le support des sessions). Si le chemin n'est pas pleinement accessible à *PHP*, ``Zend_Session`` lancera
     une exception à son démarrage (lorsque ``start()`` est appelée.

     .. note::

        **Attention aux failles de sécurité**

        Si le chemin des sessions est accessible en lecture à d'autres applications, alors le vol de session peut
        être possible. Si le dossier est accessible en écriture à d'autres applications, alors `l'empoisonnement
        de sessions`_ peut être possible. SI le chemin est partagé avec d'autres utilisateurs ou d'autres
        applications *PHP*, plusieurs problèmes de sécurité peuvent apparaître, incluant le vol de session, et
        les collisions de ramasse-miette (garbage collection) (Un process d'une autre application *PHP* déclenche
        une collecte sur vos fichiers de session).

        Par exemple, un pirate peut visiter le site d'une victime pour obtenir un cookie de session. Il modifie
        ensuite le chemin du cookie afin que celui-ci soit envoyé à sa propre application (en partage sur le
        même serveur que le votre), et il exécute ``var_dump($_SESSION)``. Il obtient alors des informations sur
        les variables de session que vous stockez, et il peut les modifier pour retourner sur votre site.
        L'empoisonnement a eu lieu. Même si deux applications sur le même serveur ne partagent pas le même
        dossier *save_path*, si celui-ci est devinable, l'attaquant peut alors l'utiliser sur sa propre application
        et dans certaines configurations de *PHP*, accéder à la session de l'application victime. La valeur du
        *save_path* ne doit pas être rendue publique ou devinable, le dossier doit se trouver dans un endroit
        isolé et sécurisé.

   - string *name*- La valeur doit être choisie de manière **unique** pour chaque application.

     .. note::

        **Risque de sécurité**

        Si la valeur *php.ini* de *session.name* n'est pas unique (celle par défaut "PHPSESSID"), et qu'il existe
        plusieurs applications accessible via le même domaine, alors elle partagerons leurs données pour les
        visiteurs. Aussi, des problème de corruption peuvent apparaître.

   - bool *use_only_cookies*- Afin d'éviter d'autres failles de sécurité (concernant le trans-sid), ne changez
     pas cette option.

        .. note::

           **Risque de sécurité**

           Si cette option n'est pas activée, un attaquant peut facilement fixer un id de session d'une victime en
           lui envoyant des liens tels que *http://www.example.com/index.php?PHPSESSID=fixed_session_id*. La
           fixation fonctionne si la victime n'a pas déjà un identifiant de session sur le site example.com.
           Lorsque la victime utilise un identifiant de session qu'un attaquant connaît, il peut alors se faire
           passer pour elle.





.. _zend.session.global_session_management.headers_sent:

L'erreur: "Headers Already Sent"
--------------------------------

Si vous voyez l'erreur, "Cannot modify header information - headers already sent", ou, "You must call ... before
any output has been sent to the browser; output started in ...", analysez tout de suite d'où vient la fuite grâce
au message d'erreur. Toute action entraînant un envoi d'en-têtes *HTTP*, comme envoyer un cookie, doit être
effectuée avant d'envoyer du contenu standard (non bufferisé), sauf si le buffer de sortie de *PHP* est activé.

- Utiliser `le buffer de sortie`_ résout souvent le problème, et peut améliorer les performances. Par exemple,
  une valeur *php.ini*, "*output_buffering = 65535*" active un buffer de 64K. Même si le buffer de sortie peut
  améliorer les performances lorsqu'il est bien configuré, se reposer sur lui concernant les erreurs "headers
  already sent" n'est pas suffisant. En effet, sa taille peut être dépassé entraînant son vidage, et le
  problème revient.

- Aussi, il convient d'organiser l'application de manière à ce que les envois d'en-tête se passent avant l'envoi
  de contenu.

- Si Zend_Session produit ce message, cherchez la cause grâce au message d'erreur indiquant d'où provient "la
  fuite". Aussi, des opérations comme ``destroy()`` envoient des en-têtes concernant la destruction du cookie de
  session. Si vous ne voulez pas ces informations envoyées, utilisez alors ``destroy(false)``.

- Supprimez tous les balises de fermeture "*?>*", si elles terminent du code *PHP*. Elles sont facultatives et les
  nouvelles lignes blanches éventuelles en fin de fichier ne seront pas envoyées, car parsées par *PHP*.

.. _zend.session.global_session_management.session_identifiers:

Identifiants de session
-----------------------

Les bonnes pratiques d'utilisation des sessions avec Zend Framework passent par un cookie, plutôt que se reporter
à l'URL concernant l'identifiant de session. Par défaut, le composant Zend_Session est bloqué sur l'utilisation
unique du cookie comme moyen de propagation de l'identifiant de session. La session *PHP* va alors utiliser cet
identifiant de manière à identifier de manière unique chaque client (navigateur) qui s'y connecte, et maintenir
un état entre leurs transactions, donnant l'impression de conservation de données. Zend_Session_* utilise alors
le tableau (``$_SESSION``) et vous y donne accès d'une manière objet élégante. Attention, si un attaquant
arrive à accéder au cookie de session d'une victime, il pourra alors tromper le serveur, et se faire passer pour
la victime. Ce comportement n'est pas unique à *PHP*, ni à Zend Framework, mais au Web en général, et au
protocole *HTTP*. La méthode ``regenerateId()`` permet de changer l'identifiant de session stocké dans le cookie
du client, par un autre, en théorie imprévisible. Notez que par la suite, nous confondons les termes 'client' et
'navigateur', même si ceci n'est pas tout à fait juste.

Changer l'identifiant de session permet d'aider contre le vol de données. Si un attaquant possède l'identifiant
d'une victime, le changer ne changera rien pour la victime, mais provoquera une invalidation de la session de
l'attaquant, qui ne connaît alors pas la nouvelle valeur de l'identifiant de session. Non seulement
``regenerateId()`` change l'identifiant de session, mais en plus il migre les données de l'ancien identifiant vers
le nouveau, invalidant totalement l'ancien.

Quand régénérer cet identifiant ? En théorie, mettre ``Zend_Session::regenerateId()`` en bootstrap est la
manière la plus adaptée pour sécuriser une session. Cependant, ceci a un coût non négligeable, car il faut
alors à chaque fois régénérer un identifiant, et renvoyer un nouveau cookie au client. Il est alors nécessaire
de déterminer les situations 'à risque', et régénérer alors l'identifiant de session dans de telles
situations. Ces situations peuvent être par exemple l'authentification d'un client, ou encore son élévation de
privilèges. Si vous appelez ``rememberMe()``, n'appelez alors pas ``regenerateId()``, car elle sera appelée de
manière automatique.

.. _zend.session.global_session_management.session_identifiers.hijacking_and_fixation:

Vol de session et fixation
^^^^^^^^^^^^^^^^^^^^^^^^^^

Éviter `les failles cross-site script (XSS)`_ aide à éviter le vol de session. Selon `Secunia`_, les problèmes
XSS sont fréquents, quelque soit le langage utilisé pour créer l'application Web. Plutôt que de se considérer
invulnérable, considérez votre application de manière à minimiser l'impact d'une éventuelle faille XSS. Avec
XSS, l'attaquant n'a pas besoin d'accéder au trafic de la victime, sur le réseau. Si la victime possède déjà
un cookie de session, javascript peut permettre à l'attaquant de voler celui-ci, et donc la session. Dans le cas
de victimes sans cookie, l'attaquant peut utiliser XSS pour créer un cookie avec un session id connu, et l'envoyer
à la victime, fixant ainsi la session. L'attaquant peut dès lors visualiser toute la session de la victime au fur
et à mesure que celle-ci surfe, sans se rendre compte de rien. Cependant, l'attaquant ne peut modifier l'état de
la session du coté *PHP* ( la fermer par exemple ), sauf si l'application possède d'autres vulnérabilités
(CSRF), ou si le *save_path* est modifiable.

En elle-même, la fonction ``Zend_Session::regenerateId()`` utilisée à la première utilisation de la session, ne
protège pas contre la fixation. Ceci peut paraître contradictoire, mais un attaquant peut très bien initialiser
une session de lui-même, qui sera alors rafraîchie (régénérée), et dont il connaîtra alors l'identifiant. Il
n'aura plus qu'à fixer cet identifiant dans un javascript pour qu'une victime l'utilise, et la faille est à
nouveau présente. Aussi, fixer la session par l'URL est extrêmement simple, mais n'est possible que lorsque
*use_only_cookies = off*.

Le vol de session ne peut se remarqué que si vous arrivez à faire la différence entre l'attaquant et la victime.
Ce n'est pas chose simple, et les techniques utilisées ne sont jamais fiables à 100%. L'IP peut être utilisée,
même si celle-ci n'est pas totalement fiable. Les en-têtes du navigateur Web, eux, le sont déjà plus (lorsque 2
requêtes successives avec le même identifiant de session arrivent au serveur, si l'une prétend être issue de
FireFox et l'autre d'Opéra, alors très probablement qu'il s'agit de 2 personnes différentes, mais ayant le même
identifiant de session. Typiquement : l'attaquant et sa victime.) Il est très difficile de différencier
l'attaquant et la victime, c'est d'ailleurs impossible dans la suite de cas suivants :

   - l'attaquant initialise une session pour obtenir un identifiant valide.

   - l'attaquant utilise une faille XSS pour envoyer un cookie de session à une victime, possédant son propre
     identifiant de session (fixation).

   - l'attaquant et la victime utilisent le même navigateur, sont derrière le même proxy.

Le code suivant permet d'empêcher l'attaquant de connaître l'identifiant de session de la victime (sauf s'il
arrive à le fixer):

.. _zend.session.global_session_management.session_identifiers.hijacking_and_fixation.example:

.. rubric:: Vol et fixation, protections

.. code-block:: php
   :linenos:

   $defaultNamespace = new Zend_Session_Namespace();

   if (!isset($defaultNamespace->initialized)) {
       Zend_Session::regenerateId();
       $defaultNamespace->initialized = true;
   }

.. _zend.session.global_session_management.rememberme:

rememberMe(integer $seconds)
----------------------------

Par défaut, la session se termine lorsque le client ferme son navigateur. Il peut cependant être nécessaire de
faire en sorte que même après la fermeture, le cookie de session persiste un certain temps dans le navigateur.
Utilisez ``Zend_Session::rememberMe()`` avant tout démarrage de la session, afin de spécifier à celle-ci qu'elle
devra utiliser un cookie persistant du coté du client. Ce cookie persistera alors $seconds secondes. Si vous ne
précisez pas de temps, *remember_me_seconds*, sera utilisé. Cette valeur se paramètre d'ailleurs au moyen de
``Zend_Session::setOptions()``.

.. _zend.session.global_session_management.forgetme:

forgetMe()
----------

Cette fonction est analogue à ``rememberMe()`` sauf qu'elle demande au cookie de session du navigateur client
d'être détruit à la fermeture de celui-ci (et non éventuellement après X temps).

.. _zend.session.global_session_management.sessionexists:

sessionExists()
---------------

Utilisez cette méthode afin de savoir si une session existe pour le client (la requête) actuel. Ceci doit être
utilisé avant le démarrage de la session.

.. _zend.session.global_session_management.destroy:

destroy(bool $remove_cookie = true, bool $readonly = true)
----------------------------------------------------------

``Zend_Session::destroy()`` détruit la session et toutes les données la concernant. Cependant, aucune variable
dans *PHP* n'est affectée, donc vos namespaces de session (instances de ``Zend_Session_Namespace``) restent
lisibles. Pour compléter la "déconnexion", laissez le premier paramètre à ``TRUE`` (par défaut), demandant
l'expiration du cookie de session du client. ``$readonly`` permet d'empêcher la future création de namespaces
(new ``Zend_Session_Namespace``) ou des opérations d'écriture via ``Zend_Session``.

Si vous voyez le message d'erreur "Cannot modify header information - headers already sent", alors tentez de ne pas
utiliser ``TRUE`` comme valeur du premier argument (ceci demande l'expiration du cookie de session, ou voyez :ref:`
<zend.session.global_session_management.headers_sent>`. Ainsi, ``Zend_Session::destroy(true)`` doit être appelé
avant tout envoi d'en-tête *HTTP* par *PHP*, ou alors la bufferisation de sortie doit être activée (sans que
celui-ci ne déborde).

.. note::

   **Exception**

   Par défaut, ``$readonly`` est activé et toute opération future d'écriture dans la session lèvera une
   exception.

.. _zend.session.global_session_management.stop:

stop()
------

Cette méthode ne fait rien d'autre que de verrouiller la session en écriture. Tout appel futur d'écriture via
des instances de ``Zend_Session_Namespace`` ou ``Zend_Session`` lèvera une exception.

.. _zend.session.global_session_management.writeclose:

writeClose($readonly = true)
----------------------------

Ferme la session coté serveur, soit enregistre les variables de session dans le support, et détache ``$_SESSION``
de son support de stockage. Le paramètre optionnel ``$readonly`` empêche alors toute future écriture via
``Zend_Session`` ou ``Zend_Session_Namespace``. Ces écritures lèveront une exception.

.. note::

   **Exception**

   Par défaut, ``$readonly`` est activé, et donc tout appel d'écriture futur dans la session générera une
   exception. Certaines applications peuvent nécessiter de conserver un accès en écriture dans ``$_SESSION``,
   même si ce tableau a été déconnecté de son support de stockage avec ``session_write_close()``. Ainsi, Zend
   Framework propose cette option en passant à ``FALSE`` la valeur de ``$readonly``, mais ce n'est pas une
   pratique conseillée.

.. _zend.session.global_session_management.expiresessioncookie:

expireSessionCookie()
---------------------

Cette méthode envoie un cookie d'identifiant de session périmé au client. Quelque fois cette technique est
utilisée pour déconnecter le client de sa session.

.. _zend.session.global_session_management.savehandler:

setSaveHandler(Zend_Session_SaveHandler_Interface $interface)
-------------------------------------------------------------

Cette méthode propose une correspondance orientée objet de `session_set_save_handler()`_.

.. _zend.session.global_session_management.namespaceisset:

namespaceIsset($namespace)
--------------------------

Cette méthode permet de déterminer si un namespace existe dans la session.

.. note::

   **Exception**

   Une exception sera levée si la session n'est pas lisible (n'a pas été démarrée).

.. _zend.session.global_session_management.namespaceunset:

namespaceUnset($namespace)
--------------------------

Utilisez ``Zend_Session::namespaceUnset($namespace)`` pour détruire un namespace entier de la session. Comme pour
les tableaux *PHP*, si le tableau est détruit, les objets à l'intérieur ne le sont pas s'il reste des
références vers eux dans d'autres tableaux ou objets toujours accessibles. Ainsi ``namespaceUnset()`` ne détruit
pas "en profondeur" la variable de session associée au namespace. Voyez `les références en PHP`_ pour plus
d'infos.

.. note::

   **Exception**

   Une exception sera envoyée si le namespace n'est pas écrivable (après un appel à ``destroy()``).

.. _zend.session.global_session_management.namespaceget:

namespaceGet($namespace)
------------------------

Déprécié: Utilisez ``getIterator()`` dans ``Zend_Session_Namespace``. Cette méthode retourne un tableau du
contenu du namespace $namespace. Si vous avez une raison de conserver cette méthode, faites nous part de vos
remarques à `fw-auth@lists.zend.com`_.

.. note::

   **Exception**

   Une exception sera levée si la session n'est pas lisible (n'a pas été démarrée).

.. _zend.session.global_session_management.getiterator:

getIterator()
-------------

``getIterator()`` retourne un *ArrayObject* contenant tous les noms des namespaces de session.

.. note::

   **Exception**

   Une exception sera levée si la session n'est pas lisible (n'a pas été démarrée).



.. _`options usuelles offertes par ext/session`: http://www.php.net/session#session.configuration
.. _`fw-auth@lists.zend.com`: mailto:fw-auth@lists.zend.com
.. _`l'empoisonnement de sessions`: http://en.wikipedia.org/wiki/Session_poisoning
.. _`le buffer de sortie`: http://php.net/outcontrol
.. _`les failles cross-site script (XSS)`: http://en.wikipedia.org/wiki/Cross_site_scripting
.. _`Secunia`: http://secunia.com/
.. _`session_set_save_handler()`: http://php.net/session_set_save_handler
.. _`les références en PHP`: http://php.net/references
