.. _zend.feed.introduction:

Inleiding
=========

*Zend_Feed* verstrekt functionaliteiten om RSS en Atom feeds uit te lezen. Het verstrekt een intuïtieve syntax om
elementen van de feeds te consulteren, attributen ervan en attributen van entries. *Zend_Feed* biedt ook
uitgebreide ondersteuning voor het wijzigen van de structuur van een feed of een entry met dezelfde intuïtieve
syntax, en om de resultaten terug in XLM te gieten. In de toekomst zou deze wijzigingsondersteuning ook het Atom
Publishing Protocol kunnen ondersteunen.

Programmeerswijs bestaat *Zend_Feed* uit een basisklasse *Zend_Feed*, de abstracte klasse *Zend_Feed_Abstract* en
de basisklasse *Zend_Feed_Entry_Abstract* om Feeds en Entries voor te stellen, om specifieke implementaties van
feeds en entries voor RSS en Atom voor te stellen, en een achter-de-scène helper om de intuïtieve syntax magie te
doen werken.

In het hiernavolgende voorbeeld demonstreren we een eenvoudig gebruik om een RSS feed te verkrijgen en relevante
delen ervan in een PHP array op te slaan, welke we dan zouden kunnen gebruiken voor het uitprinten van de data, de
data op te slaan in een database enz...

.. note::

   **Be aware**

   Vele RSS feeds bieden verschillende eigenschappen van kanalen en items. De RSS specificatie verstrekt vele
   optionele eigenschappen, wees er dus van gewaar wanneer je code schrijft om met RSS data te werken.

.. rubric:: Zend_Feed laten werken met RSS Feed Data

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Feed.php';

   // Haal de laatste Slashdot hoofdtitels
   try {
       $slashdotRss = Zend_Feed::import('http://rss.slashdot.org/Slashdot/slashdot');
   } catch (Zend_Feed_Exception $e) {
       // feed import mislukt
       echo "Uitzondering gevangen bij het importeren van feed: {$e->getMessage()}\n";
       exit;
   }

   // De datakanaal Array initializeren
   $channel = array(
       'title'       => $slashdotRss->title(),
       'link'        => $slashdotRss->link(),
       'description' => $slashdotRss->description(),
       'items'       => array()
       );

   // Loop over elk item van het kanaal en sla relevante informatie op
   foreach ($slashdotRss as $item) {
       $channel['items'][] = array(
           'title'       => $item->title(),
           'link'        => $item->link(),
           'description' => $item->description()
           );
   }

   ?>

