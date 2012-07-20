.. _learning.autoloading.usage:

Grundsätzliche Verwendung von Autoloadern
=========================================

Jetzt da wir verstehen was Autoloading ist, und was die Ziele und das Design von Zend Framework's Autoloading
Lösung sind, schauen wir und an wie ``Zend_Loader_Autoloader`` verwendet wird.

Im einfachsten Fall wird die Klasse einfach mit "require" verwendet und anschließend instanziert. Da
``Zend_Loader_Autoloader`` ein Singleton ist (aus dem Grund da auch der *SPL* Autoloader eine einzelne Ressource
ist) verwenden wir ``getInstance()`` um eine Instanz zu erhalten.

.. code-block:: php
   :linenos:

   require_once 'Zend/Loader/Autoloader.php';
   Zend_Loader_Autoloader::getInstance();

Standardmäßig erlaubt dies das Laden jeder Klasse mit dem Klassen Namespace Präfix "Zend\_" oder "ZendX\_",
solange Sie im eigenen ``include_path`` liegen.

Was passiert wenn man andere Namespace Präfix verwenden will? Der beste und einfachste Weg ist der Aufruf der
``registerNamespace()`` Methode auf der Instanz. Man kann einen einzelnen Namespace Präfix übergeben, oder ein
Array von Ihnen:

.. code-block:: php
   :linenos:

   require_once 'Zend/Loader/Autoloader.php';
   $loader = Zend_Loader_Autoloader::getInstance();
   $loader->registerNamespace('Foo_');
   $loader->registerNamespace(array('Foo_', 'Bar_'));

Alternativ kann man ``Zend_Loader_Autoloader`` sagen das es als "fallback" Autoloader arbeiten soll. Das bedeutet
das er versuchen wird jede Klasse aufzulösen unabhängig vom Namespace Präfix.

.. code-block:: php
   :linenos:

   $loader->setFallbackAutoloader(true);

.. warning::

   **Ein Fallback Autloader sollte nicht verwendet werden**

   Wärend es nützlich erscheint ``Zend_Loader_Autoloader`` als Fallback Autoloader zu verwenden, empfehlen wir
   diese Praxis nicht.

   Intern verwendet ``Zend_Loader_Autoloader`` ``Zend_Loader::loadClass()`` um Klassen zu laden. Diese Methode
   verwendet ``include()`` um zu versuchen die gegebene Klassendatei zu laden. ``include()`` gibt ein boolsches
   ``FALSE`` zurück wenn es nicht erfolgreich war -- löst aber auch eine *PHP* Warnung aus. Der letztere Fakt
   kann zu einigen Problemen führen:

   - Wenn ``display_errors`` aktiviert ist, ist die Warnung in der Ausgabe enthalten.

   - Abhängig vom ``error_reporting`` Level den man ausgewählt hat, könnte es auch die Logs zuschütten.

   Man kann die Fehlermeldungen unterdrücken (die Dokumentation von ``Zend_Loader_Autoloader`` gibt Details), aber
   man sollte beachten die Unterdrückung nur relevant ist wenn ``display_errors`` aktiviert ist; das Fehler Log
   wird die Meldung immer zeigen. Aus diesem Grund empfehlen wir die Namespace Präfixe welche der Autoloader
   behandeln soll, immer zu konfigurieren.

.. note::

   **Namespace Präfixe vs PHP Namespaces**

   Wärend dies geschrieben wurde, wurde *PHP* 5.3 herausgebracht. Mit dieser Version unterstützt *PHP* jetzt
   offiziell Namespaces.

   Trotzdem ist Zend Framework auf vor *PHP* 5.3 im Einsatz, und deshalb auch Namespaces. Wenn wir im Zend
   Framework auf "Namespaces" verweisen, verweisen wir auf eine Praxis bei der Klassen ein Hersteller "Namespace"
   vorangestellt wird. Als Beispiel wird allen Zend Framework Klassen "Zend\_" vorangestellt -- das ist unser
   Hersteller "Namespace".

   Zend Framework plant die native Unterstützung von *PHP* Namespaces im Autoloader in zukünftigen Versionen, und
   seine eigene Bibliothek wird Namespaces beginnend mit Version 2.0.0 verwenden.

Wenn man eigene Autoloader hat, die man mit Zend Framework verwenden will -- möglicherweise einen Autoloader von
einer anderen Bibliothek die man verwendet -- kann man das mit ``Zend_Loader_Autoloader``'s ``pushAutoloader()``
und ``unshiftAutoloader()`` Methoden durchführen. Diese Methoden stellen Autoloader einer Kette voran welche
aufgerufen wird, oder hängen Sie an, bevor Zend Framework's interner autoloading Mechanismus ausgeführt wird.
Dieser Ansatz bietet die folgenden Vorteile:

- Jede Methode nimmt ein zweites optionales Argument entgegen, einen Klassen Namespace Präfix. Dieser kann
  verwendet werden um anzuzeigen das der angegebene Autoloader nur verwendet werden soll wenn nach Klassen mit dem
  angegebenen Klassenpräfix gesehen wird. Wenn die aufgelöste Klasse diesen Präfix nicht hat, wird der
  Autoloader übergangen -- was zu Verbesserungen der Geschwindigkeit führen kann.

- Wenn man ``spl_autoload()``'s Registry verändern muss, können alle Autoloader welche Callbacks sind und auf
  Methoden einer Instanz sind, Probleme verursachen da ``spl_autoload_functions()`` nicht exakt die gleichen
  Callbacks zurückgibt. ``Zend_Loader_Autoloader`` hat keine entsprechenden Begrenzungen.

Autoloader welche auf diesem Weg gemanaged werden können alle gültigen *PHP* Callbacks sein.

.. code-block:: php
   :linenos:

   // Die Funktion 'my_autoloader' dem Stack voranstellen,
   // um Klassen mit dem Präfix 'My_' zu managen:
   $loader->pushAutoloader('my_autoloader', 'My_');

   // Die statische Methode Foo_Loader::autoload() dem Stack anhängen,
   // um Klassen mit dem Präfix 'Foo_' zu managen:
   $loader->unshiftAutoloader(array('Foo_Loader', 'autoload'), 'Foo_');


