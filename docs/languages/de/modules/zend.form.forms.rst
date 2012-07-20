.. _zend.form.forms:

Erstellen von Form durch Verwendung von Zend_Form
=================================================

Die ``Zend_Form`` Klasse wird verwendet um Form Element, Anzeigegruppen und Unterforms zu gruppieren. Sie kann die
folgenden Aktionen an diesen Elementen vornehmen:

- Prüfung, inklusive dem Empfang von Fehlercodes und Meldungen

- Werte behandeln, inklusive der Übermittlung von Elementen und dem Empfangen von beiden, gefilterten und
  ungefilterten Werten, von allen Elementen

- Iteration über alle Elemente in der Reihenfolge in der Sie eingegeben wurden oder basierend auf der Reihenfolge
  in der Hinweise von jedem Element empfangen werden

- Darstellung der kompletten Form, antweder über einen eigenen Dekorator der eigene Darstellungen durchführt oder
  durch die Iterierung über jedes Element in der Form

Wärend Formen die mit ``Zend_Form`` erstellt werden komplex sein können, ist der warscheinlich beste
Verwendungzweck eine einfache Form; die beste Verwendung ist für Rapid Application Development (RAD) und
Prototyping.

In der einfachsten Art, wird einfach ein Form Objekt instanziert:

.. code-block:: php
   :linenos:

   // Generelles Form Objekt:
   $form = new Zend_Form();

   // Eigenes Form Objekt:
   $form = new My_Form()

Es kann optional eine Instanz von ``Zend_Config`` oder ein Array übergeben werden, welches verwendet wird um den
Status des Objektes zu setzen sowie potentiell neue Elemente zu erstellen:

.. code-block:: php
   :linenos:

   // Konfigurations Optionen übergeben:
   $form = new Zend_Form($config);

``Zend_Form`` ist iterierbar und iteriert durch die Elemente, Anzeigegruppen und Subforms, indem es die Reihenfolge
in der diese registriert wurde verwendet und jede Reihenfolge die der Index hat. Das ist nützlich in den Fällen
in denen Elemente manuell in einer bestimmten Reihenfolge dargestellt werden sollen.

``Zend_Form``'s Magie liegt in der Fähigkeit als Factory für Elemente und Anzeigegruppen zu arbeiten, genauso wie
die Fähigkeit sich selbst durch Dekoratore darzustellen.

.. _zend.form.forms.plugins:

Plugin Loader
-------------

``Zend_Form`` verwendet ``Zend_Loader_PluginLoader`` um es Entwicklern zu erlauben Orte von alternativen Elementen
und Dekoratoren zu spezifizieren. Jeder hat seinen eigenen mit Ihm assoziierten Plugin Loader, und generelle
Zugriffspunkte werden verwendet um jeden zu empfangen und zu ändern.

Die folgenden Loadertypen werden mit den verschiedenen Plugin Loader Methoden verwendet: 'element' und 'decorator'.
Die Typnamen sind unabhängig von der Schreibweise.

Die Methoden um mit Plugin Loader zu interagieren sind die folgenden:

- ``setPluginLoader($loader, $type)``: $loader ist das Plugin Loader Objekt selbst. Das setzt den Plugin Loader
  für den gegebenen Typ zu dem neu spezifizierten Loader Objekt.

- ``getPluginLoader($type)``: Empfängt den mit $type assoziierten Plugin Loader.

- ``addPrefixPath($prefix, $path, $type = null)``: Fügt eine Präfix/Pfad Assoziation zum durch $type
  spezifizierten Loader hinzu. Wenn $type ``NULL`` ist, versucht es den Pfad allen Loadern hinzuzufügen, durch
  anhängen des Präfix an jedes "\_Element" und "\_Decorator"; und anhängen des Pfades an "Element/" und
  "Decorator/". Wenn man alle Extra Form Elementklassen in einer normalen Hierarchie sind, ist das die übliche
  Methode für das Setzen eines Basispräfix für Sie.

- ``addPrefixPaths(array $spec)``: Erlaubt es viele Pfade auf einmal zu einem oder mehreren Plugin Loadern
  hinzuzufügen. Sie erwartet das jedes Array Element ein Array mit den Schlüsseln 'path', 'prefix' und 'type'
  ist.

Zusätzlich kann ein Präfixpfad für alle Elemente und Anzeigegruppen die durch eine ``Zend_Form`` Instanz
erstellt wurden, spezifiziert werden, durch Verwendung der folgenden Methoden:

- ``addElementPrefixPath($prefix, $path, $type = null)``: Wie ``addPrefixPath()``, nur das ein Klassenpräfix und
  ein Pfad spezifiziert werden muß. Wenn ``$type`` spezifiziert wurde, muß er einer der Plugin Loader Typen sein
  die in ``Zend_Form_Element`` spezifiziert sind; siehe das :ref:`Kapitel Element Plugins
  <zend.form.elements.loaders>` für weitere Informationen über gültige ``$type`` Werte. Wenn kein ``$type``
  spezifiziert wurde, nimmt diese Methode an das ein genereller Präfix für alle Typen spezifiziert wurde.

- ``addDisplayGroupPrefixPath($prefix, $path)``: Wie ``addPrefixPath()`` nur das Klassenpräfix und ein Pfad
  spezifiziert werden muß; Trotzdem, da Anzeigegruppen nur Dekoratore als Plugin unterstützen, ist kein ``$type``
  notwendig.

Eigene Elemente und Dekoratore sind ein einfacher Weg um Funktionalitäten zwischen Forms zu teilen und eigene
Funktionalitäten zu kapseln. Siehe das :ref:`Eigene Label Beispiel <zend.form.elements.loaders.customLabel>` in
der Dokumentation über Elemente als Beispiel dafür, wie eigene Elemente als Ersatz für Standardklassen verwendet
werden können.

.. _zend.form.forms.elements:

Elemente
--------

``Zend_Form`` bietet verschiedene Zugriffsmethoden für das Hinzufügen und Entfernen von Elementen aus einer Form.
Diese können Instanzen von Elemente Objekten nehmen oder als Factories für das Instanzieren der Element Objekte
selbe herhalten.

Die grundsätzlichste Methode für das Hinzufügen eines Elements ist ``addElement()``. Diese Methode kann entweder
ein Objekt vom Typ ``Zend_Form_Element`` sein (oder einer Klasse die ``Zend_Form_Element`` erweitert), oder
Argumente für das Erstellen eines neuen Elements -- inklusive dem Elementtyp, Namen, und jegliche
Konfigurationsoption.

