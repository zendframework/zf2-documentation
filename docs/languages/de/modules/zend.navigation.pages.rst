.. _zend.navigation.pages:

Seiten
======

``Zend_Navigation`` wird mit zwei Seiten Typen ausgeliefert:



   - :ref:`MVC Seiten <zend.navigation.pages.mvc>` – diese Verwenden die Klasse ``Zend_Navigation_Page_Mvc``

   - :ref:`URI Seiten <zend.navigation.pages.uri>` – diese Verwenden die Klasse ``Zend_Navigation_Page_Uri``

MVC Seiten werden auf On-Site Webseiten verlinkt, und definiert indem MVC Parameter verwendet werden (*action*,
*controller*, *module*, *route*, *params*). URI Seiten werden durch eine einzelne Eigenschaft *uri* definiert,
welche die komplette Funktionalität bietet auf Off-Site Seiten zu verlinken, oder andere Dinge mit erstellten
Linkt durchzuführen (z.B. eine URI die zu *<a href="#">foo<a>* wird).

.. include:: zend.navigation.pages.common.rst
.. include:: zend.navigation.pages.mvc.rst
.. include:: zend.navigation.pages.uri.rst
.. include:: zend.navigation.pages.custom.rst
.. include:: zend.navigation.pages.factory.rst

