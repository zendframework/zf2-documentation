.. EN-Revision: none
.. _zend.feed.importing:

Feeds importeren met Zend_Feed
==============================

*Zend_Feed* laat ontwikkelaars toe heel gemakkelijk feeds te verkrijgen. Indien je de URI van een feed kent,
gebruik dan eenvoudigweg de *Zend\Feed\Feed::import()* methode:

.. code-block:: php
   :linenos:

   <?php

   $feed = Zend\Feed\Feed::import('http://feeds.example.com/feedName');

   ?>
Je kan *Zend_Feed* ook gebruiken om de inhoud van een feed vanuit een bestand of een PHP string variabele te
verkrijgen:

.. code-block:: php
   :linenos:

   <?php

   // een feed van een textbestand importeren
   $feedFromFile = Zend\Feed\Feed::importFile('feed.xml');

   // een feed van een PHP string importeren
   $feedFromPHP = Zend\Feed\Feed::importString($feedString);

   ?>
In elk van de bovenstaande voorbeelden wordt een object van een klasse die *Zend\Feed\Abstract* uitbreidt
teruggegeven, afhangende van de feed type. Indien een RSS feed werd verkregen via één van de hierboven beschreven
import methodes, zal een *Zend\Feed\Rss* object worden verkregen. Anderzijds, indien een Atom feed werd
geïmporteerd, zal een *Zend\Feed\Atom* object worden verkregen. De importmethodes zullen ook een
*Zend\Feed\Exception* opwerpen indien ze mislukken, zoals bij het importeren van een onleesbare of slecht gevormde
feed.


