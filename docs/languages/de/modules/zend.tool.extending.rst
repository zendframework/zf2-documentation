.. _zend.tool.extending:

Zend_Tool erweitern
===================

.. _zend.tool.extending.overview:

Übersicht über Zend_Tool
------------------------

``Zend_Tool_Framework`` ist ein Framework für die Bereitstellung gemeinsamer Funktionalitäten wie die Erstellung
von Projekthüllen, Code Erzeugung, Erstellung von Suchindezes, und noch mehr. Funktionalitäten können
geschrieben und über *PHP* Klassen in den *PHP* ``include_path`` geworfen werden, was eine immense Flexibilität
der Implementation liefert. Die Funktionalität kann dann verwendet werden indem eine Implementation geschrieben
wird oder durch protokoll-spezifische Clients -- wie Konsolen Clients, *XML-RPC*, *SOAP*, und andere.

``Zend_Tool_Project`` baut auf die Möglichkeiten von ``Zend_Tool_Framework`` auf und erweitert diese um ein
"Projekt" zu managen. Generell ist ein "Projekt" ein geplantes Ereignis oder eine Initiative. In der Computerwelt
sind Projekte generell Sammlungen von Ressourcen. Diese Ressourcen können Dateien, Verzeichnisse, Datenbanken,
Schematas, Bilder, Stile und anderes sein.

.. _zend.tool.extending.zend-tool-framework:

Erweiterungen von Zend_Tool_Framework
-------------------------------------

.. _zend.tool.extending.zend-tool-framework.architecture:

Überblick der Architektur
^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Tool_Framework`` bietet das folgende:

- **Gemeinsame Interfaces und Abstraktes** welche es Entwicklern erlauben Funktionalitäten und Möglichkeiten zu
  erstellen welche durch Tooling Clients verwendbar sind.

- **Grundsätzliche Client Funktionalität** und eine konkrete Konsolenimplementation welche externe Tools und
  Interfaces mit ``Zend_Tool_Framework`` verbindet. Der Konsolenclient kann in *CLI* Umgebungen verwendet werden,
  wie Unix Shells und der Windows Konsole.

- **"Provider" und "Manifest" Interfaces** welche vom Toolingsystem verwendet werden können. "Provider"
  repräsentieren den funktionalen Aspekt des Frameworks, und definieren die Aktionen welche Tooling Clients
  aufrufen können. "Manifests" agieren als Metadaten Registrierungen welche zusätzlichen Kontext für die
  verschiedenen definierten Provider bieten.

- **Ein introspektives Ladesystem** welches die Umgebung auf Provider scannt und erkennt was benötigt wird um Sie
  auszuführen.

- **Ein Standardset von System Provider** welche dem System erlauben zu melden was die kompletten Möglichkeiten
  des Systems sind, und ein nützliches Feedback bieten. Das beinhaltet auch ein ausführliches "Hilfe System".

Definitionen welche man in diesem Handbuch in Bezug auf ``Zend_Tool_Framework`` beachten sollte sind:

- ``Zend_Tool_Framework``- Der Framework welche die Tooling Möglichkeiten bereitstellt.

- **Tooling Client**- Ein Entwickler-Tool welches sich zum ``Zend_Tool_Framework`` verbindet und Ihn verwendet.

- **Client**- Das Subsystem von ``Zend_Tool_Framework`` welches ein Interface bereitstellt so das sich
  Tooling-Clienten verbinden, und Kommandos abfragen und ausführen können.

- **Konsolen Client / Kommandozeilen Interface / zf.php**- Der Tooling Client für die Kommandozeile.

- **Provider**- Ein Subsystem und eine Sammlung von eingebauten Funktionalitäten welche der Framework exportiert.

- **Manifest**- Ein Subsystem für die Definition, Organisation, und Verbreitung von Daten welche Provider
  benötigen.

