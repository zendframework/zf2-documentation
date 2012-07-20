.. _zend.feed.introduction:

Úvod
=====

*Zend_Feed* poskytuje funkcionalitu pre spracovanie RSS a Atom zdrojov. Poskytuje prirodzený spôsob pre prístup
k jednotlivým častiam zdroja, ako sú elementy, atribúty a jednotlivé položky. Okrem toho *Zend_Feed*
poskytuje podporu pre modifikáciu zdroja a jeho položiek a spätné uloženie do XML. V budúcnosti pribudne aj
podpora Atom Publishing Protocol

Programátorsky, *Zend_Feed* pozostáva zo základnej triedy *Zend_Feed* abstraktných tried *Zend_Feed_Abstract* a
*Zend_Feed_Entry_Abstract* pre reprezentáciu zdroja a položiek v zdroji. Ďalej sú to špecifické
implementácie zdroja a jeho položiek pre RSS a Atom.

V uvedenom príklade je ukázané získanie RSS zdroja a uloženie relevantných častí do jednoduchého poľa,
ktoré môže byť použité pre zobrazenie dát, alebo ich uloženie do databázy, atď.

.. note::

   **Uvedomte si**

   Veľa RSS zdrojov ma rôzne prúdy a rôzne vlastnosti. Špecifikácia RSS poskytuje veľa voliteľných
   vlastnosti a preto si dávajte pozor pri písaní kódu ktorý pracuje s RSS zdrojmi.

.. _zend.feed.introduction.example.rss:

.. rubric:: Použitie Zend_Feed na získanie dát z RSS zdroja

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Feed.php';

   // Získanie posledných noviniek zo slashdot.org
   try {
       $slashdotRss = Zend_Feed::import('http://rss.slashdot.org/Slashdot/slashdot');
   } catch (Zend_Feed_Exception $e) {
       // zlyhal import zdroja
       echo "Exception caught importing feed: {$e->getMessage()}\n";
       exit;
   }

   // Získanie info zo zdroja
   $channel = array(
       'title'       => $slashdotRss->title(),
       'link'        => $slashdotRss->link(),
       'description' => $slashdotRss->description(),
       'items'       => array()
       );

   // uloženie relevantných dát z každej položky zdroja
   foreach ($slashdotRss as $item) {
       $channel['items'][] = array(
           'title'       => $item->title(),
           'link'        => $item->link(),
           'description' => $item->description()
           );
   }

   ?>

