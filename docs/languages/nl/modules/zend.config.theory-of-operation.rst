.. _zend.config.theory_of_operation:

Werkingstheorie
===============

Configuratiedata wordt toegankelijk gemaakt voor de *Zend_Config* constructor via een associatieve array, welke
multidimensioneel kan zijn, om het organizeren van de data van alemeen naar specifiek te ondersteunen. Er bestaan
concrete functies van de hulpklassen om de configuratiedata aan te passen vanuit het bestand om een associatieve
array voor de constructor van *Zend_Config* aan te maken. Gebruikerscripts kunnen deze arrays direct doorgeven aan
de constructor van *Zend_Config*, zonder een hulpklasse te gebruiken. Dit kan toepasselijk zijn in sommige
situaties.

Elke configuratie data array waarde wordt een eigenschap van het *Zend_Config* object. De key wordt gebruikt als de
naam van de eigenschap. Als de waarde zelf een array is, dan zal hiervoor een nieuw *Zend_Config* object worden
gemaakt, waarin de array data geladen wordt. Dit gebeurt recursief, zodat er een hiërarchie van configuratie data
gemaakt kan worden van elke hoeveelheid niveaus.

*Zend_Config* implementeert de *Countable* en *Iterator* interfaces om eenvoudige toegang tot de configuratiedata
te vergemakkelijken. Je kan dus de `count()`_ functie en PHP constructies zoals `foreach`_ gebruiken op
*Zend_Config* objecten.

Standaard is de configuratiedata die beschikbaar wordt gemaakt via *Zend_Config* alleen lezen, en het toewijzen van
een waarde (bv: *$config->database->host = 'example.com'*) resulteert in het opwerpen van een uitzondering. Deze
standaardeigenschap kan worden gewijzigd via de constructor om het wijzigen van waarden toe te staan. Ook, wanneer
wijzigingen zijn toegstaan, ondersteunt *Zend_Config* het verwijderen van waardes (i.e.
*unset($config->database->host);*).

.. note::

   Het is belangrijk zulke in-memory wijzigingen niet te verwarren met het opslaan van configuratiedata in een
   specifieke opslagmedia. Programma's voor het aanmaken en wijzigen van configuratiedata voor de verschillende
   opslagmedia worden hier niet besproken, want ze vallen buiten het bereik van *Zend_Config*. Open source
   toepassingen van derden zijn beschikbaar voor het aanmaken en wijzigen van configuratiedata voor verschillende
   opslagmedia.

Hulpklassen erven van de *Zend_Config* klasse want ze gebruiken haar functionaliteiten.

De familie van *Zend_Config* klassen staat de organizatie van configuratiedata in secties toe. *Zend_Config*
hulpklasse objecten kunnen een enkele gespecifieerde sectie, verschillende gespecifieerde secties of alle secties
(indien er geen sectie werd gespecifieerd) inladen.

*Zend_Config* hulpklassen ondersteunen een enkel ervingsmodel dat een configuratiedata sectie toelaat te erven van
een andere sectie. Dit word gedaan om het verdubbelen van configuratiedata voor verchillende doeleinden te
verminderen of te verwijderen. Een ervende sectie kan ook de overgeërfde waarden overschrijven. Net zoals PHP
klasse erving kan een sectie van een oudersectie erven, die van een grootouder erft en zo verder, maar veelvoudige
overerving (bv: sectie C erft onmiddellijk van oudersecties A en B) wordt niet ondersteund.

Als je twee *Zend_Config* objecten hebt, kan je ze samenvoegen tot een enkel object door gebruik te maken van de
*merge()* functie. Als voorbeeld, een gegeven *$config* en *$localConfig*, je kan de data van *$localConfig*
samenvoegen met *$config* door gebruikt te maken van *$config->merge($localConfig);*. De elementen uit
*$localConfig* zullen de elementen uit *$config* overschrijven, als ze dezelfde naam hebben.



.. _`count()`: http://php.net/count
.. _`foreach`: http://php.net/foreach
