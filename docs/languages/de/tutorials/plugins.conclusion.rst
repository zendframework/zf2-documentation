.. EN-Revision: none
.. _learning.plugins.conclusion:

Fazit
=====

Das Verstehen des Konzepts von Präfix Pfaden und dem Übersteuern von existierenden Plugins hilft beim Verstehen
von vielen Konzepten im Framework. Plugins werden in einer Vielzahl von Orten verwendet:

- ``Zend_Application``: Ressourcen.

- ``Zend\Controller\Action``: Action Helfer.

- ``Zend\Feed\Reader``: Plugins.

- ``Zend_Form``: Elemente, Filter, Prüfungen und Dekorateure.

- ``Zend_View``: View Helfer.

Und verschiedene andere Orte. Wenn man die Konzepte früh lernt kann man diesen wichtigen Erweiterungspunkt im Zend
Framework entsprechend umsetzen.

.. note::

   **Nachteile**

   Wir haben erwähnt das ``Zend\Controller\Front`` ein Plugin System hat - aber es hält sich nicht an
   irgendwelche Richtlinien die in diesem Tutorial angeboten werden. Die im Front Controller registrierten Plugins
   müssen direkt instanziert und individuell in Ihm registriert werden. Der Grund hierfür ist, dass das System
   jedem anderen Plugin System im Zend Framework vorausgeht, und Änderungen an Ihm müssen sorgfältig abgewägt
   werden um sicherzustellen das Plugins welche von Entwicklern geschrieben wurden weiterhin funktionieren.


