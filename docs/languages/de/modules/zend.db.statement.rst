.. _zend.db.statement:

Zend_Db_Statement
=================

Zusätzlich zu den herkömmlichen Methoden wie ``fetchAll()`` und ``insert()``, beschrieben in
:ref:`Zend_Db_Adapter <zend.db.adapter>`, kann auch ein Statement-Objekt verwendet werden, um zusätzliche
Möglichkeiten beim Ausführen von Abfragen und holen von Ergebnissätzen zu erhalten. Dieser Abschnitt beschreibt
wie eine Instanz eines Statement-Objekts erzeugt wird, und wie dessen Methoden verwendet werden.

``Zend_Db_Statement`` basiert auf dem PDOStatement Objekt aus der `PHP Data Objects`_ Erweiterung.

.. _zend.db.statement.creating:

Erzeugung von Statement Objekten
--------------------------------

Normalerweise wird ein Statement Objekt von der ``query()`` Methode der Datenbank Adapterklasse zurück gegeben.
Diese Methode ist der grundsätzliche Weg um ein beliebiges *SQL* Statement vor zu bereiten. Das erste Argument ist
ein String, der das *SQL* Statement enthält. Das optionale zweite Argument ist ein Array von Werten, verknüpft
mit Parameterplatzhaltern im *SQL* String.

.. _zend.db.statement.creating.example1:

.. rubric:: Erzeugung eines SQL Statement Objekts mit query()

.. code-block:: php
   :linenos:

   $stmt = $db->query(
               'SELECT * FROM bugs WHERE reported_by = ? AND bug_status = ?',
               array('goofy', 'FIXED')
           );

Das Statement Objekt entspricht einem *SQL* Statement welches vorbereitet und einmalig mit angegebenen verknüpften
Werten ausgeführt wurde. War das Statement eine *SELECT* Abfrage, oder irgendein Statement welches ein
Ergebnissatz zurück gibt, so ist es nun bereit um Ergebnisse zu holen.

Ein Statement kann ebenfalls mit dem Konstruktor erzeugt werden, auch wenn dies eine weniger typische Nutzung ist.
Es existiert jedoch keine factory Methode um das Objekt zu erzeugen, weßhalb die entsprechende Statementklasse
geladen, und ihr Konstruktor aufgerufen werden muss. Als erstes Argument muss das Adapterobjekt übergeben werden
und als zweites Argument ein String welcher das *SQL* Statement enthält. Das Statement ist dadurch vorbereitet,
jedoch nicht Ausgeführt.

.. _zend.db.statement.creating.example2:

.. rubric:: Nutzung des SQL Statement Konstruktors

.. code-block:: php
   :linenos:

   $sql = 'SELECT * FROM bugs WHERE reported_by = ? AND bug_status = ?';

   $stmt = new Zend_Db_Statement_Mysqli($db, $sql);

.. _zend.db.statement.executing:

Ausführen eines Statements
--------------------------

Ein Statement Objekt muss ausgeführt werden wenn es über den Konstruktor erzeugt wurde, oder kann, wenn es
mehrere Male hintereinander ausgeführt werden soll. Dazu wird die ``execute()`` Methode des Statement Objekts
verwendet. Das einzige Argument ist ein Array von Werten, welche mit Parameterplatzhaltern im Statement verknüpft
werden.

Wenn **positionierte Parameter**, oder solche, die mit dem Fragezeichen ('**?**') verwendet werden, muss ein
einfaches Array übergeben werden.

.. _zend.db.statement.executing.example1:

.. rubric:: Ausführen eines Statements mit positionierten Parametern

.. code-block:: php
   :linenos:

   $sql = 'SELECT * FROM bugs WHERE reported_by = ? AND bug_status = ?';

   $stmt = new Zend_Db_Statement_Mysqli($db, $sql);

   $stmt->execute(array('goofy', 'FIXED'));

Wenn **benannte Parameter**, oder solche die mit einem String und voranstehenden Doppelpunkt ('**:**') bezeichnet
werden, verwendet werden, muss ein assoziatives Array übergeben werden. Die Schlüssel dieses Arrays müssen den
Parameternamen entsprechen.

.. _zend.db.statement.executing.example2:

.. rubric:: Ausführen eines Statements mit benannten Parametern

