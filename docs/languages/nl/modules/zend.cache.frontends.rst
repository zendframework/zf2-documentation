.. EN-Revision: none
.. _zend.cache.frontends:

Zend_Cache frontends
====================

.. _zend.cache.core:

Zend_Cache_Core
---------------

.. _zend.cache.core.introduction:

Introductie
^^^^^^^^^^^

*Zend_Cache_Core* is een speciale frontend omdat het de kern van de module is. Het is een generieke cache frontend
en wordt uitgebreid door andere classes.

.. note::

   Alle frontends erven van *Zend_Cache_Core* zodat zijn methodes en opties (zoals hieronder beschreven) ook
   beschikbaar zijn in andere frontends, dus ze zullen hier niet worden gedocumenteerd.

.. _zend.cache.core.options:

Beschikbare opties
^^^^^^^^^^^^^^^^^^

Deze opties worden doorgegeven aan de factory methode zoals hierboven gedemonstreerd.

.. table:: Beschikbare opties

   +-----------------------+---------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Optie                  |Data Type|Standaard Waarde|Omschrijving                                                                                                                                                                                                                                                                                     |
   +=======================+=========+================+=================================================================================================================================================================================================================================================================================================+
   |caching                |boolean  |true            |zet de caching aan of uit (kan handig zijn om te debuggen)                                                                                                                                                                                                                                       |
   +-----------------------+---------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |lifeTime               |int      |3600            |Levensduur van de cache (in seconden), wanneer de waarde null is, blijft de cache altijd geldig.                                                                                                                                                                                                 |
   +-----------------------+---------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |logging                |boolean  |false           |Wanneer dit op true staat, wordt logging via Zend_Log aangezet (maar wordt het systeem trager)                                                                                                                                                                                                   |
   +-----------------------+---------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |writeControl           |boolean  |true            |Zet schrijfcontrole aan (de cache wordt direct na schrijven gelezen om corrupte records te herkennen), door writeControl aan te zetten zal de cache iets trager wegschrijven maar het lezen wordt niet trager (het kan sommige corrupte cache bestanden herkennen maar is geen perfecte controle)|
   +-----------------------+---------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |automaticSerialization |boolean  |false           |Zet de automatische serialisatie aan of uit, dit kan worden gebruikt om direct informatie op te slaan dat geen string is (maar het is trager)                                                                                                                                                    |
   +-----------------------+---------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |automaticCleaningFactor|int      |0               |Stel het automatische opschoonsysteem in (garbage collector): 0 betekent geen automatische opschoning, 1 betekent systematisch cache opschonen en x > 1 betekent willekeurig opschonen 1 keer per x schrijf operaties.                                                                           |
   +-----------------------+---------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.core.examples:

Voorbeelden
^^^^^^^^^^^

Een voorbeeld wordt gegeven aan het begin van de handleiding.

Wanneer je alleen strings in de cache wil opslaan (want met "automaticSerialization" is het mogelijk ook sommige
booleans op te slaan), kan je een compactere constructie gebruiken:

.. code-block:: php
   :linenos:

   <?php

   // we gaan er vanuit dat je $cache al hebt

   $id = 'mijnGroteLoop'; // cache id van "wat we willen cachen"

   if (!($data = $cache->get($id))) {
       // cache miss

       $data = '';
       for ($i = 0; $i < 10000; $i++) {
           $data = $data . $i;
       }

       $cache->save($data);

   }

   // [...] doe iets met $data (echo het, stuur het door enz.)

   ?>
Als je meerdere blokken of data instanties wilt cachen, is het idee hetzelfde:

.. code-block:: php
   :linenos:

   <?php

   // Zorg ervoor dat je unieke identifiers hebt:
   $id1 = 'foo';
   $id2 = 'bar';

   // blok 1
   if (!($data = $cache->get($id1))) {
       // cache miss

       $data = '';
       for ($i=0;$i<10000;$i++) {
           $data = $data . $i;
       }

       $cache->save($data);

   }
   echo($data);

   // Dit wordt niet door de cache beïnvloed
   echo('NOOIT GECACHED! ');

   // blok 2
   if (!($data = $cache->get($id2))) {
       // cache miss

       $data = '';
       for ($i=0;$i<10000;$i++) {
           $data = $data . '!';
       }

       $cache->save($data);

   }
   echo($data);

   ?>
.. _zend.cache.frontend.output:

Zend_Cache_Frontend_Output
--------------------------

.. _zend.cache.frontend.output.introduction:

Inleiding
^^^^^^^^^

*Zend_Cache_Frontend_Output* is een output-vangend frontend. Het gebruikt output buffering in PHP om alles tussen
zijn *start()* en *end()* methodes te vangen.

.. _zend.cache.frontend.output.options:

Beschikbare opties
^^^^^^^^^^^^^^^^^^

Dit frontend heeft geen specifieke opties andere dan deze van *Zend_Cache_Core*.

.. _zend.cache.frontend.output.examples:

Voorbeelden
^^^^^^^^^^^

Een voorbeeld is in het begin van de handleiding gegeven. Hier is het met enkele kleine veranderingen:

.. code-block:: php
   :linenos:

   <?php

   // indien het een cache miss is, output buffering inroepen
   if(!$cache->start('mijnpagina')):

   // alles weergeven zoals gewoonlijk
   echo 'Dag wereld! ';
   echo 'Dit is gecached ('.time().') ';

   $cache->end(); // einde van output buffering
   endif;

   echo 'Dit is nooit gecached ('.time().').';

   ?>
Deze vorm gebruiken maakt het eenvoudig om output caching op te zetten in je reeds werkende projekt met geen of
weinig herschrijven van de code.

.. _zend.cache.frontend.function:

Zend_Cache_Frontend_Function
----------------------------

.. _zend.cache.frontend.function.introduction:

Inleiding
^^^^^^^^^

*Zend_Cache_Frontend_Function* cached het resultaat van functie oproepen. Het heeft één enkele hoofdmethode
genaam *call()* die de functienaam en parameters voor de oproep in een array aanvaard.

.. _zend.cache.frontend.function.options:

Beschikbare opties
^^^^^^^^^^^^^^^^^^

.. table:: Beschikbare opties

   +------------------+---------+----------------+-------------------------------------------------------------+
   |Optie             |Data Type|Standaard Waarde|Omschrijving                                                 |
   +==================+=========+================+=============================================================+
   |cacheByDefault    |boolean  |true            |indien true zullen functie oproepen standaard worden gecached|
   +------------------+---------+----------------+-------------------------------------------------------------+
   |cachedFunctions   |array    |                |functienamen die altijd zullen worden gecached               |
   +------------------+---------+----------------+-------------------------------------------------------------+
   |nonCachedFunctions|array    |                |functienamen die nooit mogen worden gecached                 |
   +------------------+---------+----------------+-------------------------------------------------------------+

.. _zend.cache.frontend.function.examples:

Voorbeelden
^^^^^^^^^^^

De *call()* functie gebruiken is hetzelfde als *call_user_func_array()* in PHP:

.. code-block:: php
   :linenos:

   <?php

   $cache->call('heelZwareFunctie', $params);

   # $params is een array
   # bijvoorbeeld om heelZwareFunctie(1, 'foo', 'bar') op te roepen (met caching), zal je
   # $cache->call('heelZwareFunctie', array(1, 'foo', 'bar')) gebruiken

   ?>
*Zend_Cache_Frontend_Function* is slim genoeg om zowel de return waarde van de functie als zijn interne output te
cachen.

.. note::

   Je kan eender welke ingebouwde of gebruikerfunctie doorgeven, behalve *array()*, *echo()*, *empty()*, *eval()*,
   *exit()*, *isset()*, *list()*, *print()* and *unset()*.

.. _zend.cache.frontend.class:

Zend_Cache_Frontend_Class
-------------------------

.. _zend.cache.frontend.class.introduction:

Inleiding
^^^^^^^^^

*Zend_Cache_Frontend_Class* verschilt van *Zend_Cache_Frontend_Function* omdat het toelaat een object en statische
methode oproepen te cachen.

.. _zend.cache.frontend.class.options:

Beschikbare opties
^^^^^^^^^^^^^^^^^^

.. table:: Beschikbare opties

   +----------------------+---------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Optie                 |Data Type|Standaard Waarde|Omschrijving                                                                                                                                                                                  |
   +======================+=========+================+==============================================================================================================================================================================================+
   |cachedEntity (vereist)|mixed    |                |Indien je een klassenaam doorgeeft, zullen we een abstracte klasse cachen en alleen statische oproepen gebruiken; indien je een object doorgeeft, zullen we de methodes van het object cachen.|
   +----------------------+---------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cacheByDefault        |boolean  |true            |Indien true zullen oproepen standaard worden gecached                                                                                                                                         |
   +----------------------+---------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cachedMethods         |array    |                |namen van methodes die altijd zullen worden gecached                                                                                                                                          |
   +----------------------+---------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |nonCachedMethods      |array    |                |namen van methodes die nooit zullen worden gecached                                                                                                                                           |
   +----------------------+---------+----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.frontend.class.examples:

Voorbeelden
^^^^^^^^^^^

Bijvoorbeeld, om statische oproepen te cachen :

.. code-block:: php
   :linenos:

   <?php

   class test {

       # Statische methode
       public static function foobar($param1, $param2) {
           echo "foobar_output($param1, $param2)";
           return "foobar_return($param1, $param2)";
       }

   }

   // [...]
   $frontendOptions = array(
       'cachedEntity' => 'test' // De naam van de klasse
   );
   // [...]

   # De gecachte oproep
   $res = $cache->foobar('1', '2');

   ?>
Om klassieke methode oproepen te cachen :

