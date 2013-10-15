.. EN-Revision: none
.. _zend.feed.modifying-feed:

Modifica della struttura e degli elementi di un feed
====================================================

La sintassi intuitiva di *Zend_Feed* si può utilizzare sia per costruire o modificare i feed ed gli elementi dei
feed, sia per leggerli. Un oggetto nuovo o modificato può essere facilmente riconvertito in XML per il salvataggio
in un file o l'invio ad un server.

.. _zend.feed.modifying-feed.example.modifying:

.. rubric:: Modifica di un elemento esistente in un feed

.. code-block:: php
   :linenos:

   <?php
   $feed = new Zend\Feed\Atom('http://atom.example.com/feed/1');
   $entry = $feed->current();

   $entry->title = 'Questo è un nuovo titolo';
   $entry->author->email = 'my_email@example.com';

   echo $entry->saveXML();

Questo codice esegue l'output di una rappresentazione XML completa dell'elemento, inclusa la dichiarazione *<?xml
... >* e qualsiasi namespace XML necessario.

Si noti come il codice precedente funziona anche se l'elemento esistente non contiene ancora un tag *author*. Si
possono utilizzare quanti livelli di accesso *->* si desidera prima di eseguire l'assegnamento. Tutti i livelli
intermedi verranno creati in automatico, se necessario.

Se si desidera utilizzare in un elemento un namespace oltre a *atom:*, *rss:* o *osrss:*, è necessario registrarlo
in *Zend_Feed* utilizzando *Zend\Feed\Feed::registerNamespace()*. Un elemento esistente manterrà sempre il proprio
namespace originale in fase di modifica. Un nuovo elemento sarà invece inserito nel namespace predefinito se non
si specifica esplicitamente un namespace alternativo.

.. _zend.feed.modifying-feed.example.creating:

.. rubric:: Creazione di un elemento di un feed Atom con namespace personalizzato

.. code-block:: php
   :linenos:

   <?php
   $entry = new Zend\Feed\Entry\Atom();
   // id è sempre assegnato dal server ad Atom
   $entry->title = 'il mio elemento personalizzato';
   $entry->author->name = 'Autore di Esempio';
   $entry->author->email = 'io@example.com';

   // ora esegue la parte personalizzata
   Zend\Feed\Feed::registerNamespace('mions', 'http://www.example.com/mions/1.0');

   $entry->{'mions:mioelemento_uno'} = 'il mio primo valore personalizzato';
   $entry->{'mions:contenitore_elem'}->parte1 = 'prima parte personalizzata';
   $entry->{'mions:contenitore_elem'}->parte2 = 'seconda parte personalizzata;

   echo $entry->saveXML();


