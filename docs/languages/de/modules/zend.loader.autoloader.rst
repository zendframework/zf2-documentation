.. _zend.loader.autoloader:

Der Autoloader
==============

``Zend_Loader_Autoloader`` ist eine vollständige Autoloader Lösung für den Zend Framework. Sie wurde entwickelt
um verschiedene Ziele zu lösen:

- Einen echten Namespace Autoloader bieten. (Frühere Inkarnationen waren mit Namespaces auf Benutzerebene
  verknüpft)

- Es zu erlauben eigene Callbacks als Autoloader zu registrieren und diese als Stack zu managen. (Zu der als das
  geschrieben wirde gab es einige Probleme mit *spl_autoload*, welche es nicht erlaubten einen Callback erneut zu
  registrieren wenn dieser eine Instanzmethode verwendet.)

- Er zu erlauben Namespaces optimiert zu matchen um schnellere Auflösung der Klasse zu erlauben.

``Zend_Loader_Autoloader`` implementiert ein Singleton, was es universell verwendbar macht. Das bietet die
Möglichkeit zusätzlich Autoloader von überall im eigenen Code zu registrieren wo es notwendig ist.

.. _zend.loader.autoloader.usage:

Verwenden des Autoloaders
-------------------------

Das erste Mal wenn eine Instanz des Autoloaders empfangen wird, registriert dieser sich mit *spl_autoload*. Man
kann eine Instanz erhalten indem die ``getInstance()`` Methode verwendet wird:

.. code-block:: php
   :linenos:

   $autoloader = Zend_Loader_Autoloader::getInstance();

Standardmäßig ist der Autloader so konfiguriert das er den "Zend\_" und "ZendX\_" Namespaces entspricht. Wenn man
seinen eigenen Bibliothekscode hat der seinen eigenen Namespace verwendet, kann man Ihn mit dem Autoloader
registrieren indem die ``registerNamespace()`` Methode verwendet. Wenn der eigene Blbliothekscode ein Präfix von
"My\_" hat, könnte man auch folgendes tun:

.. code-block:: php
   :linenos:

   $autoloader->registerNamespace('My_');

.. note::

   **Namespace Präfixe**

   Man sollte beachten dass das vorhergehende Beispiel "My\_" verwendet und nicht "My". Der Grund ist, das
   ``Zend_Loader_Autoloader`` als Autoloader für generelle Anwendungsfälle gedacht ist, und deshalb nicht die
   Annahme macht das ein angegebener Präfix eines Klassen Namespaces einen Unterstrich enthalten muß. Wenn der
   eigene Klassennamespace einen **enhält**, dann sollte man Ihn mit dem eigenen Namespace registrieren.

Man kann auch einen eigene Autoloader Callbacks registrieren, optional mit einem spezifischen Namespace (oder einer
Gruppe von Namespaces). ``Zend_Loader_Autoloader`` versucht zuerst die passenden zu finden bevor sein interner
Autoloading Mechanismus verwendet wird.

Man könnte, als Beispiel, ein oder mehrere eZcomponents Komponenten mit der eigenen Zend Framework Anwendung
verwenden wollen. Um deren Autoloading Möglichkeiten zu verwenden, müssen diese auf den Autoloader Stack gepusht
werden indem man ``pushAutoloader()`` verwendet:

.. code-block:: php
   :linenos:

   $autoloader->pushAutoloader(array('ezcBase', 'autoload'), 'ezc');

Das zeigt dem Autoloader das der eZcomponents Autoloader für Klassen zu verwenden ist die mit "ezc" anfangen.

Man kann die ``unshiftAutoloader()`` Methode verwenden um den Autoloader an den Anfang der Autoloader Kette hinzu
zu fügen.

Standmäßig, macht ``Zend_Loader_Autoloader`` keine Fehlerunterdrückung wenn sein interner Autoloader verwendet
wird, der seinerseits ``Zend_Loader::loadClass()`` verwendet. Die meiste Zeit ist das genau das was man will.
Trotzdem, gibt es Fälle in denen man Sie unterdrücken will. Man das mit Hilfe von ``suppressNotFoundWarnings()``
tun:

