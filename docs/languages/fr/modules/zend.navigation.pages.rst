.. EN-Revision: none
.. _zend.navigation.pages:

Pages
=====

``Zend_Navigation`` est fournie par défaut avec deux types de page:



   - :ref:`Pages MVC <zend.navigation.pages.mvc>` – utilisant la classe ``Zend\Navigation_Page\Mvc``

   - :ref:`Pages URI <zend.navigation.pages.uri>` – utilisant la classe ``Zend\Navigation_Page\Uri``

Les pages MVC proposeront des liens pour l'application courante et utilisent les paramètres MVC (*action*,
*controller*, *module*, *route*, *params*). Les pages URI utilisent elles une seule option, *uri*, ce qui vous
offre la possibilité de créer des liens vers des sites externes ou encore de créer des liens personnalisés
comme par exemple *<a href="#">foo<a>*.

.. include:: zend.navigation.pages.common.rst
.. include:: zend.navigation.pages.mvc.rst
.. include:: zend.navigation.pages.uri.rst
.. include:: zend.navigation.pages.custom.rst
.. include:: zend.navigation.pages.factory.rst

