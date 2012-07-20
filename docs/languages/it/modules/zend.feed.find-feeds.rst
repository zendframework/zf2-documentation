.. _zend.feed.findFeeds:

Individuazione e recupero di feed da pagine web
===============================================

Le pagine web spesso contengono un tag *<link>* con riferimento ai feed con contenuti rilevanti per quella
particolare pagina. *Zend_Feed* consente di recuperare tutti i feed indicati in una pagina web chiamando
semplicemente un metodo:

.. code-block::
   :linenos:
   <?php
   $feedArray = Zend_Feed::findFeeds('http://www.example.com/news.html');

Il metodo *findFeeds()* restituisce un array di oggetti *Zend_Feed_Abstract* indicati dai tag *<link>* contenuti
nella pagina web news.html. A seconda del tipo di feed, ogni elemento di *$feedArray* potrà essere una istanza di
*Zend_Feed_Rss* o *Zend_Feed_Atom*. *Zend_Feed* genera un'eccezione *Zend_Feed_Exception* in caso di errore, come
ad esempio un codice di risposta HTTP 404 o un feed non valido.


