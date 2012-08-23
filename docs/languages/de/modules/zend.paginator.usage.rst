.. EN-Revision: none
.. _zend.paginator.usage:

Verwendung
==========

.. _zend.paginator.usage.paginating:

Seitendarstellung von Datensammlungen
-------------------------------------

Um Elemente in Seiten darzustellen muß ``Zend_Paginator`` einen generellen Weg des Zugriffs auf diese Daten haben.
Für diesen Zweck, läuft jeder Datenzugriff über Datenquellen Adapter. Verschiedene Adapter werden mit dem Zend
Framework standardmäßig ausgeliefert:

.. _zend.paginator.usage.paginating.adapters:

.. table:: Adapter für Zend_Paginator

   +-------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Adapter      |Beschreibung                                                                                                                                                                                             |
   +=============+=========================================================================================================================================================================================================+
   |Array        |Verwendet ein PHP Array                                                                                                                                                                                  |
   +-------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |DbSelect     |Verwendet eine Instanz von Zend_Db_Select, welche ein Array zurückgibt                                                                                                                                   |
   +-------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |DbTableSelect|Verwendet eine Instanz von Zend_Db_Table_Select, welche eine Instanz von Zend_Db_Table_Rowset_Abstract zurückgibt. Das gibt zusätzliche Information pber das Ergebnisset, wie z.B. die Namen der Spalten.|
   +-------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Iterator     |Verwendet eine Instanz von Iterator                                                                                                                                                                      |
   +-------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Null         |Zend_Paginator nicht für das Verwalten von seitenweisen Daten verwenden. Man kann trotzdem die Vorteile des Features der Seitenkontrolle verwenden.                                                      |
   +-------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. note::

   Statt jede passende Zeile einer gegebenen Abfrage auszuwählen, empfangen die DbSelect und DbTableSelect Adapter
   nur die kleinste Anzahl an Daten die für die Darstellung der aktuellen Seite notwendig sind.

   Deswegen wird dynamisch eine zweite Abfrage erzeugt um die komplette Anzahl an passenden Zeilen festzustellen.
   Trotzdem ist es möglich die Anzahl oder die Abfrage für die Anzahl selbst direkt zu übergeben. Siehe die
   ``setRowCount()`` Methode im DbSelect Adapter für weitere Informationen.

Um eine Instanz von ``Zend_Paginator`` zu erstellen, muß ein Adapter an den Konstruktor übergeben werden:

.. code-block:: php
   :linenos:

   $paginator = new Zend_Paginator(new Zend_Paginator_Adapter_Array($array));

Der Einfachheit halber kann man für die mit dem Zend Framework mitgelieferten Adapter die statische ``factory()``
verwenden:

.. code-block:: php
   :linenos:

   $paginator = Zend_Paginator::factory($array);

.. note::

   Im Falle des ``NULL`` Adapters, muß dem Konstruktor eine Elementanzahl mitgegeben werden da keine Datensammlung
   vorliegt.

Auch wenn die Instanz in diesem Fall technische zu verwenden ist, muß in der Controller Aktion der
Seitendarstellung mitgeteilt werden welche Seitennummer der Benutzer angefragt hat. Das erlaubt Ihm auf die
seitenweisen Daten zuzugreifen.

.. code-block:: php
   :linenos:

   $paginator->setCurrentPageNumber($page);

Der einfachste Weg um diesen Wert zu verfolgen ist über eine *URL*. Auch wenn wir empfehlen einen
``Zend_Controller_Router_Interface``-kompatiblen Router zu verwenden um dies zu bewerkstelligen, ist das keine
Notwendigkeit.

Das folgende ist eine Beispielroute die in einer *INI* Konfigurationsdatei verwendet werden könnte:

.. code-block:: php
   :linenos:

   routes.example.route = articles/:articleName/:page
   routes.example.defaults.controller = articles
   routes.example.defaults.action = view
   routes.example.defaults.page = 1
   routes.example.reqs.articleName = \w+
   routes.example.reqs.page = \d+

Mit der obigen Route (und der Verwendung der Zend Framework *MVC* Komponenten), kann die aktuelle Seitenzahl wie
folgt gesetzt werden:

.. code-block:: php
   :linenos:

   $paginator->setCurrentPageNumber($this->_getParam('page'));

Es sind auch andere Optionen vorhanden; siehe :ref:`Konfiguration <zend.paginator.configuration>` für zusätzliche
Informationen.

Schlußendlich muß die Paginator Instanz der View angehängt werden. Wenn ``Zend_View`` mit dem ViewRenderer
Action Helfer verwendet wird, dann funktioniert das folgende:

.. code-block:: php
   :linenos:

   $this->view->paginator = $paginator;

.. _zend.paginator.usage.dbselect:

Die Adapter DbSelect und DbTableSelect
--------------------------------------

Die Verwendung der meisten Adapter ist recht zielgerichtet. Trotzdem benötigen die Datenbank Adapter detailiertere
Erklärungen betreffend dem Empfang und dem Zählen von Daten aus der Datenbank.

Um die DbSelect und DbTableSelect Adapter zu verwenden muß man die Daten nicht direkt von der Datenbank empfangen.
Beide Adapter führen den Empfang selbst durch, und Zählen auch die Anzahl der Seiten. Wenn zusätzliche Arbeit
basieren auf den Ergebnissen des Adapters getan werden soll, kann die ``getItems()`` Methode des Adapters in der
eigenen Anwendung erweitert werden.

Zusätzlich holen diese Adapter **nicht** alle Einträge von der Datenbank um sie zu zählen. Stattdessen
manipuliert der Adapter die originale Abfrage um die entsprechende COUNT Abfrage zu erzeugen. Paginator führt dann
diese COUNT Abfrage aus um die Anzahl der Zeilen zu erhalten. Das erfordert eine zusätzliche Beanspruchung der
Datenbank, ist aber um ein vielfaches schneller als das komplette Ergebnisset zu holen und ``count()`` zu
verwenden. Speziell bei einer großen Anzahl an Daten.

Der Datenbank Adapter versucht die effizienteste Abfrage zu erstellen die auf ziemlich allen modernen Datenbanken
ausgefürt wird. Trotzdem ist es möglich das, abhängig von der eigenen Datenbank oder sogar dem Setup des eigenen
Schemas, ein effizienterer Weg existiert um die Anzahl der Zeilen zu erhalten. Für dieses Szenario erlaubt es der
Datenbank Adapter eine eigene COUNT Abfrage zu setzen. Wenn man zum Beispiel die Anzahl der Blog Posts in einer
eigenen Tabelle speichert, kann eine schnellere Abfrage der Anzahl mit dem folgenden Setup erreicht werden:

.. code-block:: php
   :linenos:

   $adapter = new Zend_Paginator_Adapter_DbSelect($db->select()->from('posts'));
   $adapter->setRowCount(
       $db->select()
          ->from(
              'item_counts',
              array(
                  Zend_Paginator_Adapter_DbSelect::ROW_COUNT_COLUMN => 'post_count'
              )
          )
   );

   $paginator = new Zend_Paginator($adapter);

Dieser Ansatz wird jetzt wahrscheinlich keine große Performance Verbesserung bei kleinen Datemengen und oder
einfachen Abfragen ergeben. Aber bei komplexen Abfragen und großen Datenmengen kann ein ähnlicher Weg eine
signifikante Performance Verbesserung ergeben.

.. _zend.paginator.rendering:

Seiten mit View Skripten darstellen
-----------------------------------

Das View Skript wird verwendet um die Seitenelemente darzustellen (wenn ``Zend_Paginator`` verwendet wird um das zu
tun) und die Seitenkontrollen anzuzeigen.

Weil ``Zend_Paginator`` Das *SPL* Interface `IteratorAggregate`_ integriert, ist das Durchlaufen von Elementen und
deren Darstellung einfach.

.. code-block:: php
   :linenos:

   <html>
   <body>
   <h1>Beispiel</h1>
   <?php if (count($this->paginator)): ?>
   <ul>
   <?php foreach ($this->paginator as $item): ?>
     <li><?php echo $item; ?></li>
   <?php endforeach; ?>
   </ul>
   <?php endif; ?>

   <?php echo $this->paginationControl($this->paginator,
                                       'Sliding',
                                       'my_pagination_control.phtml'); ?>
   </body>
   </html>

Der Aufruf des View Helfers fast am Ende ist zu beachten. PaginationControl nimmt bis zu vier Parameter: die
Paginator Instanz, einen Scrolling Stil, eine partielle View und ein Array von zusätzlichen Parametern.

Die zweiten und dritten Parameter sind sehr wichtig. Wobei die partielle View verwendet wird um festzustellen wie
die Seitenkontrollen **aussehen** sollten, und der Scrolling Stil verwendet wird um zu kontrollieren wie er sich
**verhalten** sollte. Angenommen die partielle View ist im Stil einer Suchseiten Kontrolle, wie anbei:

.. image:: ../images/zend.paginator.usage.rendering.control.png
   :align: center

