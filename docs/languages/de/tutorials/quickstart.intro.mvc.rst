.. EN-Revision: none
.. _learning.quickstart.intro:

Zend Framework & MVC Einführung
===============================

.. _learning.quickstart.intro.zf:

Zend Framework
--------------

Zend Framework ist ein Open Source, objektorientierter Web Anwendungs Framework für *PHP* 5. Zend Framework wird
oft eine "Komponentenbibliothek" genannt, weil er viele lose verbundene Komponenten hat die man mehr oder weniger
unabhängig verwenden kann. Aber Zend Framework bietet auch eine fortgeschrittene Model-View-Controller (*MVC*)
Implementation die verwendet werden kann um eine Basisstruktur für eigene Zend Framework Anwendungen zu sein. Eine
komplette Liste der Komponenten des Zend Frameworks mit einer kurzen Beschreibung kann in der `Komponenten
Übersicht`_ gefunden werden. Dieser Schnellstart zeigt einige der am meisten verwendeten Komponenten vom Zend
Framework, inklusive ``Zend_Controller``, ``Zend_Layout``, ``Zend_Config``, ``Zend_Db``, ``Zend_Db_Table``,
``Zend_Registry``, zusammen mit ein paar View Helfern.

Durch Verwendung dieser Komponenten bauen wir eine einfache Datenbank-gesteuerte Guest Book Anwendung in wenigen
Minuten. Der komplette Quellcode für diese Anwendung ist in den folgenden Archiven vorhanden:

- `zip`_

- `tar.gz`_

.. _learning.quickstart.intro.mvc:

Model-View-Controller
---------------------

Was also ist dieses *MVC* Pattern über das alle Welt redet, und warum sollte es verwendet werden? *MVC* ist viel
mehr als nur ein drei-wortiges Acronym (*TLA*) das man erwähnen kann wann immer man smart erscheinen will; es ist
so etwas wie ein Standard bei der Erstellung von modernen Web Anwendungen. Und das aus gutem Grund. Der Code der
meisten Web Anwendungen fällt in einer der folgenden drei Kategorien: Präsentation, Business Logik, und
Datenzugriff. Das *MVC* Pattern modelliert diese Trennung bereits sehr gut. Das Endergebnis ist, das der
Präsentationscode in einem Teil der Anwendung konsolidiert werden kann, die Business Logik in einem anderen Teil
und der Code für den Datenzugriff wieder in einem anderen. Viele Entwickler finden diese gut definierte Trennung
unentbehrlich um deren Code organisiert zu halten, speziell wenn mehr als ein Entwickler an der gleichen Anwendung
arbeitet.

.. note::

   **Mehr Informationen**

   Brechen wir das Pattern auf und schauen wir uns die individuellen Teile an:

   .. image:: ../images/learning.quickstart.intro.mvc.png
      :width: 321
      :align: center

   - **Modell**- Dieser Teil der eigenen Anwendung definiert die grundsätzliche Funktionalität in einem Set von
     Abstraktionen. Datenzugriffs Routinen und etwas Business Logik kann im Model definiert sein.

   - **View**- Views definieren was exakt dem Benutzer präsentiert wird. Normalerweise übergeben Controller Daten
     in jede View damit Sie in einem Format dargestellt werden. Views sammeln auch oft Daten vom Benutzer. Dort
     findet man üblicherweise *HTML* Markup in der eigenen *MVC* Anwendung.

   - **Controller**- Controller verbinden das komplette Pattern. Sie manipulieren Modelle, entscheiden welche View,
     basieren auf der Benutzeranfrage und anderen Faktoren, angezeigt werden soll übergeben die Daten welche jede
     View benötigt, oder übergeben die Kontrolle komplett an andere Controller. Die meisten *MVC* Experten
     empfehlen `Controller so schlank wie möglich zu halten`_.

   Natürlich gibt es über dieses kritische Pattern `mehr zu sagen`_, aber das gesagte sollte genug Hintergrund
   vermitteln um die Guestbook Anwendung zu verstehen die wir bauen wollen.



.. _`Komponenten Übersicht`: http://framework.zend.com/about/components
.. _`zip`: http://framework.zend.com/demos/ZendFrameworkQuickstart.zip
.. _`tar.gz`: http://framework.zend.com/demos/ZendFrameworkQuickstart.tar.gz
.. _`Controller so schlank wie möglich zu halten`: http://weblog.jamisbuck.org/2006/10/18/skinny-controller-fat-model
.. _`mehr zu sagen`: http://ootips.org/mvc-pattern.html
