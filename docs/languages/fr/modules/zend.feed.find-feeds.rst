.. _zend.feed.findFeeds:

Obtenir des flux à partir de pages Web
======================================

Les pages Web contiennent souvent des balises *<link>* qui font référence à des flux dont le contenu est lié à
la page. ``Zend_Feed`` vous permet d'obtenir tous les flux référencés par une page Web en appelant simplement
une méthode :

.. code-block:: php
   :linenos:

   $tableauFlux =
       Zend_Feed::findFeeds('http://www.exemple.com/news.html');

La méthode ``findFeeds()`` renvoie ici un tableau d'objets ``Zend_Feed_Abstract`` associés aux flux référencés
par les balises *<link>* de la page Web *news.html*. Selon le type de chaque flux, chaque entrée respective du
tableau ``$tableauFlux`` peut être une instance de ``Zend_Feed_Rss`` ou ``Zend_Feed_Atom``. ``Zend_Feed``
déclenchera une exception ``Zend_Feed_Exception`` en cas d'échec, par exemple en cas de code *HTTP* 404 renvoyé
en réponse ou si le flux est malformé.


