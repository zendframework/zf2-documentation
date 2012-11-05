.. EN-Revision: none
.. _zend.cache.frontends:

Zend_Cache Frontends
====================

.. _zend.cache.frontends.core:

Zend\Cache\Core
---------------

.. _zend.cache.frontends.core.introduction:

Einführung
^^^^^^^^^^

``Zend\Cache\Core`` ist ein spezielles Frontend, da es der Kern dieses Moduls ist. Es ist ein generelles Cache
Frontend und wurde von anderen Klassen erweitert.

.. note::

   Alle Frontends sind von ``Zend\Cache\Core`` abgeleitet, so dass deren Methoden und Optionen (wie folgt
   beschrieben) auch in anderen Frontends vorhanden sind. Deswegen werden sie dort nicht dokumentiert.

.. _zend.cache.frontends.core.options:

Mögliche Optionen
^^^^^^^^^^^^^^^^^

Diese Optionen werden der Factory Methode übergeben wie im nachfolgenden Beispiel demonstriert.

.. _zend.cache.frontends.core.options.table:

.. table:: Core Frontend Optionen

   +-------------------------+---------+------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option                   |Daten Typ|Standardwert|Beschreibung                                                                                                                                                                                                                                                                                                                                                                                                    |
   +=========================+=========+============+================================================================================================================================================================================================================================================================================================================================================================================================================+
   |caching                  |Boolean  |TRUE        |Ein= / Ausschalten vom Caching (kann sehr nützlich für das Debuggen von gecachten Skripten sein)                                                                                                                                                                                                                                                                                                                |
   +-------------------------+---------+------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cache_id_prefix          |String   |NULL        |Ein Präfix für alle Cache IDs. Wenn er auf NULL gesetzt wird, wird kein Cache ID Präfix verwendet. Der Cache ID Präfix erstellt grundsätzlich einen Namespace im Cache, der verschiedenen Anwendungen oder Websites die Verwendung eines gemeinsamen Caches erlaubt. Jede Anwendung oder Website kann einen anderen Cache ID Prüfix verwenden sodas spezielle Cache IDs mehr als einmal verwendet werden können.|
   +-------------------------+---------+------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |lifetime                 |Integer  |3600        |Cache Lebensdauer (in Sekunden), wenn auf NULL gesetzt, ist der Cache für immer gültig.                                                                                                                                                                                                                                                                                                                         |
   +-------------------------+---------+------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |logging                  |Boolean  |FALSE       |Wenn auf TRUE gesetzt, wird das Logging durch Zend_Log aktiviert (aber das System wird langsamer)                                                                                                                                                                                                                                                                                                               |
   +-------------------------+---------+------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |write_control            |Boolean  |TRUE        |Ein- / Ausschalten der Schreibkontrolle (der Cache wird gleich gelesen, nachdem er geschrieben wurde, um fehlerhafte Einträge zu finden); das Einschalten der Schreibkontrolle wird das Schreiben des Caches etwas verlangsamen, aber nicht das Lesen des Caches (es können defekte Cache Dateien entdeckt werden, aber es ist keine perfekte Kontrolle)                                                        |
   +-------------------------+---------+------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |automatic_serialization  |Boolean  |FALSE       |Ein- / Ausschalten der automatischen Serialisierung, kann dafür benutzt werden, um Daten direkt zu speichern, welche keine Strings sind (aber es ist langsamer)                                                                                                                                                                                                                                                 |
   +-------------------------+---------+------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |automatic_cleaning_factor|Integer  |10          |Ausschalten / Abgleichen des automatischen Löschprozesses (Garbage Collector): 0 heißt keine automatische Löschung des Caches, 1 heißt Systematische Cache Löschung und x > 1 heißt automatisches zufälliges Löschen 1 mal nach x Schreiboperationen.                                                                                                                                                           |
   +-------------------------+---------+------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |ignore_user_abort        |Boolean  |FALSE       |Auf TRUE gesetzt, wird der Kern das PHP Flag ignore_user_abort innerhalb der save() Methode setzen um Cache Korruption in einigen Fällen zu verhindern                                                                                                                                                                                                                                                          |
   +-------------------------+---------+------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.core.examples:

Beispiele
^^^^^^^^^

Ein Beispiel wird ganz am Anfang des Handbuches gegeben.

Wenn nur Strings in den Cache gespeichert werden (denn mit der "automatic_serialization" Option wäre es möglich
Booleans zu speichern), kann ein kompakterer Weg wie folgt gewählt werden:

