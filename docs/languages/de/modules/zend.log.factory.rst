.. _zend.log.factory:

Die Factory verwenden um ein Log zu erstellen
=============================================

Zusätzlich zur direkten Instanzierung kann man auch die statische ``factory()`` Methode verwenden um eine Log
Instanz zu initiieren, und auch um angehängte Writer und deren Filter zu konfigurieren. Bei Verwendung der Factory
kann man keine oder mehrere Writer anhängen. Die Konfiguration kann entweder als Array oder Instanz von
``Zend_Config`` übergeben werden.

Als Beispiel:

.. code-block:: php
   :linenos:

   $logger = Zend_Log::factory(array(
       array(
           'writerName'   => 'Stream',
           'writerParams' => array(
               'stream'   => '/tmp/zend.log',
           ),
           'filterName'   => 'Priority',
           'filterParams' => array(
               'priority' => Zend_Log::WARN,
           ),
       ),
       array(
           'writerName'   => 'Firebug',
           'filterName'   => 'Priority',
           'filterParams' => array(
               'priority' => Zend_Log::INFO,
           ),
       ),
   ));

Das obige instanziert einen Logger mit zwei Writern, einen für das schreiben einer lokalen Daten, und einen
anderen für das Senden der Daten zu Firebug. Jeder hat einen angehängten Filter für Prioritäten, mit
unterschiedlichen maximalen Prioritäten.

Jeder Writer kann mit den folgenden Schlüsseln definiert werden:

**writerName (required)**
   Der "kurze" Name eines Log Writers; der Name des Log Writers ohne den führenden Klassenpräfix/Namespace. Siehe
   auch den "writerNamespace" Eintrag weiter unten für weitere Details. Beispiele: "Mock", "Stream", "Firebug".

**writerParams (optional)**
   Ein assoziatives Array von Parametern das verwendet wird wenn der Log Writer instanziert wird. Jede
   ``factory()`` Methode eines Log Writers führt diese mit den Argumenten des Contructors zusammen, wie anbei
   erwähnt.

**writerNamespace (optional)**
   Der Klassenpräfix/Namespace der verwendet wird wenn der endgültige Klassenname des Log Writers erstellt wird.
   Wird er nicht angegeben, dann wird standardmäßig "Zend_Log_Writer" angenommen; trotzdem kann man einen eigenen
   Namespace übergeben, wenn man einen eigenen Log Writer verwendet.

**filterName (optional)**
   Der "kurze" Name des Filters der mit dem angegebenen Log Writer verwendet werden soll; der Name des Filters ohne
   den führenden Klassenpräfix/Namespace. Siehe auch den "filterNamespace" Eintrag weiter unter für weitere
   Details. Beispiele: "Message", "Priority".

**filterParams (optional)**
   Ein assoziatives Array an Parametern das verwendet wird wenn der Log Filter instanziert wird. Jede ``factory()``
   Methode eines Log Filters führt diese mit den Constructor Argumenten zusammen, wie anbei erwähnt.

**filterNamespace (optional)**
   Der Klassenpräfix/Namespace der verwendet wird wenn der endgültige Klassenname des Log Filters erstellt wird.
   Wird er nicht angegeben, dann wird standardmäßig "Zend_Log_Filter" angenommen; trotzdem kann man einen eigenen
   Namespace übergeben, wenn man einen eigenen Log Filter verwendet.

Jeder Writer und jeder Filter hat spezifische Optionen.

.. _zend.log.factory.writer-options:

Writer Optionen
---------------

.. _zend.log.factory.writer-options.db:

Zend_Log_Writer_Db Optionen
^^^^^^^^^^^^^^^^^^^^^^^^^^^

**db**
   Eine Instanz von ``Zend_Db_Adapter``.

**table**
   Der Name der Tabelle in der RDBMS welche Log Einträge enthalten soll.

**columnMap**
   Ein assoziatives Array welches die Namen der Spalten der Datenbanktabelle mit den Feldern der Log Events
   verknüpft.

.. _zend.log.factory.writer-options.firebug:

Zend_Log_Writer_Firebug Optionen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Dieser Log Writer nimmt keine Optionen; alle übergebenen werden ignoriert.

.. _zend.log.factory.writer-options.mail:

Zend_Log_Writer_Mail Optionen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Log_Writer_Mail`` implementiert aktuell (mit 1.10) keine Factory, und wirft eine Exception wenn man versucht
Ihn über ``Zend_Log::factory()`` zu instanzieren.

