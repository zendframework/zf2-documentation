
.. _zend.navigation.pages:

Pages
=====

``Zend_Navigation`` ships with two page types:

- :ref:`MVC pages <zend.navigation.pages.mvc>` – using the class ``Zend_Navigation_Page_Mvc``

- :ref:`URI pages <zend.navigation.pages.uri>` – using the class ``Zend_Navigation_Page_Uri``

MVC pages are link to on-site web pages, and are defined using MVC parameters (*action*, *controller*, *module*, *route*, *params*). URI pages are defined by a single property *uri*, which give you the full flexibility to link off-site pages or do other things with the generated links (e.g. an URI that turns into *<a href="#">foo<a>*).


.. include:: zend.navigation.pages.common.rst
.. include:: zend.navigation.pages.mvc.rst
.. include:: zend.navigation.pages.uri.rst
.. include:: zend.navigation.pages.custom.rst
.. include:: zend.navigation.pages.factory.rst
