.. _zend.layout.advanced:

Erweiterte Verwendung von Zend_Layout
=====================================

``Zend_Layout`` hat eine Vielzahl an Verwendungsmöglichkeiten für den fortgeschrittenen Entwickler der es für
seine unterschiedlichen View Implementationen, Dateisystem Layouts, und anderes adaptieren will.

Die Hauptpunkte der Erweiterung sind:

- **Eigene View Objekte.** ``Zend_Layout`` erlaubt es jede Klasse zu verwenden die ``Zend_View_Interface``
  implementiert.

- **Eigene Front Controller Plugins.** ``Zend_Layout`` wird mit einem Standard Front Controller Plugin ausgeliefert
  der das Layout automatisch darstellt bevor die Antwort zurückgegeben wird. Es kann ein eigenes Plugin verwendet
  werden.

- **Eigene Action Helfer.** ``Zend_Layout`` wird mit einem Standard Action Helfer ausgeliefert der für die meiden
  Zwecke ausreichend sein sollte da er ein dummer Proxy für das Layout Objekt selbst ist.

- **Eigene Auflösung von Layout Skript Pfaden**. ``Zend_Layout`` erlaubt es einen eigenen
  :ref:`Beugungsmechanismum <zend.filter.inflector>` für die Auflösung der Layout Skript Pfade zu verwenden, oder
  einfach die beigefügte Beugung zu verändern und eigene Beugungsregeln zu spezifizieren.

.. _zend.layout.advanced.view:

Eigene View Objekte
-------------------

``Zend_Layout`` erlaubt es jede Klasse für die Darstellung der Layout Skripte zu verwenden die
``Zend_View_Interface`` implementiert oder ``Zend_View_Abstract`` erweitert. Es muß einfach das eigene View Objekt
als Parameter dem Konstruktor/``startMvc()`` übergeben werden, oder es mit der ``setView()`` Zugriffsmethode
gesetzt werden:

.. code-block:: php
   :linenos:

   $view = new My_Custom_View();
   $layout->setView($view);

.. note::

   **Nicht alle Zend_View Implementationen sind gleich**

   Wärend es ``Zend_Layout`` erlaubt jede Klasse zu verwenden die ``Zend_View_Interface`` implementiert, können
   Fälle auftreten in denen es nicht möglich ist die verschiedenen ``Zend_View`` Helfer anzupassen, speziell die
   Layout und :ref:`Platzhalter <zend.view.helpers.initial.placeholder>` Helfer. Das ist weil ``Zend_Layout`` die
   Variablen die im Objekt gesetzt werden über sich selbst und :ref:`Platzhalter
   <zend.view.helpers.initial.placeholder>` bereitstellt.

   Wenn eine eigene ``Zend_View`` Implementation verwendet werden soll die diese Helfer nicht unterstützt, muß
   ein Weg gefunden werden um die Layout Variablen in die View zu bekommen. Das kann entweder durch die Erweiterung
   vom ``Zend_Layout`` Objekt und der Anpassung der ``render()`` Methode zur Übergabe von Variablen zur View
   geschehen, oder durch die Erstellung einer eigenen Plugin Klasse die diese vor der Darstellung des Layouts
   übergibt.

   Alternativ kann auf diese Variablen, wenn die View Implementation jegliche Art von Plugin Möglichkeiten
   unterstützt, über die 'Zend_Layout' Platzhalter zugegriffen werden, indem der :ref:`Platzhalter Helfer
   <zend.view.helpers.initial.placeholder>` verwendet wird:

   .. code-block:: php
      :linenos:

      $placeholders = new Zend_View_Helper_Placeholder();
      $layoutVars   = $placeholders->placeholder('Zend_Layout')->getArrayCopy();

.. _zend.layout.advanced.plugin:

Eigene Front Controller Plugins
-------------------------------

Wenn ``Zend_Layout`` mit den *MVC* Komponenten verwendet wird, registriert es ein Front Controller Plugin dass das
Layout als letzte Aktion darstellt bevor die Bearbeitungsschleife beendet wird. In den meisten Fällen, wird das
Standardplugin ausreichen, aber sollte es gewünscht sein ein eigenes zu schreiben, kann der Name der Pluginklasse
die geladen werden soll durch die Übergabe der ``pluginClass`` Option an die ``startMvc()`` Methode spezifiziert
werden.

Jede Plugin Klasse die für diesen Zweck geschrieben wird, muß ``Zend_Controller_Plugin_Abstract`` erweitern, und
sollte eine Instanz eines Layout Objektes als Instanz für den Konstruktor akzeptieren. Andernfalls sind die
Details der Implementation in eigenen Händen.

Die Standardmäßig verwendete Plugin Klasse ist ``Zend_Layout_Controller_Plugin_Layout``.

.. _zend.layout.advanced.helper:

