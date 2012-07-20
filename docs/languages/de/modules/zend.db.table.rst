.. _zend.db.table:

Zend_Db_Table
=============

.. _zend.db.table.introduction:

Einführung
----------

Die ``Zend_Db_Table`` Klasse ist eine Objekt-Orientierte Schnittstelle zu Datenbank Tabellen. Sie bietet Methoden
für viele gängige Operationen an Tabellen. Die Basisklasse ist erweiterbar, daher kann eigene Logik eingeführt
werden.

Die ``Zend_Db_Table`` Lösung ist eine Implementation des `Table Data Gateway`_ Patterns. Die Lösung schließt
außerdem eine Klasse ein, welche das `Row Data Gateway`_ Pattern implementiert.

.. _zend.db.table.concrete:

Zend_Db_Table als konkrete Klasse verwenden
-------------------------------------------

Ab Zend Framework 1.9 kann man ``Zend_Db_Table`` instanziieren. Der zusätzliche Vorteil ist das man die
Basisklasse nicht erweitern und konfigurieren muß um einfache Operationen wie auswählen, einfügen, aktualisieren
und löschen in einer einzelnen Tabelle durchzuführen. Anbei ist ein Beispiel der einfachsten Verwendung.

.. _zend.db.table.defining.concrete-instantiation.example1:

.. rubric:: Eine Table Klasse nur mit dem Stringnamen deklarieren

.. code-block:: php
   :linenos:

   Zend_Db_Table::setDefaultAdapter($dbAdapter);
   $bugTable = new Zend_Db_Table('bug');

Das obige Beispiel zeigt das einfachste Beispiel. Nicht alle der unten beschriebenen Optionen sollten für die
Konfiguration von ``Zend_Db_Table`` Tabellen durchgeführt werden. Wenn man in der Lage sein will das konkrete
Verwendungsbeispiel zusätzlich zu den komplexeren Abhängigkeits Features zu verwenden sehen Sie in die
``Zend_Db_Table_Definition`` Dokumentation.

.. _zend.db.table.defining:

Definieren einer Table Klasse
-----------------------------

Für jede Tabelle der Datenbank auf die zugegriffen werden soll, sollte eine eine Klasse erzeugt werden, welche
``Zend_Db_Table_Abstract`` erweitert.

.. _zend.db.table.defining.table-schema:

Definieren des Tabellennamens und Schemas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die Tabelle der Datenbank, für welche die Klasse bestimmt ist, wird mit der protected Variablen ``$_name``
angegeben. Es ist ein String, welcher den Namen der Tabelle enthalten muss, wie er in der Datenbank erscheint.

.. _zend.db.table.defining.table-schema.example1:

.. rubric:: Angeben einer Table Klasse mit ausdrücklichem Tabellennamen

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';
   }

Wird keine Tabellenname angegeben, so wird ein Standard verwendet, welcher dem Namen der Klasse entspricht. Wird
sich auf diesen Standard verlassen, so muss der Klassenname der Schreibweise der Tabelle entsprechen, wie sie in
der Datenbank erscheint.

.. _zend.db.table.defining.table-schema.example:

.. rubric:: Angeben einer Table Klasse mit inbegriffenem Tabellennamen

.. code-block:: php
   :linenos:

   class bugs extends Zend_Db_Table_Abstract
   {
       // Tabellenname entspricht dem Klassennamen
   }

Es kann auch ein Schema für die Tabelle angegeben werden. Entweder mit der protected Variablen ``$_schema`` oder
mit dem Schema vorangestellt in der ``$_name`` Eigenschaft. Jedes Schema welches in der ``$_name`` Eigenschaft
angegeben ist wird vorrangig gegenüber dem Schema der ``$_schema`` Eigenschaft behandelt. In einigen *RDBMS*
Marken ist die Bezeichnung für Schema "database" oder "tablespace", wird aber ähnlich verwendet.

.. _zend.db.table.defining.table-schema.example3:

.. rubric:: Angeben einer Table Klasse mit Schema

.. code-block:: php
   :linenos:

   // Erste Möglichkeit:
   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_schema = 'bug_db';
       protected $_name   = 'bugs';
   }

   // Zweite Möglichkeit:
   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bug_db.bugs';
   }

   // Wenn Schema sowohl in $_name als auch $_schema angegeben wird, so bekommt $_name vorrang:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name   = 'bug_db.bugs';
       protected $_schema = 'ignored';
   }

Die Schema und Tabellennamen können auch mit Konstruktor Konfigurationsdirektiven angegeben werden, welche
jegliche Standardwerte, angegeben in den ``$_name`` und ``$_schema`` Eigenschaften, überschreiben. Eine Schema
Angabe welche mit der ``name`` Directive angegeben wurde überschreibt jeglichen Wert welcher von der ``schema``
Option bereitgestellt ist.

.. _zend.db.table.defining.table-schema.example.constructor:

.. rubric:: Angebend von Tabellen und Schemanamen während der Instanziierung

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
   }

   // Erste Möglichkeit:

   $tableBugs = new Bugs(array('name' => 'bugs', 'schema' => 'bug_db'));

   // Zweite Möglichkeit:

   $tableBugs = new Bugs(array('name' => 'bug_db.bugs'));

   // Wenn Schema sowohl in $_name als auch $_schema angegeben wird,
   // so bekommt $_name vorrang:

   $tableBugs = new Bugs(array('name' => 'bug_db.bugs',
                               'schema' => 'ignored'));

Wenn kein Schemaname angegeben wird, so wird als Standard der Schemaname des Datenbankadapters verwendet.

.. _zend.db.table.defining.primary-key:

Angeben des Primärschlüssels der Tabelle
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Jede Tabelle muss einen Primärschlüssel haben. Die Spalte des Primärschlüssels kann mit der protected Variablen
``$_primary`` angegeben werden. Sie enthält entweder einen String, welcher die einzelen Spalte benennt, oder ein
Array von Spaltennamen, wenn der Primärschlüssel ein zusammengesetzter Schlüssel ist.

.. _zend.db.table.defining.primary-key.example:

.. rubric:: Beispiel für das spezifizieren eines Primärschlüssels

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';
       protected $_primary = 'bug_id';
   }

Wenn kein Primärschlüssel angegeben wird, versucht ``Zend_Db_Table_Abstract`` den Primärschlüssel mit Hilfe der
``describeTable()`` Methode zu ermitteln.

.. note::

   Jede Table Klasse muss wissen mit welche(r/n) Spalte(n) Zeilen eindeutig identifiziert werden können. Wenn
   keine Primärschlüssel Spalte(n) in der Klassendefinition oder als Argument für den Konstruktor angegeben
   wurde und nicht aus den Metadaten der Tabelle mit Hilfe der ``describeTable()`` Methode ermittelt werden kann,
   dann kann die Tabelle nicht mit ``Zend_Db_Table`` verwendet werden.

.. _zend.db.table.defining.setup:

