.. EN-Revision: none
.. _zend.feed.modifying-feed:

Feed en Entry structuren wijzigen
=================================

De intuïtieve syntax van *Zend_Feed* breidt zich uit voor het bouwen en wijzigen van feeds en entries, naast het
lezen ervan. Je kan gemakkelijk je nieuwe of gewijzigde objecten in goedgevormde XML terugsturen om het in een
bestand op te slaan of naar een server te sturen.

.. rubric:: Wijzigen van een bestaande Feed Entry

.. code-block:: php
   :linenos:

   <?php

   $feed = new Zend\Feed\Atom('http://atom.example.com/feed/1');
   $entry = $feed->current();

   $entry->title = 'Dit is een nieuwe titel';
   $entry->author->email = 'my_email@example.com';

   echo $entry->saveXML();

   ?>
Dit zal een volledige (inclusief *<?xml ... >* proloog) XML representatie van de nieuwe entry weergeven, met
inbegrip van alle nodige XML namespaces.

Merk op dat het bovenstaande zelfs zal werken indien de oorspronkelijke entry nog geen *author* afbakening heeft.
Je kan zoveel niveaus van *->* aandoen als je wil voor een toewijzing te doen; alle niveaus zullen automatisch
worden aangemaakt indien nodig.

Als je een andere namespace wil gebruiken dan *atom:*, *rss:* of *osrss:* in je entry, moet je de namespace
registreren aan *Zend_Feed* door *Zend\Feed\Feed::registerNamespace()* te gebruiken. Als je een bestaand element wil
wijzigen zal het steeds zijn oorspronkelijke namespace behouden. Als je een nieuw element toevoegt zal het in de
standaard namespace gaan als je niet uitdrukkelijk een andere namespace toewijst.

.. rubric:: Een Atom Entry met elementen van een aangepaste namespace

.. code-block:: php
   :linenos:

   <?php

   $entry = new Zend\Feed_Entry\Atom();
   // id wordt altijd via de server toegewezen in Atom
   $entry->title = 'mijn aangepaste entry';
   $entry->author->name = 'Voorbeeldauteur';
   $entry->author->email = 'me@example.com';

   // Doe nu de aanpassing
   Zend\Feed\Feed::registerNamespace('myns', 'http://www.example.com/myns/1.0');

   $entry->{'myns:myelement_one'} = 'mijn eerste aangepaste waarde';
   $entry->{'myns:container_elt'}->part1 = 'eerste genesteld aangepast deel';
   $entry->{'myns:container_elt'}->part2 = 'tweede genesteld aangepast deel';

   echo $entry->saveXML();

   ?>