.. code-block:: php
   :linenos:

   $sql = 'SELECT * FROM bugs WHERE ' .
          'reported_by = :reporter AND bug_status = :status';

   $stmt = new Zend_Db_Statement_Mysqli($db, $sql);

   $stmt->execute(array(':reporter' => 'goofy', ':status' => 'FIXED'));

*PDO* Statements unterstützen sowohl postionierte als auch benannte Parameter, jedoch nicht beide Typen in einem
einzelnen *SQL* Statement. Einige der ``Zend_Db_Statement`` Klassen für nicht-PDO Erweiterungen könnten nur einen
Typ von Parametern unterstützen.

.. _zend.db.statement.fetching:

Holen von Ergebnissen eines SELECT Statements
---------------------------------------------

Es können Methoden des Statement Objekts aufgefufen werden um Zeilen von *SQL* Statements zu erhalten die
Ergebnissätze erzeugen. *SELECT*, *SHOW*, *DESCRIBE* und *EXPLAIN* sind Beispiele von von Statements die
Ergebnissätze erzeugen. *INSERT*, *UPDATE* und *DELETE* sind Beispiele von Statements die keine Ergebnissätze
erzeugen. Letztere *SQL* Statements können zwar mit ``Zend_Db_Statement`` ausgeführt werden, aber Methoden die
Zeilen oder Ergebnisse liefern können bei diesen nicht verwendet werden.

.. _zend.db.statement.fetching.fetch:

Holen einer einzelnen Zeile eines Ergebnissatzes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um eine einzelne Zeile eines Ergebnissatzes aubzurufen kann die ``fetch()`` Methode des Statement Objekts verwendet
werden. Alle drei Argumente dieser Methode sind optional:

- **Fetch Style** ist das erste Argument. Es steuert die Struktur in welcher die Zeile zurück gegeben wird. In
  :ref:`diesem Kapitel <zend.db.adapter.select.fetch-mode>` befindet sich eine Beschreibung der gültigen Werte und
  der entsprechenden Datenformaten.

- **Cursor Ausrichtung** ist das zweite Argument. Standard ist ``Zend_Db::FETCH_ORI_NEXT``, was einfach bedeutet
  das für jeden Aufruf von ``fetch()`` die nächste Zeile des Ergebnissatzes, in der Reihenfolge des *RDBMS*,
  zurück gegeben wird.

- **Offset** ist das dritte Argument. Wenn die Cursor Ausrichtung ``Zend_Db::FETCH_ORI_ABS`` ist, dann ist die
  Offset-Nummer die ordinale Nummer der Zeile die zurück gegeben wird. Wenn die Cursor Ausrichtung
  ``Zend_Db::FETCH_ORI_REL``, dann ist die Offset-Nummer relativ zu der Cursorposition bevor ``fetch()`` aufgerufen
  wurde.

``fetch()`` gibt ``FALSE`` zurück wenn alle Zeilen des Ergbnissatzes geholt wurden.

.. _zend.db.statement.fetching.fetch.example:

.. rubric:: Nutzung fetch() in einer Schleife

.. code-block:: php
   :linenos:

   $stmt = $db->query('SELECT * FROM bugs');

   while ($row = $stmt->fetch()) {
       echo $row['bug_description'];
   }

Weitere Informationen unter `PDOStatement::fetch()`_.

.. _zend.db.statement.fetching.fetchall:

Holen eines gesamten Ergebnissatzes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um alle Zeilen eines Ergebnissatzes in einem Schritt abzurufen wird die ``fetchAll()`` Methode verwendet. Dies ist
gleichbedeutend mit dem Aufruf der ``fetch()`` Methode in einer Schleife und dem Speichern der Rückgabewerte in
einem Array. Die ``fetchAll()`` Methode akzeptiert zwei Argumente. Das Erste ist der Fetch Style, wie oben
beschrieben, und das Zweite gibt die Nummer der zurück zu gebenden Spalte an, wenn der Fetch Style
``Zend_Db::FETCH_COLUMN`` ist.

.. _zend.db.statement.fetching.fetchall.example:

.. rubric:: Nutzung von fetchAll()

.. code-block:: php
   :linenos:

   $stmt = $db->query('SELECT * FROM bugs');

   $rows = $stmt->fetchAll();

   echo $rows[0]['bug_description'];

Weitere Informationen unter `PDOStatement::fetchAll()`_.