Überschreiben von Table Setup Methoden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wenn eine Instanz einer Table Klasse erzeugt wird, ruft der Konstruktor einige protected Methoden auf, die
Metadaten der Tabelle initialisieren. Jede dieser Methoden kann erweitert werden um Metadaten explizit anzugeben.
Dabei darf nicht vergessen werden am Ende der eigenen Methode die gleichnamige Methode der Parentklasse aufzurufen.

.. _zend.db.table.defining.setup.example:

.. rubric:: Beispiel für das Überschreiben der \_setupTableName() Methode

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected function _setupTableName()
       {
           $this->_name = 'bugs';
           parent::_setupTableName();
       }
   }

Folgende Setup Methoden sind überschreibbar:

- ``_setupDatabaseAdapter()`` überprüft ob ein Adapter bereitgestellt wird; nimmt einen Standardadapter aus der
  Registry, wenn benötigt. Durch das Überschreiben dieser Methode kann ein Datenbankadapter aus einer anderen
  Quelle gesetzt werden.

- ``_setupTableName()`` setzt den standard Tabellennamen auf den Namen der Klasse. Durch das Überschreiben dieser
  Methode kann der Tabellenname gesetzt werden bevor dieses Standardverhalten abläuft.

- ``_setupMetadata()`` setzt das Schema wenn der Tabellenname dem Muster "``schema.table``" entspricht; ruft
  ``describeTable()`` auf um Metadaten Informationen zu erhalten; Standardisiert das ``$_cols`` Array auf die
  Spalten wie von ``describeTable()`` geliefert. Durch das Überschreiben dieser Methode können die Spalten
  angegeben werden.

- ``_setupPrimaryKey()`` standardisiert die Primärschlüssel Spalten zu denen geliefert von ``describeTable()``;
  prüft ob die Primärschlüssel Spalten im ``$_cols`` Array enthalten sind. Durch das Überschreiben dieser
  Methode können die Primärschlüssel Spalten angegeben werden.

.. _zend.db.table.initialization:

Tabellen Initialisierung
^^^^^^^^^^^^^^^^^^^^^^^^

Wenn Anwendungs-spezifische Logik initialisiert werden soll wenn eine Tabellenklasse erstellt wird, kann man
entscheiden die Aufgaben in die ``init()`` Methode zu verschieben, die aufgerufen wird nachdem alle Tabellen
Metadaten bearbeitet wurden. Das ist besser als die ``__construct()`` Methode wenn die Metadaten nicht
programmtechnisch verändert werden sollen.

.. _zend.db.table.defining.init.usage.example:

.. rubric:: Beispielverwendung der init() Methode

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_observer;

       public function init()
       {
           $this->_observer = new MyObserverClass();
       }
   }

.. _zend.db.table.constructing:

Erzeugen einer Instanz einer Tabelle
------------------------------------

Bevor eine Table Klasse verwendet werden kann muss eine Instanz mit dem Konstruktor erzeugt werden. Das Konstruktor
Argument ist ein Array von Optionen. Die wichtigste Option für einen Tabellenkonstruktor ist die Instanz der
Adapterklasse, welche eine live Verbindung zu einem *RDBMS* repräsentiert. Es gibt drei Möglichkeiten den
Datenbankadapter einer Tabellenklasse anzugeben und diese sind unten beschrieben:

.. _zend.db.table.constructing.adapter:

Angeben eines Datenbankadapters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Der erste Weg einen Datenbankadapter an eine Table Klasse bereitzustellen ist, ein Objekt des Typs
``Zend_Db_Adapter_Abstract`` im Options Array, bezeichnet mit dem Schlüssel '``db``', zu übergeben.

.. _zend.db.table.constructing.adapter.example:

.. rubric:: Beispiel für das Erzeugen einer Tabelle mit Nutzung eines Adapterobjekts

.. code-block:: php
   :linenos:

   $db = Zend_Db::factory('PDO_MYSQL', $options);

   $table = new Bugs(array('db' => $db));

.. _zend.db.table.constructing.default-adapter:

Setzen eines Standard-Datenbankadapters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Der zweite Weg einer Table Klasse einen Datenbankadapter bereit zu stellen ist es, ein Objekt des Typs
``Zend_Db_Adapter_Abstract`` zu deklarieren und als Standard für alle nachfolgenden Instanzen von Table der
Applikation zu setzen. Dies kann mit der static Methode ``Zend_Db_Table_Abstract::setDefaultAdapter()`` getan
werden. Das Argument ist ein Objekt des Typs ``Zend_Db_Adapter_Abstract``.

.. _zend.db.table.constructing.default-adapter.example:

.. rubric:: Beispiel für das erstellen von Table mit einem Standardadapter

.. code-block:: php
   :linenos:

   $db = Zend_Db::factory('PDO_MYSQL', $options);
   Zend_Db_Table_Abstract::setDefaultAdapter($db);

   // Später...

   $table = new Bugs();

Es kann geeignet sein den Datenbankadapter an einer zentralen Stelle der Anwendung, wie dem Bootstrap, zu erzeugen,
und als Standardadapter zu speichern. Dies hilft sicher zu stellen, das der verwendete Adapter in der gesamten
Anwendung der gleiche ist. Allerdings kann nur eine einzelne Adapterinstanz als Standardadapter verwendet werden.

.. _zend.db.table.constructing.registry:

Speichern eines Datenbankadapters in der Registry
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Der dritte Weg einer Table Klasse einen Datenbankadapter bereit zu stellen ist es einen String in dem Optionsarray
zu übergeben, auch mit dem '``db``' Schlüssel identifiziert. Der String wird als Schlüssel der statischen
``Zend_Registry`` Instanz verwendet, wo der Eintrag mit dem Schlüssel ein Objekt des Typs
``Zend_Db_Adapter_Abstract`` ist.

.. _zend.db.table.constructing.registry.example:

.. rubric:: Beispiel für das Erzeugen von Table mit einem Registry Schlüssel

.. code-block:: php
   :linenos:

   $db = Zend_Db::factory('PDO_MYSQL', $options);
   Zend_Registry::set('my_db', $db);

   // Später...

   $table = new Bugs(array('db' => 'my_db'));

Wie das Setzen eines Standardadapters, bietet auch dieses sicher zu stellen das die gleiche Adapter Instanz in der
gesamten Anwendung verwendet wird. Nutzen der Registry ist flexibler, da mehr als eine Adapterinstanz gepeichert
werden kann. Eine angegebene Adapterinstanz ist spezifisch für eine bestimmte *RDBMS* Marke und Datenbankinstanz.
Wenn die Anwendung Zugriff auf mehrere Datenbanken benötigt oder auch mehrere Datenbank Marken, dann müssen
mehrere Adapter verwendet werden.

.. _zend.db.table.insert:

Zeilen in eine Tabelle einfügen
-------------------------------

