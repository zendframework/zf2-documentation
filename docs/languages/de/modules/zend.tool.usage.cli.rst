.. _zend.tool.usage.cli:

Verwendung von Zend_Tool auf der Kommandozeile
==============================================

Das *CLI*, oder Kommandozeilentool (intern bekannt als Konsolen Tool), ist aktuell das primäre Interface für die
Bearbeitung von ``Zend_Tool`` Anfragen. Mit dem *CLI* Tool können Entwickler Tooling Anfragen im "Kommandozeilen
Fenster", auch bekannt als "Terminal" Fenster, auslösen. Diese Umgebung ist vorherrschend bei \*nix Umgebungen, es
gibt aber auch übliche Implementationen unter Windows mit ``cmd.exe``, Console2 und auch im Cygwin Projekt.

.. _zend.tool.usage.cli.installation:

Installation
------------

.. _zend.tool.usage.cli.installation.download-and-go:

Herunterladen und anfangen
^^^^^^^^^^^^^^^^^^^^^^^^^^

Zuerst muss Zend Framework heruntergeladen werden. Das kann man tun, indem man auf framework.zend.com geht und das
letzte Release herunterlädt. Nachdem man das Paket heruntergeladen und auf dem System plaziert hat ist der
nächste Schritt das zf Kommendo auf dem System zu erstellen. Der einfachste Weg das zu tun ist die richtigen
Dateien vom bin/ Verzeichnis des Downloads zu kopieren, und diese Dateien im **gleichen** Verzeichnis zu platzieren
wie der Ort an dem die PHP CLI Binardatei ist.

.. _zend.tool.usage.cli.installation.pear:

Installation über Pear
^^^^^^^^^^^^^^^^^^^^^^

Um es über PEAR zu installieren muss man die 3rd Party Site zfcampus.org verwenden und das letzte Zend Framwork
PEAR Paket empfangen. Diese Pakete werden typischerweise innerhalb eines Tages nach einem offiziellen Zend
Framework Release erstellt. Der Vorteil der Installation über den PEAR Package Manager ist, dass die ZF Bibliothek
im include_path endet, und die zf.php und ZF Skripte an einem Ort im eigenen System enden der es erlaubt Sie ohne
zusätzliches Setup zu starten.

.. code-block:: text
   :linenos:

   pear discover-channel pear.zfcampus.org
   pear install zfcampus/zf

Das ist es schon. Nachdem initialen Setup sollte man in der Lage sein weiter zu machen indem das zf Kommando
ausgeführt wird. Ein gute Weg um zu prüfen ob es vorhanden ist, ist es zf --help auszuführen.

.. _zend.tool.usage.cli.installation.install-by-hand:

Installation von Hand
^^^^^^^^^^^^^^^^^^^^^

Die Installtion von Hand zeigt den Prozess um zf.php und die Zend Framework Bibliothek dazu zu zwingen zusammen zu
arbeiten wenn diese nicht auf konventionellen Orten abgelegt wurden, oder zumindest, an einem Ort an dem das eigene
System diese nicht einfach ausführen kann (typisch für Programme im eigenen System Pfad).

Wenn man auf einem \*nix oder Mac System ist, kann man auch einen Link von irgendwo im eigenen Pfad zur zf.sh Datei
erstellen. Wenn man das macht muss man sich keine Gedanken darüber machen das die Zend Framework Bibliothek im
eigenen include_path ist, da die Dateien zf.php und zf.sh auf die Bibliothek, relativ dazu wo Sie sind, zugreifen
können (was bedeutet das die ./bin/ Dateien relativ zu ../library/ der Zend Framework Bibliothek sind).

Es gibt eine Anzahl von anderen vorhandenen Optionen für das Setup von zf.php und der Bibliothek im eigenen
System. Diese Optionen drehen sich um das Setzen von speziellen Umgebungsvariablen. Diese werden im späteren
Kapitel "Die CLI Umgebung anpassen" beschrieben. Die Umgebungsvariablen für das Setzen von include_path,
ZF_INCLUDE_PATH und ZF_INCLUDE_PATH_PREPEND für zf.php sind die interessantesten.

.. _zend.tool.usage.cli.general-purpose-commands:

Kommandos für generelle Zwecke
------------------------------

.. _zend.tool.usage.cli.general-purpose-commands.version:

Version
^^^^^^^

Das zeigt die aktuelle Versionsnummer der Kopie vom Zend Framework welche das zf.php Tool verwendet.

.. code-block:: text
   :linenos:

   zf show version

.. _zend.tool.usage.cli.general-purpose-commands.built-in-help:

Eingebaute Hilfe
^^^^^^^^^^^^^^^^

Das eingebaute Hilfe System ist der primäre Ort von dem man up-to-date Informationen darüber erhält was das
eigene System in der Lage ist zu tun. Das Hilfe System ist dahingehend dynamisch das Provider dem eigenen System
hinzugefügt und automatisch ausgeführt werden, und als solches werden die notwendigen Parameter damit Sie
ausgeführt werden können, im Hilfe Schirm vorhanden. Der einfachste Weg um den Hilfe Schirm zu erhalten ist der
folgende:

.. code-block:: text
   :linenos:

   zf --help

Das gibt einen Überblick über die verschiedenen Möglichkeiten des Systems. Manchmal gibt es engültigere
Kommandos die ausgeführt werden können, und um mehr Informationen über Sie zu erhalten muss man ein
spezialisierteres Hilfe Kommando ausführen. Für die spezialisierte Hilfe muss einfach eines der Elemente des
Kommandos mit einem "=" ersetzt werden. Das sagt dem Hilfe System das man mehr Informationen darüber will welche
Kommandos an Stelle des Fragezeichens stehen können. Zum Beispiel:

.. code-block:: text
   :linenos:

   zf ? controller

Das obige bedeutet "zeig mir alle 'Aktionen' für den Provider 'controller'"; wärend das folgende:

.. code-block:: text
   :linenos:

   zf show ?

bedeutet "zeig mit alle Provider welche die 'show' Aktion unterstützen. Das arbeitet auch wenn man in Optionen
geht wie man im folgenden Beispiel sehen kann:

.. code-block:: text
   :linenos:

   zf show version.? (zeige alle Spezialitäten)
   zf show version ? (zeige alle Optionen)

.. _zend.tool.usage.cli.general-purpose-commands.manifest:

Manifest
^^^^^^^^

Das zeigt welche Informationen im Tooling System Manifest sind. Das ist wichtiger für Entwickler von Providers als
für normale Benutzer des Tooling Systems.

.. code-block:: text
   :linenos:

   zf show manifest

.. _zend.tool.usage.cli.project-specific-commands:

Projekt spezifische Kommandos
-----------------------------

.. _zend.tool.usage.cli.project-specific-commands.project:

Project
^^^^^^^

Der Projekt Provider ist das erste Kommando das man ausführen wird wollen. Er erstellt die grundsätzliche
Struktur der Anwendung. Er wird benötigt bevor irgendein anderer Provider ausgeführt werden kann.

.. code-block:: text
   :linenos:

   zf create project MyProjectName

Dies erstellt ein Projekt im ./MyProjectName genannten Verzeichnis. Von diesem Punkt an ist es wichtig anzumerken
das jedes weitere Kommando in der Kommandozeile von innerhalb des Projektverzeichnisses auszuführen ist welches
gerade erstellt wurde. Nach dessen Erstellung ist es also notwendig dass man in das Verzeichnis wechselt.

.. _zend.tool.usage.cli.project-specific-commands.module:

Module
^^^^^^

Der Module Provider erlaubt die einfache Erstellung eines Zend Framework Moduls. Ein Modul folgt lose dem MVC
Pattern. Wenn Module erstellt werden, verwenden Sie die gleiche Struktur welche im application/ Level verwendet
wird, und dupliziert diese im ausgewählten Namen für das Modul, innerhalb des Verzeichnisses "modules" im
Verzeichnis application/ ohne dass das Modul Verzeichnis selbst dupliziert wird. Zum Beispiel:

.. code-block:: text
   :linenos:

   zf create module Blog

Das erstellt ein Modul welches Blog genannt wird unter application/modules/Blog, und alle Abschnitte welche das
Modul benötigt.

.. _zend.tool.usage.cli.project-specific-commands.controller:

Controller
^^^^^^^^^^