.. code-block:: php
   :linenos:

   <?php

   class test {

       private $_string = 'hoi !';

       public function foobar2($param1, $param2) {
           echo($this->_string);
           echo "foobar2_output($param1, $param2)";
           return "foobar2_return($param1, $param2)";
       }

   }

   // [...]
   $frontendOptions = array(
       'cachedEntity' => new test() // Een instantie van de klasse
   );
   // [...]

   # De gecachte oproep
   $res = $cache->foobar2('1', '2');

   ?>
.. _zend.cache.frontends.file:

Zend_Cache_Frontend_File
------------------------

.. _zend.cache.frontends.file.introduction:

Inleiding
^^^^^^^^^

*Zend_Cache_Frontend_File* is een frontend dat bestuurd word door de wijzigingstijd van een "meesterbestand". Het
is zeer interessant voor voorbeelden in configuratie of template problemen.

Bijvoorbeeld, je hebt een XML configuratiebestand dat door een functie wordt ingelezen die een "config object"
teruggeeft (zoals met *Zend_Config*). Met *Zend_Cache_Frontend_File* kan je "config object" in de cache opslaan (om
te vermijden dat je het XML bestand elke keer inleest) maar met een soort van sterke afhankelijkheid met het
"meesterbestand". Dus, indien het XML configuratiebestand wordt gewijzigd wordt de cache onmiddellijk invalide.

.. _zend.cache.frontends.file.options:

Beschikbare opties
^^^^^^^^^^^^^^^^^^

.. table:: Beschikbare opties

   +--------------------+---------+----------------+-----------------------------------------------+
   |Optie               |Data Type|Standaard Waarde|Omschrijving                                   |
   +====================+=========+================+===============================================+
   |masterFile (vereist)|string   |                |het complete pad en naam van het meesterbestand|
   +--------------------+---------+----------------+-----------------------------------------------+

.. _zend.cache.frontends.file.examples:

Voorbeelden
^^^^^^^^^^^

Het gebruik van dit frontend is hetzelfde als dat van *Zend_Cache_Core*. Er is geen nood aan een specifiek
voorbeeld - het enige dat er te doen is, is het definiëren van *masterFile* bij het gebruik van de factory.

.. _zend.cache.frontends.page:

Zend_Cache_Frontend_Page
------------------------

.. _zend.cache.frontends.page.introduction:

inleiding
^^^^^^^^^

*Zend_Cache_Frontend_Page* is net als *Zend_Cache_Frontend_Output* maar werd ontworpen voor een volledige pagina.
Het is onmogelijk om *Zend_Cache_Frontend_Page* te gebruiken om een enkel blok te cachen.

Anderzijds word "cache id" automatisch berekend met *$_SERVER['REQUEST_URI']* en (afhankelijk van de opties)
*$_GET*, *$_POST*, *$_SESSION*, *$_COOKIE*, *$_FILES*. Bovendien hoef je slechts één methode op te roepen
(*start()*) want de *end()* oproep is volledig automatisch bij het einde van de pagina.

Het is niet geïmplementeerd voor het ogenblik, maar we hebben plannen om een HTTP conditioneel systeem bij te
voegen om bandbreedte te sparen (het systeem zal een HTTP 304 Not Modified header zenden indien de browser cache
word aangesproken en indien de browser reeds de goede versie heeft).

.. note::

   ) Zend_Cache_Frontend_Page is echt "alpha stuff" en moet later verder worden verbeterd.

.. _zend.cache.frontends.page.options:

Beschikbare opties (voor deze frontend van de Zend_Cache factory)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. table:: Beschikbare opties

   +--------------------------------------------------+---------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Optie                                             |Data Type|Standaard Waarde|Omschrijving                                                                                                                                                                                                             |
   +==================================================+=========+================+=========================================================================================================================================================================================================================+
   |httpConditional                                   |boolean  |false           |gebruik het httpConditional systeem (momenteel niet geïmplementeerd)                                                                                                                                                     |
   +--------------------------------------------------+---------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cacheWith{Get,Post,Session,Files,Cookie}Variables |boolean  |false           |indien true blijft de cache aan zelfs indien er enige variabelen in de overeenkomende superglobal array zijn indien false is de cache af indien er enige variabelen in de overeenkomende superglobal array zijn          |
   +--------------------------------------------------+---------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |makeIdWith{Get,Post,Session,Files,Cookie}Variables|boolean  |true            |indien true moeten we de inhoud van de overeenkomstige superglobal array gebruiken om een cache id aan te maken indien false zal de cache id niet afhankelijk zijn van de inhoud van de overeenkomstige superglobal array|
   +--------------------------------------------------+---------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.frontends.page.examples:

Voorbeelden
^^^^^^^^^^^

Het gebruik van Zend_Cache_Frontend_Page is echt eenvoudig :

.. code-block:: php
   :linenos:

   <?php

   // [...] // require, configuratie en factory

   $cache->start();
   # indien de cache wordt aangesproken wordt het resultaat naar de browser gestuurd en stopt het script hier

   // rest van de pagina ...

   ?>

