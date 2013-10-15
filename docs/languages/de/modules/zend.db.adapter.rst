.. EN-Revision: none
.. _zend.db.adapter:

Zend\Db\Adapter
===============

``Zend_Db`` und die zugehörigen Klassen bieten eine einfache *SQL* Schnittstelle für Zend Framework.
``Zend\Db\Adapter`` ist die Basisklasse zur Anbindung einer *PHP* Anwendung an ein *RDBMS*. Es gibt für jede
*RDBMS* Marke einen eigenen Adapter.

Die ``Zend_Db`` Adapter bilden eine Schnittstelle zu den Hersteller spezifischen *PHP* Erweiterungen und
unterstützen dadurch die Entwicklung einer *PHP* Anwendung für verschiedene *RDBMS* mit geringem Aufwand.

Die Schnittstellen der Adapterklasse ähneln denen der `PHP Data Objects`_ Erweiterung. ``Zend_Db`` bietet
Adapterklassen für *PDO* Treiber der folgenden *RDBMS* Marken:

- *IBM* *DB2* und Informix Dynamic Server (*IDS*), verwenden die `pdo_ibm`_ *PHP* Erweiterung

- MySQL, verwendet die `pdo_mysql`_ *PHP* Erweiterung

- Microsoft *SQL* Server, verwendet die `pdo_dblib`_ *PHP* Erweiterung

- Oracle, verwendet die `pdo_oci`_ *PHP* Erweiterung

- PostgreSQL, verwendet die `pdo_pgsql`_ *PHP* Erweiterung

- SQLite, verwendet die `pdo_sqlite`_ *PHP* Erweiterung

Zusätzlich bietet ``Zend_Db`` Adapterklassen für die folgenden *RDBMS* Marken, welche eigene *PHP* Datenbank
Erweiterungen nutzen:

- MySQL, mit der `mysqli`_ *PHP* Erweiterung

- Oracle, mit der `oci8`_ *PHP* Erweiterung

- *IBM* *DB2* und *DB2* I5, mit der `ibm_db2`_ *PHP* Erweiterung

- Firebird (Interbase), mit der `php_interbase`_ *PHP* Erweiterung

.. note::

   Jeder ``Zend_Db`` Adapter nutzt eine *PHP* Erweiterung. Die entsprechend *PHP* Erweiterung muss in der *PHP*
   Umgebung aktiviert sein um den ``Zend_Db`` Adapter zu nutzen. Zum Beispiel muss bei der Nutzung eines *PDO*
   ``Zend_Db`` Adapters sowohl die *PDO* Erweiterung, als auch der *PDO* Treiber für die jeweilige *RDBMS* Marke
   geladen sein.

.. _zend.db.adapter.connecting:

Anbindung einer Datenbank mit einem Adapter
-------------------------------------------

Dieser Abschnitt beschreibt wie eine Instanz eines Datenbankadapters erzeugt wird. Dies entspricht der Erzeugung
einer Verbindung an ein *RDBMS* Server in einer *PHP* Anwendung.

.. _zend.db.adapter.connecting.constructor:

Nutzung des Zend_Db Adapter Konstruktors
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Man kann eine Instanz eines Adapters erzeugen, indem man den Konstruktor verwendet. Ein Adapter Konstruktur
benötigt ein Argument, wobei es sich um ein Array mit Parametern für die Verbindung handelt.

.. _zend.db.adapter.connecting.constructor.example:

.. rubric:: Nutzung eines Adapter Konstruktors

.. code-block:: php
   :linenos:

   $db = new Zend\Db\Adapter\Pdo\Mysql(array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test'
   ));

.. _zend.db.adapter.connecting.factory:

Nutzung der Zend_Db Factory
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Als Alternative zur direkten Nutzung des Konstruktors kann man auch eine Instanz des Adapters erzeugen indem man
die statische Methode ``Zend\Db\Db::factory()`` nutzt. Diese Methode lädt die Adapterklasse dynamisch bei Aufruf
unter Nutzung von :ref:`Zend\Loader\Loader::loadClass() <zend.loader.load.class>`.

Das erste Argument ist ein String der den Namen der Adapterklasse enthält. Zum Beispiel entspricht der String
'``Pdo_Mysql``' der Klasse ``Zend\Db\Adapter\Pdo\Mysql``. Das zweite Argument ist das gleiche Array von Parametern
wie bei der Verwendung des Adapter Konstruktors.

.. _zend.db.adapter.connecting.factory.example:

.. rubric:: Nutzung der Adapter factory() Methode

.. code-block:: php
   :linenos:

   // Wir benötigen das folgende Statement nicht da die
   // Zend\Db\Adapter\Pdo\Mysql Datei für uns durch die Factory
   // Methode von Zend_Db geladen wird

   // Lädt automatisch die Klasse Zend\Db\Adapter\Pdo\Mysql
   // und erzeugt eine Instanz von Ihr.
   $db = Zend\Db\Db::factory('Pdo_Mysql', array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test'
   ));

Wenn eine eigene Klasse geschrieben wird, die ``Zend\Db\Adapter\Abstract`` erweitert aber nicht mit dem Präfix
"``Zend\Db\Adapter``" beginnt, kann die ``factory()`` Methode verwendet werden um den Adapter zu Laden wenn der
führende Teil der Adapter Klasse mit dem 'adapterNamespace' Schlüssel im Parameter Array spezifiziert wird.

.. _zend.db.adapter.connecting.factory.example2:

.. rubric:: Die factory Methode für eine eigene Adapter Klasse verwenden

.. code-block:: php
   :linenos:

   // Wir müssen die Datei der Adapter Klasse nicht laden
   // weil Sie für uns durch die Factory Methode von Zend_Db geladen wird

   // Die MyProject_Db_Adapter_Pdo_Mysql Klasse automatisch laden
   // und eine Instanz von Ihr erstellen.
   $db = Zend\Db\Db::factory('Pdo_Mysql', array(
       'host'             => '127.0.0.1',
       'username'         => 'webuser',
       'password'         => 'xxxxxxxx',
       'dbname'           => 'test',
       'adapterNamespace' => 'MyProject_Db_Adapter'
   ));

.. _zend.db.adapter.connecting.factory-config:

Zend_Config mit Zend\Db\Factory verwenden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Optional kann jedes Argument der ``factory()`` Methode als Objekt des Typs :ref:`Zend_Config <zend.config>`
spezifiziert werden.

Wenn das erste Argument ein Config Objekt ist, wird erwartet das es eine Eigenschaft enthält die ``adapter``
heißt und einen String enthält der nach dem Adapter Basis Klassen Namen benannt ist. Optional kann das Objekt
eine Eigenschaft genannt ``params`` enthalten, mit Subeigenschaften korrespondierend zu den Parameter Namen des
Adapters. Das wird nur verwendet wenn das zweite Argument für die ``factory()`` Methode nicht angegeben wird.

.. _zend.db.adapter.connecting.factory.example1:

.. rubric:: Verwenden der Factory Methode des Adapters mit einem Zend_Config Objekt

Im Beispiel anbei wird ein ``Zend_Config`` Objekt von einem Array erstellt. Die Daten können auch aus einer
externen Datei geladen werden indem Klassen wie zum Beispiel :ref:`Zend\Config\Ini <zend.config.adapters.ini>` oder
:ref:`Zend\Config\Xml <zend.config.adapters.xml>` verwendet werden.

.. code-block:: php
   :linenos:

   $config = new Zend\Config\Config(
       array(
           'database' => array(
               'adapter' => 'Mysqli',
               'params'  => array(
                   'host'     => '127.0.0.1',
                   'dbname'   => 'test',
                   'username' => 'webuser',
                   'password' => 'secret',
               )
           )
       )
   );

   $db = Zend\Db\Db::factory($config->database);

Das zweite Argument der ``factory()`` Methode kann ein assoziatives Array sein das Einträge enthält die den
Parameters des Adapters entsprechen. Dieses Argument ist optional. Wenn das erste Argument vom Typ ``Zend_Config``
ist, wird angenommen das es alle Parameter enthält, und das zweite Argument wird ignoriert.

.. _zend.db.adapter.connecting.parameters:

Adapter Parameter
^^^^^^^^^^^^^^^^^

Die folgende Liste erklärt die gemeinsamen Parameter die von ``Zend_Db`` Adapterklassen erkannt werden.

- **host**: Ein String der den Hostname oder die Ip-Adresse des Datenbankservers beinhaltet. Wenn die Datenbank auf
  dem gleichen Host wie die *PHP* Anwendung läuft wird 'localhost' oder '127.0.0.1' verwendet.

- **username**: Konto Kennung zur Authentisierung einer Verbindung zum *RDBMS* Server.

- **password**: Konto Passwort zur Authentisierung einer Verbindung zum *RDBMS* Server.

- **dbname**: Datenbank Name auf dem *RDBMS* Server.

- **port**: Einige *RDBMS* Server können Netzwerkverbindungen an vom Administrator spezifizierten Ports
  akzeptieren. Der Port-Parameter gibt die Möglichkeit die Portnummer anzugeben, an welche die *PHP* Anwendung
  verbindet um der Port-Konfiguration des *RDBMS* Servers zu entsprechen.

- **charset**: Spezifiziert das Zeichenset das für diese Verbindung verwendet werden soll.

- **options**: Dieser Parameter ist ein assoziatives Array von Optionen die in allen ``Zend\Db\Adapter`` Klassen
  enthalten sind.

- **driver_options**: Dieser Parameter ist ein assoziatives Array von zusätzlichen Optionen die spezifisch für
  die angegebene Datenbankerweiterung sind. Eine typische Anwendung dieses Parameters ist, Attribute für einen
  *PDO* Treiber zu setzen.

- **adapterNamespace**: Benennt den führenden Teil des Klassen Namens für den Adapter statt
  '``Zend\Db\Adapter``'. Dies kann verwendet werden wenn man die ``factory()``\ Methode verwenden muß um eine
  nicht von Zend kommende Datenbank Adapter Klasse zu laden.

