.. _zend.mail.read:

Lettura di messaggi e-mail
==========================

*Zend_Mail* può leggere messaggi e-mail da diversi sistemi di salvataggio locali o remoti. Ciascuno di essi ha le
stesse API alla base per contare e leggere i messaggi ed alcuni implementano interfacce aggiuntive per
funzionalità non così comuni. Per una panoramica delle funzionalità dei sistemi di raccolta consultare la
tabella seguente.

.. _zend.mail.read.table-1:

.. table:: Panoramica delle caratteristiche dei sistemi di lettura di e-mail

   +----------------------------+-------+-------+-------+-------+
   |Funzionalità                |Mbox   |Maildir|Pop3   |IMAP   |
   +============================+=======+=======+=======+=======+
   |Tipo di salvataggio         |locale |locale |remoto |remoto |
   +----------------------------+-------+-------+-------+-------+
   |Estrazione dei messaggi     |Yes    |Yes    |Yes    |Yes    |
   +----------------------------+-------+-------+-------+-------+
   |Estrazione delle parti mime |emulata|emulata|emulata|emulata|
   +----------------------------+-------+-------+-------+-------+
   |Cartelle                    |Si     |Si     |No     |Si     |
   +----------------------------+-------+-------+-------+-------+
   |Creazione messaggio/cartella|No     |Da fare|No     |Da fare|
   +----------------------------+-------+-------+-------+-------+
   |Flags                       |No     |Si     |No     |Si     |
   +----------------------------+-------+-------+-------+-------+

.. _zend.mail.read-example:

Semplice esempio usando Pop3
----------------------------

.. code-block:: php
   :linenos:

   <?php
   $mail = new Zend_Mail_Storage_Pop3(array('host'     => 'localhost',
                                            'user'     => 'test',
                                            'password' => 'test'));

   echo $mail->countMessages() . " messaggi trovati\n";
   foreach ($mail as $message) {
       echo "E-mail da '{$message->from}': {$message->subject}\n";
   }

.. _zend.mail.read-open-local:

Apertura di un sistema di salvataggio locale
--------------------------------------------

Mbox e Maildir sono due formati supportati per lo salvataggio locale delle e-mail, entrambi nel loro formato più
semplice.

Se si desidera leggere da un file Mbox è sufficiente fornire il nome del file al costruttore di
*Zend_Mail_Storage_Mbox*:

.. code-block:: php
   :linenos:

   <?php
   $mail = new Zend_Mail_Storage_Mbox(array('filename' => '/home/test/mail/inbox'));

Maildir è molto simile ma necessita il nome di una cartella:

.. code-block:: php
   :linenos:

   <?php
   $mail = new Zend_Mail_Storage_Maildir(array('dirname' => '/home/test/mail/'));

Entrambi i costruttori generano un'eccezione *Zend_Mail_Exception* se l'archivio non può essere letto.

.. _zend.mail.read-open-remote:

Apertura di un sistema di salvataggio remoto
--------------------------------------------

Per quanto riguarda i sistemi di salvataggio remoto i due protocolli più popolari sono entrambi supportati: Pop3 e
Imap. Entrambi necessitano almeno di un host ed un utente per connettersi ed autenticarsi. La password predefinita
è una stringa vuota, la porta predefinita quella specificata nel protocollo RFC.

.. code-block:: php
   :linenos:

   <?php
   // connessione con Pop3
   $mail = new Zend_Mail_Storage_Pop3(array('host'     => 'example.com'
                                            'user'     => 'test',
                                            'password' => 'test'));

   // connessione con Imap
   $mail = new Zend_Mail_Storage_Imap(array('host'     => 'example.com'
                                            'user'     => 'test',
                                            'password' => 'test'));

   // esempio di una porta non standard
   $mail = new Zend_Mail_Storage_Pop3(array('host'     => 'example.com',
                                            'port'     => 1120
                                            'user'     => 'test',
                                            'password' => 'test'));

