.. _user-guide.conclusion:

Conclusion
==========

Ceci conclut notre bref exemple de création d'une application MVC, simple mais
fonctionnelle, à l'aide de Zend Framework 2.

Dans ce tutoriel, nous avons pu rapidement voir différentes facettes du framework.

Les parties les plus importantes d'une application basée sur Zend Framework 2
sont les :ref:`modules <zend.module-manager.intro>`, le socle de toute 
:ref:`application MVC ZF2 <zend.mvc.intro>`.

Pour faciliter les dépendances au sein de notre application, nous avons
utilisé le :ref:`service manager <zend.service-manager.intro>`.

Afin de mapper une requête aux contrôleurs et à leurs actions respectives, 
nous avons utilisé les :ref:`routes <zend.mvc.routing>`.

La persistence des données, dans la plupart des cas, induit l'utilisation de 
:ref:`Zend\\Db <zend.db.adapter>` pour communiquer avec une base de données.
La saisie des données est filtrée et validée avec les :ref:`filtres <zend.input-filter.intro>`.
Ensemble, avec :ref:`Zend\\Form <zend.form.intro>`, ils offrent une passerelle
robuste entre le modèle de données et la vue.

:ref:`Zend\\View <zend.view.quick-start>` est quant à lui responsable de
la vue dans la pile MVC, en corrélation avec les :ref:`aides de vue <zend.view.helpers>`.
