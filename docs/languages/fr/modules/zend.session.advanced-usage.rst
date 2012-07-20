.. _zend.session.advanced_usage:

Utilisation avancée
===================

Même si les exemples de l'utilisation basique sont une manière parfaitement acceptable d'utiliser les sessions
dans Zend Framework, il existe de bonnes pratiques à considérer. Cette section détaille plus finement le
traitement des sessions et présente des utilisations plus avancées du composant ``Zend_Session``.

.. _zend.session.advanced_usage.starting_a_session:

Démarrer une session
--------------------

Si vous voulez que toutes les requêtes aient une session facilitée avec ``Zend_Session``, alors démarrez la
session dans votre fichier d'amorçage :

.. _zend.session.advanced_usage.starting_a_session.example:

.. rubric:: Démarrer la session globale

.. code-block:: php
   :linenos:

   Zend_Session::start();

En démarrant la session dans votre fichier d'amorçage, vous empêcher la possibilité de démarrer votre session
après l'envoi d'en-têtes à votre navigateur, ce qui entraîne la levée d'une exception, et peut être une page
cassée pour les visiteurs de votre site. Divers usages avancés nécessitent premièrement
``Zend_Session::start()``. (D'autant plus sur les utilisations avancées suivantes.)

Il existe quatre manières différentes pour démarrer une session, quand on utilise ``Zend_Session``. Deux sont
mauvaises.

. Mauvaise : n'activez pas `session.auto_start`_ de PHP. Si vous n'avez pas la possibilité de désactiver ce
  réglage dans le php.ini, ou que vous utilisez mod_php (ou équivalent), et que le réglage est déjà activé
  dans le *php.ini*, alors ajoutez le code suivant à votre fichier *.htaccess* (habituellement votre dossier de
  démarrage HTML) :

     .. code-block:: apache
        :linenos:

        php_value session.auto_start 0



. Mauvaise : n'utilisez pas la fonction `session_start()`_ directement. Si vous utilisez directement
  ``session_start()``, et que vous démarrez en utilisant ``Zend_Session_Namespace``, une exception sera levée par
  ``Zend_Session::start()`` ("session has already been started"). Si vous appelez ``session_start()``, après avoir
  utilisé ``Zend_Session_Namespace`` ou démarré explicitement ``Zend_Session::start()``, une erreur de niveau
  ``E_NOTICE`` sera générée, et l'appel sera ignoré.

. Correcte : utilisez ``Zend_Session::start()``. Si vous voulez que toutes vos requêtes aient et utilisent les
  sessions, alors placez cette fonction le plus tôt possible et sans condition dans votre fichier d'amorçage. Les
  sessions ont un coût. Si certaines requêtes nécessitent les sessions, mais que les autres n'en ont pas besoin,
  alors :

  - Sans conditions, réglez l'option *strict* à ``TRUE`` en utilisant ``Zend_Session::setOptions()`` dans votre
    fichier d'amorçage.

  - Appelez ``Zend_Session::start()``, uniquement pour les requêtes qui nécessitent l'usage des sessions, avant
    la première instanciation d'un objet ``Zend_Session_Namespace()``.

  - Utilisez "*new Zend_Session_Namespace()*" normalement, quand nécessaire, mais faites attention que
    ``Zend_Session::start()`` soit appelée auparavant.

  L'option *strict* empêche *new Zend_Session_Namespace()* d'automatiquement démarrer une session en utilisant
  ``Zend_Session::start()``. Ainsi, cette option aide les développeurs d'application Zend Framework universelles
  à imposer une décision de conception afin d'empêcher l'utilisation de sessions pour certaines requêtes,
  puisqu'une erreur sera levée en utilisant cette option et en instanciant ``Zend_Session_Namespace``, avant un
  appel explicite de ``Zend_Session::start()``. N'employez pas cette option dans le code de la librairie coeur du
  ZF, car seuls les développeurs universels peuvent faire ce choix de design. Les développeurs doivent
  considérer avec précaution l'impact de l'utilisation de ``Zend_Session::setOptions()``, puisque ces options ont
  un effet global, suite à leur correspondance avec les options sous-jacentes pour ext/session.

. Correcte : instanciez simplement ``Zend_Session_Namespace()`` quand nécessaire, la session *PHP* sous-jacente
  sera automatiquement démarrée. Ceci permet un usage extrêmement simple qui fonctionne dans la plupart des cas.
  Cependant, vous êtes responsable de vous assurer que le premier *new Zend_Session_Namespace()* intervient
  **avant** que toute sortie (par exemple `en-têtes HTTP`_) ait été envoyée par *PHP* au client, si vous
  utilisez le réglage par défaut, sessions basées sur les cookies (fortement recommandé). Voir :ref:`
  <zend.session.global_session_management.headers_sent>` pour plus d'informations.

.. _zend.session.advanced_usage.locking:

Verrouiller les espaces de noms de session
------------------------------------------

Les espaces de noms de session peuvent être verrouillés, pour éviter tout risque d'altération des données dans
cet espace. Utilisez ``lock()`` pour attribuer à un espace de nommage spécifique le mode lecture seule,
``unLock()`` pour attribuer le mode lecture / écriture, et ``isLocked()`` pour tester si un espace de nommage a
été auparavant verrouillé. Les verrouillages sont transitoires et ne persistent pas d'une requête à l'autre.
Verrouiller un espace de nommage n'a pas d'effet sur les méthodes de réglages des objets stockés dans cet
espace, mais empêche l'utilisation des méthodes de réglage de l'espace de noms destiné à détruire ou à
remplacer les objets stockés dans l'espace. De la même manière, verrouiller les instances
``Zend_Session_Namespace`` n'empêche pas l'accès direct à l'alias dans tableau de stockage ``$_SESSION`` (voir
`PHP references`_).

