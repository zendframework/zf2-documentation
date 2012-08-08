.. EN-Revision: none
.. _zend.navigation.introduction:

Einführung
==========

``Zend\Navigation`` ist eine Komponente für das Verwalten von Verweisen zu Webseiten. Einfach gesagt: Es kann für
die Erstellung von Menüs, Brotkrümelnavigationen (Breadcrumbs), Dateibeziehungen (Links) und Sitemaps verwendet 
werden, oder es dient als Grundlage für weitere navigationsrelevante Vorhaben.

.. _zend.navigation.introduction.concepts:

Seiten und Container
--------------------

Es gibt zwei grundsätzliche Konzepte in ``Zend\Navigation``:

.. _zend.navigation.introduction.pages:

Seiten
^^^^^^

Eine Seite (``Zend\Navigation\Page\AbstractPage``) ist in ``Zend\Navigation``- in seiner einfachsten Form - 
ein Objekt, das einen Verweis zu einer Webseite enthält. Zusätzlich zum Verweis selbst, enthält das Seitenobjekt 
eine Viezahl von weiteren Eigenschaften die für eine Navigation relevant sind (wie z.B. ``label``, ``title`` usw.).

Lesen Sie mehr darüber im Kapitel :ref:`Seiten <zend.navigation.pages>`.

.. _zend.navigation.introduction.containers:

Container
^^^^^^^^^

Ein Navigationscontainer (``Zend\Navigation\AbstractContainer``) ist eine Containerklasse für Seiten. Diese hat 
Methoden für das Hinzufügen, Empfangen, Löschen und für das Durchlaufen von Seiten. Die Klasse implementiert die 
`SPL`_-Interfaces ``RecursiveIterator`` und ``Countable`` und kann somit mit den SPL-Iteratoren, wie 
``RecursiveIteratorIterator``, durchlaufen werden.

Lesen Sie mehr über Container im Kapitel :ref:`Container <zend.navigation.containers>`.

.. note::

   ``Zend\Navigation\Page\AbstractPage`` erweitert ``Zend\Navigation\AbstractContainer``, was wiederum bedeutet,
   dass eine Seite weitere Unterseiten haben kann.

.. _zend.navigation.introduction.separation:

Trennung von Daten (Model) und Darstellung (View)
-------------------------------------------------

Klassen im Namensraum von ``Zend\Navigation`` handhaben keine Darstellung von Navigationselementen. Die 
Darstellung wird von den Navigations-View-Helfern durchgeführt. Trotzdem enthalten Seiten Informationen die von 
den View-Helfern bei der Darstellung verwendet werden (z.B.: Beschriftung, Klassenname (*CSS*), Titel, die 
Eigenschaften ``lastmod`` und ``priority`` für Sitemaps, usw.).

Lesen Sie mehr über die Darstellung von Navigationselementen im Abschnitt :ref:`Navigations-View-Helfer
<zend.view.helpers.initial.navigation>` des Referenzhandbuches.

.. _`SPL`: http://php.net/spl
