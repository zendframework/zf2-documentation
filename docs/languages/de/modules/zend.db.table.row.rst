.. _zend.db.table.row:

Zend_Db_Table_Row
=================

.. _zend.db.table.row.introduction:

Einführung
----------

``Zend_Db_Table_Row`` ist eine Klasse, die eine einzelne Zeile eines ``Zend_Db_Table``-Objekts enthält. Wenn eine
Abfrage über eine Table-Klasse gestartet wird, wird das Ergebnis als ein Satz von ``Zend_Db_Table_Row``-Objekten
zurückgegeben. Dieses Objekt kann auch benutzt werden, um neue Zeilen zu erstellen und sie in die Datenbank
einzutragen.

``Zend_Db_Table_Row`` ist eine Implementierung des `Row Data Gateway`_-Entwurfsmusters.

.. _zend.db.table.row.read:

Eine Zeile lesen
----------------

``Zend_Db_Table_Abstract`` enthält die Methoden ``find()`` und ``fetchAll()``, die beide ein
``Zend_Db_Table_Rowset`` Objekt zurückgeben, und die Methode ``fetchRow()``, die ein Objekt vom Typ
``Zend_Db_Table_Row`` zurückgibt.

.. _zend.db.table.row.read.example:

.. rubric:: Beispiel des Lesen einer Zeile

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow($bugs->select()->where('bug_id = ?', 1));

Ein ``Zend_Db_Table_Rowset`` Objekt enthält einen Satz von ``Zend_Db_Table_Row`` Objekten. Siehe das Kapitel über
:ref:`Tabellen Zeilensets <zend.db.table.rowset>` für Details.

.. _zend.db.table.row.read.example-rowset:

.. rubric:: Beispiel des Lesens einer Zeile aus einem Rowset

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $rowset = $bugs->fetchAll($bugs->select()->where('bug_status = ?', 1));
   $row = $rowset->current();

.. _zend.db.table.row.read.get:

Spaltenwerte aus einer Zeile lesen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Db_Table_Row_Abstract`` bietet Zugriffsmethoden an, damit die Spalten einer Zeile als Objekteigenschaften
angesprochen werden können.

.. _zend.db.table.row.read.get.example:

.. rubric:: Beispiel für das Lesens einer Spalte aus einer Zeile

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow($bugs->select()->where('bug_id = ?', 1));

   // Wert der Spalte bug_description ausgeben
   echo $row->bug_description;

.. note::

   Frühere Versionen von ``Zend_Db_Table_Row`` haben diese Spalten-Zugriffsnamen mithilfe einer
   Zeichenketten-Transformation namens **Inflection** auf Spaltennamen umgeleitet.

   Die Aktuelle Version von ``Zend_Db_Table_Row`` implementiert diese Funktion jedoch nicht mehr. Der
   Spalten-Zugriffsname muss genau so geschrieben sein, wie die Spalte in der Datenbank heißt.

.. _zend.db.table.row.read.to-array:

Zeilendaten als ein Array lesen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die Tabellenzeile kann mithilfe der ``toArray()`` Methode des Zeilenobjekts auch als Array gelesen werden. Diese
gibt ein assoziatives Array zurück, mit Spaltennamen als Index und ihren Inhalten als Werten.

.. _zend.db.table.row.read.to-array.example:

.. rubric:: Beispiel der Benutzung der toArray()-Methode

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow($bugs->select()->where('bug_id = ?', 1));

   // Das assoziative Array aus dem Zeilenobjekt holen
   $rowArray = $row->toArray();

   // Jetzt einfach wie ein normales Array verwenden
   foreach ($rowArray as $column => $value) {
       echo "Spalte: $column\n";
       echo "Wert:  $value\n";
   }

Das Array, das von ``toArray()`` zurückgegeben wird, ist nicht updatefähig. Die Werte des Arrays können wie in
jedem Array modifiziert werden, aber Änderungen an diesem Array werden nicht direkt in der Datenbank gespeichert.

.. _zend.db.table.row.read.relationships:

Daten aus verwandten Tabellen lesen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die Klasse ``Zend_Db_Table_Row_Abstract`` bietet Methoden, um Zeilen und Zeilensätze aus verwandten Tabellen
auszulesen. Siehe das :ref:`Kapitel über Beziehungen <zend.db.table.relationships>` für weitere Informationen
über Tabellenbeziehungen.

