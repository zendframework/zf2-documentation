.. EN-Revision: none
.. _learning.autoloading.design:

Architecture et buts
====================

.. _learning.autoloading.design.naming:

Convention de noms des classes
------------------------------

Pour comprendre l'autochargement dans le Zend Framework, vous devez d'abord comprendre la relation entre nom de
classe et nom de fichier.

Zend Framework a emprunté une idée de `PEAR`_, dans lequel les noms des classes ont une relation 1:1 avec le
système de fichiers. Simplement, le caractère underscore ("\_") est remplacé par un séparateur de dossier pour
résoudre le chemin vers le fichier, puis le suffixe "``.php``" est ajouté. Par exemple, une classe
"``Foo_Bar_Baz``" va correspondre à "``Foo/Bar/Baz.php``" sur le système de fichiers. La supposition est alors
que *PHP* résoudra les fichier relativement à l'``include_path`` ce qui permet d'utiliser ``include()`` et
``require()`` pour chercher le fichier relativement à l'``include_path``.

Aussi, conformément à *PEAR* et au `PHP project`_, nous utilisons et vous recommandons d'utiliser un préfixe à
votre code. Cela signifie que toutes les classes que vous écrivez doivent partager un préfixe unique, par
exemple, dans Zend Framework le préfixe est "Zend\_". Cette convention de noms évite toute collision dans les
noms des classes. Dans Zend Framework, nous utilisons la notion "d'espace de noms" ("namespace"); attention à
éviter la confusion avec l'implémentation native des espaces de noms de *PHP*.

Zend Framework suit ces règles simples en interne et nos standards de code vous encouragent à faire de même avec
le code de vos propres librairies.

.. _learning.autoloading.design.autoloader:

Conventions et architecture d'Autoload
--------------------------------------

Le support de l'autochargement (autoload) de Zend Framework, implémenté grâce à ``Zend\Loader\Autoloader``,
possède l'architecture et les buts suivants:

- **Correspondance d'espace de noms**. Si l'espace de noms de la classe (son préfixe) n'est pas dans une liste
  pré-enregistrée, retourner ``FALSE`` immédiatement. Ceci permet une optimisation de la recherche ainsi que
  l'utilisation d'autres autoloaders ou d'un autoloader global par défaut.

- **Permettre un auto-chargement "de secours"**. Dans le cas où l'on ne peut lister ou prédéterminer les
  préfixes de manière claire et sûre, l'autoloader doit pouvoir être configuré pour charger n'importe quel
  espace de noms de classes. Notez que ce cas n'est pas recommandé car il fait intervenir des algorithmes
  complexes et non optimisés.

- **Permettre la non-suppression des erreurs**. Nous pensons -- et la plus grande partie de la communauté *PHP*
  aussi -- que la suppression des erreurs est une mauvaise idée. C'est couteux en ressources et cela masque les
  problèmes réels de l'application. Ainsi, par défaut, la suppression des erreurs devrait être désactivée.
  Cependant, si un développeur **insiste** pour l'activer, nous le permettons.

- **Autoriser l'utilisation de fonctions d'autoload personnalisées**. Certaines personnes ne veulent pas utiliser
  ``Zend\Loader\Loader::loadClass()`` pour l'autoload, mais veulent tout de même bénéficier des mécanismes du Zend
  Framework. ``Zend\Loader\Autoloader`` permet de préciser ses propres fonctions d'auto-chargement.

- **Permettre la manipulation de la chaine des autoloads de la SPL**. Ceci autorise la spécification d'autoloaders
  additionnels -- par exemple les chargeurs de ressources pour les classes n'ayant pas une correspondance 1:1 avec
  le système de fichiers -- ces autoloaders pouvant être chargés avant ou après l'autoloader principal de Zend
  Framework.



.. _`PEAR`: http://pear.php.net/
.. _`PHP project`: http://php.net/userlandnaming.tips
