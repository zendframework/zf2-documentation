.. EN-Revision: none
.. _zend.navigation.pages.uri:

Zend\Navigation\Page\Uri
========================

Seiten des Typs ``Zend\Navigation\Page\Uri`` können verwendet werden um auf Seiten von anderen Domains oder Websites
zu verweisen, oder um eigene Logik für die Seite zu implementieren. *URI* Seiten sind sehr einfach gehalten.
Zusätzlich zu den normalen Seitenoptionen kennt eine *URI*-Seite nur noch die Option *uri*. Der Wert von *uri* kann
durch die Methode ``$page->getHref()`` zurückgegeben werden. Dies kann ``String`` oder ``NULL`` sein.

.. note::

   ``Zend\Navigation\Page\Uri`` versucht nicht automatisch zu ermitteln, ob die Seite aktiv ist, wenn 
   ``$page->isActive()`` aufgerufen wird. Die Methode liefert nur den aktuell festgelegten Wert zurück. Um also 
   eine *URI*-Seite aktiv zu setzen, muß man händisch ``$page->setActive()`` aufrufen oder *active* als Option 
   bei der Erstellung der Seite angeben.

.. _zend.navigation.pages.uri.options:

.. table:: Optionen für URI-Seiten

   +------+------+--------+------------------------------------------------------+
   |Option|Typ   |Standard|Beschreibung                                          |
   +======+======+========+======================================================+
   |uri   |String|NULL    |URI zur Seite. Das kann ``String`` oder ``NULL`` sein.|
   +------+------+--------+------------------------------------------------------+