.. _zend.db.table.row.write:

Zeilen in die Datenbank schreiben
---------------------------------

.. _zend.db.table.row.write.set:

Spaltenwerte einer Zeile verändern
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Individuelle Werte von Spalten können mit Hilfe der Zugriffsvariablen gesetzt werden, so ähnlich wie Spalten in
obiegen Beispiel als Objekteigenschaften gelesen werden.

Das Ändern eines Werts über eine Zugriffsvariable ändert den Spaltenwert des Zeilenobjekts in der Anwendung,
aber noch wird die Änderung nicht in die Datenbank übernommen. Das wird mit der Methode ``save()`` erledigt.

.. _zend.db.table.row.write.set.example:

.. rubric:: Beispiel der Änderung eines Spaltenwertes einer Zeile

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow($bugs->select()->where('bug_id = ?', 1));

   // Wert einer oder mehrerer Spalten ändern
   $row->bug_status = 'FIXED';

   // Die Datenbankzeile mit den neuen Werten aktualisieren
   $row->save();

.. _zend.db.table.row.write.insert:

Eine neue Zeile einfügen
^^^^^^^^^^^^^^^^^^^^^^^^

Eine neue Zeile kann in einer Tabelle mit der ``createRow()`` Methode der Tabellenklasse angelegt werden. Auf
Felder dieser Zeile können mit dem Objektorientierten Interface zugegriffen werden, aber die Zeile wird nicht in
der Datenbank geschrieben, bis die ``save()`` Methode aufgerufen wird.

.. _zend.db.table.row.write.insert.example:

.. rubric:: Beispiel der Erstellung einer neuen Zeile für eine Tabelle

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $newRow = $bugs->createRow();

   // Spaltenwerte setzen, wie es in der Anwendung üblich ist
   $newRow->bug_description = '...Beschreibung...';
   $newRow->bug_status = 'NEW';

   // Neue Zeile in die Datenbank einfügen
   $newRow->save();

Das optionale Argument der ``createRow()`` Methode ist ein assoziatives Array, mit dem Felder der neuen Zeile
eingefügt werden können.

.. _zend.db.table.row.write.insert.example2:

.. rubric:: Beispiel der Bekanntgabe einer neuen Zeile für eine Tabelle

.. code-block:: php
   :linenos:

   $data = array(
       'bug_description' => '...Beschreibung...',
       'bug_status'      => 'NEW'
   );

   $bugs = new Bugs();
   $newRow = $bugs->createRow($data);

   // Neue Zeile in die Datenbank einfugen
   $newRow->save();

.. note::

   Die Methode ``createRow()`` wurde in früheren Versionen von ``Zend_Db_Table`` ``fetchNew()`` genannt. Es wird
   empfohlen, den neuen Methodennamen zu benutzen, obwohl der alte Name weiterhin funktioniert, um
   Abwärtskompatibilität zu gewährleisten.

.. _zend.db.table.row.write.set-from-array:

Werte mehrerer Spalten ändern
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Db_Table_Row_Abstract`` beinhaltet eine Methode namens ``setFromArray()``, die es ermöglicht, mehrere
Spalten einer Zeile mithilfe eines assoziativen Arrays mit Spaltenname/Wert-Paaren gleichzeitig zu setzen. Diese
Methode ist nützlich, um Werte für neue Zeilen oder Zeilen, die aktualisiert werden müssen, zu setzen.

.. _zend.db.table.row.write.set-from-array.example:

.. rubric:: Beispiel der Verwendung von setFromArray() um neue Werte in einer Tabelle zu setzen

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $newRow = $bugs->createRow();

   // Daten in ein assoziatives Array schreiben
   $data = array(
       'bug_description' => '...Beschreibung...',
       'bug_status'      => 'NEW'
   );

   // Alle Spaltenwerte auf einmal setzen
   $newRow->setFromArray($data);

   // Neue Zeile in die Datenbank schreiben
   $newRow->save();

.. _zend.db.table.row.write.delete:

Eine Zeile löschen
^^^^^^^^^^^^^^^^^^

Das Zeilenobjekt hat eine Methode namens ``delete()``. Diese löscht Zeilen in der Datenbank, deren
Primärschlüssel dem im Zeilenobjekt entspricht.

.. _zend.db.table.row.write.delete.example:

.. rubric:: Beispiel für das Löschen einer Zeile

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow('bug_id = 1');

   // Zeile löschen
   $row->delete();

``save()`` muss nicht aufgerufen werden, um den Löschvorgang abzuschließen; er wird sofort auf der Datenbank
ausgeführt.

.. _zend.db.table.row.serialize:

Serialisieren und Deserialisieren von Zeilen
--------------------------------------------

Es ist oft nützlich, Inhalte einer Datenbankzeile für spätere Benutzung zu speichern. Die Operation, die ein
Objekt in eine Form bringt, die einfach in einem Offline Speicher abgelegt werden kann (zum Beispiel eine
Textdatei), nennt man **Serialisierung**. ``Zend_Db_Table_Row_Abstract`` Objekte sind serialisierbar.

.. _zend.db.table.row.serialize.serializing:

Eine Zeile Serialisieren
^^^^^^^^^^^^^^^^^^^^^^^^

Es kann einfach *PHP*\ s ``serialize()`` Funktion verwendet werden, um einen String zu erstellen, der einen
Byte-Stream enthält welcher das Zeilen-Objekt repräsentiert.

.. _zend.db.table.row.serialize.serializing.example:

.. rubric:: Beispiel: Eine Zeile serialisieren

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow('bug_id = 1');

   // Objekt serialisieren
   $serializedRow = serialize($row);

   // Jetzt kann $serializedRow z.B. in einer Datei gespeichert werden

.. _zend.db.table.row.serialize.unserializing:

Zeilen deserialisieren
^^^^^^^^^^^^^^^^^^^^^^

*PHP*\ s ``unserialize()`` Funktion stellt ein Objekt aus einem Byte-Stream wieder her. Die Funktion gibt das
Original Objekt zurück.

Bitte beachten: Das zurückgegebene Zeilen-Objekt ist **nicht mit der Datenbank verbunden**. Das Zeilenobjekt und
seine Eigenschaften können gelesen werden, aber es können keine Zeilenwerte verändert oder andere Operationen
ausgeführt werden, die eine Datenbankverbindung benötigen.

.. _zend.db.table.row.serialize.unserializing.example:

.. rubric:: Beispiel für das deserialisieren eines serialisiertes Zeilenobjektes

.. code-block:: php
   :linenos:

   $rowClone = unserialize($serializedRow);

   // Jetzt können die Objekteigenschaften genutzt werden
   // allerdings nur lesend.
   echo $rowClone->bug_description;

.. note::

   **Warum werden Zeilenobjekte unverbunden deserialisiert?**

   Ein serialisiertes Objekt ist eine Zeichenkette, die lesbar für jeden ist, dem sie vorliegt. Es könnte ein
   Sicherheitsrisiko sein, Parameter wie Datenbank-Loginname und -Passwort in simplem, unverschlüsseltem Text
   abzulegen. Es ist nicht wünschenswert, solche Daten in einer Textdatei abzulegen, die nicht geschützt ist,
   oder sie in einer E-Mail oder einem anderen Medium zu versenden, das leicht von potentiellen Angreifern lesbar
   ist. Der Leser des serialisierten Objekts sollte es nicht benutzen können, um Zugriff zur Datenbank zu
   erhalten, ohne richtige Logindaten zu kennen.

.. _zend.db.table.row.serialize.set-table:

Ein Zeilenobjekt als Live-Daten reaktivieren
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ein nicht verbundenes Zeilenobjekt kann mithilfe der Methode ``setTable()`` reaktiviert werden. Das Argument dieser
Methode ist ein gültiges ``Zend_Db_Table_Abstract``-Objekt, das vom Benutzer erstellt wird. Für das Erstellen
eines Tabellenobjekts wird eine aktive Datenbankverbindung benötigt, also wird, indem die Tabelle wieder mit dem
Zeilenobjekt verknüpft wird, auch der Datenbankzugriff wiederhergestellt. Ab diesem Zeitpunkt können Werte im
Zeilenobjekt wieder verändert und in der Datenbank gespeichert werden.

.. _zend.db.table.row.serialize.set-table.example:

.. rubric:: Ein Zeilenobjekt reaktivieren