Einige Beispiele:

.. code-block:: php
   :linenos:

   // Eine Instanz eines Elements verwenden:
   $element = new Zend_Form_Element_Text('foo');
   $form->addElement($element);

   // Eine Factory verwenden
   //
   // Erstellt ein Element von Typ Zend_Form_Element_Text mit dem
   // Namen 'foo':
   $form->addElement('text', 'foo');

   // Eine Label Option an das Element übergeben:
   $form->addElement('text', 'foo', array('label' => 'Foo:'));

.. note::

   **addElement() implementiert das Fluent Interface**

   ``addElement()`` implementiert das Fluent Interface; das heißt es gibt das ``Zend_Form`` Objekt zurück und
   nicht das Element. Das wird getan um es zu erlauben das mehrere addElement() Methoden gekettet werden können
   oder andere Methoden die das Fluent Interface implementieren (alle Setzer in ``Zend_Form`` implementieren dieses
   Pattern).

   Wenn das Element zurückgegeben werden soll, muß stattdessen ``createElement()`` verwendet werden, welches
   anbei beschrieben wird. Trotzdem vorsicht, da ``createElement()`` das Element nicht der Form hinzufügt.

   ``addElement()`` verwendet intern ``createElement()`` um das Element zu erstellen bevor es der Form hinzugefügt
   wird.

Sobald ein Element der Form hinzugefügt wurde, kann es durch den Namen empfangen werden. Das kann entweder durch
die Verwendung der ``getElement()`` Methode, oder durch Verwendung von Überladen um auf das Element als
Objekteigenschaft zuzugreifen:

.. code-block:: php
   :linenos:

   // getElement():
   $foo = $form->getElement('foo');

   // Als Objekteigenschaft:
   $foo = $form->foo;

Fallweise, will man ein Element erstellen ohne es einer Form hinzuzufügen (zum Beispiel, wenn man die
verschiedenen Plugin Pfade verwenden, aber das Objekt später zu einer Subform hinzufügen will). Die
``createElement()`` Methode erlaubt das:

.. code-block:: php
   :linenos:

   // $username wird ein Zend_Form_Element_Text Objekt:
   $username = $form->createElement('text', 'username');

.. _zend.form.forms.elements.values:

Werte bekanntgeben und empfangen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Nach der Prüfung einer Form, will man typischerweise die Werte empfangen damit andere Operationen durchgeführt
werden können, wie das Aktualisieren einer Datenbank oder der Abfrage eines Web Services. Es können alle Werte
für alle Elemente empfangen werden durch Verwendung von ``getValues()``; ``getValue($name)`` erlabt es ausserdem
den Wert eines einzelnen Elements durch den Elementnamen zu erhalten:

.. code-block:: php
   :linenos:

   // Alle Werte erhalten:
   $values = $form->getValues();

   // Nur den Wert des 'foo' Elements erhalten:
   $value = $form->getValue('foo');

Manchmal soll die Form mit spezifizierten Werte veröffentlicht werden bevor Sie dargestellt wird. Das kann
entweder mit den ``setDefaults()`` oder ``populate()`` Methoden getan werden:

.. code-block:: php
   :linenos:

   $form->setDefaults($data);
   $form->populate($data);

Auf der anderen Seiten kann es gewünscht sein ein Formular, nach der Übertragung oder der Prüfung, zu löschen;
das kann durch Verwendung der ``reset()`` Methode durchgeführt werden:

.. code-block:: php
   :linenos:

   $form->reset();

.. _zend.form.forms.elements.global:

Globale Operationen
^^^^^^^^^^^^^^^^^^^

Fallweise wird man wollen das bestimmte Operationen alle Elemente beeinflussen. Übliche Szenarien enthalten das
Setzen des Plugin Präfix Pfades für alle Elemente, Setzen der Dekoratore für alle Elemente, und das setzen von
Filtern für alle Elemente. Als Beispiel:

.. _zend.form.forms.elements.global.allpaths:

.. rubric:: Setzen von Präfix Pfaden für alle Elemente

Präfix Pfade können für alle Elemente durch den Typ oder der Verwendung eines globalen Präfix gesetzt werden.
Einige Beispiele:

.. code-block:: php
   :linenos:

   // Einen gobalen Präfix setzen:
   // Erstellt Pfade für die Präfixe My_Foo_Filter, My_Foo_Validate,
   // und My_Foo_Decorator
   $form->addElementPrefixPath('My_Foo', 'My/Foo/');

   // Nur Filterpfade:
   $form->addElementPrefixPath('My_Foo_Filter',
                               'My/Foo/Filter',
                               'filter');

   // Nur Prüfungspfade:
   $form->addElementPrefixPath('My_Foo_Validate',
                               'My/Foo/Validate',
                               'validate');

   // Nur Dekoratorpfade:
   $form->addElementPrefixPath('My_Foo_Decorator',
                               'My/Foo/Decorator',
                               'decorator');

.. _zend.form.forms.elements.global.decorators:

.. rubric:: Dekoratore für alle Elemente setzen

Man kann Dekoratore für alle Elemente setzen. ``setElementDecorators()`` akzeptiert ein Array von Dekoratoren, wie
``setDecorators()``, und überschreibt jeden vorher gesetzten Dekorator in jedem Element. In diesem Beispiel wird
der Dekorator einfach auf einen ViewHelfer und ein Label gesetzt:

.. code-block:: php
   :linenos:

   $form->setElementDecorators(array(
       'ViewHelper',
       'Label'
   ));

.. _zend.form.forms.elements.global.decoratorsFilter:

.. rubric:: Setzen von Dekoratoren für einige Elemente

Man kann Dekoratore auch für ein Subset von Elementen setzen, entweder durch Ausbeziehung oder durch Ausgrenzung.
Das zweite Argument von ``setElementDecorators()`` kann ein Array von Elementnamen sein; standardmäßig setzt so
ein Array den spezifizierten Dekrator nur auf diese Elemente. Man kann auch einen dritten Parameter angeben, ein
Flag das anzeigt ob diese Liste von Elementen einbezogen oder ausgegrenzt werden sollen. Wenn das Flag ``FALSE``
ist, werden alle Elemente dekoriert **ausser** denen die in der Liste übergeben wurden. Die normale Verwendung der
Methode besteht darin, das alle übergebenen Dekoratore alle vorher gesetzten Dekoratore in jedem Element
überschreiben.