.. _zend.db.adapter.connecting.parameters.example1:

.. rubric:: Übergeben der case-folding Option an die factory

Diese Option kann über die Konstante ``Zend\Db\Db::CASE_FOLDING`` angegeben werden. Sie entspricht dem ``ATTR_CASE``
Attribut in *PDO* und *IBM* *DB2* Datenbanktreibern und stellt die Schreibweise von String Schlüsseln in
Abfrageergebnissen ein. Die Option kann den Wert ``Zend\Db\Db::CASE_NATURAL`` (der Standard), ``Zend\Db\Db::CASE_UPPER``
oder ``Zend\Db\Db::CASE_LOWER`` annehmen.

.. code-block:: php
   :linenos:

   $options = array(
       Zend\Db\Db::CASE_FOLDING => Zend\Db\Db::CASE_UPPER
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'options'        => $options
   );

   $db = Zend\Db\Db::factory('Db2', $params);

.. _zend.db.adapter.connecting.parameters.example2:

.. rubric:: Übergeben der auto-quoting Option an die factory

Diese Option kann über die Konstante ``Zend\Db\Db::AUTO_QUOTE_IDENTIFIERS`` angegeben werden. Wenn der Wert ``TRUE``
(der Standard) ist, werden Bezeichner wie Tabellennamen, Spaltennamen und auch Aliase in jeder *SQL* Syntax die vom
Adapter Objekt generiert wurde begrenzt. Dies macht es einfach Bezeichner zu verwenden, die *SQL* Schlüsselwörter
oder spezielle Zeichen enthalten. Wenn der Wert ``FALSE`` ist, werden Bezeichner nicht automatisch begrenzt. Wenn
Bezeichner begrenzt werden müssen, so kann dies über die ``quoteIdentifier()`` Methode von Hand getan werden.

.. code-block:: php
   :linenos:

   $options = array(
       Zend\Db\Db::AUTO_QUOTE_IDENTIFIERS => false
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'options'        => $options
   );

   $db = Zend\Db\Db::factory('Pdo_Mysql', $params);

.. _zend.db.adapter.connecting.parameters.example3:

.. rubric:: Übergeben von PDO Treiber Optionen an die factory

.. code-block:: php
   :linenos:

   $pdoParams = array(
       PDO::MYSQL_ATTR_USE_BUFFERED_QUERY => true
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'driver_options' => $pdoParams
   );

   $db = Zend\Db\Db::factory('Pdo_Mysql', $params);

   echo $db->getConnection()
           ->getAttribute(PDO::MYSQL_ATTR_USE_BUFFERED_QUERY);

.. _zend.db.adapter.connecting.parameters.example4:

.. rubric:: Übergabe einer Serialisierungs Option an die Factory

.. code-block:: php
   :linenos:

   $options = array(
       Zend\Db\Db::ALLOW_SERIALIZATION => false
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'options'        => $options
   );

   $db = Zend\Db\Db::factory('Pdo_Mysql', $params);

.. _zend.db.adapter.connecting.getconnection:

Verwalten von Lazy Connections
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die Erzeugung einer Instanz der Adapterklasse stellt nicht gleichzeitig eine Verbindung zum *RDBMS* her. Der
Adapter speichert die Verbindungsparameter und stellt die tatsächliche Verbindung bei Bedarf her, wenn die erste
Anfrage ausgeführt wird. Dies stellt sicher, dass die Erzeugung eines Adapterobjekts schnell und sparsam ist.
Dadurch kann auch dann eine Instanz eines Adapters erzeugt werden, wenn nicht zwingend eine Datenbankanfrage für
die aktuell gelieferte Darstellung der Anwendung benötigt wird.

Wenn der Adapter zwingend eine Verbindung zum *RDBMS* herstellen soll, kann die ``getConnection()`` Methode
verwendet werden. Diese liefert ein Objekt der Verbindung, welches eine Verbindung entsprechend der verwendeten
*PHP* Erweiterung repräsentiert. Wenn zum Beispiel irgendeine der *PDO* Adapterklassen verwendet wird, dann
liefert ``getConnection()`` das *PDO* Object, nachdem es als eine live Verbindung zu der entsprechenden Datenbank
initialisiert wurde.

Es kann nützlich sein eine Verbindung zu erzwingen um jegliche Exceptions abzufangen, die als Resultat falscher
Konto Berechtigungen oder einem anderen Fehler bei der Verbindung zum *RDBMS* auftreten. Diese Exceptions treten
nicht auf, bis die tatsächliche Verbindung hergestellt ist, daher kann es den Anwendungs-Code vereinfachen, wenn
diese Exceptions an einer Stelle bearbeitet werden, und nicht erst bei der ersten Anfrage.

Zusätzlich kann ein Adapter serialisiert werden um Ihn zu speichern, zum Beispiel in einer Session Variable. Das
kann sehr nütlich sein, nicht nur für den Adapter selbst, sondern auch für andere Objekte die Ihn verwenden, wie
ein ``Zend\Db\Select`` Objekt. Standardmäßig, ist es Adaptern erlaubt serialisiert zu werden. Wenn man das nicht
will, sollte man die ``Zend\Db\Db::ALLOW_SERIALIZATION`` Option mit ``FALSE`` übergeben, wie im Beispiel anbei
gezeigt. Um das Prinzip von Lazy Connections zu erlauben, wird der Adapter sich selbst nicht wiederverbinden wenn
er deserialisiert wird. Man muß ``getConnection()`` selbst aufrufen. Mann kann den Adapter dazu bringen sich
automatisch wieder zu verbinden indem ``Zend\Db\Db::AUTO_RECONNECT_ON_UNSERIALIZE`` als Option mit ``TRUE`` zum
Adapter übergeben wird.

.. _zend.db.adapter.connecting.getconnection.example:

.. rubric:: Umgang mit Verbindungs Exceptions

.. code-block:: php
   :linenos:

   try {
       $db = Zend\Db\Db::factory('Pdo_Mysql', $parameters);
       $db->getConnection();
   } catch (Zend\Db\Adapter\Exception $e) {
       // Möglicherweise ein fehlgeschlagener login,
       // oder die RDBMS läuft möglicherweise nicht
   } catch (Zend_Exception $e) {
       // Möglicherweise kann factory() die definierte Adapter Klasse nicht laden
   }

.. _zend.db.adapter.example-database:

Beispiel Datenbank
------------------

In der Dokumentation für die ``Zend_Db`` Klassen verwenden wir einige einfache Tabellen um die Verwendung der
Klassen und Methoden zu erläutern. Diese Beispieltabellen können Informationen für das Bugtracking in einem
Softwareprojekt speichern. Die Datenbank enthält vier Tabellen:

- **accounts** speichert Informationen über jeden Benutzer des Bugtracking Systems.

- **products** speichert Informationen über jedes Produkt für das ein Bug erfasst werden kann.

- **bugs** speichert informationen über Bugs, dazu gehört der derzeitige Status des Bugs, die Person die den Bug
  berichtet hat, die Person die den Bug beheben soll und die Person welche die Fehlerbehebung verifizieren soll.

- **bugs_products** speichert Beziehungen zwischen Bugs und Produkten. Dies enthält eine Viele-zu-Viele Beziehung,
  da ein Bug für mehrere Produkte relevant sein kann. Und natürlich kann ein Produkt auch mehrere Bugs enthalten.

Der folgende *SQL* Daten Definitions Sprache Pseudocode beschreibt die Tabellen in dieser Beispieldatenbank. Diese
Beispieltabellen werden intensiv bei den automatisierten Unit-Tests für ``Zend_Db`` verwendet.

.. code-block:: sql
   :linenos:

   CREATE TABLE accounts (
   account_name      VARCHAR(100) NOT NULL PRIMARY KEY
   );

   CREATE TABLE products (
   product_id        INTEGER NOT NULL PRIMARY KEY,
   product_name      VARCHAR(100)
   );

   CREATE TABLE bugs (
   bug_id            INTEGER NOT NULL PRIMARY KEY,
   bug_description   VARCHAR(100),
   bug_status        VARCHAR(20),
   reported_by       VARCHAR(100) REFERENCES accounts(account_name),
   assigned_to       VARCHAR(100) REFERENCES accounts(account_name),
   verified_by       VARCHAR(100) REFERENCES accounts(account_name)
   );

   CREATE TABLE bugs_products (
   bug_id            INTEGER NOT NULL REFERENCES bugs,
   product_id        INTEGER NOT NULL REFERENCES products,
   PRIMARY KEY       (bug_id, product_id)
   );

Weiterhin zu beachten ist, dass die 'bugs' Tabelle mehrere Foreign-Key References zu der 'accounts' Tabelle
enthält. Jeder dieser Foreign-Keys kann auf eine andere Zeile für einen angegebenen Bug in der 'accounts' Tabelle
verweisen.

Das unten stehende Diagramm illustriert das physische Datenmodell der Beispieldatenbank.

.. image:: ../images/zend.db.adapter.example-database.png
   :width: 387
   :align: center

.. _zend.db.adapter.select:

Lesen von Abfrageergebnissen
----------------------------

Dieser Abschnitt beschreibt Methoden der Adapterklasse mit denen *SELECT* Abfragen ausgeführt werden können um
Abfrageergebnisse abzurufen.

.. _zend.db.adapter.select.fetchall:

Holen des kompletten Ergebnisssatzes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Man kann eine *SQL* *SELECT* Anfrage ausführen und alle Ergebnisse auf einmal mit der ``fetchAll()`` Methode
abrufen.

Das erste Argument dieser Methode ist ein String der die *SELECT* Anweisung enthält. Als Alternative kann das
erste Argument auch ein Objekt der :ref:`Zend\Db\Select <zend.db.select>` Klasse sein. Der Adapter konvertiert
dieses automatisch in einen String der die *SELECT* Anweisung repräsentiert.

Das zweite Argument von ``fetchAll()`` ist ein Array von Werten die Parameterplatzhalter in der *SQL* Anweisung
ersetzen.

