.. _zend.feed.consuming-atom:

Een Atom Feed lezen
===================

*Zend_Feed_Atom* is voor een groot deel identiek aan *Zend_Feed_Rss*. Het verstrekt dezelfde toegang to feed
eigenschappen en het overlopen van de entries in de feed. Het grote verschil zit in de structuur van het Atom
protocol zelf. Atom is een opvolger van RSS; het is een meer generiek protocol en is ontworpen om gemakkelijker met
feeds om te gaan die de volledige inhoud in de feed aanbieden door het opsplitsen van de RSS *description*
eigenschap in twee elementen: *summary* en *content*.

.. rubric:: Basisgebruik van een Atom Feed

Lees een Atom feed en beeld de *title* en *summary* van elke entry af:

.. code-block:: php
   :linenos:

   <?php

   $feed = new Zend_Feed_Atom('http://atom.example.com/feed/');
   echo 'de feed bevat ' . $feed->count() . ' entries.' . "\n\n";
   foreach ($feed as $entry) {
       echo 'Titel: ' . $entry->title() . "\n";
       echo 'Samenvatting: ' . $entry->summary() . "\n\n";
   }

   ?>
Je kan de volgende feed eigenschappen verwachten in een Atom feed:



   - *title*- De titel van de feed, hetzelfde als de kanaaltitel van een RSS feed

   - *id*- Elke feed en entry heeft een unieke id in Atom

   - *link*- Feeds kunnen meerder links hebben, ze zijn gescheiden door het *type* attribuut

     De tegenhanger in een RSS kanaal link zou de *type="text/html"* zijn. Indien de link naar een alternatieve
     versie van dezelfde inhoud in de feed verwijst zou het het attribuut *rel="alternative"* hebben.

   - *subtitle*- De beschrijving van de feed, de tegenhanger van de kanaalbeschrijving in RSS

     *author->name()*- De naam van de auteur van de feed

     *author->email()*- Het email adres van de auteur van de feed



Atom entries hebben gewoonlijk de volgende eigenschappen:



   - *id*- De unieke ID van de entry

   - *title*- De titel van de entry, hetzelfde als de item titels in RSS

   - *link*- Een link naar een alternatieve versie of afbeelding van deze entry

   - *summary*- Een samenvatting van de inhoud van de entry

   - *content*- De volledige inhoud van de entry; dit kan worden overgeslaan indien de feed alleen samenvattingen
     bevat

   - *author*- met *name* en *email* subafbakeningen zoals feeds hebben

   - *published*- de publicatiedatum in RFC 3339 formaat

   - *updated*- de datum van de laatste update van het item in RFC 3339 formaat



Voor meer informatie en een overvloed van bronnen over Atom, ga naar `http://www.atomenabled.org/`_.



.. _`http://www.atomenabled.org/`: http://www.atomenabled.org/
