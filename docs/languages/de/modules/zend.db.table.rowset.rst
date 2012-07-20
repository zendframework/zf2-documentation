.. _zend.db.table.rowset:

Zend_Db_Table_Rowset
====================

.. _zend.db.table.rowset.introduction:

Einführung
----------

Wenn eine Datenbankabfrage über eine Tabellenklasse ausgeführt wird, genauer über deren Methoden ``find()`` und
``fetchAll()``, wird das Ergebnis als Objekt vom Typ ``Zend_Db_Table_Rowset_Abstract`` zurückgegeben. Ein
Zeilensatz enthält eine Sammlung von Objekten die von ``Zend_Db_Table_Row_Abstract`` abgeleitet sind. Man kann
durch das Rowset iterieren und auf individuelle Zeilen Objekte zugreifen, sowie Daten in Zeilen lesen und
modifizieren.

.. _zend.db.table.rowset.fetch:

Einen Zeilensatz lesen
----------------------

``Zend_Db_Table_Abstract`` bietet die Methoden ``find()`` und ``fetchAll()``, die beide ein Objekt vom Typ
``Zend_Db_Table_Rowset_Abstract`` zurückgeben.

.. _zend.db.table.rowset.fetch.example:

.. rubric:: Einen Zeilensatz lesen

.. code-block:: php
   :linenos:

   $bugs   = new Bugs();
   $rowset = $bugs->fetchAll("bug_status = 'NEW'");

.. _zend.db.table.rowset.rows:

Zeilen aus einem Zeilensatz auslesen
------------------------------------

Der Zeilensatz selber ist normalerweise weniger interessant als die Zeilen, die er enthält. Dieser Abschnitt
zeigt, wie die Zeilen, die im Zeilensatz enthalten sind, auslesbar sind.

Eine normale Abfrage gibt null Zeilen zurück, wenn keine Zeilen in der Datenbank die Bedingungen der Abfrage
erfüllt. Daher kann eine Zeilensatz-Objekt auch null Zeilenobjekte enthalten. Weil
``Zend_Db_Table_Rowset_Abstract`` auch das Interface ``Countable`` (dt.: Zählbar) implementiert, kann die Funktion
``count()`` genutzt werden, um die Anzahl der Zeilen im Zeilensatz zu erhalten.

.. _zend.db.table.rowset.rows.counting.example:

.. rubric:: Zeilen in einem Zeilensatz zählen

.. code-block:: php
   :linenos:

   $rowset   = $bugs->fetchAll("bug_status = 'FIXED'");

   $rowCount = count($rowset);

   if ($rowCount > 0) {
       echo "$rowCount Zeilen gefunden!";
   } else {
       echo 'keine Zeilen für die Abfrage gefunden.';
   }

.. _zend.db.table.rowset.rows.current.example:

.. rubric:: Eine einzelne Zeile aus einem Zeilensatz auslesen

Die einfachste Art, eine Zeile aus einem Zeilensatz auszulesen, ist die Methode ``current()``. Diese ist vor allem
dann nützlich, wenn der Zeilensatz genau eine Zeile enthält.

.. code-block:: php
   :linenos:

   $bugs   = new Bugs();
   $rowset = $bugs->fetchAll("bug_id = 1");
   $row    = $rowset->current();

Wenn der Zeilensatz keine Zeilen enthält, gibt ``current()`` den *PHP* Wert ``NULL`` zurück.

.. _zend.db.table.rowset.rows.iterate.example:

.. rubric:: Einen Zeilensatz durchlaufen

Objekte, die von ``Zend_Db_Table_Rowset_Abstract`` abstammen, implementieren das ``SeekableIterator`` Interface,
was bedeutet, dass es mit ``foreach()`` durchlaufen werden kann. Jeder Wert, der auf diesem Weg zurückgegeben
wird, ist ein ``Zend_Db_Table_Row_Abstract``-Objekt, das zu einem Eintrag in der Tabelle gehört.

.. code-block:: php
   :linenos:

   $bugs = new Bugs();

   // Alle Zeilen aus der Tabelle lesen
   $rowset = $bugs->fetchAll();

   foreach ($rowset as $row) {

       // Ausgabe: 'Zend_Db_Table_Row' oder ähnlich,
       // je nach benutzter Zeilenklasse
       echo get_class($row) . "\n";

       // Spalte einer Zeile auslesen
       $status = $row->bug_status;

       // eine Spalte der aktuellen Zeile modifizieren
       $row->assigned_to = 'mmouse';

       // Änderung in der Datenbank speichern
       $row->save();
   }

.. _zend.db.table.rowset.rows.seek.example:

.. rubric:: Eine bekannte Position in einem Rowset suchen