.. _zend.db.adapter.select.fetchall.example:

.. rubric:: Nutzung von fetchAll()

.. code-block:: php
   :linenos:

   $sql = 'SELECT * FROM bugs WHERE bug_id = ?';

   $result = $db->fetchAll($sql, 2);

.. _zend.db.adapter.select.fetch-mode:

Ändern des Fetch Modus
^^^^^^^^^^^^^^^^^^^^^^

Standardmäßig gibt ``fetchAll()`` ein Array von Zeilen, jede als assoziatives Array, zurück. Die Schlüssel von
diesem assoziativem Array entsprechen den Spalten oder Spaltenaliasen wie sie in der SELECT Anfrage benannt sind.

Man kann einen anderen Stil für das Holen der Ergebnisse mit der ``setFetchMode()`` Methode angeben. Die
unterstützten Modi werden mit folgenden Konstanten identifiziert:

- **Zend\Db\Db::FETCH_ASSOC**: Gibt Daten in einem assoziativem Array zurück. Die Array Schlüssel sind Strings der
  Spaltennamen. Dies ist der Standardmodus für ``Zend\Db\Adapter`` Klassen.

  Zu beachten ist, dass wenn die Select-Liste mehr als eine Spalte mit dem selben Namen enthält, zum Beispiel wenn
  diese aus verschiedenen Tabellen durch einem *JOIN* bestehen, kann nur einer der Einträge im assoziativem Array
  enthalten sein. Wenn der ``FETCH_ASSOC`` Modus verwandt wird, sollten Spaltenaliase in der *SELECT* Anfrage
  angegeben werden um sicherzustellen dass die Namen eindeutige Arrayschlüssel ergeben.

  Standardmäßig werden die Strings so zurück gegeben wie sie von dem Datenbanktreiber geliefert werden. Dies
  entspricht der typischen Schreibweise der Spaltennamen auf dem *RDBMS* Server. Die Schreibweise dieser Strings
  kann mit der ``Zend\Db\Db::CASE_FOLDING`` Option angegeben werden. Dies muss bei der Instanziierung des Adapters
  angegeben werden. Beschreibung unter :ref:`dieses Beispiel <zend.db.adapter.connecting.parameters.example1>`.

- **Zend\Db\Db::FETCH_NUM**: Gibt Daten in einem Array von Arrays zurück. Die Arrays werden über Integer indiziert,
  entsprechend der Position der betreffenden Felder in der Select-Liste der Anfrage.

- **Zend\Db\Db::FETCH_BOTH**: Gibt ein Array von Arrays zurück. Die Arrayschlüssel sind sowohl Strings wie beim
  ``FETCH_ASSOC`` Modus, als auch Integer wie beim ``FETCH_NUM`` modus. Zu beachten ist, dass die Anzahl der
  Elemente in dem Array doppelt so groß ist, als wenn ``FETCH_ASSOC`` oder ``FETCH_NUM`` verwendet worden wäre.

- **Zend\Db\Db::FETCH_COLUMN**: Gibt Daten in einem Array von Werten zurück. Die Werte in jedem Array sind die Werte
  wie sie in einer Spalte des Ergebnisses zurück gegeben wurden. Standardmäßig ist die erste Spalte mit 0
  indiziert.

- **Zend\Db\Db::FETCH_OBJ**: Gibt Daten in einem Array von Objekten zurück. Die Standardklasse ist die in *PHP*
  eingebaute Klasse stdClass. Spalten des Ergebnisses sind als öffentliche Eigenschaften des Objekts verfügbar.

.. _zend.db.adapter.select.fetch-mode.example:

.. rubric:: Nutzung von setFetchMode()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend\Db\Db::FETCH_OBJ);

   $result = $db->fetchAll('SELECT * FROM bugs WHERE bug_id = ?', 2);

   // $result ist ein Array von Objekten
   echo $result[0]->bug_description;

.. _zend.db.adapter.select.fetchassoc:

Holen eines Ergbnisssatzes als assoziatives Array
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die ``fetchAssoc()`` Methode gibt Daten in einem Array von assoziativen Array zurück, egal welcher Wert für den
fetch-Modus gesetzt wurde, indem die erste Spalte als Array Index verwendet wird.

.. _zend.db.adapter.select.fetchassoc.example:

.. rubric:: Nutzung von fetchAssoc()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend\Db\Db::FETCH_OBJ);

   $result = $db->fetchAssoc(
       'SELECT bug_id, bug_description, bug_status FROM bugs'
   );

   // $result ist ein Array von assoziativen Arrays im Geist von fetch mode
   echo $result[2]['bug_description']; // Beschreibung von Fehler #2
   echo $result[1]['bug_description']; // Beschreibung von Fehler #1

.. _zend.db.adapter.select.fetchcol:

Holen einer einzelnen Spalte eines Ergebnisssatzes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die ``fetchCol()`` Methode gibt Daten in einem Array von Werten zurück, egal welcher Wert für den fetch-Modus
gesetzt wurde. Sie gibt nur die erste Spalte der Anfrage zurück. Alle weiteren Spalten der Anfrage werden
verworfen. Wenn eine andere Spalte als die Erste benötigt wird sollte :ref:`dieser Abschnitt
<zend.db.statement.fetching.fetchcolumn>` beachtet werden.

.. _zend.db.adapter.select.fetchcol.example:

.. rubric:: Nutzung von fetchCol()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend\Db\Db::FETCH_OBJ);

   $result = $db->fetchCol(
       'SELECT bug_description, bug_id FROM bugs WHERE bug_id = ?', 2);

   // Enthält bug_description; bug_id wird nicht zurückgegeben
   echo $result[0];

.. _zend.db.adapter.select.fetchpairs:

Holen von Schlüssel-Wert Paaren eines Ergebnisssatzes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die ``fetchPairs()`` Methode gibt Daten in einem Array von Schlüssel-Wert Paaren zurück, einem assoziativen Array
mit einem einzelnen Eintrag pro Zeile. Der Schlüssel dieses assoziativen Arrays wird von der ersten Spalte des
SELECT Ergebnisses genommen. Der Wert wird aus der zweiten Spalte des SELECT Ergebnisses genommen. Alle weiteren
Spalten des Ergebnisses werden verworfen.

Die *SELECT* Anfrage sollte so gestaltet sein, dass die erste Spalte nur eindeutige Werte liefert. Wenn doppelte
Werte in der ersten Spalte vorkommen, werden entsprechende Einträge in dem assoziativen Array überschrieben.

.. _zend.db.adapter.select.fetchpairs.example:

.. rubric:: Nutzung von fetchPairs()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend\Db\Db::FETCH_OBJ);

   $result = $db->fetchAssoc('SELECT bug_id, bug_status FROM bugs');

   echo $result[2];

.. _zend.db.adapter.select.fetchrow:

Holen einer einzelnen Zeile eines Ergebnisssatzes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die ``fetchRow()`` Methode gibt Daten entsprechend dem fetch-Modus zurück, jedoch nur die erste Zeile des
Ergebnisssatzes.

.. _zend.db.adapter.select.fetchrow.example:

.. rubric:: Nutzung von fetchRow()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend\Db\Db::FETCH_OBJ);

   $result = $db->fetchRow('SELECT * FROM bugs WHERE bug_id = 2');

   // Beachte das $result ein einzelnes Objekt ist, und kein Array von Objekten
   echo $result->bug_description;

.. _zend.db.adapter.select.fetchone:

Holen eines einzelnen Scalars aus einem Ergebnisssatz
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die ``fetchOne()`` Methode ist wie eine Kombination von ``fetchRow()`` mit ``fetchCol()``, gibt also nur die erste
Zeile des Ergebnisssatze zurück, und von dieser auch nur den Wert der ersten Spalte. Daher wird nur ein einziger
scalarer Wert zurückgegeben, kein Array und auch kein Objekt.

.. _zend.db.adapter.select.fetchone.example:

.. rubric:: Nutzung von fetchOne()

.. code-block:: php
   :linenos:

   $result = $db->fetchOne('SELECT bug_status FROM bugs WHERE bug_id = 2');

   // this is a single string value
   echo $result;

.. _zend.db.adapter.write:

Schreiben von Änderungen in die Datenbank
-----------------------------------------

Die Adapterklasse kann verwendet werden um neue Daten in die Datenbank zu schreiben oder bestehende Daten in der
Datenbank zu ändern. Dieser Abschnitt beschreibt Methoden für diese Operationen.

.. _zend.db.adapter.write.insert:

Einfügen von Daten
^^^^^^^^^^^^^^^^^^

Neue Zeilen können in die Datenbank mit der ``insert()`` Methode eingefügt werden. Das erste Argument ist ein
String der die Tabelle benennt, und das zweite Argument ist ein assoziatives Array das den Spaltennamen Datenwerte
zuordnet.

.. _zend.db.adapter.write.insert.example:

.. rubric:: Einfügen in eine Tabelle

.. code-block:: php
   :linenos:

   $data = array(
       'created_on'      => '2007-03-22',
       'bug_description' => 'Etwas falsch',
       'bug_status'      => 'NEW'
   );

   $db->insert('bugs', $data);

Spalten die nicht in dem Array definiert sind, werden nicht an die Datenbank übergeben. Daher folgen sie den
selben Regeln denen eine *SQL* *INSERT* Anweisung folgt: wenn die Spalte eine *DEFAULT* Klausel hat, so bekommt die
Spalte der neuen Zeile diesen Wert. Andernfalls behält sie den Status ``NULL``.

Standardmäßig werden die Daten in dem Array mit Parametern eingefügt. Dies reduziert das Risiko einiger Typen
von Sicherheitsproblemen. Die Werte in dem Array müssen daher nicht escaped oder quotiert übergeben werden.

