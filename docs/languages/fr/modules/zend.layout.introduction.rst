.. _zend.layout.introduction:

Introduction
============

``Zend_Layout`` utilise le design pattern Two Step View, ce qui permet d'encapsuler le contenu d'une vue dans une
autre, généralement appelée template. D'autres projets les appellent aussi **layouts**, ainsi Zend Framework
utilise ce terme.

Les principales caractéristiques de ``Zend_Layout`` sont :

- Automatiser le rendu des layouts lorsqu'ils sont utilisés avec les composants *MVC* de Zend Framework.

- Fournir un cadre à part entière pour les variables du layout, au même titre que les variables de vue.

- Permettre la configuration du nom des layouts, la recherche des scripts leurs correspondant (inflexion), ainsi
  que leurs chemins d'accès.

- Permettre de désactiver les layouts temporairement, changer leur configuration ; tout ceci depuis les
  contrôleurs ou les scripts de vue.

- Utiliser les mêmes règles de résolution (inflexion) que le :ref:`ViewRenderer
  <zend.controller.actionhelpers.viewrenderer>`, mais sans empêcher de les personnaliser à part.

- Une intégration sous forme d'aides/plugin dans le modèle *MVC* de Zend Framework.