Table Objekte können verwendet werden um Zeilen in die Datenbank Tabelle einzufügen auf der das Table Objekt
basiert. Hierzu kann die ``insert()`` Methode des Table Objektes verwendet werden. Das Argument ist ein
assoziatives Array, das Spalten Namen mit Werten verbindet.

.. _zend.db.table.insert.example:

.. rubric:: Beispiel für das Einfügen in eine Tabelle

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $data = array(
       'created_on'      => '2007-03-22',
       'bug_description' => 'Irgendwas falsch',
       'bug_status'      => 'NEW'
   );

   $table->insert($data);

Standardmäßig werden Werte im Daten Array als literale Werte eingefügt durch das Verwenden von Parametern. Wenn
es notwendig ist das diese als *SQL* Ausdruck behandelt werden, muß sichergestellt werden das Sie sich von reinen
Strings unterscheiden. Es kann ein Objekt vom Typ ``Zend_Db_Expr`` verwendet werden um das zu bewerkstelligen.

.. _zend.db.table.insert.example-expr:

.. rubric:: Beispiel für das Einfügen von Ausdrücken in einer Tabelle

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $data = array(
       'created_on'      => new Zend_Db_Expr('CURDATE()'),
       'bug_description' => 'Irgendwas ist falsch',
       'bug_status'      => 'NEU'
   );

Um obigen Beispiel vom Einfügen von Zeilen, wird angenommen das die Tabelle einen automatischen Primärschlüssel
hat. Das ist das Standardverhalten von ``Zend_Db_Table_Abstract``, aber es gibt auch andere Typen von
Primärschlüssel. Das folgende Kapitel beschreibt wie verschiedene Typen von Primärschlüssel unterstützt
werden.

.. _zend.db.table.insert.key-auto:

Eine Tabelle mit einem automatischen Primärschlüssel verwenden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ein automatischer Primärschlüssel erzeigt einen eindeutigen Integerwert wenn die Spalte des Primären Typs in der
eigenen *SQL* ``INSERT`` Anweisung unterdrückt wird.

Wenn die geschützte Variable ``$_sequence``, in ``Zend_Db_Table_Abstract``, als boolscher Wert ``TRUE`` definiert
wird, nimmt die Klasse an das die Tabelle einen automatischen Primärschlüssel hat.

.. _zend.db.table.insert.key-auto.example:

.. rubric:: Beispiel für das Deklarierens einer Tabelle mit einem automatischen Primärschlüssel

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';

       // Das ist der Standardwert in der Zend_Db_Table_Abstract Klasse;
       // er muß nicht definiert werden.
       protected $_sequence = true;
   }

MySQL, Microsoft *SQL* Server, und SQLite sind Beispiele von *RDBMS* Marken die automatische Primärschlüssel
unterstützen.

PostgreSQL hat eine ``SERIAL`` Notation die implizit eine Sequenz definiert die auf den Tabellen- und Spaltennamen
basiert, und diese Sequenz verwendet, um einen Schlüsselwert für neue Zeilen zu erstellen. *IBM* *DB2* hat eine
``IDENTITY`` Notation die ähnlich arbeitet. Wenn eine dieser Notationen verwendet wird, muß der ``Zend_Db_Table``
Klasse mitgeteilt werden das Sie eine automatische Spalte hat, indem ``$_sequence`` auf ``TRUE`` gesetzt wird.

.. _zend.db.table.insert.key-sequence:

Eine Tabelle mit einer Sequenz verwenden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Eine Sequenz ist ein Datenbank Objekt das einen eindeutigen Wert erstellt, der als Wert des Primärschlüssels in
einer oder mehreren Tabellen der Datenbank verwendet werden kann.

Wenn ``$_sequence`` als String definiert wird, nimmt ``Zend_Db_Table_Abstract`` an das der String den Namen des
Sequenz Objektes in der Datenbank benennt. Die Sequenz wird aufgerufen um einen neuen Wert zu erstellen, und dieser
Wert wird in der ``INSERT`` Operation verwendet.

.. _zend.db.table.insert.key-sequence.example:

.. rubric:: Beispiel für das Deklaration einer Tabelle mit einer Sequenz

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';

       protected $_sequence = 'bug_sequence';
   }

Oracle, PostgreSQL, und *IBM* *DB2* sind Beispiele von *RDBMS* Marken die Sequenz Objekte in der Datenbank
unterstützen.

PostgreSQL und *IBM* *DB2* haben auch einen Syntax der Sequenzen implizit definiert und diese mit Spalten
assoziiert. Wenn diese Notation verwendet wird, muß der Tabelle gesagt werden das Sie eine automatische
Schlüsselspalte besitzt. Der Name der Sequenz muß nur in den Fällen als String definiert werden in denen die
Sequenz explizit aufgerufen wird um den nächsten Schlüsselwert zu erhalten.

.. _zend.db.table.insert.key-natural:

Eine Tabelle mit einem natürlichen Schlüssel verwenden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Einige Tabellen haben natürliche Schlüssel. Das bedeutet das der Schlüssel nicht automatisch durch die Tabelle
oder eine Sequenz erstellt wird. Der Wert für den Primärschlüssel muß in diesem Fall selbst definiert werden.

Wenn ``$_sequence`` als boolsches ``FALSE`` definiert wird, nimmt ``Zend_Db_Table_Abstract`` an das die Tabelle
einen natürlichen Primärschlüssel hat. Es müssen Werte für die Spalte des Primärschlüssels im Array der
Daten definiert werden die an die ``insert()`` Methode übergeben werden, andernfalls wird diese Methode eine
``Zend_Db_Table_Exception`` werfen.

.. _zend.db.table.insert.key-natural.example:

.. rubric:: Beispiel für das Definieren einer Tabelle mit einem natürlichen Schlüssel

.. code-block:: php
   :linenos:

   class BugStatus extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bug_status';

       protected $_sequence = false;
   }

.. note::

   Alle *RDBMS* Marken unterstützen Tabellen mit natürlichen Schlüsseln. Beispiele von Tabellen die oft so
   definiert werden das Sie natürliche Schlüssel besitzen sind Lookup Tabellen, Durchschnitts Tabellen in
   viele-zu-viele Beziehungen, oder die meisten Tabellen mit komponierten Primärschlüsseln.

.. _zend.db.table.update:

Zeilen in einer Tabelle aktualisieren
-------------------------------------

Spalten können in der Datenbanktabelle aktualisiert werden indem die ``update()`` Methode der Table Klasse
verwendet wird. Diese Methode nimmt zwei Argumente: ein assoziatives Array von Spalten die geändert werden sollen
und neue Werte die diesen Spalten hinzugefügt werden; und einen *SQL* Ausdruck der in der ``WHERE`` Klausel
verwendet wird, als Kriterium für die Zeilen die in der ``UPDATE`` Operation geändert werden sollen.

.. _zend.db.table.update.example:

.. rubric:: Beispiel für das Aktualisieren von Zeilen in einer Tabelle

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $where = $table->getAdapter()->quoteInto('bug_id = ?', 1234);

   $table->update($data, $where);

