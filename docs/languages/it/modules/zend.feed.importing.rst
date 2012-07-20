.. _zend.feed.importing:

Importazione di feed
====================

*Zend_Feed* consente agli sviluppatori di recuperare i feed con facilità. Se si conosce l'URI di un feed è
sufficiente utilizzare il metodo *Zend_Feed::import()*:

.. code-block::
   :linenos:
   <?php
   $feed = Zend_Feed::import('http://feeds.example.com/feedName');

E' anche possibile usare *Zend_Feed* per recuperare il contenuto di un feed da un file o da una variabile stringa
in PHP:

.. code-block::
   :linenos:
   <?php
   // importazione di un feed da un file di testo
   $feedDaFile = Zend_Feed::importFile('feed.xml');

   // importazione di un feed da una variabile stringa in PHP
   $feedDaPHP = Zend_Feed::importString($stringaFeed);

Ciascuno degli esempi precedenti restituisce un oggetto di una classe che estende *Zend_Feed_Abstract*, a seconda
del tipo di feed. Se il feed recuperato con uno dei metodi indicati è un RSS, allora sarà restituito un oggetto
*Zend_Feed_Rss*. Allo stesso modo, verrà restituito un oggetto *Zend_Feed_Atom* se è stato importato un feed
Atom. I metodi d'importazione generano un'eccezione *Zend_Feed_Exception* in caso di errore, come ad esempio un
feed non leggibile o non valido.

.. _zend.feed.importing.custom:

Feed personalizzati
-------------------

*Zend_Feed* consente agli sviluppatori di creare facilmente i propri feed. E' sufficiente creare un array ed
importarlo con *Zend_Feed*. L'array può essere importato con *Zend_Feed::importArray()* o con
*Zend_Feed::importBuilder()*. Nell'ultimo caso l'array sarà elaborato al volo da una sorgente di dati
personalizzata che implementa *Zend_Feed_Builder_Interface*.

.. _zend.feed.importing.custom.importarray:

Importazione di un array personalizzato
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block::
   :linenos:
   <?php
   // importazione di un feed da un array
   $feedAtomDaArray = Zend_Feed::importArray($array);

   // la linea successiva è equivalente alla precedente;
   // un'istanza di Zend_Feed_Atom è restituita per impostazione predefinita
   $feedAtomDaArray = Zend_Feed::importArray($array, 'atom');

   // importazione di un feed RSS da un array
   $feedRssDaArray = Zend_Feed::importArray($array, 'rss');

Il formato dell'array deve essere conforme alla seguente struttura:

.. code-block::
   :linenos:
   <?php
   array(
         'title'       => 'titolo del feed', // obbligatorio
         'link'        => 'url canonico del feed', // obbligatorio
         'lastUpdate'  => 'data di aggiornamento nel formato timestamp', // opzionale
         'published'   => 'data di pubblicazione nel formato timestamp', // opzionale
         'charset'     => 'set di caratteri per il contenuto testuale', // obbligatorio
         'description' => 'breve descrizione del feed', // opzionale
         'author'      => 'autore/editore del feed', // opzionale
         'email'       => 'indirizzo email dell\'autore', // opzionale
         'webmaster'   => 'indirizzo email della persona responsabile degli aspetti tecnici' // opzionale, ignorato nel formato Atom
         'copyright'   => 'informazioni sul copyright', // opzionale
         'image'       => 'indirizzo dell\'immagine', // opzionale
         'generator'   => 'strumento adottato per generare il feed', // opzionale
         'language'    => 'lingua nella quale è scritto il feed', // opzionale
         'ttl'         => 'lunghezza in minuti del periodo in cui è possibile salvare in cache il feed', // opzionale, ignorato nel formato Atom
         'rating'      => 'L\'immagine per la votazione del canale', // opzionale, ignorato nel formato Atom
         'cloud'       => array(
                                'domain'            => 'dominio del cloud, es. rpc.sys.com' // obbligatorio
                                'port'              => 'porta di connessione' // opzionale, 80 è il valore predefinito
                                'path'              => 'percorso del cloud, es. /RPC2' // obbligatorio
                                'registerProcedure' => 'procedura da chiamare, es. myCloud.rssPleaseNotify' // obbligatorio
                                'protocol'          => 'protocol da usare, es. soap o xml-rpc' // obbligatorio
                                ), // un servizio cloud per essere informato degli aggiornamenti // opzionale, ignorato nel formato Atom
         'textInput'   => array(
                                'title'       => 'l\'etichetta del bottone Submit nel campo di testo' // obbligatorio,
                                'description' => 'spiega il significato del campo di testo' // obbligatorio
                                'name'        => 'il nome dell'oggetto testuale nel campo di testo' // obbligatorio
                                'link'        => 'l'indirizzo dello script CGI che processa le richieste' // obbligatorio
                                ) // un campo per l'inserimento di testo che può essere mostrato con il feed // opzionale, ignorato nel formato Atom
         'skipHours'   => array(
                                'ora nel formato 24 ore', // es. 13 (1pm)
                                // fino a 24 righe dove il valore è un numero compreso tra 0 e 23
                                ) // Suggerimento agli aggregatori che indica in quali ore è consigliato saltare l'aggiornamento // opzionale, ignorato nel formato Atom
         'skipDays '   => array(
                                'il giorno da saltare', // es. Monday
                                // fino a 7 righe dove il valore è Monday, Tuesday, Wednesday, Thursday, Friday, Saturday o Sunday
                                ) // Suggerimento agli aggregatori che indica in quali giorni è consigliato saltare l'aggiornamento // opzionale, ignorato nel formato Atom
         'itunes'      => array(
                                'author'       => 'Colonna corrispondente all\'artista' // opzionale, impostazione predefinita l'autore principale
                                'owner'        => array(
                                                        'name' => 'nome del proprietario' // opzionale, impostazione predefinita l'autore principale
                                                        'email' => 'email del proprietario' // opzionale, impostazione predefinita l'autore principale
                                                        ) // Proprietario del podcast // opzionale
                                'image'        => 'immagine album/podcast' // opzionale, impostazione predefinita l'immagine principale
                                'subtitle'     => 'sintetica descrizione description' // opzionale, impostazione predefinita la descrizione principale
                                'summary'      => 'completa descrizione' // opzionale, impostazione predefinita la descrizione principale
                                'block'        => 'Non mostrare l\'episodio (yes|no)' // opzionale
                                'category'     => array(
                                                        array('main' => 'categoria principale', // obbligatorio
                                                              'sub'  => 'categoria secondaria' // opzionale
                                                              ),
                                                        // fino a 3 righe
                                                        ) // 'Colonna categoria e nella navigazione nell'iTunes Music Store' // obbligatorio
                                'explicit'     => 'immagine avviso contenuti espliciti (yes|no|clean)' // opzionale
                                'keywords'     => 'una lista di categorie (fino a 12) separate da virgola' // opzionale
                                'new-feed-url' => 'utilizzato per informare iTunes di un nuovo indirizzo del feed' // opzionale
                                ) // Itunes extension data // opzionale, ignorato nel formato Atom
         'entries'     => array(
                                array(
                                      'title'        => 'titolo dell\'elemento del feed', // obbligatorio
                                      'link'         => 'indirizzo ad un elemento del feed', // obbligatorio
                                      'description'  => 'breve versione dell\'elemento del feed', // solo testo, no html, obbligatorio
                                      'guid'         => 'id dell'articolo, il link è utilizzato come alternativa', // opzionale
                                      'content'      => 'versione completa', // può contenere html, opzionale
                                      'lastUpdate'   => 'data di pubblicazione nel formato timestamp', // opzionale
                                      'comments'     => 'pagina dei commenti dell\'elemento del feed', // opzionale
                                      'commentRss'   => 'il feed dei commenti associati all\'elemento', // opzionale
                                      'source'       => array(
                                                              'title' => 'titolo della sorgente originale' // obbligatorio,
                                                              'url' => 'url della sorgente originale' // obbligatorio
                                                              ) // sorgente originale dell'elemento del feed // opzionale
                                      'category'     => array(
                                                              array(
                                                                    'term' => 'l\'etichetta della prima categoria' // obbligatorio,
                                                                    'scheme' => 'url che identifica uno schema di categoria' // opzionale
                                                                    ),
                                                              array(
                                                                    // dati per il secondo elemento ed elementi successivi
                                                                    )
                                                              ) // elenco delle categorie // opzionale
                                      'enclosure'    => array(
                                                              array(
                                                                    'url' => 'url del contenuto multimediale collegato' // obbligatorio
                                                                    'type' => 'mime type del contenuto multimediale' // opzionale
                                                                    'length' => 'lunghezza in byte del contenuto multimediale collegato' // opzionale
                                                                    ),
                                                              array(
                                                                    // dati per il secondo elemento multimediale ed elementi successivi
                                                                    )
                                                              ) // elenco degli elementi multimediali per l'elemento del feed // opzionale
                                      ),
                                array(
                                      // dati per il secondo elemento del feed ed elementi successivi
                                      )
                                )
          );