.. code-block:: php
   :linenos:

   $autoloader->suppressNotFoundWarnings(true);

Letztendlich kann es Zeiten geben in denen man will das der Autoloader irgendeinen Namespace verwendet. Zum
Beispiel verwenden die PEAR Bibliotheken keinen gemeinsamen Namespace, was es schwierig macht individuelle
Namespaces zu spezifizieren wenn viele PEAR Komponenten verwendet werden. Man kann die ``setFallbackAutoloader()``
Methode verwenden damit der Autoloader als catch-all arbeitet:

.. code-block:: php
   :linenos:

   $autoloader->setFallbackAutoloader(true);

.. note::

   **Klassen von PHP Namespaces laden**

   Beginnend mit Version 1.10.0 erlaubt Zend Framework das Laden von Klassen aus *PHP* Namespaces. Diese
   Unterstützung folgt den gleichen Richtlinien und Implementationen wie Sie in der `PHP Framework Interop Group
   PSR-0`_ Referenz Implementation gefunden werden können.

   Mit dieser Richtlinie werden die folgenden Regeln angewandt:

   - Jeder Separator für Namespaces wird zu einem ``DIRECTORY_SEPARATOR`` konvertiert wenn er vom Dateisystem
     geladen wird.

   - Jedes "\_" Zeichen im **CLASS NAME** wird zu einem ``DIRECTORY_SEPARATOR`` konvertiert. Das "\_" Zeichen hat
     keine spezielle Bedeutung im Namespace.

   - Dem voll-qualifizierte Namespace und der Klasse wird ".php" angehängt wenn Sie vom Dateisystem geladen
     werden.

   Als Beispiel:

   - ``\Doctrine\Common\IsolatedClassLoader`` =>
     ``/path/to/project/lib/vendor/Doctrine/Common/IsolatedClassLoader.php``

   - ``\namespace\package\Class_Name`` => ``/path/to/project/lib/vendor/namespace/package/Class/Name.php``

   - ``\namespace\package_name\Class_Name`` =>
     ``/path/to/project/lib/vendor/namespace/package_name/Class/Name.php``

.. _zend.loader.autoloader.zf-version:

Auswahl einer Zend Framework Version
------------------------------------

Typischerweise, verwendet man die Version des Zend Frameworks die mit dem Autoloader, den man instanziert, gekommen
ist. Trotzdem ist es oft nützlich, wenn man ein Projekt entwickelt, spezielle Versionen zu verwenden, Major und
Minor Branches, oder einfach die letzte Version. ``Zend_Loader_Autoloader`` bietet, seit Version 1.10, einige
Features um bei dieser Arbeit zu helfen.

Nehmen wir das folgende Szenario an:

- Wärend der **Entwicklung** will man die letzte Version vom Zend Framework verwenden die man installiert hat,
  damit man sicherstellen kann das die Anwendung funktioniert wenn man zwischen Versionen hochrüstet.

  Wenn man auf die **Qualitäts-Sicherung** wechselt, benötigt man etwas mehr Stabilität, sodas man die letzte
  installierte Revision einer speziellen Minor Version verwenden will.

  Letztendlich, wenn man auf die **Produktion** wechselt, will man auf eine spezielle installierte Version
  festnageln, um sicherzustellen das kein Bruch stattfinden wenn man neue Versionen des Zend Frameworks auf dem
  eigenen Server hinzufügt.

Der Autoloader erlaubt es das mit der Methode ``setZfPath()`` zu tun. Diese Methode nimmt zwei Argumente, ein
**Pfad** zu einem Set von Zend Framework Installationen, und eine **Version** die zu Verwenden ist. Sobald
ausgeführt, wird dem ``include_path`` ein Pfad vorangestellt der auf die entsprechende Zend Framework
Installationsbibliothek zeigt.

Das Verzeichnis das man als den eigenen **Pfad** spezifiziert sollte einen Pfad wie den folgenden haben:

.. code-block:: text
   :linenos:

   ZendFramework/
   |-- 1.9.2/
   |   |-- library/
   |-- ZendFramework-1.9.1-minimal/
   |   |-- library/
   |-- 1.8.4PL1/
   |   |-- library/
   |-- 1.8.4/
   |   |-- library/
   |-- ZendFramework-1.8.3/
   |   |-- library/
   |-- 1.7.8/
   |   |-- library/
   |-- 1.7.7/
   |   |-- library/
   |-- 1.7.6/
   |   |-- library/

