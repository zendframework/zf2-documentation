.. EN-Revision: none
.. _zend.paginator.advanced:

Advanced usage
==============

.. _zend.paginator.advanced.adapters:

Eigene Adapter für Quelldaten
-----------------------------

An irgendeinem Punkt kann es passieren das man auf einen Datentyp stößt der nicht von den mitgelieferten Adaptern
abgedeckt wird. In diesem Fall muß man seinen eigenen schreiben.

Um das zu tun, muß man ``Zend\Paginator_Adapter\Interface`` implementieren. Es gibt zwei Methoden die hierfür
benötigt werden:

- count()

- getItems($offset, $itemCountPerPage)

Zusätzlich kann es gewünscht sein einen Konstruktor zu implementieren der die Datenquelle als Parameter
entgegennimmt und als geschützte oder private Eigenschaft abspeichert. Wie man das realisieren will liegt komplett
in Eigenverantwortung.

Wenn man jemals schon das SPL Interface `Countable`_ verwendet hat, wird man mit ``count()`` umgehen können.
``Zend_Paginator`` verwendet es als totale Anzahl an Elementen in der Datensammlung. Zusätzlich bietet die
``Zend_Paginator`` Instanz eine ``countAllItems()`` Methode die auf die ``count()`` Methode des Adapters
weiterleitet.

Die ``getItems()`` Methode ist nur etwas komplizierter. Hierfür, wird der Adapter mit einem Offset und der Anzahl
an Einträgen die pro Seite dargestellt werden sollen, gefüttert. Man muß den entsprechenden Bereich an Daten
zurückgeben. Für ein Array wurde das wie folgt funktionieren:

.. code-block:: php
   :linenos:

   return array_slice($this->_array, $offset, $itemCountPerPage);

Man sollte einen Blick auf die mitgelieferten Adapter werfen (alle welche ``Zend\Paginator_Adapter\Interface``
implementieren) um eine Idee zu bekommen wie man das selbst implementieren könnte.

.. _zend.paginator.advanced.scrolling-styles:

Eigene Scrolling Stile
----------------------

Das Erstellen von eigenen Scrolling Stilen erfordert das man ``Zend\Paginator_ScrollingStyle\Interface``
implementiert, welche eine einzelne Methode, ``getPages()``, definiert. Speziell,

.. code-block:: php
   :linenos:

   public function getPages(Zend_Paginator $paginator, $pageRange = null);

Diese Methode sollten eine untere und obere Grenze für die Seitenzahl innerhalb der sogenannten "lokalen" Seiten
berechnen (das sind Seiten nahe der aktuellen Seite).