.. code-block:: php
   :linenos:

   // Es wird angenommen das $cache existiert

   $id = 'myBigLoop'; // Die Cache ID von dem "das gecached werden soll"

   if (!($data = $cache->load($id))) {
       // Cache miss

       $data = '';
       for ($i = 0; $i < 10000; $i++) {
           $data = $data . $i;
       }

       $cache->save($data);

   }

   // [...] Irgendwas mit $data machen (ausgeben, verarbeiten, usw.)

Wenn mehrere Blöcke von Daten oder Daten Instanzen gecached werden sollen, ist die Idee dahinter die gleiche:

.. code-block:: php
   :linenos:

   // Sicherstellen, dass eindeutige Identifizierer verwendet werden:
   $id1 = 'foo';
   $id2 = 'bar';

   // Block 1
   if (!($data = $cache->load($id1))) {
       // Cache miss

       $data = '';
       for ($i=0;$i<10000;$i++) {
           $data = $data . $i;
       }

       $cache->save($data);

   }
   echo($data);

   // Hier wird NIE gecached
   echo('NIE GECACHED! ');

   // Block 2
   if (!($data = $cache->load($id2))) {
       // Cache miss

       $data = '';
       for ($i=0;$i<10000;$i++) {
           $data = $data . '!';
       }

       $cache->save($data);

   }
   echo($data);

Wenn spezielle Werte gecached werden sollen (boolean mit der "automatic_serialization" Option) oder leere Strings
kann die kompakte Erstellung wie oben gezeigt nicht verwendet werden. Der Cache Eintrag muß formell getestet
werden.

.. code-block:: php
   :linenos:

   // Die kompakte Erstellung
   // (nicht gut wenn leere Strings und/oder boolsche Werte gecached werden)
   if (!($data = $cache->load($id))) {

       // Cache fehlgeschlagen

       // [...] wir erstellen $data

       $cache->save($data);

   }

   // wir machen etwas mit $data

   // [...]

   // die komplette Erstellung (funktioniert in jedem Fall)
   if (!($cache->test($id))) {

       // Cache fehlgeschlagen

       // [...] wir erstellen $data

       $cache->save($data);

   } else {

       // Cache getroffen

       $data = $cache->load($id);

   }

   // Wir machen irgendetwas mit $data

.. _zend.cache.frontends.output:

Zend\Cache_Frontend\Output
--------------------------

.. _zend.cache.frontends.output.introduction:

Einführung
^^^^^^^^^^

``Zend\Cache_Frontend\Output`` ist ein Ausgabe-Empfangendes Frontend. Es verwendet den Ausgabe Puffer in *PHP*, um
alles zwischen der ``start()`` und der ``end()`` Methode zu fangen.

.. _zend.cache.frontends.output.options:

Mögliche Optionen
^^^^^^^^^^^^^^^^^

Dieses Frontend hat keine bestimmten Optionen zusätzlich zu denen von ``Zend\Cache\Core``.

.. _zend.cache.frontends.output.examples:

Beispiele
^^^^^^^^^

Ein Beispiel wird ganz am Anfang des Handbuches gegeben. Hier ist es mit kleinen Änderungen:

.. code-block:: php
   :linenos:

   // Wenn es ein Cache Miss ist, wird das puffern der Ausgabe ausgelöst
   if( ! ($cache->start('mypage'))) {

       // Alle wie gewohnt ausgeben
       echo 'Hallo Welt! ';
       echo 'Das wird gecached ('.time().') ';

       $cache->end(); // Ausgabepufferung beenden

   }

   echo 'Hier wird nie gecached ('.time().').';

Die Verwendung dieser Form ist ziemlich einfach, um Ausgabe caching in einem bereits bestehenden Projekt, mit nur
wenig oder gar keinen Codeänderungen, zu erhalten.

.. _zend.cache.frontends.function:

Zend\Cache_Frontend\Function
----------------------------

.. _zend.cache.frontends.function.introduction:

Einführung
^^^^^^^^^^

``Zend\Cache_Frontend\Function`` cached das Ergebnis von Funktionsaufrufen. Es hat eine einzelne Hauptmethode
genannt ``call()``, welche den Funktionsnamen und Parameter für den Aufruf in einem Array entgegennimmt.

.. _zend.cache.frontends.function.options:

Mögliche Optionen
^^^^^^^^^^^^^^^^^

