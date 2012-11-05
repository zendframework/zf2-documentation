.. EN-Revision: none
.. _zend.feed.findFeeds:

Obtenir des flux à partir de pages Web
======================================

Les pages Web contiennent souvent des balises *<link>* qui font référence à des flux dont le contenu est lié à
la page. ``Zend_Feed`` vous permet d'obtenir tous les flux référencés par une page Web en appelant simplement
une méthode :

.. code-block:: php
   :linenos:

   $tableauFlux =
       Zend\Feed\Feed::findFeeds('http://www.exemple.com/news.html');

La méthode ``findFeeds()`` renvoie ici un tableau d'objets ``Zend\Feed\Abstract`` associés aux flux référencés
par les balises *<link>* de la page Web *news.html*. Selon le type de chaque flux, chaque entrée respective du
tableau ``$tableauFlux`` peut être une instance de ``Zend\Feed\Rss`` ou ``Zend\Feed\Atom``. ``Zend_Feed``
déclenchera une exception ``Zend\Feed\Exception`` en cas d'échec, par exemple en cas de code *HTTP* 404 renvoyé
en réponse ou si le flux est malformé.