Per entrambi i protocolli sono supportate le connessioni SSL e TSL. Se si utilizza SSL, la porta predefinita cambia
come specificato in RFC.

.. code-block:: php
   :linenos:

   <?php
   // esempi per Zend_Mail_Storage_Pop3, gli stessi funzionano per Zend_Mail_Storage_Imap

   // utilizzo di SSL su una porta differente
   // (i valori predefiniti sono 995 per Pop3 e 993 per Imap)
   $mail = new Zend_Mail_Storage_Pop3(array('host'     => 'example.com'
                                            'user'     => 'test',
                                            'password' => 'test',
                                            'ssl'      => 'SSL'));

   // use TLS
   $mail = new Zend_Mail_Storage_Pop3(array('host'     => 'example.com'
                                            'user'     => 'test',
                                            'password' => 'test',
                                            'ssl'      => 'TLS'));

Entrambi i costruttori possono restituire un'eccezione *Zend_Mail_Exception* o *Zend_Mail_Protocol_Exception*, a
seconda del tipo di errore.

.. _zend.mail.read-fetching:

Lettura dei messaggi e semplici metodi
--------------------------------------

Una volta aperta la connessione, è possibile estrarre i messaggi. E' necessario il numero di messaggi, che
rappresenta un contatore che parte da 1 per il primo messaggio. Per estrarre il messaggio si utilizza il metodo
*getMessage()*:

.. code-block:: php
   :linenos:

   <?php
   $message = $mail->getMessage($messageNum);

L'accesso sotto forma di array è supportato, ma non consente di specificare alcun parametro aggiuntivo al metodo
*getMessage()*. Se questo non è un problema e si può vivere anche solo con i valori predefiniti, allora si può
usare:

.. code-block:: php
   :linenos:

   <?php
   $message = $mail[$messageNum];

L'interfaccia Iterator è implementata e consente di scorrere tutti i messaggi:

.. code-block:: php
   :linenos:

   <?php
   foreach ($mail as $messageNum => $message) {
       // fai qualcosa ...
   }

Per contare i messaggi salvati è possibile usare sia il metodo *countMessages()* sia l'accesso del tipo array:

.. code-block:: php
   :linenos:

   <?php
   // metodo
   $maxMessage = $mail->countMessages();

   // accesso array
   $maxMessage = count($mail);

Per rimuovere un'e-mail si utilizzi il metodo *removeMessage()* o, nuovamente, l'accesso del tipo array:

.. code-block:: php
   :linenos:

   <?php
   // metodo
   $mail->removeMessage($messageNum);

   // accesso array
   unset($mail[$messageNum]);

.. _zend.mail.read-message:

Interazione con i messaggi
--------------------------

Dopo aver estratto i messaggi *getMessage()* potrebbe essere necessario estrarre le intestazioni, il contenuto o
singole parti di un messaggio multipart. Tutte le intestazioni sono accessibili come proprietà o grazie al metodo
*getHeader()* se è necessario maggiore controllo o in caso di nomi di intestazioni poco comuni. Internamente,
tutte le intestazioni sono convertite in minuscolo dunque il caso del testo nel nome non è importante. Inoltre, le
intestazioni che contengono un trattino "-" possono essere scritte con la notazione CamelCase.

.. code-block:: php
   :linenos:

   <?php
   // recupera l'oggetto messaggio
   $message = $mail->getMessage(1);

   // stampa l'oggetto del messaggio
   echo $message->subject . "\n";

   // recupera l'intestazione content-type
   $type = $message->contentType;

In caso di più intestazioni con lo stesso nome, esempio l'intestazione *Received*, è possibile recuperare il
valore come array invece che stringa con il metodo *getHeader()*.

