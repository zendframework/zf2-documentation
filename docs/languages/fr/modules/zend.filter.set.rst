.. EN-Revision: none
.. _zend.filter.set:

Classes de filtre standards
===========================

Zend Framework est fourni avec un jeu de filtres standards, qui sont directement utilisables.

.. include:: zend.filter.alnum.rst
.. include:: zend.filter.alpha.rst
.. include:: zend.filter.base-name.rst
.. include:: zend.filter.boolean.rst
.. include:: zend.filter.callback.rst
.. include:: zend.filter.compress.rst
.. include:: zend.filter.digits.rst
.. include:: zend.filter.dir.rst
.. include:: zend.filter.html-entities.rst
.. include:: zend.filter.int.rst
.. include:: zend.filter.null.rst
.. include:: zend.filter.preg-replace.rst
.. include:: zend.filter.real-path.rst
.. include:: zend.filter.string-to-lower.rst
.. include:: zend.filter.string-to-upper.rst
.. include:: zend.filter.string-trim.rst
.. _zend.filter.set.stripnewlines:

Int
---

Retourne la valeur ``$value`` en enlevant les caractères représentant une nouvelle ligne.

.. _zend.filter.set.striptags:

StripTags
---------

Ce filtre retourne une chaîne, où toutes les balises HTML et *PHP* sont supprimées, exceptées celles qui sont
explicitement autorisées. En plus de pouvoir spécifier quelles balises sont autorisées, les développeurs
peuvent spécifier quels attributs sont autorisés soit pour toutes les balises autorisées soit pour des balises
spécifiques seulement.


