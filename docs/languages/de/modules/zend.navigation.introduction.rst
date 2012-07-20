.. _zend.navigation.introduction:

Einführung
==========

``Zend_Navigation`` ist eine Komponente für das Verwalten von Pointern zu Webseiten. Einfach gesagt: Es kann für
die Erstellung von Menüs, Breadcrumbs, Links und Sitemaps verwendet werden, oder fungiert als Modell für andere
Navigations-relevanten Vorhaben.

.. _zend.navigation.introduction.concepts:

Seiten und Container
--------------------

Es gibt zwei grundsätzliche Konzepte in ``Zend_Navigation``:

.. _zend.navigation.introduction.pages:

Seiten
^^^^^^

Eine Seite (``Zend_Navigation_Page``) ist in ``Zend_Navigation``- in seiner einfachsten Form - ein Objekt das einen
Pointer zu einer Webseite enthält. Zusätzlich zum Pointer selbst, enthält das Seitenobjekt eine Anzahl von
anderen Eigenschaften die typischerweise für die Navigation relevant sind, wie z.B. ``label``, ``title`` usw.

Lesen Sie mehr darüber im Kapitel :ref:`Seiten <zend.navigation.pages>`.

.. _zend.navigation.introduction.containers:

Container
^^^^^^^^^

Ein Navigations Container (``Zend_Navigation_Container``) ist eine Containerklasse für Seiten. Sie hat Methoden
für das hinzufügen, empfangen, löschen und durchlaufen von Seiten. Sie implementiert die `SPL`_ Interfaces
``RecursiveIterator`` und ``Countable``, und kann deshalb mit SPL Iteratoren wie ``RecursiveIteratorIterator``
durchsucht werden.

Lesen Sie mehr über Container im Kapitel :ref:`Container <zend.navigation.containers>`.

.. note::

   ``Zend_Navigation_Page`` erweitert ``Zend_Navigation_Container``, was bedeutet das eine Seite Unterseiten haben
   kann.

.. _zend.navigation.introduction.separation:

Trennung von Daten (Modell) und Darstellung (View)
--------------------------------------------------

Klassen im ``Zend_Navigation`` Namespace handhaben keine Darstellung von Navigationselementen. Die Darstellung wird
von den Navigations View Helfern durchgeführt. Trotzdem enthalten Seiten Informationen die von den View Helfern
bei der Darstellung verwendet wird wie z.B.: Label, *CSS* Klasse, Titel, ``lastmod`` und ``priority`` Eigenschaften
für Sitemaps, usw.

Lesen Sie mehr über die Darstellung von Navigationselementen im Kapitel :ref:`Navigations Helfer
<zend.view.helpers.initial.navigation>` des Handbuchs.



.. _`SPL`: http://php.net/spl
