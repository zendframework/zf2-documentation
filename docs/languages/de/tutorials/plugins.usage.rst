.. EN-Revision: none
.. _learning.plugins.usage:

Verwenden von Plugins
=====================

Komponenten die Plugins verwenden, verwenden typischerweise ``Zend\Loader\PluginLoader`` um Ihre Arbeit zu tun.
Diese Klasse registriert Plugins indem ein oder mehrere "Präfix Pfade" spezifiziert werden. Diese Komponente ruft
anschließend die ``load()`` Methode des PluginLoader's auf, und übergibt Ihm den Kurznamen des Plugins. Der
PluginLoader wird anschließend jeden Präfix Pfad abfragen um zu sehen ob eine Klasse passt die dem Kurznamen
entspricht. Präfix Pfade werden also LIFO Reihenfolge (Last In, First Out) durchsucht, deshalb werden jene Präfix
Pfade abgeglichen die zuletzt registriert wurden -- was es erlaubt existierende Plugins zu überladen.

Einige Beispiele werden das alles etwas aufklären.

.. _learning.plugins.usage.basic:

.. rubric:: Grundsätzliches Plugin Beispiel: Hinzufügen eines einzelnen Präfix Pfades

In diesem Beispiel nehmen wir an das einige Prüfungen geschrieben und im Verzeichnis ``foo/plugins/validators/``
wurden, und das alle Klassen den Klassenpräfix "Foo_Validate\_" teilen; diese zwei Teile von Information formen
unseren "Präfix Pfad". Weiters nehmen wir an das wir zwei Prüfungen haben, einen der "Even" genannt wird (und
sicherstellt das eine Zahl die geprüft wird gerade ist), und eine andere die "Dozens" genannt wird (und
sicherstellt das eine Zahl ein Vielfaches von 12 ist). Die drei könnten wie folgt anschauen:

.. code-block:: text
   :linenos:

   foo/
   |-- plugins/
   |   |-- validators/
   |   |   |-- Even.php
   |   |   |-- Dozens.php

Jetzt informieren wir eine ``Zend\Form\Element`` Instanz über diesen Präfix Pfad. ``Zend\Form\Element``'s
``addPrefixPath()`` Methode erwartet ein drittes Argument welches den Typ des Plugins zeigt für den der Pfad
registriert wird; in diesem Fall ist es ein "validate" Plugin.

.. code-block:: php
   :linenos:

   $element->addPrefixPath('Foo_Validate', 'foo/plugins/validators/', 'validate');

Jetzt können wir dem Element einfach den kurzen Namen der Prüfung angeben die wir verwenden wollen. Im folgenden
Beispiel verwenden wir einen Mix aus Standardprüfungen ("NotEmpty", "Int") und eigenen Prüfungen ("Even",
"Dozens").

.. code-block:: php
   :linenos:

   $element->addValidator('NotEmpty')
           ->addValidator('Int')
           ->addValidator('Even')
           ->addValidator('Dozens');

Wenn das Element geprüft werden soll, ruft es die Plugin Klasse vom PluginLoader ab. Die ersten zwei Prüfungen
werden zu ``Zend\Validate\NotEmpty`` und ``Zend\Validate\Int`` aufgelöst; die nächsten zwei werden zu
``Foo_Validate_Even`` und ``Foo_Validate_Dozens`` aufgelöst.

.. note::

   **Was passiert wenn ein Plugin nicht gefunden wird?**

   Was passiert wenn ein Plugin angefragt wird, aber der PluginLoader nicht in der Lage ist eine zu Ihm passende
   Klasse zu finden? Im obigen Beispiel, zum Beispiel, wenn wir das Plugin "Bar" mit dem Element registrieren, was
   würde dann passieren?

   Der Plugin Loader durchsucht jeden Präfix Pfad, prüft ob eine Datei gefunden wird die in diesem Pfad auf den
   Plugin Namen passt. Wenn die Datei nicht gefunden wird, geht er auf den nächsten Präfix Pfad weiter.

   Sobald der Stack von Präfix Pfaden erschöpft ist, und keine passende Datei gefunden wurde, wirft es eine
   ``Zend\Loader_PluginLoader\Exception``.

.. _learning.plugins.usage.override:

.. rubric:: Fortgeschrittene Plugin Verwendung: Überladen existierender Plugins

Eine Stärke des PluginLoaders ist dessen Verwendung eines LIFO Stacks welche es erlaubt existierende Plugins zu
überladen indem eine eigene Version lokal mit einem anderen Präfix Pfad erstellt wird, und der Präfix Pfad
später im Stack registriert wird.

Nehmen wir zum Beispiel ``Zend\View_Helper\FormButton`` an (View Helfer sind eine Form von Plugins). Dieser View
Helfer akzeptiert drei Argumente, ein Elementname (der auch als DOM Identifikator des Elements verwendet wird),
einen Wert (der als Button Label verwendet wird), und ein optionales Array an Attributen. Der Helfer erzeugt dann
das *HTML* Markup für ein Formular Eingabeelement.

Sagen wir, dass der Helfer stattdessen ein echtes *HTML* ``button`` Element erzeugen soll; dass wir nicht wollen
das der Helfer einen DOM Identifikator erzeugt, sondern statt dessen den Wert für einen CSS Klassen Selektor; und
das wir kein Interesse an der behandling eigener Attribute haben. Man könnte dies auf verschiedenen wegen
erreichen. In beiden Fällen erstellen wir eine eigene View Helfer Klasse die das Verhalten implementiert welches
wir wollen; der Unterschied liegt darin wie wir Sie benennen und aufrufen wollen.

Unser erstes Beispiel wird der Name des Elements mit einem eindeutigen Namen sein: ``Foo_View_Helper_CssButton``
welcher den Plugin Namen "CssButton" impliziert. Wärend das ein recht brauchbarer Ansatz ist, wirft es einige
Probleme auf: Wenn man bereits einen Button View Helfer im eigenen Code verwendet, muss man jetzt einges
umarbeiten; alternativ, wenn ein anderer Entwickler damit beginnt Code für diese Anwendung zu schreiben, mus er
unbeabsichtlicher Weise den Button View Helfer verwenden statt den neuen View Helfer.

Deshalb ist es better den Plugin Namen "Button" zu verwenden was uns den Klassennamen ``Foo_View_Helper_Button``
gibt. Wir registrieren den Präfix Pfad in der View:

.. code-block:: php
   :linenos:

   // Zend\View\View::addHelperPath() verwendet den PluginLoader; Trotzdem invertiert
   // er die Argumente, da er den Standardwert "Zend\View\Helper" für den Plugin
   // Präfix anbietet.
   //
   // Anbei nehmen wir an das die eigene Klasse im Verzeichnis
   // 'foo/view/helpers/' ist.
   $view->addHelperPath('foo/view/helpers', 'Foo_View_Helper');

Sobald das getan wurde, wird überall wo wir den "Button" Helfer verwenden auf die eigene
``Foo_View_Helper_Button`` Klasse verwiesen!