Einige Werte in dem Array könnten als *SQL* Expressions benötigt werden, in diesem Fall dürfen sie nicht in
Anführungszeichen stehen. Standardmäßig werden alle übergebenen String-Werte als String-literale behandelt. Um
anzugeben das ein Wert eine *SQL* Expression ist, und daher nicht quotiert werden soll, muss der Wert als ein
Objekt des Typs ``Zend\Db\Expr`` übergeben werden, und nicht als einfacher String.

.. _zend.db.adapter.write.insert.example2:

.. rubric:: Einfügen von Expressions in eine Tabelle

.. code-block:: php
   :linenos:

   $data = array(
       'created_on'      => new Zend\Db\Expr('CURDATE()'),
       'bug_description' => 'Etwas falsch',
       'bug_status'      => 'NEW'
   );

   $db->insert('bugs', $data);

.. _zend.db.adapter.write.lastinsertid:

Abfragen von generierten Werten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Einige *RDBMS* Marken unterstützen Auto-Incrementierung von Primärschlüsseln. Eine Tabelle die so definiert ist
generiert automatisch einen Primärschlüsselwert während des *INSERT*'s einer neuen Zeile. Der Rückgabewert der
``insert()`` Methode ist **nicht** die letzte eingefügte ID, weil die Tabelle keine Auto-Increment Spalte haben
könnte. Statt dessen ist der Rückgabewert die Anzahl der betroffenen Zeilen (normalerweise 1).

Wenn die Tabelle mit einem Auto-Increment Primärschlüssel definiert ist, kann die ``lastInsertId()`` Methode nach
dem INSERT aufgerufen werden. Diese Methode gibt den letzten generierten Wertim Rahmen der aktuellen
Datenbankverbindung zurück.

.. _zend.db.adapter.write.lastinsertid.example-1:

.. rubric:: Nutzung von lastInsertId() für einen Auto-Increment Schlüssel

.. code-block:: php
   :linenos:

   $db->insert('bugs', $data);

   // Gib den letzten durch eine auto-inkrement Spalte erzeugten Wert zurück
   $id = $db->lastInsertId();

Einige *RDBMS* Marken unterstützen ein Sequenz-Objekt, welches eindeutige Werte generiert, die als
Primärschlüsselwerte dienen. Um Sequenzen zu unterstützen, akzeptiert die ``lastInsertId()`` Method zwei
optionale String Argumente. Diese Argumente benennen die Tabelle und die Spalte, in der Annahme das die Konvention
beachtet wurde, dass eine Sequenz mit der Tabelle und der Spalte benannt wurde, für die sie Werte generiert plus
dem Anhang "\_seq". Dies basiert auf der Konvention die von PostgreSQL verwendet wird, wenn Sequenzen für *SERIAL*
Spalten benannt werden. Zum Beispiel würde eine Tabelle "bugs" mit der Primärschlüsselspalte "bug_id" eine
Sequenz als "bugs_bug_id_seq" benennen.

.. _zend.db.adapter.write.lastinsertid.example-2:

.. rubric:: Nutzung von lastInsertId() für eine Sequenz

.. code-block:: php
   :linenos:

   $db->insert('bugs', $data);

   // Gib den letzten durch die 'bugs_bug_id_seq' Sequenz erstellten Wert zurück
   $id = $db->lastInsertId('bugs', 'bug_id');

   // Gib, alternativ, den letzten durch die 'bugs_seq' Sequenz
   // erstellten Wert zurück
   $id = $db->lastInsertId('bugs');

Wenn der Name des Squenz-Objekts nicht dieser Konvention folgt muss die ``lastSequenceId()`` Methode an Stelle
verwendet werden. Diese Methode benötigt ein String Argument, welches die Sequenz wörtlich benennt.

.. _zend.db.adapter.write.lastinsertid.example-3:

.. rubric:: Nutzung von lastSequenceId()

.. code-block:: php
   :linenos:

   $db->insert('bugs', $data);

   // Gib den letzten durch die 'bugs_id_gen' Sequenz erstellten Wert zurück.
   $id = $db->lastSequenceId('bugs_id_gen');

Bei *RDBMS* Marken die keine Sequenzen unterstützen, dazu gehören MySQL, Microsoft *SQL* Server und SQLite,
werden die Argumente an die ``lastInsertId()`` Methode ignoriert, und der zurück gegebene Wert ist der zuletzt
für eirgendeine Tabelle während einer *INSERT* Operation generierte Wert innerhalb der aktuellen Verbindung. Für
diese *RDBMS* Marken gibt die ``lastSequenceId()`` Methode immer ``NULL`` zurück.

.. note::

   **Weshalb sollte man nicht "SELECT MAX(id) FROM table" verwenden?**

   Manchmal gibt diese Anfrage den zuletzt eingefügten Primärschlüsselwert zurück. Trotzdem ist diese Technik
   in einer Umgebung in der mehrere Clients Daten in die Datenbank einfügen nicht sicher. Es ist möglich, und
   daher vorherbestimmt eventuell aufzutreten, das ein anderer Client in dem Augenblick zwischen dem INSERT deiner
   Client Anwendung und deiner Anfrage für den ``MAX(id)`` Wert, eine andere Zeile einfügt. Somit identifiziert
   der zurück gegebene Wert nicht die von dir eingefügte Zeile, sondern die eines anderen Clients. Man kann nie
   wissen wann dies passiert.

   Das Nutzen eines starken Transaktions Isolationsmodus wie "repeatable read" kann das Risiko mindern, aber einige
   *RDBMS* Marken unterstützen nicht die Transaktions Isolation die hierfür benötigt wird, oder deine
   Applikation könnte einen schwächeren Transaktions Isolationsmodus nutzen.

   Darüberhinaus ist das Nutzen eins Ausdrucks wie "``MAX(id)+1``" um einen neuen Wert für den Primärschlüssel
   zu generiern nict sicher, weil zwei Clients diese Anfrage gleichzeitig ausführen könnten und damit beide den
   gleichen Wert für ihre nächste *INSERT* Operation bekommen würden.

   Alle *RDBMS* Marken bieten einen Mechanismus um eindeutige Werte zu generieren, und um den zuletzt generierten
   Wert zurück zu geben. Diese Machanismen funktionieren notwendigerweise außerhalb des Gültigkeitsbereichs
   einer Transaktions Isolation, es besteht daher nicht die Möglichkeit das zwei Clients den selben Wert
   generieren und es besteht nicht die Möglichkeit das der Wert, der von einem anderen Client generiert wurde, an
   die Verbindung deines Clients, als letzter generierter Wert, gesendet wird.

.. _zend.db.adapter.write.update:

Aktualisieren von Daten
^^^^^^^^^^^^^^^^^^^^^^^

Zeilen in der Datenbank können mit der ``update()`` Methode eines Adapters aktualisiert werden. Diese Methode
benötigt drei Argumente: Das Erste ist der Name der Tabelle und das Zweite ist ein assoziatives Array das den zu
Ändernden Spalten neue Werte zuordnet.

Die Werte des Datenarrays werden als String Literale behandelt. Beachte :ref:`diesen Abschnitt
<zend.db.adapter.write.insert>` für Informationen zur Nutzung von *SQL* Expressions in dem Datenarray.

Das dritte Argument ist ein String der aus einer *SQL* Expression besteht, die genutzt wird um Kriterien für die
Auswahl der zu ändernden Zeilen zu bestimmen. Die Werte und Bezeichner in diesem Argument werden nicht escaped
oder quotiert. An dieser Stelle muss darauf geachtet werden das sichergestellt ist, das dynamischer Inhalt sicher
in diesen String eingefügt wird. In :ref:`diesem Abschnitt <zend.db.adapter.quoting>` sind Methoden beschrieben
die dabei helfen können.

Der Rückgabewert ist die Anzahl der Betroffenen Zeilen der UPDATE Operation.

.. _zend.db.adapter.write.update.example:

.. rubric:: Aktualisieren von Zeilen

.. code-block:: php
   :linenos:

   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $n = $db->update('bugs', $data, 'bug_id = 2');

Wenn das dritte Argument ausgelassen wird, werden alle Zeilen der Tabelle mit den Werten des Datenarrays
aktualisiert.

Wenn ein Array mit Strings als drittes Argument übergeben wird, werden diese Strings als eine Expression von
Ausdrücken, getrennt von ``AND`` Operatoren, zusammengefügt.

Wenn man ein Array von Arrays als drittes Argument anbietet, werden die Werte automatisch in die Schlüssel
eingefügt. Diese werden dann zusammen zu Ausdrücken verbunden, getrennt von ``AND`` Operatoren.

.. _zend.db.adapter.write.update.example-array:

.. rubric:: Aktualisieren von Zeilen unter Nutzung eines Arrays von Expressions

.. code-block:: php
   :linenos:

   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $where[] = "reported_by = 'goofy'";
   $where[] = "bug_status = 'OPEN'";

   $n = $db->update('bugs', $data, $where);

   // Der erstellte SQL Syntax ist:
   //  UPDATE "bugs" SET "update_on" = '2007-03-23', "bug_status" = 'FIXED'
   //  WHERE ("reported_by" = 'goofy') AND ("bug_status" = 'OPEN')

.. _zend.db.adapter.write.update.example-arrayofarrays:

.. rubric:: Zeilen aktualisieren durch Verwendung von einem Array von Arrays

.. code-block:: php
   :linenos:

   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $where['reported_by = ?'] = 'goofy';
   $where['bug_status = ?']  = 'OPEN';

   $n = $db->update('bugs', $data, $where);

   // Das resultierende SQL ist:
   //  UPDATE "bugs" SET "update_on" = '2007-03-23', "bug_status" = 'FIXED'
   //  WHERE ("reported_by" = 'goofy') AND ("bug_status" = 'OPEN')

.. _zend.db.adapter.write.delete:

Löschen von Daten
^^^^^^^^^^^^^^^^^

Daten können aus einer Datenbanktabelle mit der ``delete()`` Methode gelöscht werden. Diese Methode benötigt
zwei Argumente: Das erste ist ein String der die Tabelle benennt.