.. _zend.session.advanced_usage.locking.example.basic:

.. rubric:: Verrouillage des espaces de noms de session

.. code-block:: php
   :linenos:

   $userProfileNamespace =
       new Zend_Session_Namespace('userProfileNamespace');

   // vérrouillons une session en lecture seule
   $userProfileNamespace->lock();

   // dévérrouillage si déjà vérrouillé
   if ($userProfileNamespace->isLocked()) {
       $userProfileNamespace->unLock();
   }

.. _zend.session.advanced_usage.expiration:

Expiration d'un espace de noms
------------------------------

Des limites peuvent être affectées à la durée de vie soit des espaces de noms soit de clés individuelles dans
cet espace. Les cas d'utilisation habituels incluent le passage d'une information temporaire entre requêtes, et la
diminution de l'exposition à un potentiel risque de sécurité par la suppression de l'accès à des informations
sensibles potentielles à une certaine heure après que l'authentification ait eu lieu. L'expiration peut être
basée sur les secondes écoulées, ou basées sur le concept de "hops", où un "hop" apparaît à chaque requête
successive.

.. _zend.session.advanced_usage.expiration.example:

.. rubric:: Exemple d'expiration

.. code-block:: php
   :linenos:

   $s = new Zend_Session_Namespace('expireAll');
   $s->a = 'apple';
   $s->p = 'pear';
   $s->o = 'orange';

   $s->setExpirationSeconds(5, 'a');
   // expire seulement pour la clé "a" dans 5 secondes

   // expiration de tout l'espace de nommage dans 5 "hops"
   $s->setExpirationHops(5);

   $s->setExpirationSeconds(60);
   // L'espace de noms "expireAll" sera marqué "expired"
   // soit à la première requête reçue après 60 secondes,
   // soit dans 5 hops, en fonction de ce qui arrivera en premier.

Quand vous travaillez avec des données de session expirées dans la requête courante, des précautions doivent
être prises concernant leur utilisation. Bien que les données soient retournées par référence, modifier les
données expirées ne les rendra pas persistantes dans la requête courante. Dans le but de remettre à zéro leur
temps d'expiration, transférez les données dans des variables temporaires, utilisez l'espace de nommage pour les
effacer, et ensuite réaffectez les clés appropriées de nouveau.

.. _zend.session.advanced_usage.controllers:

Encapsulation de session et Contrôleurs
---------------------------------------

Les espaces de noms peuvent aussi être utilisés pour séparer l'accès aux sessions par contrôleur afin de
protéger les variables d'une quelconque contamination. Par exemple, un contrôleur d'authentification pourrait
garder ces données de session séparées de tous les autres contrôleurs pour des raisons de sécurité.

.. _zend.session.advanced_usage.controllers.example:

.. rubric:: Sessions nommées par contrôleur avec expiration automatique

Le code suivant, partie d'un contrôleur destiné à afficher une question dans un test, initie une variable
booléenne pour représenter l'acceptation ou non d'une réponse à la question soumise. Dans ce cas, l'utilisateur
de l'application a 300 secondes pour répondre à la question affichée.

.. code-block:: php
   :linenos:

   $testSpace = new Zend_Session_Namespace('testSpace');
   $testSpace->setExpirationSeconds(300, 'accept_answer');
   // expire seulement cette variable
   $testSpace->accept_answer = true;

Ci-dessous, le contrôleur qui analyse les réponses aux questions du test détermine l'acceptation ou non d'une
réponse en se basant sur le fait que l'utilisateur a répondu dans le temps alloué :

.. code-block:: php
   :linenos:

   // contrôleur analysant la réponse
   $testSpace = new Zend_Session_Namespace('testSpace');
   if ($testSpace->accept_answer === true) {
       // dans le temps autorisé
   }
   else {
       // pas dans le temps autorisé
   }

.. _zend.session.advanced_usage.single_instance:

Limiter les instances multiples par espace de noms
--------------------------------------------------

Bien que :ref:`le verrouillage de session <zend.session.advanced_usage.locking>` fournisse un bon degré de
protection contre l'utilisation inattendue des données dans un espace de noms, ``Zend_Session_Namespace`` offre
aussi la possibilité d'empêcher la création d'instances multiples correspondant à un unique espace de noms.

Pour activer ce comportement, réglez à ``TRUE`` le second argument du constructeur quand vous créez la dernière
instance autorisée de ``Zend_Session_Namespace``. Tout tentative suivante d'instanciation du même espace de noms
entraînera la levée d'une exception.

.. _zend.session.advanced_usage.single_instance.example:

.. rubric:: Limiter l'accès à un espace de noms à une instance unique

.. code-block:: php
   :linenos:

   // créer une instance d'espace
   $authSpaceAccessor1 = new Zend_Session_Namespace('Zend_Auth');

   // créer une autre instance du même espace,
   // mais désactiver toute nouvelle instance
   $authSpaceAccessor2 = new Zend_Session_Namespace('Zend_Auth', true);

   // créer une référence est toujours possible
   $authSpaceAccessor3 = $authSpaceAccessor2;

   $authSpaceAccessor1->foo = 'bar';

   assert($authSpaceAccessor2->foo, 'bar');

   try {
       $aNamespaceObject = new Zend_Session_Namespace('Zend_Auth');
   } catch (Zend_Session_Exception $e) {
       echo "Cannot instantiate this namespace "
          . "since $authSpaceAccessor2 was created\n";
   }

Le second paramètre dans le constructeur ci-dessus informe ``Zend_Session_Namespace`` que toute future instance
avec l'espace de noms "Zend_Auth" sera refusée. Tenter de créer une instance entraînera la levée d'une
exception par le constructeur. Le développeur devient responsable de stocker quelque part une référence à
l'instance de l'objet (``$authSpaceAccessor1``, ``$authSpaceAccessor2``, ou ``$authSpaceAccessor3`` dans l'exemple
ci-dessus), si l'accès à l'espace de noms de session est nécessaire plus tard dans la même requête. Par
exemple, le développeur peut stocker la référence dans une variable statique , ajouter la référence au
`registre`_ (voir :ref:` <zend.registry>`), ou sinon la rendre disponible pour les autres méthodes qui peuvent
avoir accès à cet espace de noms.

.. _zend.session.advanced_usage.arrays:

Travailler avec les tableaux
----------------------------