Im folgenden Schnipsel, sagen wir das wir nur die ViewHelper und Label Dekoratore für die 'foo' und 'bar' Elemente
haben wollen:

.. code-block:: php
   :linenos:

   $form->setElementDecorators(
       array(
           'ViewHelper',
           'Label'
       ),
       array(
           'foo',
           'bar'
       )
   );

Auf der anderen Seite zeigt dieses Schnipsel jetzt an das nur nur die ViewHelper und Label Dekoratore für jedes
Element verwenden wollen **ausgenommen** die 'foo' und 'bar' Elemente:

.. code-block:: php
   :linenos:

   $form->setElementDecorators(
       array(
           'ViewHelper',
           'Label'
       ),
       array(
           'foo',
           'bar'
       ),
       false
   );

.. note::

   **Einige Dekoratore sind für einige Elemente ungeeignet**

   Wärend ``setElementDecorators()`` wie eine gute Lösung ausschaut gibt es einige Fälle in denen es zu
   unerwarteten Ergebnissen führen kann. Zum Beispiel verwenden die verschiedenen Button Elemente (Submit, Button,
   Reset) aktuell das Label als Wert des Buttons, und verwenden nur den ViewHelper und DtDdWrapper Dekorator -- was
   zusätzliche Labels, Fehler und Hinweise für die Darstellung verhindert. Das obige Beispiel würde einige
   Inhalte (das Label) für Button Elemente duplizieren.

   Man kann das Enthalten/Ausnehmen Array verwenden um dieses Problem, wie im vorherigen Beispiel gezeigt, zu
   umgehen.

   Diese Methode sollte also weise verwendet werden und man sollte bedenken das man einige Dekoratore von Elementen
   händisch ändern muss damit ungewollte Ausgaben verhindert werden.

.. _zend.form.forms.elements.global.filters:

.. rubric:: Filter für alle Elemente setzen

In einigen Fällen will man den selben Filter auf alle Elemente anwenden; ein üblicher Fall ist es alle Werte zu
``trim()``\ men:

.. code-block:: php
   :linenos:

   $form->setElementFilters(array('StringTrim'));

.. _zend.form.forms.elements.methods:

Methoden für die Interaktion mit Elementen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die folgenden Methoden können verwendet werden um mit Elementen zu interagieren:

- ``createElement($element, $name = null, $options = null)``

- ``addElement($element, $name = null, $options = null)``

- ``addElements(array $elements)``

- ``setElements(array $elements)``

- ``getElement($name)``

- ``getElements()``

- ``removeElement($name)``

- ``clearElements()``

- ``setDefaults(array $defaults)``

- ``setDefault($name, $value)``

- ``getValue($name)``

- ``getValues()``

- ``getUnfilteredValue($name)``

- ``getUnfilteredValues()``

- ``setElementFilters(array $filters)``

- ``setElementDecorators(array $decorators)``

- ``addElementPrefixPath($prefix, $path, $type = null)``

- ``addElementPrefixPaths(array $spec)``

.. _zend.form.forms.displaygroups:

Anzeigegruppen
--------------

Anzeigegruppen sind ein Weg um virtuell Gruppierungen von Elementen für Anzeigezwecke zu erstellen. Alle Elemente
bleiben durch Ihren Namen in der Form zugreifbar, aber wenn die Form iteriert oder dargestellt wird, werden alle
Elemente in Anzeigegruppen gemeinsam dargestellt. Üblicherweise wird das für die Gruppierung von Elementen in
Fieldsets verwendet.

Die Basisklasse für Anzeigegruppen ist ``Zend_Form_DisplayGroup``. Wärend Sie direkt Instanziert werden kann, ist
es normalerweise am besten die ``addDisplayGroup()`` Methode von ``Zend_Form`` zu verwenden um das zu erledigen.
Diese Methode nimmt ein Array von Elementen als erstes Argument, und einen Namen für die Anzeigegruppe als zweites
Argument. Es kann optional ein Array von Optionen oder ein ``Zend_Config`` Objekt als drittes Argument übergeben
werden.

Angenommen das die Elemente 'username' und 'passwort' bereits in der Form gesetzt wurden. Dann würde der folgende
Code diese Elemente in einer 'login' Anzeigegruppe gruppieren:

.. code-block:: php
   :linenos:

   $form->addDisplayGroup(array('username', 'password'), 'login');

Auf Displaygruppen kann mithilfe der ``getDisplayGroup()`` Methode zugegriffen werden, oder über Überladung inden
der Name der Anzeigegruppe verwendet wird:

.. code-block:: php
   :linenos:

   // getDisplayGroup() verwenden:
   $login = $form->getDisplayGroup('login');

   // Überladen verwenden:
   $login = $form->login;

.. note::

   **Standarddekoratore müssen nicht geladen werden**

   Standardmäßig werden die Standarddekoratore wärend der Initialisierung des Objektes geladen. Das kann durch
   die Übergabe der 'disableLoadDefaultDecorators' Option, bei der Erstellung der Anzeigegruppe, deaktiviert
   werden:

   .. code-block:: php
      :linenos:

      $form->addDisplayGroup(
          array('foo', 'bar'),
          'foobar',
          array('disableLoadDefaultDecorators' => true)
      );

   Diese Option kann mit jeder anderen Option gemischt werden die übergeben wird, sowohl als Array Option als auch
   in einem ``Zend_Config`` Objekt.

.. _zend.form.forms.displaygroups.global:

Globale Operationen
^^^^^^^^^^^^^^^^^^^

Wie bei den Elementen gibt es einige Operationen welche alle Anzeigegruppen beeinflussen; diese inkludieren das
Setzen von Dekoratoren und Setzen des Plugin Pfades in denen nach Dekoratoren nachgesehen werden soll.

.. _zend.form.forms.displaygroups.global.paths:

.. rubric:: Setzen des Dekorator Präfix Pfades für alle Anzeigegruppen

Standardmäßig erben Anzeigegruppen die Dekorator Pfade welche die Form verwendet; wenn trotzdem in alternativen
Orten nachgeschaut werden soll kann die ``addDisplayGroupPrefixPath()`` Methode verwendet werden.

.. code-block:: php
   :linenos:

   $form->addDisplayGroupPrefixPath('My_Foo_Decorator', 'My/Foo/Decorator');

.. _zend.form.forms.displaygroups.global.decorators:

.. rubric:: Setzen von Dekoratoren für alle Anzeigegruppen

