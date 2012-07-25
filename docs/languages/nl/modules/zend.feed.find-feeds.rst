.. _zend.feed.findFeeds:

Feeds verkregen van Web Paginas
===============================

Web paginas bevatten dikwijls *alt;link>* afbakeningen die naar feeds met relevante informatie met betrekking tot
de pagina wijzen. *Zend_Feed* laat je toe om alle gereferenceerde feeds in een web pagina met één eenvoudige
methode oproep te verkrijgen:

.. code-block:: php
   :linenos:

   <?php

   $feedArray = Zend_Feed::findFeeds('http://www.example.com/news.html');

   ?>
De methode *findFeeds()* stuurt een array van *Zend_Feed_Abstract* objecten terug die gereferenceerd zijn door
*<link>* afbakeningen op de news.html web pagina. Afhankelijk van het type van elk van de feeds zal elke
respectieve entry in de *$feedArray* array een *Zend_Feed_Rss* of een *Zend_Feed_Atom* instantie zijn. *Zend_Feed*
zal een *Zend_Feed_Exception* opwerpen bij mislukking, zoals een HTTP 404 antwoord of een misvormde feed.