``SeekableIterator`` erlaubt es eine Position zu suchen auf die der Iterator springen soll. Hierfür kann einfach
die ``seek()`` Methode verwendet werden. Es kann ein Integer übergeben werden die der Nummer der Zeile
repräsentiert auf die das Rowset als nächstes zeigen soll, wobei man nicht vergessen sollte das der Index mit 0
beginnt. Wenn der Index falsch ist, z.b. nicht existiert, wird eine Ausnahme geworfen. Man sollte ``count()``
verwenden um die Anzahl an Ergebnissen zu prüfen bevor eine Position gesucht wird.

.. code-block:: php
   :linenos:

   $bugs = new Bugs();

   // Alle Einträge von der Tabelle holen
   $rowset = $bugs->fetchAll();

   // Den Iterator zum 9ten Element bringen (null ist das erste Element) :
   $rowset->seek(8);

   // es empfangen
   $row9 = $rowset->current();

   // und es verwenden
   $row9->assigned_to = 'mmouse';
   $row9->save();

``getRow()`` erlaubt es eine spezielle Zeile im Rowset zu erhalten wenn dessen Position bekannt ist; trotzdem
sollte nicht vergessen werden dass die Position mit dem Index Null beginnt. Der erste Parameter für ``getRow()``
ist ein Integer für die gewünschte Position. Der zweite optionale Parameter ist ein Boolean; Es teilt dem Rowset
Iterator mit ob er zur gleichen Zeit diese Position suchen muss, oder nicht (standard ist ``FALSE``). Diese Methode
gibt standardmäßig ein ``Zend_Db_Table_Row`` Objekt zurück. Wenn die angefragte Position nicht existiert wird
eine Ausnahme geworfen. Hier ist ein Beispiel:

.. code-block:: php
   :linenos:

   $bugs = new Bugs();

   // Alle Einträge von der Tabelle holen
   $rowset = $bugs->fetchAll();

   // Sofort das 9te Element holen:
   $row9->getRow(8);

   // und es verwenden:
   $row9->assigned_to = 'mmouse';
   $row9->save();

Sobald der Zugriff auf ein Zeilenobjekt besteht, kann dieses mit den Methoden manipuliert werden, die in
:ref:`Zend_Db_Table_Row <zend.db.table.row>` beschrieben werden.

.. _zend.db.table.rowset.to-array:

Einen Zeilensatz als Array lesen
--------------------------------

Auf die gesamten Daten in einem Zeilensatz kann mithilfe der Methode ``toArray()`` des Zeilensatz-Objekts auch als
Array zugegriffen werden. Diese Methode gibt ein Array mit einem Eintrag je Zeile zurück. Jeder dieser Einträge
ist ein assoziatives Array mit Spaltennamen als Schlüsseln und deren Daten als Werten.

.. _zend.db.table.rowset.to-array.example:

.. rubric:: Benutzung von toArray()

.. code-block:: php
   :linenos:

   $bugs   = new Bugs();
   $rowset = $bugs->fetchAll();

   $rowsetArray = $rowset->toArray();

   $rowCount = 1;
   foreach ($rowsetArray as $rowArray) {
       echo "Zeile #$rowCount:\n";
       foreach ($rowArray as $column => $value) {
           echo "\t$column => $value\n";
       }
       ++$rowCount;
       echo "\n";
   }

Das Array, das von ``toArray()``\ zurückgegeben wird, ist nicht update-fähig. Die Werte des Arrays können wie
bei jedem Array modifiziert werden, aber Änderungen an diesem Array werden nicht direkt in der Datenbank
gespeichert.

.. _zend.db.table.rowset.serialize:

Einen Zeilensatz serialisieren / deserialisieren
------------------------------------------------

Objekte vom Typ ``Zend_Db_Table_Rowset_Abstract`` sind serialisierbar auf eine ähnliche Art, wie auch einzelne
Zeilen-Objekte serialisierbar und deserialisierbar sind.

.. _zend.db.table.rowset.serialize.example.serialize:

.. rubric:: Einen Zeilensatz serialisieren

*PHP*\ s ``serialize()``-Funktion wird genutzt, um einen Byte-Stream zu erzeugen. Dieser repräsentiert das
Zeilensatz-Objekt.

.. code-block:: php
   :linenos:

   $bugs   = new Bugs();
   $rowset = $bugs->fetchAll();

   // Objekt serialisieren
   $serializedRowset = serialize($rowset);

   // Jetzt kann $serializedRowset bspw.
   // in einer Datei gespeichert werden

.. _zend.db.table.rowset.serialize.example.unserialize:

.. rubric:: Einen Zeilensatz deserialisieren

*PHP*\ s ``unserialize()`` stellt aus einer Zeichenkette mit einem Byte-Stream ein Objekt wieder her. Die Funktion
gibt das originale Objekt zurück.

Bitte beachten: Das zurückgegebene Zeilensatz-Objekt ist **nicht mit der Datenbank verbunden**. Das
Zeilensatz-Objekt kann durchlaufen werden und die Zeilenobjekte können gelesen werden, aber es können keine
Zeilenwerte verändert oder andere Operationen ausgeführt werden, die eine Datenbankverbindung benötigen
(beispielsweise Abfragen auf verwandte Tabellen).

