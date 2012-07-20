.. _zend.db.select:

Zend_Db_Select
==============

.. _zend.db.select.introduction:

Einführung
----------

Das ``Zend_Db_Select`` Objekt repräsentiert ein *SQL* *SELECT* Anfrage Statement. Die Klasse bietet Methoden um
einzelne Teile der Anfrage hinzuzufügen. Einzelne Teile der Anfrage können mit Hilfe von *PHP* Methoden und
Datenstrukturen angegeben werden, und die Klasse erzeugt korrekte *SQL* Syntax. Nachdem die Anfrage formuliert
wurde kann sie ausgeführt werden als wäre sie mit einem normalen String geschrieben worden.

``Zend_Db_Select`` bietet folgenden Nutzen:

- Objekt Orientierte Methoden um *SQL* Anfragen Stück für Stück zu formulieren.

- Datenbank unabhängige Abstraktion einiger Teile der *SQL* Anfrage.

- In den meisten Fällen automatische Quotierung von Metadaten um Bezeichner zu unterstützen welche reservierte
  *SQL* Wörter und spezielle Zeichen enthalten.

- Quotierung von Bezeichnern und Werten um dabei zu helfen das Risiko von *SQL* Injektion Attacken zu reduzieren.

Nutzung von ``Zend_Db_Select`` ist nicht zwingend erforderlich. Für einfache *SELECT* Anfragen ist es
normalerweise einfacher die gesamte *SQL* Anfrage in einem String zu formulieren und mit Hilfe der Methoden der
Adapterklasse, wie ``query()`` oder ``fetchAll()``, auszuführen. Die Nutzung von ``Zend_Db_Select`` ist hilfreich
wenn eine *SELECT* Anfrage prozedural oder basierend auf der konditionellen Logik der Anwendung zusammengesetzt
wird.

.. _zend.db.select.creating:

Erzeugung eines Select Objekts
------------------------------

Die Instanz eines ``Zend_Db_Select`` Objekts kann mit Hilfe der ``select()`` Methode des
``Zend_Db_Adapter_Abstract`` Objekts erzeugt werden.

.. _zend.db.select.creating.example-db:

.. rubric:: Beispiel für die Nutzung der select() Methode der Datenbankadapterklasse

.. code-block:: php
   :linenos:

   $db = Zend_Db::factory( ...Optionen... );
   $select = $db->select();

Ein anderer Weg ein ``Zend_Db_Select`` Objekt zu erzeugen ist die Nutzung des Konstruktors unter Angabe des
Datenbankadapters als Argument.

.. _zend.db.select.creating.example-new:

.. rubric:: Beispiel für die Erzeugung eines Select Objektes

.. code-block:: php
   :linenos:

   $db = Zend_Db::factory( ...Optionen... );
   $select = new Zend_Db_Select($db);

.. _zend.db.select.building:

Erstellung von Select Anfragen
------------------------------

Wenn die Anfrage erstellt wird können Bedingungen der Anfrage nacheinander hinzugefügt werden. Es gibt eine
separate Methode für das Hinzufügen von verschiedenen Bedingungen zum ``Zend_Db_Select`` Objekt.

.. _zend.db.select.building.example:

.. rubric:: Beispiele für die Nutzung der Methoden zum Hinzufügen von Bedingungen

.. code-block:: php
   :linenos:

   // Erzeugung des Zend_Db_Select Objekts
   $select = $db->select();

   // Hinzufügen einer FROM Bedingung
   $select->from( ...Angabe von Tabelle und Spalten... )

   // Hinzufügen einer WHERE Bedingung
   $select->where( ...Angabe von Suchkriterien... )

   // Hinzufügen einer ORDER BY Bedingung
   $select->order( ...Angabe von Sortierkriterien... );

Die meisten Methoden des ``Zend_Db_Select`` Objekts lassen sich auch über das bequeme Fluent Interface nutzen.
Fluent Interface bedeutet das jede Methode eine Referenz auf das aufrufende Objekt zurück gibt, daher kann direkt
eine andere Methode aufgerufen werden.

.. _zend.db.select.building.example-fluent:

.. rubric:: Beispiel für die Nutzung der flüssigen Schnittstelle

.. code-block:: php
   :linenos:

   $select = $db->select()
       ->from( ...Angabe von Tabelle und Spalten... )
       ->where( ...Angabe von Suchkriterien... )
       ->order( ...Angabe von Sortierkriterien... );

Die Beispiele in diesem Abschnitt zeigen die Nutzung des Fluent Interface, es kann aber auch immer das normale
Interface verwendet werden. Häufig ist es nötig das normale Interface zu nutzen, zum Beispiel wenn die Anwendung
vor dem Hinzufügen der Bedingung Berechnungen durchführen muss.

.. _zend.db.select.building.from:

Hinzufügen eines FROM Abschnitts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um die Tabelle für die Anfrage an zu geben wird die ``from()`` Methode verwendet. Der Tabellenname kann als
einfacher String übergeben werden. ``Zend_Db_Select`` wendet Bezeichner Quotierung an, es können also auch
spezielle Zeichen verwendet werden.

.. _zend.db.select.building.from.example:

.. rubric:: Beispiel für die from() Methode

.. code-block:: php
   :linenos:

   // Erstellen dieser Anfrage:
   //   SELECT *
   //   FROM "products"

   $select = $db->select()
                ->from( 'products' );

Es kann auch der Beziehungsname (auch Aliasname genannt) einer Tabelle angegeben werden. Anstelle eines einfachen
Strings muss dann ein assoziatives Array übergeben werden, welches den Beziehungsnamen dem tatsächlichen
Tabellennamen zuordnet. In anderen Bedingungen der *SQL* Anfrage kann dann dieser Beziehungsname verwendet werden.
Wenn die Anfrage mehr als eine Tabelle verbindet, generiert ``Zend_Db_Select`` eindeutige Beziehungsnamen basierend
auf den Tabellennamen, wenn keine Beziehungsnamen angegeben wurden.