- ``Zend_Tool_Project`` Provider - Ein Set von Providern speziell für die Erstellung und die Wartung von Zend
  Framework basierenden Projekten.

.. _zend.tool.extending.zend-tool-framework.cli-client:

Verstehen des CLI Clients
^^^^^^^^^^^^^^^^^^^^^^^^^

Das *CLI*, oder Kommandozeilen-Tool (intern als das Konsolen-Tool bekannt) ist aktuell das primäre Interface für
die Bearbeitung von ``Zend_Tool`` Anfragen. Mit dem *CLI* Tool können Entwickler Tooling-Anfragen im
"Kommandozeilen-Fenster" behandeln, üblicherweise auch als "Terminal" Fenster bekannt. Diese Umgebung ist in einer
\*nix Umgebung vorherrschend, hat aber auch eine übliche Implementation in Windows mit ``cmd.exe``, Console2 und
mit dem Cygwin Projekt.

.. _zend.tool.extending.zend-tool-framework.cli-client.setup-general:

Das CLI Tool vorbereiten
^^^^^^^^^^^^^^^^^^^^^^^^

Um Tooling-Anfragen über den Kommandozeilen-Client auszuführen, muss man zuerst den Client vorbereiten so dass
das System den "zf" Befehl ausführen kann. Der Kommandozeilen-Client ist, für alle Wünsche und Zwecke, die Datei
``.sh`` oder ``.bat`` welche mit der Zend Framework Distribution bereitgestellt wird. Im Trunk kann er hier
gefunden werden: `http://framework.zend.com/svn/framework/standard/trunk/bin/`_.

Wie man sehen kann, gibt es 3 Dateien im ``/bin/`` Verzeichnis: ``zf.php``, ``zf.sh``, und ``zf.bat``. ``zf.sh``
und ``zf.bat`` sind Betriebssystem-spezifische Client-Wrapper: ``zf.sh`` für die \*nix Umgebung, und ``zf.bat``
für die Win32 Umgebung. Diese Client-Wrapper sind für das Finden der richtigen ``php.exe``, das finden der
``zf.php``, und die Übergabe an die Anfrage des Clients zuständig. Die ``zf.php`` ist verantwortlich für die
Behandlung der Umgebung, die Erstellung des richtigen include_path, und der Übergabe von dem was auf der
Kommandozeile angegeben wurde an die richtige Bibliothekskomponente für die Bearbeitung.

Ultimativ, muss man zwei Dinge sicherstellen damit alles funktioniert, unabhängig vom Betriebssystem auf dem man
arbeitet:

. ``zf.sh/zf.bat`` ist vom Systempfad aus erreichbar. Das ist die Fähigkeit ``zf`` von überall aus aufzurufen,
  unabhängig von aktuellen Arbeitsverzeichnisses.

. ``ZendFramework/library`` ist im ``include_path``.

.. note::

   Zu beachten: Wärend das oben stehende sind die idealsten Notwendigkeiten sind, kann man einfach Zend Framework
   herunterladen und erwarten das es mit ``./path/to/zf.php`` und einem Kommando funktioniert.

.. _zend.tool.extending.zend-tool-framework.cli-client.setup-starnix:

Das CLI Tool auf Unix-artigen Systemen einrichten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Das üblichste Setup in einer \*nix Umgebung ist es, ``zf.sh`` und ``zf.sh`` in das selbe Verzeichnis wie die *PHP*
Installation zu kopieren. Diese kann normalerweise in einem der folgenden Plätze gefunden werden:

.. code-block:: text
   :linenos:

   /usr/bin
   /usr/local/bin
   /usr/local/ZendServer/bin/
   /Applications/ZendServer/bin/

Um den Ort der eigenen *PHP* Installation zu finden kann man 'which php' auf der Kommandozeile ausführen. Das gibt
den Ort der *PHP* Installation zurück welche verwendet wird um in dieser Umgebung *PHP* Skripte auszuführen.

