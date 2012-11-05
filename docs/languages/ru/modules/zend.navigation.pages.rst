.. EN-Revision: none
.. _zend.navigation.pages:

Страницы
========

``Zend_Navigation`` поставляется с двумя типами страниц:



   - :ref:`страницы MVC <zend.navigation.pages.mvc>`, с использованием класса
     ``Zend\Navigation_Page\Mvc``

   - :ref:`страницы URI <zend.navigation.pages.uri>`, с использованием класса
     ``Zend\Navigation_Page\Uri``

Страницы MVC являются ссылками на внутренние веб-страницы сайта
и определяются с использованием параметров MVC (*action*, *controller*,
*module*, *route*, *params*). Страницы URI определяются единственным
свойством *uri*, которое дает возможность гибко ссылаться на
страницы других сайтов или производить другие действия со
сгенерированными ссылками.

.. include:: zend.navigation.pages.common.rst
.. include:: zend.navigation.pages.mvc.rst
.. include:: zend.navigation.pages.uri.rst
.. include:: zend.navigation.pages.custom.rst
.. include:: zend.navigation.pages.factory.rst

