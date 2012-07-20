.. _zend.tool.framework.clitool:

Verwenden des CLI Tools
=======================

Das *CLI*, oder Kommandozeilen Tool (Intern als Consolen Tool bekannt), ist aktuell das primäre Interface für die
Bearbeitung von ``Zend_Tool`` Anfragen. Mit dem *CLI* Tool können Entwickler werkmäßige Anfragen in einem
"Kommandozeilen Fenster", allgemein bekannt als "Terminal", erstellen. Diese Umgebung ist in einer \*nix Umgebung
vorherrschend, hat aber auch eine bekannte Implementation in Windows, mit ``cmd.exe``, Console2 und auch dem Cygwin
Projekt.

.. _zend.tool.framework.clitool.setup-general:

Vorbereiten des CLI Tools
-------------------------

Um werkmäßige Anfragen über den Kommandozeilen Client zu erstellen, muß man zuerst den Client einrichten, damit
das System das "zf" Kommando behandeln kann. Der Kommandozeilen Client für alle Wünsche und Zwecke, ust die
``.sh`` oder ``.bat`` Datei die mit der Distribution von Zend Framework ausgeliefert wurde. Im Trunk kann sie hier
gefunden werden: `http://framework.zend.com/svn/framework/standard/trunk/bin/`_.

Wie man siehr gibt es im ``/bin/`` Verzeichnis 3 Dateien: ``zf.php``, ``zf.sh`` und ``zf.bat``. ``zf.sh`` und
``zf.bat`` sind spezielle Client-Wrapper für das Betriebssystem: ``zf.sh`` für \*nix Umgebungen, und ``zf.bat``
für Win32 Umgebungen. Diese Client-Wrapper sind dafür zuständig die richtige ``php.exe`` und ``zf.php`` zu
finden, sowie die Anfrage des Clients weiterzugeben. ``zf.php`` ist dafür zuständig die Umgebung zu verstehen,
den richtigen include_path zu erstellen, und das an die richtigen Komponenten der Bibliothek für die Verarbeitung
zu übergeben was über die Kommandozeile übergeben wurde.

Ultimativ muß man zwei Dinge sicherstellen das alles funktioniert, unabhängig davon auf welchem Betriebssystem
man ist:

. ``zf.sh/zf.bat`` ist vom Systempfad aus erreichbar. Das ist die Möglichkeit ``zf`` überall von der
  Kommandozeile aus aufzurufen, unabhängig davon welches das aktuelle Arbeitsverzeichnis ist.

. ``ZendFramework/library`` ist im eigenen ``include_path``.

.. note::

   Beachte: wärend das oben stehende die idealsten Voraussetzungen sind, kann man einfach Zend Framework
   herunterladen und erwarten das es mit ``./path/to/zf.php`` funktioniert.

.. _zend.tool.framework.clitool.setup-starnix:

Das CLI Tool in Unix-artigen Systemen vorbereiten
-------------------------------------------------

Das übliche Setup in einer \*nix Umgebung, besteht darin ``zf.sh`` und ``zf.php`` in das gleiche Verzeichnis wie
die *PHP* Binaries zu kopieren. Diese können normalerweise an einem der folgenden Plätze gefunden werden:

.. code-block:: text
   :linenos:

   /usr/bin
   /usr/local/bin
   /usr/local/ZendServer/bin/
   /Applications/ZendServer/bin/

Um den Ort der *PHP* Binaries herauszufinden, kann man 'which php' auf der Kommandozeile ausführen. Das gibt den
Ort der *PHP* Binaries zurück, die verwendet werden wenn *PHP* Skripte in der eigenen Umgebung ausgeführt werden.

Der nächste Arbeitsschritt besteht darin, sicherzustellen das die Zend Framework Bibliothek richtig im
``include_path`` vom *PHP* System steht. Um herauszufinden wo der ``include_path`` ist, kann man ``php -i``
ausführen und nach der ``include_path`` Variable sehen, oder kompakter einfach ``php -i | grep include_path``
ausführen. Sobald man herausgefunden hat wo die ``include_path`` Variable steht (das ist normalerweise etwas wie
``/usr/lib/php``, ``/usr/share/php``, ``/usr/local/lib/php``, oder ähnliches), muß man sicherstellen das der
Inhalt des ``/library/`` Verzeichnisses im spezifizierten Verzeichnis des ``include_path``'s abgelegt sind.

Sobald man diese zwei Dinge getan hat, sollte man in der Lage sein ein Kommando auszuführen und die richtige
Antwort, ähnlich der folgenden, zurückzugekommen:

.. image:: ../images/zend.tool.framework.cliversionunix.png
   :align: center

Wenn man diese Art der Ausgabe nicht sieht, muß man zurückgehen und das Setup prüfen um sicherzustellen das alle
notwendigen Teile am richtigen Platz stehen.

Es gibt eine Anzahl von alternativen Setup die man eventuell verwenden will, abhängig von der Server
Konfiguration, dem Zugriffslevel, oder aus anderen Gründen.

**Alternative Setup** bedeutet das der Zend Framework Download so wie er ist zusammenbleibt, und ein Link von einem
``PATH`` Ort zur Datei ``zf.sh`` erstellt wird. Das bedeutet das man den Inhalt des ZendFramework Downloads an
einem Ort wie ``/usr/local/share/ZendFramework``, oder noch lokaler wie ``/home/username/lib/ZendFramework``
platzieren kann, und einen Symbolischen Link zu ``zf.sh`` erstellt.

