.. EN-Revision: none
.. _performance.classloading:

Laden von Klassen
=================

Jeder der jemals Profiling von Zend Framework Anwendungen durchführen muß, wird sofort feststellen dass das Laden
von Klassen relativ teuer ist im Zend Framework. Zwischen der reinen Anzahl von Klassendateien die für viele
Komponenten geladen werden müssen, und der Verwendung von Plugins die keine 1:1 Verknüpfung zwischen Ihrem
Klassennamen und dem Dateisystem haben, können die Aufrufe zu ``include_once()`` und ``require_once()``
problematisch sein. Diese Kapitel versucht einige konkrete Lösungen für diese Probleme zu geben.

.. _performance.classloading.includepath:

Wie kann ich meinen include_path optimieren?
--------------------------------------------

Eine triviale Optimierung die man machen kann um die Geschwindigkeit für das Laden der Klassen zu erhöhen ist es,
auf den include_path besonders Rücksicht zu nehmen. Im speziellen, sollte man vier Dinge tun: Absolute Pfade
verwenden (oder Pfade relativ zu absoluten Pfaden), die Anzahl der Include Pfade die man definiert reduzieren, den
include_path von Zend Framework so früh wie möglich zu haben, und am Ende von include_path nur den aktuellen
Verzechnispfad inkludieren.

.. _performance.classloading.includepath.abspath:

Absolute Pfade verwenden
^^^^^^^^^^^^^^^^^^^^^^^^

Auch wenn das wie eine Mikro-Optimierung aussieht, ist es Fakt das wenn man es nicht durchführt, die Vorteile von
*PHP*'s RealPath Cache sehr klein sind, und als Ergebnis, das OpCode Caching nicht so schnell sein wird wie man
erwarten könnte.

Es gibt zwei einfache Wege um das Sicherzustellen. Erstens, kann man die Pfade in der ``php.ini``, ``httpd.conf``,
oder ``.htaccess`` Hardcoded hineinschreiben. Zweitens, kann man *PHP*'s ``realpath()`` Funktion verwendet wenn man
den include_path setzt:

.. code-block:: php
   :linenos:

   $paths = array(
       realpath(dirname(__FILE__) . '/../library'),
       '.',
   );
   set_include_path(implode(PATH_SEPARATOR, $paths);

Man **kann** relative Pfade verwenden -- solange Sie relativ zu einem absoluten Pfad sind:

.. code-block:: php
   :linenos:

   define('APPLICATION_PATH', realpath(dirname(__FILE__)));
   $paths = array(
       APPLICATION_PATH . '/../library'),
       '.',
   );
   set_include_path(implode(PATH_SEPARATOR, $paths);

Wie auch immer, selbst auf diese Art, ist es typischerweise eine triviale Aufgabe um den Pfad einfach an
``realpath()`` zu übergeben.

.. _performance.classloading.includepath.reduce:

Die Anzahl der Include Pfade die man definiert reduzieren
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Include Pfade werden in der Reihenfolge in der Sie im include_path vorkommen durchsucht. Natürlich bedeutet das,
das man ein Ergebnis schneller erhält wenn die Datei im ersten Scan gefunden wird, statt im letzten. Deswegen ist
eine offensichtliche Verbesserung wenn man einfach die Anzahl der Pfade im include_path nur auf die reduziert die
man benötigt. Man muß sich jeden include_path den man definiert hat anschauen, und feststellen ob aktuell
irgendeine Funktionalität in diesem Pfad ist, die in der eigenen Anwendung verwendet wird; wenn nicht, dann
entfernen Sie ihn.

Eine weitere Optimierung ist es Pfade zu kombinieren. Zum Beispiel folgt Zend Framework der Namenskonvention von
*PEAR*; deswegen kann man, wenn man *PEAR* Bibliotheken verwendet (oder Bibliotheken von anderen Frameworks oder
Komponentenbibliotheken die dem *PEAR* CS folgen), versuchen alle diese Bibliotheken in den gleichen include_path
zu geben. Das kann oft durchgeführt werden indem etwas einfaches wie ein SymLink auf eine oder mehrere
Bibliotheken in ein generelles Verzeichnis gelegt wird.

.. _performance.classloading.includepath.early:

Definiere den include_path zum Zend Framework so früh wie möglich
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Als Fortführung des vorherigen Vorschlags, ist eine weitere offensichtliche Optimierung die Definierung vom
include_path vom Zend Framework so früh wie möglich im include_path. In den meisten Fällen sollte er der Erste
in der Liste sein. Das stellt sicher das die Dateien die vom Zend Framework included werden schon beim Ersten Scan
gefunden werden.

.. _performance.classloading.includepath.currentdir:

Definiere das aktuelle Verzeichnis als letztes oder gar nicht
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die meisten Beispiele von include_path zeigen die Verwendung des aktuellen Verzeichnisses oder '.'. Das ist üblich
um sicherzustellen das Skripte die im gleichen Verzeichnis wie die Datei die Sie benötigt geladen werden können.
Trotzdem, zeigen die gleichen Beispiele typischerweise dieses Pfadelement als erstes Element im include_path -- was
bedeuetet das der aktuelle Verzeichnisbaum immer zuerst gescannt wird. In den meisten Fällen, wenn man Zend
Framework Anwendungen hat, ist das nicht gewünscht, und der Pfad kann ohne Probleme als letztes Element in der
Liste verschoben werden.

.. _performance.classloading.includepath.example:

.. rubric:: Beispiel: Optimierter include_path

Fügen wir also alle diese Vorschläge zusammen. Unsere Annahme wird sein, das man ein oder mehrere *PEAR*
Bibliotheken in Verbindung mit dem Zend Framework verwendet -- möglicherweise die PHPUnit und ``Archive_Tar``
Bibliotheken -- und das man offensichtlicherweise die Dateien relativ zur aktuellen Datei einfügen muß.

Zuerst, erstellen wir ein Bibliotheksverzeichnis in unserem Projekt. Innerhalb dieses Verzeichnisses, erstellen wir
einen Symlink zu unserer Zend Framework ``library/Zend`` Verzeichnis, wie auch dem notwendigen Verzeichnis von
unserer *PEAR* Installation:

.. code-block:: php
   :linenos:

   library
       Archive/
       PEAR/
       PHPUnit/
       Zend/

Das erlaubt es und unseren eigenen Blbiliothekscode hinzuzufügen wenn das notwendig werden sollte, wärend andere
verwendete Bibliotheken intakt bleiben.

Als nächstes erstellen wir unseren include_path programmtechnisch in unserer ``public/index.php`` Datei. Das
erlaubt es uns unseren Code in unserem Dateisystem zu verschieben, ohne das es notwendig ist jedesmal den
include_path zu bearbeiten.

Wir borgen uns Ideen von jedem der obigen Vorschläge aus: Wir verwenden absolute Pfade, die durch die Verwendung
von ``realpath()`` erkannt werden; wir fügen den Zend Framework so früh wie möglich in den include_path ein; wir
haben bereits Include Pfade erstellt; und wir geben das aktuelle Verzeichnis als letzten Pfad hinein. Faktisch,
machen wir es hier sehr gut -- wir werden mit nur zwei Pfaden enden.

.. code-block:: php
   :linenos:

   $paths = array(
       realpath(dirname(__FILE__) . '/../library'),
       '.'
   );
   set_include_path(implode(PATH_SEPARATOR, $paths));

.. _performance.classloading.striprequires:

Wie kann man unnötige require_once Anweisungen entfernen?
---------------------------------------------------------

Lazy Loading ist eine Optimierungstechnik die entwickelt wurde um die teure Operation des Ladens einer Klassendatei
bis zum Letztmöglichen Moment zu verzögern -- bzw., wenn ein Objekt dieser Klasse instanziiert wird, wenn eine
statische Klassenmethode aufgerufen wird, oder wenn auf eine Klassenkonstante oder statische Eigenschaft
referenziert wird. *PHP* unterstützt das durch Autoloading, welches es erlaubt ein oder mehrere Callbacks zu
definieren die in Reihenfolge aufgerufen werden um einen Klassennamen mit einer Datei zu verbinden.

Trotzdem sind die meisten Vorteile man Autoloading erwarten könnte, hinfällig wenn der Bibliothekscode weiterhin
``require_once()`` Aufrufe durchführt -- was präzise der Fall ist beim Zend Framework. Die Frage ist also: Wie
kann man diese ``require_once()`` Aufrufe entfernen um die Geschwindigkeit vom Autoloader zu maximieren?

.. _performance.classloading.striprequires.sed:

Aufrufe von require_once mit find und sed entfernen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ein einfacher Weg um ``require_once()`` Aufrufe zu entfernen ist die Verwendung der *UNIX* Utilities 'find' und
'set' in Verbindung um jeden Aufruf auszukommentieren. Führe die folgenden Anweisungen aus (wobei '%' der Shell
Prompt ist):

.. code-block:: console
   :linenos:

   % cd path/to/ZendFramework/library
   % find . -name '*.php' -not -wholename '*/Loader/Autoloader.php' \
     -not -wholename '*/Application.php' -print0 | \
     xargs -0 sed --regexp-extended --in-place 's/(require_once)/\/\/ \1/g'

Dieser Ein-Zeiler (wegen der Lesbarkeit in zwei Zeilen gebrochen) geht durch jede *PHP* Datei und sagt Ihr das jede
Instanz von 'require_once' mit '// require_once' ersetzt werden soll, was jede dieser Anweisungen effektiv
auskommentiert. (Es stellt sicher das ``require_once()`` Aufrufe innerhalb von ``Zend_Application`` und
``Zend\Loader\Autoloader`` bleiben, da diese Klassen ohne Sie nicht funktionieren.)

Dieses Kommando sollte in einem automatischen Build oder Release Prozess ganz trivial hinzugefügt werden. Es
sollte trotzdem klar sein das man, wenn man diese Technik verwendet, Autoloading verwendetn **muss**; man kann das
von der eigenen "``public/index.php``" Datei mit dem folgenden Code tun:

.. code-block:: php
   :linenos:

   require_once 'Zend/Loader/Autoloader.php';
   Zend\Loader\Autoloader::getInstance();

.. _performance.classloading.pluginloader:

Wie kann ich das Laden der Plugins beschleunigen?
-------------------------------------------------

Viele Komponenten haben Plugins, welche es erlauben eigene Klassen zu Erstellen und in der Komponente zu verwenden,
sowie bestehende Standardplugins vom Zend Framework, zu überladen. Das bietet eine wichtige Flexibilität für den
Framework, aber zu einem Preis: Das Laden der Plugins ist eine recht teure Aufgabe.

Der Pluginlader erlaubt es Klassenpräfixe / Pfadpaare zu registrieren, was es erlaubt Klassendateien in
nicht-standard Pfaden zu spezifizieren. Jeder Präfix kann mehrere mit Ihm assoziierte Pfade haben. Intern
durchläuft der Pluginlader jeden Präfix, und dann jeden Ihm angehängten Pfad, testet od die Datei existiert und
unter diesem Pfad lesbar ist. Dann lädt er Sie, und testet ob die Klasse nach der er sucht vorhanden ist. Sie man
sich vorstellen kann, kann das zu vielen Aufrufe auf das Dateisystem führen.

Multipliziert mit der anzahl der Komponenten die den PluginLoader verwenden, und man bekommt eine Idee von der
Reichweite des Problems. Zu der Zeit zu der das geschrieben wird, verwenden die folgenden Komponenten den
PluginLoader:

- ``Zend\Controller_Action\HelperBroker``: Helfer

- ``Zend\File\Transfer``: Adapter

- ``Zend\Filter\Inflector``: Filter (verwendet vom ViewRenderer Action Helfer und ``Zend_Layout``)

- ``Zend\Filter\Input``: Filter und Prüfungen

- ``Zend_Form``: Elemente, Prüfungen, Filter, Dekoratore, Captcha und File Transfer Adapter

- ``Zend_Paginator``: Adapter

- ``Zend_View``: Helfer, Filter

Wie kann man die Anzahl der so gemachten Aufrufe reduzieren?

.. _performance.classloading.pluginloader.includefilecache:

Verwenden des PluginLoaders Include-File Caches
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Zend Framework 1.7.0 fügt einen Include-File Cache zum PluginLoader hinzu. Diese Funktionalität schreibt
"``include_once()``" Aufrufe in eine Datei, welche man dann in der Bootstrap Datei einfügen (include) kann.
Wärend das einen extra ``include_once()`` Aufruf im Code bedeutet, stellt es auch sicher das der PluginLoader so
früh wie möglich zurückkehrt.

Die PluginLoader Dokumentation :ref:`enthält ein kompettes Beispiel seiner Verwendung
<zend.loader.pluginloader.performance.example>`.