.. _zend.cache.frontends.function.options.table:

.. table:: Cache Frontend Optionen

   +--------------------+---------+------------+----------------------------------------------------------+
   |Option              |Daten Typ|Standardwert|Beschreibung                                              |
   +====================+=========+============+==========================================================+
   |cache_by_default    |Boolean  |TRUE        |Wenn TRUE, wird der Funktionsaufruf standardmäßig gecached|
   +--------------------+---------+------------+----------------------------------------------------------+
   |cached_functions    |Array    |            |Funktionsnamen, die immer gecached werden sollen          |
   +--------------------+---------+------------+----------------------------------------------------------+
   |non_cached_functions|Array    |            |Funktionsnamen, die nie gecached werden sollen            |
   +--------------------+---------+------------+----------------------------------------------------------+

.. _zend.cache.frontends.function.examples:

Beispiele
^^^^^^^^^

Die Verwendung der ``call()`` Funktion ist die gleiche, wie die von ``call_user_func_array()`` in *PHP*:

.. code-block:: php
   :linenos:

   $cache->call('veryExpensiveFunc', $params);

   // $params ist ein Array
   // Für das Aufrufen von veryExpensiveFunc(1, 'foo', 'bar') mit Caching kann,
   // z.B. $cache->call('veryExpensiveFunc', array(1, 'foo', 'bar')) benutzt
   // werden

``Zend\Cache_Frontend\Function`` ist elegant genug, um beides zu cachen, den Rückgabewert der Funktion und deren
interne Ausgabe.

.. note::

   Man kann jede eingebaute oder benutzerdefinierte Funktion übergeben, mit Ausnahme von ``array()``, ``echo()``,
   ``empty()``, ``eval()``, ``exit()``, ``isset()``, ``list()``, ``print()`` und ``unset()``.

.. _zend.cache.frontends.class:

Zend\Cache_Frontend\Class
-------------------------

.. _zend.cache.frontends.class.introduction:

Einführung
^^^^^^^^^^

``Zend\Cache_Frontend\Class`` ist unterschiedlich zu ``Zend\Cache_Frontend\Function``, weil es das Cachen von
Objekten und statischen Methodenaufrufen erlaubt.

.. _zend.cache.frontends.class.options:

Mögliche Optionen
^^^^^^^^^^^^^^^^^

.. _zend.cache.frontends.class.options.table:

.. table:: Class Frontend Optionen

   +-------------------------+--------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option                   |Datentyp|Standardwert|Beschreibung                                                                                                                                                                       |
   +=========================+========+============+===================================================================================================================================================================================+
   |cached_entity (Notwendig)|Mixed   |            |Wenn auf einen Klassennamen gesetzt, wird eine abstrakte Klasse gecached und es werden statische Aufrufe verwendet; wenn auf ein Objekt gesetzt, wird deren Objektmethoden gecached|
   +-------------------------+--------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cache_by_default         |Boolean |TRUE        |Wenn TRUE, wird der Aufruf standardmäßig gecached                                                                                                                                  |
   +-------------------------+--------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cached_methods           |Array   |            |Methodennamen, die immer gecached werden sollen                                                                                                                                    |
   +-------------------------+--------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |non_cached_methods       |Array   |            |Methodennamen, die nie gecached werden sollen                                                                                                                                      |
   +-------------------------+--------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.frontends.class.examples:

Beispiele
^^^^^^^^^

zum Beispiel, um einen statischen Aufruf zu cachen:

.. code-block:: php
   :linenos:

   class Test {

       // Statische Methode
       public static function foobar($param1, $param2) {
           echo "foobar_output($param1, $param2)";
           return "foobar_return($param1, $param2)";
       }

   }

   // [...]
   $frontendOptions = array(
       'cached_entity' => 'Test' // Der Name der Klasse
   );
   // [...]

   // Der gecachte Aufruf
   $result = $cache->foobar('1', '2');

Um klassische Methodenaufrufe zu cachen :

.. code-block:: php
   :linenos:

   class Test {

       private $_string = 'Hallo !';

       public function foobar2($param1, $param2) {
           echo($this->_string);
           echo "foobar2_output($param1, $param2)";
           return "foobar2_return($param1, $param2)";
       }

   }

   // [...]
   $frontendOptions = array(
       'cached_entity' => new Test() // Eine Instanz der Klasse
   );
   // [...]

   // Der gecachte Aufruf
   $res = $cache->foobar2('1', '2');

.. _zend.cache.frontends.file:

Zend\Cache_Frontend\File
------------------------

.. _zend.cache.frontends.file.introduction:

Einführung
^^^^^^^^^^

``Zend\Cache_Frontend\File`` ist ein Frontend angetrieben durch den Änderungszeitpunkt einer "Masterdatei". Es ist
wirklich interessant für Beispiele in Konfigurations- oder Templateanwendungen. Es ist auch möglich mehrere
Masterdateien zu verwenden.

Zum Beispiel eine *XML* Konfigurationsdatei, welche von einer Funktion geparsed wird und die ein "Config Objekt"
zurückgibt (wie durch ``Zend_Config``). Mit ``Zend\Cache_Frontend\File`` kann das "Config Objekt" im Cache
gespeichert werden (um zu Verhindern, das die *XML* Konfiguration jedes mal geparsed wird), aber mit einer strengen
Abhängigkeit zur "Masterdatei". Wenn also die *XML* Konfigurationsdatei geändert wird, wird der Cache sofort
ungültig.

.. _zend.cache.frontends.file.options:

Mögliche Optionen
^^^^^^^^^^^^^^^^^

.. _zend.cache.frontends.file.options.table:

.. table:: File Frontend Optionen

   +---------------------------+---------+---------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option                     |Daten Typ|Standardwert                     |Beschreibung                                                                                                                                                                                                                                                  |
   +===========================+=========+=================================+==============================================================================================================================================================================================================================================================+
   |master_File (depreciated)  |String   |''                               |Der komplette Pfad und Name der Master Datei                                                                                                                                                                                                                  |
   +---------------------------+---------+---------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |master_files               |Array    |array()                          |Ein Array der kompletten Pfade der Masterdateien                                                                                                                                                                                                              |
   +---------------------------+---------+---------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |master_files_mode          |String   |Zend\Cache_Frontend\File::MODE_OR|Zend\Cache_Frontend\File::MODE_AND oder Zend\Cache_Frontend\File::MODE_OR ; bei MODE_AND müssen alle Masterdateien angegriffen werden um einen Cache ungültig zu machen, bei MODE_OR ist eine eizelne angegriffene Datei genug um den Cache ungültig zu machen|
   +---------------------------+---------+---------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |ignore_missing_master_files|Boolean  |FALSE                            |bei TRUE werden fehlende Masterdateien leise ignoriert (andernfalls wird eine Exception geworfen)                                                                                                                                                             |
   +---------------------------+---------+---------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.frontends.file.examples:

Beispiele
^^^^^^^^^

Die Verwendung dieses Frontends ist die gleiche wie die von ``Zend\Cache\Core``. Es gibt kein eigenes Beispiel -
was als einziges gemacht werden muß, ist das **master_File** zu definieren, wenn die Factory verwendet wird.

.. _zend.cache.frontends.page:

Zend\Cache_Frontend\Page
------------------------

.. _zend.cache.frontends.page.introduction:

Einführung
^^^^^^^^^^

``Zend\Cache_Frontend\Page`` ist wie ``Zend\Cache_Frontend\Output`` aber entwickelt für eine komplette Seite. Es
ist unmöglich ``Zend\Cache_Frontend\Page`` nur für das Cachen eines einzelnen Blockes zu verwenden.

Andererseits wird die "Cache ID" automatisch berechnet mit ``$_SERVER['REQUEST_URI']`` und (abhängig von den
Optionen) mit ``$_GET``, ``$_POST``, ``$_SESSION``, ``$_COOKIE``, ``$_FILES``. Trotzdem muß nur eine Methode
aufgerufen werden (``start()``), weil der Aufruf von ``end()`` immer vollautomatisch ist, wenn die Seite endet.

Zur Zeit ist es nicht eingebaut, aber es ist ein *HTTP* abhängiges System geplant, um Bandbreiten zu sparen (das
System wird ein "*HTTP* 304 nicht geändert" schicken, wenn der Cache gefunden wurde und wenn der Browser bereits
eine gültige Version hat).

.. note::

   Dieses Frontend arbeitet indem es eine Callback Funktion registriert welche aufgerufen wird wenn das Buffern der
   Ausgabe welches es verwendet, gelöscht wird. Damit dies korrekt arbeitet muss es der letzte Ausgabebuffer in
   der Anfrage sein. Um dies zu garantieren **muss** der Ausgabebuffer, den der Dispatcher verwendet, deaktiviert
   sein indem die ``setParam()`` Methode von ``Zend\Controller\Front`` verwendet wird. Zum Beispiel
   ``$front->setParam('disableOutputBuffering', true)`` oder durch Hinzufügen von
   "resources.frontcontroller.params.disableOutputBuffering = true" zum eigenen Konfigurationsdatei der Bootstrap
   (*INI* angenommen) wenn ``Zend_Application`` verwendet wird.

