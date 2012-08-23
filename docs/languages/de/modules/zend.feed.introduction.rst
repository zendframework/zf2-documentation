.. EN-Revision: none
.. _zend.feed.introduction:

Einführung
==========

``Zend_Feed`` stellt Funktionalitäten für das Konsumieren von *RSS* und Atom Feeds. Es stellt eine natürliche
Syntax bereit, um auf Elemente und Attribute des Feeds sowie auf die Attribute der Einträge zugreifen zu können.
Mit derselben natürlichen Syntax bietet ``Zend_Feed`` auch eine umfassende Unterstützung für das Ändern von
Feed und Eintragsstruktur sowie die Rückgabe der Ergebniss nach *XML*. In Zukunft könnte diese
Modifizierungsunterstützung auch das Atom Publishing Protocol unterstützen.

``Zend_Feed`` besteht aus der Basisklasse ``Zend_Feed``, sowie den beiden abstrakten Basisklassen
``Zend_Feed_Abstract`` und ``Zend_Feed_Entry_Abstract`` für die Darstellung von Feeds und Einträgen, aus
speziellen Implementationen von Feeds und Einträgen für *RSS* und Atom sowie einem Helfer, der hinter den
Kulissen die natürliche Syntax ermöglicht.

Im Beispiel unten demonstrieren wir einen einfachen Anwendungsfall für die Abfrage eines *RSS* Feeds und die
Speicherung relevanter Teile der Feed Daten in einem einfachen *PHP* Array, welches dann für die Ausgabe der
Daten, das Speichern in eine Datenbank, usw. genutzt werden kann.

.. note::

   **Achtung**

   Viele *RSS* Feeds bieten verschiedene Eigenschaften für Kanäle und Einträge. Die *RSS* Spezifikation bietet
   viele optionale Eigenschaften, also sei dir dessen beim Schreiben von Code für die Verarbeitung von *RSS* Daten
   bewußt.

.. _zend.feed.introduction.example.rss:

.. rubric:: Zend_Feed für die Verarbeitung von RSS Feed Daten verwenden

.. code-block:: php
   :linenos:

   // hole die neuesten Slashdot Schlagzeilen
   try {
       $slashdotRss =
           Zend_Feed::import('http://rss.slashdot.org/Slashdot/slashdot');
   } catch (Zend_Feed_Exception $e) {
       // Import des Feeds ist fehlgeschlagen
       echo "Exception caught importing feed: {$e->getMessage()}\n";
       exit;
   }

   // Initialisiere das Array mit den Channel Daten
   $channel = array(
       'title'       => $slashdotRss->title(),
       'link'        => $slashdotRss->link(),
       'description' => $slashdotRss->description(),
       'items'       => array()
       );

   // Durchlauf jeden Eintrag und speichere die relevanten Daten
   foreach ($slashdotRss as $item) {
       $channel['items'][] = array(
           'title'       => $item->title(),
           'link'        => $item->link(),
           'description' => $item->description()
           );
   }


