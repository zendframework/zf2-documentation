.. EN-Revision: none
.. _zend.cache.backends:

Zend_Cache Backends
===================

Es gibt zwei Arten von Backends: Standard und erweiterte. Natürlich bieten erweiterte Backends mehr Features.

.. _zend.cache.backends.file:

Zend\Cache_Backend\File
-----------------------

Dieses (erweiterte) Backend speichert Cache Datensätze in Dateien (in einem gewählten Verzeichnis).

Mögliche Optionen sind :

.. _zend.cache.backends.file.table:

.. table:: File Backend Optionen

   +--------------------------+---------+------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option                    |Daten Typ|Standardwert|Beschreibung                                                                                                                                                                                                                                                                                                                                                                         |
   +==========================+=========+============+=====================================================================================================================================================================================================================================================================================================================================================================================+
   |cache_dir                 |String   |'/tmp/'     |Verzeichnis, in dem die Cache Dateien gespeichert werden                                                                                                                                                                                                                                                                                                                             |
   +--------------------------+---------+------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |file_locking              |Boolean  |TRUE        |Ein- oder Ausschalten von file_locking: kann die Beschädigung des Caches unter schlechten Bedingungen verhindern, aber es hilft nicht bei Multithreaded Webservern oder bei NFS Filesystemen...                                                                                                                                                                                      |
   +--------------------------+---------+------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |read_control              |Boolean  |TRUE        |Ein- oder Ausschalten von read_control: eingeschaltet wird ein Kontrollschlüssel im Cache File inkludiert und dieser Schlüssel wird mit dem Schlüssel verglichen, der nach dem Lesen berechnet wird.                                                                                                                                                                                 |
   +--------------------------+---------+------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |read_control_type         |String   |'crc32'     |Typ der Schreibkontrolle (nur wenn read_control eingeschaltet ist). Mögliche Werte sind : 'md5' (bestes, aber am Langsamsten), 'crc32' (etwas weniger sicher, aber schneller, beste Wahl), 'adler32' (neue Wahl, schneller als crc32), 'strlen' um nur die Länge zu testen (schnellstes).                                                                                            |
   +--------------------------+---------+------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |hashed_directory_level    |Integer  |0           |Level der gehashten Verzeichnis Struktur: 0 heißt "keine gehashte Verzeichnis Strutur, 1 heißt "ein Level von Verzeichnissen", 2 heißt "zwei Levels"... Diese Option kann den Cache nur dann schneller machen, wenn viele Tausende Cache Dateien verwendet werden. Nur spezielle Messungen können helfen, den perfekten Wert zu finden. Möglicherweise ist 1 oder 2 ein guter Anfang.|
   +--------------------------+---------+------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |hashed_directory_umask    |Integer  |0700        |Umask für die gehashte Verzeichnis Struktur                                                                                                                                                                                                                                                                                                                                          |
   +--------------------------+---------+------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |file_name_prefix          |String   |'zend_cache'|Präfix für Cache Dateien; man muss mit dieser Option sehr vorsichtig umgehen, weil ein zu generischer Wert in einem System Cache Verzeichnis (wie /tmp) kann beim Löschen des Caches zu großen Problemen führen.                                                                                                                                                                     |
   +--------------------------+---------+------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cache_file_umask          |Integer  |0700        |umask nach Cache Dateien                                                                                                                                                                                                                                                                                                                                                             |
   +--------------------------+---------+------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |metatadatas_array_max_size|Integer  |100         |Interne maximale Größe für das Metadaten Array (dieser Wert sollte nicht geändert werden außer man weiß was man macht)                                                                                                                                                                                                                                                               |
   +--------------------------+---------+------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.backends.sqlite:

Zend\Cache_Backend\Sqlite
-------------------------

Dieses (erweiterte) Backend speichert die Cache Datensätze in einer SQLite Datenbank.

Mögliche Optionen sind :

.. _zend.cache.backends.sqlite.table:

