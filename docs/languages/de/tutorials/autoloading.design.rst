.. EN-Revision: none
.. _learning.autoloading.design:

Ziele und Design
================

.. _learning.autoloading.design.naming:

Konventionen für Klassennamen
-----------------------------

Um das Autoloaden im Zend Framework zu verstehen, muss man zuerst die Abhängigkeit zwischen Klassennamen und
Klassendateien verstehen.

Zend Framework hat sich eine Idee von `PEAR`_ geborgt wobei Klassennamen eine 1:1 Beziehung zum Dateisystem haben.
Einfach gesagt, der Unterstrich ("\_") wird durch einen Verzeichnis Separator ersetzt um den Pfad zur Datei
aufzulösen, und anschließend wird der Suffix "``.php``" hinzugefügt. Zum Beispiel würde die Klasse
"``Foo_Bar_Baz``" mit "``Foo/Bar/Baz.php``" auf dem Dateisystem korrespondieren. Die Annahme ist auch, das die
Klassen über *PHP*'s ``include_path`` Einstellung aufgelöst werden kann, welche es sowohl ``include()`` als auch
``require()`` erlaubt den Dateinamen über einen relativen Pfad Lookup im ``include_path`` zu finden.

Zusätzlich, bei *PEAR* wie auch im `PHP Projekt`_, verwenden und empfehlen wir die Verwendung eines Hersteller
oder Projekt Präfixes für den eigenen Code. Was das bedeutet ist, dass alle Klassen die man schreibt den gleichen
gemeinsamen Klassenpräfix teilen; zum Beispiel hat jeder Code im Zend Framework den Präfix "Zend\_". Diese
Namenskonvention hilft Namenskollisionen zu verhindern. Im Zend Framework referieren wir hierzu oft als "Namespace"
Präfix; man sollte darauf achten das man dies nicht mit *PHP*'s nativer Namespace Implementation verwechselt.

Zend Framework folgt diesen einfachen Regeln intern, und unser Coding Standard empfiehlt dass man dies in jedem
Bibliotheks Code macht.

.. _learning.autoloading.design.autoloader:

Autoloader Konventionen und Design
----------------------------------

Zend Framework's unterstützung für das Autoloaden, welche primär über ``Zend_Loader_Autoloader`` angeboten
wird, hat die folgenden Ziele und Design Elemente:

- **Namespace Abgleich anbieten**: Wenn der Namespace Präfix der Klasse nicht in der Liste der registrierten
  Namespaces ist, wird sofort ``FALSE`` zurückgegeben. Das erlaubt es einen optimistischeren Abgleich anzubieten,
  sowie als Fallback für andere Autoloader zu fungieren.

- **Erlaubt dem Autoloader als Fallback Autoloader zu arbeiten**: Im Falle das ein Team sehr weit verbreitet ist,
  oder ein unbekanntes Set von Namespace Präfixes verwendet, sollte der Autoloader trotzdem konfigurierbar sein
  damit er versucht jedem Namespace Präfix zu entsprechen. Es sollte trotzdem erwähnt werden das diese Praxis
  nicht empfohlen wird, da Sie auch zu unnötigen Lookups führt.

- **Erlaubt es Fehlerunterdrückung zu wechseln**: Wir denken -- und die größere *PHP* Community tut das auch --
  dass die Fehlerunterdrückung eine schlechte Idee ist. Sie ist teuer, und maskiert die rechten Probleme der
  Anwendung. Deswegen sollte sie standardmäßig ausgeschaltet sein. Trotzdem, wenn ein Entwickler darauf
  **besteht** das Sie eingeschaltet wenn soll, erlauben wir es Sie einzuschalten.

- **Erlaubt spezielle eigene Callbacks für Autoloading**: Einige Entwickler wollen ``Zend_Loader::loadClass()``
  für das Autoloaden nicht, aber trotzdem Zend Framework's Mechanismus hierfür verwenden.
  ``Zend_Loader_Autoloader`` erlaubt es einen alternativen Callback für das Autoloaden zu spezifizieren.

- **Erlaubt die Manipulation der Autload Callback Kette von SPL**: Der Zweck hiervon ist es die Spezifikation von
  zusätzlichen Autoloadern zu verwenden -- zum Beispiel müssen Ressource Lader für Klassen keine 1:1
  Entsprechung zum Dateisystem haben -- und Sie vor oder nach dem primären Zend Framework Autoloader zu
  registrieren.



.. _`PEAR`: http://pear.php.net/
.. _`PHP Projekt`: http://php.net/userlandnaming.tips