Solange es keinen anderen Scrolling Stil erweitert (siehe zum Beispiel ``Zend\Paginator_ScrollingStyle\Elastic``,
wird der eigene Scrolling Stil üblicherweise mit etwas ähnlichem sie der folgenden Codezeile enden:

.. code-block:: php
   :linenos:

   return $paginator->getPagesInRange($lowerBound, $upperBound);

Es ist nichts speziellen an diesem Aufruf; es ist mehr eine übliche Methode um die Gültigkeit der unteren und
oberen Grenze zu prüfen und ein Array des Bereichs an den Paginator zurückzugeben.

Wenn man bereit ist den neuen Scrolling Stil zu benutzen, muß man ``Zend_Paginator`` bekanntgeben in welchem
Verzeichnis er nachschauen muß. Um das zu tun muß das folgende ausgeführt werden:

.. code-block:: php
   :linenos:

   $prefix = 'My_Paginator_ScrollingStyle';
   $path   = 'My/Paginator/ScrollingStyle/';
   Zend\Paginator\Paginator::addScrollingStylePrefixPath($prefix, $path);

.. _zend.paginator.advanced.caching:

Caching features
----------------

``Zend_Paginator`` kann gesagt werden das es die Daten die Ihm bereits übergeben wurden, cachen soll, um zu
verhindern das der Adapter sie jedes mal wenn Sie verwendet werden holen muß. Um dem Paginator zu sagen das die
Daten des Adapters automatisch gecacht werden, muß der-``setCache()`` Methode nur eine ``Zend\Cache\Core`` Instanz
übergeben werden.

.. code-block:: php
   :linenos:

   $paginator = Zend\Paginator\Paginator::factory($someData);
   $fO = array('lifetime' => 3600, 'automatic_serialization' => true);
   $bO = array('cache_dir'=>'/tmp');
   $cache = Zend\cache\cache::factory('Core', 'File', $fO, $bO);
   Zend\Paginator\Paginator::setCache($cache);

Sobald ``Zend_Paginator`` eine ``Zend\Cache\Core`` Instanz erhalten hat, werden Daten gecacht. Manchmal will man
Daten nicht cachen selbst wenn man bereits eine Cacheinstanz übergeben hat. Man sollte dann hierfür
``setCacheEnable()`` verwenden.

.. code-block:: php
   :linenos:

   $paginator = Zend\Paginator\Paginator::factory($someData);
   // $cache ist eine Zend\Cache\Core Instanz
   Zend\Paginator\Paginator::setCache($cache);
   // ... später im Skript
   $paginator->setCacheEnable(false);
   // Der Cache ist nun ausgeschaltet

Wenn ein Cache gesetzt ist, werden Daten automatisch in Ihm gespeichert und von Ihm herausgeholt. Es kann nützlich
sein den Cache manuell zu entleeren. Das kann durch den Aufruf von ``clearPageItemCache($pageNumber)`` getan
werden. Wenn kein Parameter übergeben wird, wird der komplette Cache entleert. Optional kann ein Parameter
übergeben werden der die Seitenanzahl repräsentiert die den Cache löschen :

.. code-block:: php
   :linenos:

   $paginator = Zend\Paginator\Paginator::factory($someData);
   Zend\Paginator\Paginator::setCache($cache);
   $items = $paginator->getCurrentItems();
   // Seite 1 ist nun in Cache
   $page3Items = $paginator->getItemsByPage(3);
   // Seite 3 ist nun in Cache

   // Den Cache für die Ergebnisse der Seite 3 löschen
   $paginator->clearPageItemCache(3);

   // Alle Cachedaten löschen
   $paginator->clearPageItemCache();

Das Ändern das Anzahl der Teile pro Seite wird den kompletten Cache leeren, das er ungültig geworden wäre :

.. code-block:: php
   :linenos:

   $paginator = Zend\Paginator\Paginator::factory($someData);
   Zend\Paginator\Paginator::setCache($cache);
   // Einige Teile holen
   $items = $paginator->getCurrentItems();

   // Alle Cachedaten werden ausgegeben :
   $paginator->setItemCountPerPage(2);

Es ist auch möglich zu sehen welche Daten im Cache sind und direkt nach Ihnen zu fragen. Hierfür kann
``getPageItemCache()`` verwendet werden:

.. code-block:: php
   :linenos:

   $paginator = Zend\Paginator\Paginator::factory($someData);
   $paginator->setItemCountPerPage(3);
   Zend\Paginator\Paginator::setCache($cache);

   // Einige Teile holen
   $items = $paginator->getCurrentItems();
   $otherItems = $paginator->getItemsPerPage(4);

   // Die gecachten Teile als zwei-dimensionales Array sehen
   var_dump($paginator->getPageItemCache());

.. _zend.paginator.advanced.aggregator:

Zend\Paginator\AdapterAggregate Interface
-----------------------------------------

Abhängig von der Anwendung kann es gewünscht sein Objekte zu Seiten zu verarbeiten, dessen interne Datenstruktur
identisch zu existierenden Adaptern ist, aber bei denen man nicht will das die eigene Kapselung gebrochen wird um
Zugriff auf diese Daten zu erlauben. In anderen Fällen könnte ein Objekt in einer "hat einen Adapter" Relation
stehen, statt in einer "ist ein Adapter" Relation die ``Zend\Paginator_Adapter\Abstract`` promotet. Für diese
Fälle kann man das ``Zend\Paginator\AdapterAggregate`` Interface verwenden das sich so verhält wie das
``IteratorAggregate`` Interface der SPL Erweiterung von *PHP*.

.. code-block:: php
   :linenos:

   interface Zend\Paginator\AdapterAggregate
   {
       /**
        * Return a fully configured Paginator Adapter from this method.
        *
        * @return Zend\Paginator_Adapter\Abstract
        */
       public function getPaginatorAdapter();
   }

Das Interface ist sehr klein und erwartet nur das eine Instanz von ``Zend\Paginator_Adapter\Abstract``
zurückgegeben wird. Eine Aggregate Instanz des Adapters wird dann von beiden erkannt, sowohl
``Zend\Paginator\Paginator::factory()`` als auch dem Constructor von ``Zend_Paginator`` und entsprechend behandelt.



.. _`Countable`: http://www.php.net/~helly/php/ext/spl/interfaceCountable.html