.. _zend.db.select.building.from.example-cname:

.. rubric:: Beispiel für das Angeben eines Beziehungsnamens

.. code-block:: php
   :linenos:

   // Erzeugt diese Anfrage:
   //   SELECT p.*
   //   FROM "products" AS p

   $select = $db->select()
                ->from( array('p' => 'products') );

Einige *RDBMS* Marken unterstützen einen voran stehenden Schemenbezeichner für eine Tabelle. Der Tabellenname
kann mit "``schemaName.tabellenName``" angegeben werden, ``Zend_Db_Select`` Quotiert die einzelnen Teile für sich.
Der Schemaname kann aber auch separat angegeben werden. Ein Schemaname, der mit dem Tabellennamen angegeben wurde
bekommt Vorrang, falls beides angegeben wurde.

.. _zend.db.select.building.from.example-schema:

.. rubric:: Beispiel für das Angeben eines Schemanamens

.. code-block:: php
   :linenos:

   // Erzeut diese Anfrage:
   //   SELECT *
   //   FROM "myschema"."products"

   $select = $db->select()
                ->from( 'myschema.products' );

   // oder

   $select = $db->select()
                ->from('products', '*', 'myschema');

.. _zend.db.select.building.columns:

Hinzufügen von Spalten
^^^^^^^^^^^^^^^^^^^^^^

Im zweiten Argument der ``from()`` Methode kann angegeben werden, welche Spalten der Tabelle ausgelesen werden
sollen. Werden keine Spalten angegeben, so gilt der Standardwert *****, der *SQL* Platzhalter für alle Spalten.

Die Spalten können in einem einfachen Array von Strings oder einem assoziativen Array, in dem Aliasnamen den
Spaltennamen zugewiesen werden, angegeben werden. Soll nur eine einzelne Spalte ohne Aliasnamen ausgelesen werden,
so kann auch ein einfacher String übergeben werden.

Wird ein leeres Array übergeben, so werden auch keine Spalten der Tabelle in den Ergebnissatz aufgenommen. Ein
Codebeispiel gibt es unter :ref:`code example <zend.db.select.building.join.example-no-columns>` bei der ``join()``
Methode.

Der Spaltenname kann mit "``beziehungsName.spaltenName``" angegeben werden. ``Zend_Db_Select`` Quotiert die
einzelnen Teile für sich. Wird kein Beziehungsname für die Spalte angegeben, dann wird der Beziehungsname der
Tabelle der aktuellen ``from()`` Methode verwendet.

.. _zend.db.select.building.columns.example:

.. rubric:: Beispiele für das Angeben von Spalten

.. code-block:: php
   :linenos:

   // Erzeugt diese Anfrage:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'product_name'));

   // Erzeugt dieselbe Anfrage, Angabe von Beziehungsnamen:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('p.product_id', 'p.product_name'));

   // Erzeugt diese Anfrage mit einem Alias für eine Spalte:
   //   SELECT p."product_id" AS prodno, p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('prodno' => 'product_id', 'product_name'));

.. _zend.db.select.building.columns-expr:

Hinzufügen von Spalten mit Expressions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Spalten in einer *SQL* Anfrage sind manchmal Expressions, keine einfachen Spaltennamen einer Tabelle. Expressions
dürfen keine Beziehungsnamen oder Quotierungen bekommen. Wenn der Spaltenstring runde Klammern enthält erkennt
``Zend_Db_Select`` dies als eine Expression.

Es kann auch ein Objekt des Typs ``Zend_Db_Expr`` erzeugt werden um zu verhindern das ein String wie ein
Spaltenname behandelt wird. ``Zend_Db_Expr`` ist eine Minimalklasse die einen String enthält. ``Zend_Db_Select``
erkennt Objekte des Typs ``Zend_Db_Expr`` und konvertiert diese in Strings, nimmt aber keine Änderungen daran vor,
wie Quotierung oder Beziehungsnamen.

.. note::

   Benutzung von ``Zend_Db_Expr`` für Spaltennamen ist nicht nötig wenn Spaltennamen Expressions runde Klammern
   enthalten. ``Zend_Db_Select`` erkennt diese und behandelt den String als eine Expression und lässt Quotierung
   und Beziehungsnamen aus.

.. _zend.db.select.building.columns-expr.example:

.. rubric:: Beispiel für das angeben von Spaltennamen, die Expressions enthalten

.. code-block:: php
   :linenos:

   // Erzeugt diese Anfrage:
   //   SELECT p."product_id", LOWER(product_name)
   //   FROM "products" AS p
   // Eine Expression eingeschlossen von runden Klammern wird zu Zend_Db_Expr.

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'LOWER(product_name)'));

   // Erzeugt diese Anfrage:
   //   SELECT p."product_id", (p.cost * 1.08) AS cost_plus_tax
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id',
                             'cost_plus_tax' => '(p.cost * 1.08)'));

   // Erzeugt diese Anfrage unter ausdrücklicher Verwendung  von Zend_Db_Expr:
   //   SELECT p."product_id", p.cost * 1.08 AS cost_plus_tax
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id',
                             'cost_plus_tax' =>
                                 new Zend_Db_Expr('p.cost * 1.08'))
                       );

In den oben stehenden Fällen ändern ``Zend_Db_Select`` den String nicht mit Beziehungsnamen oder
Bezeichnerquotierung. Wenn diese Änderungen notwendig sein sollten um doppeldeutigkeiten auf zu lösen, muss dies
manuell am String geändert werden.