.. _zend.cache.frontends.page.options:

Mögliche Optionen
^^^^^^^^^^^^^^^^^

.. _zend.cache.frontends.page.options.table:

.. table:: Page Frontend Optionen

   +----------------+---------+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option          |Daten Typ|Standardwert            |Beschreibung                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
   +================+=========+========================+======================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================+
   |http_conditional|Boolean  |FALSE                   |Verwendung des http_conditional Systems (zur Zeit nicht implementiert)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
   +----------------+---------+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |debug_header    |Boolean  |FALSE                   |Wenn TRUE, wird ein Debugging Text vor jeder gecacheten Seite hinzugefügt                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
   +----------------+---------+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |default_options |Array    |array(...siehe unten...)|Ein assoziatives Array mit Standard Optionen: (boolean, TRUE per Default) cache: Cache ist aktiviert wenn TRUE(boolean, FALSE per Default) cache_with_get_variables: wenn TRUE, ist der Cache weiterhin aktiviert, selbst wenn es einige Variablen im $_GET Array gibt (boolean, FALSE per Default) cache_with_post_variables: wenn TRUE, ist der Cache weiterhin aktiviert, selbst wenn es einige Variablen im $_POST Array gibt (boolean, FALSE per Default) cache_with_session_variables: wenn TRUE, ist der Cache weiterhin aktiviert, selbst wenn es einige Variablen im $_SESSION Array gibt (boolean, FALSE per Default) cache_with_files_variables: wenn TRUE, ist der Cache weiterhin aktiviert, selbst wenn es einige Variablen im $_FILES Array gibt (boolean, FALSE per Default) cache_with_cookie_variables: wenn TRUE, ist der Cache weiterhin aktiviert, selbst wenn es einige Variablen im $_COOKIE Array gibt (boolean, TRUE per Default) make_id_with_get_variables: wenn TRUE, wird die Cache ID vom Inhalt des $_GET Arrays abhängig sein (boolean, TRUE per Default) make_id_with_post_variables: wenn TRUE, wird die Cache ID vom Inhalt des $_POST Arrays abhängig sein (boolean, TRUE per Default) make_id_with_session_variables: wenn TRUE, wird die Cache ID vom Inhalt des $_SESSION Arrays abhängig sein (boolean, TRUE per Default) make_id_with_files_variables: wenn TRUE, wird die Cache ID vom Inhalt des $_FILES Arrays abhängig sein (boolean, TRUE per Default) make_id_with_cookie_variables: wenn TRUE, wird die Cache ID vom Inhalt des $_COOKIE Arrays abhängig sein (int, FALSE by default) specific_lifetime: wenn nicht FALSE, wird die angegebene Lifetime für das ausgewählte Regex verwendet (array, array() by default) tags: Tags für den Cache Eintrag (int, NULL by default) priority: Priorität (wenn das Backend das unterstützt)|
   +----------------+---------+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |regexps         |Array    |array()                 |Ein assoziatives Array, um Optionen nur für einige REQUEST_URI zu setzen. Die Schlüssel sind reguläre Ausdrücke (PCRE), die Werte sind ein assoziatives Array mit spezifischen Optionen, die gesetzt werden sollen, wenn der reguläre Ausdruck auf $_SERVER['REQUEST_URI'] passt (siehe die default_options für eine Liste der verfügbaren Optionen); wenn verschiedene reguläre Ausdrücke auf $_SERVER['REQUEST_URI'] passen, wird nur der letzte verwendet.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
   +----------------+---------+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |memorize_headers|Array    |array()                 |Ein Array von Strings die zu einem HTTP Headernamen korrespondieren. Aufgelistete Header werden mit den Cache Daten gespeichert und wieder "abgespielt" wenn der Cache getroffen wird.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
   +----------------+---------+------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.frontends.page.examples:

Beispiele
^^^^^^^^^

Die Verwendung von ``Zend\Cache_Frontend\Page`` ist wirklich trivial :

