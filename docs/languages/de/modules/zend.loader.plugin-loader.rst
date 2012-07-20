.. _zend.loader.pluginloader:

Plugins laden
=============

Eine Anzahl von Zend Framework Komponenten ist steckbar, und erlaubt es Funktionen dynamisch zu laden durch die
Angabe eines Klassenpräfixes und einem Pfad zu den Klassendaten die nicht notwendigerweise im ``include_path``
sind, oder nicht notwendigerweise den traditionellen Namenskonventionen folgen. ``Zend_Loader_PluginLoader`` bietet
übliche Funktionalitäten für diesen Prozess.

Die grundsätzliche Verwendung vom ``PluginLoader`` folgt den Namenskonventionen vom Zend Framework mit einer
Klasse pro Datei, der Verwendung von Unterstrichen als Verzeichnistrenner bei der Auflösung von Pfaden. Es erlaubt
die Übergabe eines optionalen Klasenpräfixes der vorangestellt wird, wenn eine bestimmte Pluginklasse geladen
wird. Zusätzlich können Pfade in LIFO Reihenfolge durchsucht werden. Die LIFO Suche und der Klassen Präfix
erlaubt es für die Plugins Namensräumen zu definieren, und auf diese Weise Plugins zu überladen die vorher
registriert wurden.

.. _zend.loader.pluginloader.usage:

Grundsätzliche Verwendung
-------------------------

Nehmen wir zuerst die folgende Verzeichnis Struktur und Klassendateien an, und dass das oberste Verzeichnis und das
Library Verzeichnis im include_path sind:

.. code-block:: text
   :linenos:

   application/
       modules/
           foo/
               views/
                   helpers/
                       FormLabel.php
                       FormSubmit.php
           bar/
               views/
                   helpers/
                       FormSubmit.php
   library/
       Zend/
           View/
               Helper/
                   FormLabel.php
                   FormSubmit.php
                   FormText.php

Jetzt wird ein Plugin Lader erstellt um die verschiedenen vorhandenene View Helfer Repositories anzusprechen:

.. code-block:: php
   :linenos:

   $loader = new Zend_Loader_PluginLoader();
   $loader->addPrefixPath('Zend_View_Helper', 'Zend/View/Helper/')
          ->addPrefixPath('Foo_View_Helper',
                          'application/modules/foo/views/helpers')
          ->addPrefixPath('Bar_View_Helper',
                          'application/modules/bar/views/helpers');

Anschließend kann ein gegebener View Helfer geladen werden indem nur der Teil des Klassennamens verwendet wird der
dem Präfix folgt wie er definiert wurde als die Pfade hinzugefügt wurden:

.. code-block:: php
   :linenos:

   // lädt den 'FormText' Helfer:
   $formTextClass = $loader->load('FormText'); // 'Zend_View_Helper_FormText';

   // lädt den 'FormLabel' Helfer:
   $formLabelClass = $loader->load('FormLabel'); // 'Foo_View_Helper_FormLabel'

   // lädt den 'FormSubmit' Helfer:
   $formSubmitClass = $loader->load('FormSubmit'); // 'Bar_View_Helper_FormSubmit'

Sobald die Klasse geladen wurde, kann diese Instanziiert werden.

.. note::

   **Mehrere Pfade können für einen gegebenen Präfix registriert werden**

   In einigen Fällen kann es gewünscht sein den gleichen Präfix für mehrere Pfade zu verwenden.
   ``Zend_Loader_PluginLoader`` registriert aktuell ein Array von Pfaden für jeden gegebenen Präfix; der zuletzt
   resistrierte wird als erste geprüft. Das ist teilweise nützlich wenn Inkubator Komponenten verwendet werden.

.. note::

   Optional kann ein Array von Präfix / Pfad Paaren angegeben werden (oder Präfix / Pfade -- Plural, Pfade sind
   erlaubt) und als Parameter dem Kontruktor übergeben werden:

   .. code-block:: php
      :linenos:

      $loader = new Zend_Loader_PluginLoader(array(
          'Zend_View_Helper' => 'Zend/View/Helper/',
          'Foo_View_Helper'  => 'application/modules/foo/views/helpers',
          'Bar_View_Helper'  => 'application/modules/bar/views/helpers'
      ));

``Zend_Loader_PluginLoader`` erlaubt es auch optional Plugins über Plugin-fähige Objekte zu teilen, ohne das eine
Singleton Instanz verwendet werden muß. Das wird durch eine statische Registrierung ermöglicht. Der Name des
Registry muß bei der Instanziierung als zweiter Parameter an den Konstruktor übergeben werden:

.. code-block:: php
   :linenos:

   // Speichere Plugins in der statischen Registry 'foobar':
   $loader = new Zend_Loader_PluginLoader(array(), 'foobar');

Andere Komponenten die den ``PluginLoader`` instanziieren un den gleichen Registry Namen verwenden haben dann
Zugriff auf bereits geladene Pfade und Plugins.

