.. EN-Revision: none
.. _zend.navigation.pages.uri:

Zend\Navigation_Page\Uri
========================

Les pages de type ``Zend\Navigation_Page\Uri`` peuvent être utilisées pour pointer vers des sites externes, ou
des pages internes personnalisées. Les pages *URI* sont simples, en plus des options classiques des pages, les
pages *URI* utilisent une seule option : *uri*. L'*uri* sera retourné à l'appel de *$page->getHref()* et
retournera une ``chaine`` ou ``NULL``.

.. note::

   ``Zend\Navigation_Page\Uri`` ne pourra pas calculer elle même si elle est active ou pas suite à un appel à
   *$page->isActive()*. L'appel retournera la valeur que vous aurez spécifier vous-mêmes grâce à
   *$page->setActive()* ou via l'option de constructeur *active*.

.. _zend.navigation.pages.uri.options:

.. table:: URI page options

   +---+------+-----------------+--------------------------------------+
   |Clé|Type  |Valeur par défaut|Description                           |
   +===+======+=================+======================================+
   |uri|chaine|NULL             |URI vers la page. Une chaine, ou NULL.|
   +---+------+-----------------+--------------------------------------+