.. _zend.db.statement.fetching.fetch-mode:

Ändern des Fetch Modus
^^^^^^^^^^^^^^^^^^^^^^

Standardmäßig gibt das Statement Objekt Zeilen des Ergebnissatzes als assoziatives Array, mapping column names to
column values, zurück. Ein anderes Format für die Datenrückgabe der Statementklasse kann genau wie bei der
Adapterklasse angegeben werden. Die ``setFetchMode()`` Methode des Statement Objekts wird verwendet um den
Fetch-Modus anzugeben. Dazu werden die ``Zend_Db`` Klassen Konstanten ``FETCH_ASSOC``, ``FETCH_NUM``,
``FETCH_BOTH``, ``FETCH_COLUMN`` und ``FETCH_OBJ`` verwendet. Weiter Informationen über diese Modi gibt es in
:ref:`diesem Kapitel <zend.db.adapter.select.fetch-mode>`. Nachfolgende Aufrufe der Statement Methoden ``fetch()``
und ``fetchAll()`` benutzen den neu gesetzten Fetch-Modus.

.. _zend.db.statement.fetching.fetch-mode.example:

.. rubric:: Ändern des Fetch-Modus

.. code-block:: php
   :linenos:

   $stmt = $db->query('SELECT * FROM bugs');

   $stmt->setFetchMode(Zend_Db::FETCH_NUM);

   $rows = $stmt->fetchAll();

   echo $rows[0][0];

Weitere Informationen unter `PDOStatement::setFetchMode()`_.

.. _zend.db.statement.fetching.fetchcolumn:

Holen einer einzelnen Spalte eines Ergebnissatzes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``fetchColumn()`` wird verwendet mm eine einzelne Spalte eines Ergebnissatzes zurück zu geben. Das optionale
Argument ist der Integer Index der Spalte die zurück gegeben werden soll. Der Standardwert ist 0. Diese Methode
gibt einen scalaren Wert zurück, oder ``FALSE`` wenn alle Zeilen des Ergebnissatzes bereits geholt wurden.

Zu beachten ist, dass diese Methode anders als die ``fetchCol()`` Methode der Adapterklasse arbeitet. Die
``fetchColumn()`` Methode der Statementklasse gibt einen einzelnen Wert einer Zeile zurück. Die ``fetchCol()``
Methode der Adapterklasse hingegen gibt ein Array von Werten der ersten Spalte aller Zeilen eines Ergebnissatzes
zurück.

.. _zend.db.statement.fetching.fetchcolumn.example:

.. rubric:: Nutzung von fetchColumn()

.. code-block:: php
   :linenos:

   $stmt = $db->query('SELECT bug_id, bug_description, bug_status FROM bugs');

   $bug_status = $stmt->fetchColumn(2);

Weitere Informationen unter `PDOStatement::fetchColumn()`_.

.. _zend.db.statement.fetching.fetchobject:

Holen einer Zeile als Objekt
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um eine Zeile eines Ergebnissatzes zu holen, die wie ein Objekt strukturiert ist, wird die ``fetchObject()``
Methode verwendet. Diese Methode nimmt zwei optionale Argumente entgegen. Das erste Argument ist ein String der den
Klassenname des zurück zu gebenden Objekts enthält, standard ist 'stdClass'. Das zweite Argument ist ein Array
von Werten, die an den Konstruktor des Objekts übergeben werden.

.. _zend.db.statement.fetching.fetchobject.example:

.. rubric:: Nutzung von fetchObject()

.. code-block:: php
   :linenos:

   $stmt = $db->query('SELECT bug_id, bug_description, bug_status FROM bugs');

   $obj = $stmt->fetchObject();

   echo $obj->bug_description;

Weitere Informationen unter `PDOStatement::fetchObject()`_.



.. _`PHP Data Objects`: http://www.php.net/pdo
.. _`PDOStatement::fetch()`: http://www.php.net/PDOStatement-fetch
.. _`PDOStatement::fetchAll()`: http://www.php.net/PDOStatement-fetchAll
.. _`PDOStatement::setFetchMode()`: http://www.php.net/PDOStatement-setFetchMode
.. _`PDOStatement::fetchColumn()`: http://www.php.net/PDOStatement-fetchColumn
.. _`PDOStatement::fetchObject()`: http://www.php.net/PDOStatement-fetchObject