Es können Dekoratore für alle Anzeigegruppen gesetzt werden. ``setDisplayGroupDecorators()`` akzeptiert ein Array
von Dekoratoren, wie ``setDecorators()``, und überschreibt alle vorher gesetzten Dekoratore in jeder
Anzeigegruppe. In diesem Beispiel setzen wir die Dekoratore einfach auf ein Fieldset (der FormElements Dekorator
ist notwendig um sicherzustellen das die Elemente iterierbar sind):

.. code-block:: php
   :linenos:

   $form->setDisplayGroupDecorators(array(
       'FormElements',
       'Fieldset'
   ));

.. _zend.form.forms.displaygroups.customClasses:

Eigene Anzeigegruppen Klassen verwenden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Standardmäßig verwendet ``Zend_Form`` die ``Zend_Form_DisplayGroup`` Klasse für Anzeigegruppen. Man kann diese
Klasse erweitern um eigene Funktionalitäten anzubieten. ``addDisplayGroup()`` erlaubt es nicht eine konkrete
Instanz zu übergeben, aber sie erlaubt es eine Klasse zu spezifizieren die als eine Ihrer Optionen verwendet wird,
indem der 'displayGroupClass' Schlüssel verwendet wird:

.. code-block:: php
   :linenos:

   // Verwenden der 'My_DisplayGroup' Klasse
   $form->addDisplayGroup(
       array('username', 'password'),
       'user',
       array('displayGroupClass' => 'My_DisplayGroup')
   );

Wenn die Klasse noch nicht geladen wurde, versucht ``Zend_Form`` das zu tun, indem ``Zend_Loader`` verwendet wird.

Es kann auch eine eine Standardklasse für Anzeigegruppen definiert werden die mit der Form zu verwenden ist, sodas
alle Anzeigegrupen die mit dem Form Objekt erstellt werden diese Klasse verwenden:

.. code-block:: php
   :linenos:

   // Verwenden der Klasse 'My_DisplayGroup' für alle Anzeigegruppen:
   $form->setDefaultDisplayGroupClass('My_DisplayGroup');

Diese Einstellung kann in Konfigurationen als 'defaultDisplayGroupClass' spezifiziert werden, und wird früh
geladen um sicherzustellen das alle Anzeigegruppen diese Klasse verwenden.

.. _zend.form.forms.displaygroups.interactionmethods:

Methoden für die Interaktion mit Anzeigegruppen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die folgenden Methoden können verwendet werden um mit Anzeigegruppen zu interagieren:

- ``addDisplayGroup(array $elements, $name, $options = null)``

- ``addDisplayGroups(array $groups)``

- ``setDisplayGroups(array $groups)``

- ``getDisplayGroup($name)``

- ``getDisplayGroups()``

- ``removeDisplayGroup($name)``

- ``clearDisplayGroups()``

- ``setDisplayGroupDecorators(array $decorators)``

- ``addDisplayGroupPrefixPath($prefix, $path)``

- ``setDefaultDisplayGroupClass($class)``

- ``getDefaultDisplayGroupClass($class)``

.. _zend.form.forms.displaygroups.methods:

Methoden von Zend_Form_DisplayGroup
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Form_DisplayGroup`` hat die folgenden Methoden, gruppiert nach Typ:

- Konfiguration:

  - ``setOptions(array $options)``

  - ``setConfig(Zend_Config $config)``

- Metadaten:

  - ``setAttrib($key, $value)``

  - ``addAttribs(array $attribs)``

  - ``setAttribs(array $attribs)``

  - ``getAttrib($key)``

  - ``getAttribs()``

  - ``removeAttrib($key)``

  - ``clearAttribs()``

  - ``setName($name)``

  - ``getName()``

  - ``setDescription($value)``

  - ``getDescription()``

  - ``setLegend($legend)``

  - ``getLegend()``

  - ``setOrder($order)``

  - ``getOrder()``

- Elemente:

  - ``createElement($type, $name, array $options = array())``

  - ``addElement($typeOrElement, $name, array $options = array())``

  - ``addElements(array $elements)``

  - ``setElements(array $elements)``

  - ``getElement($name)``

  - ``getElements()``

  - ``removeElement($name)``

  - ``clearElements()``

- Plugin Loader:

  - ``setPluginLoader(Zend_Loader_PluginLoader $loader)``

  - ``getPluginLoader()``

  - ``addPrefixPath($prefix, $path)``

  - ``addPrefixPaths(array $spec)``

- Dekoratore:

  - ``addDecorator($decorator, $options = null)``

  - ``addDecorators(array $decorators)``

  - ``setDecorators(array $decorators)``

  - ``getDecorator($name)``

  - ``getDecorators()``

  - ``removeDecorator($name)``

  - ``clearDecorators()``

- Darstellung:

  - ``setView(Zend_View_Interface $view = null)``

  - ``getView()``

  - ``render(Zend_View_Interface $view = null)``

- I18n:

  - ``setTranslator(Zend_Translator_Adapter $translator = null)``

  - ``getTranslator()``

  - ``setDisableTranslator($flag)``

  - ``translatorIsDisabled()``

.. _zend.form.forms.subforms:

Subformen
---------

Subformen haben unterschiedliche Zwecke:

- Erstellung von logischen Element Gruppen. Da Subformen einfach Formen sind, können Sie auch wie individuelle
  Einheiten geprüft werden.

- Erstellung von Multi-Seiten Formen. Da Subformen einfach Formen sind, kann eine separate Subform pro Seite
  angezeigt werden, um Multi-Seiten Formen zu bauen in denen jede Form seine eigene Prüflogik besitzt. Nur sobald
  alle Subformen geprüft wurden würde die Form als komplett angenommen werden.

- Anzeige Gruppierungen. Wie Anzeigegruppen, können Subformen, wenn Sie als Teil einer größeren Form dargestellt
  werden, verwendet werden um Elemente zu gruppieren. Trotzdem muß darauf geachtet werden dass das Hauptform
  Objekt keine Ahnung von den Elementen in Subformen besitzt.

Eine Subform kann ein ``Zend_Form`` Objekt sein, oder typischerweise ein ``Zend_Form_SubForm`` Objekt. Das zweitere
enthält Dekoratore die für das Einfügen in größere Formen passen (z.B. gibt es keine zusätzlichen *HTML* form
Tags aus, gruppiert aber Elemente). Um eine Subform anzuhängen, muß diese einfach der Form hinzugefügt und ein
Name vergeben werden:

.. code-block:: php
   :linenos:

   $form->addSubForm($subForm, 'subform');