.. _zend.loader.pluginloader.paths:

Plugin Pfade manipulieren
-------------------------

Das Beispiel der vorherigen Sektion zeigt wie Pfade zu einem Plugin Loader hinzugefügt werden können. Aber was
kann getan werden um herauszufinden ob ein Pfad bereits geladen, entfernt oder anderes wurde?

- ``getPaths($prefix = null)`` gibt alle Pfade als Präfix / Pfad Paare zurück wenn kein ``$prefix`` angegeben
  wurde, oder nur die registrierten Pfade für einen gegebenen Präfix wenn ein ``$prefix`` vorhanden ist.

- ``clearPaths($prefix = null)`` löscht standardmäßig alle registrierten Pfade, oder nur die mit einem gegebenen
  Präfix assoziierten, wenn ``$prefix`` angegeben wurde und dieser im Stack vorhanden ist.

- ``removePrefixPath($prefix, $path = null)`` erlaubt das selektive löschen eines speziellen Pfades der mit einem
  gegebenen Präfix assoziiert ist. Wenn ``$path`` nicht angegeben wurde, werden alle Pfade für diesen Präfix
  entfernt. Wenn ``$path`` angegeben wurde und dieser für den Präfix existiert, dann wird nur dieser Pfad
  entfernt.

.. _zend.loader.pluginloader.checks:

Testen auf Plugins und Klassennamen erhalten
--------------------------------------------

Hier und da soll einfach eruiert werden ob eine Pluginklasse bereits geladen wurde bevor eine Aktion ausgeführt
wird. ``isLoaded()`` nimmt einen Pluginnamen und gibt den Status zurück.

Ein anderer üblicher Fall für das ``PluginLoader`` ist das eruieren des voll qualifizierten Plugin Klassennamens
von geladenen Klassen; ``getClassName()`` bietet diese Funktionalität. Typischerweise wird dieses in Verbindung
mit ``isLoaded()`` verwendet:

.. code-block:: php
   :linenos:

   if ($loader->isLoaded('Adapter')) {
       $class   = $loader->getClassName('Adapter');
       $adapter = call_user_func(array($class, 'getInstance'));
   }

.. _zend.loader.pluginloader.performance:

Bessere Performance für Plugins erhalten
----------------------------------------

Das Laden von Plugins kann eine teure Operation sein. Im Innersten muß es durch jeden Präfix springen, dann durch
jeden Pfad dieses Präfixes, solange bis es eine passende Datei findet -- und welche die erwartete Klasse
definiert. In Fällen wo die Datei existiert aber die Klasse nicht definiert ist, wird ein Fehler auf dem *PHP*
Fehlerstack hinzugefügt, was auch eine teure Operation ist. Die Frage die sich stellt lautet also: Wie kann man
die Flexibilität der Plugins behalten und auch die Performance sicherstellen?

``Zend_Loader_PluginLoader`` bietet ein optional einschaltbares Feature für genau diese Situation, einen
integrierten Cache für die Klassendateien. Wenn er aktiviert wird, erstellt er eine Datei die alle erfolgreichen
Includes enthält welche dann von der Bootstrap Datei aus aufgerufen werden kann. Durch Verwendung dieser
Strategie, kann die Performance für Produktive Server sehr stark verbessert werden.

.. _zend.loader.pluginloader.performance.example:

.. rubric:: Verwendung des integrierten Klassendatei Caches des PluginLoaders

Um den integrierten Klassendatei Cache zu verwenden muß einfach der folgende Code in die Bootstrap Datei
eingefügt werden:

.. code-block:: php
   :linenos:

   $classFileIncCache = APPLICATION_PATH . '/../data/pluginLoaderCache.php';
   if (file_exists($classFileIncCache)) {
       include_once $classFileIncCache;
   }
   Zend_Loader_PluginLoader::setIncludeFileCache($classFileIncCache);

Natürlich, veriiert der Pfad und der Dateiname basieren auf den eigenen Bedürfnissen. Dieser Code sollte so früh
wie möglich vorhanden sein um sicherzustellen das Plugin-basierende Komponenten davon Verwendung machen können.

Wärend der Entwicklung kann es gewünscht sein den Cache auszuschalten. Eine Methode um das zu tun ist die
Verwendung eines Konfigurationsschlüsses um festzustellen ob der PluginLoader cachen soll oder nicht.

.. code-block:: php
   :linenos:

   $classFileIncCache = APPLICATION_PATH . '/../data/pluginLoaderCache.php';
   if (file_exists($classFileIncCache)) {
       include_once $classFileIncCache;
   }
   if ($config->enablePluginLoaderCache) {
       Zend_Loader_PluginLoader::setIncludeFileCache($classFileIncCache);
   }

Diese Technik erlaubt es die Änderungen in der Konfigurationsdatei zu belassen und nicht im Code.


