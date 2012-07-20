.. _zend.tool.project.introduction:

Introduction
============

``Zend_Tool_Project`` est construit à partir de ``Zend_Tool_Framework`` permettant ainsi d'étendre ses capacités
et de gérer un projet. En général, un projet est un effort prévu ou une initiative. Dans le monde de
l'informatique, les projets sont généralement une collection de ressources. Ces ressources peuvent être des
fichiers, des répertoires, des bases de données, des schémas, des images, des styles, et parfois plus.

Ce même concept s'applique aux projets Zend Framework. Dans les projets Zend Framework, vous avez des
contrôleurs, des actions, des vues, des modèles, des bases de données et ainsi de suite. En terme de
``Zend_Tool``, nous avons besoin d'un moyen de pister ce type de ressources - c'est-à-dire ``Zend_Tool_Project``.

``Zend_Tool_Project`` est capable de pister les ressources de projet au cours du développement d'un projet. Ainsi,
par exemple, si lors de la première commande vous créez un contrôleur et que lors de la commande suivante vous
souhaitez créer une action à l'intérieur de ce contrôleur, ``Zend_Tool_Project`` doit **connaitre** ce fichier
de contrôleur qui a été créé ainsi vous pouvez (dans l'action suivante), être capable de lui ajouter une
action. C'est ce qui maintient nos projets à jour et **complets**.

Un autre point important à comprendre concernant les projets est que typiquement, les ressources sont organisées
de manière hiérarchique. Avec cela à l'esprit, ``Zend_Tool_Project`` est capable de construire le projet en
cours dans une représentation interne qui lui permet de maintenir non seulement **quelles** ressources de font
partie d'un projet à un moment donné, mais également **où** elles sont les unes par rapport aux autres.


