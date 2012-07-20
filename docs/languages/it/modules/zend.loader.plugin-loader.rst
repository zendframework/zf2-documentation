.. _zend.loader.pluginloader:

Caricamento di plugin
=====================

Diversi componenti del Framework Zend sono estendibili e permettono il caricamento dinamico di funzionalità
specificando un prefisso di classe ed un percorso ai file contenenti le classi che non necessariamente rientra nei
percorsi specificati in *include_path* o segue le convenzioni tradizionali sui nomi di classe.
*Zend_Loader_PluginLoader* fornisce funzionalità comuni per quest'attività.

L'utilizzo base di *PluginLoader* segue le convenzioni sui nomi di Zend Framework che prevedono una classe per
file, utilizzando l'underscore "\_" come carattere separatore delle cartelle nell'indicazione del percorso
completo. Permette di specificare un prefisso opzionale per il nome delle classi da prependere nel controllo sul
caricamento di una classe. In aggiunta, i percorsi sono cercati nell'ordine LIFO. La ricerca di tipo LIFO ed i
prefissi di classe consentono di aggiungere namespace ai propri plugin e sovrascrivere plugin da percorsi
registrati precedentemente.

.. _zend.loader.pluginloader.usage:

Esempio di utilizzo base
------------------------

Innanzi tutto, si assuma la seguente struttura di cartelle e file contenenti classi e che le cartelle application e
library siano incluse in *include_path*:

.. code-block::
   :linenos:

   application/
       modules/
           foo/
               views/
                   helpers/
                       FormLabel.php
                       FormSubmit.php
           bar/
               views/
                   helpers/
                       FormSubmit.php
   library/
       Zend/
           View/
               Helper/
                   FormLabel.php
                   FormSubmit.php
                   FormText.php

Si crei ora un plugin loader per caricare tutti i metodi a supporto (helper) per le viste (view) disponibili:

.. code-block::
   :linenos:
   <?php
   $loader = new Zend_Loader_PluginLoader();
   $loader->addPrefixPath('Zend_View_Helper', 'Zend/View/Helper/')
          ->addPrefixPath('Foo_View_Helper', 'application/modules/foo/views/helpers')
          ->addPrefixPath('Bar_View_Helper', 'application/modules/bar/views/helpers');
   ?>
Ora è possibile caricare un helper specifico utilizzando esclusivamente la porzione corrispondente al nome della
classe dopo al prefisso così come specificato nell'aggiunta dei percorsi:

.. code-block::
   :linenos:
   <?php
   // load 'FormText' helper:
   $formTextClass = $loader->load('FormText'); // 'Zend_View_Helper_FormText';

   // load 'FormLabel' helper:
   $formLabelClass = $loader->load('FormLabel'); // 'Foo_View_Helper_FormLabel'

   // load 'FormSubmit' helper:
   $formSubmitClass = $loader->load('FormSubmit'); // 'Bar_View_Helper_FormSubmit'
   ?>
Una volta che la classe è caricata, è possibile crearne una nuova istanza.

.. note::

   **Registrazione di più percorsi per un prefisso**

   In alcuni casi, è necessario utilizzare lo stesso prefisso per percorsi differenti. Attualmente
   *Zend_Loader_PluginLoader* registra un array di percorsi per ogni prefisso specificato; l'ultimo registrato è
   il primo ad essere controllato. Questa soluzione è particolarmente utile se si utilizzano componenti in
   incubator (NdT. la cartella contenente i moduli dello Zend Framework ancora in fase di sviluppo).

.. note::

   **E' possibile definire i percorsi in fase di creazione di un'istanza**

   Opzionalmente è possibile fornire un array di coppie prefisso / percorso (o prefisso / percorsi -- sono ammessi
   più percorsi) come parametro del costruttore:

   .. code-block::
      :linenos:
      <?php
      $loader = new Zend_Loader_PluginLoader(array(
          'Zend_View_Helper' => 'Zend/View/Helper/',
          'Foo_View_Helper'  => 'application/modules/foo/views/helpers',
          'Bar_View_Helper'  => 'application/modules/bar/views/helpers'
      ));
      ?>
*Zend_Loader_PluginLoader* consente anche, opzionalmente, di condividere plugin tra diversi oggetti compatibili
senza la necessità di utilizzare un'istanza singleton. Questo è possibile grazie ad un registro statico. Indicare
il nome del registro in fase di creazione di una nuova istanza, come secondo parametro del costruttore:

.. code-block::
   :linenos:
   <?php
   // Store plugins in static registry 'foobar':
   $loader = new Zend_Loader_PluginLoader(array(), 'foobar');
   ?>
Altri componenti che istanziano *PluginLoader* utilizzando lo stesso nome di registro avranno accesso a tutti i
plugin e percorsi già caricati.

.. _zend.loader.pluginloader.paths:

Manipolazione dei percorsi dei plugin
-------------------------------------

L'esempio nella sezione precedente mostra come aggiungere percorsi al plugin loader. Come fare per determinare i
percorsi già caricati, per rimuoverne uno o più?

- *getPaths($prefix = null)* restituisce tutti i percorsi come coppie prefisso / percorso se non è fornito alcun
  *$prefix* oppure solo i percorsi registrati per un determinato prefisso se *$prefix* è presente.

- *clearPaths($prefix = null)* rimuove tutti i percorsi predefiniti registrati oppure solo quelli associati ad un
  determinato prefisso se *$prefix* è disponibile e presente nella pila.

- *removePrefixPath($prefix, $path = null)* permette di rimuovere selettivamente un percorso specifico associato ad
  un dato prefisso. Se viene indicato *$path* ed il valore esiste per il dato prefisso, allora verrà rimosso solo
  quel percorso.

.. _zend.loader.pluginloader.checks:

Verifica di plugin ed estrazione dei nomi delle classi
------------------------------------------------------

Qualche volta è necessario determinare semplicemente se la classe di un plugin è stata caricata prima di eseguire
un'azione. *isLoaded()* accetta il nome di un plugin e restituisce lo status.

Un altro uso comune per *PluginLoader* è determinare i nomi completi delle classi dei plugin corrispondenti alle
classi caricate; questa funzionalità è offerta da *getClassName()*. Tipicamente, la si utilizza insieme a
*isLoaded()*:

.. code-block::
   :linenos:
   <?php
   if ($loader->isLoaded('Adapter')) {
       $class   = $loader->getClassName('Adapter');
       $adapter = call_user_func(array($class, 'getInstance'));
   }
   ?>

