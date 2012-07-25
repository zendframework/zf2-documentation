.. _zend.feed.findFeeds:

Retrieving Feeds from Web Pages
===============================

Web stránky často obsahujú *<link>* značku, ktorá odkazuje na zdroje s obsahom ktoré sú relevantné ku
konkrétnej stránke. *Zend_Feed* umožňuje získať referencie na všetky uvedené zdroje na web stránke pomocou
jednoduchého volania metódy:

.. code-block:: php
   :linenos:

   <?php

   $feedArray = Zend_Feed::findFeeds('http://www.example.com/news.html');

   ?>
Metóda *findFeeds()* vráti pole objektov typu *Zend_Feed_Abstract* pre každý rozpoznaný *<link>* na stránke
news.html V závislosti od typu zdroja je každá položka v poli *$feedArray* je inštancia objektu
*Zend_Feed_Rss* alebo *Zend_Feed_Atom*. *Zend_Feed* môže vyvolať výnimku *Zend_Feed_Exception* v prípade
chyby, napríklad chyba 404 v prípade HTTP alebo nespracovateľný (chybný) zdroj.


