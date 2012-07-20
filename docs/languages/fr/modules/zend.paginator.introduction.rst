.. _zend.paginator.introduction:

Introduction
============

``Zend_Paginator`` est un composant flexible pour paginer des collections de données et présenter ces données
aux utilisateurs.

Les buts principaux de la conception de ``Zend_Paginator`` sont les suivants :

   - paginer des données arbitraires, et pas simplement issues de base de données relationnelle ;

   - récupérer seulement les résultats qu'il est nécessaire d'afficher ;

   - ne pas forcer les utilisateurs à adhérer à une seule manière d'afficher les données ou de retourner les
     contrôles de pagination ;

   - faiblement coupler ``Zend_Paginator`` envers les autres composants de Zend Framework, ainsi les utilisateurs
     qui voudront l'utiliser indépendamment de ``Zend_View``, ``Zend_Db``, etc. pourront le faire.