.. code-block:: php
   :linenos:

   <?php
   // recupera l'intestazione come proprietà
   // il risultato è sempre una stringa,
   // dove le diverse occorrenze sono separate dal carattere carattere newline (\n)
   $received = $message->received;

   // stesso risultato usando il metodo getHeader()
   $received = $message->getHeader('received', 'string');

   // o, meglio, un array contenente un elemento per ogni occorrenza
   $received = $message->getHeader('received', 'array');
   foreach ($received as $line) {
       // fai qualcosa
   }

   // se non si definisce un formato si ottiene la rappresentazione interna
   // (stringa per singole intestazioni, array per multipli)
   $received = $message->getHeader('received');
   if (is_string($received)) {
       // trovata una sola intestazione received nel messaggio
   }

Il metodo *getHeaders()* restituisce tutte le intestazioni come array. Per ogni elemento, la chiave corrisponde al
nome dell'intestazione in minuscolo, il valore è un array nel caso di intestazioni multiple, una stringa per
intestazioni singole.

.. code-block:: php
   :linenos:

   <?php
   // stampa tutte le intestazioni
   foreach ($message->getHeaders() as $name => $value) {
       if (is_string($value)) {
           echo "$name: $value\n";
           continue;
       }
       foreach ($value as $entry) {
           echo "$name: $entry\n";
       }
   }

Se il messaggio non è di tipo multipart la sua lettura è immediata con il metodo *getContent()*. A differenza
delle intestazioni, il contenuto è caricato solo in caso di necessità (late-fetch).

.. code-block:: php
   :linenos:

   <?php
   // stampa il contenuto del messaggio
   echo '<pre>';
   echo $message->getContent();
   echo '</pre>';

La verifica di un messaggio multipart avviene con il metodo *isMultipart()*. In caso positivo, è possibile
ottenere un'istanza di *Zend_Mail_Part* con il metodo *getPart()*. *Zend_Mail_Part* è la classe alla base di
*Zend_Mail_Message*, quindi si ha accesso agli stessi metodi: *getHeader()*, *getHeaders()*, *getContent()*,
*getPart()*, *isMultipart* e le proprietà per le intestazioni.

.. code-block:: php
   :linenos:

   <?php
   // recupera la prima parte non multipart
   $part = $message;
   while ($part->isMultipart()) {
       $part = $message->getPart(1);
   }
   echo 'Il tipo di questa parte è ' . strtok($part->contentType, ';') . "\n";
   echo "Contenuto:\n";
   echo $part->getContent();

*Zend_Mail_Part* implementa *RecursiveIterator* che semplifica l'iterazione di tutte le parti. Inoltre, per
agevolare l'ouput, implementa il metodo magico *__toString()* che restituisce il contenuto.

.. code-block:: php
   :linenos:

   <?php
   // stampa la prima parte text/plain
   $foundPart = null;
   foreach (new RecursiveIteratorIterator($mail->getMessage(1)) as $part) {
       try {
           if (strtok($part->contentType, ';') == 'text/plain') {
               $foundPart = $part;
               break;
           }
       } catch (Zend_Mail_Exception $e) {
           // ignora
       }
   }
   if (!$foundPart) {
       echo 'Nessuna parte solo testo trovata';
   } else {
       echo "Parte solo testo: \n" . $foundPart;
   }

.. _zend.mail.read-flags:

Controllo dei contrassegni
--------------------------

Maildir e IMAP supportano il salvataggio dei contrassegni. La classe Zend_Mail_Storage include costanti per tutti i
tipi di contrassegno IMAP e maildir conosciuti, chiamati *Zend_Mail_Storage::FLAG_<flagname>*. *Zend_Mail_Message*
contiene un metodo chiamato *hasFlag()* per eseguire un controllo dei contrassegni. Il metodo *getFlags()*
restituisce invece tutti i contrassegni impostati.