Was passiert wenn der Benutzer den "next" Link ein paar Mal anklickt? Nun, viele Dinge könnten geschehen. Die
aktuelle Seitennummer könnte in der Mitte stehen wärend man durchklickt (wie Sie es auf Yahoo macht!), oder Sie
könnte bis zum Ende des Seitenbereichs ansteigen und dann auf der linken Seite erscheinen wenn der Benutzer ein
weiteres Mal "next" klickt. Die Seitennummer könnte sogar größer und kleiner werden wärend der Benutzer auf sie
zugreift (oder "scrollt). (wie es auf Google geschieht).

Es gibt view Scrolling Stile die mit dem Zend Framework geliefert werden:

.. _zend.paginator.usage.rendering.scrolling-styles:

.. table:: Scrolling Stile für Zend_Paginator

   +--------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Scrolling Stil|Beschreibung                                                                                                                                                                                                           |
   +==============+=======================================================================================================================================================================================================================+
   |All           |Gibt alle Seiten zurück. Das ist für Seitenkontrollen mit Dropdownmenüs nützlich wenn Sie relativ wenig Seiten haben. In diesen Fällen ist es oft gewünscht alle vorhandenen Seiten dem Benutzer auf einmal anzuzeigen.|
   +--------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Elastic       |Eine Google-artiger Scrolling Stil der sich erweitert und verkleinert wenn ein Benutzer durch die Seiten scrollt.                                                                                                      |
   +--------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Jumping       |Wenn Benutzer scrollen, steigt die Seitenzahl bis zum Ende eines gegebenen Bereichs, und startet anschließend wieder beim Beginn eines neuen Bereichs.                                                                 |
   +--------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Sliding       |Ein Yahoo!-artiger Scrolling Stil der die aktuelle Seitenzahl in der Mitte des Seitenbereichs platziert, oder so nahe wie möglich. Das ist der Standardstil.                                                           |
   +--------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Der vierte und letzte Parameter ist reserviert für ein assoziatives Array an zusätzlichen Variablen das in der
partiellen View vorhanden sein sill (über ``$this``). Für Instanzen, können diese Werte extra *URL* Parameter
für Seitendarstellungslinks enthalten.

Durch das Setzen von einer standardmäßigen partiellen View, einem standardmäßigen Scrolling Stil und einer View
Instanz kann dei Aufruf der PaginationControl komplett eliminiert werden:

.. code-block:: php
   :linenos:

   Zend_Paginator::setDefaultScrollingStyle('Sliding');
   Zend_View_Helper_PaginationControl::setDefaultViewPartial(
       'my_pagination_control.phtml'
   );
   $paginator->setView($view);

Wenn alle diese Werte gesetzt sind, kann die Seitenkontrolle im View Skript mit einem einfachen echo Statement
dargestellt werden:

.. code-block:: php
   :linenos:

   <?php echo $this->paginator; ?>

.. note::

   Natürlich ist es möglich ``Zend_Paginator`` mit anderen Template Engines zu verwenden. Mit Smarty zum
   Beispiel, würde man das folgendermaßen bewerkstelligen:

   .. code-block:: php
      :linenos:

      $smarty->assign('pages', $paginator->getPages());

   Man könnte die Seitenverte von einem Template wie folgt erhalten:

   .. code-block:: php
      :linenos:

      {$pages->pageCount}

.. _zend.paginator.usage.rendering.example-controls:

Beispiel der Seitenkontrolle
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Das folgende Beispiel von Seitenkontrollen wird Ihnen hoffentlich helfen um erstmals anzufangen:

Such-Seitendarstellung

.. code-block:: php
   :linenos:

   <!--
   Siehe http://developer.yahoo.com/ypatterns/pattern.php?pattern=searchpagination
   -->

   <?php if ($this->pageCount): ?>
   <div class="paginationControl">
   <!-- Vorheriger Seitenlink -->
   <?php if (isset($this->previous)): ?>
     <a href="<?php echo $this->url(array('page' => $this->previous)); ?>">
       < Vorher
     </a> |
   <?php else: ?>
     <span class="disabled">< Vorher</span> |
   <?php endif; ?>

   <!-- Anzahl an Seitenlinks -->
   <?php foreach ($this->pagesInRange as $page): ?>
     <?php if ($page != $this->current): ?>
       <a href="<?php echo $this->url(array('page' => $page)); ?>">
         <?php echo $page; ?>
       </a> |
     <?php else: ?>
       <?php echo $page; ?> |
     <?php endif; ?>
   <?php endforeach; ?>

   <!-- Nächster Seitenlink -->
   <?php if (isset($this->next)): ?>
     <a href="<?php echo $this->url(array('page' => $this->next)); ?>">
       Nächster >
     </a>
   <?php else: ?>
     <span class="disabled">Nächster ></span>
   <?php endif; ?>
   </div>
   <?php endif; ?>

Element Seitendarstellung:

.. code-block:: php
   :linenos:

   <!--
   Siehe http://developer.yahoo.com/ypatterns/pattern.php?pattern=itempagination
   -->

   <?php if ($this->pageCount): ?>
   <div class="paginationControl">
   <?php echo $this->firstItemNumber; ?> - <?php echo $this->lastItemNumber; ?>
   of <?php echo $this->totalItemCount; ?>

   <!-- First page link -->
   <?php if (isset($this->previous)): ?>
     <a href="<?php echo $this->url(array('page' => $this->first)); ?>">
       First
     </a> |
   <?php else: ?>
     <span class="disabled">First</span> |
   <?php endif; ?>

   <!-- Vorheriger Seitenlink -->
   <?php if (isset($this->previous)): ?>
     <a href="<?php echo $this->url(array('page' => $this->previous)); ?>">
       < Vorheriger
     </a> |
   <?php else: ?>
     <span class="disabled">< Vorheriger</span> |
   <?php endif; ?>

   <!-- Next page link -->
   <?php if (isset($this->next)): ?>
     <a href="<?php echo $this->url(array('page' => $this->next)); ?>">
       Nächster >
     </a> |
   <?php else: ?>
     <span class="disabled">Nächster ></span> |
   <?php endif; ?>

   <!-- Last page link -->
   <?php if (isset($this->next)): ?>
     <a href="<?php echo $this->url(array('page' => $this->last)); ?>">
       Last
     </a>
   <?php else: ?>
     <span class="disabled">Last</span>
   <?php endif; ?>

   </div>
   <?php endif; ?>

Dropdown Seitendarstellung:

.. code-block:: php
   :linenos:

   <?php if ($this->pageCount): ?>
   <select id="paginationControl" size="1">
   <?php foreach ($this->pagesInRange as $page): ?>
     <?php $selected = ($page == $this->current) ? ' selected="selected"' : ''; ?>
     <option value="<?php
           echo $this->url(array('page' => $page)); ?>"<?php echo $selected ?>>
       <?php echo $page; ?>
     </option>
   <?php endforeach; ?>
   </select>
   <?php endif; ?>

   <script type="text/javascript"
        src="http://ajax.googleapis.com/ajax/libs/prototype/1.6.0.2/prototype.js">
   </script>
   <script type="text/javascript">
   $('paginationControl').observe('change', function() {
       window.location = this.options[this.selectedIndex].value;
   })
   </script>

.. _zend.paginator.usage.rendering.properties:

Tabelle von Eigenschaften
^^^^^^^^^^^^^^^^^^^^^^^^^

Die folgenden Optionen von für eine Seitenkontrolle bei View Partials vorhanden:

.. _zend.paginator.usage.rendering.properties.table:

.. table:: Eigenschaften die bei View Partials vorhanden sind

   +----------------+-------+------------------------------------------------------------------+
   |Eigenschaft     |Typ    |Beschreibung                                                      |
   +================+=======+==================================================================+
   |first           |integer|Erste Seitennummer (z.B., 1)                                      |
   +----------------+-------+------------------------------------------------------------------+
   |firstItemNumber |integer|Absolute Nummer des ersten Elements auf dieser Seite              |
   +----------------+-------+------------------------------------------------------------------+
   |firstPageInRange|integer|Erste Seite des Bereichs der vom Scrolling Stil zurückgegeben wird|
   +----------------+-------+------------------------------------------------------------------+
   |current         |integer|Aktuelle Seitenzahl                                               |
   +----------------+-------+------------------------------------------------------------------+
   |currentItemCount|integer|Anzahl der Elemente auf dieser Seite                              |
   +----------------+-------+------------------------------------------------------------------+
   |itemCountPerPage|integer|Maximale Anzahl der Elemente die auf jeder Seite vorhanden sind   |
   +----------------+-------+------------------------------------------------------------------+
   |last            |integer|Letzte Seitennummer                                               |
   +----------------+-------+------------------------------------------------------------------+
   |lastItemNumber  |integer|Absolute Zahl des letzten Elements auf dieser Seite               |
   +----------------+-------+------------------------------------------------------------------+
   |lastPageInRange |integer|Letzte Seite im Bereich der vom Scrolling Stil zurückgegeben wird |
   +----------------+-------+------------------------------------------------------------------+
   |next            |integer|Nächste Seitenzahl                                                |
   +----------------+-------+------------------------------------------------------------------+
   |pageCount       |integer|Anzahl an Seiten                                                  |
   +----------------+-------+------------------------------------------------------------------+
   |pagesInRange    |array  |Array von Seiten das vom Scrolling Stil zurückgegeben wird        |
   +----------------+-------+------------------------------------------------------------------+
   |previous        |integer|Vorherige Seitenzahl                                              |
   +----------------+-------+------------------------------------------------------------------+
   |totalItemCount  |integer|Komplette Anzahl an Elementen                                     |
   +----------------+-------+------------------------------------------------------------------+



.. _`IteratorAggregate`: http://www.php.net/~helly/php/ext/spl/interfaceIteratorAggregate.html