.. table:: Sqlite Backend Optionen

   +----------------------------------+---------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option                            |Daten Typ|Standardwert|Beschreibung                                                                                                                                                                                                                                                                                                                                                                                                                 |
   +==================================+=========+============+=============================================================================================================================================================================================================================================================================================================================================================================================================================+
   |cache_db_complete_path (mandatory)|String   |NULL        |Der komplette Pfad (inklusive Dateiname) der SQLite Datenbank                                                                                                                                                                                                                                                                                                                                                                |
   +----------------------------------+---------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |automatic_vacuum_factor           |Integer  |10          |Deaktiviert oder stellt den automatischen Vakuumprozess ein. Der automatische Vakuumprozess defragmentiert die Datenbankdatei (und verkleinert sie) wenn clean() oder delete() aufgerufen wird: 0 bedeutet kein automatisches Vakuum; 1 bedeutet systematisches Vakuum (wenn die delete() or clean() Methoden aufgerufen werden; x (integer) > 1 => automatisches Vakuum zufällig einmal pro x clean() oder delete() Aufrufe.|
   +----------------------------------+---------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.backends.memcached:

Zend\Cache_Backend\Memcached
----------------------------

Dieses (erweiterte) Backend speichert Cache Datensätze in einem Memcached Server. `memcached`_ ist ein
hoch-performantes, verteiltes Speicher Objekt Caching System. Um dieses Backend zu benutzen, wird ein Memcached
Dämon benötigt und `die Memcached PECL Erweiterung`_.

Vorsicht: mit diesem Backend werden zur Zeit "Marker" nicht unterstützt genauso wie das
"doNotTestCacheValidity=true" Argument.

Mögliche Optionen sind :

.. _zend.cache.backends.memcached.table:

.. table:: Memcached Backend Optionen

   +-------------+---------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option       |Daten Typ|Standardwert                                                                                                                                                                 |Beschreibung                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
   +=============+=========+=============================================================================================================================================================================+===================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================+
   |servers      |Array    |array(array('host' => 'localhost','port' => 11211, 'persistent' => true, 'weight' => 1, 'timeout' => 5, 'retry_interval' => 15, 'status' => true, 'failure_callback' => '' ))|Ein Array von Memcached Servern; jeder Memcached Server wird durch ein assoziatives Array beschrieben : 'host' => (string) : Der Name des Memcached Servers, 'port' => (int) : Der Port des Memcached Servers, 'persistent' => (bool) : Persistente Verbindungen für diesen Memcached Server verwenden oder nicht 'weight' => (int) : Das Gewicht des Memcached Servers, 'timeout' => (int) : Das Timeout des Memcached Servers, 'retry_interval' => (int) : Das Wiederholungsintervall des Memcached Servers, 'status' => (bool) : Der Status des Memcached Servers, 'failure_callback' => (callback) : Der failure_callback des Memcached Servers|
   +-------------+---------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |compression  |Boolean  |FALSE                                                                                                                                                                        |TRUE wenn on-the-fly Kompression verwendet werden soll                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
   +-------------+---------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |compatibility|Boolean  |FALSE                                                                                                                                                                        |TRUE wenn man den Compatibility Modus mit alten Memcache Servern oder Erweiterungen verwenden will                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
   +-------------+---------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.backends.apc:

Zend\Cache_Backend\Apc
----------------------

Dieses (erweiterte) Backend speichert Cache Datensätze im Shared Memory durch die `APC`_ (Alternativer *PHP*
Cache) Erweiterung (welche natürlich für die Verwendung dieses Backends benötigt wird).

Vorsicht: mit diesem Backend werden "Marker" zur Zeit nicht unterstützt genauso wie das
"doNotTestCacheValidity=true" Argument.

Es gibt keine Optionen für dieses Backend.

.. _zend.cache.backends.xcache:

Zend\Cache_Backend\Xcache
-------------------------

Dieses Backend speichert Cache Einträge im Shared Memory durch die `XCache`_ Erweiterung (welche natürlich
benötigt wird, damit dieses Backend verwendet werden kann).

Achtung: Bei diesem Backend werden "tags" aktuell nicht unterstützt sowie das "doNotTestCacheValidity=true"
Argument.

Mögliche Optionen sind:

.. _zend.cache.backends.xcache.table:

.. table:: Xcache backend options

   +--------+---------+------------+---------------------------------------------------------------------------------+
   |Option  |Daten Typ|Standardwert|Beschreibung                                                                     |
   +========+=========+============+=================================================================================+
   |user    |String   |NULL        |xcache.admin.user, notwendig für die clean() Methode                             |
   +--------+---------+------------+---------------------------------------------------------------------------------+
   |password|String   |NULL        |xcache.admin.pass (in offener Form, nicht MD5), notwendig für die clean() Methode|
   +--------+---------+------------+---------------------------------------------------------------------------------+

.. _zend.cache.backends.platform:

Zend\Cache_Backend\ZendPlatform
-------------------------------

Dieses Backend verwendet die Content Caching *API* des `Zend Platform`_ Produktes. Natürlich muss man die Zend
Platform installiert haben, um dieses Backend verwenden zu können.

Dieses Backend unterstützt Tags, aber nicht den ``CLEANING_MODE_NOT_MATCHING_TAG`` Löschmodus.

Bei Definition dieses Backends muß ein Trennzeichen -- '-', '.', ' ', oder '\_' -- zwischen den Wörtern 'Zend'
und 'Platform' definiert sein wenn die ``Zend\Cache\Cache::factory()`` Methode verwendet wird:

.. code-block:: php
   :linenos:

   $cache = Zend\Cache\Cache::factory('Core', 'Zend Platform');

Es gibt keine Optionen für dieses Backend.

.. _zend.cache.backends.twolevels:

Zend\Cache_Backend\TwoLevels
----------------------------

Dieses (erweiterte) Backend ist ein Hybrides. Es speichert Cache Einträge in zwei anderen Backends: Ein schnelles
(aber limitiertes) wie Apc, Memcache... und ein "langsames" wie File, Sqlite...

Dieses Backend verwendet den Priority Parameter (der auf Frontend Level angegeben wird wenn ein Eintrag gespeichert
wird) und den verbleibenden Platz im schnellen Backend um die Verwendung dieser zwei Backends zu optimieren.

Dieses Backend sollte mit Verwendung eines Word Separators -- '-', '.', ' ', oder '\_' -- zwischen den Wörtern
'Two' und 'Levels' spezifiziert werden wenn die ``Zend\Cache\Cache::factory()`` Methode verwendet wird:

.. code-block:: php
   :linenos:

   $cache = Zend\Cache\Cache::factory('Core', 'Two Levels');

Vorhandene Optionen sind:

.. _zend.cache.backends.twolevels.table:

.. table:: TwoLevels Backend Optionen

   +--------------------------+--------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option                    |Datentyp|Standardwert|Beschreibung                                                                                                                                                                                                                                   |
   +==========================+========+============+===============================================================================================================================================================================================================================================+
   |slow_backend              |String  |File        |Der "langsame" Backendname                                                                                                                                                                                                                     |
   +--------------------------+--------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |fast_backend              |String  |Apc         |Der "schnelle" Backendname                                                                                                                                                                                                                     |
   +--------------------------+--------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |slow_backend_options      |Array   |array()     |Die "langsamen" Backendoptionen                                                                                                                                                                                                                |
   +--------------------------+--------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |fast_backend_options      |Array   |array()     |Die "schnellen" Backendoptionen                                                                                                                                                                                                                |
   +--------------------------+--------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |slow_backend_custom_naming|Boolean |FALSE       |Wenn TRUE, wird das slow_backend Argument als kompletter Klassenname verwendet; wenn FALSE, wird das frontend Argument als Ende des "Zend\Cache_Backend\[...]" Klassennamens verwendet                                                         |
   +--------------------------+--------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |fast_backend_custom_naming|Boolean |FALSE       |Wenn TRUE, wird das fast_backend Argument als kompletter Klassenname verwendet; wenn FALSE, wird das frontend Argument als Ende des "Zend\Cache_Backend\[...]" Klassennamens verwendet                                                         |
   +--------------------------+--------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |slow_backend_autoload     |Boolean |FALSE       |Wenn TRUE, wird kein require_once für das langsame Backend verwendet (nur für eigene Backends nützlich)                                                                                                                                        |
   +--------------------------+--------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |fast_backend_autoload     |Boolean |FALSE       |Wenn TRUE, wird kein require_once für das schnelle Backend verwendet (nur für eigene Backends nützlich)                                                                                                                                        |
   +--------------------------+--------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |auto_refresh_fast_cache   |Boolean |TRUE        |Wenn TRUE, wird der schnelle Cache automatisch refresht wenn ein Cache Eintrag getroffen wird                                                                                                                                                  |
   +--------------------------+--------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |stats_update_factor       |Integer |10          |Ausschalten / Feintunen der Berechnung des Füll-Prozentsatzes des schnellen Backends (wenn ein Eintrag in den Cache gespeichert wird, die Berechnung des Füll-Prozentsatzes des schnellen Backends zufällig 1 mal bei x Cache Schreibvorgängen)|
   +--------------------------+--------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.backends.zendserver:

Zend\Cache\Backend\ZendServer\Disk und Zend\Cache\Backend\ZendServer\ShMem
--------------------------------------------------------------------------

Diese Backends speichern Cacheeinträge indem Sie die Caching Funktionalitäten von `Zend Server`_ verwenden.

Achtung: mit diesen Backends werden für den Moment "Tags" nicht unterstützt, wegen dem
"doNotTestCacheValidity=true" Argument.

Diese Backends arbeiten nur in einer Zend Server Umgebung für Seiten die über *HTTP* oder *HTTPS* angefragt
wurden und nicht für Kommandozeilen Ausführung.

Dieses Backend muß durch Verwendung des **customBackendNaming** Parameter mit ``TRUE`` spezifiziert werden wenn
die Methode ``Zend\Cache\Cache::factory()`` verwendet wird:

.. code-block:: php
   :linenos:

   $cache = Zend\Cache\Cache::factory('Core', 'Zend\Cache\Backend\ZendServer\Disk',
                                $frontendOptions, $backendOptions, false, true);

Es gibt keine Optionen für diese Backends.

.. _zend.cache.backends.static:

Zend\Cache_Backend\Static
-------------------------

Dieses Backend arbeitet in Verbindung mit ``Zend\Cache_Frontend\Capture`` (diese zwei müssen zusammen verwendet
werden) um die Ausgabe von Anfragen als statische Dateien zu speichern. Dies bedeutet das die statischen Dateien
bei weiteren Anfragen direkt serviert werden ohne dass *PHP* oder sogar Zend Framework involviert sind.

.. note::

   ``Zend\Cache_Frontend\Capture`` arbeitet indem es eine Callback Funktion registriert welche aufgerufen wird wenn
   der Ausgabebuffer den es verwendet gelöscht wird. Damit das richtig funktioniert muss er der letzte
   Ausgabebuffer in der Anfrage sein. Um dies zu garantieren **muss** der Ausgabebuffer welcher vom Dispacher
   verwendet wird ausgeschaltet sein indem ``Zend\Controller\Front``'s Methode ``setParam()`` verwendet wird, zum
   Beispiel ``$front->setParam('disableOutputBuffering', true);`` oder indem
   "resources.frontcontroller.params.disableOutputBuffering = true" in der Bootstrap Konfigurationsdatei (wir
   nehmen *INI* an) wenn ``Zend_Application`` verwendet wird.

Der Vorteil dieses Caches besteht darin das eine starke Verbesserung des Durchsatzes stattfindet weil statische
Dateien zurückgegeben werden und keine weitere dynamische Bearbeitung stattfindet. Natürlich gibt es auch einige
Nachteile. Der einzige Weg um dynamische Anfragen wieder zu haben besteht darin die gecachten Dateien von anderswo
in der Anwendung zu löschen (oder über einen Cronjob wenn das zeitlich abgestimmt werden soll). Es ist auch auf
Single-Server Anwendungen begrenzt begrenzt bei denen nur ein Dateisystem verwendet wird. Trotzdem kann es eine
große Bedeutung haben wenn man mehr Geschwindigkeit haben will ohne auf Kosten eines Proxies auf einzelnen
Maschinen zu setzen.

Bevor die Optionen beschrieben werden sollte man beachten das dies einige Änderungen der Standardwerte in der
``.htaccess`` Datei benötigt damit Anfrage auf die staischen Dateien zeigen wenn diese existieren. Hier ist ein
Beispiel einer einfachen Anwendung die etwas Inhalt cacht, inklusive zwei spezifischer Feeds welche zusätzliche
Behandlung benötigen um einen korrekten Content-Type Header zu schicken:

.. code-block:: text
   :linenos:

   AddType application/rss+xml .xml
   AddType application/atom+xml .xml

   RewriteEngine On

   RewriteCond %{REQUEST_URI} feed/rss$
   RewriteCond %{DOCUMENT_ROOT}/cached/%{REQUEST_URI}.xml -f
   RewriteRule .* cached/%{REQUEST_URI}.xml [L,T=application/rss+xml]

   RewriteCond %{REQUEST_URI} feed/atom$
   RewriteCond %{DOCUMENT_ROOT}/cached/%{REQUEST_URI}.xml -f
   RewriteRule .* cached/%{REQUEST_URI}.xml [L,T=application/atom+xml]

   RewriteCond %{DOCUMENT_ROOT}/cached/index.html -f
   RewriteRule ^/*$ cached/index.html [L]
   RewriteCond %{DOCUMENT_ROOT}/cached/%{REQUEST_URI}.(html|xml|json|opml|svg) -f
   RewriteRule .* cached/%{REQUEST_URI}.%1 [L]

   RewriteCond %{REQUEST_FILENAME} -s [OR]
   RewriteCond %{REQUEST_FILENAME} -l [OR]
   RewriteCond %{REQUEST_FILENAME} -d
   RewriteRule ^.*$ - [NC,L]

   RewriteRule ^.*$ index.php [NC,L]

Das obenstehende nimmt an das statische Dateien im Verzeichnis ``./public/cached`` gecacht werden. Wir betrachten
die Einstellung dieses Ortes unter "public_dir" weiter unten.

Durch die Natur des Cachens von statischen Dateien bietet die Backend Klasse zwei zusätzliche Methoden an:
``remove()`` und ``removeRecursively()``. Beide akzeptieren eine Anfrage *URI* welche, wenn Sie mit dem
"public_dir" in dem statische Dateien gecacht werden verknüpft wird, und eine vor-gespeicherte Erweiterung
angehängt wird, entweder den Namen einer statischen Datei anbietet welche zu löschen ist, oder einen
Verzeichnispfad welcher rekursiv zu löschen ist. Durch die Einschränkung von ``Zend\Cache_Backend\Interface``
akzeptieren alle anderen Methoden wie ``save()`` eine ID welche durch Anwendung von ``bin2hex()`` auf eine Anfrage
*URI* berechnet wird.

Durch das Level an dem das statische Cachen arbeitet ist das statische Dateicaching auf eine einfachere Verwendung
mit ``Zend\Controller\Action\Helper\Cache`` ausgelegt. Dieser Helfer assistiert beim Einstellen welche Aktionen
eines Controllers zu cachen sind, mit welchen Tags, und mit welcher Erweiterung. Er bietet auch Methoden für das
Entleeren des Caches durch die Anfrage *URI* oder Tag. Statischen Dateicaching wird auch durch
``Zend\Cache\Manager`` unterstützt welcher vorkonfigurierte Konfigurationstemplates für den statischen Cache
enthält (als ``Zend\Cache\Manager::PAGECACHE`` oder "page"). Die Standardwerte können hierbei wie benötigt
konfiguriert werden um einen "public_dir" Ort für das Cachen zu setzen, usw.

.. note::

   Es sollte beachtet werden dass der statische Cache aktuell einen zweiten Cache verwendet um Tags zu speichern
   (offensichtlich können wir Sie nicht anderswo speichern da bei einem statischen Cache *PHP* nicht aufgerufen
   wird wenn er richtig arbeitet). Das ist nur ein standardmäßiger Core Cache, und er sollte ein persistentes
   Backend wie File oder TwoLevels verwenden (um die Vorteile des Memory Speichers zu verwenden ohne die permanente
   Persistenz zu opfern). Das Backend enthält die Option "tag_cache" um es zu konfigurieren (das ist
   obligatorisch), oder die Methode ``setInnerCache()``.

.. _zend.cache.backends.static.table:

.. table:: Statische Backend Optionen

   +---------------------+--------+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option               |Datentyp|Standardwert|Beschreibung                                                                                                                                                                                                                                                                                                                                                  |
   +=====================+========+============+==============================================================================================================================================================================================================================================================================================================================================================+
   |public_dir           |String  |NULL        |Verzeichnis in dem statische Dateien zu speichern sind. Es muß im öffentlichen Verzeichnis existieren.                                                                                                                                                                                                                                                        |
   +---------------------+--------+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |file_locking         |Boolean |TRUE        |file_locking aktivieren oder deaktivieren: Kann die Korruption des Caches unter schlechten Umständen verhindern hilft aber nicht bei Multithreaded Webservern oder bei NFS Dateisystemen.                                                                                                                                                                     |
   +---------------------+--------+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |read_control         |Boolean |TRUE        |Lesekontrolle aktivieren oder deaktivieren: Aktiviert wird ein Kontrollschlüssel in die Cachedatei eingebettet und dieser Schlüssel wird mit dem verglichen der nach dem Lesen berechnet wird.                                                                                                                                                                |
   +---------------------+--------+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |read_control_type    |String  |'crc32'     |Typ der Lesekontrolle (nur wenn die Lesekontrolle aktiviert ist). Mögliche Werte sind: 'md5' (am besten aber langsam), 'crc32' (etwas weniger sicher aber schneller, bessere Wahl), 'adler32' (neue Wahl, schneller als cec32), 'strlen' für einen reinen Längentest (am schnellsten).                                                                        |
   +---------------------+--------+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cache_file_umask     |Integer |0700        |Umask für gecachte Dateien.                                                                                                                                                                                                                                                                                                                                   |
   +---------------------+--------+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cache_directory_umask|Integer |0700        |Umask für Verzeichnisse welche im public_dir erstellt wurden.                                                                                                                                                                                                                                                                                                 |
   +---------------------+--------+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |file_extension       |String  |'.html'     |Standardmäßige Dateierweiterung für erstellt statische Dateien. Diese kann im Fluge konfiguriert werden, siehe Zend\Cache_Backend\Static::save() obwohl generell empfohlen wird sich auf Zend\Controller\Action\Helper\Cache zu verlassen wenn man das macht, weil es ein einfacherer Weg ist als mit Arrays oder der manuellen Serialisierung herumzuspielen.|
   +---------------------+--------+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |index_filename       |String  |'index'     |Wenn eine Anfrage URI nicht genügend Informationen enthält um eine statische Datei zu erstellen (normalerweise bedeutet dies einen Indexaufruf, z.B. die URI von '/'), dann wir stattdessen index_filename verwendet. Deshalb würden '' oder '/' auf 'index.html' verweisen (in der Annahme das die standardmäßige file_extension '.html' ist).               |
   +---------------------+--------+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |tag_cache            |Object  |NULL        |Wird verwendet um einen 'inner' Cache zu Setzen der verwendet wird um Tags zu speichern und Dateierweiterungen mit statischen Dateien zu verknüpfen. Das muss gesetzt sein, oder der statische Cache kann nicht verfolgt und gemanagt werden.                                                                                                                 |
   +---------------------+--------+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |disable_caching      |Boolean |FALSE       |Wenn es auf TRUE gesetzt wird, werden statische Dateien nicht gecacht. Das zwingt alle Anfragen dynamisch zu sein, selbst wenn diese markiert und in den Controller gecacht sind. Dies ist für das Debuggen nützlich.                                                                                                                                         |
   +---------------------+--------+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+



.. _`memcached`: http://www.danga.com/memcached/
.. _`die Memcached PECL Erweiterung`: http://pecl.php.net/package/memcache
.. _`APC`: http://pecl.php.net/package/APC
.. _`XCache`: http://xcache.lighttpd.net/
.. _`Zend Platform`: http://www.zend.com/en/products/platform
.. _`Zend Server`: http://www.zend.com/en/products/server/downloads-all?zfs=zf_download