Der nächste Schritt ist es sicherzustellen das die Zend Framework Bibliothek korrekt im *PHP* ``include_path``
eingestellt wurde. Um herauszufinden wo der ``include_path`` ist, kann man ``php -i`` ausführen und nach der
``include_path`` Variable sehen, oder kompakter ``php -i | grep include_path`` ausführen. Sobald man
herausgefunden hat wo der ``include_path`` ist (er ist normalerweise etwas wie ``/usr/lib/php``,
``/usr/share/php``, ``/usr/local/lib/php``, oder so ähnlich), sollte man sicherstellen das der Inhalt des
Verzeichnisses ``/library/`` in einem der in ``include_path`` spezifizierten Verzeichnisse ist.

Sobald man diese zwei Dinge getan hat, sollte man in der Lage sein ein Kommando auszuführen und die richtige
Antwort zurück zu erhalten, wie zum Beispiel:

.. image:: ../images/zend.tool.framework.cliversionunix.png
   :align: center

Wenn man diese Art der Ausgabe nicht sieht, sollte man zurückgeben und die eigenen Einstellungen prüfen um
sicherzustellen das man alle notwendigen Teile am richtigen Ort vorhanden sind.

Es gibt eine Anzahl an alternativen Einstellungen die man erstellen kann, abhängig von der Konfiguration des
Servers, dem Zugriffslevel, oder aus anderen Gründen.

Das **alternative Setup** enthält das man den Download vom Zend Framework zusammenbehält wie er ist, und einen
Link von einem ``PATH`` Ort zur ``zf.sh`` erstellt. Was dies bedeutet ist, dass man den Inhalt des Zend Framework
Downloads in einem Ort wie ``/usr/local/share/ZendFramework`` platzieren kann, oder lokaler unter
``/home/username/lib/ZendFramework`` und einen symbolischen Link zu ``zf.sh`` erstellt.

Angenommen man will den Link in ``/usr/local/bin`` platzieren (dies könnte zum Beispiel auch für die Platzierung
des Links unter ``/home/username/bin/`` funktionieren), dan würde man ein Kommando wie das folgende platzieren:

.. code-block:: sh
   :linenos:

   ln -s /usr/local/share/ZendFramework/bin/zf.sh /usr/local/bin/zf

   # ODER (zum Beispiel)
   ln -s /home/username/lib/ZendFramework/bin/zf.sh /home/username/bin/zf

Das erstellt einen Link auf den man global von der Kommandozeile aus zugreifen kann.

.. _zend.tool.extending.zend-tool-framework.cli-client.setup-windows:

Das CLI Tool unter Windows einrichten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Das üblichste Setup in einer Windows Win32 Umgebung ist es ``zf.bat`` und ``zf.php`` in das selbe Verzeichnis wie
die *PHP* Bibliothek zu kopieren. Diese kann generell an einem der folgenden Plätze gefunden werden:

.. code-block:: text
   :linenos:

   C:\PHP
   C:\Program Files\ZendServer\bin\
   C:\WAMP\PHP\bin

Man sollte in der Lage sein ``php.exe`` von der Kommandozeile aus auszuführen. Wenn man dazu nicht in der Lage
ist, sollte man zuerst die Dokumentation prüfen welche mit der *PHP* Bibliothek mitgeliefert wird, um
sicherzustellen dass der Pfad zu ``php.exe`` in der Windows Umgebungsvariable ``PATH`` zu finden ist.

Der nächste Schritt besteht darin sicherzustellen das die Zend Framework Bibliothek richtig auf dem *PHP*
``include_path`` des Systems eingerichtet ist. Um herauszufinden wo der ``include_path`` ist, kann man ``php -i``
eingeben und nach der Variable ``include_path`` sehen, oder kompakter ``php -i | grep include_path`` ausführen
wenn man ein Cygwin Setup mit vorhandenem grep hat. Sobald man herausgefunden hat wo der ``include_path`` liegt
(das ist normalerweise etwas wie ``C:\PHP\pear``, ``C:\PHP\share``, ``C:\Program%20Files\ZendServer\share``, oder
ähnlich), sollte man sicherstellen das der Inhalt des Verzeichnisses library/ in einem vom ``include_path``
spezifizierten Verzeichnis ist.

