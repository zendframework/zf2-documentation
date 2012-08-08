.. EN-Revision: none
.. _learning.autoloading.intro:

Introduction
============

L'auto-chargement est un mécanisme qui élimine les inclusions de dépendances manuelles au sein du code *PHP*. Le
`manuel sur l'autoload en PHP`_\ précise qu'une fois qu'un autoloader a été défini, "il est appelé
automatiquement dans le cas où l'on tente d'utiliser une classe ou une interface qui n'a pas encore été
définie"

En utilisant l'auto-chargement, vous n'avez pas besoin de vous inquiéter **du lieu** où la classe existe au sein
du projet. Avec des autoloaders bien définis, la résolution du fichier contenant la classe utilisée sera
effectuée de manière transparente.

Aussi, l'autoloader chargeant la classe uniquement lorsque celle-ci est strictement nécessaire, ceci peut avoir
des effets très positifs sur les performances globales -- particulièrement si vous prenez soin de supprimer tous
les appels à ``require_once()`` avant votre déploiement.

Zend Framework encourage l'utilisation de l'auto-chargement et propose différents outils pour charger le code des
librairies comme celui de l'application. Ce tutoriel couvre ces outils et la manière de les utiliser efficacement.



.. _`manuel sur l'autoload en PHP`: http://php.net/autoload