.. code-block:: php
   :linenos:

   <?php
   // cerca i messaggi non letti
   echo "E-mail da leggere:\n";
   foreach ($mail as $message) {
       if ($message->hasFlag(Zend_Mail_Storage::FLAG_SEEN)) {
           continue;
       }
       // distingui le e-mail recenti/nuove
       if ($message->hasFlag(Zend_Mail_Storage::FLAG_RECENT)) {
           echo '! ';
       } else {
           echo '  ';
       }
       echo $message->subject . "\n";
   }


   // verifica i contrassegni conosciuti
   $flags = $message->getFlags();
   echo "Il messaggio è contrassegnato come: ";
   foreach ($flags as $flag) {
       switch ($flag) {
           case Zend_Mail_Storage::FLAG_ANSWERED:
               echo 'Risposto ';
               break;
           case Zend_Mail_Storage::FLAG_FLAGGED:
               echo 'Contrassegnato ';
               break;

           // ...
           // verifica altri contrassegni
           // ...

           default:
               echo $flag . '(contrassegno sconosciuto) ';
       }
   }

Poiché IMAP permette all'utente o al client di definire contrassegni personalizzati, potrebbero esistere
contrassegni senza una costante corrispondente in *Zend_Mail_Storage*. In questo caso i valori sono restituiti come
stringa e possono essere verificati allo stesso modo con *hasFlag()*.

.. code-block:: php
   :linenos:

   <?php
   // verifica il messaggio alla ricerca dei contrassegni
   // $IsSpam, $SpamTested impostati dal client
   if (!$message->hasFlag('$SpamTested')) {
       echo 'Messaggio non verificato dal controllo anti spam';
   } else if ($message->hasFlag('$IsSpam')) {
       echo 'Questo messaggio è spam';
   } else {
       echo 'Questo messaggio è sicuro';
   }

.. _zend.mail.read-folders:

Utilizzo delle cartelle
-----------------------

Tutti i sistemi di salvataggio, eccetto Pop3, supportano le cartelle anche chiamate mailbox. L'interfaccia
implementata dai sistemi che supportano le cartelle si chiama *Zend_Mail_Storage_Folder_Interface*. Inoltre, tutte
queste classi contengono un parametro opzionale aggiuntivo chiamato *folder* che rappresenta la cartella
selezionata dopo l'autenticazione, nel costruttore.

Per i sistemi di salvataggio locali è necessario usare delle classi a parte chiamate
*Zend_Mail_Storage_Folder_Mbox* o *Zend_Mail_Storage_Folder_Maildir*. Entrambe necessitano di un parametro chiamato
*dirname* che corrisponde alla cartella principale. Il formato per maildir è definito in maildir++ (con un punto
come delimitatore predefinito), in Mbox è una gerarchia di directory contenenti file Mbox. Se nella cartella
principale di Mbox non è presente un file Mbox chiamato INBOX, allora è necessario specificare un'altra cartella
nel costruttore.

Il supporto alle cartelle è nativo in *Zend_Mail_Storage_Imap*. Alcuni esempi per aprire questi sistemi di
salvataggio:

.. code-block:: php
   :linenos:

   <?php
   // mbox con cartelle
   $mail = new Zend_Mail_Storage_Folder_Mbox(array('dirname' => '/home/test/mail/'));

   // mbox con una cartella predefinita non chiamata INBOX,
   // funziona anche con Zend_Mail_Storage_Folder_Maildir e Zend_Mail_Storage_Imap
   $mail = new Zend_Mail_Storage_Folder_Mbox(array('dirname' => '/home/test/mail/',
                                                   'folder'  => 'Archive'));

   // maildir con cartelle
   $mail = new Zend_Mail_Storage_Folder_Maildir(array('dirname' => '/home/test/mail/'));

   // maildir con due punti come delimitatore, come suggerito in Maildir++
   $mail = new Zend_Mail_Storage_Folder_Maildir(array('dirname' => '/home/test/mail/'
                                                      'delim'   => ':'));

   // imap è lo stesso con o senza cartelle
   $mail = new Zend_Mail_Storage_Imap(array('host'     => 'example.com'
                                            'user'     => 'test',
                                            'password' => 'test'));