Sobald man diese zwei Dinge getan hat, sollte man in der Lage sein ein Kommando auszuführen und die richtige
Antwort, so ähnlich wie die folgende, zu erhalten:

.. image:: ../images/zend.tool.framework.cliversionwin32.png
   :align: center

Wenn man diese Art der Ausgabe nicht sieht, sollte man zurückgehen und die Einstellungen prüfen um
sicherzustellen das man alle notwendigen Teile an den richtigen Orten hat.

Es gibt eine Anzahl an alternativen Einstellungen die man erstellen kann, abhängig von der Konfiguration des
Servers, dem Zugriffslevel, oder aus anderen Gründen.

Das **alternative Setup** enthält das man den Download vom Zend Framework zusammenbehält wie er ist, und sowohl
den System ``PATH``, als auch die ``php.ini`` Datei verändert. In der Umgebung des Benutzers muss man
``C:\Path\To\ZendFramework\bin`` hinzufügen damit die Datei ``zf.bat`` ausführbar ist. Auch die Datei ``php.ini``
ist zu verändern um sicherzustellen das ``C:\Path\To\ZendFramework\library`` im ``include_path`` liegt.

.. _zend.tool.extending.zend-tool-framework.cli-client.setup-othernotes:

Andere Einstellungs-Möglichkeiten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wenn man aus bestimmten Gründen die Zend Framework Bibliothek nicht im ``include_path`` haben will, gibt es andere
Optionen. Es gibt zwei spezielle Umgebungsvariablen welche ``zf.php`` verwendet um den Ort der Zend Framework
Installation zu erkennen.

Die erste ist ``ZEND_TOOL_INCLUDE_PATH_PREPEND``, welche den Wert der Umgebungsvariable dem ``include_path`` des
Systems (``php.ini``) voranstellt bevor der Client geladen wird.

Alternativ kann man ``ZEND_TOOL_INCLUDE_PATH`` verwenden um den ``include_path`` des System komplett zu
**ersetzen** für jene bei denen es Sinn macht, speziell für das ``zf`` Kommandozeilen-Tool.

.. _zend.tool.extending.zend-tool-framework.providers-and-manifests:

Erstellen von Providern
^^^^^^^^^^^^^^^^^^^^^^^

Generell, ist ein Provider für sich selbst gesehen, nichts weiter als eine Shell für einen Entwickler um einige
Möglichkeiten zu bündeln welche er mit den Kommandozeilen (oder anderen) Clients ausführen will. Das ist eine
Analogie für das was der "Controller" in der *MVC* Anwendung ist.

.. _zend.tool.extending.zend-tool-framework.providers-and-manifests.loading:

Wie Zend_Tool eigene Provider findet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Standardmäßig verwendet ``Zend_Tool`` den BasicLoader um alle Provider zu finden die es ausführen kann. Er
durchsucht alle Verzeichnisse des Include Pfades rekursiv und öffnet alle Dateien welche mit "Manifest.php" oder
"Provider.php" enden. Alle Klassen in diesen Dateien werden darauf durchsucht ob Sie entweder
``Zend_Tool_Framework_Provider_Interface`` oder ``Zend_Tool_Framework_Manifest_ProviderManifestable``
implementieren. Instanzen des Provider Interfaces sind für die echte Funktionalität zuständig und alle Ihre
öffentlichen Methoden kann als Provider Aktionen zugegriffen werden. Das ProviderManifestable Interface benötigt
trotzdem die Implementation einer ``getProviders()`` Methode welche ein Array an instanzierten Provider Interface
Instanzen zurückgibt.

