.. _zend.db.select:

Zend_Db_Select
==============

.. _zend.db.select.introduction:

Inleiding
---------

Zend_Db_Select is een werktuig dat je helpt SQL SELECT verklaringen te bouwen op een manier waardoor deze niet
database gebonden zijn. Het kan uiteraard niet perfect zijn, maar het helpt je een goed stuk om je queries
database-onafhankelijk te maken, en daardoor overdraagbaar van een database naar een andere. Bovendien helpt het je
je queries beter bestand te maken tegen SQL injectie aanvallen.

De gemakkelijkste manier om een instantie van de Zend_Db_Select te verkrijgen is het gebruik van de
Zend_Db_Adapter::select() methode.

.. code-block::
   :linenos:
   <?php

   require_once 'Zend/Db.php';

   $params = array (
       'host'     => '127.0.0.1',
       'username' => 'gweniver',
       'password' => '******',
       'dbname'   => 'camelot'
   );

   $db = Zend_Db::factory('PDO_MYSQL', $params);

   $select = $db->select();
   // $select is nu een Zend_Db_Select_PdoMysql object

   ?>
Dan maak je een SELECT query via dat object en zijn methodes en die maakt dan een string die je aan Zend_Db_Adapter
kan doorgeven om queries of ophalingen uit te voeren.