Wenn die Spaltennamen aus *SQL* Schlüsselwörtern besteht oder spezielle Zeichen enthält sollte die
``quoteIdentifier()`` Methode verwendet werden und der Rückgabewert in den String eingefügt werden. Die
``quoteIdentifier()`` Methode verwendet *SQL* Quotierung um Bezeichner abzugrenzen, wodurch klar wird, das es sich
um einen Bezeichner für eine Tabelle oder Spalte handelt, und nicht um einem anderen Teil der *SQL* Syntax.

Der Code wird Datenbank unabhängiger wenn die ``quoteIdentifier()`` Methode anstelle von direkter Eingabe der
Quotierungszeichen verwendet wird, da einige *RDBMS* Marken nicht-Standard Symbole für die Quotierung von
Bezeichnern verwenden. Die ``quoteIdentifier()`` Methode wählt die passenden Quotierungssymbole für den
Adaptertyp aus. Die ``quoteIdentifier()`` Methode ersetzt außerdem alle Quotierungszeichen innerhalb des
Bezeichners.

.. _zend.db.select.building.columns-quoteid.example:

.. rubric:: Beispiel für die Quotierung von Spalten in einer Expression

.. code-block:: php
   :linenos:

   // Erzeugt folgende Anfrage und Quotiert dabei einen Spaltennamen
   // "from" in der Expression:
   //   SELECT p."from" + 10 AS origin
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('origin' =>
                             '(p.' . $db->quoteIdentifier('from') . ' + 10)')
                      );

.. _zend.db.select.building.columns-atomic:

Spalten zu einer existierenden FROM oder JOIN Tabelle hinzufügen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Es kann Fälle geben wo es gewünscht ist Spalten zu einer bestehenden *FROM* oder *JOIN* Tabelle hinzuzufügen
nachdem diese Methoden aufgerufen wurde. Die ``columns()`` Methode erlaubt es spezifische Spalten an jedem Punkt
hinzuzufügen bevor die Abfrage aufgeführt wird. Die Spalte kann entweder als String oder ``Zend_Db_Expr`` oder
als Array dieser Elemente angegeben werden. Das zweite Argument dieser Methode kann unterdrückt werden, was
impliziert das die Spalten zu der *FROM* Tabelle hinzugefügt werden sollen, andernfall muß ein bestehender
Korrelationsname verwendet werden.

.. _zend.db.select.building.columns-atomic.example:

.. rubric:: Beispiel für das Hinzufügen von Spalten mit der columns() Methode

.. code-block:: php
   :linenos:

   // Diese Abfrage bauen:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'), 'product_id')
                ->columns('product_name');

   // Die selbe Abfrage bauen, durch spezifizierung der Korrelationsnamen:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'), 'p.product_id')
                ->columns('product_name', 'p');
                // Alternativ kann columns('p.product_name') verwendet werden

.. _zend.db.select.building.join:

Hinzufügen einer weiteren Tabelle zu der Anfrage mit JOIN
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Viele nützliche Anfragen benötigen ein *JOIN* um mehrere Spalten verschiedener Tabellen miteinander zu
kombinieren. Tabellen können zu einer ``Zend_Db_Select`` Anfrage mit der ``join()`` Methode hinzugefügt werden.
Die Nutzung dieser Methode ist ähnlich der ``from()`` Methode, außer das in den meisten Fällen zusätzlich eine
Join Bedingung angegeben werden kann.

.. _zend.db.select.building.join.example:

.. rubric:: Beispiel für die join() Methode

.. code-block:: php
   :linenos:

   // Erzeugt diese Anfrage:
   //   SELECT p."product_id", p."product_name", l.*
   //   FROM "products" AS p JOIN "line_items" AS l
   //     ON p.product_id = l.product_id

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'product_name'))
                ->join(array('l' => 'line_items'),
                       'p.product_id = l.product_id');

Das zweite Argument der ``join()`` Methode ist ein String mit der Join Bedingung. Dies ist eine Exspression die
Kriterien angibt, welche Zeilen in der einen Tabelle mit Zeilen einer anderen Tabelle verknüpft werden. Es können
Beziehungsnamen in dieser Expression verwendet werden.

.. note::

   Es wird keine Quotierung auf die Expression für die Join Bedingung angewendet. Werden Spaltennamen verwendet,
   welche Quotierung benötigen, so muss ``quoteIdentifier()`` verwendet werden wenn der String für die Join
   Bedingung formuliert wird.

Das dritte Argument für ``join()`` ist ein Array von Spaltennahmen, entsprechend des Arrays der ``from()``
Methode. Der Standard ist ebenfalls "*****" und unterstützt Beziehungsnamen, Expressions und ``Zend_Db_Expr`` in
der gleichen Weise wie dem Array von Spaltennamen der ``from()`` Methode.

Wenn keine Spalten einer Tabelle ausgewählt werden soll muss ein leeres Array für die Liste der Spaltennamen
übergeben werden. Diese Nutzung funktioniert ebenfalls in der ``from()`` Methode, aber normalerweise werden einige
Spalten der primären Tabelle in den Anfragen benötigt, während möglicherweise keine Spalten der verbundenen
Tabelle ausgewählt werden sollen.

.. _zend.db.select.building.join.example-no-columns:

.. rubric:: Beispiel für das Angeben keiner Spalten

.. code-block:: php
   :linenos:

   // Erzeugt diese Anfrage:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p JOIN "line_items" AS l
   //     ON p.product_id = l.product_id

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'product_name'))
                ->join(array('l' => 'line_items'),
                       'p.product_id = l.product_id',
                       array() ); // leere Liste von Spalten