Die folgenden Namensregeln sind darauf anzuwenden, wie man auf die Provider zugreifen kann welche vom
IncludePathLoader gefunden werden:

- Der letzte Teil des eigenen Klassennamens welcher von einem Unterstrich getrennt ist, wird für den Providernamen
  verwendet, zum Beispiel führt "My_Provider_Hello" zum Provider auf welchen mit dem Namen "hello" zugegriffen
  werden kann.

- Wenn der Provider eine Methode ``getName()`` hat, dann wird diese verwendet statt der vorherigen Methode um den
  Namen zu erkennen.

- Wenn der Provider den Präfix "Provider" hat, zum Beispiel wenn er ``My_HelloProvider`` heißt, dann wird er vom
  Namen entfernt so dass der Provider "hello" heißt.

.. note::

   Der IncludePathLoader folgt Symlinks nicht, was bedeutet das man Provider Funktionalitäten nicht in den Include
   Pfaden verlinken kann, sondern dass Sie physikalisch in den Include Pfaden vorhanden sein müssen.

.. _zend.tool.extending.zend-tool-framework.providers-and-manifests.loading.example:

.. rubric:: Provider mit einem Manifest bekanntmachen

Man kann eigene Provider bei ``Zend_Tool`` bekannt machen indem man ein Manifest anbietet, mit einer speziellen
Endung des Dateinamens von "Manifest.php". Ein Provider-Manifest ist eine Implementation von
Zend_Tool_Framework_Manifest_ProviderManifestable und benötigt die ``getProviders()`` Methode um ein Array von
instanziierten Providern zurückzugeben. Anders als unser erster eigener Provider ``My_Component_HelloProvider``
erstellen wir das folgende Manifest:

.. code-block:: php
   :linenos:

   class My_Component_Manifest
       implements Zend_Tool_Framework_Manifest_ProviderManifestable
   {
       public function getProviders()
       {
           return array(
               new My_Component_HelloProvider()
           );
       }
   }

.. _zend.tool.extending.zend-tool-framework.providers-and-manifests.basic:

Grundsätzliche Instruktionen für die Erstellung von Providern
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wenn, als Beispiel, ein Entwickler die Fähigkeit, eine Version einer Datendatei anzuzeigen, hinzufügen will mit
der seine 3rd Party Komponente arbeitet, gibt es nur eine Klasse welche der Entwickler implementieren muss.
Angenommen die Komponente wird ``My_Component`` genannt, dann würde er eine Klasse erstellen welche
``My_Component_HelloProvider`` heißt in einer Datei wleche ``HelloProvider.php`` genannt ist und irgendwo in
seinem ``include_path`` liegt. Diese Klasse würde ``Zend_Tool_Framework_Provider_Interface`` implementieren und
diese Datei würde etwa wie folgt auszusehen haben:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       implements Zend_Tool_Framework_Provider_Interface
   {
       public function say()
       {
           echo 'Hallo von meinem Provider!';
       }
   }

Bei dem obigen Code und der Annahme das der Entwickler Zugriff auf diese Funktionalität über den Konsolen-Client
haben will, würde der Aufruf wie folgt aussehen:

.. code-block:: sh
   :linenos:

   % zf say hello
   Hallo von meinem Provider!

.. _zend.tool.extending.zend-tool-framework.providers-and-manifests.response:

Das Antwort-Objekt
^^^^^^^^^^^^^^^^^^

Wie im Architektur-Abschnitt diskutiert erlaubt es ``Zend_Tool`` andere Clients für die Verwendung eigener
``Zend_Tool`` Provider zu verknüpfen. Um den unterschiedlichen Clients zu entsprechen sollte man das
Antwort-Objekt verwenden um Rückgabe-Meldungen von Providern zurückzugeben anstatt ``echo()`` oder ähnliche
Ausgabe-Mechanismen zu verwenden. Nach dem Umschreiben des Hello-Providers mit diesen Erkenntnissen sieht er wie
folgt aus:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       extends Zend_Tool_Framework_Provider_Abstract
   {
       public function say()
       {
           $this->_registry->getResponse
                           ->appendContent("Hallo von meinem Provider!");
       }
   }

