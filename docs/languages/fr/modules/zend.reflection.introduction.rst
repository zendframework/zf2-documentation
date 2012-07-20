.. _zend.reflection.introduction:

Introduction
============

``Zend_Reflection`` est un ensemble de fonctionnalités écrites par dessus `l'API Reflection de PHP`_, et propose
un ensemble de nouvelles fonctionnalités :

- Possibilité de récupérer les types de retour des valeurs.

- Possibilité de récupérer les types des paramètres de fonctions.

- Possibilité de récupérer les types des attributs de classes.

- Les blocs de commentaires PHPDoc possèdent aussi une classe de réflexion. Ceci permet de récupérer un bloc
  précis de documentation, notamment son nom, sa valeur et sa description, longue ou courte.

- Les fichiers aussi possèdent leur propre classe de réflexion. Ceci permet l'introspection de fichiers *PHP*
  afin de déterminer les classes et fonctions écrites dans un fichier.

- La possibilité de remplacer n'importe quelle classe de réflexion par la votre propre.

En général, ``Zend_Reflection`` fonctionne de la même manière que l'API Reflection de *PHP*, elle propose par
contre de nouvelles fonctionnalités.



.. _`l'API Reflection de PHP`: http://php.net/reflection
