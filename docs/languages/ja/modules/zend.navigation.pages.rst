.. EN-Revision: none
.. _zend.navigation.pages:

画面
==

``Zend_Navigation``\ は２種類の画面タイプを入手可能にします。



   - :ref:`MVC画面 <zend.navigation.pages.mvc>` – ``Zend\Navigation\Page\Mvc``\ クラスを使用

   - :ref:`URI画面 <zend.navigation.pages.uri>` – ``Zend\Navigation\Page\Uri``\ クラスを使用

MVC画面はオンサイトなweb画面にリンクしていて、 MVCパラメータ(*action*, *controller*,
*module*, *route*, *params*)を使って定義されます。 URI画面は単一な属性の *uri*\
で定義されます。 そのURI画面はオフサイトな画面をリンクしたり、
生成されたリンク(例えば、 *<a href="#">foo<a>*\ という形になるURI)
で画面をリンクしたりできる柔軟性を完全に備えています。

.. include:: zend.navigation.pages.common.rst
.. include:: zend.navigation.pages.mvc.rst
.. include:: zend.navigation.pages.uri.rst
.. include:: zend.navigation.pages.custom.rst
.. include:: zend.navigation.pages.factory.rst

