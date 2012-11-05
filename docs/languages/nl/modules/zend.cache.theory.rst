.. EN-Revision: none
.. _zend.cache.theory:

De theorie van het cachencaching
================================

Er zijn drie belangrijke concepten in Zend_Cache. Een is de unieke identifier (een string) die wordt gebruikt om
cache records te identificeren. De tweede is de *'lifeTime'* parameter zoals gezien in de voorbeelden; het
definieert hoe lang de cache als 'vers' wordt beschouwd. Het derde belangrijke concept is voorwaardelijke
uitvoering zodat delen van de code compleet overgeslagen kunnen worden, waardoor de performance wordt verbeterd. De
belangrijkste frontend functie (bijv. *Zend\Cache\Core::get()* is altijd ontworpen om false terug te geven wanneer
er geen waarde in de cache aanwezig is wanneer dat logisch is voor de aard van de frontend. Dat staat
eindgebruikers toe om delen van de code te 'wrappen' die ze willen cachen (en dus overslaan) in *if(){...}*
statements waarbij de voorwaarde een Zend_Cache methode is. Aan het einde van deze blokken moet je wel opslaan wat
je hebt gegenereerd (bijvoorbeeld *Zend\Cache\Core::save()*).

.. note::

   Het ontwerp van de voorwaardelijke uitvoer van de gemaakte code is niet noodzakelijk in sommige frontends
   (bijvoorbeeld *Function*) wanneer de logica aan de frontend is geimplementeerd.

.. note::

   'Cache hit' is een term voor een voorwaarde waarbij een cache record wordt gevonden, valide is en 'vers' (in
   andere woorden, niet verlopen) is. 'Cache miss' is al het andere. Wanneer een cache miss voorkomt moet je je
   data genereren zoals normaal and cachen. Wanneer je een cache hit hebt, daarentegen, haalt de backend
   automatisch de record uit de cache.

.. _zend.cache.factory:

De Zend_Cache factory methode
-----------------------------

Een goede manier om een bruikbare instantie van een *Zend_Cache* frontend te bouwen wordt gegeven in het volgende
voorbeeld:

.. code-block:: php
   :linenos:

   <?php

   # We "laden" de Zend_Cache factory.
   require 'Zend/Cache.php';

   # we kiezen een backend (bijvoorbeeld 'File' of 'Sqlite'...)
   $backendName = '[...]';

   # We kiezen een frontend (bijvoorbeeld 'Core', 'Output', 'Page'...)
   $frontendName = '[...]';

   # We zetten een array met opties voor de gekozen frontend
   $frontendOptions = array([...]);

   # We zetten een array met opties voor de gekozen backend
   $backendOptions = array([...]);

   # We maken de goede instantie.
   # (natuurlijk zijn de laatste twee argumenten optioneel)
   $cache = Zend\Cache\Cache::factory($frontendName, $backendName, $frontendOptions, $backendOptions);

   ?>
In het volgende voorbeeld zullen we uitgaan dat de *$cache* variabele een valide, geinstantieerde frontend bevat
zoals getoond en dat je begrijpt hoe je parameters naar je backends kan doorgeven.

.. note::

   Gebruikt altijd *Zend\Cache\Cache::factory()* om frontend instanties te krijgen. Zelf frontends en backends
   instantieren zal niet zoals verwacht werken.

.. _zend.cache.tags:

Records taggen
--------------

Tags zijn een manier om je cache records te categoriseren. Wanneer je een cache opslaat met de *save()* methode,
kan je een array zetten met tags voor deze record. Vervolgens heb je de mogelijkheid om alle cache records met een
bepaalde tag of met bepaalde tags op te schonen:

.. code-block:: php
   :linenos:

   <?php

   $cache->save($veel_data, 'mijnUniekeID', array('tagA', 'tagB', 'tagC'));

   ?>
.. _zend.cache.clean:

Opschonen van de cache
----------------------

Om een specifieke cache id te verwijderen/invalideren kan je de *remove()* methode gebruiken:

.. code-block:: php
   :linenos:

   <?php

   $cache->remove('idOmTeVerwijderen');

   ?>
Om verschillende cache ids in een operatie te verwijderen/invalideren kan je de *clean()* methode gebruiken.
Bijvoorbeeld om alle cache records te verwijderen:

.. code-block:: php
   :linenos:

   <?php

   // Schoon alle cache records op
   $cache->clean(Zend\Cache\Cache::CLEANING_MODE_ALL);

   // Schoon alleen verlopen records op
   $cache->clean(Zend\Cache\Cache::CLEANING_MODE_OLD);

   ?>
Als je cache records wil verwijderen die aan tags 'tagA' en 'tagC' voldoen:

.. code-block:: php
   :linenos:

   <?php

   $cache->clean(Zend\Cache\Cache::CLEANING_MODE_MATCHING_TAG, array('tagA', 'tagC'));

   ?>
Beschikbare opschoon modes zijn: *CLEANING_MODE_ALL*, *CLEANING_MODE_OLD*, *CLEANING_MODE_MATCHING_TAG* en
*CLEANING_MODE_NOT_MATCHING_TAG*. De laatsten zijn, zoals hun namen doen vermoeden, gecombineerd met een array van
tags voor de opschoonoperatie.


