.. _zend.feed.introduction:

Introduzione
============

*Zend_Feed* fornisce le funzionalità per utilizzare feed RSS e Atom. Offre una sintassi naturale per accedere alla
struttura del feed del feed, attributi ed attributi degli elementi. *Zend_Feed* include anche un supporto esteso
per la modifica della struttura dei feed e degli elementi che lo compongono con la stessa naturale sintassi per poi
trasformare il risultato nuovamente in un XML. In futuro, il supporto alla modifica potrà anche includere il
supporto all'Atom Publishing Protocol.

*Zend_Feed* consiste in una classe base *Zend_Feed*, in due classi base astratte *Zend_Feed_Abstract* e
*Zend_Feed_Entry_Abstract* per la rappresentazione del feed e dei suoi elementi, specifiche implementazioni per
feed RSS e Atom ed alcune funzioni a supporto che lavorano dietro le scene per assicurare il buon funzionamento ed
una sintassi intuitiva.

L'esempio seguente dimostra un semplice caso di lettura e salvataggio di una porzione di dati da un feed in un
semplice array PHP, che può essere utilizzato per stampare i dati, salvarli in un database, ecc.

.. note::

   **Attenzione**

   Molti feed RSS hanno diverse proprietà disponibili per il canale (channel) così come per i suoi elementi
   (item). Le specifiche RSS indicano numerose proprietà opzionali quindi è necessario prestare loro attenzione
   quando si scrive codice per interagire con dati provenienti da un RSS.

.. _zend.feed.introduction.example.rss:

.. rubric:: Lettura di un feed RSS con Zend_Feed

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Feed.php';

   // Recupera le ultime novità da Slashdot
   try {
       $slashdotRss = Zend_Feed::import('http://rss.slashdot.org/Slashdot/slashdot');
   } catch (Zend_Feed_Exception $e) {
       // importazione del feed fallita
       echo "Si è verificata un'eccezione nell'importazione del feed: {$e->getMessage()}\n";
       exit;
   }

   // Inizializza l'array contenente i dati del canale
   $channel = array(
       'title'       => $slashdotRss->title(),
       'link'        => $slashdotRss->link(),
       'description' => $slashdotRss->description(),
       'items'       => array()
       );

   // Scorri ogni elemento del canale e salva i dati rilevanti
   foreach ($slashdotRss as $item) {
       $channel['items'][] = array(
           'title'       => $item->title(),
           'link'        => $item->link(),
           'description' => $item->description()
           );
   }


