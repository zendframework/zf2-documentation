.. _zend.search.lucene.queries:

Query Types
===========

.. _zend.search.lucene.queries.term-query:

Term Query
----------

Term queries zijn bedoeld voor het zoeken met een enkele term.

Query string:

.. code-block::
   :linenos:

       $hits = $index->find('word1');

of

Query opbouw door API:

.. code-block::
   :linenos:
   <?php

       $term  = new Zend_Search_Lucene_Index_Term('word1');
       $query = new Zend_Search_Lucene_Search_Query_Term($term);
       $hits  = $index->find($query);

   ?>
.. _zend.search.lucene.queries.multiterm-query:

Multi-Term Query
----------------

Multi term queries zijn bedoeld voor het zoeken op een set met termen.

Elke term in een set kan gedefinieerd worden als noodzakelijk, verboden of geen van beiden (optioneel).



   - noodzakelijk betekent dat documenten waar de term niet in voorkomt, niet in het resultaat terugkomen;

   - verboden betekent dat documenten waar deze term wel in voorkomt niet in het resultaat terugkomen;

   - geen van beiden betekent dat de term niet verboden is voor documenten, maar de term ook niet noodzakelijk is.
     Een document moet in dit geval minimaal een term bevatten om in het resultaat terug te komen.



Dit betekent dat wanneer een optionele term aan een query wordt toegevoerd met noodzakelijke termen, de documenten
in het resultaat hetzelfde blijven, maar documenten waarin de optionele term gevonden word bovenaan de result set
komen te staan.

Beide zoekmethodes kunnen worden gebruikt voor multiterm zoekopdrachten.

Query string:

.. code-block::
   :linenos:
   <?php

   $hits = $index->find('+word1 author:word2 -word3');

   ?>


   - '+' word gebruikt voor een noodzakelijke term.

   - '-' word gebruikt voor een verboden term.

   - 'field:' prefix word gebruikt om een document veld aan te geven bij het zoeken. Wanneer het niet wordt
     ingegeven, wordt 'contents' gebruikt.



of

Query opbouw door API:

.. code-block::
   :linenos:
   <?php

       $query = new Zend_Search_Lucene_Search_Query_MultiTerm();

       $query->addTerm(new Zend_Search_Lucene_Index_Term('word1'), true);
       $query->addTerm(new Zend_Search_Lucene_Index_Term('word2'), null);
       $query->addTerm(new Zend_Search_Lucene_Index_Term('word3'), false);

       $hits  = $index->find($query);

   ?>
*$signs* array bevat informatie over het type term:

   - true word gebruikt om een noodzakelijke term te definieren.

   - false word gebruikt om een verboden term te definieren.

   - null word gebruikt om geen noodzakelijk en geen verboden term te definieren.



.. _zend.search.lucene.queries.phrase-query:

Phrase Query
------------

Phrase Queries zijn bedoeld voor het zoeken op zinnen (uitdrukkingen?).

Phrase Queries zijn erg flexibel en staan toe om te zoeken op zowel exacte als 'slordige' zinnen. Zinnen kunnen ook
gaten of termen bevatten op bepaalde plaatsen. (Dit kan door de Analyser worden aangemaakt voor verschillende
doeleinden. Voorbeeld: Een term kan gedupliceerd worden om een bepaalde term extra gewicht te geven of
verschillende synoniemen kunnen op een plek worden geplaatst). De volgende phrase queries kunnen alleen door de API
worden aangemaakt:

.. code-block::
   :linenos:
   <?php
   $query1 = new Zend_Search_Lucene_Search_Query_Phrase();

   // Voeg 'word1' op relatieve positie 0 toe.
   $query1->addTerm(new Zend_Search_Lucene_Index_Term('word1'));

   // Voeg 'word2' op relatieve positie 1 toe.
   $query1->addTerm(new Zend_Search_Lucene_Index_Term('word2'));

   // Voeg 'word3' op relatieve positie 3 toe.
   $query1->addTerm(new Zend_Search_Lucene_Index_Term('word3'), 3);

   ...

   $query2 = new Zend_Search_Lucene_Search_Query_Phrase(
                   array('word1', 'word2', 'word3'), array(0,1,3));

   ...

   // Query zonder gat.
   $query3 = new Zend_Search_Lucene_Search_Query_Phrase(
                   array('word1', 'word2', 'word3'));

   ...

   $query4 = new Zend_Search_Lucene_Search_Query_Phrase(
                   array('word1', 'word2'), array(0,1), 'annotation');

   ?>
Phrase query kunnen worden aangemaakt met een enkele stap in de klasse constructor of stap voor stap met de
*Zend_Search_Lucene_Search_Query_Phrase::addTerm()* methode.

Zend_Search_Lucene_Search_Query_Phrase klasse constructor accepteert drie optionele argumenten:

.. code-block::
   :linenos:
   Zend_Search_Lucene_Search_Query_Phrase([array $terms[, array $offsets[, string $field]]]);
*$terms* is een array van strings, welke een set van zin termen bevat. Wanneer het niet wordt meegegeven of null
is, wordt een lege query aangemaakt.

*$offsets* is een array van integers, welke startpunten van termen in een zin bevatten. Wanneer het niet wordt
meegegeven of null is, wordt uitgegaan van posities zoals *array(0, 1, 2, 3, ...)*.

*$field* is een string, welke aangeeft welk document veld doorzocht moet worden. Wanneer het niet wordt meegegeven
of null is, dan wordt het standaard veld doorzicht. Deze versie van Zend_Search_Lucene behandelt het 'contents'
veld als standaard, maar het plan is dit aan te passen tot "ieder veld" in volgende versies.

Dus:

.. code-block::
   :linenos:
   $query = new Zend_Search_Lucene_Search_Query_Phrase(array('zend', 'framework'));
zoekt naar de 'zend framework' uitdrukking.

.. code-block::
   :linenos:
   <$query = new Zend_Search_Lucene_Search_Query_Phrase(array('zend', 'download'), array(0, 2));
zoekt naar 'zend ????? download' en dus voldoet 'zend platform download', 'zend studio download', 'zend core
download', 'zend framework download' hieraan.

.. code-block::
   :linenos:
   $query = new Zend_Search_Lucene_Search_Query_Phrase(array('zend', 'framework'), null, 'title');
zoekt naar 'zend framework' in het 'title' veld.

*Zend_Search_Lucene_Search_Query_Phrase::addTerm()* methode accepteert twee argumenten. Noodzakelijk
*Zend_Search_Lucene_Index_Term* object en optioneel positie:

.. code-block::
   :linenos:
   Zend_Search_Lucene_Search_Query_Phrase::addTerm(Zend_Search_Lucene_Index_Term $term[, integer $position]);
*$term* omschrijft de volgende term binnen de uitdrukking. Het moet hetzelfde veld als eerdere termen omschrijven.
Anders wordt er een exceptie opgeworpen.

*$position* geeft de positie van de term aan.

Dus:

.. code-block::
   :linenos:
   $query = new Zend_Search_Lucene_Search_Query_Phrase();
   $query->addTerm(new Zend_Search_Lucene_Index_Term('zend'));
   $query->addTerm(new Zend_Search_Lucene_Index_Term('framework'));
zoekt naar de 'zend framework' uitdrukking.

.. code-block::
   :linenos:
   $query = new Zend_Search_Lucene_Search_Query_Phrase();
   $query->addTerm(new Zend_Search_Lucene_Index_Term('zend'), 0);
   $query->addTerm(new Zend_Search_Lucene_Index_Term('framework'), 2);
zoekt naar de 'zend ????? download' uitdrukking en dus zal 'zend platform download', 'zend studio download', 'zend
core download', 'zend framework download' hieraan voldoen.

.. code-block::
   :linenos:
   $query = new Zend_Search_Lucene_Search_Query_Phrase();
   $query->addTerm(new Zend_Search_Lucene_Index_Term('zend', 'title'));
   $query->addTerm(new Zend_Search_Lucene_Index_Term('framework', 'title'));
zoekt naar 'zend framework' in het 'title' veld.

Slop factor zet het aantal woorden dat is toegestaan binnen een query uitdrukking. Wanneer deze nul is, wordt er op
een exacte uitdrukking gezocht. Voor hogere waardes werkt het als een WITHIN of NEAR operator.

De 'slop' is eigenlijk een editie-afstand, waar de eenheden overeenkomen met wijzigingen in de positie van termen
in de query uitdrukking. Voorbeeld: om de volgorde van twee woorden aan te passen is twee wijzigingen (de eerste
wijzigingen zet beide termen op dezelfde positie), om het herschikken van uitdrukkingen toe te staan dient 'slop'
minstens twee te zijn.

Exactere overeenkomsten krijgen een hogere score dan slordigere overeenkomsten, dus zoekresultaten worden geordend
op exactheid. 'Slop' staat standaard op nul, waardoor exacte overeenkomsten noodzakelijk zijn.

Slop factor kan na het aanmaken van een query worden aangegeven:

.. code-block::
   :linenos:
   <?php

   // Query zonder een gat.
   $query = new Zend_Search_Lucene_Search_Query_Phrase(array('word1', 'word2'));

   // Zoek naar 'word1 word2', 'word1 ... word2'
   $query->setSlop(1);
   $hits1 = $index->find($query);

   // Zoek naar 'word1 word2', 'word1 ... word2',
   // 'word1 ... ... word2', 'word2 word1'
   $query->setSlop(2);
   $hits2 = $index->find($query);

   ?>

