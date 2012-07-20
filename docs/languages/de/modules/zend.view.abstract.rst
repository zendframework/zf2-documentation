.. _zend.view.abstract:

Zend_View_Abstract
==================

``Zend_View_Abstract`` ist die Basisklasse auf der ``Zend_View`` aufbaut; ``Zend_View`` selbst erweitert Sie
einfach und deklariert eine konkrete Implementation der ``_run()`` Methode (welche durch ``render()`` aufgerufen
wird).

Viele Entwickler finden das Sie ``Zend_View_Abstract`` erweitern wollen um eigene Funktionalitäten hinzuzufügen
und daraus folgend in Probleme mit dessen Design laufen, welches eine Anzahl an privaten Membern enthält. Dieses
Dokument zielt darauf ab die Entscheidung hinter diesem Design zu erklären.

``Zend_View`` ist etwas wie eine Anti-Template Maschine und verwendet deswegen *PHP* nativ für sein Templating.
Als Ergebnis ist alles von *PHP* vorhanden und View Skripte erweitern Ihre aufrufendes Objekt.

Es ist dieser letzte Punkt der relevant für die Design Entscheidung war. Intern macht ``Zend_View::_run()``
folgendes:

.. code-block:: php
   :linenos:

   protected function _run()
   {
       include func_get_arg(0);
   }

Als solches, haben die View Skripte Zugriff auf das aktuelle Objekt (``$this``), **und jede Methode oder jeden
Member dieses Objekts**. Da viele Operationen von Membern mit limitierter Sichtbarkeit abhängen, führt das zu
einem Problem: Das View Skript können potentiell Aufrufe zu solchen Methoden tätigen, oder kritische
Eigenschaften direkt ändern. Angenommen ein Skript überschreibt ``$_path`` oder ``$_file`` unabsichtlich -- jeder
weitere Aufruf zu ``render()`` oder View Helfern würde fehlschlagen!

Glücklicherweise hat *PHP* 5 eine Anwort auf das mit seiner Deklaration der Sichtbarkeit; Auf private Member kann
nicht durch Objekte zugegriffen werden wenn eine bestehende Klasse erweitert wird. Das führt zum aktuellen Design:
Da ``Zend_View`` ``Zend_View_Abstract`` **erweitert** sind View Skripte limitiert auf protected und public Methoden
und Member von ``Zend_View_Abstract``-- was effektiv die Aktionen beschränkt die durchgeführt werden können, und
es erlaubt kritische Bereiche vor Missbrauch durch View Skripte zu schützen.