Zu beachten ist das leere ``array()`` in dem oben stehenden Beispiel, am Stelle einer Liste von Spalten der
verbundenen Tabelle.

*SQL* kennt verschiedene Typen von Joins. In der unten stehen Liste sind Methoden zu finden, für die verschiedenen
Join Typen die ``Zend_Db_Select`` unterstützt.

- ``INNER JOIN`` mit den ``join(tabelle, join, [spalten])`` oder ``joinInner(tabelle, join, [spalten])`` Methoden.

  Dies wird der gebräuchlichste Typ von Join sein. Zeilen jeder Tabelle werden mit Hilfe der angegebenen Join
  Bedingung verglichen. Der Ergebnissatz enthält nur die Zeilen die der Join Bedingungen entsprechen. Der
  Ergebnissatz kann leer sein, wenn keine Zeile die Bedingung erfüllt.

  Alle *RDBMS* Marken unterstützen diesen Join Typ.

- ``LEFT JOIN`` mit der ``joinLeft(tabelle, bedingung, [spalten])`` Methode.

  Alle Zeilen der links vom Operanden stehenden Tabelle sind enthalten, passende Zeilen der rechts stehenden
  Tabelle sind ebenfalls enthalten. Die Spalten der rechts stehenden Tabelle werden mit ``NULL`` aufgefüllt, wenn
  keine zu der linken Tabelle passenden Zeilen existieren.

  Alle *RDBMS* Marken unterstützen diesen Join Typ.

- ``RIGHT JOIN`` mit der ``joinRight(tabelle, bedingung, [spalten])`` Methode.

  Right Outer Join ist das Gegenstück zu Left Outer Join. Alle Zeilen der rechts vom Operanden stehenden Tabelle
  sind enthalten, passende Zeilen der links stehenden Tabelle sind ebenfalls enthalten. Die Spalten der links
  stehenden Tabelle werden mit ``NULL`` aufgefüllt, wenn keine zu der rechten Tabelle passenden Zeilen existieren.

  Einige *RDBMS* Marken unterstützen diesen Join Typ nicht, aber grundsätzlich kann jeder Right Join durch einen
  Left Join mit umgekehrter Sortierung der Tabellen dargestellt werden.

- ``FULL JOIN`` mit der ``joinFull(tabelle, bedingung, [spalten])`` Methode.

  Ein Full Outer Join ist wie eine Kombination eines Left Outer Join mit einem Right Outer Join. Alle Zeilen beider
  Tabellen sind enthalten, gepaart miteinander in der gleichen Zeile des Ergebnissatzes wenn die Join Bedingung
  erfüllt wird, oder wenn nicht, mit ``NULL``'s an Stelle der Spalten der anderen Tabelle.

  Einige *RDBMS* Marken unterstützen diesen Join Typ nicht.

- ``CROSS JOIN`` mit der ``joinCross(tabelle, [spalten])`` Methode.

  Ein Cross Join ist ein Kartesisches Produkt. Jede Zeile der ersten Tabelle wird mit jeder Zeile der zweiten
  Tabelle verbunden. Daher ist die Anzahl der Zeilen im Ergebnissatz gleich dem Produkt der Zeilenanzahlen der
  beiden Tabellen. Der Ergebnissatz kann mit Bedingungen einer *WHERE* Bedingung gefiltert werden. Ein Cross Join
  ist ähnlich der alten *SQL*-89 Join Syntax.

  Die ``joinCross()`` Methode hat keinen Parameter für die Join Bedingung. Einige *RDBMS* Marken unterstützen
  diesen Join Typ nicht.

- ``NATURAL JOIN`` mit der ``joinNatural(tabelle, [spalten])`` Methode.

  Ein Natural Join vergleicht alle Spalten die in beiden Tabellen mit gleichem Namen vorkommen. Der Vergleich
  prüft Gleichheit aller Spalten, ein Vergleich auf Ungleichheit ist kein Natural Join. Von dieser *API* werden
  nur Natural Inner Joins unterstützt, auch wenn *SQL* auch Natural Outer Joins erlaubt.

  Die ``joinNatural()`` Methode hat keinen Parameter für die Join Bedingung.

Zusätzlich zu diesen Join Methoden können Abfragen durch Verwendung der JoinUsing Methoden vereinfacht werden.
Statt das eine komplette Definition des Joins angegeben wird, kann einfach der Spaltenname übergeben werden auf
welchem gejoint werden soll und das ``Zend_Db_Select`` Objekt vervollständigt die Bedingung alleine.

.. _zend.db.select.building.joinusing.example:

.. rubric:: Beispiel für die joinUsing() Methode

.. code-block:: php
   :linenos:

   // Erzeugt diese Abfrage
   //   SELECT *
   //   FROM "table1"
   //   JOIN "table2"
   //   ON "table1".column1 = "table2".column1
   //   WHERE column2 = 'foo'

   $select = $db->select()
                ->from('table1')
                ->joinUsing('table2', 'column1')
                ->where('column2 = ?', 'foo');

Jede der anwendbaren Join Methoden in der ``Zend_Db_Select`` Komponente hat eine entsprechende 'using' Methode.

- ``joinUsing(table, join, [columns])`` und ``joinInnerUsing(table, join, [columns])``

- ``joinLeftUsing(table, join, [columns])``

- ``joinRightUsing(table, join, [columns])``

- ``joinFullUsing(table, join, [columns])``

.. _zend.db.select.building.where:

Hinzufügen eines WHERE Abschnitts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Es können Kriterien die den Ergebnissatz einschränken mit der ``where()`` Methode angegeben werden. Das erste
Argument dieser Methode ist eine *SQL* Expression, welche in einer *SQL* *WHERE* Klausel der Anfrage steht.

