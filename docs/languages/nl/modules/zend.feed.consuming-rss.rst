.. EN-Revision: none
.. _zend.feed.consuming-rss:

Een RSS Feed lezen
==================

Een RSS feed lezen is zo eenvoudig als het instantiëren van een *Zend\Feed\Rss* object met het URI van de feed:

.. code-block:: php
   :linenos:

   <?php

   $channel = new Zend\Feed\Rss('http://rss.example.com/channelName');

   ?>
Indien er fouten optreden bij het verkrijgen van de feed zal een *Zend\Feed\Exception* opgeworpen worden.

Als je eenmaal een feed object hebt, kan je toegang verkrijgen voor eender welke van de standaard RSS
kanaaleigenschappen op een direkte wijze:

.. code-block:: php
   :linenos:

   <?php

   echo $channel->title();

   ?>
Merk de functiesyntax op. *Zend_Feed* gebruikt een overeenkomst om eigenschappen als XML objecten te behandelen
indien ze werden opgevraagd met de variabele "getter" syntax (*$obj->property()*). Dit laat het toe de volledige
tekst van eender welke individuele node te verkrijgen en toch volledig toegang te hebben tot alle childnodes.

Indien kanaaleigenschappen attributen hebben zijn deze toegangkelijk door het gebruiken van de array syntax van
PHP:

.. code-block:: php
   :linenos:

   <?php

   echo $channel->category['domain'];

   ?>
Vermits XML attributen geen kinderen kunnen hebben is de functiesyntax niet nodig om toegang te krijgen tot
attribuutwaarden.

Meestal zal je door een feed willen loopen en iets met de entries willen doen. *Zend\Feed\Abstract* implementeert
PHP's *Iterator* interface, dus het weergeven van alle titels van artikels in een kanaal is eenvoudig met:

.. code-block:: php
   :linenos:

   <?php

   foreach ($channel as $item) {
       echo $item->title() . "\n";
   }

   ?>
Indien je niet vertrouwd bent met RSS zijn hier de standaard elementen die je kan verwachten in een RSS kanaal en
in individuele RSS items (entries).

Verplichte kanaalelementen:



   - *title*- De naam van het kanaal

   - *link*- De URL van de overeenkomstige website

   - *description*- Eén of meerdere zinnen die het kanaal beschrijven



Gewone optionele elementen:



   - *pubDate*- De publicatiedatum van deze set van inhoud, in de vorm van een RFC 822 datum

   - *language*- De taal waarin het kanaal is geschreven

   - *category*- Eén of meerdere (gespecifieerd door het vermenigvuldigen van de afbakeningen) categoriën waartoe
     het kanaal behoort



RSS *<item>* elementen hebben geen strict verplichte eigenschappen. Desalnietemin moeten ofwèl *title* of
*description* aanwezig zijn.

Gewone item elementen:



   - *title*- De titel van het item

   - *link*- De URL van het item

   - *description*- Een samenvatting van het item

   - *author*- Het e-mailadres van de auteur

   - *category*- Eén of meerdere categorieën waartoe het item behoort

   - *comments*- URL van commentaren verbonden aan dit item

   - *pubDate*- De datum van publicatie van het item in RFC 822 formaat



Je kan in jouw code altijd testen of een element leeg is of niet met:

.. code-block:: php
   :linenos:

   <?php

   if ($item->propname()) {
       // ... doorgaan.
   }

   ?>
Indien je in de plaats daarvan *$item->propname* gebruikt, zal je altijd een leeg object verkrijgen dat
geëvalueerd zal worden als *TRUE* en je test zal niet juist zijn.

Voor verdere informatie kan je terecht op de officiële RSS 2.0 specificatie:
`http://blogs.law.harvard.edu/tech/rss`_



.. _`http://blogs.law.harvard.edu/tech/rss`: http://blogs.law.harvard.edu/tech/rss