Der Controller Provider ist (meistens) für die Erstellung leerer Controller zuständig sowie deren entsprechenden
Verzeichnissen und Dateien für View Skripte. Um Ihn zum Beispiel dazu zu verwenden einen 'Auth' Controller zu
erstellen muss folgendes ausgeführt werden:

.. code-block:: text
   :linenos:

   zf create controller Auth

Das erstellt einen Controller der Auth heißt, und im speziellen wird eine Datei unter
application/controllers/AuthController.php erstellt welche den AuthController enthält. Wenn man einen Controller
für ein Modul erstellen will, kann eine der folgenden Zeilen verwendet werden:

.. code-block:: text
   :linenos:

   zf create controller Post 1 Blog
   zf create controller Post -m Blog
   zf create controller Post --module=Blog

Beachte: Im ersten Kommando ist der Wert 1 für das "includeIndexAction" Flag.

.. _zend.tool.usage.cli.project-specific-commands.action:

Action
^^^^^^

Um eine Action in einem bestehenden Controller zu erstellen:

.. code-block:: text
   :linenos:

   zf create action login Auth
   zf create action login -c Auth
   zf create action login --controller-name=Auth

.. _zend.tool.usage.cli.project-specific-commands.view:

View
^^^^

Um eine View ausserhalb der normalen Controller/Action Erstellung zu erstellen würde man eine der folgenden Zeilen
verwenden:

.. code-block:: text
   :linenos:

   zf create view Auth my-script-name
   zf create view -c Auth -a my-script-name

Das erstellt ein View Skript im Controller Verzeichnis von Auth.

.. _zend.tool.usage.cli.project-specific-commands.model:

Model
^^^^^

Der Model Provider ist nur für die Erstellung der richtigen Modell Dateien, mit dem richtigen Namen im
Anwendungsverzeichnis zuständig. Zum Beispiel:

.. code-block:: text
   :linenos:

   zf create model User

Wenn man ein Modell mit einem spezifischen Modul erstellen will:

.. code-block:: text
   :linenos:

   zf create model Post -m Blog

Das obige erstellt ein 'Post' Modell im Modul 'Blog'.

.. _zend.tool.usage.cli.project-specific-commands.form:

Form
^^^^

Der Form Provider ist nur für die Erstellung der richtigen Formulardateien und der init() Methode, mit dem
richtigen Namen im Anwendungsverzeichnis zuständig. Zum Beispiel:

.. code-block:: text
   :linenos:

   zf create form Auth

Wenn man ein Modell in einem spezifischen Modul erstellen will:

.. code-block:: text
   :linenos:

   zf create form Comment -m Blog

Das obige erstellt ein 'Comment' Formular im Modul 'Blog'.

.. _zend.tool.usage.cli.project-specific-commands.database-adapter:

DbAdapter
^^^^^^^^^

Um einen DbAdapter zu konfigurieren muss man die Informationen als Url kodierten String angeben. Dieser String muss
in der Kommandozeile in Hochkommas stehen.

Um zum Beispiel die folgenden Informationen einzugeben:



   - adapter: Pdo_Mysql

   - username: test

   - password: test

   - dbname: test

Muss das folgende auf der Kommandozeile ausgeführt werden:

.. code-block:: text
   :linenos:

   zf configure dbadapter "adapter=Pdo_Mysql&username=test&password=test&dbname=test"

Dies nimmt an das man diese Information im Abschnitt 'production' der Konfigurationsdatei der Anwendung speichern
will. Das folgende demonstriert eine Sqlite Konfiguration im Abschnitt 'development' der Konfigurationsdatei der
Anwendung:

.. code-block:: text
   :linenos:

   zf configure dbadapter "adapter=Pdo_Sqlite&dbname=../data/test.db" development
   zf configure dbadapter "adapter=Pdo_Sqlite&dbname=../data/test.db" -s development

.. _zend.tool.usage.cli.project-specific-commands.db-table:

DbTable
^^^^^^^

Der DbTable Provider ist für die Erstellung der ``Zend_Db_Table`` Modell/Datenzugriffs- Dateien, der Anwendung die
Sie benötigt, verantwortlich. Zusammen mit dem richtigen Klassennamen und dem richtigen Platz in der Anwendung.
Die zwei wichtigsten Informationsteile sind **DbTable Name** und der **aktuelle Name der Datenbank Tabelle**. Zum
Beispiel:

.. code-block:: text
   :linenos:

   zf create dbtable User user
   zf create dbtable User -a user

   // akzeptiert auch eine "erzwinge" Option
   // um existierende Dateien zu überschreiben
   zf create dbtable User user -f
   zf create dbtable User user --force-override

Der DbTable Provider ist auch dazu in der Lage die richtigen Daten zu erstellen indem er die Datenbank scannt die
mit dem obigen DbAdapter Provider konfiguriert wurde.

.. code-block:: text
   :linenos:

   zf create dbtable.from-database

Wenn das obenstehende ausgeführt wird, könnte es Sinn machen das voranstellen-Flag ("-p") zuerst zu verwenden
damit man sieht was getan werden würde und welche Tabellen in der Datenbank gefunden werden können.

.. code-block:: text
   :linenos:

   zf -p create dbtable.from-database

.. _zend.tool.usage.cli.project-specific-commands.layout:

Layout
^^^^^^

Aktuell ist die einzige unterstützte Aktion für Layouts einfach deren Aktivierung damit die richtigen Schlüssel
in die Datei application.ini geschrieben werden damit die Anwendungs Ressource funktioniert und die richtigen
Verzeichnisse und die Datei layout.phtml erstellt wird.

.. code-block:: text
   :linenos:

   zf enable layout

.. _zend.tool.usage.cli.environment-customization:

Anpassung der Umgebung
----------------------

.. _zend.tool.usage.cli.environment-customization.storage-directory:

Das Speicher Verzeichnis
^^^^^^^^^^^^^^^^^^^^^^^^

Das Speicherverzeichnis ist wichtig damit Provider einen Platz haben an dem Sie die Benutzer-definierte Logik
finden welche den Weg verändern könnte wie Sie sich verhalten. Ein Beispiel welches anbei gefunden werden kann
ist die Platzierung einer eigenen Projekt Profil Datei.

.. code-block:: text
   :linenos:

   zf --setup storage-directory

.. _zend.tool.usage.cli.environment-customization.configuration-file:

Die Konfigurationsdatei
^^^^^^^^^^^^^^^^^^^^^^^

Das erstellt die richtige zf.ini Datei. Dies **sollte** nach ``zf --setup storage-directory`` ausgeführt werden.
Wenn dem nicht so ist, wird Sie im Home Verzeichnis des Benutzers platziert. Aber wenn dem so ist, dann wird Sie im
Benutzerdefinierten Speicherverzeichnis platziert.

.. code-block:: text
   :linenos:

   zf --setup config-file

.. _zend.tool.usage.cli.environment-customization.environment-locations:

Orte der Umgebung
^^^^^^^^^^^^^^^^^

Diese sollten gesetzt werden wenn man die standardmäßigen Orte überschreiben will an denen ZF versucht seine
Werte zu lesen.

- ZF_HOME

  - Das Verzeichnis in dem dieses Tool nach dem Home Verzeichnis nachsieht

  - Das Verzeichnis muss existieren

  - Suchrichtung:

    - ZF_HOME Umgebungsvariable

    - HOME Umgebungsvariable

    - dann HOMEPATH Umgebungsvariable

- ZF_STORAGE_DIRECTORY

  - Wo dieses Tool nach dem Speicherverzeichnis nachsehen wird

  - Das Verzeichnis muss existieren

  - Suchrichtung:

    - ZF_STORAGE_DIRECTORY Umgebungsvariable

    - $homeDirectory/.zf/ Verzeichnis

- ZF_CONFIG_FILE

  - Wo dieses Tool nach der Konfigurationsdatei nachsieht

  - Suchrichtung:

    - ZF_CONFIG_FILE Umgebungsvariable

    - $homeDirectory/.zf.ini Datei wenn Sie existiert

    - $storageDirectory/zf.ini Datei wenn Sie existiert

- ZF_INCLUDE_PATH

  - Setzt den include_path der für dieses Tool verwendet werden soll auf diesen Wert

  - Originales Verhalten:

    - Verwende php's include_path um ZF zu finden

    - Verwende die Umgebungsvariable ZF_INCLUDE_PATH

    - Verwende den Pfad ../library (relativ zu zf.php) um ZF zu finden

- ZF_INCLUDE_PATH_PREPEND

  - Stellt diesen Wert dem aktuellen include_path in php.ini voran