Eine Subform kann empfangen werden indem entweder ``getSubForm($name)`` oder Überladung mithilfe des Namens der
Subform verwendet wird:

.. code-block:: php
   :linenos:

   // Verwenden von getSubForm():
   $subForm = $form->getSubForm('subform');

   // Verwenden von Überladen:
   $subForm = $form->subform;

Subformen sind bei der Iteration der Form enthalten, aber die Elemente die Sie enthalten nicht.

.. _zend.form.forms.subforms.global:

Globale Operationen
^^^^^^^^^^^^^^^^^^^

Wie Elemente und Anzeigegruppen. gibt es einige Operationen für die es notwendig ist alle Subformen zu bearbeiten.
Anders als Anzeigegruppen und Elemente, erben Subformen die meisten Funktionalitäten vom Hauptform Objekt, und die
einzige wirklich Operation die durchgeführt werden sollte, ist das Setzen der Dekoratore für Subformen. Für
diesen Zweck, gibt es die ``setSubFormDecorators()`` Methode. Im nächsten Beispiel setzen wir den Dekorator für
alle Subformen einfach auf ein Fieldset (der FormElements Dekorator wird benötigt um sicherzustellen das seine
Elemente iterierbar sind):

.. code-block:: php
   :linenos:

   $form->setSubFormDecorators(array(
       'FormElements',
       'Fieldset'
   ));

.. _zend.form.forms.subforms.methods:

Methoden für die Interaktion mit Subfomen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die folgenden Meothden können verwendet werden um mit Subformen zu interagieren:

- ``addSubForm(Zend_Form $form, $name, $order = null)``

- ``addSubForms(array $subForms)``

- ``setSubForms(array $subForms)``

- ``getSubForm($name)``

- ``getSubForms()``

- ``removeSubForm($name)``

- ``clearSubForms()``

- ``setSubFormDecorators(array $decorators)``

.. _zend.form.forms.metadata:

Metadaten und Attribute
-----------------------

Wärend die Nützlichkeit von Formen primär von den Elementen die Sie enthalten her rührt, enthhalten Sie auch
anderen Metadaten, wie einen Namen (oft verwendet als eindeutige ID im *HTML* Markup); die Aktion und Methode der
Form; die Anzahl an Elementen, Gruppen, und Subformen die Sie enthält; und sonstige Metadaten (die normalerweise
verwendet werden um *HTML* Attribute für das Form Tag selbst zu setzen).

Der Name der Form kann mithilfe der name Zugriffsmethoden gesetzt und empfangen werden:

.. code-block:: php
   :linenos:

   // Den Namen setzen:
   $form->setName('registration');

   // Den Namen empfangen:
   $name = $form->getName();

Um die Aktion (URL zu der die Form übermittelt) und Methode (Methode mit der übermittelt werden soll, 'POST' oder
'``GET``') zu setzen, können die Zugriffsmethoden für action und method verwendet werden:

.. code-block:: php
   :linenos:

   // action und method setzen:
   $form->setAction('/user/login')
        ->setMethod('post');

Man kann auch den Encoding Typ des Formulars spezifizieren indem die Enctype Zugriffsmethode verwendet wird.
``Zend_Form`` definiert zwei Konstanten, ``Zend_Form::ENCTYPE_URLENCODED`` und ``Zend_Form::ENCTYPE_MULTIPART``,
die den Werten 'application/x-www-form-urlencoded' und 'multipart/form-data' entsprechen; trotzdem kann das auf
jeden gewünschten Encodingtyp gesetzt werden.

.. code-block:: php
   :linenos:

   // Setzt die Aktion, Methoden, und Enctype:
   $form->setAction('/user/login')
        ->setMethod('post')
        ->setEnctype(Zend_Form::ENCTYPE_MULTIPART);

.. note::

   Methode, Aktion und Encodingtyp werden nur intern für die Darstellung verwendet, und nicht für irgendeine Art
   von Prüfung.

``Zend_Form`` implementiert das ``Countable`` Interface, welches es erlaubt es als Argument fürs Zählen zu
übergeben:

.. code-block:: php
   :linenos:

   $numItems = count($form);

Das Setzen von eigenen Metadaten wird durch die attribs Zugriffsmethode durchgeführt. Da Überladen in
``Zend_Form`` verwendet wird um auf Elemente, Anzeigegruppen, und Subformen zuzugreifen ist das die einzige Methode
für den Zugriff auf Metadaten.

.. code-block:: php
   :linenos:

   // Setzen von Attributen:
   $form->setAttrib('class', 'zend-form')
        ->addAttribs(array(
            'id'       => 'registration',
            'onSubmit' => 'validate(this)',
        ));

   // Empfangen von Attributen:
   $class = $form->getAttrib('class');
   $attribs = $form->getAttribs();

   // Entfernen eines Attributes:
   $form->removeAttrib('onSubmit');

   // Löschen aller Attribute:
   $form->clearAttribs();

.. _zend.form.forms.decorators:

Dekoratore
----------

Das Erstellen des Markups für eine Form ist oft ein zeitintensiver Arbeitsschritt, speziell wenn man plant das
selbe Markup wiederzuverwenden um Dinge zu zeigen wie Prüffehler, übermittelte Werte, usw. ``Zend_Form``'s
Antwort hierfür sind **Dekoratore**.

Dekoratore für ``Zend_Form`` Objekte können verwendet werden um eine Form darzustellen. Der FormElements
Dekorator iteriert durch alle Elemente in einer Form -- Elemente, Anzeigegruppen, und Subformen -- stellt sie dar,
und gibt das Ergebnis zurück. Zusätzliche Dekoratore können dann verwendet werden um diese Inhalte zu wrappen,
sie anzufügen oder sie voranzustellen.

Die Standarddekoratore für ``Zend_Form`` sind FormElemente, HtmlTag (wrappt in einer Definitionsliste), und Form;
der entsprechende Code für deren Erstellung ist wie folgt:

.. code-block:: php
   :linenos:

   $form->setDecorators(array(
       'FormElements',
       array('HtmlTag', array('tag' => 'dl')),
       'Form'
   ));

Das erstellt eine Ausgabe wie die folgende:

.. code-block:: html
   :linenos:

   <form action="/form/action" method="post">
   <dl>
   ...
   </dl>
   </form>

Jegliche Attribute die auf dem Form Objekt gesetzt sindwerden als *HTML* Attribute des **<form>** Tags verwendet.

