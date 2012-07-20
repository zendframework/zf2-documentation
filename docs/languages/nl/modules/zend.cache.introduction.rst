.. _zend.cache.introduction:

Inleiding
=========

*Zend_Cache* verstrekt een standaard functie om eender welke data te "cachen".

Caching in het Zend Framework word door frontends uitgevoerd, terwijl cache records door backend adapters worden
opgeslagen (*File*, *Sqlite*, *Memcache*...) via een flexibel systeem van IDs en tags. Het gebruik van deze tags
laat toe eenvoudig bepaalde record types te verwijderen (bijvoorbeeld: "verwijder alle cache records gemarkeerd met
een bepaalde tag").

De kern van de *Zend_Cache_Core* module is standaard, flexibel en configurabel. Er bestaan echter cache frontends
voor specifieke doeleinden die *Zend_Cache_Core* uitbreiden: *Output*, *File*, *Function* en *Class*.

.. rubric:: Een frontend verkrijgen met *Zend_Cache::factory()*

*Zend_Cache::factory()* instantieert juiste objecten en bindt ze samen. In dit eerste voorbeeld zullen we *Core*
frontend gebruiken, samen met *File* backend.

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Cache.php';

   $frontendOptions = array(
      'lifeTime' => 7200, // cache levensduur van 2 uur
      'automaticSerialization' => true
   );

   $backendOptions = array(
       'cacheDir' => './tmp/' // Directory waar we de cache bestanden wegschrijven
   );

   // verkrijgen van een Zend_Cache_Core object
   $cache = Zend_Cache::factory('Core', 'File', $frontendOptions, $backendOptions);

   ?>
Nu we een frontend hebben kunnen we eender welk type data cachen (we activeerden serialisatie). We kunnen
bijvoorbeeld het resultaat van een zeer "dure" database query cachen. Nadat het in de cache is opgeslagen, is het
zelfs niet meer nodig een verbinding met de database te maken; records worden uit de cache gehaald en
gedeserialiseerd.

.. code-block::
   :linenos:
   <?php

   // $cache die in het vorige voorbeeld werd geïnitialiseerd

   // nagaan of de cache reeds bestaat:
   if(!$result = $cache->get('mijnresultaat')) {

       // geen cache; verbind met de database

       $db = Zend_Db::factory( [...] );

       $result = $db->fetchAll('SELECT * FROM enorme_tabel');

       $cache->save($result, 'mijnresultaat');

   } else {

       // cache bestaat! laat het weten
       echo "Dit komt uit de cache!\n\n";

   }

   print_r($result);

   ?>
.. rubric:: Output cachen met de *Zend_Cache* output frontend

We markeren secties waarin we output willen cachen door er een beetje conditionele logica aan toe te voegen. We
zetten de sectie tussen *start()* en *end()* methodes (dit wordt geïllustreerd in het eerste voorbeeld en is de
voornaamste strategie voor het cachen).

Tussen de twee methodes output je je data zoals gewoonlijk - alle output zal worden gecached als de uitvoering de
*end()* methode tegenkomt. Bij de volgende uitvoering zal de hele sectie worden overgeslagen ten voordele van het
verkrijgen van de data uit de cache (zolang de cache record geldig is).

.. code-block::
   :linenos:
   <?php

   $frontendOptions = array(
      'lifeTime' => 30,                  // cache levensduur van een halve minuut
      'automaticSerialization' => false  // dit is sowieso standaard
   );

   $backendOptions = array('cacheDir' => './tmp/');

   $cache = Zend_Cache::factory('Output', 'File', $frontendOptions, $backendOptions);

   // we geven een unieke id door aan de start() methode
   if(!$cache->start('mijnpagina')) {
       // output zoals gewoonlijk:

       echo 'Hallo wereld! ';
       echo 'Dit is gecached ('.time().') ';

       $cache->end(); // de output wordt opgeslagen en naar de browser gestuurd
   }

   echo 'Dit word nooit gecached ('.time().').';

   ?>
Merk op dat we het resultaat van *time()* tweemaal weergeven; dit is iets dynamisch om het voorbeeld te toetsen.
Probeer het voorbeeld verschillende malen uit te voeren; je zal merken dat het eerste nummer niet verandert,
terwijl het tweede verandert naargelang de tijd vordert. Dit komt omdat het eerste nummer samen met de andere
output in de cache werd opgeslaan. Na een halve minuut (we hebben de levensduur op 30 seconden gezet) moeten de
nummers opnieuw gelijk zijn omdat de cache record niet meer geldig is -- voor hij opnieuw word gecached. Je zou dit
in je browser of console moeten proberen.

.. note::

   Als je *Zend_Cache* gebruikt, let dan op de belangrijke cache id (doorgegeven aan *save()* en *start()*. Die
   moet uniek zijn voor elk deel data die je wil cachen, anders kunnen cache records die niets met elkaar te maken
   hebben elkaar uitwissen of, erger nog, afgebeeld worden in plaats van de ander.