.. _zend.db.select.building.where.example:

.. rubric:: Beispiel für die where() Methode

.. code-block:: php
   :linenos:

   // Erzeugt diese Anfrage:
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE price > 100.00

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where('price > 100.00');

.. note::

   Auf Expressions die an ``where()`` oder ``orWhere()`` Methoden übergeben werden, wird keine Quotierung
   angewendet. Werden Spaltennamen verwendet die Quotiert werden müssen, so muss ``quoteIdentifier()`` verwendet
   werden wenn der String für die Bedingung formuliert wird.

Das zweite Argument der ``where()`` Methode ist optional. Es ist ein Wert der in die Expression eingesetzt wird.
``Zend_Db_Select`` Quotiert den Wert und ersetzt ihn für ein Fragezeichen ("**?**") in der Expression.

.. _zend.db.select.building.where.example-param:

.. rubric:: Beispiel für einen Parameter in der where() Methode

.. code-block:: php
   :linenos:

   // Erzeugt diese Anfrage:
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE (price > 100.00)

   $minimumPrice = 100;

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where('price > ?', $minimumPrice);

Man kann als zweiten Parameter ein Array an die ``where()`` Methode übergeben wenn der *SQL* IN Operator verwendet
wird.

.. _zend.db.select.building.where.example-array:

.. rubric:: Beispiel eines Array Parameters in der where() Methode

.. code-block:: php
   :linenos:

   // Diese Abrage wird gebaut:
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE (product_id IN (1, 2, 3))

   $productIds = array(1, 2, 3);

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where('product_id IN (?)', $productIds);

Die ``where()`` Methode kann mehrere Male in dem selben ``Zend_Db_Select`` Objekt aufgerufen werden. Die daraus
folgenden Anfrage kombiniert die unterschiedlichen Ausdrücke unter Benutzung von *AND* zwischen ihnen.

.. _zend.db.select.building.where.example-and:

.. rubric:: Beispiel für mehrfach Aufruf der where() Methode

.. code-block:: php
   :linenos:

   // Erzeugt diese Anfrage:
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE (price > 100.00)
   //     AND (price < 500.00)

   $minimumPrice = 100;
   $maximumPrice = 500;

   $select = $db->select()
               ->from('products',
                      array('product_id', 'product_name', 'price'))
               ->where('price > ?', $minimumPrice)
               ->where('price < ?', $maximumPrice);

Wenn mehrere Ausdrücke mit *OR* verknüpft werden sollen kann die ``orWhere()`` Methode verwendet werden. Sie wird
genauso benutzt wie die ``where()`` Methode, außer das dem angegebene Ausdruck ein *OR* vorangestellt wird,
anstelle eines *AND*.

.. _zend.db.select.building.where.example-or:

.. rubric:: Beispiel für die orWhere() Methode

.. code-block:: php
   :linenos:

   // Erzeugt diese Anfrage:
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE (price < 100.00)
   //     OR (price > 500.00)

   $minimumPrice = 100;
   $maximumPrice = 500;

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where('price < ?', $minimumPrice)
                ->orWhere('price > ?', $maximumPrice);

``Zend_Db_Select`` klammert Expressions automatisch mit runden Klammern ein wenn sie mit der ``where()`` oder
``orWhere()`` Methode angegeben wurden. Dies hilft sicher zu stellen dass das voranstellen von Boolean Operatoren
keine unerwarteten Ergebnisse nach sich zieht.

.. _zend.db.select.building.where.example-parens:

.. rubric:: Beispiel für das Einklammern von Boolean Expressions

.. code-block:: php
   :linenos:

   // Erzeugt diese Anfrage:
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE (price < 100.00 OR price > 500.00)
   //     AND (product_name = 'Apple')

   $minimumPrice = 100;
   $maximumPrice = 500;
   $prod = 'Apple';

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where("price < $minimumPrice OR price > $maximumPrice")
                ->where('product_name = ?', $prod);

In dem oben stehenden Beispiel währen die Ergebnisse ohne den Klammern ziemlich anders, weil *AND* eine höhere
Priorität als *OR* hat. ``Zend_Db_Select`` erzeugt runde Klammern wodurch jede Expression von aufeinander
folgenden Aufrufen der ``where()`` Methode fester binden als das *AND* welches die Expressions kombiniert.

.. _zend.db.select.building.group:

Hinzufügen eines GROUP BY Abschnitts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In *SQL* ermöglicht der ``GROUP BY`` Abschnitt die Zeilenzahl des Ergebnissatzes auf eine Zeile pro eindeutigem
Wert der Spalte(n), welche in dem ``GROUP BY`` Abschnitt benannt sind, einzuschränken.

In ``Zend_Db_Select`` können diese Spalte(n) mit der ``group()`` Methode angegeben werden. Das Argument der
Methode ist ein Spaltenname oder ein Array von Spaltennamen, welche im ``GROUP BY`` Abschnitt stehen sollen.

.. _zend.db.select.building.group.example:

.. rubric:: Beispiel für die group() Methode

.. code-block:: php
   :linenos:

   // Erzeugt diese Anfrage:
   //   SELECT p."product_id", COUNT(*) AS line_items_per_product
   //   FROM "products" AS p JOIN "line_items" AS l
   //     ON p.product_id = l.product_id
   //   GROUP BY p.product_id

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id'))
                ->join(array('l' => 'line_items'),
                       'p.product_id = l.product_id',
                       array('line_items_per_product' => 'COUNT(*)'))
                ->group('p.product_id');

Wie in dem Array von Spaltennamen der ``from()`` Methode, so können auch hier Beziehungsnamen in den Strings der
Spaltennamen verwendet werden, und der Spaltenname wird als Bezeichner Quotiert, wenn er nicht in runden Klammern
steht oder ein Objekt des Typs ``Zend_Db_Expr`` ist.