Da die ``update()`` Methode der Tabelle zur :ref:`update() <zend.db.adapter.write.update>` Methode des Datenbank
Adapters weiterleitet, kann das zweite Argument ein Array von *SQL* Ausdrücken sein. Diese Ausdrücke werden als
Boolsche Terme kombiniert indem ein ``AND`` Operator verwendet wird.

.. note::

   Die Werte und Identifizierer im *SQL* Ausdruck werden nicht in Anführungszeichen gesetzt. Wenn Werte oder
   Identifizierer vorhanden sind die das Setzen in Anführungszeichen benötigen, ist man selbst dafür zuständig
   das dies getan wird. Die ``quote()``, ``quoteInto()`` und ``quoteIdentifier()`` Methoden des Datenbank Adapters
   können dafür verwendet werden.

.. _zend.db.table.delete:

Zeilen aus einer Tabelle löschen
--------------------------------

Zeilen können von einer Datenbanktabelle gelöscht werden indem die ``delete()`` Methode verwendet wird. Diese
Methode nimmt ein Argument, welches ein *SQL* Ausdruck ist, der in der ``WHERE`` Klausel als Kriterium dafür
verwendet wird, welche Zeilen gelöscht werden sollen.

.. _zend.db.table.delete.example:

.. rubric:: Beispiel für das Löschen von Zeilen einer Tabelle

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $where = $table->getAdapter()->quoteInto('bug_id = ?', 1235);

   $table->delete($where);

Da die ``delete()`` Methode der Tabelle zur :ref:`delete() <zend.db.adapter.write.delete>` Methode des Datenbank
Adapters weiterleitet, kann das Argument ein Array von *SQL* Ausdrücken sein. Diese Ausdrücke werden als boolsche
Terme kombiniert indem ein ``AND`` Operator verwendet wird.

.. note::

   Die Werte und Identifizierer im *SQL* Ausdruck werden nicht in Anführungszeichen gesetzt. Wenn Werte oder
   Identifizierer vorhanden sind die das Setzen in Anführungszeichen benötigen, ist man selbst dafür zuständig
   das dies getan wird. Die ``quote()``, ``quoteInto()`` und ``quoteIdentifier()`` Methoden des Datenbank Adapters
   können dafür verwendet werden.

.. _zend.db.table.find:

Zeilen durch den Primärschlüssel finden
---------------------------------------

Die Datenbanktabelle kann nach passenden Zeilen für spezifizierte Werte im Primärschlüssel abgefragt werden,
indem die ``find()`` Methode verwendet wird. Das erste Argument dieser Methode ist entweder ein einzelner Wert oder
ein Array von Werten die dem Primärschlüssel dieser Tabelle entsprechen.

.. _zend.db.table.find.example:

.. rubric:: Beispiel für das Finden von Zeilen durch Werte des Primärschlüssels

.. code-block:: php
   :linenos:

   $table = new Bugs();

   // Eine einzelne Zeile finden
   // Gibt ein Rowset zurück
   $rows = $table->find(1234);

   // Mehrere Zeilen finden
   // Gibt auch ein Rowset zurück
   $rows = $table->find(array(1234, 5678));

Wenn ein einzelner Wert spezifiziert wird, gibt die Methode auch maximal eine Zeile zurück, weil ein
Primärschlüssel keinen doppelten Wert haben kann und es maximal eine Zeile in der Datenbank gibt die dem
spezifizierten Wert entspricht. Wenn mehrere Werte in einem Array spezifiziert werden, gibt die Methode maximal
soviele Zeilen zurück wie die Anzahl an unterschiedlichen Werten die spezifiziert wurden.

Die ``find()`` Methode kann weniger Zeilen zurückgeben als die Anzahl an Werten die für den Primärschlüssel
definiert wurden, wenn einige der Werte keiner Zeile in der Datenbank Tabelle entsprechen. Die Methode kann sogar
null Zeilen zurückgeben. Weil die Anzahl an zurückgegebenen Zeilen variabel ist, gibt die ``find()`` Methode ein
Objekt vom Typ ``Zend_Db_Table_Rowset_Abstract`` zurück.

Wenn der Primärschlüssel ein komponierter Schlüssel ist, als einer der aus mehreren Spalten besteht, können die
zusätzlichen Spalten als zusätzliche Argumente in der ``find()`` Methode definiert werden. Es müssen soviele
Argumente angegeben werden wie Spalten im Primärschlüssel der Tabelle existieren.

Um mehrere Zeilen von einer Tabelle mit einem kombinierten Primärschlüssel zu finden, muß ein Array für jedes
der Argumente übergeben werden. Alle dieser Arrays müssen die gleiche Anzahl an Elementen haben. Die Werte in
jedem Array werden in Tupeln geformt und gereiht; zum Beispiel definiert das erste Element in allen Array
Argumenten den ersten kombinierten Wert des Primärschlüssels, das zweite Element von allen Arrays definiert den
zweiten kombinierten Wert des Primärschlüssels, und so weiter.

.. _zend.db.table.find.example-compound:

.. rubric:: Beispiel für das Finden von Zeilen durch Werte von kombinierten Primärschlüsseln

Der Aufruf von ``find()`` anbei um mehreren Zeilen zu entsprechen kann zwei Zeilen in der Datenbank entsprechen.
Die erste Zeile muß den Wert des Primärenschlüssels (1234, 'ABC') haben, und die zweite Zeile den Wert des
Primärschlüssels (5678, 'DEF').

.. code-block:: php
   :linenos:

   class BugsProducts extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs_products';
       protected $_primary = array('bug_id', 'product_id');
   }

   $table = new BugsProducts();

   // Eine einzelne Zeilen mit einem kombinierten Primärschlüssel finden
   // Gibt ein Rowset zurück
   $rows = $table->find(1234, 'ABC');

   // Mehrere Zeilen mit einem kombinierten Primärschlüssel finden
   // Gibt auch ein Rowset zurück
   $rows = $table->find(array(1234, 5678), array('ABC', 'DEF'));

.. _zend.db.table.fetch-all:

Ein Set von Zeilen abfragen
---------------------------

.. _zend.db.table.fetch-all.select:

Select API
^^^^^^^^^^