Riferimenti:

   - Specifiche RSS 2.0: `RSS 2.0`_

   - Specifiche Atom: `RFC 4287`_

   - Specifiche WFW: `Well Formed Web`_

   - Specifiche iTunes: `Specifiche Tecniche iTunes`_



.. _zend.feed.importing.custom.importbuilder:

Importazione di una sorgente di dati personalizzata
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

E' possibile creare un'istanza di *Zend_Feed* da una qualsiasi sorgente di dati che implementa
*Zend_Feed_Builder_Interface*. E' sufficiente implementare i metodi *getHeader()* e *getEntries()* per essere in
grado di utilizzare il proprio oggetto con *Zend_Feed::importBuilder()*. Come semplice esempio di implementazione
è possibile utilizzare *Zend_Feed::importBuilder()*, che accetta un array in ingresso, esegue alcune validazioni
minori ed infine può essere utilizzato nel metodo *importBuilder()*. Il metodo *getHeader()* deve restituire
un'istanza di *Zend_Feed_Builder_Header* e *getEntries()* deve restituire un array di istanze di
*Zend_Feed_Builder_Entry*.

.. note::

   *Zend_Feed_Builder* è utile come concreta implementazione per dimostrare l'utilizzo. Si consiglia agli utenti
   la creazione di proprie implementazioni personalizzate di *Zend_Feed_Builder_Interface*.

Ecco un esempio di utilizzo di *Zend_Feed::importBuilder()*:

.. code-block::
   :linenos:
   <?php
   // importazione di un feed da un costruttore personalizzato
   $feedAtomDaArray = Zend_Feed::importBuilder(new Zend_Feed_Builder($array));

   // la linea successiva è equivalente alla precedente;
   // un'istanza di Zend_Feed_Atom è restituita per impostazione predefinita
   $feedAtomDaArray = Zend_Feed::importArray(new Zend_Feed_Builder($array), 'atom');

   // importazione di un feed RSS da un costruttore personalizzato
   $feedRssDaArray = Zend_Feed::importArray(new Zend_Feed_Builder($array), 'rss');

.. _zend.feed.importing.custom.dump:

Stampa del contenuto di un feed
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Per stampare il contenuto di un'istanza di *Zend_Feed_Abstract* è possibile utilizzare i metodi *send()* o
*saveXml()*.

.. code-block::
   :linenos:
   <?php
   assert($feed instanceof Zend_Feed_Abstract);

   // stampa il feed su standard output
   print $feed->saveXML();

   // invia gli header http e stampa il feed
   $feed->send();



.. _`RSS 2.0`: http://blogs.law.harvard.edu/tech/rss
.. _`RFC 4287`: http://tools.ietf.org/html/rfc4287
.. _`Well Formed Web`: http://wellformedweb.org/news/wfw_namespace_elements
.. _`Specifiche Tecniche iTunes`: http://www.apple.com/itunes/store/podcaststechspecs.html
