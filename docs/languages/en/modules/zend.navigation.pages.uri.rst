.. _zend.navigation.pages.uri:

Zend\\Navigation\\Page\\Uri
===========================

Pages of type ``Zend\Navigation\Page\Uri`` can be used to link to pages on other domains or sites, or to implement
custom logic for the page. *URI* pages are simple; in addition to the common page options, a *URI* page takes only
one option — *uri*. The *uri* will be returned when calling ``$page->getHref()``, and may be a ``String`` or
``NULL``.

.. note::

   ``Zend\Navigation\Page\Uri`` will not try to determine whether it should be active when calling
   ``$page->isActive()``. It merely returns what currently is set, so to make a *URI* page active you have to
   manually call ``$page->setActive()`` or specifying *active* as a page option when constructing.

.. _zend.navigation.pages.uri.options:

.. table:: URI page options

   +---+------+-------+--------------------------------------------+
   |Key|Type  |Default|Description                                 |
   +===+======+=======+============================================+
   |uri|String|NULL   |URI to page. This can be any string or NULL.|
   +---+------+-------+--------------------------------------------+