.. warning::

   Die *API* für die Hol-Operationen wurde ausgeweitet um einem ``Zend_Db_Table_Select`` Objekt zu erlauben die
   Abfrage zu modifizieren. Trotzdem wird die veraltete Verwendung der ``fetchRow()`` und ``fetchAll()`` Methoden
   weiterhin ohne Änderungen funktionieren.

   Die folgenden Ausdrücke sind gültig und funktionell identisch, trotzdem wird empfohlen den Code zu
   aktualisieren um Vorteil aus der neuen Verwendung zu ziehen wo das möglich ist.

   .. code-block:: php
      :linenos:

      /**
       * Ein Rowset holen
       */
      $rows = $table->fetchAll(
          'bug_status = "NEW"',
          'bug_id ASC',
          10,
          0
          );
      $rows = $table->fetchAll(
          $table->select()
              ->where('bug_status = ?', 'NEW')
              ->order('bug_id ASC')
              ->limit(10, 0)
          );
      // oder mit Bindung
      $rows = $table->fetchAll(
          $table->select()
              ->where('bug_status = :status')
              ->bind(array(':status'=>'NEW')
              ->order('bug_id ASC')
              ->limit(10, 0)
          );

      /**
       * Eine einzelne Zeile holen
       */
      $row = $table->fetchRow(
          'bug_status = "NEW"',
          'bug_id ASC'
          );
      $row = $table->fetchRow(
          $table->select()
              ->where('bug_status = ?', 'NEW')
              ->order('bug_id ASC')
          );
      // oder mit Bindung
      $row = $table->fetchRow(
          $table->select()
              ->where('bug_status = :status')
              ->bind(array(':status'=>'NEW')
              ->order('bug_id ASC')
          );

Das ``Zend_Db_Table_Select`` Objekt ist eine Erweiterung des ``Zend_Db_Select`` Objekts das spezielle
Einschränkungen zu einer Abfrage hinzufügt. Die Verbesserungen und Einschränkungen sind folgende:

- Man **kann** sich entscheiden ein Subset von Zeilen einer fetchRow oder fetchAll Abfrage zurückzuerhalten. Dann
  kann Vorteile durch Optimierung bieten, wenn die Rückgabe eines großes Sets an Ergebnissen für alle Zeilen
  nicht gewünscht wird.

- Man **kann** Zeilen spezifizieren die Ausdrücke innerhalb der ausgewählten Tabelle evaluieren. Trotzdem
  bedeutet das, das die zurückgegebene Zeile oder Zeilenset ``readOnly`` (nur lesbar) ist und nicht für
  ``save()`` Operationen verwendet werden kann. Eine ``Zend_Db_Table_Row`` mit ``readOnly`` Status wird eine
  Exception werfen wenn eine ``save()`` Operation versucht wird.

- Man **kann** ``JOIN`` Klauseln auf einer Auswahl erlauben um Mehrfach-Tabellen Lookups zu erlauben.

- Man **kann keine** Spalten von einer geJOINten Tabelle spezifizieren damit Sie in einer Zeile oder Zeilenset
  zurückgegeben werden. Wenn das versucht wird, wird ein *PHP* Fehler getriggert. Das wurde getan um
  Sicherzustellen das die Integrität von ``Zend_Db_Table`` gewahrt bleibt. z.B. ein ``Zend_Db_Table_Row`` sollte
  nur Spalten referenzieren die von seiner Elterntabelle abgeleitet sind.

.. _zend.db.table.qry.rows.set.simple.usage.example:

.. rubric:: Einfache Verwendung

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $select = $table->select();
   $select->where('bug_status = ?', 'NEW');

   $rows = $table->fetchAll($select);

Flüssige Interfaces sind über alle Komponenten hinweg implementiert, sodass dies zu einer abgekürzteren Form
umgeschrieben werden kann.

.. _zend.db.table.qry.rows.set.fluent.interface.example:

.. rubric:: Beispiel des Fluent Interfaces

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $rows =
       $table->fetchAll($table->select()->where('bug_status = ?', 'NEW'));

.. _zend.db.table.fetch-all.usage:

Ein Set von Zeilen abfragen
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ein Set von Zeilen kann abgefragt werden indem irgendein Kriterium verwendet wird, das anders als die Werte des
Primärschlüssels sind, indem die ``fetchAll()`` Methode der Tabellen Klasse verwendet wird. Diese Methode gibt
ein Objekt vom Typ ``Zend_Db_Table_Rowset_Abstract`` zurück.

.. _zend.db.table.qry.rows.set.finding.row.example:

.. rubric:: Beispiel für das Finden von Zeilen durch einen Ausdruck

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $select = $table->select()->where('bug_status = ?', 'NEW');

   $rows = $table->fetchAll($select);

Der ``ORDER`` BY kann auch ein Sortier-Kriterium übergeben werden, genauso wie auch Count und Offset Integer
Werte, verwendet werden können damit die Abfrage ein spezielles Subset von Zeilen zurück gibt. Diese Werte werden
in einer ``LIMIT`` Klausel verwendet oder in einer ähnlichen Logik für *RDBMS* Marken welche die ``LIMIT`` Syntax
nicht unterstützen.

.. _zend.db.table.fetch-all.example2:

.. rubric:: Beispiel für das Finden von Zeilen durch einen Ausdruck

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $order  = 'bug_id';

   // Gibt die Zeilen 21 bis 30 zurück
   $count  = 10;
   $offset = 20;

   $select = $table->select()->where('bug_status = ?' => 'NEW')
                             ->order($order)
                             ->limit($count, $offset);

   $rows = $table->fetchAll($select);

Alle diese Argumente sind optional. Wenn die ``ORDER`` Klausel unterdrückt wird, dann enthält das Ergebnis die
Zeilen der Tabelle in einer unvorhersagbaren Reihenfolge. Wenn keine ``LIMIT`` Klausel gesetzt ist, dann wird jede
Zeile dieser Tabelle zurückgegeben die der ``WHERE`` Klausen entspricht.

.. _zend.db.table.advanced.usage:

Fortgeschrittene Verwendung
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Für speziellere und optimierte Ergebnisse, kann es gewünscht sein die Anzahl der zurückgegebenen Zeilen oder
Sets zu limitieren. Das kann durch die Übergabe einer ``FROM`` Klausel an das Select Objekt getan werden. Das
erste Argument in der ``FROM`` Klausel ist identisch mit den des ``Zend_Db_Select`` Objekts wobei man zusätzlich
eine Instanz von ``Zend_Db_Table_Abstract`` übergeben und damit den Tabellen Namen automatisch ermitteln lassen
kann.

.. _zend.db.table.qry.rows.set.retrieving.a.example:

.. rubric:: Spezielle Spalten erhalten

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $select = $table->select();
   $select->from($table, array('bug_id', 'bug_description'))
          ->where('bug_status = ?', 'NEW');

   $rows = $table->fetchAll($select);

.. important::

   Das Rowset enthält Zeilen die trotzdem 'gültig' sind - sie enthalten bloß ein Subset der Spalten einer
   Tabelle. Wenn eine ``save()`` Methode auf dem Teil einer Zeile aufgerufen wird dann werden nur die vorhandenen
   Felder geändert.

Es können Ausdrücke in einer ``FROM`` Klausel spezifiziert werden die dann als readOnly Zeile oder Set
zurückgegeben werden. In diesem Beispiel werden Zeilen von der Bugs Tabelle zurückgegeben die einen Bereich von
Nummern neuer Bugs zeigen die von Individuen mitgeteilt wurden. Die ``GROUP`` Klausel ist zu beachten. Die 'count'
Spalte wird der Zeile für Evaluation angefügt und es kann auch Sie zugegriffen werden wie wenn Sie ein Teil des
Schemas wäre.

.. _zend.db.table.qry.rows.set.retrieving.b.example:

.. rubric:: Ausdrücke als Spalten erhalten

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $select = $table->select();
   $select->from($table,
                 array('COUNT(reported_by) as `count`', 'reported_by'))
          ->where('bug_status = ?', 'NEW')
          ->group('reported_by');

   $rows = $table->fetchAll($select);

Es kann auch ein Lookup als Teil der Abfrage verwendet werden um die Fetch Operation zu verfeinern. In diesem
Beispiel wird die Accounts Tabelle als Teil einer Suche nach allen Bugs die von 'Bob' gemeldet wurden, abgefragt.

.. _zend.db.table.qry.rows.set.refine.example:

.. rubric:: Beispiel für das Finden von Zeilen durch einen Ausdruck

.. code-block:: php
   :linenos:

   $table = new Bugs();

   // Bei gesetztem From Abschnitt empfangen, wichtig wenn gejoint werden soll
   $select = $table->select(Zend_Db_Table::SELECT_WITH_FROM_PART);
   $select->setIntegrityCheck(false)
          ->where('bug_status = ?', 'NEW')
          ->join('accounts', 'accounts.account_name = bugs.reported_by')
          ->where('accounts.account_name = ?', 'Bob');

   $rows = $table->fetchAll($select);

``Zend_Db_Table_Select`` wird primär verwendet um zu verbinden und zu prüfen um die Kriterien für einen legalen
``SELECT`` Query sicherzustellen. Trotzdem gibt es viele Fälle in denen man die Flexibilität der
``Zend_Db_Table_Row`` benötigt und Zeilen nicht geschrieben oder gelöscht werden müssen. Für diesen speziellen
Fall ist es möglich Zeilen/-sets durch die Übergabe eines ``FALSE`` Wertes an ``setIntegrityCheck()`` zu
erhalten. Das resultierende Zeilen oder Zeilenset wird als eine 'locked' Zeile zurückgegeben (das bedeutet das
``save()``, ``delete()`` und jede andere Methode die Felder setzt wird eine Ausnahme werfen).

.. _zend.db.table.qry.rows.set.integrity.example:

.. rubric:: Entfernen des Integritäts Checks von Zend_Db_Table_Select um geJOINte Zeilen zu erlauben

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $select = $table->select(Zend_Db_Table::SELECT_WITH_FROM_PART)
                   ->setIntegrityCheck(false);
   $select->where('bug_status = ?', 'NEW')
          ->join('accounts',
                 'accounts.account_name= bugs.reported_by',
                 'account_name')
          ->where('accounts.account_name = ?', 'Bob');

   $rows = $table->fetchAll($select);

.. _zend.db.table.fetch-row:

Eine einzelne Zeilen abfragen
-----------------------------

Eine einzelne Zeile kann abgefragt werden indem Kriterien verwendet werden die ähnlich denen der ``fetchAll()``
Methode sind.

.. _zend.db.table.fetch-row.example1:

.. rubric:: Beispiel für das Finden einer einzelnen Zeilen durch einen Ausdruck

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $select  = $table->select()->where('bug_status = ?', 'NEW')
                              ->order('bug_id');

   $row = $table->fetchRow($select);

Diese Methode gibt ein Objekt vom Typ ``Zend_Db_Table_Row_Abstract`` zurück. Wenn die spezifizierten
Sortier-Kriterien keiner Zeile in der Datenbank Tabelle entsprechen gibt ``fetchRow()`` *PHP*'s ``NULL`` Wert
zurück.

.. _zend.db.table.info:

Informationen der Tabellen Metadaten erhalten
---------------------------------------------

Die ``Zend_Db_Table_Abstract`` Klasse bietet einige Informationen über Ihre Metadaten. Die ``info()`` Methode gibt
eine Array Struktur mit Informationen über die Tabelle, Ihre Spalten und Primärschlüssel zurück, sowie andere
Metadaten.

.. _zend.db.table.info.example:

.. rubric:: Beispiel für das Erhalten des Namens einer Tabelle

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $info = $table->info();

   echo "Der Name der Tabelle ist " . $info['name'] . "\n";

Die Schlüssel des Arrays das von der ``info()`` Methode zurückgegeben wird sind anbei beschrieben:

- **name** => der Name der Tabelle.

- **cols** => ein Array das die Spalte(n) der Tabelle benennt.

- **primary** => ein Array das die Spalte(n) des Primärschlüssels benennt.

- **metadata** => ein assoziatives Array das die Spaltennamen mit Informationen über die Spalten zusammenführt.
  Das ist die Information die durch die ``describeTable()`` Methode zurückgegeben wird.

- **rowClass** => der Name der konkreten Klasse die für Zeilen Objekte verwendet wird und von den Methoden dieser
  Table Instanz zurückgegeben wird. Der Standardwert ist ``Zend_Db_Table_Row``.

- **rowsetClass** => Name der konkreten Klasse für für Rowset Objekte verwendet wird und von den Methoden dieser
  Table Instanz zurückgegeben wird. Der Standardwert ist ``Zend_Db_Table_Rowset``.

- **referenceMap** => ist ein assoziatives Array von Klassennamen von Tabellen die diese Tabelle referenzieren.
  Siehe :ref:`dieses Kapitel <zend.db.table.relationships.defining>`.

- **dependentTables** => ein Array von Klassennamen von Tabellen die diese Tabelle referenzieren. Siehe
  :ref:`dieses Kapitel <zend.db.table.relationships.defining>`.

- **schema** => der Name des Schemas (oder der Datenbank oder dem Tabellenraum) für diese Tabelle.

.. _zend.db.table.metadata.caching:

Tabellen Metadaten cachen
-------------------------

Standardmäßig fragt ``Zend_Db_Table_Abstract`` die darunterliegende Datenbank für die :ref:`Metadaten der
Tabelle <zend.db.table.info>` ab immer wenn diese diese Daten benötigt werden um Tabellenoperationen
durchzuführen. Das Tableobjekt holt die Metadaten der Tabelle von der Datenbank indem es die ``describeTable()``
Methode des Adapters verwendet. Operationen die diese Einsicht benötigten sind:

- ``insert()``

- ``find()``

- ``info()``

In einigen Fällen, speziell wenn viele Table Objekte auf der gleichen Datenbanktabelle instanziert werden kann das
Abfragen der Datenbank nach den Metadaten der Tabelle für jede Instanz unerwünscht sein wegen der
Geschwindigkeit. In solchen Fällen, können Benutzer davon profitieren das die Metadaten der Tabelle, die von der
Datenbank empfangen werden, gecached werden.

Es gibt zwei grundsätzliche Wege bei denen ein Benutzer Vorteile davon haben kann wenn die Metadaten der Tabelle
gecached werden:

- **Aufruf von Zend_Db_Table_Abstract::setDefaultMetadataCache()**- Das erlaubt es Entwicklern das
  Standardcacheobjekt zu setzen das für alle Tabellenklassen verwendet werden soll.

- **Konfigurieren von Zend_Db_Table_Abstract::__construct()**- Das erlaubt es Entwicklern das Cacheobjekt zu setzen
  das für eine spezielle Instanz der Tabellenklasse verwendet werden soll.

In beiden Fällen muß die Spezifikation des Caches entweder ``NULL`` (wenn kein Cache verwendet wird) oder eine
Instanz von :ref:`Zend_Cache_Core <zend.cache.frontends.core>` sein. Die Methoden können in Verbindung zueinander
verwendet werden wenn es gewünscht ist beides zu haben, einen standardmäßigen Cache für die Metadaten und die
Möglichkeit den Cache eines individuellen Tabellenobjektes zu ändern.

.. _zend.db.table.metadata.caching-default:

.. rubric:: Verwenden eines standardmäßigen Caches für Metadaten für alle Tabellenobjekte

Der folgende Code demonstriert wie ein standardmäßiger Cache für die Metadaten gesetzt werden kann der für alle
Tabellenobjekte verwendet wird:

.. code-block:: php
   :linenos:

   // Zuerst muß der Cache vorbereitet werden
   $frontendOptions = array(
       'automatic_serialization' => true
       );

   $backendOptions  = array(
       'cache_dir'                => 'cacheDir'
       );

   $cache = Zend_Cache::factory('Core',
                                'File',
                                $frontendOptions,
                                $backendOptions);

   // Als nächstes, den Cache setzen der mit allen Tabellenobjekten verwendet werden soll
   Zend_Db_Table_Abstract::setDefaultMetadataCache($cache);

   // Eine Tabellenklasse wird auch benötigt
   class Bugs extends Zend_Db_Table_Abstract
   {
       // ...
   }

   // Jede Instanz von Bugs verwenden nur den Standardmäßigen Cache für die Metadaten
   $bugs = new Bugs();

.. _zend.db.table.metadata.caching-instance:

.. rubric:: Einen Metadaten Cache für ein spezielles Tabellenobjekt verwenden

Der folgende Code demonstriert wie ein Cache für Metadaten für eine spezielle Instanz eines Tabellenobjektes
gesetzt werden kann:

.. code-block:: php
   :linenos:

   // Zuerst den Cache vorbereiten
   $frontendOptions = array(
       'automatic_serialization' => true
       );

   $backendOptions  = array(
       'cache_dir'                => 'cacheDir'
       );

   $cache = Zend_Cache::factory('Core',
                                'File',
                                $frontendOptions,
                                $backendOptions);

   // Eine Tabellenklasse wird auch benötigt
   class Bugs extends Zend_Db_Table_Abstract
   {
       // ...
   }

   // Eine Instanz für die Instanzierung konfgurieren
   $bugs = new Bugs(array('metadataCache' => $cache));

.. note::

   **Automatische Serialisierung mit dem Cache Frontend**

   Da die Information die von der ``describeTable()`` Methode des Adapters zurückgegeben wird, ein Array ist, muß
   sichergestellt werden das die ``automatic_serialization`` Option für das ``Zend_Cache_Core`` Frontend auf
   ``TRUE`` gesetzt wird.

Obwohl die obigen Beispiele ``Zend_Cache_Backend_File`` verwenden, können Entwickler jegliches Cache Backend
verwenden das der Situation am besten entspricht. Siehe :ref:`Zend_Cache <zend.cache>` für weitere Informationen.

.. _zend.db.table.metadata.caching.hardcoding:

Tabellen Metadaten hardcoden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um das Cachen von Metadaten einen weiteren Schritt weiterzubringen, kann man sich auch entscheiden die Metadaten
hardzucoden. In diesem speziellen Fall benötigt jede Änderung trotzdem eine Änderung im Code. Als solches, ist
es nur empfohlen für jene die eine Produktionsumgebung optimieren wollen.

Die Struktur der Metadaten ist wie folgt:

.. code-block:: php
   :linenos:

   protected $_metadata = array(
       '<column_name>' => array(
           'SCHEMA_NAME'      => <string>,
           'TABLE_NAME'       => <string>,
           'COLUMN_NAME'      => <string>,
           'COLUMN_POSITION'  => <int>,
           'DATA_TYPE'        => <string>,
           'DEFAULT'          => NULL|<value>,
           'NULLABLE'         => <bool>,
           'LENGTH'           => <string - length>,
           'SCALE'            => NULL|<value>,
           'PRECISION'        => NULL|<value>,
           'UNSIGNED'         => NULL|<bool>,
           'PRIMARY'          => <bool>,
           'PRIMARY_POSITION' => <int>,
           'IDENTITY'         => <bool>,
       ),
       // additional columns...
   );

Ein einfacher Weg um die richtigen Werte zu erhalten ist es den Metadaten Cache zu verwenden, und dann die Werte
die im Cache gespeichert sind, zu deserialisieren.

Diese Optimierung kann ausgeschaltet werden indem das ``metadataCacheInClass`` Flag ausgeschaltet wird:

.. code-block:: php
   :linenos:

   // Bei der Instanziierung:
   $bugs = new Bugs(array('metadataCacheInClass' => false));

   // Oder später:
   $bugs->setMetadataCacheInClass(false);

Das Flag ist standardmäßig aktiviert, was sicherstellt dass das ``$_metadata`` Array nur einmal pro Instanz
ausgeliefert wird.

.. _zend.db.table.extending:

Eine Table Klasse erweitern und anpassen
----------------------------------------

.. _zend.db.table.extending.row-rowset:

Verwenden eigener Zeilen oder Rowset Klassen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Standardmäßig geben die Methoden der Table Klasse ein Rowset als Instanzen der konkreten Klasse
``Zend_Db_Table_Rowset``, und Rowsets enthalten eine Kollektion von Instanzen der konkreten Klasse
``Zend_Db_Table_Row``. Eine alternative Klasse kann für jede von Ihnen als alternative Klasse definiert werden die
verwendet werden soll, aber es müssen Klassen sein die ``Zend_Db_Table_Rowset_Abstract`` erweitern und respektiv
``Zend_Db_Table_Row_Abstract``.

Es können Zeilen und Rowset Klassen definiert werden indem das Optionsarray des Table Konstruktors verwendet wird,
respektiv die Schlüssel '``rowClass``' und '``rowsetClass``'. Die Namen der Klassen müssen spezifiziert werden
indem Strings verwendet werden.

.. _zend.db.table.extending.row-rowset.example:

.. rubric:: Beispiel dafür wie die Zeilen und Rowset Klassen spezifiziert werden können

.. code-block:: php
   :linenos:

   class My_Row extends Zend_Db_Table_Row_Abstract
   {
       ...
   }

   class My_Rowset extends Zend_Db_Table_Rowset_Abstract
   {
       ...
   }

   $table = new Bugs(
       array(
           'rowClass'    => 'My_Row',
           'rowsetClass' => 'My_Rowset'
       )
   );

   $where = $table->getAdapter()->quoteInto('bug_status = ?', 'NEW')

   // Gibt ein Objekt des Typs My_Rowset zurück
   // das ein Array von Objekten des Typs My_Row enthält.
   $rows = $table->fetchAll($where);

Die Klassen können geändert werden indem Sie mit den ``setRowClass()`` und ``setRowsetClass()`` Methoden
spezifiziert werden. Das entspricht den Zeilen und Rowsets die nachfolgend erstellt werden; es ändert aber nicht
die Klasse von Zeilen- oder Rowsetobjekten die bereits davor erstellt wurden.

.. _zend.db.table.extending.row-rowset.example2:

.. rubric:: Beispiel für das Ändern von Zeilen und Rowset Klassen

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $where = $table->getAdapter()->quoteInto('bug_status = ?', 'NEW')

   // Gibt ein Objekt vom Typ Zend_Db_Table_Rowset zurück das ein Array
   // von Objekten des Typs Zend_Db_Table_Row enthält.
   $rowsStandard = $table->fetchAll($where);

   $table->setRowClass('My_Row');
   $table->setRowsetClass('My_Rowset');

   // Gibt ein Objekt vom Typ My_Rowset zurück das ein Array
   // von Objekten des Typs My_Row enthält.
   $rowsCustom = $table->fetchAll($where);

   // Das $rowsStandard Objekt existiert noch immer, und es bleibt unverändert.

Für weitere Informationen über Zeilen und Rowset Klassenm siehe :ref:`dieses Kapitel <zend.db.table.row>` und
:ref:`dieses hier <zend.db.table.rowset>`.

.. _zend.db.table.extending.insert-update:

Selbst definierte Logik für das Einfügen, Aktualisieren und Löschen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die ``insert()`` und ``update()`` Methoden in der Table Klasse können überschrieben werden. Das bietet die
Möglichkeit eigenen Code einzufügen der ausgeführt wird bevor die Datenbank Operation durchgeführt wird. Es
muß sichergestellt werden das die Methode der Elternklasse aufgerufen wird wenn man fertig ist.

.. _zend.db.table.extending.insert-update.example:

.. rubric:: Eigene Logik um Zeitstempel zu managen

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';

       public function insert(array $data)
       {
           // Einen Zeitstempel hinzufügen
           if (empty($data['created_on'])) {
               $data['created_on'] = time();
           }
           return parent::insert($data);
       }

       public function update(array $data, $where)
       {
           // Einen Zeitstempel hinzufügen
           if (empty($data['updated_on'])) {
               $data['updated_on'] = time();
           }
           return parent::update($data, $where);
       }
   }

Auch die ``delete()`` Methode kann überschrieben werden.

.. _zend.db.table.extending.finders:

Eigene Such Methoden in Zend_Db_Table definieren
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Es können eigene Abfrage Methoden in der Table Klasse implementiert werden, wenn oft die Notwendigkeit besteht
Abragen mit speziellen Kriterien auf der Table Klasse durchzuführen. Die meisten Abfragen können mit
``fetchAll()`` geschrieben werden, das bedeutet aber das Code dupliziert werden muß um Abfragekonditionen zu
formen die Abfrage in verschiedenen Orten der Anwendung auszuführen. Hierfür kann es nützlich sein eine Methode
in der Table Klasse zu definieren um oft benutzte Abfragen an dieser Tabelle durchzuführen.

.. _zend.db.table.extending.finders.example:

.. rubric:: Eigene Methode um Fehler durch den Status zu finden

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';

       public function findByStatus($status)
       {
           $where = $this->getAdapter()->quoteInto('bug_status = ?', $status);
           return $this->fetchAll($where, 'bug_id');
       }
   }

