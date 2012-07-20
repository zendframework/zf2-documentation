.. _zend.currency.introduction:

Einführung in Zend_Currency
===========================

``Zend_Currency`` ist Teil der starken Unterstützung für I18n im Zend Framework. Es behandelt alle Themen
bezüglich Währung, Darstellung von Geld, Formatierung, Wechselkurs Services und Berechnung.

.. _zend.currency.introduction.list:

Warum sollte man Zend_Currency verwenden?
-----------------------------------------

``Zend_Currency`` bietet die folgenden Vorteile:

- **Komplette Unterstützung für Gebietsschemata**

  Diese Komponente arbeitet mit allen vorhandenen Gebietsschemata und weiß deshalb über mehr als 100
  unterschiedliche lokalisierte Währungen bescheid. Das enthält Informationen wie die Namen von Währungen, deren
  Abkürzungen, Währungszeichen und viele andere.

- **Wiederverwendbare Währungsdefinitionen**

  ``Zend_Currency`` bietet den Vorteil das bereits definierte Darstellungen für Währungen wiederverwendet werden
  können. Man könnte also 2 unterschiedliche Darstellungen für die gleiche Währung haben.

- **Währungen Kalkulieren**

  ``Zend_Currency`` erlaubt es mit Währungswerten zu rechnen. Hierfür bietet sie ein Interface zu
  Währungsumrechnungs Services.

- **Zusätzliche Methoden**

  ``Zend_Currency`` enthält verschiedene zusätzliche Methoden welche Informationen über Details zu Währungen
  bieten wie z.B.: Welche Währung wird in einer bestimmten Region verwendet, oder Was sind die bekannten
  Abkürzungen einer Währung.