.. note::

   **Standarddekoratore müssen nicht geladen werden**

   Standardmäßig werden die Standarddekoratore wärend der Initialisierung des Objektes geladen. Das kann durch
   die Übergabe der 'disableLoadDefaultDecorators' Option, bei der Erstellung der Anzeigegruppe, deaktiviert
   werden:

   .. code-block:: php
      :linenos:

      $form = new Zend_Form(array('disableLoadDefaultDecorators' => true));

   Diese Option kann mit jeder anderen Option gemischt werden die übergeben wird, sowohl als Array Option als auch
   in einem ``Zend_Config`` Objekt.

.. note::

   **Verwenden mehrerer Dekoratore des gleichen Typs**

   Intern verwendet ``Zend_Form`` eine Dekorator Klasse als Mechsnismus für das nachsehen wenn Dekoratore
   empfangen werden. Als Ergebnis können mehrere Dekoratore nicht zur gleichen Zeit registriert werden;
   nachfolgende Dekoratore würden einfach die vorher existierenden überschreiben.

   Um das zu umgehen können Aliase verwendet werden. Statt der Übergabe eines Dekorators oder eines
   Dekoratornamens als erstes Argument an ``addDecorator()``, kann ein Array mit einem einzelnen Argument
   übergeben werden, mit dem Alias der auf das Dekorator Objekt oder den Namen zeigt:

   .. code-block:: php
      :linenos:

      // Alias zu 'FooBar':
      $form->addDecorator(array('FooBar' => 'HtmlTag'), array('tag' => 'div'));

      // Und Ihn später empfangen:
      $form = $element->getDecorator('FooBar');

   In den ``addDecorators()`` und ``setDecorators()`` Methoden muß die 'decorator' Option im Array übergeben
   werden das den Dekorator repräsentiert:

   .. code-block:: php
      :linenos:

      // Zwei 'HtmlTag' Dekoratore hinzufügen und einen mit 'FooBar' benennen:
      $form->addDecorators(
          array('HtmlTag', array('tag' => 'div')),
          array(
              'decorator' => array('FooBar' => 'HtmlTag'),
              'options' => array('tag' => 'dd')
          ),
      );

      // Und Sie später empfangen:
      $htmlTag = $form->getDecorator('HtmlTag');
      $fooBar  = $form->getDecorator('FooBar');

Man kann eigene Dekoratore für die Erzeugung der Form erstellen. Ein üblicher Grund hierfür ist, wenn man das
exakte *HTML* weiß das man verwenden will; der Dekorator könnte das exakte *HTML* erstellen und es einfach
zurückgeben, wobei potentiell die Dekoratore der individuellen Elemente oder Anzeigegruppen verwendet werden.

Die folgenden Methoden können verwendet werden um mit Dekoratoren zu interagieren:

- ``addDecorator($decorator, $options = null)``

- ``addDecorators(array $decorators)``

- ``setDecorators(array $decorators)``

- ``getDecorator($name)``

- ``getDecorators()``

- ``removeDecorator($name)``

- ``clearDecorators()``

``Zend_Form`` verwendet auch das Überladen um die Darstellung von speziellen Dekoratoren zu erlauben. ``__call()``
interagiert mit Methoden die mit dem Text 'render' beginnen und verwendet den Rest des Methodennamens um nach einem
Dekorator zu suchen; wenn er gefunden wird, wird dieser **einzelne** Dekorator dargestellt. Jedes Argument das dem
Methodenaufruf übergeben wird, wird als Inhalt an die ``render()`` Methode des Dekorators übergeben. Als
Beispiel:

.. code-block:: php
   :linenos:

   // Stellt nur den FormElements Dekorator dar:
   echo $form->renderFormElements();

   // Stell nur den Fieldset Dekorator dar, und übergibt Inhalte:
   echo $form->renderFieldset("<p>Das ist der Fieldset Inhalt</p>");

Wenn der Dekorator nicht existiert, wird eine Exception geworfen.

.. _zend.form.forms.validation:

Prüfung
-------

Ein primärer Verwendungszweck für Forms ist die Überprüfung von übermittelten Daten. ``Zend_Form`` erlaubt es
eine komplette Form, eine teilweise Form, oder Antworten von XmlHttpRequests (AJAX) zu prüfen. Wenn die
übertragenen Daten nicht gültig sind, hat es Methoden für das Empfangen der verschiedenen Fehlercodes und
Nachrichten für Elemente und Subformen.

Um eine ganze Form zu prüfen, kann die ``isValid()`` Methode verwendet werden:

.. code-block:: php
   :linenos:

   if (!$form->isValid($_POST)) {
       // Prüfung fehlgeschlagen
   }

``isValid()`` prüft jedes benötigte Element, und jedes nicht benötigte Element das in den übermittelten Daten
enthalten ist.

Manchmal muß nur ein Subset der Daten geprüft werden; dafür kann ``isValidPartial($data)`` verwendet werden:

.. code-block:: php
   :linenos:

   if (!$form->isValidPartial($data)) {
       // Prüfung fehlgeschlagen
   }

``isValidPartial()`` versucht nur die Teile zu prüfen für die es passende Elemente gibt; wenn ein Element nicht
in den Daten repräsentiert ist, wird es übersprungen.

Wenn Elemente oder Gruppen von Elementen für eine *AJAX* Anfrage geprüft werden, wird üblicherweise ein Subset
der Form geprüft, und die Antwort in *JSON* zurückgegeben. ``processAjax()`` führt das präzise durch:

.. code-block:: php
   :linenos:

   $json = $form->processAjax($data);

Man kann dann einfach die *JSON* Antwort an den Client senden. Wenn die Form gültig ist, wird das eine boolsche
``TRUE`` Antwort sein. Wenn nicht, wird es ein Javascript Objekt sein das Schlüssel/Nachricht Paare enthält,
wobei jede Nachricht 'message' ein Array von Prüf-Fehlermeldungen enthält.

Für Forms bei denen die Prüfung fehlschlägt, können beide, Fehlercodes und Fehlermeldung empfangen werden,
indem ``getErrors()`` und ``getMessages()`` verwendet werden:

.. code-block:: php
   :linenos:

   $codes = $form->getErrors();
   $messages = $form->getMessages();

.. note::

   Da die Nachrichten die von ``getMessages()`` zurückgegeben werden in einem Array von Fehlercode/Nachricht
   Paaren sind, wird ``getErrors()`` normalerweise nicht benötigt.

Codes und Fehlermeldungen kann man für individuelle Elemente erhalten indem einfach der Name des Elements an jede
übergeben wird:

