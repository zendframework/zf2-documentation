.. _zend.db.table:

Zend_Db_Table
=============

.. _zend.db.table.introduction:

Inleiding
---------

Zend_Db_Table is een tabellenmodule voor het Zend Framework. Het verbindt je met een database via Zend_Db_Adapter,
onderzoekt het schema van de tabel en helpt je dan in het manipuleren en opvragen van rijen uit de tabel.

.. _zend.db.table.getting-started:

Om te beginnen
--------------

Het eerste wat gedaan moet worden is een standaard database adapter te geven aan de abstracte Zend_Db_Table klasse;
tenzij je het anders opgeeft zullen alle Zend_Db_Table instanties deze standaard adapter gebruiken.

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
   ?>

Laten we ons nu voorstellen dat je een tabel genaamd "round_table" hebt in je database. Om Zend_Db_Table te
gebruiken met deze database moet je eenvoudigweg Zend_Db_Table uitbreiden door een nieuwe klasse "RoundTable" te
maken (merk op hoe we de round_table naam "kameleren"). Nu kunnen we via deze klasse rijen onderzoeken ,
manipuleren en resultaten opvragen van de "round_table" tabel in de database.

.. code-block:: php
   :linenos:

   <?php
   class RoundTable extends Zend_Db_Table {}
   $table = new RoundTable();
   ?>

.. _zend.db.table.name-and-key:

Tabelnaam en Primaire Key
-------------------------

Per definitie verwacht Zend_Db_Table dat de tabelnaam in de database dezelfde is als zijn eigen klassenaam (eenmaal
omgezet van camelCaps naar underscore_woorden). Aldus, een Zend_Db_Table klasse genaamd EenTabelNaam wordt naar een
SQL tabel genaamd een_tabel_naam gemapt. Als je wil dat je klasse naar iets anders dan de underscore vorm van je
klassenaam wordt gemapt, moet je de $_name eigenschap overschrijven wanneer je je klasse definieert.

.. code-block:: php
   :linenos:

   <?php
   class ClassName extends Zend_Db_Table
   {
       // standaard tabelnaam is 'class_name'
       // maar we willen ergens anders naartoe mappen
       protected $_name = 'another_table_name';
   }
   ?>

Per definitie verwacht Zend_Db_Table dat jouw tabel een primaire key heeft die 'id' noemt. (Het is beter indien
deze kolom automatisch wordt geïncrementeerd, maar het is niet verplicht.) Indien jouw primaire key anders heet
kan je de $_primary eigenschap van de klasse overschrijven wanneer je je klasse definieert.

.. code-block:: php
   :linenos:

   <?php
   class ClassName extends Zend_Db_Table
   {
       // standaard primaire key is 'id'
       // maar we willen iets anders gebruiken
       protected $_primary = 'another_column_name';
   }
   ?>

Op een andere manier mag je hetzelfde doen in de \_setup() methode van je uitgebreide klasse; maar wees er zeker
van de parent::\_setup() methode op te roepen wanneer je klaar bent.

.. code-block:: php
   :linenos:

   <?php
   class ClassName extends Zend_Db_Table
   {
       protected function _setup()
       {
           $this->_name = 'another_table_name';
           $this->_primary = 'another_column_name';
           parent::_setup();
       }
   }
   ?>

.. _zend.db.table.insert:

Rijen invoegen
--------------

Om een nieuwe rij in jouw tabel in te voegen roep je gewoon insert() op met een associatieve array van kolom:waarde
data. De data zal automatisch correct worden omwikkeld met quotes, en de laatst ingevoegde ID wordt teruggestuurd.
(Merk op dat dit verschilt van Zend_Db_Adapter::insert(), waar het aantal beïnvloede rijen wordt teruggestuurd.)

.. code-block:: php
   :linenos:

   <?php
   //
   // INSERT INTO round_table
   //     (noble_title, first_name, favorite_color)
   //     VALUES ("King", "Arthur", "blue")
   //

   class RoundTable extends Zend_Db_Table {}

   $table = new RoundTable();

   $data = array(
       'noble_title' => 'King',
       'first_name'  => 'Arthur',
       'favorite_color' => 'blue',
   )

   $id = $table->insert($data);
   ?>

.. _zend.db.table.udpate:

Rijen updaten
-------------

Om eender welk aantal rijen in je tabel te updaten roep je update() op met een associatieve array van kolom:waarde
data die moet worden gezet, samen met een WHERE clausule om de rijen die moeten worden geupdate te definiëren. Het
zal de tabel updaten en het aantal beïnvloede rijen teruggeven.

De data die gezet moet worden zal automatisch correct worden omwikkeld met quotes, maar de WHERE clausule niet, die
moet je dus zelf quoten met het Zend_Db_Adapter object van de tabel.

.. code-block:: php
   :linenos:

   <?php
   //
   // UPDATE round_table
   //     SET favorite_color = "yellow"
   //     WHERE first_name = "Robin"
   //

   class RoundTable extends Zend_Db_Table {}

   $table = new RoundTable();
   $db = $table->getAdapter();

   $set = array(
       'favorite_color' => 'yellow',
   )

   $where = $db->quoteInto('first_name = ?', 'Robin');

   $rows_affected = $table->update($set, $where);
   ?>

.. _zend.db.table.delete:

Rijen verwijderen
-----------------

