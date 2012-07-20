.. _zend.navigation.pages.uri:

Zend_Navigation_Page_Uri
========================

Seiten des Typs ``Zend_Navigation_Page_Uri`` können verwendet werden um auf Seiten von anderen Domains oder Sites
zu verweisen, oder um eigene Logik für die Seite zu implementieren. *URI* Seiten sind einfach; zusätzlich zu den
normalen Seitenoptionen nimmt eine *URI* Seite nur eine Option -*uri*. *uri* wird zurückgegeben wenn
*$page->getHref()* aufgerufen wird, und kann ein ``String`` oder ``NULL`` sein.

.. note::

   ``Zend_Navigation_Page_Uri`` versucht nicht zu erkennen ob es aktiv ist wenn *$page->isActive()* aufgerufen
   wird. Es gibt zurück, was aktuell gesetzt ist. Um also eine *URI* Seite aktiv zu machen muß man händisch
   *$page->setActive()* aufrufen oder *active* als eine Option der Seite bei der Erstellung spezifizieren.

.. _zend.navigation.pages.uri.options:

.. table:: URI Seiten Optionen

   +---------+------+--------+--------------------------------------------------+
   |Schlüssel|Typ   |Standard|Beschreibung                                      |
   +=========+======+========+==================================================+
   |uri      |String|NULL    |URI zur Seite. Das kann ein String oder NULL sein.|
   +---------+------+--------+--------------------------------------------------+