Eigene Action Helfer
--------------------

Wenn ``Zend_Layout`` mit den *MVC* Komponenten verwendet wird, registriert es einen Action Controller Helfer mit
dem Helfer Broker. Der Standardhelfer, ``Zend_Layout_Controller_Action_Helper_Layout`` arbeitet als dummer Proxy
zur Layout Objekt Instanz selbst, und sollte für die meisten Zwecke ausreichend sein.

Sollte es gewünscht sein eigene Funktionalitäten zu schreiben, kann einfach eine Action Helfer Klasse geschrieben
werden die ``Zend_Controller_Action_Helper_Abstract`` erweitert und den Klassennamen als ``helperClass`` Option an
die ``startMvc()`` Methode übergeben werden. Details der Implementiert oblieben jedem selbst.

.. _zend.layout.advanced.inflector:

Auflösung eigener Layout Skript Pfade: Verwenden der Beugung
------------------------------------------------------------

``Zend_Layout`` verwendet ``Zend_Filter_Inflector`` um eine Filterkette zu erstellen für die Übersetzung eines
Layout Namens zu einem Layout Skript Pfad. Standardmäßig verwendet es die 'Word_CamelCaseToDash' Regeln gefolgt
von 'StringToLower' und dem Anhang 'phtml' um den Namen in einen Pfad zu transformieren. Einige Beispiele:

- 'foo' wird zu 'foo.phtml' transformiert.

- 'FooBarBaz' wird zu 'foo-bar-baz.phtml' transformiert.

Es gibt drei Optionen für die Änderung der Beugung: Änderung des Beuzungszieles und/oder des View Suffix über
``Zend_Layout`` Zugriffsmethoden, änderung der Beugungsregeln und des Ziels der Beugung die mit der
``Zend_Layout`` Instanz gekoppelt ist, oder Erstellung einer eigenen Beugungsinstanz und dessen Übergabe an
``Zend_Layout::setInflector()``.

.. _zend.layout.advanced.inflector.accessors:

.. rubric:: Verwenden von Zend_Layout Zugriffsmethoden zur Änderung der Beugung

Der standardmäßige ``Zend_Layout`` Beugungsmechanismus verwendet statische Referenzen für das Ziel und View
Skript Suffix, und besitzt Zugriffsmethoden für das setzen dieser Werte.

.. code-block:: php
   :linenos:

   // Setzen des Beugungsziel:
   $layout->setInflectorTarget('layouts/:script.:suffix');

   // Setzen des Layout View Skript Suffix:
   $layout->setViewSuffix('php');

.. _zend.layout.advanced.inflector.directmodification:

.. rubric:: Direkte Änderung der Zend_Layout Beugung

Beugung hat ein Ziel und ein oder mehrere Regeln. Das Standardziel das von ``Zend_Layout`` verwendet wird ist:
':script.:suffix'; ':script' wird als registrierter Layoutname übergeben, wärend ':suffix' eine statische Regel
der Beugung ist.

Angenommen man will dass das Layout Skript mit der Endung 'html' endet, und es ist gewünscht das MixedCase und
camelCased Wörter mit Unterstrichen statt Bindestrichen getrennt werden und der Name nicht kleingeschrieben wird.
Zusätzlich ist es gewünscht in einem 'layouts' Unterverzeichnis nach den Skripten nachzuschauen.

.. code-block:: php
   :linenos:

   $layout->getInflector()->setTarget('layouts/:script.:suffix')
                          ->setStaticRule('suffix', 'html')
                          ->setFilterRule(array('Word_CamelCaseToUnderscore'));

.. _zend.layout.advanced.inflector.custom:

.. rubric:: Eigene Beugung

In den meisten Fällen ist es ausreichend den bestehenden Beugungsmechanismus zu verändern. Trotzdem kann man eine
Beugung haben die in verschiedenen Orten verwendet werden soll, mit unterschiedlichen Objekten von
unterschiedlichen Typen. ``Zend_Layout`` unterstützt das.

.. code-block:: php
   :linenos:

   $inflector = new Zend_Filter_Inflector('layouts/:script.:suffix');
   $inflector->addRules(array(
       ':script' => array('Word_CamelCaseToUnderscore'),
       'suffix'  => 'html'
   ));
   $layout->setInflector($inflector);

.. note::

   **Beugung kann ausgeschaltet werden**

   Beugung kann ausgeschaltet und eingeschaltet werden indem eine zugriffsmethode auf dem ``Zend_Layout`` Objekt
   verwendet wird. Das kann nützlich sein wenn man einen absoluten Pfad für ein Layout Skript spezifizieren will,
   oder man weiß das der Mechanismus den man für die Spezifikation des Layout Skripts verwenden will, keine
   Beugung benötigt. Es können einfach die ``enableInflection()`` und ``disableInflection()`` Methoden verwendet
   werden.


