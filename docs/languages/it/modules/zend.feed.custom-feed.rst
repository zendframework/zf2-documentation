.. EN-Revision: none
.. _zend.feed.custom-feed:

Classi personalizzate per feed ed elementi
==========================================

Infine, è possibile estendere la classe *Zend_Feed* se si desidera offrire un proprio formato o raffinatezze come
la gestione automatica di elementi all'interno di namespace personalizzati.

Ecco un esempio di un elemento personalizzato di un feed Atom che gestisce un proprio namespace *mions:*. Si noti
come la classe si occupa di eseguire anche la richiesta a *registerNamespace()* in modo che l'utente finale non
debba preoccuparsi affatto dell'uso dei namespace.

.. _zend.feed.custom-feed.example.extending:

.. rubric:: Estensione della classe elemento Atom con namespace personalizzati

.. code-block:: php
   :linenos:

   <?php
   /**
    * La classe elemento personalizzata conosce l'URI del feed (opzionale) e
    * può aggiungere ulteriori namespace in automatico
    */
   class MyEntry extends Zend\Feed_Entry\Atom
   {

       public function __construct($uri = 'http://www.example.com/myfeed/',
                                   $xml = null)
       {
           parent::__construct($uri, $xml);

           Zend\Feed\Feed::registerNamespace('mions', 'http://www.example.com/mions/1.0');
       }

       public function __get($var)
       {
           switch ($var) {
               case 'myUpdated':
                   // Converti myUpdated in mions:updated.
                   return parent::__get('mions:updated');

               default:
                   return parent::__get($var);
               }
       }

       public function __set($var, $value)
       {
           switch ($var) {
               case 'myUpdated':
                   // Converti myUpdated in mions:updated.
                   parent::__set('mions:updated', $value);
                   break;

               default:
                   parent::__set($var, $value);
           }
       }

       public function __call($var, $unused)
       {
           switch ($var) {
               case 'myUpdated':
                   // Converti myUpdated to myns:updated.
                   return parent::__call('myns:updated', $unused);

               default:
                   return parent::__call($var, $unused);
           }
       }
   }

A questo punto per utilizzare la classe è sufficiente crearne direttamente un'istanza ed impostare la proprietà
*myUpdated*:

.. code-block:: php
   :linenos:

   <?php
   $entry = new MyEntry();
   $entry->myUpdated = '2005-04-19T15:30';

   // la chiamata in stile metodo è gestita dalla funzione __call
   $entry->myUpdated();
   // la chiamata in stile proprietà è gestita dalla funzione __get
   $entry->myUpdated;


