.. EN-Revision: none
.. _zend.db.adapter:

Zend\Db\Adapter
===============

.. _zend.db.adapter.introduction:

Inleiding
---------

*Zend\Db\Adapter* is de database API abstractielaag voor het Zend Framework, gebaseerd op PDO. Je kan
*Zend\Db\Adapter* gebruiken om je te verbinden en te werken met alle ondersteunde SQL database systemen die
dezelfde API gebruiken. Deze houden onder andere in: Microsoft SQL Server, MySQL, PostgreSQL, SQLite, en anderen.

Om een instantie van *Zend\Db\Adapter* voor jouw specifieke database op te roepen, moet je *Zend\Db\Db::factory()*
oproepen met de naam van de van toepassing zijnde adapter en een array van parameters die de verbinding
beschrijven. Bijvoorbeeld, om een verbinding tot stand te brengen op een MySQL database die "camelot" heet op
localhost met een user genaamd "arthur":

.. code-block:: php
   :linenos:

   <?php

   require_once 'Zend/Db.php';

   $params = array ('host'     => '127.0.0.1',
                    'username' => 'arthur',
                    'password' => '******',
                    'dbname'   => 'camelot');

   $db = Zend\Db\Db::factory('PDO_MYSQL', $params);

   ?>
Om een verbinding te maken met een SQLite database genaamd "camelot":

.. code-block:: php
   :linenos:

   <?php

   require_once 'Zend/Db.php';

   $params = array ('dbname' => 'camelot');

   $db = Zend\Db\Db::factory('PDO_SQLITE', $params);

   ?>
In elk geval zal je exact dezelfde API kunnen gebruiken om de database te ondervragen.

.. _zend.db.adapter.quoting:

Quoting tegen SQL Injectie
--------------------------

Je moet altijd waarden quoten die gebruikt moeten worden in een SQL verklaring; dit om SQL injectie aanvallen te
helpen voorkomen. *Zend\Db\Adapter* verstrekt twee methodes (via het onderliggende PDO object) om je te helpen
handmatig waarden te quoten.

De eerste van deze methodes is de *quote()* methode. Het zal een scalaire waarde correct quoten voor jouw database
adapter; als je een array probeert te quoten zal het een komma-gescheiden string van arraywaarden terugsturen, elk
van deze waarden met correcte quotes (dit is handig voor functies die een lijstparameter verwachten).