(wobei **Pfad** auf das Verzeichnis "ZendFramework" im obigen Beispiel zeigt)

Es ist zu beachten das jedes Unterverzeichnis das Verzeichnis ``library`` enthalten sollte, welche den aktuellen
Zend Framework Bibliothekscode enthält. Die individuellen Namen der Unterverzeichnisse können Versionsnummern
sein, oder einfach die entpackten Inhalte des standardmäßigen Zend Framework Distributions Tarballs/Zipfiles.

Sehen wir uns also einige Anwendungsfälle an. Im ersten Anwendungsfall, der **Entwicklung**, wollen wir die letzte
Quellinstallation verwenden. Das kann getan werden indem man "latest" als Version übergibt:

.. code-block:: php
   :linenos:

   $autoloader->setZfPath($path, 'latest');

Im obigen Beispiel, verweist dass auf das Verzeichnis ``ZendFramework/1.9.2/library/``; das kann geprüft werden
indem man den Rückgabewert von ``getZfPath()`` prüft.

In der zweiten Situation, der **Qualitäts-Sicherung**, wollen wir auf die Minor Release 1.8 verweisen, und die
letzte Installation verwenden die wir für diese Release haben. Man kann das wie folgt durchführen:

.. code-block:: php
   :linenos:

   $autoloader->setZfPath($path, '1.8');

In diesem Fall wird das Verzeichnis ``ZendFramework/1.8.4PL1/library/`` gefunden.

Im letzten Fall, für die **Produktion**, wollen wir uns auf eine spezielle Version festnageln -- 1.7.7, da dass
vorhanden war als die Qualitäts Sicherung getestet hat, also vor unserem eigenen Release.

.. code-block:: php
   :linenos:

   $autoloader->setZfPath($path, '1.7.7');

Logischerweise wird das Verzeichnis ``ZendFramework/1.7.7/library/`` gefunden.

Man diese Werte auch in der Konfigurationsdatei spezifizieren die man mit ``Zend_Application`` verwendet. Um das zu
tun, muss man die folgenden Informationen spezifizieren:

.. code-block:: ini
   :linenos:

   [production]
   autoloaderZfPath = "path/to/ZendFramework"
   autoloaderZfVersion = "1.7.7"

   [qa]
   autoloaderZfVersion = "1.8"

   [development]
   autoloaderZfVersion = "latest"

Die unterschiedlichen Umgebungssektionen sind zu beachten, und die verschiedenen Versionen die in jeder Umgebung
spezifiziert werden; diese Faktoren erlauben ``Zend_Application`` den Autoloader entsprechend zu konfigurieren.

.. warning::

   **Implikationen für die Geschwindigkeit**

   Für die beste Performance, sollte man dieses Feature entweder nicht verwenden, oder eine spezielle Zend
   Framework Version spezifizieren (z.B. nicht "latest", eine Major Revision wie "1", oder eine Minor Revision wie
   "1.8"). Andernfalls muss der Autoloader die angebotenen Pfade nach Verzeichnissen suchen welche diesem Kriterium
   entsprechen -- manchmal eine teure Operation die für jede Anfrage durchgeführt wird.

.. _zend.loader.autoloader.interface:

Das Autoloader Interface
------------------------

Neben der Möglichkeit eigene Callbacks als Autoloader zu spezifizieren, definiert Zend Framework auch ein
Interface für Autoloading Klassen, ``Zend_Loader_Autoloader_Interface``, das implementiert werden kann:

.. code-block:: php
   :linenos:

   interface Zend_Loader_Autoloader_Interface
   {
       public function autoload($class);
   }

Wenn das Interface verwendet wird, kann man einfach eine Klasseninstanz an ``Zend_Loader_Autoloader``'s
``pushAutoloader()`` und ``unshiftAutoloader()`` Methoden übergeben:

.. code-block:: php
   :linenos:

   // Angenommen Foo_Autoloader implementiert Zend_Loader_Autoloader_Interface:
   $foo = new Foo_Autoloader();

   $autoloader->pushAutoloader($foo, 'Foo_');