.. _zend.db.table.extending.inflection:

Inflection (Beugung) in Zend_Db_Table definieren
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Einige Leute bevorzugen das der Name der Table Klasse einem Tabellennamen in der *RDBMS*, durch eine
Stringumwandlung die **Inflection** (Beugung) genannt wird, entspricht.

Wenn zum Beispiel der Name der Table Klasse "BugsProducts" ist, würde Sie der physikalischen Tabelle in der
Datenbank entsprechen die "bugs_products" heißt, wenn die explizite Definition der ``$_name`` Eigenschaft der
Klasse unterdrückt wird. In dieser Übereinstimmung der Beugung, wird der Klassenname im "CamelCase" Format
geschrieben und in Kleinschreibung transformiert, und Wörter mit einem Unterstrich seperiert.

Der Tabellenname der Datenbank kann unabhängig vom Klassennamen spezifiziert werden indem der Tabellenname mit der
Klasseneigenschaft ``$_name`` in jeder der eigenen Tabellenklassen deklariert wird.

``Zend_Db_Table_Abstract`` führt keine Beugung durch um die Klassennamen mit den Tabellennamen in Übereinstimmung
zu bringen. Wenn die Deklaration von ``$_name`` in der eigenen Tabellenklasse unterdrückt wird, wird die Klasse
mit der Datenbanktabelle in Verbindung gebracht die der Schreibweise des Klassennamens exakt entspricht.

