.. _zend.tool.framework.system-providers:

Mitgelieferte System Provider
=============================

Zusätzlich zu den nützlicheren Projekt basierten Providern die mit ``Zend_Tool_Project`` ausgeliefert werden,
gibt es auch einige grundsätzlichere, aber interessante Provider die in ``Zend_Tool_Framework`` eingebaut sind.
Einige von Ihnen existieren für den Zweck, über die Kommandozeile Informationen zu extrahieren, wie die Version,
wärend andere dazu gedacht sind den Entwickler zu unterstützen, wärend er zusätzliche Provider erstellt.

.. _zend.tool.framework.system-providers.version:

Der Version Provider
--------------------

Der Version Provider ist enthalten, sodas man feststellen kann mit welcher Version vom Framework ``zf`` oder
``Zend_Tool`` aktuell arbeitet.

Über die Kommandozeile, einfach ``zf show version`` ausführen.

.. _zend.tool.framework.system-providers.manifest:

Der Manifest Provider
---------------------

Der Manifest Provider ist enthalten, sodas man feststellen kann welche Art von "manifest" Information wärend der
Laufzeit von ``Zend_Tool`` vorhanden ist. Manifest Daten sind Informationen die speziellen Objekten wärend der
Laufzeit von ``Zend_Tool`` angehängt werden. Im Manifest findet man Konsolen-spezifische Benennungen die man
verwendet wenn bestimmte Kommandos aufgerufen werden. Die Daten die im Manifest gefunden werden können von jedem
Provider oder Client bei Bedarf verwendet werden.

Über die Kommandozeile, einfach ``zf show manifest`` ausführen.