Con il metodo getFolders($root = null) si ottiene la gerarchia delle cartelle a partire dalla cartella root o da
quella specificata. Restituisce un'istanza di *Zend_Mail_Storage_Folder*, che implementa *RecursiveIterator* e
tutte le sottocartelle sono a loro volta istanze di *Zend_Mail_Storage_Folder*. Ciascuna di queste istanze contiene
un nome locale e globale restituiti rispettivamente dai metodi *getLocalName()* e *getGlobalName()*. Il nome
globale è il nome assoluto a partire dalla cartella principale (inclusi i delimitatori), il nome locale è invece
il nome specifico assunto nella cartella di livello superiore.

.. _zend.mail.read-folders.table-1:

.. table:: Nomi delle cartelle e-mail

   +---------------+-----------+
   |Nome Globale   |Nome Locale|
   +===============+===========+
   |/INBOX         |INBOX      |
   +---------------+-----------+
   |/Archive/2005  |2005       |
   +---------------+-----------+
   |List.ZF.General|General    |
   +---------------+-----------+

Se si utilizza un iteratore la chiave dell'elemento corrente corrisponde al nome locale. Il nome globale è anche
restituito dal metodo magico *__toString()*. Alcune cartelle non sono selezionabili, ovvero non è possibile
salvare all'interno dei messaggi e se selezionate il risultato è un errore. E' possibile eseguire un controllo con
il metodo *isSelectable()*. E' molto semplice stampare la visualizzazione dell'intero albero delle cartelle:

.. code-block:: php
   :linenos:

   <?php
   $folders = new RecursiveIteratorIterator($this->mail->getFolders(),
                                            RecursiveIteratorIterator::SELF_FIRST);
   echo '<select name="folder">';
   foreach ($folders as $localName => $folder) {
       $localName = str_pad('', $folders->getDepth(), '-', STR_PAD_LEFT) . $localName;
       echo '<option';
       if (!$folder->isSelectable()) {
           echo ' disabled="disabled"';
       }
       echo ' value="' . htmlspecialchars($folder) . '">'
           . htmlspecialchars($localName) . '</option>';
   }
   echo '</select>';

Il metodo *getSelectedFolder()* restituisce la cartella corrente selezionata. Per cambiare la cartella utilizzare
il metodo *selectFolder()*, che necessita del nome globale come parametro. Per evitare di scrivere i delimitatori
è possibile utilizzare le proprietà di un'istanza *Zend_Mail_Storage_Folder*:

.. code-block:: php
   :linenos:

   <?php
   // a seconda del sistema di salvataggio e delle impostazioni $rootFolder->Archive->2005
   // è identico a:
   //  /Archive/2005
   //  Archive:2005
   //  INBOX.Archive.2005
   //  ...
   $folder = $mail->getFolders()->Archive->2005;
   echo "L'ultima cartella era " . $mail->getSelectedFolder() . " la nuova cartella è $folder\n";
   $mail->selectFolder($folder);

.. _zend.mail.read-advanced:

Utilizzo avanzato
-----------------

.. _zend.mail.read-advanced.noop:

Utilizzo di NOOP
^^^^^^^^^^^^^^^^

Se si utilizza un sistema di salvataggio remoto e si devono eseguire alcune attività di lunga durata, è
necessario mantenere attiva la connessione via noop:

.. code-block:: php
   :linenos:

   <?php
   foreach ($mail as $message) {

       // esegui qualche elaborazione ...

       $mail->noop(); // keep alive

       // esegui qualche altra elaborazione ...

       $mail->noop(); // keep alive
   }

.. _zend.mail.read-advanced.caching:

Salvataggio in cache delle istanze
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*Zend_Mail_Storage_Mbox*, *Zend_Mail_Storage_Folder_Mbox*, *Zend_Mail_Storage_Maildir* e
*Zend_Mail_Storage_Folder_Maildir* implementano i metodi magici *__sleep()* e *__wakeup()*, dunque sono
serializzabili. Questo evita di eseguire la lettura dei file o delle cartelle più di una volta. Lo svantaggio è
che la struttura Mbox o Maildir non deve cambiare. Sono eseguiti alcuni semplici controlli, come ad esempio la
rilettura del file Mbox corrente in caso di variazione della data di ultima modifica o la rilettura della struttura
delle cartelle se una cartella è scomparsa (l'errore persiste, ma è possibile cercare una nuova cartella
successivamente). Ad ogni modo, è meglio mantenere qualcosa come un file indicatore dei cambiamenti e verificarlo
prima di utilizzare un'istanza salvata in cache.