.. _zend.db.select.building.having:

Hinzufügen eines HAVING Abschnittes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In *SQL* fügt der ``HAVING`` Abschnitt eine Beschränkungsbedingung für Gruppen von Zeilen ein. Dies ist ähnlich
der Einschränkungsbedingungen auf Zeilen, des ``WHERE`` Abschnittes. Die beiden Abschnitte unterscheiden sich
jedoch, denn die ``WHERE`` Bedingungen werden abgewendet bevor Gruppen definiert wurden. Im Gegensatz werden
``HAVING`` Bedingungen erst angewendet nach dem Gruppen definiert wurden.

In ``Zend_Db_Select`` können Bedingungen für die Einschränkung von Gruppen mit der ``having()`` Methode
angegeben werden. Die Nutzung ist ähnlich wie die der ``where()`` Methode. Das erste Argument ist ein String,
welcher eine *SQL* Expression enthält. Das zweite Argument ist optional und wird verwendet um einen positionierten
Parameter Platzhalter in der *SQL* Expression zu ersetzen. Expressions die durch mehrfaches Aufrufen der
``having()`` Methode erzeugt wurden werden mit dem Boolean *AND* Operator verknüpft, oder mit dem *OR* Operator
wenn die ``orHaving()`` Methode verwendet wird.

.. _zend.db.select.building.having.example:

.. rubric:: Beispiel für die having() Methode

.. code-block:: php
   :linenos:

   // Erzeugt diese Anfrage:
   //   SELECT p."product_id", COUNT(*) AS line_items_per_product
   //   FROM "products" AS p JOIN "line_items" AS l
   //     ON p.product_id = l.product_id
   //   GROUP BY p.product_id
   //   HAVING line_items_per_product > 10

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id'))
                ->join(array('l' => 'line_items'),
                       'p.product_id = l.product_id',
                       array('line_items_per_product' => 'COUNT(*)'))
                ->group('p.product_id')
                ->having('line_items_per_product > 10');

.. note::

   Es wird keine Quotierung bei den Expressions welche an die ``having()`` oder ``orHaving()`` Methoden übergeben
   werden. Werden Spaltennamen verwendet die Quotiert werden müssen, so muss ``quoteIdentifier()`` verwendet
   werden wenn der String für die Bedingung formuliert wird.

.. _zend.db.select.building.order:

Hinzufügen eines ORDER BY Abschnitts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In *SQL* gibt der *ORDER* BY Abschnitt eine oder mehrere Spalten oder Expressions an, wonach ein Ergebnissatz
sortiert wird. Wenn mehrere Spalten angegeben sind, werden die sekundären Spalten verwendet um "ties" aufzulösen;
die Sortierung wird von sekundären Spalten bestimmt, wenn vorhergehende Spalten identische Werte enthalten. Die
standard Sortierung ist vom kleinsten zum größten Wert. Dieses Verhalten kann umgekehrt werden, wenn das
Schlüsselwort ``DESC`` nach der Spalte angegeben wird.

In ``Zend_Db_Select`` kann die ``order()`` Methode verwendet werden um Spalten, oder Arrays von Spalten, anzugeben,
nach denen sortiert werden soll. Jedes Element des Arrays ist ein String, welcher die Spalte benennt. Optional kann
auf den Namen eines der Schlüsselwörter ``ASC`` ``DESC`` folgen, abgetrennt durch ein Leerzeichen.

Wie in den ``from()`` und ``group()`` Methoden, werden Spalten als Bezeichner Quotiert, wenn sie nicht von runden
Klammern eingeschlossen oder vom Objekttyp ``Zend_Db_Expr`` sind.

.. _zend.db.select.building.order.example:

.. rubric:: Beispiel für die order() Methode

.. code-block:: php
   :linenos:

   // Erzeugt diese Anfrage:
   //   SELECT p."product_id", COUNT(*) AS line_items_per_product
   //   FROM "products" AS p JOIN "line_items" AS l
   //     ON p.product_id = l.product_id
   //   GROUP BY p.product_id
   //   ORDER BY "line_items_per_product" DESC, "product_id"

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id'))
                ->join(array('l' => 'line_items'),
                       'p.product_id = l.product_id',
                       array('line_items_per_product' => 'COUNT(*)'))
                ->group('p.product_id')
                ->order(array('line_items_per_product DESC',
                              'product_id'));

.. _zend.db.select.building.limit:

Hinzufügen eines LIMIT Abschnitts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Einige *RDBMS* Marken erweitern *SQL* mit einem Anfrage Abschnitt, bekannt als ``LIMIT`` Abschnitt. Dieser
Abschnitt begrenzt die Anzahl der Zeilen in einem Ergebnissatz auf die angegebene Höchstanzahl. Es kann ebenfalls
angegeben werden, dass eine Anzahl von Zeilen ausgelassen werden soll. Dieses Feature erlaubt es eine Untermenge
des Ergebnissatzes zu holen, zum Beispiel wenn Anfrage Ergebnisse auf aufeinander folgenden Seiten angezeigt werden
sollen.

In ``Zend_Db_Select`` kann die ``limit()`` Methode verwendet werden um die Anzahl von Zeilen und die Anzahl der
auszulassenden Spalten anzugeben. Das **erste** Argument dieser Methode ist die gewünschte Anzahl an Zeilen. Das
**zweite** Argument gibt die Anzahl der auszulassenden Zeilen an.

.. _zend.db.select.building.limit.example:

.. rubric:: Beispiel für die limit() Methode

