.. _zend.layout.options:

Zend_Layout Konfigurations Optionen
===================================

``Zend_Layout`` hat eine Variation an Konfigurations Optionen. Diese können durch den Aufruf entsprechender
Zugriffsmethoden gesetzt werden, durch die Übergabe eines Arrays oder ``Zend_Config`` Objektes an den Konstruktor
oder ``startMvc()``, durch die Übergabe eines Arrays von Optionen an ``setOptions()``, oder der Übergabe eines
``Zend_Config`` Objektes an ``setConfig()``.

- **layout**: Das Layout das verwendet werden soll. Verwendet die aktuelle Beugung um den Namen, der dem
  entsprechenden Layout View Skript angegeben wurde, aufzulösen. Standardmäßig ist dieser Wert 'layout' und wird
  zu 'layout.phtml' aufgelöst. Zugriffsmethoden sind ``setLayout()`` und ``getLayout()``.

- **layoutPath**: Der Basispfad zu den Layout View Skripten. Zugriffsmethoden sind ``setLayoutPath()`` und
  ``getLayoutPath()``.

- **contentKey**: Die Layout Variable die für Standardinhalte verwendet wird (wenn mit dem *MVC* verwendet). Der
  Standardwert ist 'content'. Zugriffsmethoden sind ``setContentKey()`` und ``getContentKey()``.

- **mvcSuccessfulActionOnly**: Wenn *MVC* verwendet wird, dann wird das Layout nicht dargestellt wenn eine Aktion
  eine Ausnahme wirft und dieses Flag ``TRUE`` ist (das wird verwendet um zu verhindern dass das Layout doppelt
  dargestellt wird wenn das :ref:`ErrorHandler Plugin <zend.controller.plugins.standard.errorhandler>` verwendet
  wird. Standardmäßig ist dieses Flag ``TRUE``. Zugriffsmethoden sind ``setMvcSuccessfulActionOnly()`` und
  ``getMvcSuccessfulActionOnly()``.

- **view**: Das View Objekt das für die Darstellung verwendet wird. Wenn mit *MVC* verwendet, dann versucht
  ``Zend_Layout`` das View Objekt zu verwenden das mit :ref:`dem ViewRenderer
  <zend.controller.actionhelpers.viewrenderer>` registriert wurde wenn kein explizites View Objekt übergeben
  wurde. Zugriffsmethoden sind ``setView()`` und ``getView()``.

- **helperClass**: Die Action Helfer Klasse die verwendet wird wenn ``Zend_Layout`` mit den *MVC* Komponenten
  verwendet wird. Standardmäßig ist das ``Zend_Layout_Controller_Action_Helper_Layout``. Zugriffsmethoden sind
  ``setHelperClass()`` und ``getHelperClass()``.

- **pluginClass**: Das Front Controller Plugin das verwendet wird wenn ``Zend_Layout`` mit den *MVC* Komponenten
  verwendet wird. Standardmäßig ist das ``Zend_Layout_Controller_Plugin_Layout``. Zugriffsmethoden sind
  ``setPluginClass()`` und ``getPluginClass()``.

- **inflector**: Die Beugung die verwendet werden soll wenn Layout Namen zu Layout Skript Pfaden aufgelöst werden;
  siehe :ref:`die Zend_Layout Beugungs Dokumentation für weitere Details <zend.layout.advanced.inflector>`.
  Zugriffsmethoden sind ``setInflector()`` und ``getInflector()``.

.. note::

   **HelferKlasse und PluginKlasse müssen an startMvc() übergeben werden**

   Damit die ``helperClass`` und ``pluginClass`` Einstellungen wirken, müssen diese als Option an ``startMvc()``
   übergeben werden; wenn sie später gesetzt werden, haben Sie keinen Effekt.

.. _zend.layout.options.examples:

Beispiele
---------

Die folgenden Beispiele nehmen das folgende ``$options`` Array und ``$config`` Objekt an:

.. code-block:: php
   :linenos:

   $options = array(
       'layout'     => 'foo',
       'layoutPath' => '/path/to/layouts',
       'contentKey' => 'CONTENT', // Ignoriert wenn MVC nicht verwendet wird
   );

.. code-block:: php
   :linenos:

   /**
   [layout]
   layout = "foo"
   layoutPath = "/path/to/layouts"
   contentKey = "CONTENT"
   */
   $config = new Zend_Config_Ini('/path/to/layout.ini', 'layout');

.. _zend.layout.options.examples.constructor:

.. rubric:: Optionen an den Konstruktor oder startMvc() übergeben

Beide, der Konstruktor und die statische ``startMvc()`` Methode akzeptieren entweder ein Array von Optionen oder
ein ``Zend_Config`` Objekt mit Optionen um die ``Zend_Layout`` Instanz zu konfigurieren.

Zuerst zeigen wir die Übergabe eines Arrays:

.. code-block:: php
   :linenos:

   // Konstruktor verwenden:
   $layout = new Zend_Layout($options);

   // startMvc() verwenden:
   $layout = Zend_Layout::startMvc($options);

Und jetzt die Verwendung eines Config Objekts:

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Ini('/path/to/layout.ini', 'layout');

   // Konstruktor verwenden:
   $layout = new Zend_Layout($config);

   // startMvc() verwenden:
   $layout = Zend_Layout::startMvc($config);

Grundsätzlich ist das der einfachste Weg um die ``Zend_Layout`` Instanz anzupassen.

.. _zend.layout.options.examples.setoptionsconfig:

.. rubric:: setOption() und setConfig() verwenden

Machmal ist es notwendig das ``Zend_Layout`` Objekt zu Konfigurieren nachdem es instanziiert wurde;
``setOptions()`` und ``setConfig()`` bieten einen schnellen und einfachen Weg das zu tun:

.. code-block:: php
   :linenos:

   // Ein Array von Optionen verwenden:
   $layout->setOptions($options);

   // Ein Zend_Config Objekt verwenden:
   $layout->setConfig($options);

Es ist zu beachten das einige Optionen, wie ``pluginClass`` und ``helperClass``, keinen Effekt haven wenn Sie mit
Hilfe dieser Methode übergeben werden; sie müssen mit dem Konstruktor oder der ``startMvc()`` Methode übergeben
werden.

.. _zend.layout.options.examples.accessors:

.. rubric:: Zugriffsmethoden verwenden

Letztendlich kann die ``Zend_Layout`` Instanz auch über Zugriffsmetoden konfiguriert werden. Alle Zugriffsmethoden
implementieren ein Flüssiges Interface, was bedeutet das Ihre Aufrufe gekettet werden können:

.. code-block:: php
   :linenos:

   $layout->setLayout('foo')
          ->setLayoutPath('/path/to/layouts')
          ->setContentKey('CONTENT');


