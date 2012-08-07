.. _requirements:

************************************************
Configuration système requise par Zend Framework
************************************************

.. _requirements.introduction:

Introduction
------------

Zend Framework requière un interpréteur PHP5 avec un serveur Web configuré pour gérer correctement les scripts
PHP. Certaines fonctionnalités requièrent des extensions additionnelles ou des fonctionnalités du serveur Web ;
dans la plupart des cas le framework peut être utilisé sans celle-ci, bien que l'exécution puisse perdre en
performance ou les fonctionnalités auxiliaires peuvent ne pas être entièrement fonctionnelles. Un exemple d'un
telle dépendance est le mod_rewrite d'un environnement Apache, qui peut être utilisé pour implémenter les
"jolies URL" ("pretty URL") comme "http://www.exemple.com/utilisateur/edition". Si le mod_rewrite n'est pas
activé, Zend Framework peut être configuré pour supporter les URL de type
*"http://www.exemple.com?controller=utilisateur&action=edition"*. Les jolies URL peuvent être utilisées pour
réduire la longueur des URLs avec une représentation textuelle ou pour l'optimisation des moteurs de recherche
(SEO), mais il n'affectent pas directement le fonctionnement de l'application.

.. _requirements.version:

Version de PHP requise
^^^^^^^^^^^^^^^^^^^^^^

Zend recommande la version la plus récente de PHP pour des questions de sécurité et de performances, et supporte
actuellement la version 5.2.4 de PHP (ou plus récent).

Zend Framework possède une collection étendue de tests automatisés, que vous pouvez lancer avec PHPUnit 3.3.0 ou
plus.

.. _requirements.extensions:

Extensions PHP
^^^^^^^^^^^^^^

Ci-dessous, la table recense toutes les extensions typiquement trouvées dans PHP et comment elles sont utilisées
dans Zend Framework. Cela peut aider à vous guider pour savoir quelles extensions sont exigées pour votre
application. Cependant toutes les extensions utilisées par Zend Framework ne sont pas exigées pour chaque
application.

Une dépendance de type "forte" indique que le composant ou la classe ne pourra pas fonctionner correctement si
l'extension respective n'est pas disponible, tandis qu'une dépendance de type "faible" indique que le composant
peut utiliser l'extension si elle est disponible mais fonctionnera malgré tout si elle ne l'est pas. Certains
composants utiliseront automatiquement les extensions si elles sont disponibles afin d'optimiser les performances
mais pourront exécuter du code similaire dans le propre code du composant si elles ne le sont pas.

.. include:: requirements.php.extensions.table.rst
.. _requirements.zendcomponents:

Les composants de Zend Framework
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ci-dessous vous trouverez un tableau qui liste tous les composants disponibles de Zend Framework ainsi que les
extensions PHP dont ils ont besoin. Ceci peut vous aider pour connaître les extensions requises pour votre
application. Les extensions par Zend Framework ne sont pas utiles pour toutes les applications.

Une dépendance de type "forte" indique que le composant ou la classe ne pourra pas fonctionner correctement si
l'extension respective n'est pas disponible, tandis qu'une dépendance de type "faible" indique que le composant
peut utiliser l'extension si elle est disponible mais fonctionnera malgré tout si elle ne l'est pas. Certains
composants utiliseront automatiquement les extensions si elles sont disponibles afin d'optimiser les performances
mais pourront exécuter du code similaire dans le propre code du composant si elles ne le sont pas.

.. include:: requirements.zendcomponents.table.rst
.. _requirements.dependencies:

Dépendances internes de Zend Framework
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ci-dessous vous trouverez un tableau listant les composants de Zend Framework ainsi que leurs dépendances envers
les autres composants de Zend Framework. Ceci peut vous aider si vous utilisez un composant seul au lieu de la
bibliothèque complète.

Une dépendance de type "forte" indique que le composant ou la classe ne pourra pas fonctionner correctement si le
composant respectif n'est pas disponible, tandis qu'une dépendance de type "faible" indique que le composant peut
avoir besoin du composant dans certains cas.

.. note::

   Bien qu'il soit possible d'utiliser uniquement certains composants au lieu de Zend Framework complet, vous
   devriez avoir à l'esprit que ceci peut entraîner des problèmes quand des fichiers sont manquants ou que des
   composants sont utilisés dynamiquement.

.. include:: requirements.dependencies.table.rst