A cause de l'histoire de l'implémentation des méthodes magiques dans *PHP*, la modification d'un tableau à
l'intérieur d'un espace de noms peut ne pas fonctionner avec les versions de *PHP* inférieures à 5.2.1. Si vous
travaillez exclusivement avec des versions de *PHP* 5.2.1 ou supérieur., alors vous pouvez passer la :ref:`section
suivante <zend.session.advanced_usage.objects>`.

.. _zend.session.advanced_usage.arrays.example.modifying:

.. rubric:: Modifier un tableau de données avec un espace de noms de session

Le code suivant illustre le problème qui peut être reproduit :

.. code-block:: php
   :linenos:

   $sessionNamespace = new Zend_Session_Namespace();
   $sessionNamespace->array = array();
   $sessionNamespace->array['testKey'] = 1;
   // ne fonctionne pas comme attendu avant PHP 5.2.1
   echo $sessionNamespace->array['testKey'];

.. _zend.session.advanced_usage.arrays.example.building_prior:

.. rubric:: Construire les tableaux avant le stockage en session

Si possible, évitez le problème en stockant les tableaux dans un espace de noms de session seulement après que
toutes les clés et les valeurs aient été définies :

.. code-block:: php
   :linenos:

   $sessionNamespace = new Zend_Session_Namespace('Foo');
   $sessionNamespace->array = array('a', 'b', 'c');

Si vous utilisez une version de *PHP* affectée et avez besoin de modifier un tableau après l'avoir assigné à
une clé dans l'espace de noms, vous pouvez utiliser l'une des solutions suivantes :

.. _zend.session.advanced_usage.arrays.example.workaround.reassign:

.. rubric:: Solution : réassigner un tableau modifié

Dans le code suivant, une copie du tableau stocké est créée, modifiée, et réassignée à la place d'où
provenait la copie, en effaçant le tableau original.

.. code-block:: php
   :linenos:

   $sessionNamespace = new Zend_Session_Namespace();

   // assigne le tableau initial
   $sessionNamespace->array = array('fruit' => 'pomme');

   // copie du tableau
   $tmp = $sessionNamespace->array;

   // modification de la copie
   $tmp['fruit'] = 'poire';

   // ré-assignation de la copie dans l'espace de noms
   $sessionNamespace->array = $tmp;

   echo $sessionNamespace->array['fruit']; // affiche "poire"

.. _zend.session.advanced_usage.arrays.example.workaround.reference:

.. rubric:: Solution : stocker un tableau contenant une référence

Autrement, stockez un tableau contenant une référence au tableau désiré, et y accéder indirectement.

.. code-block:: php
   :linenos:

   $myNamespace = new Zend_Session_Namespace('myNamespace');
   $a = array(1, 2, 3);
   $myNamespace->someArray = array( &$a );
   $a['foo'] = 'bar';
   echo $myNamespace->someArray['foo']; // affiche "bar"

.. _zend.session.advanced_usage.objects:

Utiliser les sessions avec des objets
-------------------------------------

Si vous prévoyez de rendre persistant des objets dans les sessions *PHP*, pensez qu'ils peuvent être
`sérialisé`_ pour le stockage. Ainsi, tout objet persistant dans les sessions *PHP* doit être désérialisé
après sa récupération à partir du stockage. L'implication est que le développeur doit s'assurer que les
classes des objets persistants doivent avoir été définies avant que l'objet ne soit désérialisé du stockage.
Si aucune classe n'est définie pour l'objet désérialisé, alors il devient une instance de *stdClass*.

.. _zend.session.advanced_usage.testing:

Utiliser les sessions avec les tests unitaires
----------------------------------------------