.. code-block:: php
   :linenos:

   $rowClone = unserialize($serializedRow);

   $bugs = new Bugs();

   // Das Zeilenobjekt wieder mit einer Tabelle
   // und damit mit einer aktiven Datenbankverbindung verknüpfen
   $rowClone->setTable($bugs);

   // Jetzt können wieder Werte geändert und danach gespeichert werden
   $rowClone->bug_status = 'FIXED';
   $rowClone->save();

.. _zend.db.table.row.extending:

Die Zeilenklasse erweitern
--------------------------

``Zend_Db_Table_Row`` ist die standardmäßige Implementierung der abstrakten Klasse
``Zend_Db_Table_Row_Abstract``. Selbstverständlich können auch eigene Klassen geschrieben werden, die
``Zend_Db_Table_Row_Abstract`` erweitern. Um die neue Zeilenklasse zum Speichern von Abfrageergebnissen zu
benutzen, muss der Name dieser selbstgeschriebene Zeilenklasse entweder in der geschützten ``$_rowClass``-Variable
einer Tabellen-KLasse oder als Array-Argument des Konstruktors eines Tabellenobjekts angegeben werden.

.. _zend.db.table.row.extending.example:

.. rubric:: Eine eigene Zeilenklasse angeben

.. code-block:: php
   :linenos:

   class MyRow extends Zend_Db_Table_Row_Abstract
   {
       // ...Anpassungen
   }

   // Eine eigene Zeilenklasse angeben, die
   // in allen Instanzen einer Tabellenklasse verwendet wird.
   class Products extends Zend_Db_Table_Abstract
   {
       protected $_name = 'products';
       protected $_rowClass = 'MyRow';
   }

   // Oder die eigene Zeilenklasse nur für eine bestimmte
   // Instanz der Tabellenklasse angeben.
   $bugs = new Bugs(array('rowClass' => 'MyRow'));

.. _zend.db.table.row.extending.overriding:

Initialisierung einer Zeile
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wenn Anwendungs-spezifische Logik benötigt wird die initialisiert werden soll wenn eine Zeile erstellt wird, kann
entschieden werden die Aufgaben in die ``init()`` Methode zu verschieben, welche aufgerufen wird nachdem alle
Metadaten der Zeile bearbeitet wurden. Das wird empfohlen statt der ``__construct()`` Methode wenn die Metadaten
nicht programtechnisch verändert werden müssen.

.. _zend.db.table.row.init.usage.example:

.. rubric:: Beispiel der Verwendung der init() Methode

.. code-block:: php
   :linenos:

   class MyApplicationRow extends Zend_Db_Table_Row_Abstract
   {
       protected $_role;

       public function init()
       {
           $this->_role = new MyRoleClass();
       }
   }

.. _zend.db.table.row.extending.insert-update:

Eigene Logik für Einfügen, Aktualisieren und Löschen in Zend_Db_Table_Row definieren
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die Zeilenklasse ruft geschützte Methoden namens ``_insert()``, ``_update()``, und ``_delete()`` auf, bevor die
entsprechenden Operationen in der ``INSERT``, ``UPDATE``, und ``DELETE`` ausgeführt werden. In diesen Methoden
kann in den eigenen Zeilenklassen auch eigene Logik implementiert werden.

Wenn es nötig ist, eigene Logik in einer bestimmten Tabelle auszuführen, und diese Logik bei jeder Operation
ausgeführt werden muss, die auf die Tabelle angewendet wird, hat es vielleicht mehr Sinn, diesen eigenen Code in
den ``insert()``, ``update()`` und ``delete()``-Methoden der eigenen Tabellenklasse zu implementieren. Trotzdem
kann es manchmal nötig sein, eigene Logik in der Zeilenklasse einzubauen.

Unten sind beispielhaft Fälle aufgeführt, in denen es Sinn haben könnte, eigene Logik in der Zeilenklasse
anstatt der Tabellenklasse einzubauen:

.. _zend.db.table.row.extending.overriding-example1:

.. rubric:: Beispiel einer eigenen Logik in einer Zeilenklasse

Es ist möglich, dass es nicht in allen Fällen nötig ist, diese Logik anzuwenden. Eigene Logik kann auf Abruf
angeboten werden, indem sie in einer Zeilenklasse eingebaut und je nach Bedarf ein Tabellenobjekt mit dieser
Zeilenklasse erstellt wird. In anderen Fällen benutzt das Tabellenobjekt die Standard Zeilenklasse.