.. code-block:: php
   :linenos:

   <?php
   // non c'è alcuna classe/gestore per la cache specificato qui,
   // modificare il codice con il gestore di cache in uso
   $signal_file = '/home/test/.mail.last_change';
   $mbox_basedir = '/home/test/mail/';
   $cache_id = 'esempio di email in cache ' . $mbox_basedir . $signal_file;

   $cache = new Your_Cache_Class();
   if (!$cache->isCached($cache_id) || filemtime($signal_file) > $cache->getMTime($cache_id)) {
       $mail = new Zend_Mail_Storage_Folder_Pop3(array('dirname' => $mbox_basedir));
   } else {
       $mail = $cache->get($cache_id);
   }

   // fai qualcosa ...

   $cache->set($cache_id, $mail);

.. _zend.mail.read-advanced.extending:

Estensione delle classi dei protocolli
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I sistemi di salvataggio remoti utilizzano due classi: *Zend_Mail_Storage_<Name>* e *Zend_Mail_Protocol_<Name>*. La
classe protocol traduce i comandi e le risposte da e in PHP, come ad esempio i metodi per i comandi o le variabili
con strutture di dati differenti. L'altra classe principale implementa l'interfaccia comune.

Per aggiungere ulteriori funzionalità ad un protocollo è possibile estendere la classe ed utilizzarla nel
costruttore della classe principale. Per esempio si assuma di dover utilizzare una porta differente per aprire una
connessione POP3.

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Loader.php';
   Zend_Loader::loadClass('Zend_Mail_Storage_Pop3');

   class Example_Mail_Exception extends Zend_Mail_Exception
   {
   }

   class Example_Mail_Protocol_Exception extends Zend_Mail_Protocol_Exception
   {
   }

   class Example_Mail_Protocol_Pop3_Knock extends Zend_Mail_Protocol_Pop3
   {
       private $host, $port;

       public function __construct($host, $port = null)
       {
           // nessuna connessione automatica in questa classe
           $this->host = $host;
           $this->port = $port;
       }

       public function knock($port)
       {
           $sock = @fsockopen($this->host, $port);
           if ($sock) {
               fclose($sock);
           }
       }

       public function connect($host = null, $port = null, $ssl = false)
       {
           if ($host === null) {
               $host = $this->host;
           }
           if ($port === null) {
               $port = $this->port;
           }
           parent::connect($host, $port);
       }
   }

   class Example_Mail_Pop3_Knock extends Zend_Mail_Storage_Pop3
   {
       public function __construct(array $params)
       {
           // ... verifica qui $params! ...
           $protocol = new Example_Mail_Protocol_Pop3_Knock($params['host']);

           // esegui i nostri comandi "speciali"
           foreach ((array)$params['knock_ports'] as $port) {
               $protocol->knock($port);
           }

           // recupera lo status corretto
           $protocol->connect($params['host'], $params['port']);
           $protocol->login($params['user'], $params['password']);

           // inizializza la classe genitore
           parent::__construct($protocol);
       }
   }

   $mail = new Example_Mail_Pop3_Knock(array('host'        => 'localhost',
                                             'user'        => 'test',
                                             'password'    => 'test',
                                             'knock_ports' => array(1101, 1105, 1111)));

Come è possibile notare si suppone sempre di essere connessi, autenticati e, se supportato, una cartella è
selezionata nel costruttore della classe principale. Quindi, se si assegna una classe protocollo personalizzata è
necessario assicurarsi che tutto questo sia avvenuto correttamente o il metodo seguente non andrà a buon fine se
il server non lo permette nello status corrente.


