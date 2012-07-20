.. _zend.session.basic_usage:

Usage basique
=============

Les instances ``Zend_Session_Namespace`` fournissent l'API primaire pour manipuler les données de session dans
Zend Framework. Les espaces de noms sont utilisés pour isoler toutes les données de session, bien qu'un espace de
noms par défaut existe pour ceux qui veulent juste un endroit pour stocker toutes leurs données de session.
``Zend_Session`` utilise ext/session et sa superglobale spéciale ``$_SESSION`` comme mécanisme de stockage pour
les données d'état de session. Bien que ``$_SESSION`` est toujours disponible dans l'espace global de *PHP*, les
développeurs devraient s'abstenir d'accéder directement à elle, alors que ``Zend_Session`` et
``Zend_Session_Namespace`` fournissent plus efficacement et plus solidement leur suite de fonctionnalités liées
à session.

Chaque instance de ``Zend_Session_Namespace`` correspond à une entrée dans le tableau de la superglobale
``$_SESSION``, où l'espace de noms est utilisée comme une clé.

   .. code-block:: php
      :linenos:

      $monNamespace = new Zend_Session_Namespace('monNamespace');

      // $monNamespace corresponds to $_SESSION['monNamespace']

Il est possible d'utiliser ``Zend_Session`` conjointement avec d'autre code utilisant directement ``$_SESSION``.
Cependant, pour éviter les problèmes, il est fortement recommandé que ce code utilise seulement les parties de
``$_SESSION`` ne correspondant pas aux instances de ``Zend_Session_Namespace``.

.. _zend.session.basic_usage.basic_examples:

Tutoriel d'exemples
-------------------

Si aucun espace de noms n'est spécifié lors de l'instanciation de ``Zend_Session_Namespace``, toutes les données
sont stockées de manière transparente dans un espace de noms appelé "*Default*". ``Zend_Session`` n'est pas
prévu pour fonctionner directement sur le contenu des conteneurs des espaces de noms. Au lieu de cela, nous
utilisons ``Zend_Session_Namespace``. L'exemple ci-dessous montre l'utilisation de cet espace de noms par défaut,
en montrant comment compter le nombre de fois qu'un utilisateur a vu une page sur le site Web. Pour tester cet
exemple, ajouter le code suivant à votre fichier d'amorçage ZF :

.. _zend.session.basic_usage.basic_examples.example.counting_page_views:

.. rubric:: Compter le nombre de pages vues

.. code-block:: php
   :linenos:

   $defaultNamespace = new Zend_Session_Namespace('Default');

   if (isset($defaultNamespace->numberOfPageRequests)) {
       $defaultNamespace->numberOfPageRequests++;
       // ceci s'incrémente à chaque chargement de page.
   } else {
       $defaultNamespace->numberOfPageRequests = 1;
       // première page
   }

   echo "Page demandée lors de cette session : ",
        $defaultNamespace->numberOfPageRequests;

Quand de multiples modules utilisent des instances de ``Zend_Session_Namespace`` ayant différents espaces de noms,
chaque module obtient une encapsulation pour ses propres données de session. Le constructeur de
``Zend_Session_Namespace`` peut recevoir un paramètre facultatif ``$namespace``, qui permet aux développeurs la
partition des données de session dans des espaces de noms séparés. Les espaces de noms fournissent une manière
efficace et populaire de protéger un sous-ensemble de données de session contre un changement accidentel dû à
des collisions de noms.

Les noms des espaces de noms sont limités à des chaînes de caractères *PHP* non-vides qui ne commencent par un
tiret-bas ("*_*"). De plus, seuls les composants coeur de Zend Framework devraient employer un nom d'espace de noms
commençant par "*Zend*".

.. _zend.session.basic_usage.basic_examples.example.namespaces.new:

.. rubric:: Nouvelle méthode : les espaces de noms évitent les collisions

.. code-block:: php
   :linenos:

   // Dans le composant Zend_Auth
   $authNamespace = new Zend_Session_Namespace('Zend_Auth');
   $authNamespace->user = "monusername";

   // Dans un composant service web
   $webServiceNamespace = new Zend_Session_Namespace('Un_Service_Web');
   $webServiceNamespace->user = "monwebusername";

L'exemple ci-dessus réalise la même chose que celui ci-dessous, excepté que les objets de session ci-dessus
préserve l'encapsulation des données de session dans leur espace de noms respectif.

.. _zend.session.basic_usage.basic_examples.example.namespaces.old:

.. rubric:: Ancienne méthode : accès aux sessions PHP

.. code-block:: php
   :linenos:

   $_SESSION['Zend_Auth']['user'] = "monusername";
   $_SESSION['Un_Service_Web']['user'] = "monwebusername";

.. _zend.session.basic_usage.iteration:

Énumérer les espaces de noms de session
---------------------------------------

``Zend_Session_Namespace`` fournit une `interface IteratorAggregate`_ complète, incluant le support de
l'instruction *foreach*:

.. _zend.session.basic_usage.iteration.example:

.. rubric:: Énumération des sessions

.. code-block:: php
   :linenos:

   $unNamespace =
       new Zend_Session_Namespace('un_namespace_avec_des_donnes_presentes');

   foreach ($unNamespace as $index => $valeur) {
       echo "unNamespace->$index = '$valeur';\n";
   }

.. _zend.session.basic_usage.accessors:

Accesseurs pour les espaces de noms de session
----------------------------------------------

``Zend_Session_Namespace`` implémente ``__get()``, ``__set()``, ``__isset()``, et ``__unset()``. `Les méthodes
magiques`_ ne devraient pas être utilisées directement, excepté à l'intérieur d'une sous-classe. Au lieu de
cela, utilisez les opérateurs normaux pour appeler ces méthodes magiques, comme :

.. _zend.session.basic_usage.accessors.example:

.. rubric:: Accéder aux données de session

.. code-block:: php
   :linenos:

   $namespace = new Zend_Session_Namespace();
   // Espace de noms par défaut

   $namespace->foo = 100;

   echo "\$namespace->foo = $namespace->foo\n";

   if (!isset($namespace->bar)) {
       echo "\$namespace->bar n'existe pas\n";
   }

   unset($namespace->foo);



.. _`interface IteratorAggregate`: http://www.php.net/~helly/php/ext/spl/interfaceIteratorAggregate.html
.. _`Les méthodes magiques`: http://www.php.net/manual/fr/language.oop5.overloading.php