.. _zend.loader.autoloader.reference:

Autoloader Referenz
-------------------

Anbei kann ein Wegweiser für die Methoden gefunden werden die in ``Zend_Loader_Autoloader`` vorhanden sind.

.. _zend.loader.autoloader.reference.api:

.. table:: Zend_Loader_Autoloader Methoden

   +---------------------------------------------+------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Methode                                      |Rückgabewert                  |Parameter                                                                                                                                                            |Beschreibung                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
   +=============================================+==============================+=====================================================================================================================================================================+=================================================================================================================================================================================================================================================================================================================================================================================================================================================================================+
   |getInstance()                                |Zend_Loader_Autoloader        |N/A                                                                                                                                                                  |empfängt die Singleton Instanz von Zend_Loader_Autoloader. Beim ersten Empfang registriert sich diese selbst bei spl_autoload. Diese Methode ist statisch.                                                                                                                                                                                                                                                                                                                       |
   +---------------------------------------------+------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |resetInstance()                              |void                          |N/A                                                                                                                                                                  |Setzt den Status der Singleton Instanz von Zend_Loader_Autoloader auf den originalen Status zurück, de-registriert alle Autoloader Callbacks und alle registrierten Namespaces.                                                                                                                                                                                                                                                                                                  |
   +---------------------------------------------+------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |autoload($class)                             |string|FALSE                  |$class, Benötigt. Der String eines Klassennamens der geladen werden soll.                                                                                            |Versucht einen Klassennamen zu einer Datei aufzulösen und diese zu laden.                                                                                                                                                                                                                                                                                                                                                                                                        |
   +---------------------------------------------+------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setDefaultAutoloader($callback)              |Zend_Loader_Autoloader        |$callback, Benötigt.                                                                                                                                                 |Spezifiziert einen alternativen PHP Callback der für die standardmäßige Autoloader Implementation verwendet werden soll.                                                                                                                                                                                                                                                                                                                                                         |
   +---------------------------------------------+------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getDefaultAutoloader()                       |callback                      |N/A                                                                                                                                                                  |Empfängt die standardmäßige Autoloader Implementation; standardmäßig ist das Zend_Loader::loadClass().                                                                                                                                                                                                                                                                                                                                                                           |
   +---------------------------------------------+------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setAutoloaders(array $autoloaders)           |Zend_Loader_Autoloader        |$autoloaders, Benötigt.                                                                                                                                              |Setzt eine Liste von konkreten Autoloadern für deren Verwendung in den Autoloader Stack. Jedes Element im Autoloader Array muß ein PHP Callback sein.                                                                                                                                                                                                                                                                                                                            |
   +---------------------------------------------+------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getAutoloaders()                             |Array                         |N/A                                                                                                                                                                  |Empfängt den internen Autoloader Stack.                                                                                                                                                                                                                                                                                                                                                                                                                                          |
   +---------------------------------------------+------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getNamespaceAutoloaders($namespace)          |Array                         |$namespace, Benötigt                                                                                                                                                 |Holt alle Autoloader die registriert wurden um mit einem spezifischen Namespace geladen zu werden.                                                                                                                                                                                                                                                                                                                                                                               |
   +---------------------------------------------+------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |registerNamespace($namespace)                |Zend_Loader_Autoloader        |$namespace, Benötigt.                                                                                                                                                |Registriert ein oder mehrere Namespaces mit dem standardmäßigen Autoloader. Wenn $namespace ein String ist, registriert er diesen Namespace; wenn er ein Array von Strings ist, registriert er jeden als Namespace.                                                                                                                                                                                                                                                              |
   +---------------------------------------------+------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |unregisterNamespace($namespace)              |Zend_Loader_Autoloader        |$namespace, Benötigt.                                                                                                                                                |De-Registriert ein oder mehrere Namespaces vom standardmäßigen Autoloader. Wenn $namespace ein String ist, de-registriert er diesen Namespace; wenn er ein Array von Strings ist, de-registriert er jeden davon als Namespace.                                                                                                                                                                                                                                                   |
   +---------------------------------------------+------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getRegisteredNamespaces()                    |Array                         |N/A                                                                                                                                                                  |Gibt ein Array aller Namespaces zurück die mit dem standardmäßigen Autoloader registriert sind.                                                                                                                                                                                                                                                                                                                                                                                  |
   +---------------------------------------------+------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |suppressNotFoundWarnings($flag = null)       |boolean|Zend_Loader_Autoloader|$flag, Optional.                                                                                                                                                     |Setzt oder Empfängt den Wert des Flags das verwendet wird um anzuzeigen ob die standardmäßige Autoloader Implementation "file not found" Warnungen unterdrücken soll oder nicht. Wenn keine Argumente oder ein NULL Wert übergeben wird, wird ein Boolscher Wert zurückgegeben der den Status des Flags anzeigt; wenn ein Boolean übergeben wurde, wird das Flag auf den Wert gesetzt und die Autoloader Instanz wird zurückgegeben (um die Verkettung von Methoden zu erlauben).|
   +---------------------------------------------+------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setFallbackAutoloader($flag)                 |Zend_Loader_Autoloader        |$flag, Benötigt.                                                                                                                                                     |Setzt den Wert des Flags das verwendet wird um anzuzeigen ob der standardmäßige Autoloader als Fallback, oder Catch-All Autoloader für alle Namespaces verwendet werden soll.                                                                                                                                                                                                                                                                                                    |
   +---------------------------------------------+------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |isFallbackAutoloader()                       |Boolean                       |N/A                                                                                                                                                                  |Empfängt den Wert des Flags das verwendet wird um anzuzeigen ob der standardmäßige Autoloader als Fallback, oder Catch-All Autoloader für alle Namespaces verwendet wird. Standardmäßig ist er FALSE.                                                                                                                                                                                                                                                                            |
   +---------------------------------------------+------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getClassAutoloaders($class)                  |Array                         |$class, Benötigt.                                                                                                                                                    |Gibt eine Liste von Namespaced Autoloadern zurück die der angegebenen Klasse potentiell entsprechen. Wenn keine passt, werden alle globalen (nicht ge-namespaceten Autoloader) zurückgegeben.                                                                                                                                                                                                                                                                                    |
   +---------------------------------------------+------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |unshiftAutoloader($callback, $namespace = '')|Zend_Loader_Autoloader        |$callback, Benötigt. Ein gültiger PHP Callback. $namespace, Optional. Ein String der einen Klassenpräfix Namespace repräsentiert.                                    |Fügt eine konkrete Autoloader Implementation an den Anfang des Autoloader Stacks hinzu. Wenn ein Namespace angegeben wird, wird dieser Namespace verwendet um optimistischerweise zu passen; andernfalls wird angenommen das der Autoloader ein globaler Autoloader ist.                                                                                                                                                                                                         |
   +---------------------------------------------+------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |pushAutoloader($callback, $namespace = '')   |Zend_Loader_Autoloader        |$callback, Benötigt. Ein gültiger PHP Callback $namespace, Optional. Ein String der einen Klassenpräfix Namespace repräsentiert.                                     |Fügt eine konkrete Autoloader Implementation an das Ende des internen Autoloader Stacks hinzu. Wenn ein Namespace angegeben wird, wird dieser Namespace verwendet um optimistischerweise zu passen; andernfalls wird angenommen das der Autoloader ein globaler Autoloader ist.                                                                                                                                                                                                  |
   +---------------------------------------------+------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |removeAutoloader($callback, $namespace = '') |Zend_Loader_Autoloader        |$callback, Benötigt. Ein gültiger PHP Callback $namespace, Optional. Ein String der einen Klassenpräfix Namespace repräsentiert oder ein Array von Namespace Strings.|Entfernt eine konkrete Autoloader Implementation vom internen Autoloader Stack. Wenn ein Namespace oder mehrere Namespaces angegeben werden, wird der Callback nur vom angegebenen Namespace oder den angegebenen Namespaces entfernt.                                                                                                                                                                                                                                           |
   +---------------------------------------------+------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+



.. _`PHP Framework Interop Group PSR-0`: http://groups.google.com/group/php-standards/web/psr-0-final-proposal
