.. _zend.paginator.advanced:

Advanced usage
==============

.. _zend.paginator.advanced.adapters:

Custom data source adapters
---------------------------

At some point you may run across a data type that is not covered by the packaged adapters. In this case, you will need to write your own.

To do so, you must implement ``Zend_Paginator_Adapter_Interface``. There are two methods required to do this:

- count()

- getItems($offset, $itemCountPerPage)

Additionally, you'll want to implement a constructor that takes your data source as a parameter and stores it as a protected or private property. How you wish to go about doing this specifically is up to you.

If you've ever used the SPL interface `Countable`_, you're familiar with ``count()``. As used with ``Zend_Paginator``, this is the total number of items in the data collection. Additionally, the ``Zend_Paginator`` instance provides a method ``countAllItems()`` that proxies to the adapter ``count()`` method.

The ``getItems()`` method is only slightly more complicated. For this, your adapter is supplied with an offset and the number of items to display per page. You must return the appropriate slice of data. For an array, that would be:

.. code-block:: php
   :linenos:

   return array_slice($this->_array, $offset, $itemCountPerPage);

Take a look at the packaged adapters (all of which implement the ``Zend_Paginator_Adapter_Interface``) for ideas of how you might go about implementing your own.

.. _zend.paginator.advanced.scrolling-styles:

Custom scrolling styles
-----------------------

Creating your own scrolling style requires that you implement ``Zend_Paginator_ScrollingStyle_Interface``, which defines a single method, ``getPages()``. Specifically,

.. code-block:: php
   :linenos:

   public function getPages(Zend_Paginator $paginator, $pageRange = null);

This method should calculate a lower and upper bound for page numbers within the range of so-called "local" pages (that is, pages that are nearby the current page).

Unless it extends another scrolling style (see ``Zend_Paginator_ScrollingStyle_Elastic`` for an example), your custom scrolling style will inevitably end with something similar to the following line of code:

.. code-block:: php
   :linenos:

   return $paginator->getPagesInRange($lowerBound, $upperBound);

There's nothing special about this call; it's merely a convenience method to check the validity of the lower and upper bound and return an array of the range to the paginator.

When you're ready to use your new scrolling style, you'll need to tell ``Zend_Paginator`` what directory to look in. To do that, do the following:

.. code-block:: php
   :linenos:

   $prefix = 'My_Paginator_ScrollingStyle';
   $path   = 'My/Paginator/ScrollingStyle/';
   Zend_Paginator::addScrollingStylePrefixPath($prefix, $path);

.. _zend.paginator.advanced.caching:

Caching features
----------------

``Zend_Paginator`` can be told to cache the data it has already passed on, preventing the adapter from fetching them each time they are used. To tell paginator to automatically cache the adapter's data, just pass to its ``setCache()`` method a ``Zend_Cache_Core`` instance.

.. code-block:: php
   :linenos:

   $paginator = Zend_Paginator::factory($someData);
   $fO = array('lifetime' => 3600, 'automatic_serialization' => true);
   $bO = array('cache_dir'=>'/tmp');
   $cache = Zend_cache::factory('Core', 'File', $fO, $bO);
   Zend_Paginator::setCache($cache);

As far as ``Zend_Paginator`` has got a ``Zend_Cache_Core`` instance, data will be cached. Sometimes you would like not to cache data even if you already passed a cache instance. You should then use ``setCacheEnable()`` for that.

.. code-block:: php
   :linenos:

   $paginator = Zend_Paginator::factory($someData);
   // $cache is a Zend_Cache_Core instance
   Zend_Paginator::setCache($cache);
   // ... later on the script
   $paginator->setCacheEnable(false);
   // cache is now disabled

When a cache is set, data are automatically stored in it and pulled out from it. It then can be useful to empty the cache manually. You can get this done by calling ``clearPageItemCache($pageNumber)``. If you don't pass any parameter, the whole cache will be empty. You can optionally pass a parameter representing the page number to empty in the cache:

.. code-block:: php
   :linenos:

   $paginator = Zend_Paginator::factory($someData);
   Zend_Paginator::setCache($cache);
   $items = $paginator->getCurrentItems();
   // page 1 is now in cache
   $page3Items = $paginator->getItemsByPage(3);
   // page 3 is now in cache

   // clear the cache of the results for page 3
   $paginator->clearPageItemCache(3);

   // clear all the cache data
   $paginator->clearPageItemCache();

Changing the item count per page will empty the whole cache as it would have become invalid:

.. code-block:: php
   :linenos:

   $paginator = Zend_Paginator::factory($someData);
   Zend_Paginator::setCache($cache);
   // fetch some items
   $items = $paginator->getCurrentItems();

   // all the cache data will be flushed:
   $paginator->setItemCountPerPage(2);

It is also possible to see the data in cache and ask for them directly. ``getPageItemCache()`` can be used for that:

.. code-block:: php
   :linenos:

   $paginator = Zend_Paginator::factory($someData);
   $paginator->setItemCountPerPage(3);
   Zend_Paginator::setCache($cache);

   // fetch some items
   $items = $paginator->getCurrentItems();
   $otherItems = $paginator->getItemsPerPage(4);

   // see the cached items as a two-dimension array:
   var_dump($paginator->getPageItemCache());

.. _zend.paginator.advanced.aggregator:

Zend_Paginator_AdapterAggregate Interface
-----------------------------------------

Depending on your application you might want to paginate objects, whose internal data-structure is equal to existing adapters, but you don't want to break up your encapsulation to allow access to this data. In other cases an object might be in a "has-an adapter" relationship, rather than the "is-an adapter" relationsship that ``Zend_Paginator_Adapter_Abstract`` promotes. For this cases you can use the ``Zend_Paginator_AdapterAggregate`` interface that behaves much like the ``IteratorAggregate`` interface of the *PHP* SPL extension.

.. code-block:: php
   :linenos:

   interface Zend_Paginator_AdapterAggregate
   {
       /**
        * Return a fully configured Paginator Adapter from this method.
        *
        * @return Zend_Paginator_Adapter_Abstract
        */
       public function getPaginatorAdapter();
   }

The interface is fairly small and only expects you to return an instance of ``Zend_Paginator_Adapter_Abstract``. An Adapter Aggregate instance is then recognized by both ``Zend_Paginator::factory()`` and the constructor of ``Zend_Paginator`` and handled accordingly.



.. _`Countable`: http://www.php.net/~helly/php/ext/spl/interfaceCountable.html