.. _zend.log.factory.writer-options.mock:

Zend_Log_Writer_Mock Optionen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Dieser Log Writer nimmt keine Optionen; alle übergebenen werden ignoriert.

.. _zend.log.factory.writer-options.null:

Zend_Log_Writer_Null Optionen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Dieser Log Writer nimmt keine Optionen; alle übergebenen werden ignoriert.

.. _zend.log.factory.writer-options.stream:

Zend_Log_Writer_Stream Optionen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**stream|url**
   Ein gültiger Identifikator eines *PHP* Streams auf den geloggt werden soll.

**mode**
   Der I/O Modus mit dem geloggt werden soll; Standardwert ist "a" für "append".

.. _zend.log.factory.writer-options.syslog:

Zend_Log_Writer_Syslog Optionen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**application**
   Der Name der Anwendung die vom Syslog Writer verwendet wird.

**facility**
   Die Facility die vom Syslog Writer verwendet wird.

.. _zend.log.factory.writer-options.zendmonitor:

Zend_Log_Writer_ZendMonitor Optionen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Dieser Log Writer nimmt keine Optionen; alle übergebenen werden ignoriert.

.. _zend.log.factory.filter-options:

Filter Optionen
---------------

.. _zend.log.factory.filter-options.message:

Zend_Log_Filter_Message Optionen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**regexp**
   Ein regulärer Ausdruck der passen muss damit eine Nachricht geloggt wird.

.. _zend.log.factory.filter-options.priority:

Zend_Log_Filter_Priority Optionen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**priority**
   Das maximale Level der Priorität mit dem Nachrichten geloggt werden.

**operator**
   Der Vergleichsoperator mit dem Vergleiche der Priorität durchgeführt werden; der Standardwert ist "<=".

.. _zend.log.factory.filter-options.suppress:

Zend_Log_Writer_Suppress Optionen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Dieser Log Filter nimmt keine Optionen; alle übergebenen werden ignoriert.

.. _zend.log.factory.custom:

Erstellen konfigurierbarer Writer und Filter
--------------------------------------------

Wenn man die Notwendigkeit hat eigene Log Writer und/oder Filter zu schreiben kann man diese sehr einfach zu
``Zend_Log::factory()`` kompatibel machen.

Dazu muss man mindestens ``Zend_Log_FactoryInterface`` implementieren, welches eine statische ``factory()`` Methode
erwartet die ein einzelnes ``$config`` Argument akzeptiert. Wenn der eigene Log Writer ``Zend_Log_Writer_Abstract``
erweitert, oder der eigene Filter ``Zend_Log_Filter_Abstract`` erweitert, nimmt man das bereits kostenlos mit.

Dann muss man einfach Verknüpfungen zwischen akzeptierten Konfigurationen und den Contructor Argumenten
definieren. Als Beispiel:

.. code-block:: php
   :linenos:

   class My_Log_Writer_Foo extends Zend_Log_Writer_Abstract
   {
       public function __construct($bar, $baz)
       {
           // ...
       }

       public static function factory($config)
       {
           if ($config instanceof Zend_Config) {
               $config = $config->toArray();
           }
           if (!is_array($config)) {
               throw new Exception(
                   'factory erwartet ein Array oder eine Instanz von Zend_Config'
               );
           }

           $default = array(
               'bar' => null,
               'baz' => null,
           );
           $config = array_merge($default, $config);

           return new self(
               $config['bar'],
               $config['baz']
           );
       }
   }

Alternativ könnte man die richtigen Setter nach der Instanzierung aufrufen, aber noch bevor die Instanz
zurückgegeben wird:

.. code-block:: php
   :linenos:

   class My_Log_Writer_Foo extends Zend_Log_Writer_Abstract
   {
       public function __construct($bar = null, $baz = null)
       {
           // ...
       }

       public function setBar($value)
       {
           // ...
       }

       public function setBaz($value)
       {
           // ...
       }

       public static function factory($config)
       {
           if ($config instanceof Zend_Config) {
               $config = $config->toArray();
           }
           if (!is_array($config)) {
               throw new Exception(
                   'factory erwartet ein Array oder eine Instanz von Zend_Config'
               );
           }

           $writer = new self();
           if (isset($config['bar'])) {
               $writer->setBar($config['bar']);
           }
           if (isset($config['baz'])) {
               $writer->setBaz($config['baz']);
           }
           return $writer;
       }
   }


