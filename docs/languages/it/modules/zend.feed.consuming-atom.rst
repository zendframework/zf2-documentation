.. _zend.feed.consuming-atom:

Lettura di un feed Atom
=======================

*Zend_Feed_Atom* è utilizzato pressappoco allo stesso modo di *Zend_Feed_Rss*. Fornisce lo stesso accesso alle
proprietà del feed e la possibilità di scorrere gli elementi del feed. La principale differenza è la struttura
stessa del formato Atom. L'Atom è un successore dell'RSS; è un formato più generalizzato e disegnato per gestire
più facilmente i feed che forniscono l'intero contenuto all'interno del feed stesso, sdoppiando l'elemento
*description* del formato RSS in due elementi: *summary* e *content*.

.. _zend.feed.consuming-atom.example.usage:

.. rubric:: Utilizzo base di un feed Atom

Lettura di un feed Atom e stampa di *title* e *summary* per ogni elemento:

.. code-block::
   :linenos:
   <?php

   $feed = new Zend_Feed_Atom('http://atom.example.com/feed/');
   echo 'Il feed contiene ' . $feed->count() . ' elementi.' . "\n\n";
   foreach ($feed as $entry) {
       echo 'Titolo: ' . $entry->title() . "\n";
       echo 'Sommario: ' . $entry->summary() . "\n\n";
   }
In un feed Atom è possibile trovare le seguenti proprietà:



   - *title*- Il titolo del feed, corrispondente a *title* per un canale RSS

   - *id*- Ciascun feed ed elemento in un Atom ha un identificatore univoco

   - *link*- I feed possono avere più collegamenti, ciascuno identificato da un attributo *type*

     L'equivalente per un canale RSS sarebbe *type="text/html"*. Un collegamento che indica una versione
     alternativa dello stesso contenuto del feed dovrebbe contenere l'attributo *rel="alternate"*.

   - *subtitle*- La descrizione del feed, equivalente a *description* per un canale RSS

     *author->name()*- Il nome dell'autore del feed

     *author->email()*- L'indirizzo email dell'autore del feed



Gli elementi di un feed normalmente contengono le seguenti proprietà:



   - *id*- L'identificatore univoco dell'elemento

   - *title*- Il titolo dell'elemento, corrispondente a *title* per un elemento RSS

   - *link*- Collegamento ad un altro formato o ad una visualizzazione alternativa dell'elemento

   - *summary*- Un sommario del contenuto dell'elemento

   - *content*- Il contenuto completo dell'elemento; può essere saltato se il feed contiene esclusivamente il
     sommario

   - *author*- Include i tag *name* e *email* così come il feed principale

   - *published*- La data di pubblicazione dell'elemento, nel formato RFC 3339

   - *updated*- La data di ultimo aggiornamento dell'elemento, nel formato RFC 3339



Per maggiori informazioni sull'Atom e risorse aggiuntive è possibile visitare `http://www.atomenabled.org/`_.



.. _`http://www.atomenabled.org/`: http://www.atomenabled.org/
