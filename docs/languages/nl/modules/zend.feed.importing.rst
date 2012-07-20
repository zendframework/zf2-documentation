.. _zend.feed.importing:

Feeds importeren met Zend_Feed
==============================

*Zend_Feed* laat ontwikkelaars toe heel gemakkelijk feeds te verkrijgen. Indien je de URI van een feed kent,
gebruik dan eenvoudigweg de *Zend_Feed::import()* methode:

.. code-block::
   :linenos:

   <?php

   $feed = Zend_Feed::import('http://feeds.example.com/feedName');

   ?>
Je kan *Zend_Feed* ook gebruiken om de inhoud van een feed vanuit een bestand of een PHP string variabele te
verkrijgen:

.. code-block::
   :linenos:

   <?php

   // een feed van een textbestand importeren
   $feedFromFile = Zend_Feed::importFile('feed.xml');

   // een feed van een PHP string importeren
   $feedFromPHP = Zend_Feed::importString($feedString);

   ?>
In elk van de bovenstaande voorbeelden wordt een object van een klasse die *Zend_Feed_Abstract* uitbreidt
teruggegeven, afhangende van de feed type. Indien een RSS feed werd verkregen via één van de hierboven beschreven
import methodes, zal een *Zend_Feed_Rss* object worden verkregen. Anderzijds, indien een Atom feed werd
geïmporteerd, zal een *Zend_Feed_Atom* object worden verkregen. De importmethodes zullen ook een
*Zend_Feed_Exception* opwerpen indien ze mislukken, zoals bij het importeren van een onleesbare of slecht gevormde
feed.


