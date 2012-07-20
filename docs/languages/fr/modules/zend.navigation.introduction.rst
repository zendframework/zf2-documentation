.. _zend.navigation.introduction:

Introduction
============

``Zend_Navigation`` est un composant gérant arbres et menus pour les pages webs. Il permet de créer des menus,
des fils, des liens et des cartographies de sites (sitemaps), ou encore toute autre représentation concernant la
navigation.

.. _zend.navigation.introduction.concepts:

Pages et Conteneurs
-------------------

Deux concepts existent dans ``Zend_Navigation``:

.. _zend.navigation.introduction.pages:

Pages
^^^^^

Une page (``Zend_Navigation_Page``) dans ``Zend_Navigation`` – dans sa forme la plus simple – est un objet
pointant vers une page web. En plus d'un pointeur vers une page web, l'objet page contient d'autres informations
utiles à la navigation comme un *label*, un titre *title*, etc.

Pour plus d'informations sur les pages, lisez :ref:`leur section <zend.navigation.pages>`.

.. _zend.navigation.introduction.containers:

Conteneurs
^^^^^^^^^^

Un conteneur de navigation (``Zend_Navigation_Container``) est une classe contenant des pages. Elle possède des
méthodes pour ajouter, supprimer, récupérer et itrérer au travers de pages. Elle implémente les interfaces de
la `SPL`_ ``RecursiveIterator`` et ``Countable``, et peuvent ainsi être parcourues avec les itérateurs de la SPL
tels que ``RecursiveIteratorIterator``.

Pour plus d'informations sur les conteneurs, lisez :ref:`leur section <zend.navigation.containers>`.

.. note::

   ``Zend_Navigation_Page`` étend ``Zend_Navigation_Container``, ce qui signifie qu'une page peut posséder des
   sous-pages.

.. _zend.navigation.introduction.separation:

Séparation des données (modèle) et du rendu (vue)
-------------------------------------------------

Les classes dans ``Zend_Navigation`` ne s'occupent pas du rendu visuel, celui-ci est effectué par des aides de
vue. Par contre, les pages peuvent contenir des informations utilisées par les aides de vue comme un label
(libellé), une classe *CSS*, un titre, des attributs *lastmod* et *priority* pour les sitemaps, etc.

Pour plus d'informations sur le rendu des éléments, lisez :ref:`leur section
<zend.view.helpers.initial.navigation>`.



.. _`SPL`: http://php.net/spl