Man benötigt Daten Operationen an der Tabelle um die Operationen an einem ``Zend_Log`` Objekt zu speichern, aber
nur, wenn die Konfiguration der Anwendung dieses Verhalten eingeschaltet hat.

.. code-block:: php
   :linenos:

   class MyLoggingRow extends Zend_Db_Table_Row_Abstract
   {
       protected function _insert()
       {
           $log = Zend_Registry::get('database_log');
           $log->info(Zend_Debug::dump($this->_data,
                                       "INSERT: $this->_tableClass",
                                       false)
                     );
       }
   }

   // $loggingEnabled sei ein Beispiel
   // für eine Konfigurationseinstellung
   if ($loggingEnabled) {
       $bugs = new Bugs(array('rowClass' => 'MyLoggingRow'));
   } else {
       $bugs = new Bugs();
   }

.. _zend.db.table.row.extending.overriding-example2:

.. rubric:: Zeilenklasse, die Insert Daten für verschiedene Tabellen loggt

Es könnte sein, dass eigene Anwendungslogik für mehrere Tabellen angewendet werden muss. Anstatt diese eigene
Logik in jeder Tabellenklasse zu implementieren, kann der Code für solche Zwecke auch in einer Zeilenklasse
eingebaut und diese Zeilenklasse für jede dieser Tabellenklassen benutzt werden.

In diesem Beispiel ist der Logging-Code für alle Tabellenklassen identisch.

.. code-block:: php
   :linenos:

   class MyLoggingRow extends Zend_Db_Table_Row_Abstract
   {
       protected function _insert()
       {
           $log = Zend_Registry::get('database_log');
           $log->info(Zend_Debug::dump($this->_data,
                                       "INSERT: $this->_tableClass",
                                       false)
                     );
       }
   }

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';
       protected $_rowClass = 'MyLoggingRow';
   }

   class Products extends Zend_Db_Table_Abstract
   {
       protected $_name = 'products';
       protected $_rowClass = 'MyLoggingRow';
   }

.. _zend.db.table.row.extending.inflection:

Inflection in Zend_Db_Table_Row einbauen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Manche Personen ziehen es vor, dass der Klassenname der Tabelle dem Tabellennamen in der *RDBMS* direkt entspricht,
indem eine String Transformation durchgeführt wird, die auch **Inflection** genannt wird.

``Zend_Db`` Klassen implementieren Inflection standardmäßig nicht. Siehe das Kapitel über die :ref:`Erweiterung
der Inflection <zend.db.table.extending.inflection>` für eine Erklärung diesr Richtlinie.

Wenn Inflection genutzt werden soll, dann muss die Manipulation selbst implementiert werden, indem die Methode
``_transformColumn()`` in einer eigenen Zeilenklasse überschrieben wird und Objekte dieser Klasse für Abfragen an
die Datenbank genutzt werden.

.. _zend.db.table.row.extending.inflection.example:

.. rubric:: Inflection-Methode definieren

Das definieren einer Methode für Inflection erlaubt es, inflection-ierte Versionen der Spaltenname (beispielsweise
vollständig in Großbuchstaben) als Zugriffsvariablen eines Zeilenobjekts zu benutzen. Die Zeilenklasse benutzt
die Methode ``_transformColumn()``, um den Namen, der als Zugriffsvariable genutzt wurde, wieder in den
ursprünglichen Spaltennamen in der Tabelle umzuwandeln.

.. code-block:: php
   :linenos:

   class MyInflectedRow extends Zend_Db_Table_Row_Abstract
   {
       protected function _transformColumn($columnName)
       {
           $nativeColumnName = meineEigeneInflectionFunktion($columnName);
           return $nativeColumnName;
       }
   }

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';
       protected $_rowClass = 'MyInflectedRow';
   }

   $bugs = new Bugs();
   $row = $bugs->fetchNew();

   // Benutzung von Spaltennamen im camelCase.
   // _transformColumn() wandelt den Spaltennamen wieder um.
   $row->bugDescription = 'New description';

Es liegt in der Verantwortung des Entwicklers, Funktionen für Inflection zu schreiben. Zend Framework bietet
solche Funktionen wie bereits erwähnt von Haus aus nicht an.



.. _`Row Data Gateway`: http://www.martinfowler.com/eaaCatalog/rowDataGateway.html
