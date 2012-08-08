.. EN-Revision: none
.. _learning.paginator.intro:

Introduction
============

Imaginons que vous vouliez créer un blog, rempli de billets traitant d'un sujet. Fort probablement, vous
n'afficherez pas tous les billets sur une seule et unique page. La solution est de selectionner une petite partie
des billets et de l'afficher tout en permettant à l'utilisateur de naviguer dans les différentes pages, un peu
comme votre moteur de recherche favori présente ses résultats. ``Zend_Paginator`` est étudié pour répondre à
ce besoin : diviser des collections de données en parties logiques plus petites, le tout facilement et dupliquant
peu de code.

``Zend_Paginator`` utilises des adaptateurs pour gérer les données et fournir les pages disponibles. Nous verrons
dans les sections suivantes comment les manipuler et comment tirer partie du meilleur de ``Zend_Paginator``.

Avant d'aller plus loin, nous allons regarder quelques exemples simples. Puis ensuite, nous examinerons
``Zend_Paginator`` dans des cas réels simples, comme paginer des résultats de base de données.

Cette introduction vous a permis de voir globalement le potentiel de ``Zend_Paginator``. Pour démarrer, voyons
quelques extraits de codes au travers d'exemples.


