.. _learning.plugins.intro:

Introduction
============

Zend Framework utilise abondamment la notion de plugin. Les plugins permettent à la fois l'extensibilité mais
aussi la personnalisation du framework tout en gardant votre code séparé de celui de Zend Framework.

Typiquement, les plugins dans Zend Framework fonctionnent comme suit:

- Les plugins sont des classes dont la définition va varier en fonction du composant considéré. Par exemple vous
  aurez soit besoin d'implémenter une interface, soit d'étendre une classe très souvent abstraite. Un plugin est
  donc une classe.

- Les plugins relatifs aux même fonctionnalités vont partager un préfixe de classe. Par exemple, si vous avez
  crée des aides de vue, il se peut que celle-ci partagent le préfixe "``Foo_View_Helper_``".

- Tout ce qui suit le préfixe est appelé **nom du plugin** ou **nom court** (contrairement au "nom long", qui
  représente le nom de la classe complet). Par exemple, si le préfixe du plugin est "``Foo_View_Helper_``", et le
  nom de la classe "``Foo_View_Helper_Bar``", le nom du plugin est "``Bar``".

- Les noms de plugins sont sensibles à la casse à l'exception de la première lettre qui peut être soit en
  majuscules soit en minuscules. Dans nos exemples, nous aurions pu utiliser "bar" ou "Bar" de manière
  équivalente.

Voyons maintenant comment utiliser des plugins.


