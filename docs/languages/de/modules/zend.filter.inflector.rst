.. EN-Revision: none
.. _zend.filter.inflector:

Zend\Filter\Inflector
=====================

``Zend\Filter\Inflector`` ist ein generell verwendbares Tool für regel-basierende Beugung von Strings zu einem
gegebenen Ziel.

Als Beispiel, kann es gewünscht sein MixedCase oder camelCaseWörter in einen Pfad zu transformieren; für die
Lesbarkeit, OS Policies, oder andere Gründe, sollen diese auch kleingeschrieben werden, und die Wörter sollen mit
einem Bindestrich ('-') getrennt werden. Eine Beugung (Inflector) kann das erledigen.

``Zend\Filter\Inflector`` implementiert ``Zend\Filter\Interface``; eine Beugung kann durch den Aufruf von
``filter()`` auf der Objekt Instanz durchgeführt werden.

.. _zend.filter.inflector.camel_case_example:

.. rubric:: MixedCase und camelCaseText in ein anderes Format transformieren

.. code-block:: php
   :linenos:

   $inflector = new Zend\Filter\Inflector('pages/:page.:suffix');
   $inflector->setRules(array(
       ':page'  => array('Word_CamelCaseToDash', 'StringToLower'),
       'suffix' => 'html'
   ));

   $string   = 'camelCasedWords';
   $filtered = $inflector->filter(array('page' => $string));
   // pages/camel-cased-words.html

   $string   = 'this_is_not_camel_cased';
   $filtered = $inflector->filter(array('page' => $string));
   // pages/this_is_not_camel_cased.html

.. _zend.filter.inflector.operation:

Funktion
--------

Eine Beugung benötigt ein **Ziel** (target) und ein oder mehrere **Regeln** (rules). Ein Ziel ist grundsätzlich
ein String der Platzhalter für Variablen definiert die ersetzt werden sollen. Sie werden durch das Voranstellen
eines ':' spezifiziert: **:script**.

Wenn ``filter()`` aufgerufen wird, muß ein Array von Schlüssel und Wert Paaren übergeben werden die den
Variablen im Ziel entsprechen.

Jede Variable im Ziel kann null oder mehr, mit Ihr assoziierte Regeln, besitzen. Regeln können entweder
**statisch** (static) sein oder zu einer ``Zend_Filter`` Klasse verweisen. Statische Regeln werden den angegebenen
Text ersetzen. Andernfalls wird eine Klasse verwendet die auf die Regel passt die angegeben wurde, um den Text zu
beugen. Klasse werden typischerweise spezifiziert indem ein Kurzname verwendet wird, der den Filternamen indiziert,
wobei jeglicher üblicher Präfix entfernt wurde.

Als Beispiel kann jede konkrete ``Zend_Filter`` Implementierung verwendet werden; trotzdem, statt auf diese als
'``Zend\Filter\Alpha``' oder '``Zend\Filter\StringToLower``' zu verweisen kann einfach '``Alpha``' oder
'``StringToLower``' spezifiziert werden.

.. _zend.filter.inflector.paths:

Pfade zu alternativen Filtern setzen
------------------------------------

``Zend\Filter\Inflector`` verwendet ``Zend\Loader\PluginLoader`` um das Laden von Filtern zu managen die von der
Beugung verwendet werden sollen. Standardmäßig, wird jeder Filter mit dem Präfix ``Zend_Filter`` vorhanden sein.
Um auf Filter mit diesem Präfix zuzugreifen, die aber tiefer in der Hirarchie vorhanden sind, kann einfach der
``Zend_Filter Präfix`` entfernt werden:

.. code-block:: php
   :linenos:

   // Verwendet Zend\Filter\Word\CamelCaseToDash als Regel
   $inflector->addRules(array('script' => 'Word_CamelCaseToDash'));

Um einen alternativen Pfad zu setzen hat ``Zend\Filter\Inflector`` eine Utility Methode die den Plugin Lader
verwendet, ``addFilterPrefixPath()``:

.. code-block:: php
   :linenos:

   $inflector->addFilterPrefixPath('My_Filter', 'My/Filter/');