Zend Framework s'appuie sur PHPUnit pour faciliter ses propres tests. Beaucoup de développeurs étendent la suite
des tests unitaires pour couvrir le code de leurs applications. L'exception "**Zend_Session is currently marked as
read-only**" (NDT. : "Zend_Session est actuellement marquée en lecture seule") est levée lors de l'exécution des
tests unitaires, si une méthode d'écriture est utilisée après la clôture de la session. Cependant les tests
unitaires employant ``Zend_Session`` requièrent une attention particulière, car la fermeture
(``Zend_Session::writeClose()``), ou la destruction d'une session (``Zend_Session::destroy()``) empêche tout futur
changement ou suppression de clés dans un ``Zend_Session_Namespace``. Ce comportement est un résultat direct du
mécanisme fondamental de l'extension session et des fonctions *PHP* ``session_destroy()`` et
``session_write_close()``, qui n'a pas de mécanisme de marche arrière ("undo") pour faciliter le
réglage/démontage avec les tests unitaires.

Pour contourner ceci, regardez le test unitaire ``testSetExpirationSeconds()`` dans
*tests/Zend/Session/SessionTest.php* et *SessionTestHelper.php*, qui utilise le code *PHP* ``exec()`` pour charger
un processus séparé. Le nouveau processus simule plus précisément une seconde requête successive du
navigateur. Le processus séparé démarre avec une session "propre", comme n'importe quelle exécution de *PHP*
pour une requête Web. Ainsi, tout changement fait à ``$_SESSION`` dans le processus appelant devient disponible
dans le processus enfant, pourvu que le parent ait fermé la session avant d'utiliser ``exec()``.

.. _zend.session.advanced_usage.testing.example:

.. rubric:: Utilisation de PHPUnit pour tester le code écrit avec Zend_Session*

.. code-block:: php
   :linenos:

   // tester setExpirationSeconds()
   require 'tests/Zend/Session/SessionTestHelper.php';
   // voir aussi SessionTest.php dans trunk/
   $script = 'SessionTestHelper.php';
   $s = new Zend_Session_Namespace('espace');
   $s->a = 'abricot';
   $s->o = 'orange';
   $s->setExpirationSeconds(5);

   Zend_Session::regenerateId();
   $id = Zend_Session::getId();
   session_write_close();
   // relâche la session donc le processus suivant peut l'utiliser
   sleep(4); // pas assez long pour les éléments expirent
   exec($script . "expireAll $id expireAll", $result);
   $result = $this->sortResult($result);
   $expect = ';a === abricot;o === orange;p === pear';
   $this->assertTrue($result === $expect,
       "iteration over default Zend_Session namespace failed; "
     . "expecting result === '$expect', but got '$result'");

   sleep(2);
   // assez long pour que les éléments expirent
   // (total de 6 secondes écoulées, avec une expiration de 5)
   exec($script . "expireAll $id expireAll", $result);
   $result = array_pop($result);
   $this->assertTrue($result === '',
       "iteration over default Zend_Session namespace failed; "
     . "expecting result === '', but got '$result')");
   session_start(); // redémarre artificiellement une session suspendue

   // Ceci peut être découpé dans un test séparé, mais en réalité,
   // si quoi que ce soit reste de la partie précédente et contamine
   // les tests suivants, alors c'est un bug dont nous voulons avoir
   // des informations
   $s = new Zend_Session_Namespace('expireGuava');
   $s->setExpirationSeconds(5, 'g');
   // maintenant essayons d'expirer seulement une clé dans l'espace
   $s->g = 'guava';
   $s->p = 'peach';
   $s->p = 'plum';

   session_write_close();
   // relâche la session donc le processus suivant peut l'utiliser
   sleep(6); // pas assez long pour les éléments expirent
   exec($script . "expireAll $id expireGuava", $result);
   $result = $this->sortResult($result);
   session_start(); // redémarre artificiellement la session suspendue
   $this->assertTrue($result === ';p === plum',
       "iteration over named Zend_Session namespace failed (result=$result)");



.. _`session.auto_start`: http://www.php.net/manual/fr/ref.session.php#ini.session.auto-start
.. _`session_start()`: http://www.php.net/session_start
.. _`en-têtes HTTP`: http://www.php.net/headers_sent
.. _`PHP references`: http://www.php.net/references
.. _`registre`: http://www.martinfowler.com/eaaCatalog/registry.html
.. _`sérialisé`: http://www.php.net/manual/fr/language.oop.serialization.php
