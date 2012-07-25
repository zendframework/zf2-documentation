.. _zend.feed.consuming-atom-single-entry:

Een enkele Atom entry lezen
===========================

Een Atom *<entry>* element is ook alleenstaand geldig. Gewoonlijk is de URL van een entry gelijk aan de URL van de
feed gevolgd door *<entryId>* zoals *http://atom.example.com/feed/1*, het voorbeeld van hierboven volgend.

Als je een enkele entry leest zal je nog altijd een *Zend_Feed_Atom* object hebben maar het zal automatisch een
"anonieme" feed aanmaken om de entry in te kapselen.

.. rubric:: Een alleenstaande entry van een Atom Feed lezen

.. code-block:: php
   :linenos:

   <?php

   $feed = new Zend_Feed_Atom('http://atom.example.com/feed/1');
   echo 'De feed heeft: ' . $feed->count() . ' entry.';

   $entry = $feed->current();

   ?>
Op een andere manier zou je het entry objekt direct kunnen instantiëren indien je weet dat je een document opent
dat alleen *<entry>* elementen bevat:

.. rubric:: Het Entry Object Direct gebruiken voor een Single-Entry Atom Feed

.. code-block:: php
   :linenos:

   <?php

   $entry = new Zend_Feed_Entry_Atom('http://atom.example.com/feed/1');
   echo $entry->title();

   ?>