Wie man sieht muss ``Zend_Tool_Framework_Provider_Abstract`` erweitert werden um Zugriff auf die Registry zu
erhalten welche die ``Zend_Tool_Framework_Client_Response`` Instanz enthält.

.. _zend.tool.extending.zend-tool-framework.providers-and-manifests.advanced:

Fortgeschrittene Informationen für die Entwicklung
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.tool.extending.zend-tool-framework.providers-and-manifests.advanced.variables:

Variablen an einen Provider übergeben
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Das obige "Hello World" Beispiel ist großartig für einfache Befehle, aber was ist mit etwas komplizierterem? Wenn
die eigenen Skripting- und Tooling-Bedürfnisse wachsen kann man die Notwendigkeit sehen dass man Variablen
akzeptiert. So wie Funktions-Signaturen Parameter haben, so können eigene Tooling-Anfragen auch Parmeter
akzeptieren.

So wie jede Tooling-Anfrage isoliert von einer Methode in einer Klasse sein kann, können auch die Parameter einer
Tooling-Anfrage in einem sehr bekanntem Platz isoliert sein. Parameter einer Aktions-Methode eines Providers
können die selben Parameter enthalten welche der eigene Client verwenden soll wenn diese Provider und
Aktions-Methode aufgerufen wird. Wenn man zum Beispiel einen Namen im oben stehenden Beispiel akzeptieren will,
würde man möglicherweise folgendes in OO Code machen:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       implements Zend_Tool_Framework_Provider_Interface
   {
       public function say($name = 'Ralph')
       {
           echo 'Hallo' . $name . ', von meinem Provider!';
       }
   }

Das obige Beispiel kann dann über die Kommandozeile ``zf say hello Joe`` aufgerufen werden. "Joe" wird dem
Provider bereitgestellt so wie ein Parameter eines Methodenaufrufs. Es ist auch zu beachten das der Parameter
optional ist, was bedeutet das er auch in der Kommandozeile optional ist, so dass ``zf say hello`` trotzdem noch
funktioniert, und auf den Standardwert "Ralph" zeigt.

.. _zend.tool.extending.zend-tool-framework.providers-and-manifests.advanced.prompt:

Den Benutzer nach einer Eingabe fragen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Es gibt Fälle in denen der Workflow des eigenen Providers es notwendig macht den Benutzer nach einer Eingabe zu
fragen. Dies kann getan werden indem der Client nach einer zusätzlich benötigten Eingabe gefragt wird indem
folgendes aufgerufen wird:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       extends Zend_Tool_Framework_Provider_Abstract
   {
       public function say($name = 'Ralph')
       {
           $nameResponse = $this->_registry
                                ->getClient()
                                ->promptInteractiveInput("Wie ist dein Name?");
           $name = $name->getContent();

           echo 'Hallo' . $name . ', von meinem Provider!';
       }
   }

Dieses Kommando wirft eine Ausnahme wenn der aktuelle Client nicht in der Lage ist interaktive Anfragen zu
behandeln. Im Falle des standardmäßigen Konsolen-Clients wird man aber danach gefragt den Namen einzugeben.

.. _zend.tool.extending.zend-tool-framework.providers-and-manifests.advanced.pretendable:

Die Ausführung einer Provider-Aktion vorbereiten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ein anderes interessantes Feature das man möglicherweise implementieren will ist die **Vorbereitung**.
Vorbereitung ist die Fähigkeit des eigenen Providers sich "vorzubereiten", wie wenn er die angefragte Kombination
von Aktion und Provider durchführt und dem Benutzer so viele Informationen wie möglich darüber zu geben was er
tun **würde** ohne es wirklich zu tun. Das kann ein wichtiger Hinweis sein wenn große Änderungen in der
Datenbank oder auf dem Dateisystem durchgeführt werden welche der Benutzer andernfalls nicht durchführen wollen
würde.

