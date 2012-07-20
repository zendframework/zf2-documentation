.. _zend.db.table.rowset:

Zend_Db_Table_Rowset
====================

.. _zend.db.table.rowset.introduction:

Inleiding
---------

Zend_Db_Table_Rowset is een iterator voor Zend_Db_Table_Row object verzamelingen. In het algemeen instantieer je
geen alleenstaande Zend_Db_Table_Rowset; maar krijg je een Zend_Db_Table_Rowset terug als resultaat van een oproep
aan Zend_Db_Table::find() of fetchAll(). Je kan dan door de verzameling Zend_Db_Table_Row objecten lopen en deze
wijzigen indien je dat wenst.

.. _zend.db.table.rowset.fetch:

Een Rowset verkrijgen
---------------------

Het eerste wat je moet doen is een Zend_Db_Table klasse instantiëren.

.. code-block::
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

   // de standaard adapter zetten voor alle Zend_Db_Table objekten
   require_once 'Zend/Db/Table.php';
   Zend_Db_Table::setDefaultAdapter($db);

   // verbinden met een tabel in de database
   class RoundTable extends Zend_Db_Table {}
   $table = new RoundTable();
   ?>

Verkrijg vele records van de database door Zend_Db_Table::find() met meerdere keys te gebruiken, of door
Zend_Db_Table::fetchAll() te gebruiken; het aldus bekomen resultaat zal een Zend_Db_Table_Rowset object zijn dat je
toelaat door de individuele Zend_Db_Table_Row objecten in de recordset te lopen.

.. code-block::
   :linenos:
   <?php
   // verkrijg meerdere records van de tabel
   $rowset = $table->fetchAll();

   //
   // $rowset is nu een Zend_Db_Table_Rowset object bestaande uit
   // één Zend_Db_Table_Row object per record in de resultaten
   //
   ?>

.. _zend.db.table.rowset.iterate:

Door de Rowset lopen
--------------------

Zend_Db_Table_Rowset implementeert de SPL Iterator interface, wat betekent dat je door Zend_Db_Table_Rowset
objecten kan lopen zoals je dat doet met arrays door foreach() te gebruiken. Elke waarde die je zo verkrijgt zal
een Zend_Db_Table_Row object zijn dat overeenkomt met een record van de tabel. Je kan dan de eigenschappen ervan
afbeelden, wijzigen en terug opslaan.

.. code-block::
   :linenos:
   <?php
   // verbinden met een tabel in de database
   class RoundTable extends Zend_Db_Table {}
   $table = new RoundTable();

   // meerdere records verkrijgen van de tabel
   $rowset = $table->fetchAll();

   // ze allemaal afbeelden
   foreach ($rowset as $row) {
       // $row is een Zend_Db_Table_Row objekt
       echo "<p>De lievelingskleur van " . htmlspecialchars($row->nobleTitle) . " "
          . htmlspecialchars($row->firstName)
          . " is " . htmlspecialchars($row->favoriteColor)
          . ".</p>\n";

       // update het aantal keer dat we deze rij hebben afgebeeld
       // (deze eigenschap mapt naar een kolom in de tabel "times_displayed")
       $row->timesDisplayed ++;

       // de record opslaan met de nieuwe informatie
       $row->save();
   }
   ?>


