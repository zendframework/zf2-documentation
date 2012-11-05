.. EN-Revision: none
.. _learning.autoloading.usage:

Utilisation de base de l'autoloader
===================================

Maintenant que vous savez les buts et le fonctionnement des autoloaders de Zend Framework, voyons comment utiliser
``Zend\Loader\Autoloader``.

Dans le cas le plus simple, vous incluez cette classe et l'instanciez. Comme ``Zend\Loader\Autoloader`` est un
singleton (car l'autoloader de la *SPL* est unique), nous utilisons ``getInstance()`` pour en récupérer
l'instance.

.. code-block:: php
   :linenos:

   require_once 'Zend/Loader/Autoloader.php';
   Zend\Loader\Autoloader::getInstance();

Par défaut, ceci va permettre de charger des classes dont le préfixe est "Zend\_" ou "ZendX\_", si leurs fichiers
sont dans votre ``include_path``.

Que se passe-t-il si vous avez d'autres espaces de noms à charger? Le mieux et le plus simple est alors d'utiliser
la méthode ``registerNamespace()`` de l'instance. Vous pouvez lui passer un préfixe simple, ou un tableau de
préfixes:

.. code-block:: php
   :linenos:

   require_once 'Zend/Loader/Autoloader.php';
   $loader = Zend\Loader\Autoloader::getInstance();
   $loader->registerNamespace('Foo_');
   $loader->registerNamespace(array('Foo_', 'Bar_'));

Aussi, vous pouvez indiquer à ``Zend\Loader\Autoloader`` d'agire comme autoloader par défaut ("de secours"). Ceci
signifie qu'il essayera de charger toute classe peu importe son préfixe.

.. code-block:: php
   :linenos:

   $loader->setFallbackAutoloader(true);

.. warning::

   **N'utilisez pas l'autoloader de secours**

   Ce peut être tentant de se reposer abondamment sur ``Zend\Loader\Autoloader`` comme chargeur de secours, nous
   ne recommandons pas une telle pratique.

   En interne, ``Zend\Loader\Autoloader`` utilise ``Zend\Loader\Loader::loadClass()`` pour charger les classes. Cette
   méthode utilise ``include()`` pour tenter de charger le fichier de la classe. ``include()`` retourne ``FALSE``
   s'il ne réussi pas -- mais renvoie aussi un warning *PHP*. Ce dernier point peut mener à des problèmes:

   - Si ``display_errors`` est activé, le warning sera inclus dans la sortie (l'affichage).

   - Selon le niveau de ``error_reporting``, le warning pourra aussi déclencher l'écriture dans les journaux
     d'évènements.

   Vous pouvez supprimer les messages d'erreur (la documentation de ``Zend\Loader\Autoloader`` détaille cela),
   mais notez bien que la suppression n'est utilisée que lorsque ``display_errors`` est activé; le journal des
   évènements enregistrera toujours l'erreur. Pour ces raisons, nous vous recommandons de bien configurer vos
   espaces de noms avec l'autoloader.

.. note::

   **Préfixes d'espaces de nom et espaces de noms PHP**

   A l'heure de l'écriture de ces lignes, *PHP* 5.3 est sorti. Avec cette version, *PHP* supporte maintenant
   officiellement les espaces de noms.

   Cependant, Zend Framework date d'avant *PHP* 5.3, et donc les espaces de noms PHP. Dans Zend Framework, lorsque
   nous parlons "d'espace de noms", nous parlons d'une pratique consistant à préfixer le nom de la classe par un
   préfixe. Par exemple, toutes les classes de Zend Framework commencent par "Zend\_" -- c'est notre espace de
   noms.

   Zend Framework projette de supporter nativement les espaces de noms *PHP* pour l'autoloader dans les versions
   futures. Il utilisera aussi ce support en interne, à partir de la version 2.0.0.

Si vous possédez votre propre autoloader et que vous voulez l'utiliser avec Zend Framework -- peut être un
autoloader provenant d'une autre librairie que vous utilisez -- vous pouvez l'enregistrer grâce aux méthodes de
``Zend\Loader\Autoloader`` ``pushAutoloader()`` et ``unshiftAutoloader()``. Ces méthodes ajoutent des autoloaders
à la fin ou au début de la chaine utilisée avant l'exécution des mecanismes internes d'auto-chargement de Zend
Framewor. Cette approche a les avantages suivants:

- Chaque méthode prend un deuxième paramètre : un espace de noms qui indique que l'autoloader passé ne doit
  être utilisé que pour charger des classes dans cet espace de noms là. Si la classe n'est pas dans cet espace
  de noms, l'autoloader sera alors ignoré, ce qui peut amener à des optimisations de performance.

- Si vous devez manipuler le registre de ``spl_autoload()``, prenez garde si vous préciser des fonctions de
  rappels sous forme de méthodes de classes car ``spl_autoload_functions()`` ne retourne pas exactement leurs
  définitions. ``Zend\Loader\Autoloader`` ne souffre pas de ce problème.

Voici une liste de définitions de fonctions de rappel pour auto-chargement valides en *PHP*.

.. code-block:: php
   :linenos:

   // Ajoute à la suite de la pile la fonction 'my_autoloader',
   // pour charger des classes commençant par 'My_':
   $loader->pushAutoloader('my_autoloader', 'My_');

   // Ajoute au début de la pile une méthode statique Foo_Loader::autoload(),
   // pour charger des classes commençant par 'Foo_':
   $loader->unshiftAutoloader(array('Foo_Loader', 'autoload'), 'Foo_');


