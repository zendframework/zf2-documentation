.. _zend.tool.project.create-a-project:

Ein Projekt erstellen
=====================

.. note::

   Das folgende Beispiel nimmt an das man ein Kommandozeilen Interface von ``Zend_Tool_Framework`` hat.

.. note::

   Um irgendeinen der Kommandos von ``Zend_Tool_Project`` mit *CLI* auszuführen muss man im Verzeichnis sein in
   dem das Projekt ursprünglich erstellt wurde.

Um mit ``Zend_Tool_Project`` zu starten, muss man einfach ein Projekt erstelltn. Die Erstellung eines Projektes ist
sehr einfach: Gehe zu einem Ort im Dateisystem, erstelle ein Verzeichnis, wechsele in dieses Verzeichnis, und dann
führe die folgenden Kommandos aus:

``/tmp/project$ zf create project``

Optional kann ein Verzeichnis überall wie folgt erstellt werden:

``$ zf create project /path/to/non-existent-dir``

Die folgende Tabelle beschreibt die Möglichkeiten der Provider die vorhanden sind. Wie man in der Tabelle sieht,
gibt es einen "Project" Provider. Der Project Provider hat eine Vielzahl von assoziierten Aktionen, und mit diesen
Aktionen auch eine Anzahl an Optionen die verwendet werden können um das Verhalten von Aktionen und Providern zu
verändern.

.. _zend.tool.project.project-provider-table:

.. table:: Optionen des Project Providers

   +-------------+-------------------+---------------------------------------+---------------------------+
   |Provider Name|Vorhandene Aktionen|Parameter                              |CLI Verwendung             |
   +=============+===================+=======================================+===========================+
   |Project      |Create Show        |create = [path=null, profile='default']|zf create project some/path|
   +-------------+-------------------+---------------------------------------+---------------------------+