.. code-block:: php
   :linenos:

   $codes = $form->getErrors('username');
   $messages = $form->getMessages('username');

.. note::

   Notiz: Wenn Elemente geprüft werden, sendet ``Zend_Form`` ein zweites Argument zu jeder ``isValid()`` Methode
   der Elemente: Das Array der Daten die geprüft werden sollen. Das kann von individuellen Prüfern verwendet
   werden um Ihnen zu erlauben andere übertragene Werte zu verwenden wenn die Gültigkeit der Daten ermittelt
   wird. Ein Beispiel wäre eine Registrations Form die beide benötigt, ein Passwort und eine Passwort
   Bestätigung; das Passwort Element könnte die Passwort Bestätigung als Teil seiner Prüfung verwenden.

.. _zend.form.forms.validation.errors:

Selbst definierte Fehlermeldungen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Von Zeit zu Zeit ist es gewünscht ein oder mehrere spezielle Fehlermeldungen zu spezifizieren die statt den
Fehlermeldungen verwendet werden sollen die von den Validatoren verwendet werden die dem Element angehängt sind.
Zusätzlich will man von Zeit zu Zeit ein Element selbst als ungültig markieren. Diese Funktionalität ist über
die folgenden Methoden ermöglicht.

- ``addErrorMessage($message)``: Fügt eine Fehlermeldung hinzu die bei Form-Überprüfungs-Fehlern angezeigt wird.
  Sie kann mehr als einmal aufgerufen werden, und neue Meldungen werden dem Stack angehängt.

- ``addErrorMessages(array $messages)``: Fügt mehrere Fehlermeldungen hinzu die bei Form-Überprüfungs-Fehlern
  angezeigt werden.

- ``setErrorMessages(array $messages)``: Fügt mehrere Fehlermeldungen hinzu die bei Form-Überprüfungs-Fehlern
  angezeigt werden, und überschreibt alle vorher gesetzten Fehlermeldungen.

- ``getErrorMessages()``: Empfängt eine Liste von selbstdefinierten Fehlermeldungen die vorher definiert wurden.

- ``clearErrorMessages()``: Entfernt alle eigenen Fehlermeldungen die vorher definiert wurden.

- ``markAsError()``: Markiert das Element wie wenn die Überprüfung fehlgeschlagen wäre.

- ``addError($message)``: Fügt einen Fehler zum eigenen Stack der Fehlermeldungen hinzu und markiert das Element
  als ungültig.

- ``addErrors(array $messages)``: Fügt mehrere Nachrichten zum eigenen Stack der Fehlermeldungen hinzu und
  markiert das Element als ungültig.

- ``setErrors(array $messages)``: Überschreibt den eigenen Stack der Fehlermeldungen mit den angegebenen Meldungen
  und markiert das Element als ungültig.

Alle auf diesem Weg gesetzten Fehler können übersetzt werden.

.. _zend.form.forms.validation.values:

Nur einen gültigen Wert empfangen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Es gibt Szenarien in denen man dem Benutzer erlauben will in verschiedenen Schritten mit einem gültigen Formular
zu arbeiten. In der Zwischenzeit wird dem Benutzer erlaubt das Formular mit jedem Set an Werte zu speichern. Dann,
wenn alle Daten spezifiziert wurden kann das Modell von der Building oder Prototyping Stufe zu einer Gültigen
Stufe transferiert werden.

Alle gültigen Werte die mit den übermittelten Daten übereinstimmen können empfangen werden indem folgendes
aufgerufen wird:

.. code-block:: php
   :linenos:

   $validValues = $form->getValidValues($_POST);

.. _zend.form.forms.methods:

Methoden
--------

Nachfolgend ist eine komplette Liste der in ``Zend_Form`` vorhandenen Methoden, gruppiert nach Typ:

- Konfiguration und Optionen:

  - ``setOptions(array $options)``

  - ``setConfig(Zend_Config $config)``

- Plugin Loader und Pfade:

  - ``setPluginLoader(Zend_Loader_PluginLoader_Interface $loader, $type = null)``

  - ``getPluginLoader($type = null)``

  - ``addPrefixPath($prefix, $path, $type = null)``

  - ``addPrefixPaths(array $spec)``

  - ``addElementPrefixPath($prefix, $path, $type = null)``

  - ``addElementPrefixPaths(array $spec)``

  - ``addDisplayGroupPrefixPath($prefix, $path)``

- Metadaten:

  - ``setAttrib($key, $value)``

  - ``addAttribs(array $attribs)``

  - ``setAttribs(array $attribs)``

  - ``getAttrib($key)``

  - ``getAttribs()``

  - ``removeAttrib($key)``

  - ``clearAttribs()``

  - ``setAction($action)``

  - ``getAction()``

  - ``setMethod($method)``

  - ``getMethod()``

  - ``setName($name)``

  - ``getName()``

- Elemente:

  - ``addElement($element, $name = null, $options = null)``

  - ``addElements(array $elements)``

  - ``setElements(array $elements)``

  - ``getElement($name)``

  - ``getElements()``

  - ``removeElement($name)``

  - ``clearElements()``

  - ``setDefaults(array $defaults)``

  - ``setDefault($name, $value)``

  - ``getValue($name)``

  - ``getValues()``

  - ``getUnfilteredValue($name)``

  - ``getUnfilteredValues()``

  - ``setElementFilters(array $filters)``

  - ``setElementDecorators(array $decorators)``

- Subformen:

  - ``addSubForm(Zend_Form $form, $name, $order = null)``

  - ``addSubForms(array $subForms)``

  - ``setSubForms(array $subForms)``

  - ``getSubForm($name)``

  - ``getSubForms()``

  - ``removeSubForm($name)``

  - ``clearSubForms()``

  - ``setSubFormDecorators(array $decorators)``

- Anzeigegruppen:

  - ``addDisplayGroup(array $elements, $name, $options = null)``

  - ``addDisplayGroups(array $groups)``

  - ``setDisplayGroups(array $groups)``

  - ``getDisplayGroup($name)``

  - ``getDisplayGroups()``

  - ``removeDisplayGroup($name)``

  - ``clearDisplayGroups()``

  - ``setDisplayGroupDecorators(array $decorators)``

- Prüfungen

  - ``populate(array $values)``

  - ``isValid(array $data)``

  - ``isValidPartial(array $data)``

  - ``processAjax(array $data)``

  - ``persistData()``

  - ``getErrors($name = null)``

  - ``getMessages($name = null)``

