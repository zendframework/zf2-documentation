.. _zend.feed.consuming-rss:

Lettura di un feed RSS
======================

Leggere un feed RSS è tanto semplice quanto creare un'istanza di un nuovo oggetto *Zend_Feed_Rss* con l'URL del
feed:

.. code-block:: php
   :linenos:

   <?php
   $channel = new Zend_Feed_Rss('http://rss.example.com/channelName');

Se qualche errore si verifica nel recuperare il feed, verrà generata un'eccezione *Zend_Feed_Exception*.

Una volta a disposizione un oggetto feed si ha accesso ad ognuna delle proprietà standard di un canale RSS
(channel), direttamente dall'oggetto:

.. code-block:: php
   :linenos:

   <?php
   echo $channel->title();

Si noti la sintassi della funzione. *Zend_Feed* utilizza una convenzione per trattare le proprietà come oggetti
XML se sono richieste con la sintassi "getter" di una variabile (*$obj->property*) e come stringhe se sono
richieste con la sintassi tipica di un metodo (*$obj->property()*). Questo consente l'accesso al testo completo di
ogni singolo nodo così come consente pieno accesso a tutti gli elementi figli del nodo stesso.

Se le proprietà di un canale contengono attributi è possibile accedervi utilizzando la sintassi tipica di un
array in PHP:

.. code-block:: php
   :linenos:

   <?php
   echo $channel->category['domain'];

Poiché gli attributi XML non possono contenere figli, la sintassi caratteristica di un metodo non è necessaria
per accedere ai valori degli attributi.

Più comunemente si desidera scorrere il feed ed eseguire qualche azione con i suoi elementi. *Zend_Feed_Abstract*
implementa l'interfaccia PHP *Iterator*, dunque stampare tutti i titoli degli articoli consiste esclusivamente in:

.. code-block:: php
   :linenos:

   <?php
   foreach ($channel as $item) {
       echo $item->title() . "\n";
   }

Se non si ha familiarità con un feed RSS, ecco gli elementi standard che ci si può aspettare essere disponibili
in un canale RSS o un singolo elemento RSS (entry).

Tag obbligatori del canale (*channel*):



   - *title*- Il nome del canale

   - *link*- L'URL del sito web corrispondente al canale

   - *description*- Una o alcune frasi descrittive del canale



Tipici tag opzionali del canale:



   - *pubDate*- La data di pubblicazione del contenuto, nel formato RFC 822

   - *language*- La lingua nella quale è scritto il canale

   - *category*- Una o più categorie (specificate da più tag) alle quali appartiene il canale



Gli elementi (*<item>*) di un RSS non contengono particolari tag obbligatori. Tuttavia, almeno uno tra i tag
*title* o *description* deve essere presente.

Tipici tag di un elemento:



   - *title*- Il titolo dell'elemento

   - *link*- L'URL dell'elemento

   - *description*- Un riassunto dell'elemento

   - *author*- L'indirizzo email dell'autore

   - *category*- Una o più categorie alle quali appartiene l'elemento

   - *comments*- L'URL dei commenti riguardanti questo elemento

   - *pubDate*- La data di pubblicazione dell'elemento, nel formato RFC 822



E' possibile verificare la presenza di un elemento all'interno del codice utilizzando:

.. code-block:: php
   :linenos:

   <?php
   if ($item->propname()) {
       // ... proceed.
   }

Se in alternativa si utilizza *$item->propname*, verrà sempre restituito un oggetto vuoto valutato come *TRUE*,
dunque il controllo non sarà eseguito correttamente.

Per ulteriori informazioni, le specifiche ufficiali del formato RSS 2.0 sono disponibili all'indirizzo:
`http://blogs.law.harvard.edu/tech/rss`_



.. _`http://blogs.law.harvard.edu/tech/rss`: http://blogs.law.harvard.edu/tech/rss