Voranstellbarkeit ist einfach zu implementieren. Es gibt zwei Teile zu diesem Feature: 1) Den Provider markieren,
das er die Fähigkeit hat "vorzubereiten", und 2) die Anfrage prüfen und sicherstellen das die aktuelle Anfrage
wirklich als "vorzubereiten" angefragt wurde. Dieses Feature wird im folgenden Code-Beispiel demonstriert.

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       extends    Zend_Tool_Framework_Provider_Abstract
       implements Zend_Tool_Framework_Provider_Pretendable
   {
       public function say($name = 'Ralph')
       {
           if ($this->_registry->getRequest()->isPretend()) {
               echo 'Ich würde Hallo zu ' . $name . ' sagen.';
           } else {
               echo 'Hallo' . $name . ', von meinem Provider!';
           }
       }
   }

Um den Provider im vorbereiteten Modus auszuführen muss nur folgendes aufgerufen werden:

.. code-block:: sh
   :linenos:

   % zf --pretend say hello Ralph
   Ich würde Hallo zu Ralph sagen.

.. _zend.tool.extending.zend-tool-framework.providers-and-manifests.advanced.verbosedebug:

Verbose und Debug Modi
^^^^^^^^^^^^^^^^^^^^^^

Man kann Provider Aktionen auch in den Modi "verbose" oder "debug" laufen lassen. Die Semantik bezüglich dieser
Aktionen muss man im Kontext des Providers implementieren. Man kann auf die Modi Debug oder Verbose wie folgt
zugreifen:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       implements Zend_Tool_Framework_Provider_Interface
   {
       public function say($name = 'Ralph')
       {
           if($this->_registry->getRequest()->isVerbose()) {
               echo "Hello::say wurde aufgerufen\n";
           }
           if($this->_registry->getRequest()->isDebug()) {
               syslog(LOG_INFO, "Hello::say wurde aufgerufen\n");
           }
       }
   }

.. _zend.tool.extending.zend-tool-framework.providers-and-manifests.advanced.configstorage:

Auf die Benutzerkonfiguration und den Speicher zugreifen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Bei Verwendung der Umgebungsvariable ``ZF_CONFIG_FILE`` oder von .zf.ini im Heimverzeichnis können
Konfigurationsparameter in jeden ``Zend_Tool`` Provider eingefügt werden. Der Zugriff auf diese Konfiguration ist
über die Registry möglich welche dem Provider übergeben wird wenn man ``Zend_Tool_Framework_Provider_Abstract``
erweitert.

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       extends Zend_Tool_Framework_Provider_Abstract
   {
       public function say()
       {
           $username = $this->_registry->getConfig()->username;
           if(!empty($username)) {
               echo "Hallo $username!";
           } else {
               echo "Hallo!";
           }
       }
   }

Die zurückgegebene Konfiguration ist vom Typ ``Zend_Tool_Framework_Client_Config`` allerdings verweisen die
magischen Methoden ``__get()`` und ``__set()`` intern auf eine ``Zend_Config`` oder den angegebenen
Konfigurationstyp.

Der Speicher erlaubt es notwendige Daten für eine spätere Referenz zu speichern. Das kann für Aufgaben bei der
Ausführung von Batches nützlich sein oder für das wiederausführen von Aufgaben. Man kann auf den Speicher auf
dem gleichen Weg zugreifen wie auf die Konfiguration:

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       extends Zend_Tool_Framework_Provider_Abstract
   {
       public function say()
       {
           $aValue = $this->_registry->getStorage()->get("myUsername");
           echo "Hallo $aValue!";
       }
   }

