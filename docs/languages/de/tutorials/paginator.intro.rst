.. _learning.paginator.intro:

Einführung
==========

Angenommen wir wollen eine Blogging Anwendung erstellen die das Heim unserer gewaltigen Sammlung an blog Posts ist.
Es gibt eine gute Chance das wir nicht wollen das alle unsere Blog Posts auf einer Seite erscheinen wenn jemand
unseren Blog besucht. Eine offensichtliche Lösung besteht darin nur eine kleine Anzahl an Blog Posts auf dem
Bildschirm zur gleichen Zeit anzuzeigen, und dem Benutzer zu erlauben durch die unterschiedlichen Seiten zu gehen,
ähnlich wie die geliebte Suchmaschine das Ergebnis eigener Suchanfragen zeigt. ``Zend_Paginator`` ist dazu gebaut
dabei zu helfen dieses Ziel, der Trennung von Datensammlungen in kleinere, besser managebare Sets, einfacher,
konsistenter und mit weniger Code Duplizierung zu erreichen.

``Zend_Paginator`` verwendet Adapter um verschiedene Datenquellen zu unterstützen und Scrollingstile um
verschiedene Methoden zu unterstützen die dem Benutzer anzeigen welche Seiten vorhanden sind. In späteren
Sektionen dieses Textes haben wir eine genauere Sicht darauf was diese Dinge sind, und wie Sie helfen das meiste
aus ``Zend_Paginator`` herauszuholen.

Bevor wir in die Tiefe gehen schauen wir uns zuerst einige einfache Beispiele an. Nach diesen einfachen Beispielen
sehen wir wie ``Zend_Paginator`` die üblichsten Fälle unterstützt; seitenweise Ausgabe von Datenbank
Ergebnissen.

Diese Einführung hat einen schnellen Überblick über ``Zend_Paginator`` gegeben. Um anzufangen und einen Blick
auf einige Code Abschnitte zu haben, sehen wir uns einige einfache Beispiele an.