- Darstellung:

  - ``setView(Zend_View_Interface $view = null)``

  - ``getView()``

  - ``addDecorator($decorator, $options = null)``

  - ``addDecorators(array $decorators)``

  - ``setDecorators(array $decorators)``

  - ``getDecorator($name)``

  - ``getDecorators()``

  - ``removeDecorator($name)``

  - ``clearDecorators()``

  - ``render(Zend_View_Interface $view = null)``

- I18n:

  - ``setTranslator(Zend_Translator_Adapter $translator = null)``

  - ``getTranslator()``

  - ``setDisableTranslator($flag)``

  - ``translatorIsDisabled()``

.. _zend.form.forms.config:

Konfiguration
-------------

``Zend_Form`` ist über ``setOptions()`` und ``setConfig()`` vollständig konfigurierbar (oder durch die Übergabe
von Optionen oder einem ``Zend_Config`` Objekt an den Konstruktor). Durch Verwendung dieser Methoden können Form
Elemente, Anzeigegruppen, Dekoratore, und Metadaten spezifiziert werden.

Als generelle Regel, wenn 'set' + der Optionsschlüssel zu einer ``Zend_Form`` Methode referieren, wird der
angebotene Wert zu dieser Methode übergeben. Wenn die Methode nicht existiert, wird angenommen das der Schlüssel
eine Referenz zu einem Attribut ist, und wird an ``setAttrib()`` übergeben.

Ausnahmen zu dieser Regel sind die folgenden:

- ``prefixPath`` wird übergeben an ``addPrefixPaths()``

- ``elementPrefixPath`` wird übergeben an ``addElementPrefixPaths()``

- ``displayGroupPrefixPath`` wird übergeben an ``addDisplayGroupPrefixPaths()``

- die folgenden Setter können nicht auf diesem Weg gesetzt werden:

  - ``setAttrib`` (da setAttribs \*wird* funktionieren)

  - ``setConfig``

  - ``setDefault``

  - ``setOptions``

  - ``setPluginLoader``

  - ``setSubForms``

  - ``setTranslator``

  - ``setView``

Als Beispiel ist hier eine Konfigurationsdatei die eine Konfiguration für jeden Typ von konfigurierbaren Daten
übergibt:

.. code-block:: ini
   :linenos:

   [element]
   name = "Registrierung"
   action = "/user/register"
   method = "post"
   attribs.class = "zend_form"
   attribs.onclick = "validate(this)"

   disableTranslator = 0

   prefixPath.element.prefix = "My_Element"
   prefixPath.element.path = "My/Element/"
   elementPrefixPath.validate.prefix = "My_Validate"
   elementPrefixPath.validate.path = "My/Validate/"
   displayGroupPrefixPath.prefix = "My_Group"
   displayGroupPrefixPath.path = "My/Group/"

   elements.username.type = "text"
   elements.username.options.label = "Benutzername"
   elements.username.options.validators.alpha.validator = "Alpha"
   elements.username.options.filters.lcase = "StringToLower"
   ; natürlich mehr Elemente...

   elementFilters.trim = "StringTrim"
   ;elementDecorators.trim = "StringTrim"

   displayGroups.login.elements.username = "username"
   displayGroups.login.elements.password = "password"
   displayGroupDecorators.elements.decorator = "FormElements"
   displayGroupDecorators.fieldset.decorator = "Fieldset"

   decorators.elements.decorator = "FormElements"
   decorators.fieldset.decorator = "FieldSet"
   decorators.fieldset.decorator.options.class = "zend_form"
   decorators.form.decorator = "Form"

Das obige könnte einfach abstrahiert werden zu einer *XML* oder *PHP* Array-basierenden Konfigurations Datei.

.. _zend.form.forms.custom:

Eigene Forms
------------

Eine Alternative zur Verwendung von Konfigurations-basierenden Forms ist es ``Zend_Form`` abzuleiten. Das hat
einige Vorteile:

- Die Form kein einfachst mit Unittests getestet werden um sicherzugehen das Prüfungen und Darstellungen wie
  erwartet durchgeführt werden.

- Eine feinkörnige Kontrolle über individuelle Elemente.

- Wiederverwendung von Form Objekten, und größere Portierbarkeit (keine Notwendigkeit Konfigurationsdateien zu
  verfolgen).

- Eigene Funktionalitäten zu implementieren.

Der typischste Anwendungsfall würde sein die ``init()`` Methode zu verwenden um spezielle Form Elemente und
Konfigurationen zu definieren:

.. code-block:: php
   :linenos:

   class My_Form_Login extends Zend_Form
   {
       public function init()
       {
           $username = new Zend_Form_Element_Text('username');
           $username->class = 'formtext';
           $username->setLabel('Benutzername:')
                    ->setDecorators(array(
                        array('ViewHelper',
                              array('helper' => 'formText')),
                        array('Label',
                              array('class' => 'label'))
                    ));

           $password = new Zend_Form_Element_Password('password');
           $password->class = 'formtext';
           $password->setLabel('Passwort:')
                    ->setDecorators(array(
                        array('ViewHelper',
                              array('helper' => 'formPassword')),
                        array('Label',
                              array('class' => 'label'))
                    ));

           $submit = new Zend_Form_Element_Submit('login');
           $submit->class = 'formsubmit';
           $submit->setValue('Anmeldung')
                  ->setDecorators(array(
                      array('ViewHelper',
                      array('helper' => 'formSubmit'))
                  ));

           $this->addElements(array(
               $username,
               $password,
               $submit
           ));

           $this->setDecorators(array(
               'FormElements',
               'Fieldset',
               'Form'
           ));
       }
   }

Diese form kann instanziert werden mit einem einfachen:

.. code-block:: php
   :linenos:

   $form = new My_Form_Login();

und die gesamte Funktionalität ist bereits eingestellt und bereit; keine Konfigurationsdateien notwendig. (Bitte
beachten das dieses Beispiel sehr vereinfacht ist, da es keine Prüfungen oder Filter für die Elemente enthält.)

Ein anderer üblicher Grund für die Erweiterung ist es ein Set von Standard Dekoratoren zu definieren. Das kann
durch überladen der ``loadDefaultDecorators()`` Methode durchgeführt werden:

.. code-block:: php
   :linenos:

   class My_Form_Login extends Zend_Form
   {
       public function loadDefaultDecorators()
       {
           $this->setDecorators(array(
               'FormElements',
               'Fieldset',
               'Form'
           ));
       }
   }