Om eender welk aantal rijen te verwijderen uit een tabel roep je delete() op met een WHERE clausule om de rijen die
verwijderd moeten worden te identificeren. Het zal het aantal verwijderde rijen terugsturen.

De WHERE clausule zal niet in quotes worden omwikkeld, dus die moet je zelf quoten met het Zend_Db_Adapter object
van de tabel.

.. code-block:: php
   :linenos:

   <?php
   //
   // DELETE FROM round_table
   //     WHERE first_name = "Patsy"
   //

   class RoundTable extends Zend_Db_Table {}

   $table = new RoundTable();
   $db = $table->getAdapter();

   $where = $db->quoteInto('first_name = ?', 'Patsy');

   $rows_affected = $table->delete($where);
   ?>

.. _zend.db.table.findbykey:

Rijen vinden per primaire key
-----------------------------

Het is eenvoudig om rijen uit een tabel te verkrijgen door gebruik te maken van de primaire key waarden in de
find() methode. Deze methode keert een Zend_Db_Table_Row object terug indien je één enkele key probeert te
vinden, of een Zend_Db_Table_Rowset objekt indien je meerdere keys probeert te vinden met find().

.. code-block:: php
   :linenos:

   <?php
   class RoundTable extends Zend_Db_Table {}

   $table = new RoundTable();

   // SELECT * FROM round_table WHERE id = "1"
   $row = $table->find(1);

   // SELECT * FROM round_table WHERE id IN("1", "2", 3")
   $rowset = $table->find(array(1, 2, 3));
   ?>

.. _zend.db.table.fetchonerow:

Eén enkele rij ophalen
----------------------

Hoewel je gemakkellijk een rij kan vinden via zijn primaire key met find(), zal je vaak verschillende voorwaarden
willen toevoegen om een rij te verkrijgen. Juist hiervoor verstrekt Zend_Db_Table fetchRow(). Gebruik fetchRow()
met een WHERE clausule (en een optionele ORDER clausule), en Zend_Db_Table zal een Zend_Db_Row object teruggeven
met de eerste rij die aan de voorwaarden voldoet.

De WHERE clausule zal niet in quotes worden omwikkeld, dus die moet je zelf quoten met het Zend_Db_Adapter object
van de tabel.

.. code-block:: php
   :linenos:

   <?php
   //
   // SELECT * FROM round_table
   //     WHERE noble_title = "Sir"
   //     AND first_name = "Robin"
   //     ORDER BY favorite_color
   //

   class RoundTable extends Zend_Db_Table {}

   $table = new RoundTable();
   $db = $table->getAdapter();

   $where = $db->quoteInto('noble_title = ?', 'Sir')
          . $db->quoteInto('AND first_name = ?', 'Robin');

   $order = 'favorite_color';

   $row = $table->fetchRow($where, $order);
   ?>

.. _zend.db.table.fetchmultiple:

Meerdere rijen ophalen
----------------------

Indien je meerdere rijen in een enkele keer moet ophalen kan je fetchAll() gebruiken. Zoals met fetchRow()
behandelt deze methode WHERE en ORDER clausules, maar kan bovendien limit-count en limit-offset waarden aanvaarden
om het aantal teruggekeerde rijen te beperken. Het zal een Zend_Db_Table_Rowset object teruggeven met de
geselecteerde records.

De WHERE clausule zal niet in quotes worden omwikkeld, dus die moet je zelf quoten met het Zend_Db_Adapter object
van de tabel.

.. code-block:: php
   :linenos:

   <?php
   class RoundTable extends Zend_Db_Table {}

   $table = new RoundTable();
   $db = $table->getAdapter();

   // SELECT * FROM round_table
   //     WHERE noble_title = "Sir"
   //     ORDER BY first_name
   //     LIMIT 10 OFFSET 20

   $where = $db->quoteInto('noble_title = ?', 'Sir');
   $order = 'first_name';
   $count = 10;
   $offset = 20;

   $rowset = $table->fetchRow($where, $order, $count, $offset);
   ?>

.. _zend.db.table.domain-logic:

Domein Logica Invoegen
----------------------

Als een tabelmodule leent Zend_Db_Table er zichzelf goed toe om je eigen domeinlogica in te kapselen. Bijvoorbeeld,
je kan de insert() en update() methodes overschrijven om de gepostte data te manipuleren of te valideren voordat
die naar de database wordt geschreven.

.. code-block:: php
   :linenos:

   <?php
   class RoundTable extends Zend_Db_Table
   {
       public function insert($data)
       {
           // voeg een timestamp in
           if (empty($data['created_on'])) {
               $data['created_on'] = time();
           }
           return parent::insert($data);
       }

       public function update($data)
       {
           // voeg een timestamp in
           if (empty($data['updated_on'])) {
               $data['updated_on'] = time();
           }
           return parent::update($data);
       }
   }
   ?>

Op een gelijkaardige wijze kan je je eigen find() methoden toevoegen om records op te zoeken door iets anders dan
hun primaire key te gebruiken.

.. code-block:: php
   :linenos:

   <?php
   class RoundTable extends Zend_Db_Table
   {
       public function findAllWithName($name)
       {
           $db = $this->getAdapter();
           $where = $db->quoteInto("name = ?", $name);
           $order = "first_name";
           return $this->fetchAll($where, $order);
       }
   }
   ?>