.. code-block:: php
   :linenos:

   $rowsetDisconnected = unserialize($serializedRowset);

   // Jetzt können Objekt-Methoden und -Eigenschaften genutzt werden,
   // aber nur lesend.
   $row = $rowsetDisconnected->current();
   echo $row->bug_description;

.. note::

   **Warum werden Zeilensatz-Objekte unverbunden deserialisiert?**

   Ein serialisiertes Objekt ist eine Zeichenkette, die lesbar für jeden ist, dem sie vorliegt. Es könnte ein
   Sicherheitsrisiko sein, Parameter wie Datenbank-Loginname und -Passwort in simplem, unverschlüsseltem Text
   abzulegen. Es ist nicht wünschenswert, solche Daten in einer Textdatei abzulegen, die nicht geschützt ist,
   oder sie in einer E-Mail oder einem anderen Medium zu versenden, das leicht von potentiellen Angreifern lesbar
   ist. Der Leser des serialisierten Objekts sollte es nicht benutzen können, um Zugriff zur Datenbank zu
   erhalten, ohne richtige Logindaten zu kennen.

Ein nicht verbundenes Zeilensatz-Objekt kann mithilfe der Methode ``setTable()`` reaktiviert werden. Das Argument
dieser Methode ist ein valides ``Zend_Db_Table_Abstract``-Objekt, das vom Benutzer erstellt wird. Für das
Erstellen eines Tabellenobjekts wird eine aktive Datenbankverbindung benötigt, also wird, indem die Tabelle wieder
mit dem Zeilenobjekt verknüpft wird, auch der Datenbankzugriff wiederhergestellt. Ab diesem Zeitpunkt können
Werte in den enthaltenen Zeilenobjekten wieder verändert und in der Datenbank gespeichert werden.

.. _zend.db.table.rowset.serialize.example.set-table:

.. rubric:: Einen Zeilensatz als Live-Daten reaktivieren

.. code-block:: php
   :linenos:

   $rowset = unserialize($serializedRowset);

   $bugs = new Bugs();

   // Den Zeilensatz wieder mit einer Tabelle
   // und damit mit einer aktiven Datenbankverbindung verknüpfen
   $rowset->setTable($bugs);

   $row = $rowset->current();

   // Jetzt können wieder Werte geändert und danach gespeichert werden
   $row->bug_status = 'FIXED';
   $row->save();

Wenn ein Zeilensatz mit ``setTable()`` reaktiviert wird, reaktiviert das auch alle enthaltenen Zeilen-Objekte.

.. _zend.db.table.rowset.extending:

Die Zeilensatz-Klasse erweitern
-------------------------------

Es können auch alternative Klassen für Zeilensätze benutzt werden, wenn diese ``Zend_Db_Table_Rowset_Abstract``
erweitern. Der Name der eigenen Zeilensatz-Klasse wird entweder in der geschützten Tabellenklassen-Eigenschaft
``$_rowsetClass`` oder als Teil des Array-Arguments des Konstruktors eines Tabellenobjekts übergeben.

.. _zend.db.table.rowset.extending.example:

.. rubric:: Eine eigene Zeilensatz-Klasse angeben

.. code-block:: php
   :linenos:

   class MyRowset extends Zend_Db_Table_Rowset_Abstract
   {
       // ...Anpassungen
   }

   // Eine eigene Zeilensatz-Klasse angeben, die standardmäßig
   // in allen Instanzen der Tabellenklasse benutzt wird.
   class Products extends Zend_Db_Table_Abstract
   {
       protected $_name = 'products';
       protected $_rowsetClass = 'MyRowset';
   }

   // Oder eine eigene Zeilensatz-Klasse angeben, die in einer
   // Instanz einer Tabellenklasse benutzt wird
   $bugs = new Bugs(array('rowsetClass' => 'MyRowset'));

Typischerweise reicht die Standardklasse ``Zend_Db_Rowset`` für die meisten Benutzungsfälle aus. Trotzdem könnte
es nützlich sein, neue Logik in einen Zeilensatz einzubauen, die für eine bestimmte Tabelle nötig ist.
Beispielsweise könnte eine neue Methode einen Durchschnitt aller Zeilen im Zeilensatz errechnen.

.. _zend.db.table.rowset.extending.example-aggregate:

.. rubric:: Eine Zeilensatz-Klasse mit einer neuen Methode

.. code-block:: php
   :linenos:

   class MyBugsRowset extends Zend_Db_Table_Rowset_Abstract
   {
       /**
        * Suche nach der Zeile im Zeilensatz, deren
        * 'updated_at'-Spalte den größten Wert hat.
        */
       public function getLatestUpdatedRow()
       {
           $max_updated_at = 0;
           $latestRow = null;
           foreach ($this as $row) {
               if ($row->updated_at > $max_updated_at) {
                   $latestRow = $row;
               }
           }
           return $latestRow;
       }
   }

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';
       protected $_rowsetClass = 'MyBugsRowset';
   }