.. code-block:: php
   :linenos:

   // [...] // Benötigt, Konfiguration und Factory

   $cache->start();
   // Wenn der Cache gefunden wurde, wird das Ergebnis zum Browser geschickt,
   // und das Skript stoppt hier

   // Rest der Seite ...

Ein etwas komplexeres Beispiel, welches einen Weg zeigt, um ein zentralisiertes Cache Management in einer Bootstrap
Datei zu erhalten (um es z.B. mit ``Zend_Controller`` zu verwenden)

.. code-block:: php
   :linenos:

   /*
    * Es sollte vermieden werden, zu viele Zeilen vor dem Cache Bereich zu setzen
    * zum Beispiel sollten für optimale Performanz "require_once" oder
    * "Zend\Loader\Loader::loadClass" nach dem Cache Bereich stehen
    */

   $frontendOptions = array(
      'lifetime' => 7200,
      'debug_header' => true, // für das Debuggen
      'regexps' => array(
          // cache den gesamten IndexController
          '^/$' => array('cache' => true),

          // cache den gesamten IndexController
          '^/index/' => array('cache' => true),

          // wir cachen nicht den ArticleController...
          '^/article/' => array('cache' => false),

          // ...aber wir cachen die "View" Aktion von diesem ArticleController
          '^/article/view/' => array(
              'cache' => true,

              // und wir cachen sogar wenn es einige Variablen in $_POST gibt
              'cache_with_post_variables' => true,

              // aber die Cache Id wird vom $_POST Array abhängig sein
              'make_id_with_post_variables' => true,
          )
      )
   );

   $backendOptions = array(
       'cache_dir' => '/tmp/'
   );

   // erhalte ein Zend\Cache_Frontend\Page Objekt
   $cache = Zend\Cache\Cache::factory('Page',
                                'File',
                                $frontendOptions,
                                $backendOptions);

   $cache->start();

   // Wenn der Cache gefunden wurde, wird das Ergebnis zum Browser geschickt,
   // und das Skript stoppt hier

   // [...] das Ende der Bootstrap Datei
   // diese Zeilen werden nicht ausgeführt, wenn der Cache ausgegeben wurde

.. _zend.cache.frontends.page.cancel:

Die spezielle cancel Methode
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Aus Designgründen, kann es in einigen Fällen (zum Beispiel bei Verwendung von nicht *HTTP* 200 Return Codes),
notwendig sein den aktuellen Cacheprozess zu unterbrechen. Deshalb zeigen wir für dieses spezielle Frontend die
``cancel()`` Methode.

.. code-block:: php
   :linenos:

   // [...] // Benötigt, Konfiguration und Factory

   $cache->start();

   // [...]

   if ($someTest) {
       $cache->cancel();
       // [...]
   }

   // [...]

.. _zend.cache.frontends.capture:

Zend\Cache_Frontend\Capture
---------------------------

.. _zend.cache.frontends.capture.introduction:

Einführung
^^^^^^^^^^

``Zend\Cache_Frontend\Capture`` ist wie ``Zend\Cache_Frontend\Output`` aber für komplette Seiten gestaltet. Es ist
nicht möglich ``Zend\Cache_Frontend\Capture`` für das Cachen eines einzelnen Blocks zu verwenden. Diese Klasse
ist speziell dazu gestaltet um nur in Verbindung mit dem ``Zend\Cache_Backend\Static`` Backend zu funktionieren
indem es komplette Seiten von *HTML*/*XML* oder anderen Inhalten in einer statischen physikalischen Datei auf dem
lokalen Dateisystem cached.

Sehen Sie bitte in die Dokumentation von ``Zend\Cache_Backend\Static`` für alle Use Cases bezüglich dieser
Klasse.

.. note::

   Dieses Frontend arbeitet indem es eine Callback Funktion registriert welche aufgerufen wird wenn das Buffern der
   Ausgabe welches es verwendet, gelöscht wird. Damit dies korrekt arbeitet muss es der letzte Ausgabebuffer in
   der Anfrage sein. Um dies zu garantieren *muss* der Ausgabebuffer, den der Dispatcher verwendet, deaktiviert
   sein indem die ``setParam()`` Methode von ``Zend\Controller\Front`` verwendet wird. Zum Beispiel
   ``$front->setParam('disableOutputBuffering', true)`` oder durch Hinzufügen von
   "resources.frontcontroller.params.disableOutputBuffering = true" zum eigenen Konfigurationsdatei der Bootstrap
   (*INI* angenommen) wenn ``Zend_Application`` verwendet wird.