Alternativ kann der Plugin Lader von der Beugung empfangen, und direkt mit Ihm interagiert werden:

.. code-block:: php
   :linenos:

   $loader = $inflector->getPluginLoader();
   $loader->addPrefixPath('My_Filter', 'My/Filter/');

Für weitere Optionen über das Bearbeiten von Pfaden zu Filtern sollte in die :ref:`PluginLoader Dokumentation
<zend.loader.pluginloader>` gesehen werden.

.. _zend.filter.inflector.targets:

Das Ziel der Beugung setzen
---------------------------

Das Ziel der Beugung ist ein String mit einigen Platzhaltern für Variablen. Platzhalter haben die Form eines
Identifizierers, standardmäßig einem Doppelpunkt (':'), gefolgt von einem Variablennamen: ':script', ':path',
usw. Die ``filter()`` Methode sieht nach dem Identifizierer gefolgt von dem Variablennamen der ersetzt werden soll.

Der Identifizierer kann geändert werden in dem die ``setTargetReplacementIdentifier()`` Methode verwendet wird,
oder indem er als drittes Argument dem Konstruktor übergeben wird:

.. code-block:: php
   :linenos:

   // Über Konstruktor:
   $inflector = new Zend\Filter\Inflector('#foo/#bar.#sfx', null, '#');

   // Über Zugriffsmethode:
   $inflector->setTargetReplacementIdentifier('#');

Typischerweise wird das Ziel über den Konstruktor gesetzt. Trotzdem kann es Ziel später geändert werden (zum
Beispiel, um die Standardbeugung in Kernkomponenten die dem ``ViewRenderer`` oder ``Zend_Layout`` zu verändern).
``setTarget()`` kann für diese Zwecke verwendet werden:

.. code-block:: php
   :linenos:

   $inflector = $layout->getInflector();
   $inflector->setTarget('layouts/:script.phtml');

Zusätzlich kann es gewünscht sein einen Klassenmember für die eigene Klasse zu haben, der es erlaubt das
Beugungsziel zu aktualisieren -- ohne dass das Ziel jedesmal direkt aktualisiert werden muß (was Methodenaufrufe
erspart). ``setTargetReference()`` erlaubt es das zu tun:

.. code-block:: php
   :linenos:

   class Foo
   {
       /**
        * @var string Beugungsziel
        */
       protected $_target = 'foo/:bar/:baz.:suffix';

       /**
        * Konstruktor
        * @return void
        */
       public function __construct()
       {
           $this->_inflector = new Zend\Filter\Inflector();
           $this->_inflector->setTargetReference($this->_target);
       }

       /**
        * Setzt das Ziel; Aktualisiert das Ziel für die Beugung
        *
        * @param  string $target
        * @return Foo
        */
       public function setTarget($target)
       {
           $this->_target = $target;
           return $this;
       }
   }

.. _zend.filter.inflector.rules:

Beugungsregeln
--------------

Wie bereits in der Einführung erwähnt, gibt es zwei Typen von Regeln: statische und filter-basierende.

.. note::

   Es ist wichtig festzustellen das unabhängig von der Methode in welche Regeln dem Inflector hinzugefügt werden,
   entweder eine nach der anderen, oder alle auf einmal; die Reihenfolge sehr wichtig ist. Speziellere Namen, oder
   Namen die andere Regelnamen enthalten können, müssen vor nicht speziellen Namen hinzugefügt werden. Wenn zum
   Beispiel zwei Regelnamen 'moduleDir' und 'module' angenommen werden, sollte die 'moduleDir' Regel vor 'module'
   auftreten, da 'module' in 'moduleDir' enthalten ist. Wenn 'module' vor 'moduleDir' hinzugefügt wurde, wird
   'module' als Teil von 'moduleDir' erkannt und und ausgeführt wobei 'Dir' im Ziel nicht ersetzt wird.

.. _zend.filter.inflector.rules.static:

Statische Regeln
^^^^^^^^^^^^^^^^

Statische Regeln führen einfach eine Ersetzung von Strings aus; sie sollten verwendet werden wenn ein Segment in
einem Ziel existiert das typischerweise statisch ist, aber welches der Entwickler ändern darf. Die
``setStaticRule()`` Methode kann verwendet werden um die Regel zu ändern:

.. code-block:: php
   :linenos:

   $inflector = new Zend\Filter\Inflector(':script.:suffix');
   $inflector->setStaticRule('suffix', 'phtml');

   // Später ändern:
   $inflector->setStaticRule('suffix', 'php');

So wie das Ziel selbst kann auch eine statische Regel an eine Referenz gebunden werden, was die Aktualisierung
einer einzelnen Variablen erlaubt statt das ein Methodenaufruf benötigt wird; das ist oft nützlich wenn die
Klasse intern eine Beugung verwendet, und die User den Beugungsmechanismus nicht holen sollen damit dieser
aktualisiert werden kann. Die ``setStaticRuleReference()`` kann verwendet werden um das durchzuführen:

.. code-block:: php
   :linenos:

   class Foo
   {
       /**
        * @var string Suffix
        */
       protected $_suffix = 'phtml';

       /**
        * Konstruktor
        * @return void
        */
       public function __construct()
       {
           $this->_inflector = new Zend\Filter\Inflector(':script.:suffix');
           $this->_inflector->setStaticRuleReference('suffix', $this->_suffix);
       }

       /**
        * Suffix setzen
        * aktualisiert die statische Suffix Regel im Beugungsmechanismus
        *
        * @param  string $suffix
        * @return Foo
        */
       public function setSuffix($suffix)
       {
           $this->_suffix = $suffix;
           return $this;
       }
   }

.. _zend.filter.inflector.rules.filters:

Beugungsregeln filtern
^^^^^^^^^^^^^^^^^^^^^^

Die Filter von ``Zend_Filter`` können auch als Beugungsregeln verwendet werden. Genauso wie bei statische Regeln
werden Sie an eine Zielvariable gebunden; anders als statische Regeln können mehrfache Filter definiert werden die
zur Beugung verwendet werden. Diese Filter werden in der Reihenfolge ausgeführt, weswegen man vorsichtig sein
sollte und Sie in der Reihenfolge registriert die für die Daten die empfangen werden sollen Sinn machen.

Regeln können durch Verwendung von ``setFilterRule()`` hinzugefügt werden (was alle vorhergehenden Regeln für
diese Variable überschreibt) oder ``addFilterRule()`` (was die neue Regel zu jeder existierenden Regel für diese
Variable hinzufügt). Filter werden in einem der folgenden Wege spezifiziert:

- **String**. Der String kann ein Klassenname eines Filters, oder ein Segment des Klassennamens ohne jeglichem
  Präfix sein der im Beugungs Plugin Lader gesetzt ist (standardmäßig, ohne den '``Zend_Filter``' Präfix).

- **Filter Objekt**. Jede Objekt Instanz die ``Zend\Filter\Interface`` implementiert kann als ein Filter übergeben
  werden.

- **Array**. Ein Array von einem oder mehreren Strings oder Filterobjekten wie vorher definiert.

.. code-block:: php
   :linenos:

   $inflector = new Zend\Filter\Inflector(':script.:suffix');

   // Setzt eine Regel um den Zend\Filter\Word\CamelCaseToDash Filter zu verwenden
   $inflector->setFilterRule('script', 'Word_CamelCaseToDash');

   // Eine Regel hinzufügen um Strings kleinzuschreiben
   $inflector->addFilterRule('script', new Zend\Filter\StringToLower());

   // Regeln en-masse setzen
   $inflector->setFilterRule('script', array(
       'Word_CamelCaseToDash',
       new Zend\Filter\StringToLower()
   ));

.. _zend.filter.inflector.rules.multiple:

Viele Regeln auf einmal setzen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Typischerweise ist es einfacher viele Regeln auf einmal zu setzen als eine einzelne Variable und die Beugungsregeln
auf einmal zu konfigurieren. ``Zend\Filter\Inflector``'s ``addRules()`` und ``setRules()`` Methode erlaubt dies.