.. code-block:: php
   :linenos:

   // Erzeugt diese Anfrage:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p
   //   LIMIT 10, 20
   // Identisch zu:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p
   //   LIMIT 20 OFFSET 10

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'product_name'))
                ->limit(20, 10);

.. note::

   Die ``LIMIT`` Syntax wird nicht von allen *RDBMS* Marken unterstützt. Einige *RDBMS* benötigen eine
   unterschiedliche Syntax für eine ähnliche Funktionalität. Jede ``Zend_Db_Adapter_Abstract`` Klasse enthält
   eine Methode um für das *RDBMS* passende *SQL* Syntax zu erzeugen.

Die ``limitPage()`` Methode kann als alternativer Weg verwendet werden um Zeilenanzahl und Offset zu spezifizieren.
Diese Methode erlaubt den Ergebnissatz auf einen Subset, aus einer Serie von Subsets mit Reihen einer fixe Länge,
auf dem totalen Ergebnissatz der Abfrage, zu limitieren. In anderen Worten, spezifiziert man die Länge einer Seite
("page") von Ergebnissen, und die ordinale Anzahl an Ergebnissen einer einzelnen Seite, die als von der Abfrage
zurück gegeben werden sollen. Die Seitennummer ist das erste Argument der ``limitPage()`` Methode, und die
Seitenlänge ist das zweite Argument. Beide Argumente werden benötigt; sie haben keinen Standardwert.

.. _zend.db.select.building.limit.example2:

.. rubric:: Beispiel der limitPage() Methode

.. code-block:: php
   :linenos:

   // Erstelle diese Abfrage:
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p
   //   LIMIT 10, 20

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'product_name'))
                ->limitPage(2, 10);

.. _zend.db.select.building.distinct:

Hinzufügen des DISTINCT Anfragewandlers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die ``distinct()`` Methode ermöglicht es ``DISTINCT`` Schlüsselworte in die *SQL* Syntax einzufügen.

.. _zend.db.select.building.distinct.example:

.. rubric:: Beispiel für die distinct() Methode

.. code-block:: php
   :linenos:

   // Erzeugt diese Anfrage:
   //   SELECT DISTINCT p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->distinct()
                ->from(array('p' => 'products'), 'product_name');

.. _zend.db.select.building.for-update:

Hinzufügen des FOR UPDATE Anfragewandlers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die ``forUpdate()`` Methode ermöglicht es *FOR* *UPDATE* Schlüsselworte in die *SQL* Syntax einzufügen.

.. _zend.db.select.building.for-update.example:

.. rubric:: Beispiel der forUpdate() Methode

.. code-block:: php
   :linenos:

   // Erzeugt diese Anfrage:
   //   SELECT FOR UPDATE p.*
   //   FROM "products" AS p

   $select = $db->select()
                ->forUpdate()
                ->from(array('p' => 'products'));

.. _zend.db.select.building.union:

Eine UNION Abfrage erstellen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Man kann Union Abfragen mit ``Zend_Db_Select`` erstellen indem ein Array von ``Zend_Db_Select`` oder *SQL* Query
Strings an die ``union()`` Methode übergeben wird. Als zweiter Parameter können die Konstanten
``Zend_Db_Select::SQL_UNION`` oder ``Zend_Db_Select::SQL_UNION_ALL`` übergeben werden um den Typ der Union zu
spezifizieren den man ausführen will.

.. _zend.db.select.building.union.example:

.. rubric:: Beispiel der union() Methode

.. code-block:: php
   :linenos:

   $sql1 = $db->select();
   $sql2 = "SELECT ...";

   $select = $db->select()
       ->union(array($sql1, $sql2))
       ->order("id");

.. _zend.db.select.execute:

Ausführen von SELECT Anfrage
----------------------------

Dieser Abschnitt beschreibt wie Anfragen ausgeführt werden, die durch ein ``Zend_Db_Select`` Objekt repräsentiert
werden.

.. _zend.db.select.execute.query-adapter:

Ausführen von Select Anfragen aus dem Db Adapter
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die Anfrage, die durch das ``Zend_Db_Select`` Objekt repräsentiert wird kann ausgeführt werden, indem sie als
erstes Argument an die ``query()`` Methode des ``Zend_Db_Adapter_Abstract`` Objekts übergeben wird. Dabei wird das
``Zend_Db_Select`` anstelle eines Strings verwendet.

Die ``query()`` Methode gibt ein Objekt vom Typ ``Zend_Db_Statement`` oder PDOStatement zurück, je nachdem welcher
Adaptertyp verwendet wird.

.. _zend.db.select.execute.query-adapter.example:

.. rubric:: Beispiel für die Nutzung der query() Methode des Db Adapters

.. code-block:: php
   :linenos:

   $select = $db->select()
                ->from('products');

   $stmt = $db->query($select);
   $result = $stmt->fetchAll();

.. _zend.db.select.execute.query-select:

Ausführen von Select Anfragen mit dem objekt
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Als Alternative zur Nutzung der ``query()`` Methode des Adapterobjekts kann auch die ``query()`` Methode des
``Zend_Db_Select`` Objekts verwendet werden. Beide Methoden geben ein Objekt vom Typ ``Zend_Db_Statement`` oder
PDOStatement zurück, je nachdem welcher Adaptertyp verwendet wird.

.. _zend.db.select.execute.query-select.example:

.. rubric:: Beispiel für die Nutzung der query() Methode des Select Objekts

.. code-block:: php
   :linenos:

   $select = $db->select()
                ->from('products');

   $stmt = $select->query();
   $result = $stmt->fetchAll();

.. _zend.db.select.execute.tostring:

Konvertieren eines Select Objekts in einen SQL String
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wenn Zugriff zu auf eine String Repräsentante der *SQL* Anfrage, entsprechend dem ``Zend_Db_Select``, benötigt
wird, kann die ``__toString()`` Methode verwendet werden.

.. _zend.db.select.execute.tostring.example:

.. rubric:: Beispiel für die \__toString() Methode

.. code-block:: php
   :linenos:

   $select = $db->select()
                ->from('products');

   $sql = $select->__toString();
   echo "$sql\n";

   // Ausgabe ist dieser String:
   //   SELECT * FROM "products"

.. _zend.db.select.other:

Andere Methoden
---------------

Dieser Abschnitt beschreibt andere Methoden der ``Zend_Db_Select`` Klasse, welche bisher nicht beschrieben wurden:
``getPart()`` und ``reset()``.

.. _zend.db.select.other.get-part:

Abfragen von Teilen des Select Objekts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die ``getPart()`` Methode gibt eine Repräsentante eines Teils der *SQL* Anfrage zurück. Zum Beispiel kann diese
Methode verwendet werden um, ein Array von Expressions des ``WHERE`` Abschnitts, ein Array von Spalten (oder
Spalten Expressions) von ``SELECT`` oder die Werte der Spaltenzahl und Auslassungen des ``LIMIT`` Abschnitts, zu
erhalten.

Die Rückgabe ist kein String der ein Fragment der *SQL* Syntax enthält. Der Rückgabewert ist eine interne
Repräsentante, was typischerweise eine Arraystruktur ist, welche Werte und Expressions enthält. Jeder Teil der
Anfrage hat eine unterschiedliche Struktur.

Das einzige Argument der ``getPart()`` Methode ist ein String der den zurück zu gebenden Teil der Anfrage
bezeichnet. Zum Beispiel bezeichnet der String ``'from'`` den Teil des Select Objekts, welcher Informationen über
den ``FROM`` Abschnitt, einschließlich verbundener Tabellen enthält.

Die ``Zend_Db_Select`` Klasse definiert Konstanten die für Teile der *SQL* Anfrage verwendet werden können. Es
können die Konstantendefinitionen oder die literalen Strings verwendet werden.

.. _zend.db.select.other.get-part.table:

.. table:: Konstanten die von getPart() und reset() verwendet werden

   +----------------------------+-------------+
   |Konstante                   |String Wert  |
   +============================+=============+
   |Zend_Db_Select::DISTINCT    |'distinct'   |
   +----------------------------+-------------+
   |Zend_Db_Select::FOR_UPDATE  |'forupdate'  |
   +----------------------------+-------------+
   |Zend_Db_Select::COLUMNS     |'columns'    |
   +----------------------------+-------------+
   |Zend_Db_Select::FROM        |'from'       |
   +----------------------------+-------------+
   |Zend_Db_Select::WHERE       |'where'      |
   +----------------------------+-------------+
   |Zend_Db_Select::GROUP       |'group'      |
   +----------------------------+-------------+
   |Zend_Db_Select::HAVING      |'having'     |
   +----------------------------+-------------+
   |Zend_Db_Select::ORDER       |'order'      |
   +----------------------------+-------------+
   |Zend_Db_Select::LIMIT_COUNT |'limitcount' |
   +----------------------------+-------------+
   |Zend_Db_Select::LIMIT_OFFSET|'limitoffset'|
   +----------------------------+-------------+

.. _zend.db.select.other.get-part.example:

.. rubric:: Beispiel der getPart() Methode

.. code-block:: php
   :linenos:

   $select = $db->select()
                ->from('products')
                ->order('product_id');

   // Ein literaler String kann verwendet werden um den Abschnitt zu definieren
   $orderData = $select->getPart( 'order' );

   // Eine Konstante kann verwendet werden um den selben Abschnitt zu definieren
   $orderData = $select->getPart( Zend_Db_Select::ORDER );

   // Der zurückgegebene Wert kann eine Array Struktur sein, kein String.
   // Jeder Abschnitt hat eine unterschiedliche Struktur.
   print_r( $orderData );

.. _zend.db.select.other.reset:

Zurücksetzen von Teilen des Select Objekts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die ``reset()`` Methode ermöglicht es einen angegebenen Teil der *SQL* Anfrage zu löschen oder, wenn der
Parameter ausgelassen ist, alle Teile der *SQL* Anfrage zu löschen.

Das einzige Argument ist optional. Es kann der Teil der Anfrage angegeben werden, der gelöscht werden soll, unter
Nutzung des gleichen Strings wie er als Argument der ``getPart()`` Methode verwendet wird. Der angegebene Teil wird
auf ein Standardwert zurück gesetzt.

Wenn der Parameter ausgelassen wird, setzt ``reset()`` alle geänderten Teile auf einen Standardwert zurück.
Dadurch ist das ``Zend_Db_Select`` Objekt gleichwertig mit einem neuen Objekt, wie wenn es gerade Instanziiert
wurde.

.. _zend.db.select.other.reset.example:

.. rubric:: Beispiel der reset() Methode

.. code-block:: php
   :linenos:

   // Erzeugt diese Anfrage:
   //   SELECT p.*
   //   FROM "products" AS p
   //   ORDER BY "product_name"

   $select = $db->select()
                ->from(array('p' => 'products')
                ->order('product_name');

   // Geänderte Anforderungen, stattdessen sortiert nach einer anderen Spalte:
   //   SELECT p.*
   //   FROM "products" AS p
   //   ORDER BY "product_id"

   // Lösche einen Abschnitt damit er neu defniert werden kann
   $select->reset( Zend_Db_Select::ORDER );

   // und definiere eine andere Spalte
   $select->order('product_id');

   // Lösche alle Abschnitte von der Abfrage
   $select->reset();


