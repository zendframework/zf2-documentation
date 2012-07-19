.. _zend.navigation.introduction:

Introduction
============

``Zend_Navigation`` is a component for managing trees of pointers to web pages. Simply put: It can be used for
creating menus, breadcrumbs, links, and sitemaps, or serve as a model for other navigation related purposes.

.. _zend.navigation.introduction.concepts:

Pages and Containers
--------------------

There are two main concepts in ``Zend_Navigation``:

.. _zend.navigation.introduction.pages:

Pages
^^^^^

A page (``Zend_Navigation_Page``) in ``Zend_Navigation`` – in its most basic form – is an object that holds a
pointer to a web page. In addition to the pointer itself, the page object contains a number of other properties
that are typically relevant for navigation, such as ``label``, ``title``, etc.

Read more about pages in the :ref:`pages <zend.navigation.pages>` section.

.. _zend.navigation.introduction.containers:

Containers
^^^^^^^^^^

A navigation container (``Zend_Navigation_Container``) is a container class for pages. It has methods for adding,
retrieving, deleting and iterating pages. It implements the `SPL`_ interfaces ``RecursiveIterator`` and
``Countable``, and can thus be iterated with SPL iterators such as ``RecursiveIteratorIterator``.

Read more about containers in the :ref:`containers <zend.navigation.containers>` section.

.. note::

   ``Zend_Navigation_Page`` extends ``Zend_Navigation_Container``, which means that a page can have sub pages.

.. _zend.navigation.introduction.separation:

Separation of data (model) and rendering (view)
-----------------------------------------------

Classes in the ``Zend_Navigation`` namespace do not deal with rendering of navigational elements. Rendering is done
with navigational view helpers. However, pages contain information that is used by view helpers when rendering,
such as; ``label``, *CSS* class, ``title``, ``lastmod`` and ``priority`` properties for sitemaps, etc.

Read more about rendering navigational elements in the manual section on :ref:`navigation helpers
<zend.view.helpers.initial.navigation>`.



.. _`SPL`: http://php.net/spl