.. code-block::
   :linenos:
   <?php

   //
   // SELECT *
   //     FROM round_table
   //     WHERE noble_title = "Sir"
   //     ORDER BY first_name
   //     LIMIT 10 OFFSET 20
   //

   // je kan een iteratieve stijl gebruiken...
   $select->from('round_table', '*');
   $select->where('noble_title' = ?', 'Sir');
   $select->order('first_name');
   $select->limit(10,20);

   // ...of een "vloeiende" stijl
   $select->from('round_table', '*')
          ->where('noble_title = ?', 'Sir')
          ->order('first_name')
          ->limit(10,20);

   // in ieder geval, het resultaat ophalen
   $sql = $select->__toString();
   $result = $db->fetchAll($sql);

   // een andere manier is om het $select object zelf door te geven;
   // Zend_Db_Adapter Is slim genoeg om de __toString() methode op
   // Zend_Db_Select objecten toe te passen om de querystring te
   // verkrijgen.
   $result = $db->fetchAll($select);

   ?>
Je kan ook gebonden parameters gebruiken in je queries plaats van ze één per één te quoten.

.. code-block::
   :linenos:
   <?php

   //
   // SELECT *
   //     FROM round_table
   //     WHERE noble_title = "Sir"
   //     ORDER BY first_name
   //     LIMIT 10 OFFSET 20
   //

   $select->from('round_table', '*')
          ->where('noble_title = :title')
          ->order('first_name')
          ->limit(10,20);

   // in ieder geval, het resultaat ophalen door de parameters te binden
   $params = array('title' => 'Sir');
   $result = $db->fetchAll($select, $params);

   ?>
.. _zend.db.select.fromcols:

Kolommen FROM een tabel
-----------------------

Om kolommen van een bepaalde tabel de selecteren gebruik je de from() methode, de tabel en de kolommen die je ervan
wil verkijgen specificerend. Je kan zowel tabel als kolom aliassen gebruiken en je kan from() zoveel gebruiken als
nodig is.

.. code-block::
   :linenos:
   <?php

   // maak een $db object en neem aan dat we de Mysql adapter gebruiken
   $select = $db->select();

   // SELECT a, b, c FROM some_table
   $select->from('some_table', 'a, b, c');
   // hetzelfde, maar anders:
   $select->from('some_table', array('a', 'b', 'c');

   // SELECT bar.col FROM foo AS bar
   $select->from('foo AS bar', 'bar.col');

   // SELECT foo.col AS col1, bar.col AS col2 FROM foo, bar
   $select->from('foo', 'foo.col AS col1');
   $select->from('bar', 'bar.col AS col2');

   ?>
.. _zend.db.select.joincols:

Kolommen van geJOINde tabellen
------------------------------

Om kolommen van gejoinde tabellen te selecteren kan je de join() methode gebruiken. Geef eerst de gejoinde
tabelnaam op, dan de join voorwaarde en uiteindelijk de kolommen die je van de join wil terugkrijgen. Je kan join()
zoveel maal gebruiken als dat nodig is.

.. code-block::
   :linenos:
   <?php

   // maak een $db object en neem aan dat we de Mysql adapter gebruiken
   $select = $db->select();

   //
   // SELECT foo.*, bar.*
   //     FROM foo
   //     JOIN bar ON foo.id = bar.id
   //
   $select->from('foo', '*');
   $select->join('bar', 'foo.id = bar.id', '*');

   ?>
Voor het moment is alleen de JOIN syntax ondersteund; geen LEFT JOINs, RIGHT JOINs enz. Latere versies zullen deze
concepten in een database-onafhankelijke manier ondersteunen.

.. _zend.db.select.where:

WHERE voorwaarden
-----------------

Om WHERE voorwaarden toe te voegen gebruik je de where() methode. Je kan een gewone string doorgeven, of een string
met de vraagteken plaatshouder en een waarde die er moet worden ingequote (de waarde zal in qoutes worden gewikkeld
door Zend_Db_Adapter::quoteInto() te gebruiken.

Meerdere aanvragen aan where() zal de voorwaarden aan elkaar AND-en; als je een OR voorwaarde nodig hebt, gebruik
dan orWhere().

.. code-block::
   :linenos:
   <?php

   // maak a $db object en verkrijg een SELECT werktuig.
   $select = $db->select();

   //
   // SELECT *
   //     FROM round_table
   //     WHERE noble_title = "Sir"
   //     AND favorite_color = "yellow"
   //
   $select->from('round_table', '*');
   $select->where('noble_title = "Sir"); // ingebedde waarde
   $select->where('favorite_color = ?', 'yellow'); // waarde met quotes

   //
   // SELECT *
   //     FROM foo
   //     WHERE bar = "baz"
   //     OR id IN("1", "2", "3")
   //
   $select->from('foo', '*');
   $select->where('bar = ?', 'baz');
   $select->orWhere('id IN(?)', array(1, 2, 3);

   ?>
.. _zend.db.select.group:

GROUP BY clausule
-----------------

Om rijen te groeperen gebruik je de group() methode zoveel maal als dat nodig is.

.. code-block::
   :linenos:
   <?php

   // maak a $db object en verkrijg een SELECT werktuig.
   $select = $db->select();

   //
   // SELECT COUNT(id)
   //     FROM foo
   //     GROUP BY bar, baz
   //
   $select->from('foo', 'COUNT(id)');
   $select->group('bar');
   $select->group('baz');

   // een gelijkaardige oproep van group():
   $select->group('bar, baz');

   // een andere gelijkaardige oproep van group():
   $select->group(array('bar', 'baz'));

   ?>
.. _zend.db.select.having:

HAVING voorwaarden
------------------

Om HAVING voorwaarden aan de selectieregels toe te voegen gebruik je de having() methode. Deze methode heeft een
identieke werking als de where() methode.

Indien je having() meerdere malen oproept worden de voorwaarden aaneen ge-AND; om OR voorwaarden te verkrijgen
gebruik je orHaving().

.. code-block::
   :linenos:
   <?php

   // maak a $db object en verkrijg een SELECT werktuig.
   $select = $db->select();

   //
   // SELECT COUNT(id) AS count_id
   //     FROM foo
   //     GROUP BY bar, baz
   //     HAVING count_id > "1"
   //
   $select->from('foo', 'COUNT(id) AS count_id');
   $select->group('bar, baz');
   $select->having('count_id > ?', 1);

   ?>
.. _zend.db.select.order:

ORDER BY clausule
-----------------

Om kolommen te ordenen gebruik je de order() methode zoveel maal als dat nodig is.

.. code-block::
   :linenos:
   <?php

   // maak a $db object en verkrijg een SELECT werktuig.
   $select = $db->select();

   //
   // SELECT * FROM round_table
   //     ORDER BY noble_title DESC, first_name ASC
   //
   $select->from('round_table', '*');
   $select->order('noble_title DESC');
   $select->order('first_name');

   // een gelijkaardige oproep van order():
   $select->order('noble_title DESC, first_name');

   // een andere gelijkaardige oproep van order():
   $select->order(array('noble_title DESC', 'first_name'));

   ?>
.. _zend.db.select.limit:

LIMIT per Count en Offset
-------------------------

Zend_Db_Select ondersteunt een database onafhankelijke LIMIT clausule. Voor vele databases, zoals MySQL en
PostgreSQL is dit relatief eenvoudig omdat ze de "LIMIT :count [OFFSET :offset]" syntax ondersteunen.

Voor andere databases, zoals Microsoft SQL en Oracle is dit niet zo eenvoudig omdat zij helemaal geen LIMIT
clausule ondersteunen. MS-SQL heeft alleen een TOP-clausule, en voor Oracle moet de query op een specifieke manier
worden geschreven om LIMIT te emuleren. Vanwege de innerlijke werking van Zend_Db_Select kunnen we de SELECT query
on-the-fly herschrijven om de LIMIT functionaliteit van de voornoemde open source database systemen te emuleren.

Om het teruggestuurde resultaat te LIMITeren per count en offset gebruik je de limit() methode met een count en een
optionele offset.

.. code-block::
   :linenos:
   <?php

   // eerst een eenvoudige "LIMIT :count"
   $select = $db->select();
   $select->from('foo', '*');
   $select->order('id');
   $select->limit(10);

   //
   // In MySQL/PostgreSQL/SQLite wordt dit vertaald naar:
   //
   // SELECT * FROM foo
   //     ORDER BY id ASC
   //     LIMIT 10
   //
   // Maar in Microsoft SQL wordt dit vertaald naar:
   //
   // SELECT TOP 10 * FROM FOO
   //     ORDER BY id ASC
   //
   //

   // nu een meer complexe "LIMIT :count OFFSET :offset"
   $select = $db->select();
   $select->from('foo', '*');
   $select->order('id');
   $select->limit(10, 20);

   //
   // In MySQL/PostgreSQL/SQLite wordt dit vertaald naar:
   //
   // SELECT * FROM foo
   //     ORDER BY id ASC
   //     LIMIT 10 OFFSET 20
   //
   // Maar in Microsoft SQL die offset niet ondersteund, wordt dit vertaald
   // naar iets als dit:
   //
   // SELECT * FROM (
   //     SELECT TOP 10 * FROM (
   //         SELECT TOP 30 * FROM foo ORDER BY id DESC
   //     ) ORDER BY id ASC
   // )
   //
   // Zend_Db_Adapter doet de vertaling van de query automatisch voor jou
   //

   ?>
.. _zend.db.select.paging:

LIMIT per Pagina en Count
-------------------------

Zend_Db_Select biedt eveneens pagina-gebaseerde limits. Indien je een zeker aantal "pagina's" resultaten wil
ophalen gebruik je de limitPage() methode; geef eerste het paginanummer aan en dan het aantal rijen dat op elke
pagina moet worden afgebeeld.

.. code-block::
   :linenos:
   <?php

   // bouw de basis select...
   $select = $db->select();
   $select->from('foo', '*');
   $select->order('id');

   // ... en limit naar pagina 3 en elke pagina heeft 10 rijen af te beelden
   $select->limitPage(3, 10);

   //
   // In MySQL/PostgreSQL/SQLite wordt dit vertaald naar:
   //
   // SELECT * FROM foo
   //     ORDER BY id ASC
   //     LIMIT 10 OFFSET 20
   //

   ?>