Es ist unzureichend Identifizierer von der Datenbank zu transformieren, da das zu Doppeldeutigkeiten führen kann
oder einige Identifizierer sogar unerreichbar macht. Die Verwendung der *SQL* Identifizierer exakt so wie Sie in
der Datenbank vorhanden sind, macht ``Zend_Db_Table_Abstract`` sowohl einfacher als auch flexibler.

Wenn man es vorzieht Beugung zu verwenden, muß die Transformation selbst durch das Überschreiben der
``_setupTableName()`` Methode in der eigenen Tabellenklasse implementiert werden. Ein Weg um das zu tun ist die
Definition einer abstrakten Klase die ``Zend_Db_Table_Abstract`` erweitert. Der Rest der eigenen Klassen erweitert
dann die eigene neue abstrakte Klasse.

.. _zend.db.table.extending.inflection.example:

.. rubric:: Beispiel einer abstrakten Tabellenklasse die Beugung implementiert

.. code-block:: php
   :linenos:

   abstract class MyAbstractTable extends Zend_Db_Table_Abstract
   {
       protected function _setupTableName()
       {
           if (!$this->_name) {
               $this->_name = myCustomInflector(get_class($this));
           }
           parent::_setupTableName();
       }
   }

   class BugsProducts extends MyAbstractTable
   {
   }

Man ist selbst für das Schreiben von Funktionen verantwortlich um die Transformation der Beugung auszuführen.
Zend Framework bietet solche Funktionen nicht an.



.. _`Table Data Gateway`: http://www.martinfowler.com/eaaCatalog/tableDataGateway.html
.. _`Row Data Gateway`: http://www.martinfowler.com/eaaCatalog/rowDataGateway.html