Jede Methode nimmt ein Array von Variable und Regel Paaren, wobei die Regel alles sein kann was der Typ der Regel
akzeptiert (String, Filterobjekt, oder Array). Variablennamen akzeptieren eine spezielle Schreibweise um das Setzen
von statischen Regeln und Filterregeln zu erlauben, entsprechend der folgenden Schreibweise:

- **':' prefix**: Filterregeln.

- **kein Präfix**: statische Regel.

.. _zend.filter.inflector.rules.multiple.example:

.. rubric:: Mehrere Regeln auf einmal setzen

.. code-block:: php
   :linenos:

   // Es kann auch setRules() mit dieser Schreibweise verwendet werden:
   $inflector->addRules(array(
       // Filterregeln:
       ':controller' => array('CamelCaseToUnderscore','StringToLower'),
       ':action'     => array('CamelCaseToUnderscore','StringToLower'),

       // Statische Regel:
       'suffix'      => 'phtml'
   ));

.. _zend.filter.inflector.utility:

Hilfsmethoden
-------------

``Zend\Filter\Inflector`` hat eine Anzahl von Hilfsmethoden für das Empfangen und Setzen der Plugin Laders, die
Manipulation und das Empfangen von Regeln, und die Kontrolle ob und wann Ausnahmen geworfen werden.

- ``setPluginLoader()`` kann verwendet werden wenn ein eigener Plugin Loader konfiguriert werden soll der mit
  ``Zend\Filter\Inflector`` verwendet werden soll; ``getPluginLoader()`` empfängt den aktuell gesetzten.

- ``setThrowTargetExceptionsOn()`` kann verwendet werden um zu kontrollieren ob ``filter()`` eine Ausnahme wirft,
  oder nicht, wenn ein übergegebener Identifizierer der ersetzt werden soll nicht im Ziel gefunden wird.
  Standardmäßig wird keine Ausnahme geworfen. ``isThrowTargetExceptionsOn()`` zeigt wie der aktuelle Wert ist.

- ``getRules($spec = null)`` kann verwendet werden um alle registrierten Regeln für alle Variablen zu empfangen,
  oder nur die Regeln für eine einzelne Variable.

- ``getRule($spec, $index)`` holt eine einzelne Regel für eine gegebene Variable; das kann nützlich sein für das
  Holen einer spezifischen Filterregel für eine Variable die eine Filterkette hat. ``$index`` muß übergeben
  werden.

- ``clearRules()`` löscht alle aktuell registrierten Regeln.

.. _zend.filter.inflector.config:

Zend_Config mit Zend\Filter\Inflector verwenden
-----------------------------------------------

``Zend_Config`` kann verwendet werden um Regeln, Filter Präfix Pfade, oder andere Objektstati im
Beugungsmachanismus zu setzen, entweder durch die Übergabe eines ``Zend_Config`` Objekts zum Konstruktor, oder
durch ``setOptions()``. Die folgenden Einstellungen können spezifiziert werden:

- ``target`` spezifiziert das Beugungsziel.

- ``filterPrefixPath`` spezifiziert ein oder mehrere Filter Präfix und Pfad Paare für die Verwendung mit dem
  Beugungsmechanismus.

- ``throwTargetExceptionsOn`` sollte ein Boolscher Wert sein der anzeigt ob eine Ausnahme geworfen wird, oder nicht
  geworfen wird, wenn ein Idenzifizierer der ersetzt werden soll nach der Beugung noch immer vorhanden ist.

- ``targetReplacementIdentifier`` spezifiziert das Zeichen das verwendet wird wenn Ersetzungsvariablen im
  Zielstring identifiziert werden.

- ``rules`` spezifiziert ein Array von Beugungsregeln; es sollte aus Schlüsseln bestehen die entweder Werte oder
  Arrays von Werten spezifizieren, die mit ``addRules()`` übereinstimmen.

.. _zend.filter.inflector.config.example:

.. rubric:: Zend_Config mit Zend\Filter\Inflector verwenden

.. code-block:: php
   :linenos:

   // Mit dem Konstruktor:
   $config    = new Zend\Config\Config($options);
   $inflector = new Zend\Filter\Inflector($config);

   // Oder mit setOptions():
   $inflector = new Zend\Filter\Inflector();
   $inflector->setOptions($config);