Die *API* des Speichers ist sehr einfach:

.. code-block:: php
   :linenos:

   class Zend_Tool_Framework_Client_Storage
   {
       public function setAdapter($adapter);
       public function isEnabled();
       public function put($name, $value);
       public function get($name, $defaultValue=null);
       public function has($name);
       public function remove($name);
       public function getStreamUri($name);
   }

.. important::

   Wenn man Provider erstellt welche Konfigurations-fähig oder Speicher-fähig sind muss man daran denken dass man
   prüfen muss ob die notwendigen Benutzerkonfigurations- oder Speicher-Schlüssel wirklich für diesen Benutzer
   existieren. Man wird keine fatalen Fehler erhalten wenn keiner von Ihnen angegeben wurde, da leere Schlüssel
   bei der Anfrage erstellt werden.

.. _zend.tool.extending.zend-tool-project:

Zend_Tool_Project Erweiterungen
-------------------------------

``Zend_Tool_Project`` bietet ein reiches Set an Funktionalitäten und Möglichkeiten welche die Aufgabe der
Erstellung neuer Provider, speziell jener welche auf ein Projekt abzielen, einfacher und besser managebar.

.. _zend.tool.extending.zend-tool-project.architecture:

Architektur-Übersicht
^^^^^^^^^^^^^^^^^^^^^

Das selbe Konzept gilt auch für Zend Framework Projekte. In Zend Framework Projekten hat man Controller, Aktionen,
Views, Modelle, Datenbanken und so weiter. Im Sinn von ``Zend_Tool`` benötigen wir einen Weg um diese Arten von
Ressourcen zu verfolgen -- deshalb ``Zend_Tool_Project``.

``Zend_Tool_Project`` ist in der Lage Projektressourcen wärend der Entwicklung eines Projekts zu verfolgen. Wenn
man, zum Beispiel, in einem Kommando einen Controller erstellt, und im nächsten Kommando eine Aktion in diesem
Controller erstellen will, muss ``Zend_Tool_Project`` über die Controllerdatei bescheid **wissen** die man
erstellt hat, damit man (in der nächsten Aktion) in der Lage ist diese Aktion daran anzuhängen. Das ist was das
Projekt aktuell hält und **zustandsbehaftet**.

Ein andere wichtiger Punkt den man über Projekte verstehen sollte ist, dass Ressourcen typischerweise in einer
hierarchischen Art orgainisiert sind. Dies zu wissen bedeutet das ``Zend_Tool_Project`` in der Lage ist das
aktuelle Projekt in eine interne Repräsentation zu serialisieren welche es erlaubt nicht nur jederzeit
festzustellen **welche** Ressourcen Teil eines Projekts sind, sondern auch **wo** Sie in Relation zu anderen
stehen.

.. _zend.tool.extending.zend-tool-project.providers:

Provider erstellen
^^^^^^^^^^^^^^^^^^

Projektspezifische Provider werden auf dem selben Weg erstellt wie reine Framework Provider, mit einer Ausnahme:
Projektprovider müssen ``Zend_Tool_Project_Provider_Abstract`` erweitern. Diese Klasse kommt mit einigen
signifikanten Funktionalitäten welche Entwicklern helfen existierende Projekte zu laden, das Profilobjekt zu
erhalten, und in der Lage zu sein das Profil zu suchen, und später dann alle Änderungen im aktuellen
Projektprofil zu speichern.

.. code-block:: php
   :linenos:

   class My_Component_HelloProvider
       extends Zend_Tool_Project_Provider_Abstract
   {
       public function say()
       {
           $profile = $this->_loadExistingProfile();

           /* ... Projektarbeiten hier durchführen */

           $this->_storeProfile();
       }
   }



.. _`http://framework.zend.com/svn/framework/standard/trunk/bin/`: http://framework.zend.com/svn/framework/standard/trunk/bin/
