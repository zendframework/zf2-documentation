.. _zend.db.table.row:

Zend_Db_Table_Row
=================

.. _zend.db.table.row.introduction:

Inleiding
---------

Zend_Db_Table_Row is een datarij gateway voor het Zend Framework. In het algemeen instantieer je Zend_Db_Table_Row
niet alleen maar krijg je een Zend_Db_Table_Row terug als een resultaat van Zend_Db_Table::find() of
Zend_Db_Table::fetchRow(). Eenmaal je een Zend_Db_Table_Row hebt kan je de recordwaarden wijzigen (voorgesteld als
klasse-eigenschappen) en dan de wijzigingen terug naar de oorspronkelijke tabel sturen via save().

.. _zend.db.table.row.fetch:

Een rij ophalen
---------------

Het eerste wat je moet doen is een Zend_Db_Table klasse instantiëren.

.. code-block:: php
   :linenos:

   <?php
   // een adapter opzetten
   require_once 'Zend/Db.php';
   $params = array (
       'host'     => '127.0.0.1',
       'username' => 'malory',
       'password' => '******',
       'dbname'   => 'camelot'
   );

   $db = Zend_Db::factory('PDO_MYSQL', $params);

   // zet de standaard adapter voor alle Zend_Db_Table objecten
   require_once 'Zend/Db/Table.php';
   Zend_Db_Table::setDefaultAdapter($db);

   // verbinden met een tabel in de database
   class RoundTable extends Zend_Db_Table {}
   $table = new RoundTable();
   ?>

Verkrijg één record van de database door Zend_Db_Table::find() met één enkele key te gebruiken of door
Zend_Db_Table::fetchRow() te gebruiken. Het verkregen resultaat zal een Zend_Db_Table_Row zijn waarvan elke
eigenschap een "camelCaps" benaming van een "underscore_naam" kolom van de tabel is. Bijvoorbeeld, "first_name" in
de tabel zal "firstName" worden in de objecteigenschappen.

.. code-block:: php
   :linenos:

   <?php
   // verkrijg een record van de tabel als een Zend_Db_Table_Row object
   $row = $table->fetchRow('first_name = "Robin"');

   //
   // $row is nu een Zend_Db_Table_Row objekt met publieke eigenschappen
   // die naar tabelkolommen mappen:
   //
   // $row->id = '3'
   // $row->nobleTitle = 'Sir'
   // $row->firstName = 'Robin'
   // $row->favoriteColor = 'yellow'
   //

   ?>

.. _zend.db.table.row.modify:

Waarden wijzigen
----------------

Het wijzigen van rijwaarden is heel eenvoudig: werk gewoon met de object eigenschappen zoals je dat met eender welk
ander object zou doen. Als je klaar bent kan je de rij terugschrijven naar de oorspronkelijke tabel met save().

.. code-block:: php
   :linenos:

   <?php
   // verbinden met een tabel in de database
   class RoundTable extends Zend_Db_Table {}
   $table = new RoundTable();

   // verkrijg een record van de tabel als een Zend_Db_Table_Row object
   $row = $table->fetchRow('first_name = "Robin"');

   //
   // $row is nu een Zend_Db_Table_Row object met publieke eigenschappen
   // die naar tabelkolommen mappen:
   //
   // $row->id = '3'
   // $row->nobleTitle = 'Sir'
   // $row->firstName = 'Robin'
   // $row->favoriteColor = 'yellow'
   //
   // wijzig de leivelingskleur en schrijf de rij terug naar de tabel.
   $row->favoriteColor = 'blue';'
   $row->save();
   ?>

Het is evenwel verboden de waarden van primaire keys te wijzigen; indien je dat toch doet zal Zend_Db_Table_Row een
exceptie opwerpen.

.. code-block:: php
   :linenos:

   <?php
   // verbinden met een tabel in de database
   class RoundTable extends Zend_Db_Table {}
   $table = new RoundTable();

   // verkrijg een record van de tabel als een Zend_Db_Table_Row object
   $row = $table->fetchRow('first_name = "Robin"');

   // kunnen we de primaire key "id" wijzigen?
   try {
       $row->id = 5;
       echo "We zouden dit bericht niet moeten zien omdat er een fout werd opgeworpen.";
   } catch (Zend_Db_Table_RowException $e) {
       echo $e->getMessage();
   }
   ?>