Das zweite Argument ist ein String der aus einer *SQL* Expression besteht, welche Kriterien für die zu löschenden
Zeilen enthält. Die Werte und Bezeichner in diesem Argument werden nicht escaped quotiert. An dieser Stelle muss
darauf geachtet werden das sichergestellt ist, das dynamischer Inhalt sicher in diesen String eingefügt wird. In
:ref:`diesem Abschnitt <zend.db.adapter.quoting>` sind Methoden beschrieben die dabei helfen können.

Der Rückgabewert ist die Anzahl der Betroffenen Zeilen der DELETE Operation.

.. _zend.db.adapter.write.delete.example:

.. rubric:: Löschen von Zeilen

.. code-block:: php
   :linenos:

   $n = $db->delete('bugs', 'bug_id = 3');

Wenn das zweite Argument ausgelassen wird, werden alle Zeilen der Tabelle gelöscht.

Wenn ein Array mit Strings als zweites Argument übergeben wird, werden diese Strings als eine Expression von
Ausdrücken, getrennt von ``AND`` Operatoren, zusammengefügt.

Wenn man ein Array von Arrays als zweites Argument übergibt, werden die Werte automatisch in die Schlüssel
eingefügt. Diese werden dann zusammen zu Ausdrücken verbunden, getrennt durch ``AND`` Operatoren.

.. _zend.db.adapter.quoting:

Quotierung von Werten und Bezeichnern
-------------------------------------

Beim Erzeugen von *SQL* Anfragen ist es häufig nötig *PHP* Variablen in die *SQL* Expression einzufügen. Dies
ist riskant, weil der Wert eines *PHP* Strings bestimmte Zeichen enthalten kann, wie das Anführungszeichen, was zu
ungültiger *SQL* Syntax führen kann. Zum Beispiel, zu beachten ist die ungerade Anzahl der Anführungszeichen in
der folgenden Anfrage:

.. code-block:: php
   :linenos:

   $name = "O'Reilly";
   $sql = "SELECT * FROM bugs WHERE reported_by = '$name'";

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 'O'Reilly'

Noch schlimmer ist das Risiko, dass solche Code-Fehler von einer Person absichtlich ausgenutzt werden um die
Funktion der Webanwendung zu manipulieren. Wenn der Wert einer *PHP* Variablen über die Nutzung von *HTTP*
Parametern oder eines anderen Mechanismus gesetzt werden kann, könnte eine Person die *SQL* Anfragen nutzen um
Dinge zu tun, wozu sie nicht gedacht sind, wie Daten ausgeben, wozu die Person keine Zugangsberechtigung hat. Dies
ist eine ernst zu nehmende und weit verbreitete Technik um die Sicherheit einer Anwendung zu verletzen, bekannt
unter dem Namen "SQL Injection" (siehe `http://en.wikipedia.org/wiki/SQL_Injection`_).

Die ``Zend_Db`` Adapterklassen bieten bequeme Methoden, die helfen die Verletzbarkeit durch *SQL* Injection
Angriffe im *PHP* Code zu reduzieren. Die Lösung ist bestimmte Zeichen, wie Anführungszeichen, in *PHP* Werten zu
ersetzen bevor sie in *SQL* Strings eingefügt werden. Dies schützt sowohl vor versehentlicher als auch vor
absichtlicher Manipulation von *SQL* Strings durch *PHP* Variablen, die spezielle Zeichen enthalten.

.. _zend.db.adapter.quoting.quote:

Nutzung von quote()
^^^^^^^^^^^^^^^^^^^