Angenommen man will den Link nach ``/usr/local/bin`` geben (das könnte auch funktionieren wenn der Link in
``/home/username/bin/`` platziert werden soll), dann könnte man ein Kommando ähnlich dem folgenden ausführen:

.. code-block:: sh
   :linenos:

   ln -s /usr/local/share/ZendFramework/bin/zf.sh /usr/local/bin/zf

   # ODER (zum Beispiel)
   ln -s /home/username/lib/ZendFramework/bin/zf.sh /home/username/bin/zf

Das erstellt einen Link den man global von der Kommandozeile aus aufrufen können sollte.

.. _zend.tool.framework.clitool.setup-windows:

Das CLI Tool in Windows vorbereiten
-----------------------------------

Das üblichste Setup in einer Windows Win32 Umgebung besteht darin, ``zf.bat`` und ``zf.php`` in das gleiche
Verzeichnis wie die *PHP* Binaries zu kopieren. Diese können generell an einem der folgenden Plätze gefunden
werden:

.. code-block:: text
   :linenos:

   C:\PHP
   C:\Program Files\ZendServer\bin\
   C:\WAMP\PHP\bin

Man sollte in der Lage sein ``php.exe`` auf der Kommandozeile auszuführen. Wenn man das nicht kann, muß man
zuerst die Dokumentation prüfen die mit der *PHP* Distribution gekommen ist, oder sicherstellen das der Pfad zu
``php.exe`` in der Windows Umgebungsvariable ``PATH`` vorhanden ist.

Der nächste Arbeitsschritt besteht darin, sicherzustellen das die Zend Framework Bibliothek richtig im
``include_path`` vom *PHP* System steht. Um herauszufinden wo der ``include_path`` ist, kann man ``php -i``
ausführen und nach der ``include_path`` Variable sehen, oder kompakter einfach ``php -i | grep include_path``
ausführen wenn Cygwin mit grep zur Verfügung steht. Sobald man herausgefunden hat wo die ``include_path``
Variable steht (das ist normalerweise etwas wie ``C:\PHP\pear``, ``C:\PHP\share``,
``C:\Program%20Files\ZendServer\share`` oder ähnliches), muß man sicherstellen das der Inhalt des library/
Verzeichnisses im spezifizierten Verzeichnis des ``include_path``'s abgelegt sind.

Sobald man diese zwei Dinge getan hat, sollte man in der Lage sein ein Kommando auszuführen und die richtige
Antwort, ähnlich der folgenden, zurückzugekommen:

.. image:: ../images/zend.tool.framework.cliversionwin32.png
   :align: center

Wenn man diese Art der Ausgabe nicht sieht, muß man zurückgehen und das Setup prüfen um sicherzustellen das alle
notwendigen Teile am richtigen Platz stehen.

Es gibt eine Anzahl von alternativen Setup die man eventuell verwenden will, abhängig von der Server
Konfiguration, dem Zugriffslevel, oder aus anderen Gründen.

**Alternative Setup** bedeutet das der Zend Framework Download so wie er ist zusammenbleibt, und sowohl die
Systemvariable ``PATH`` als auch die ``php.ini`` Datei geändert werden muss. In der Umgebung des Benutzers muss
man sicherstellen das ``C:\Path\To\ZendFramework\bin`` hinzugefügt ist, damit die Datei ``zf.bat`` ausgeführt
werden kann. Auch die Datei ``php.ini`` ist zu Ändern um sicherzustellen das ``C:\Path\To\ZendFramework\library``
im ``include_path`` ist.

.. _zend.tool.framework.clitool.setup-othernotes:

Andere Überlegungen für ein Setup
---------------------------------

Wenn man aus bestimmten Gründen die Zend Framework Bibliothek nicht im ``include_path`` haben will, gibt es auch
eine andere Option. Es gibt auch zwei spezielle Umgebungsvariablen die ``zf.php`` verwendet um den Ort der
Installation vom Zend Framework zu erkennen.

Der erste ist ``ZEND_TOOL_INCLUDE_PATH_PREPEND``, welcher den Wert dieser Umgebungsvariablen dem ``include_path``
des Systems (``php.ini``) voranstellt, bevor der Client geladen wird.

Alternativ kann es gewünscht sein ``ZEND_TOOL_INCLUDE_PATH`` zu verwenden, um den ``include_path`` des System
komplett zu **ersetzen**, wenn das speziell für das ``zf`` Kommandozeilen Tool Sinn macht.

.. _zend.tool.framework.clitool.continuing:

Wohin als nächstes?
-------------------

An diesem Punkt sollte man dafür gerüstet sein einige "interessantere" Kommandos zu initialisieren. Um
weiterzumachen kann man das Kommando ``zf --help`` ausführen um zu sehen was vorhanden ist.

.. image:: ../images/zend.tool.framework.clihelp.png
   :align: center

Lesen Sie bei ``Zend_Tool_Project`` im Kapitel "Create Project" weiter um zu verstehen wie das ``zf`` Skript für
die Projekterstellung verwendet werden kann.



.. _`http://framework.zend.com/svn/framework/standard/trunk/bin/`: http://framework.zend.com/svn/framework/standard/trunk/bin/
