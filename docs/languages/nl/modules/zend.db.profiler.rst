.. _zend.db.profiler:

Zend_Db_Profiler
================

.. _zend.db.profiler.introduction:

Inleiding
---------

*Zend_Db_Profiler* kan worden geactiveerd om queries te profileren. Profielen bevatten de door de adapter
uitgevoerde queries evenals de tijd die nodig was om de queries uit te voeren. Dit laat inspectie van de
uitgevoerde queries toe zonder bijkomende debug code aan de klassen toe te voegen. Geavanceerd gebruik laat de
ontwikkelaar filteren welke queries geprofileerd worden.

Activeren van de profiler kan op twee wijzen gebeuren: een directive aan de adapter constructor doorgeven, of door
de adapter te vragen het later te activeren.

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Db.php';

   $params = array (
       'host'     => '127.0.0.1',
       'username' => 'arthur',
       'password' => '******',
       'dbname'   => 'camelot',
       'profiler' => true  // profiler activeren; naar false zetten om te de-activeren (standaard)
   );

   $db = Zend_Db::factory('PDO_MYSQL', $params);

   // profiler de-activeren:
   $db->getProfiler()->setEnabled(false);

   // profiler activeren:
   $db->getProfiler()->setEnabled(true);
   ?>
.. _zend.db.profiler.using:

De Profiler Gebruiken
---------------------

De profiler kan op eender welk moment worden aangeroepen via de *getProfiler()* methode van de adapter:

.. code-block::
   :linenos:
   <?php
   $profiler = $db->getProfiler();
   ?>
Dit geeft een objectinstantie van *Zend_Db_Profiler* terug. Met deze instantie kan de ontwikkelaar je queries
inspecteren via verscheidene methodes:

- *getTotalNumQueries()* geeft het totaal aantal queries weer die werden geprofileerd.

- *getTotalElapsedSecs()* geeft het totaal aantal seconden weer die nodig waren om alle queries uit te voeren.

- *getQueryProfiles()* geeft een array van alle query profielen weer.

- *getLastQueryProfile()* geeft het laatste (meest recente) query profiel weer, ongeacht of de query volledig
  uitgevoerd is (indien niet, zal de eindtijd null zijn)

- *clear()* vaagt alle query profielen van de lijst weg.

De teruggegeven waarde van *getLastQueryProfile()* en de individuele elementen van *getQueryProfiles()* zijn
*Zend_Db_Profiler_Query* objecten die je de mogelijkheid geven om de individuele queries zelf te inspecteren:

- *getQuery()* geeft de SQL tekst van de query terug.

- *getElapsedSecs()* geeft het aantal seconden terug die de query nam om uitgevoerd te worden.

De informatie die *Zend_Db_Profiler* verstrekt is handig voor het profileren van opstoppers in programma's en voor
het debuggen van gebruikte queries. Bijvoorbeeld, om de exacte laatst uitgevoerde query te zien:

.. code-block::
   :linenos:
   <?php
   $query = $profiler->getLastQueryProfile();

   echo $query->getQuery();
   ?>
Misschien doet een pagina er lang over om afgebeeld te worden; gebruik dan de profiler om eerst het totaal aantal
seconden van alle queries te verkrijgen, en dan de queries één voor één te doorlopen om uit te vinden welke het
langste duurde:

.. code-block::
   :linenos:
   <?php
   $totalTime    = $profiler->getTotalElapsedSecs();
   $queryCount   = $profiler->getTotalNumQueries();
   $longestTime  = 0;
   $longestQuery = null;

   foreach ($profiler->getQueryProfiles() as $query) {
       if ($query->getElapsedSecs() > $longestTime) {
           $longestTime  = $query->getElapsedSecs();
           $longestQuery = $query->getQuery();
       }
   }

   echo $queryCount . ' queries uitgevoerd in ' . $totalTime . ' seconden' . "\n";
   echo 'Gemiddelde query tijd: ' . $totalTime / $queryCount . ' seconden' . "\n";
   echo 'Queries per seconde: ' . $queryCount / $totalTime . "\n";
   echo 'Langste query tijd: ' . $longestTime . "\n";
   echo "Langste query: \n" . $longestQuery . "\n";
   ?>
