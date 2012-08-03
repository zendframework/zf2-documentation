.. _zend.navigation.pages:

Seiten
======

``Zend\Navigation`` wird mit zwei Seitentypen ausgeliefert:

- :ref:`MVC-Seiten <zend.navigation.pages.mvc>` – diese verwenden die Klasse ``Zend\Navigation\Page\Mvc``
- :ref:`URI-Seiten <zend.navigation.pages.uri>` – diese verwenden die Klasse ``Zend\Navigation\Page\Uri``

MVC-Seiten zeigen auf Seiten der eigenen Webanwendung, welche durch MVC-Parameter (*action*,
*controller*, *route*, *params*) definiert werden. URI-Seiten haben nur die Eigenschaft *uri*,
welche die Möglichkeit bietet, auf externe Webesiten zu verlinken oder sonstige Links zu erzeugen
(z.B. *<a href="#">foo<a>*).

.. include:: zend.navigation.pages.common.rst
.. include:: zend.navigation.pages.mvc.rst
.. include:: zend.navigation.pages.uri.rst
.. include:: zend.navigation.pages.custom.rst
.. include:: zend.navigation.pages.factory.rst