.. code-block:: php
   :linenos:

   <?php

   // maak een $db object, we nemen aan dat de adapter Mysql is.

   // quote een scalaire waarde
   $value = $db->quote('St John"s Wort');
   // $value is nu '"St John\"s Wort"' (merk de omringende quotes op)

   // quote een array
   $value = $db->quote(array('a', 'b', 'c');
   // $value is nu '"a", "b", "c"' (een komma-gescheiden string)

   ?>
De tweede methode is de *quoteInto()* methode. Je geeft een basis string op met een vraagteken plaatshouder, en
één scalaire waarde of een array om erin te quoten. Dit is handig om queries en clausules te maken "as-you-go".
Scalaire waarden en arrays werken hetzelfde als in de *quote()* methode.

.. code-block:: php
   :linenos:

   <?php

   // maak een $db object, we nemen aan dat de adapter Mysql is.

   // quote een scalaire waarde in de WHERE clausule
   $where = $db->quoteInto('id = ?', 1);
   // $where is nu 'id = "1"' (merk de omringende quotes op)

   // quote een array into een WHERE clausule
   $where = $db->quoteInto('id IN(?)', array(1, 2, 3));
   // $where is nu 'id IN("1", "2", "3")' (een komma-gescheiden string)

   ?>
.. _zend.db.adapter.queries:

Directe Queries
---------------

Eenmaal je een *Zend\Db\Adapter* instantie hebt, kan je queries direct in SQL uitvoeren. *Zend\Db\Adapter* geeft
die queries door aan het onderliggende PDO object, die de query klaarmaakt en uitvoert en dan een PDOStatement
object teruggeeft met de resultaten (als die er zijn) voor jou om te behandelen.

.. code-block:: php
   :linenos:

   <?php

   // maak een $db object, en ondervraag de database
   // met een SQL verklaring met correcte quotes.
   $sql = $db->quoteInto(
       'SELECT * FROM example WHERE date > ?',
       '2006-01-01'
   );
   $result = $db->query($sql);

   // gebruik het PDOStatement $result om alle regels als een array te halen
   $rows = $result->fetchAll();

   ?>
Je mag data automatisch in je query binden. Dat betekent dat je meerdere benoemde plaatshouders in de query kan
zetten, en dan een array kan doorgeven die de data bevat om de plaatshouders te vervullen. De vervulde waarden
zullen automatisch de juiste quotes krijgen, en zodanig een grotere veiligheid verstrekken tegen SQL injectie
aanvallen.

.. code-block:: php
   :linenos:

   <?php

   // maak een $db object, en ondervraag de database
   // gebruik deze keer benoemde plaatshouders bindingen.
   $result = $db->query(
       'SELECT * FROM example WHERE date > :placeholder',
       array('placeholder' => '2006-01-01')
   );

   // gebruik het PDOStatement $result om alle regels als een array te halen
   $rows = $result->fetchAll();

   ?>
Naar keuze zou je handmatig data willen voorbereiden en binden aan SQL verklaringen. Om dit te doen kan je de
*prepare()* methode gebruiken om een voorbereid *PDOStatement* te verkrijgen dat je kan aanpassen.

.. code-block:: php
   :linenos:

   <?php

   // maak een $db object, en ondervraag de database
   // bereid deze keer een PDOStatement voor dat aangepast kan worden
   $stmt = $db->prepare('SELECT * FROM example WHERE date > :placeholder');
   $stmt->bindValue('placeholder', '2006-01-01');
   $stmt->execute();

   // gebruik het PDOStatement $result om alle regels als een array te halen
   $rows = $stmt->fetchAll();

   ?>
.. _zend.db.adapter.transactions:

Transacties
-----------

Standaard is PDO (en dus ook *Zend\Db\Adapter*) in "auto-commit" mode. Dit betekent dat alle queries worden
gecommit wanneer ze worden uitgevoerd. Indien je wenst dat ze in een transactie worden uitgevoerd kan je
eenvoudigweg de *beginTransaction()* methode oproepen en, naargelang, je veranderingen *commit()* of *rollBack()*.
*Zend\Db\Adapter* keert terug naar "auto-commit" mode tot je opnieuw de *beginTransaction* methode aanroept.

.. code-block:: php
   :linenos:

   <?php

   // maak $db object, en begin een transactie
   $db->beginTransaction();

   // probeer een query.
   // indien ze succesvol is, commit de veranderingen
   // indien ze faalt, roll back.
   try {
       $db->query(...);
       $db->commit();
   } catch (Exception $e) {
       $db->rollBack();
       echo $e->getMessage();
   }

   ?>
.. _zend.db.adapter.insert:

Rijen Invoegen
--------------

Voor jouw gemak kan je de *insert()* methode gebruiken om een INSERT verklaring voor je te bouwen en er data aan te
binden die moet ingevoegd worden. De aldus gebonden data heeft automatisch correcte quotes om te helpen SQL
injectie aanvallen te voorkomen.

De terugkeerwaarde is **niet** de laatst ingevoegde ID omdat het kan zijn dat de tabel geen auto-increment kolom
heeft; in de plaats daarvan is de terugkeerwaarde het aantal rijen dat werd beïnvloedt (gewoonlijk 1). Als je de
ID van de laatst ingevoegde rij wil, kan je de *lastInsertId()* methode oproepen na de invoeging.

.. code-block:: php
   :linenos:

   <?php

   //
   // INSERT INTO round_table
   //     (noble_title, first_name, favorite_color)
   //     VALUES ("King", "Arthur", "blue");
   //

   // maak een $db object, en dan...
   // de rijdata die moet worden ingevoegd in kolom => waarde formaat
   $row = array (
       'noble_title'    => 'King',
       'first_name'     => 'Arthur',
       'favorite_color' => 'blue',
   );

   // de tabel waarin de rij zou moeten worden ingevoegd
   $table = 'round_table';

   // voeg de rij in en verkrijg de rij ID
   $rows_affected = $db->insert($table, $data);
   $last_insert_id = $db->lastInsertId();

   ?>
.. _zend.db.adapter.update:

Rijen updaten
-------------

Voor jouw gemak kan je de *update()* methode gebruiken om een UPDATE verklaring voor je te maken waaraan je dan de
data die moet worden geupdate kan binden. De aldus gebonden data heeft automatisch correcte quotes om te helpen SQL
injectie aanvallen te voorkomen.

Je kan een optionele WHERE clausule verstrekken om te determineren welke rijen moeten worden geupdate. (Merk op dat
de WHERE clausule geen gebonden parameter is, de waarden ervan moet je dus zelf correct quoten.)

.. code-block:: php
   :linenos:

   <?php

   //
   // UPDATE round_table
   //     SET favorite_color = "yellow"
   //     WHERE first_name = "Robin";
   //

   // maak a $db object, en dan...
   // de nieuwe waarden om te zetten in de update, in kolom => waarde formaat.
   $set = array (
       'favorite_color' => 'yellow',
   );

   // de tabel die moet worden geupdate
   $table = 'round_table';

   // de WHERE clausule
   $where = $db->quoteInto('first_name = ?', 'Robin');

   // update de tabel en verkrijg het aantal beïnvloede rijen
   $rows_affected = $db->update($table, $set, $where);

   ?>
.. _zend.db.adapter.delete:

Rijen Verwijderen
-----------------

Voor jouw gemak kan je de *delete()* methode gebruiken om een DELETE verklaring voor je te maken; je kan een
optionele WHERE clausule verstrekken om te definiëren welke rijen je wil verwijderen. (Merk op dat de WHERE
clausule geen gebonden parameter is, de waarden ervan moet je dus zelf correct quoten.)

.. code-block:: php
   :linenos:

   <?php

   //
   // DELETE FROM round_table
   //     WHERE first_name = "Patsy";
   //

   // maak een $db object, en dan...
   // de tabel waarvan rijen moeten worden verwijderd
   $table = 'round_table';

   // de WHERE clausule
   $where = $db->quoteInto('first_name = ?', 'Patsy');

   // update de tabel en verkrijg het aantal beïnvloede rijen
   $rows_affected = $db->delete($table, $where);

   ?>
.. _zend.db.adapter.fetch:

Rijen Halen
-----------

Alhoewel je de database direct kan ondervragen met de *query* methode is het meestal zo dat het enige wat je nodig
hebt is enkele rijen te selecteren en de resultaten terug te krijgen. De *fetch\*()* methodeserie doet dat voor
jou. Voor elk van de *fetch\*()* methodes geef je een SQL SELECT verklaring op; indien je benoemde plaatshouders
gebruikt in de verklaring moet je ook een array van bindwaarden doorgeven die dan met correcte quotes worden
omringd en in de verklaring worden opgenomen. De *fetch\*()* methodes zijn:

- *fetchAll()*

- *fetchAssoc()*

- *fetchCol()*

- *fetchOne()*

- *fetchPairs()*

- *fetchRow()*

.. code-block:: php
   :linenos:

   <?php

   // maak een $db object, en dan...

   // verkrijg alle kolommen van alle rijen als een opeenvolgende array
   $result = $db->fetchAll(
       "SELECT * FROM round_table WHERE noble_title = :title",
       array('title' => 'Sir')
   );

   // verkrijg all kolommen van alle rijen als een associatieve array
   // de eerste kolom wordt gebruikt als array key.
   $result = $db->fetchAssoc(
       "SELECT * FROM round_table WHERE noble_title = :title",
       array('title' => 'Sir')
   );

   // verkrijg de eerste kolom van elke teruggestuurde rij
   $result = $db->fetchCol(
       "SELECT first_name FROM round_table WHERE noble_title = :title",
       array('title' => 'Sir')
   );

   // verkrijg alleen de eerste waarde
   $result = $db->fetchOne(
       "SELECT COUNT(*) FROM round_table WHERE noble_title = :title",
       array('title' => 'Sir')
   );

   // verkrijg een serie van key/waarde-paren; de eerste kolom is
   // de key van de array, de tweede kolom is de waarde van de array
   $result = $db->fetchPairs(
       "SELECT first_name, favorite_color FROM round_table WHERE noble_title = :title",
       array('title' => 'Sir')
   );

   // verkrijg enkel de eerste rij die werd teruggestuurd
   $result = $db->fetchRow(
       "SELECT * FROM round_table WHERE first_name = :name",
       array('name' => 'Lancelot')
   );

   ?>

