.. EN-Revision: none
.. _zend.feed.findFeeds:

Feeds von Websites abrufen
==========================

Websites beinhalten oft **<link>** Tags, die auf Feeds mit für diese Seite relevanten Informationen verweisen.
``Zend_Feed`` ermöglicht Dir, mit einem einfachen Methodenaufruf alle von einer Webseite referenzierten Feeds
abzurufen.

.. code-block:: php
   :linenos:

   $feedArray = Zend_Feed::findFeeds('http://www.example.com/news.html');

Hier gibt die ``findFeeds()`` Methode ein Array mit ``Zend_Feed_Abstract`` Objekten zurück, die durch die
**<link>** Tags der ``news.html`` Webseite referenziert worden sind. Abhängig vom Typ jedes Feeds kann jeder
einzelne Eintrag in ``$feedArray`` eine ``Zend_Feed_Rss`` oder ``Zend_Feed_Atom`` Instanz enthalten. Bei Fehlern,
wie z.B. ein *HTTP* 404 Response Code oder ein nicht wohlgeformter Feed, wirft ``Zend_Feed`` eine
``Zend_Feed_Exception``.


