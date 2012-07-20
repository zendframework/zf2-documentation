.. _zend.json.objects:

JSON Objecten
=============

Wanneer je PHP objecten als JSON encodeerd zullen alle publieke eigenschappen van dat object naar JSON objecten
worden gecodeerd.

Het decoderen van JSON objecten houdt weliswaar een klein probleempje in, omdat Javascript objecten heel dicht
tegen PHP associatieve arrays aanleunen. Sommigen suggereren dat een klasse identificator doorgegeven zou moeten
worden, en een object instantie van die klasse zou moeten worden gebouwd en bevolkt met de key/waarde-paren van het
JSON object; anderen denken dat dit een potentieel groot veiligheidsrisico inhoudt.

*Zend_Json* zal JSON objecten standaard als associatieve arrays decoderen. Als je liever een object terugkrijgt,
kan je dit zo opvragen:

.. code-block::
   :linenos:
   <?php
   // Decodeer objecten als objecten
   $phpNative = Zend_Json::decode($encodedValue, Zend_Json::TYPE_OBJECT);
   ?>
Alle zo gedecodeerde objecten worden teruggestuurd als *StdClass* objecten met eigenschappen die overeenkomen met
de key/waarde-paren in de JSON notatie.

De aanbeveling van het Zend Framework is dat de ontwikkelaar individueel zou moeten beslissen hoe hij JSON objecten
gedecodeerd wil hebben. Indien een object van een bepaald type zou moeten worden gemaakt, kan dat worden gemaakt in
de code van de ontwikkelaar en bevolkt worden met de waarden die *Zend_Json* heeft gedecodeerd.