Die ``quote()`` Methode benötigt ein Argument, einen skalaren String Wert. Sie gibt den Wert mit ersetzten
speziellen Zeichen, passend zu dem eingesetzten *RDBMS*, und umgeben von Stringwertbegrenzern zurück. Der Standard
*SQL* Stringwertbegrenzer ist das einfache Anführungszeichen (').

.. _zend.db.adapter.quoting.quote.example:

.. rubric:: Nutzung von quote()

.. code-block:: php
   :linenos:

   $name = $db->quote("O'Reilly");
   echo $name;
   // 'O\'Reilly'

   $sql = "SELECT * FROM bugs WHERE reported_by = $name";

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 'O\'Reilly'

Zu beachten ist, dass der Rückgabewert von ``quote()`` die Stringwertbegrenzer enthält. Dies ist ein Unterschied
zu anderen Methoden die spezielle Zeichen ersetzen, aber keine Stringwertbegrenzer hinzufügen, wie z.B.
`mysql_real_escape_string()`_.

Es kann notwendig sein Werte in Anführungszeichen zu setzen oder nicht je nach dem Kontext des *SQL* Datentyps in
dem diese verwendet werden. Zum Beispiel darf, in einigen *RDBMS* Typen, ein Integer Wert nicht wie in String in
Anführungszeichen gesetzt werden, wenn dieser mit einer Integer-Typ Spalte oder einem Ausdruck verglichen wird.
Anders gesagt ist das folgende in einigen *SQL* Implementationen ein Fehler, wenn angenommen wird dass
``intColumn`` einen *SQL* Datentyp von ``INTEGER`` besitzt

.. code-block:: php
   :linenos:

   SELECT * FROM atable WHERE intColumn = '123'

Es kann das optionale zweite Argument der ``quote()`` Methode verwendet werden um die Verwendung von
Anführungszeichen selektiv für den spezifizierten *SQL* Datentyp auszuwählen.

.. _zend.db.adapter.quoting.quote.example-2:

.. rubric:: Verwenden von quote() mit einem SQL Typ

.. code-block:: php
   :linenos:

   $value = '1234';
   $sql = 'SELECT * FROM atable WHERE intColumn = '
        . $db->quote($value, 'INTEGER');

Jede ``Zend\Db\Adapter`` Klasse hat den Namen des nummerischen *SQL* Datentyps für die respektive Marke von
*RDBMS* codiert. Man kann genauso die Konstanten ``Zend\Db\Db::INT_TYPE``, ``Zend\Db\Db::BIGINT_TYPE``, und
``Zend\Db\Db::FLOAT_TYPE`` verwenden um Code in einem mehr *RDBMS*-unabhängigen Weg zu schreiben.

``Zend\Db\Table`` definiert *SQL* Typen zu ``quote()`` automatisch wenn *SQL* Abfragen erstellt werden die einer
Tabellen Schlüssel Spalte entsprechen.

.. _zend.db.adapter.quoting.quote-into:

Nutzung von quoteInto()
^^^^^^^^^^^^^^^^^^^^^^^

Die typischste Anwendung von Quotierung ist das Einfügen von *PHP* Variablen in eine *SQL* Expression oder
Anweisung. Die ``quoteInto()`` Methode kann verwendet werden um dies in einem Schritt zu erledigen. Die Methode
benötigt zwei Argumente: Das erste Argument ist ein String der ein Platzhaltersymbol (?) enthält, und das zweite
Argument ist ein Wert oder eine *PHP* Variable die den Platzhalter ersetzen soll.

Das Platzhaltersymbol ist das gleiche Symbol wie es von vielen *RDBMS* Marken für Lage betreffende Parameter
verwendet wird, aber die ``quoteInto()`` Methode bildet nur Abfrageparameter nach. Die Methode fügt den Wert in
den String ein, ersetzt dabei spezielle Zeichen und fügt Stringwertbegrenzer ein. Echte Abfrageparameter sorgen
für eine Trennung von *SQL* String und Parametern wenn die Anweisung vom *RDBMS* Server verarbeitet wird.

.. _zend.db.adapter.quoting.quote-into.example:

.. rubric:: Nutzung von quoteInto()

.. code-block:: php
   :linenos:

   $sql = $db->quoteInto("SELECT * FROM bugs WHERE reported_by = ?", "O'Reilly");

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 'O\'Reilly'

Man kann den optionalen dritten Parameter von ``quoteInto()`` verwenden um den *SQL* Datentyp zu spezifizieren.
Nummerische Datentypen werden nicht in Anführungszeichen gesetzt und andere Typen werden in Anführungszeichen
gesetzt.

.. _zend.db.adapter.quoting.quote-into.example-2:

.. rubric:: Verwenden von quoteInto() mit einem SQL Typ

.. code-block:: php
   :linenos:

   $sql = $db
       ->quoteInto("SELECT * FROM bugs WHERE bug_id = ?", '1234', 'INTEGER');

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 1234

.. _zend.db.adapter.quoting.quote-identifier:

Nutzung von quoteIdentifier()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Werte könnten nicht der einzige Teil der *SQL* Syntax sein, der Variabel sein soll. Wenn *PHP* Variablen genutzt
werden um Tabellen, Spalten oder andere Bezeichner in den *SQL* Anweisungen zu benennen, könnte es nötig sein das
diese Strings ebenfalls quotiert werden müssen. Standardmäßig haben *SQL* Bezeichner Syntaxregeln wie *PHP* und
die meißten anderen Programmiersprachen. Zum Beispiel dürfen Bezeichner keine Leerzeichen, bestimmte Punktierung,
spezielle Zeichen oder Internationale Zeichen enthalten. Außerdem sind bestimmte Wörter für die *SQL* Syntax
reserviert und dürfen nicht als Bezeichner verwendet werden.

Dennoch hat *SQL* ein Feature mit Namen **delimited identifiers (begrenzte Bezeichner)**, welches eine größere
Auswahl bei der Schreibweise von Bezeichnern erlaubt. Wenn ein *SQL* Bezeichner mit dem richtigen Typ von´
Quotierung eingeschlossen ist, können Schreibweisen für die Bezeichner verwendet werden, die ohne der Quotierung
ungültig wären. Begrenzte Bezeichner können Leerzeichen, Punktierung oder internationale Zeichen enthalten.
Desweiteren dürfen auch von der *SQL* Syntax reservierte Wörter verwendet werden, wenn sie von Bezeichner
Begrenzungszeichen eingeschlossen sind.

Die ``quoteIdentifier()`` Methode funktioniert wie ``quote()``, aber sie wendet die Bezeichner Begrenzungszeichen
entsprechend dem verwendeten Adapter an. Zum Beispiel nutzt Standard *SQL* doppelte Anführungszeichen (") zum
begrenzen von Bezeichnern und die meisten der *RDBMS* Marken nutzen ebenfalls dieses Symbol. MySQL hingegen benutzt
back-quotes (\`) als Standardzeichen. Die ``quoteIdentifier()`` Methode ersetzt außerdem spezielle Zeichen im
String Argument.

.. _zend.db.adapter.quoting.quote-identifier.example:

.. rubric:: Nutzung von quoteIdentifier()

.. code-block:: php
   :linenos:

   // Wir könnten einen Tabellennamen haben, der ein in SQL reserviertes Wort ist
   $tableName = $db->quoteIdentifier("order");

   $sql = "SELECT * FROM $tableName";

   echo $sql
   // SELECT * FROM "order"

*SQL* begrenzte Bezeichner beachten die Groß- und Kleinschreibung, im Gegensatz zu nicht quotierten Bezeichnern.
Daher muss, bei Verwendung von begrenztern Bezeichnern, die Schreibung der Bezeichner genau der Schreibung der
Bezeichner im Tabellenschema entsprechen. Einschließlich der Groß- und Kleinschreibung.

In den meisten Fällen wo *SQL* innerhalb der ``Zend_Db`` Klassen generiert wird, werden standardmäßig alle
Bezeichner automatisch begrenzt. Dieses Verhalten kann mit der Option ``Zend\Db\Db::AUTO_QUOTE_IDENTIFIERS`` geändert
werden. Dies muss beim Instanziieren des Adapters wie in :ref:`diesem Beispiel
<zend.db.adapter.connecting.parameters.example2>` angegeben werden.

.. _zend.db.adapter.transactions:

Kontrollieren von Datenbank Transaktionen
-----------------------------------------

Datenbanken definieren Transaktionen als logische Einheiten von Arbeit, die als einzelne Änderung übergeben oder
rückgängig gemacht werden kann, selbst wenn sie auf verschiedenen Tabellen operiert. Alle Anfragen an einen
Datenbank werden im Kontext einer Transaktion ausgeführt, selbst wenn der Datenbanktreiber sie implizit Verwaltet.
Es wird **auto-commit** Modus genannt, wenn der Datenbanktreiber eine Transaktion für jede Anweisung erzeugt, und
diese direkt nach dem Ausführen des *SQL* Statements übergibt. Standardmäßig operieren alle ``Zend_Db``
Adapterklassen im auto-commit Modus.

Alternativ kann der Begin und das Ergebnis einer Transaktion selbst spezifiziert werden, und damit kann
kontrolliert werden wieviele *SQL* Anfragen in einer Gruppe enthalten sind, die entweder übergeben oder
rückgängig gemacht wird, als eine einzelne Operation. Um eine Transaktion zu initiieren wird die
``beginTransaction()`` Methode verwendet. Anschließend folgende *SQL* Anweisungen werden im Kontext der selben
Transaktion ausgeführt bis sie explizit aufgelöst wird.

Um eine Transaktion aufzulösen wird entweder die ``commit()`` oder die ``rollBack()`` Methode verwendet. Die
``commit()`` Methode markiert die Änderungen die während der Transaktionen durchgeführt wurden als übergeben,
was bedeutet das die Effekte dieser Änderungen in anderen Transaktionen angezeigt werden.

Die ``rollBack()`` Methode tut das Gegenteil: sie verwirft die Änderungen die während der Transaktionen
durchgeführt wurden. Die Änderungen werden gewissermaßen ungeschehen gemacht, der Status der Daten ändert sich
zurück auf jenen wie sie vor Beginn der Transaktion waren. Allerdings hat das rückgängig machen keinen Einfluss
auf Änderungen die von anderen, gleichzeitig laufenden Transaktionen verursacht wurden.

Nach dem Auflösen der Transaktion befindet sich der ``Zend\Db\Adapter`` wieder im auto-commit Modus, bis
``beginTransaction()`` wieder aufgerufen wird.

.. _zend.db.adapter.transactions.example:

.. rubric:: Verwalten einer Transaktion um Konsistenz sicher zu stellen

.. code-block:: php
   :linenos:

   // Eine Transaktion explizit starten
   $db->beginTransaction();

   try {
       // Versuchen einen oder mehrere Abfragen auszuführen
       $db->query(...);
       $db->query(...);
       $db->query(...);

       // Wenn alle erfolgreich waren, übertrage die Transaktion
       // und alle Änderungen werden auf einmal übermittelt
       $db->commit();

   } catch (Exception $e) {
       // Wenn irgendeine der Abfragen fehlgeschlagen ist, wirf eine Ausnahme, wir
       // wollen die komplette Transaktion zurücknehmen, alle durch die
       // Transaktion gemachten Änderungen wieder entfernen, auch die erfolgreichen
       // So werden alle Änderungen auf einmal übermittelt oder keine
       $db->rollBack();
       echo $e->getMessage();
   }

.. _zend.db.adapter.list-describe:

Auflistung und Beschreibung von Tabellen
----------------------------------------

Die ``listTables()`` Methode gibt ein Array von Strings zurück, mit den Namen aller Tabellen in der aktuellen
Datenbank.

Die ``describeTable()`` Methode gibt ein assoziatives Array von MetaDaten über die Tabelle zurück. Das erste
Argument dieser Methode ist ein String der den Namen der Tabelle enthält. Das zweite Argument ist optional und
benennt das Schema in dem die Tabelle besteht.

Die Schlüssel des assoziativen Arrays sind die Spaltennamen der Tabelle. Der zugehörige Wert jeder Spalte ist
ebenfalls ein assoziatives Array mit den folgenden Schlüsseln und Werten:

.. _zend.db.adapter.list-describe.metadata:

.. table:: Metadata Felder die von describeTable() zurückgegeben werden

   +----------------+---------+------------------------------------------------------------------------------------------+
   |Schlüssel       |Typ      |Beschreibung                                                                              |
   +================+=========+==========================================================================================+
   |SCHEMA_NAME     |(string) |Name des Datenbankschemas in welchem diese Tabelle existiert.                             |
   +----------------+---------+------------------------------------------------------------------------------------------+
   |TABLE_NAME      |(string) |Name der Tabelle zu welcher diese Spalte gehört.                                          |
   +----------------+---------+------------------------------------------------------------------------------------------+
   |COLUMN_NAME     |(string) |Name der Spalte.                                                                          |
   +----------------+---------+------------------------------------------------------------------------------------------+
   |COLUMN_POSITION |(integer)|Ordinale Position der Spalte in der Tabelle.                                              |
   +----------------+---------+------------------------------------------------------------------------------------------+
   |DATA_TYPE       |(string) |RDBMS Name des Datentyps der Spalte.                                                      |
   +----------------+---------+------------------------------------------------------------------------------------------+
   |DEFAULT         |(string) |Standardwert der Spalte, wenn angegeben.                                                  |
   +----------------+---------+------------------------------------------------------------------------------------------+
   |NULLABLE        |(boolean)|TRUE wenn die Spalte SQLNULL akzeptiert, FALSE wenn die Spalte eine NOTNULL Bedingung hat.|
   +----------------+---------+------------------------------------------------------------------------------------------+
   |LENGTH          |(integer)|Länge oder Größe der Spalte wie vom RDBMS angegeben.                                      |
   +----------------+---------+------------------------------------------------------------------------------------------+
   |SCALE           |(integer)|Scalar vom Typ SQLNUMERIC oder DECIMAL.                                                   |
   +----------------+---------+------------------------------------------------------------------------------------------+
   |PRECISION       |(integer)|Präzision des Typs SQLNUMERIC oder DECIMAL.                                               |
   +----------------+---------+------------------------------------------------------------------------------------------+
   |UNSIGNED        |(boolean)|TRUE wenn ein Integer-basierender Typ als UNSIGNED angegeben wird.                        |
   +----------------+---------+------------------------------------------------------------------------------------------+
   |PRIMARY         |(boolean)|TRUE wenn die Spalte Teil des Primärschlüsssels der Tabelle ist.                          |
   +----------------+---------+------------------------------------------------------------------------------------------+
   |PRIMARY_POSITION|(integer)|Ordinale Position (1-basierend) der Spalte des Primärschlüssels.                          |
   +----------------+---------+------------------------------------------------------------------------------------------+
   |IDENTITY        |(boolean)|TRUE wenn die Spalte einen auto-increment Wert nutzt.                                     |
   +----------------+---------+------------------------------------------------------------------------------------------+

.. note::

   **Wie das IDENTITY Metadata Feld zu speziellen RDBMS zuzuordnen ist**

   Das ``IDENTITY`` Metadata Feld wurd gewählt als ein 'idiomatischer' Ausdruck um eine Relation von
   Ersatzschlüsseln zu repräsentieren. Dieses Feld ist üblicherweise durch die folgenden Werte bekannt:

   - ``IDENTITY``-*DB2*, *MSSQL*

   - ``AUTO_INCREMENT``- MySQL

   - ``SERIAL``- PostgreSQL

   - ``SEQUENCE``- Oracle

Wenn keine Tabelle mit dem Tabellennamen und dem optional angegebenen Schemanamen existiert, gibt
``describeTable()`` ein leeres Array zurück.

.. _zend.db.adapter.closing:

Schließen einer Verbindung
--------------------------

Normalerweise ist es nicht nötig eine Datenbankverbindung zu schließen. *PHP* räumt automatisch alle Ressourcen
am Ende einer Anfrage auf und die Datenbankerweiterungen sind so designed das sie Verbindungen beenden wenn
Referenzen zu ihren Objekten aufgeräumt werden.

Trotzdem könnte es sinnvoll sein, wenn ein lang andauerndes *PHP* Script verwendet wird, das viele
Datenbankverbindungen hat, diese zu schließen um zu vermeiden das die Kapazität des *RDBMS* Servers
überschritten wird. Die ``closeConnection()`` Methode der Adapterklasse kann verwendet werden um die
zugrundeliegende Datenbankverbindung explizit zu schließen.

Seit Release 1.7.2, kann man prüfen ob man mit der ``isConnected()`` prüfen ob man aktuell mit dem *RDBMS* Server
verbunden ist. Das bedeutet das eine Verbindungs Ressource initialisiert und nicht geschlossen wurde. Diese
Funktion ist aktuell nicht in der Lage zu prüfen ob zum Beispiel die Server Seite die Verbindung geschlossen hat.
Das wird intern verwendet um die Verbindung zu schließen. Das erlaubt es die Verbindung ohne Fehler mehrere Male
zu schließen. Das war bereits vor 1.7.2 der Fall für *PDO* Adapter, aber nicht für die anderen.

.. _zend.db.adapter.closing.example:

.. rubric:: Schließen einer Datenbankverbindung

.. code-block:: php
   :linenos:

   $db->closeConnection();

.. note::

   **Unterstützt Zend_Db persistente Verbindungen?**

   Ja, Persistenz wird durch das Hinzufügen des ``persistent`` Flags in der Konfiguration (nicht
   driver_configuration) und dessen Setzen auf ``TRUE`` bei einem Adapter in ``Zend_Db`` unterstützt.

   .. _zend.db.adapter.connecting.persistence.example:

   .. rubric:: Verwendung des Persistence Flags mit dem Oracle Adapter

   .. code-block:: php
      :linenos:

      $db = Zend\Db\Db::factory('Oracle', array(
          'host'       => '127.0.0.1',
          'username'   => 'webuser',
          'password'   => 'xxxxxxxx',
          'dbname'     => 'test',
          'persistent' => true
      ));

   Es ist zu beachten das die Verwendung von persistenten Verbindungen einen Exzess an Idle Verbindungen auf dem
   *RDBMS* Server verursachen kann, was mehr Probleme macht als jeder Performance Gewinn den man durch die
   Verminderung des Overheads eines Verbindungsaufbaues erhalten kann.

   Datenbankverbindungen haben einen Status. Natürlich existieren einige Objekte auf dem *RDBMS* Server im
   Gültigkeitsbereich einer Session. Beispiele dafür sind locks, user variablen, temporary tables und
   Informationen über die zuletzt ausgeführte Anfrage, sowie betroffene Zeilen und zuletzt generierte ID Werte.
   Wenn persistente Verbindungen genutzt werden könnte die Anwendung Zugriff auf ungültige oder privilegierte
   Daten erlangen, die in einem vorigen *PHP* Request erzeugt wurden.

   Aktuell unterstützen nur die Oracle, *DB2* und *PDO* Adapter (wo es von *PHP* spezifiziert ist) Persistenz in
   ``Zend_Db``.

.. _zend.db.adapter.other-statements:

Ausführen anderer Datenbank Anweisungen
---------------------------------------

Es könnte Fälle geben in denen direkter Zugriff auf das Verbindungsobjekt benötigt wird, wie es von der *PHP*
Erweiterung bereitgestellt wird. Einige der Erweiterungen könnten Features anbieten, welche nicht von Methoden der
``Zend\Db\Adapter\Abstract`` Klasse auftauchen..

Zum Beispiel werden alle *SQL* Anweisungen von ``Zend_Db`` vorbereitet und dann ausgeführt. Trotzdem gibt es
einige Features welche nicht kompatibel mit vorbereiteten Anweisungen sind. ``DDL`` Anweisungen wie ``CREATE`` und
``ALTER`` können in MySQL nicht vorbereitet werden. Auch können *SQL* Anweisungen keinen Nutzen aus dem `MySQL
Query Cache`_ ziehen, bei einer geringeren MySQL Version als 5.1.17.

Die meisten *PHP* Datenbankerweiterungen bieten eine Methode um *SQL* Anweisung auszuführen ohne diese
vorzubereiten. Zum Beispiel bietet *PDO* die Methode ``exec()``. Das Verbindungsobjekt der *PHP* Erweiterung kann
kann mit der Methode ``getConnection()`` direkt verwendet werden.

.. _zend.db.adapter.other-statements.example:

.. rubric:: Ausführen eines nicht-prepared Statements mit einem PDO Adapter

.. code-block:: php
   :linenos:

   $result = $db->getConnection()->exec('DROP TABLE bugs');

So ähnlich können auch andere Methoden oder Eigenschaften der speziellen *PHP* Datenbankerweiterung genutzt
werden. Zu beachten dabei ist jedoch, dass dadurch möglicherweise die Anwendung auf das angegebene Interface,
bereitgestellt von einer Erweiterung für ein bestimmtes *RDBMS*, beschränkt wird.

In zukünftigen Versionen von ``Zend_Db`` werden Möglichkeiten gegeben sein, um Methoden Startpunkte
hinzuzufügen, für Funktionalitäten die den unterstützten *PHP* Datenbankerweiterungen gemein sind. Dies wird
die Rückwärtskompatibilität nicht beeinträchtigen.

.. _zend.db.adapter.server-version:

Erhalten der Server Version
---------------------------

Seit Release 1.7.2 kann man die Version des Servers in einem *PHP* artigen Stil erhalten damit man es mit
``version_compare()`` verwenden kann. Wenn die Information nicht vorhanden ist erhält man ``NULL`` zurück.

.. _zend.db.adapter.server-version.example:

.. rubric:: Prüfen der Server Version bevor eine Abfrage gestartet wird

.. code-block:: php
   :linenos:

   $version = $db->getServerVersion();
   if (!is_null($version)) {
       if (version_compare($version, '5.0.0', '>=')) {
           // mach was
       } else {
           // mach was anderes
       }
   } else {
       // Server Version ist unmöglich zu lesen
   }

.. _zend.db.adapter.adapter-notes:

Anmerkungen zu bestimmten Adaptern
----------------------------------

Dieser Abschnitt beschreibt Unterschiede zwischen den verschieden Adapterklassen auf die man achtgeben sollte.

.. _zend.db.adapter.adapter-notes.sqlsrv:

Microsoft SQL Server
^^^^^^^^^^^^^^^^^^^^

- Dieser Adapter wird in der ``factory()`` Methode mit dem Namen 'Sqlsrv' angegeben.

- Dieser Adapter nutzt die *PHP* Erweiterung sqlsrv.

- Es wird nur Microsoft *SQL* Server 2005 oder höher unterstützt.

- Microsoft *SQL* Server unterstützt keine Sequenzen, daher ignoriert ``lastInsertId()`` das Primary Key Argument
  und gibt immer den letzten Wert zurück der für den auto-increment Schlüssel generiert wurde wenn ein
  Tabellenname spezifiziert wurde oder die letzte Insert Abfrage eine Id zurückgegeben hat. Die
  ``lastSequenceId()`` Methode gibt ``NULL`` zurück.

- ``Zend\Db\Adapter\Sqlsrv`` setzt ``QUOTED_IDENTIFIER`` ON unmittelbar nach der Verbindung zu einer *SQL* Server
  Datenbank. Dadurch verwendet der Treiber das standardmäßige *SQL* Trennzeichen (**"**) statt den propietären
  eckigen Klammern die der *SQL* Server für die Identifikatoren als Trennzeichen verwendet.

- Man kann ``driver_options`` als Schlüssel im Options Array spezifizieren. Der Wert kann alles hieraus sein:
  `http://msdn.microsoft.com/en-us/library/cc296161(SQL.90).aspx`_.

- Man kann ``setTransactionIsolationLevel()`` verwenden um einen Isolations Level für die aktuelle Verbindung zu
  setzen. Der Wert kann wie folgt sein: ``SQLSRV_TXN_READ_UNCOMMITTED``, ``SQLSRV_TXN_READ_COMMITTED``,
  ``SQLSRV_TXN_REPEATABLE_READ``, ``SQLSRV_TXN_SNAPSHOT`` oder ``SQLSRV_TXN_SERIALIZABLE``.

- Mit *ZF* 1.9 ist das mindestens unterstützte Build der *PHP* *SQL* Server erweiterung von Microsoft 1.0.1924.0
  und die Version des *MSSQL* Server Native Clients 9.00.3042.00.

.. _zend.db.adapter.adapter-notes.ibm-db2:

IBM DB2
^^^^^^^

- Dieser Adapter wird in der ``factory()`` Methode mit dem Namen 'Db2' angegeben.

- Dieser Adapter nutzt die *PHP* Erweiterung ``IBM_DB2``.

- *IBM* *DB2* unterstützt sowohl Sequenzen als auch auto-increment Schlüssel. Daher sind die Argumente für
  ``lastInsertId()`` optional. Werden keine Argumente angegeben, gibt der Adapter den letzten Wert der für den
  auto-increment Key generiert wurde zurück. Werden Argumente angegeben, gibt der Adapter den letzten Wert der
  für die Sequenz mit dem Namen, entsprechend der Konvention, '**table**\ _ **column**\ _seq' generiert wurde
  zurück.

.. _zend.db.adapter.adapter-notes.mysqli:

MySQLi
^^^^^^

- Dieser Adapter wird in der ``factory()`` Methode mit dem Namen 'Mysqli' angegeben.

- Dieser Adapter nutzt die *PHP* Erweiterung mysqli.

- MySQL unterstützt keine Sequenzen, daher ignoriert ``lastInsertId()`` Argumente und gibt immer den letzten Wert
  der für den auto-increment Schlüssel generiert wurde zurück. Die ``lastSequenceId()`` Methode gibt ``NULL``
  zurück.

.. _zend.db.adapter.adapter-notes.oracle:

Oracle
^^^^^^

- Dieser Adapter wird in der ``factory()`` Methode mit dem Namen 'Oracle' angegeben.

- Dieser Adapter nutzt die *PHP* Erweiterung oci8.

- Oracle unterstützt keine auto-increment Schlüssel, daher sollte der Name einer Sequenz an ``lastInsertId()``
  oder ``lastSequenceId()`` übergeben werden.

- Die Oracle Erweiterung unterstützt keine positionierten Parameter. Es müssen benannte Parameter verwendet
  werden.

- Aktuell wird die ``Zend\Db\Db::CASE_FOLDING`` Option vom Oracle Adapter nicht unterstützt. Um diese Option mit
  Oracle zu nutzen muss der *PDO* *OCI* Adapter verwendet werden.

- Standardmäßig werden *LOB* Felder als *OCI*-Log Objekte zurückgegeben. Man kann Sie für alle Anfragen als
  String empfangen indem die Treiberoption '``lob_as_string``' verwendet wird, oder für spezielle Anfragen durch
  Verwendung von ``setLobAsString(boolean)`` auf dem Adapter oder dem Statement.

.. _zend.db.adapter.adapter-notes.pdo-ibm:

PDO Adapter für IBM DB2 und für Informix Dynamic Server (IDS)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Dieser Adapter wird in der ``factory()`` Methode mit dem Namen '``Pdo_Ibm``' spezifiziert.

- Dieser Adapter nutzt die *PHP* Erweiterungen *PDO* und *PDO_IBM*.

- Es muß mindestens die *PDO_IBM* Erweiterung mit der Version 1.2.2 verwendet werden. Wenn eine ältere Version
  verwendet wird, muß die *PDO_IBM* Erweiterung über *PECL* hochgerüstet werden.

.. _zend.db.adapter.adapter-notes.pdo-mssql:

PDO Microsoft SQL Server
^^^^^^^^^^^^^^^^^^^^^^^^

- Dieser Adapter wird in der ``factory()`` Methode mit dem Namen '``Pdo_Mssql``' angegeben.

- Dieser Adapter nutzt die *PHP* Erweiterungen pdo und pdo_dblib.

- Microsoft *SQL* Server unterstützt keine Sequenzen, daher ignoriert ``lastInsertId()`` Argumente und gibt immer
  den letzten Wert der für den auto-increment Schlüssel generiert wurde zurück. Die ``lastSequenceId()`` Methode
  gibt ``NULL`` zurück.

- Wenn man mit Unicode Strings in einer anderen Codierung als *UCS*-2 (wie *UTF*-8) arbeitet, kann es sein das man
  eine Konvertierung im eigenen Anwendungscode durchführen, oder die Daten in einer Binären Spalte speichern
  muß. Referieren Sie bitte auf `Microsoft's Knowledge Base`_ für weitere Informationen.

- ``Zend\Db\Adapter\Pdo\Mssql`` setzt ``QUOTED_IDENTIFIER`` ON direkt nach dem Verbinden zu einer *SQL* Server
  Datenbank. Dadurch verwendet der Treiber das Standard *SQL* Bezeichner Begrenzungssymbol (") an Stelle der
  proprietären Eckige-Klammer Syntax die der *SQL* Server standradmäßig nutzt.

- Es kann ``pdoType`` als ein Schlüssel im Optionsarray gesetzt werden. Der Wert kann "mssql" (der Standard),
  "dblib", "freetds", oder "sybase" sein. Diese Option beeinflusst den *DNS* Prefix, welchen der Adapter beim
  Konstruieren des *DNS* Strings benutzt. Sowohl "freetds" als auch "sybase" implementieren einen Prefix von
  "sybase:", welcher für den `FreeTDS`_ Satz von Libraries verwendet wird. Siehe auch
  `http://www.php.net/manual/de/ref.pdo-dblib.connection.php`_ für weitere Informationen über die *DNS* Prefixe
  die von diesem Treiber verwendet werden.

.. _zend.db.adapter.adapter-notes.pdo-mysql:

PDO MySQL
^^^^^^^^^

- Dieser Adapter wird in der ``factory()`` Methode mit dem Namen '``Pdo_Mysql``' angegeben.

- Dieser Adapter nutzt die *PHP* Erweiterungen pdo und pdo_mysql.

- MySQL unterstützt keine Sequenzen, daher ignoriert ``lastInsertId()`` Argumente und gibt immer den letzten Wert
  der für den auto-increment Schlüssel generiert wurde zurück. Die ``lastSequenceId()`` Methode gibt ``NULL``
  zurück.

.. _zend.db.adapter.adapter-notes.pdo-oci:

PDO Oracle
^^^^^^^^^^

- Dieser Adapter wird in der ``factory()`` Methode mit dem Namen '``Pdo_Oci``' angegeben.

- Dieser Adapter nutzt die *PHP* Erweiterungen pdo und pdo_oci.

- Oracle unterstützt keine auto-increment Schlüssel, daher sollte der Name einer Sequenz an ``lastInsertId()``
  oder ``lastSequenceId()`` übergeben werden.

.. _zend.db.adapter.adapter-notes.pdo-pgsql:

PDO PostgreSQL
^^^^^^^^^^^^^^

- Dieser Adapter wird in der ``factory()`` Methode mit dem Namen '``Pdo_Pgsql``' angegeben.

- Dieser Adapter nutzt die *PHP* Erweiterungen pdo und pdo_pgsql.

- PostgreSQL unterstützt sowohl Sequenzen als auch auto-increment Schlüssel. Daher sind die Argumente für
  ``lastInsertId()`` optional. Werden keine Argumente angegeben, gibt der Adapter den letzten Wert der für den
  auto-increment Key generiert wurde zurück. Werden Argumente angegeben, gibt der Adapter den letzten Wert der
  für die Sequenz mit dem Namen, entsprechend der Konvention, '**table**\ _ **column**\ _seq' generiert wurde
  zurück.

.. _zend.db.adapter.adapter-notes.pdo-sqlite:

PDO SQLite
^^^^^^^^^^

- Dieser Adapter wird in der ``factory()`` Methode mit dem Namen '``Pdo_Sqlite``' angegeben.

- Dieser Adapter nutzt die *PHP* Erweiterungen pdo und pdo_sqlite.

- SQLite unterstützt keine Sequenzen, daher ignoriert ``lastInsertId()`` Argumente und gibt immer den letzten Wert
  der für den auto-increment Schlüssel generiert wurde zurück. Die ``lastSequenceId()`` Methode gibt ``NULL``
  zurück.

- Um mit einer SQLite2 Datenbank zu Verbinden muss ``'sqlite2' => true`` in dem Array von Parametern beim Erzeugen
  einer Instanz des ``Pdo_Sqlite`` Adapters angegeben werden.

- Um mit einer in-memory SQLite Datenbank zu verbinden muss ``'dbname' => ':memory:'`` in dem Array von Parametern
  beim Erzeugen einer Instanz des ``Pdo_Sqlite`` Adapters angegeben werden.

- Ältere Versionen des SQLite Treibers in *PHP* scheinen die *PRAGMA* Kommandos nicht zu unterstützen, die
  benötigt werden um sicherzustellen, dass kurze Spaltennamen in Ergebnissätzen verwendet werden. Wenn in den
  Ergebnissätzen Schlüssel der Art "tabellenname.spaltenname" bei Nutzung von JOIN Abfragen auftreten, sollte die
  aktuellste *PHP* Version installiert werden.

.. _zend.db.adapter.adapter-notes.firebird:

Firebird (Interbase)
^^^^^^^^^^^^^^^^^^^^

- Dieser Adapter verwendet die *PHP* Erweiterung php_interbase.

- Firebird (Interbase) unterstützt keine auto-increment Schlüssel, deswegen sollte der Name einer Sequenz bei
  ``lastInsertId()`` oder ``lastSequenceId()`` spezifiziert werden.

- Aktuell wird die ``Zend\Db\Db::CASE_FOLDING`` Option vom Firebird (Interbase) Adapter nicht unterstützt. Nicht
  gequotete Identifizierer werden automatisch in Großschreibweise zurückgegeben.

- Der Name des Adapters ist ``ZendX_Db_Adapter_Firebird``.

  Beachte das der Parameter adapterNamespace mit dem Wert ``ZendX_Db_Adapter`` zu verwenden ist.

  Wir empfehlen die ``gds32.dll`` (oder Ihr Linux Äquivalent) welche mit *PHP* ausgeliefert wird, auf die gleiche
  Version wie am Server hochzurüsten. Für Firebird ist das Äquivalent zu ``gds32.dll`` die ``fbclient.dll``.

  Standardmäßig werden alle Identifikatoren (Tabellennamen, Felder) in Großschreibweise zurückgegeben.



.. _`PHP Data Objects`: http://www.php.net/pdo
.. _`pdo_ibm`: http://www.php.net/pdo-ibm
.. _`pdo_mysql`: http://www.php.net/pdo-mysql
.. _`pdo_dblib`: http://www.php.net/pdo-dblib
.. _`pdo_oci`: http://www.php.net/pdo-oci
.. _`pdo_pgsql`: http://www.php.net/pdo-pgsql
.. _`pdo_sqlite`: http://www.php.net/pdo-sqlite
.. _`mysqli`: http://www.php.net/mysqli
.. _`oci8`: http://www.php.net/oci8
.. _`ibm_db2`: http://www.php.net/ibm_db2
.. _`php_interbase`: http://www.php.net/ibase
.. _`http://en.wikipedia.org/wiki/SQL_Injection`: http://en.wikipedia.org/wiki/SQL_Injection
.. _`mysql_real_escape_string()`: http://www.php.net/mysqli_real_escape_string
.. _`MySQL Query Cache`: http://dev.mysql.com/doc/refman/5.1/en/query-cache-how.html
.. _`http://msdn.microsoft.com/en-us/library/cc296161(SQL.90).aspx`: http://msdn.microsoft.com/en-us/library/cc296161(SQL.90).aspx
.. _`Microsoft's Knowledge Base`: http://support.microsoft.com/kb/232580
.. _`FreeTDS`: http://www.freetds.org/
.. _`http://www.php.net/manual/de/ref.pdo-dblib.connection.php`: http://www.php.net/manual/de/ref.pdo-dblib.connection.php