.. _zend.db.profiler.advanced:

Geavanceerd Profiler Gebruik
----------------------------

Bovenop query inspectie staat de profiler je ook toe de queries die worden geprofileerd te filteren. De volgende
methodes kunnen op een *Zend_Db_Profiler* instantie worden uitgevoerd:

.. _zend.db.profiler.advanced.filtertime:

Filteren op afgelopen tijd
^^^^^^^^^^^^^^^^^^^^^^^^^^

*setFilterElapsedSecs()* laat je toe om een minimum query tijd te definiëren voordat een query wordt geprofileerd.
Geef een null tijd aan de methode door om de filter te verwijderen.

.. code-block::
   :linenos:
   <?php
   // Profileer alleen queries die langer dan 5 seconden duren:
   $profiler->setFilterElapsedSecs(5);

   // Profileer alle queries ongeacht de uitvoeringstijd:
   $profiler->setFilterElapsedSecs(null);
   ?>
.. _zend.db.profiler.advanced.filtertype:

Filteren per type query
^^^^^^^^^^^^^^^^^^^^^^^

*setFilterQueryType()* laat je toe welk type queries moeten worden geprofileerd; om meerdere types te profileren
geef je ze met een logische OR door. Query types zijn als de volgende *Zend_Db_Profiler* constanten gedefinieerd:

- *Zend_Db_Profiler::CONNECT*: verbindingsoperaties, of het selecteren van een database.

- *Zend_Db_Profiler::QUERY*: standaard database queries die met geen ander type query overeenkomen.

- *Zend_Db_Profiler::INSERT*: eender welke query die data aan de database toevoegt, meestal SQL INSERT.

- *Zend_Db_Profiler::UPDATE*: eender welke query die bestaande data wijzigt, meestal SQL UPDATE.

- *Zend_Db_Profiler::DELETE*: eender welke query die bestaande data verwijdert, meestal SQL DELETE.

- *Zend_Db_Profiler::SELECT*: eender welke query die bestaande data opvraagt, meestal SQL SELECT.

- *Zend_Db_Profiler::TRANSACTION*: eender welke transactionele operatie, zoals een transactie starten, bevestigen
  (commit) of annuleren (rollback).

Zoals bij *setFilterElapsedSecs()* kan je elke bestaande filter verwijderen door *null* als enig argument door te
geven.

.. code-block::
   :linenos:
   <?php
   // profileer enkel SELECT queries
   $profiler->setFilterQueryType(Zend_Db_Profiler::SELECT);

   // profileer SELECT, INSERT, en UPDATE queries
   $profiler->setFilterQueryType(Zend_Db_Profiler::SELECT | Zend_Db_Profiler::INSERT | Zend_Db_Profiler::UPDATE);

   // profileer DELETE queries (zodat we kunnnen uitvissen waarom data maar blijft verdwijnen)
   $profiler->setFilterQueryType(Zend_Db_Profiler::DELETE);

   // Alle filters verwijderen
   $profiler->setFilterQueryType(null);
   ?>
.. _zend.db.profiler.advanced.getbytype:

Profielen per type query verkrijgen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Het gebruik van *setFilterQueryType()* kan het aantal gegenereerde profielen beperken. Soms is het echter handiger
om alle profielen te behouden, maar enkel die te bekijken die je op dat moment nodig hebt. Een andere eigenschap
van *getQueryProfiles()* is dat het kan filteren terwijl de code loopt, door het een type query (of een logische
combinatie van querytypes) als eerste argument door te geven; zie :ref:` <zend.db.profiler.advanced.filtertype>`
voor een lijst van de querytype constanten.

.. code-block::
   :linenos:
   <?php
   // Alleen SELECT query profielen verkrijgen
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::SELECT);

   // Alleen SELECT, INSERT, en UPDATE query profielen verkrijgen
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::SELECT | Zend_Db_Profiler::INSERT | Zend_Db_Profiler::UPDATE);

   // Alleen DELETE query profielen verkrijgen (zodat we kunnen nagaan waarom data maar blijft verdwijnen)
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::DELETE);
   ?>

