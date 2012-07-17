
.. _zend.paginator.usage:

Usage
=====


.. _zend.paginator.usage.paginating:

Paginating data collections
---------------------------

In order to paginate items into pages, ``Zend_Paginator`` must have a generic way of accessing that data. For that reason, all data access takes place through data source adapters. Several adapters ship with Zend Framework by default:


.. _zend.paginator.usage.paginating.adapters:

.. table:: Adapters for Zend_Paginator

   +-------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Adapter      |Description                                                                                                                                                                          |
   +=============+=====================================================================================================================================================================================+
   |Array        |Use a PHP array                                                                                                                                                                      |
   +-------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |DbSelect     |Use a Zend_Db_Select instance, which will return an array                                                                                                                            |
   +-------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |DbTableSelect|Use a Zend_Db_Table_Select instance, which will return an instance of Zend_Db_Table_Rowset_Abstract. This provides additional information about the result set, such as column names.|
   +-------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Iterator     |Use an Iterator instance                                                                                                                                                             |
   +-------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Null         |Do not use Zend_Paginator to manage data pagination. You can still take advantage of the pagination control feature.                                                                 |
   +-------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+


.. note::
   Instead of selecting every matching row of a given query, the DbSelect and DbTableSelect adapters retrieve only the smallest amount of data necessary for displaying the current page.


   Because of this, a second query is dynamically generated to determine the total number of matching rows. However, it is possible to directly supply a count or count query yourself. See the ``setRowCount()`` method in the DbSelect adapter for more information.


To create an instance of ``Zend_Paginator``, you must supply an adapter to the constructor:

.. code-block:: php
   :linenos:

   $paginator = new Zend_Paginator(new Zend_Paginator_Adapter_Array($array));

For convenience, you may take advantage of the static ``factory()`` method for the adapters packaged with Zend Framework:

.. code-block:: php
   :linenos:

   $paginator = Zend_Paginator::factory($array);

.. note::
   In the case of the ``Null`` adapter, in lieu of a data collection you must supply an item count to its constructor.


Although the instance is technically usable in this state, in your controller action you'll need to tell the paginator what page number the user requested. This allows him to advance through the paginated data.

.. code-block:: php
   :linenos:

   $paginator->setCurrentPageNumber($page);

The simplest way to keep track of this value is through a *URL*. Although we recommend using a ``Zend_Controller_Router_Interface``-compatible router to handle this, it is not a requirement.

The following is an example route you might use in an *INI* configuration file:

.. code-block:: php
   :linenos:

   routes.example.route = articles/:articleName/:page
   routes.example.defaults.controller = articles
   routes.example.defaults.action = view
   routes.example.defaults.page = 1
   routes.example.reqs.articleName = \w+
   routes.example.reqs.page = \d+

With the above route (and using Zend Framework *MVC* components), you might set the current page number like this:

.. code-block:: php
   :linenos:

   $paginator->setCurrentPageNumber($this->_getParam('page'));

There are other options available; see :ref:`Configuration <zend.paginator.configuration>` for more on them.

Finally, you'll need to assign the paginator instance to your view. If you're using ``Zend_View`` with the ViewRenderer action helper, the following will work:

.. code-block:: php
   :linenos:

   $this->view->paginator = $paginator;


.. _zend.paginator.usage.dbselect:

The DbSelect and DbTableSelect adapter
--------------------------------------

The usage of most adapters is pretty straight-forward. However, the database adapters require a more detailed explanation regarding the retrieval and count of the data from the database.

To use the DbSelect and DbTableSelect adapters you don't have to retrieve the data upfront from the database. Both adapters do the retrieval for you, aswell as the counting of the total pages. If additional work has to be done on the database results the adapter ``getItems()`` method has to be extended in your application.

Additionally these adapters do **not** fetch all records from the database in order to count them. Instead, the adapters manipulates the original query to produce the corresponding COUNT query. Paginator then executes that COUNT query to get the number of rows. This does require an extra round-trip to the database, but this is many times faster than fetching an entire result set and using ``count()``. Especially with large collections of data.

The database adapters will try and build the most efficient query that will execute on pretty much all modern databases. However, depending on your database or even your own schema setup, there might be more efficient ways to get a rowcount. For this scenario the database adapters allow you to set a custom COUNT query. For example, if you keep track of the count of blog posts in a separate table, you could achieve a faster count query with the following setup:

.. code-block:: php
   :linenos:

   $adapter = new Zend_Paginator_Adapter_DbSelect($db->select()->from('posts'));
   $adapter->setRowCount(
       $db->select()
          ->from(
               'item_counts',
               array(
                  Zend_Paginator_Adapter_DbSelect::ROW_COUNT_COLUMN => 'post_count'
               )
            )
   );

   $paginator = new Zend_Paginator($adapter);

This approach will probably not give you a huge performance gain on small collections and/or simple select queries. However, with complex queries and large collections, a similar approach could give you a significant performance boost.


.. _zend.paginator.rendering:

Rendering pages with view scripts
---------------------------------

The view script is used to render the page items (if you're using ``Zend_Paginator`` to do so) and display the pagination control.

Because ``Zend_Paginator`` implements the *SPL* interface `IteratorAggregate`_, looping over your items and displaying them is simple.

.. code-block:: php
   :linenos:

   <html>
   <body>
   <h1>Example</h1>
   <?php if (count($this->paginator)): ?>
   <ul>
   <?php foreach ($this->paginator as $item): ?>
     <li><?php echo $item; ?></li>
   <?php endforeach; ?>
   </ul>
   <?php endif; ?>

   <?php echo $this->paginationControl($this->paginator,
                                       'Sliding',
                                       'my_pagination_control.phtml'); ?>
   </body>
   </html>

Notice the view helper call near the end. PaginationControl accepts up to four parameters: the paginator instance, a scrolling style, a view partial, and an array of additional parameters.

The second and third parameters are very important. Whereas the view partial is used to determine how the pagination control should **look**, the scrolling style is used to control how it should **behave**. Say the view partial is in the style of a search pagination control, like the one below:


.. image:: ../images/zend.paginator.usage.rendering.control.png
   :align: center

What happens when the user clicks the "next" link a few times? Well, any number of things could happen. The current page number could stay in the middle as you click through (as it does on Yahoo!), or it could advance to the end of the page range and then appear again on the left when the user clicks "next" one more time. The page numbers might even expand and contract as the user advances (or "scrolls") through them (as they do on Google).

There are four scrolling styles packaged with Zend Framework:


.. _zend.paginator.usage.rendering.scrolling-styles:

.. table:: Scrolling styles for Zend_Paginator

   +---------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Scrolling style|Description                                                                                                                                                          |
   +===============+=====================================================================================================================================================================+
   |All            |Returns every page. This is useful for dropdown menu pagination controls with relatively few pages. In these cases, you want all pages available to the user at once.|
   +---------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Elastic        |A Google-like scrolling style that expands and contracts as a user scrolls through the pages.                                                                        |
   +---------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Jumping        |As users scroll through, the page number advances to the end of a given range, then starts again at the beginning of the new range.                                  |
   +---------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Sliding        |A Yahoo!-like scrolling style that positions the current page number in the center of the page range, or as close as possible. This is the default style.            |
   +---------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+


The fourth and final parameter is reserved for an optional associative array of additional variables that you want available in your view partial (available via ``$this``). For instance, these values could include extra *URL* parameters for pagination links.

By setting the default view partial, default scrolling style, and view instance, you can eliminate the calls to PaginationControl completely:

.. code-block:: php
   :linenos:

   Zend_Paginator::setDefaultScrollingStyle('Sliding');
   Zend_View_Helper_PaginationControl::setDefaultViewPartial(
       'my_pagination_control.phtml'
   );
   $paginator->setView($view);

When all of these values are set, you can render the pagination control inside your view script with a simple echo statement:

.. code-block:: php
   :linenos:

   <?php echo $this->paginator; ?>

.. note::
   Of course, it's possible to use ``Zend_Paginator`` with other template engines. For example, with Smarty you might do the following:


   .. code-block:: php
      :linenos:

      $smarty->assign('pages', $paginator->getPages());


   You could then access paginator values from a template like so:


   .. code-block:: php
      :linenos:

      {$pages->pageCount}



.. _zend.paginator.usage.rendering.example-controls:

Example pagination controls
^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following example pagination controls will hopefully help you get started:

Search pagination:

.. code-block:: php
   :linenos:

   <!--
   See http://developer.yahoo.com/ypatterns/pattern.php?pattern=searchpagination
   -->

   <?php if ($this->pageCount): ?>
   <div class="paginationControl">
   <!-- Previous page link -->
   <?php if (isset($this->previous)): ?>
     <a href="<?php echo $this->url(array('page' => $this->previous)); ?>">
       < Previous
     </a> |
   <?php else: ?>
     <span class="disabled">< Previous</span> |
   <?php endif; ?>

   <!-- Numbered page links -->
   <?php foreach ($this->pagesInRange as $page): ?>
     <?php if ($page != $this->current): ?>
       <a href="<?php echo $this->url(array('page' => $page)); ?>">
           <?php echo $page; ?>
       </a> |
     <?php else: ?>
       <?php echo $page; ?> |
     <?php endif; ?>
   <?php endforeach; ?>

   <!-- Next page link -->
   <?php if (isset($this->next)): ?>
     <a href="<?php echo $this->url(array('page' => $this->next)); ?>">
       Next >
     </a>
   <?php else: ?>
     <span class="disabled">Next ></span>
   <?php endif; ?>
   </div>
   <?php endif; ?>

Item pagination:

.. code-block:: php
   :linenos:

   <!--
   See http://developer.yahoo.com/ypatterns/pattern.php?pattern=itempagination
   -->

   <?php if ($this->pageCount): ?>
   <div class="paginationControl">
   <?php echo $this->firstItemNumber; ?> - <?php echo $this->lastItemNumber; ?>
   of <?php echo $this->totalItemCount; ?>

   <!-- First page link -->
   <?php if (isset($this->previous)): ?>
     <a href="<?php echo $this->url(array('page' => $this->first)); ?>">
       First
     </a> |
   <?php else: ?>
     <span class="disabled">First</span> |
   <?php endif; ?>

   <!-- Previous page link -->
   <?php if (isset($this->previous)): ?>
     <a href="<?php echo $this->url(array('page' => $this->previous)); ?>">
       < Previous
     </a> |
   <?php else: ?>
     <span class="disabled">< Previous</span> |
   <?php endif; ?>

   <!-- Next page link -->
   <?php if (isset($this->next)): ?>
     <a href="<?php echo $this->url(array('page' => $this->next)); ?>">
       Next >
     </a> |
   <?php else: ?>
     <span class="disabled">Next ></span> |
   <?php endif; ?>

   <!-- Last page link -->
   <?php if (isset($this->next)): ?>
     <a href="<?php echo $this->url(array('page' => $this->last)); ?>">
       Last
     </a>
   <?php else: ?>
     <span class="disabled">Last</span>
   <?php endif; ?>

   </div>
   <?php endif; ?>

Dropdown pagination:

.. code-block:: php
   :linenos:

   <?php if ($this->pageCount): ?>
   <select id="paginationControl" size="1">
   <?php foreach ($this->pagesInRange as $page): ?>
     <?php $selected = ($page == $this->current) ? ' selected="selected"' : ''; ?>
     <option value="<?php
           echo $this->url(array('page' => $page));?>"<?php echo $selected ?>>
       <?php echo $page; ?>
     </option>
   <?php endforeach; ?>
   </select>
   <?php endif; ?>

   <script type="text/javascript"
        src="http://ajax.googleapis.com/ajax/libs/prototype/1.6.0.2/prototype.js">
   </script>
   <script type="text/javascript">
   $('paginationControl').observe('change', function() {
       window.location = this.options[this.selectedIndex].value;
   })
   </script>


.. _zend.paginator.usage.rendering.properties:

Listing of properties
^^^^^^^^^^^^^^^^^^^^^

The following options are available to pagination control view partials:


.. _zend.paginator.usage.rendering.properties.table:

.. table:: Properties available to view partials

   +----------------+-------+-------------------------------------------------------+
   |Property        |Type   |Description                                            |
   +================+=======+=======================================================+
   |first           |integer|First page number (i.e., 1)                            |
   +----------------+-------+-------------------------------------------------------+
   |firstItemNumber |integer|Absolute number of the first item on this page         |
   +----------------+-------+-------------------------------------------------------+
   |firstPageInRange|integer|First page in the range returned by the scrolling style|
   +----------------+-------+-------------------------------------------------------+
   |current         |integer|Current page number                                    |
   +----------------+-------+-------------------------------------------------------+
   |currentItemCount|integer|Number of items on this page                           |
   +----------------+-------+-------------------------------------------------------+
   |itemCountPerPage|integer|Maximum number of items available to each page         |
   +----------------+-------+-------------------------------------------------------+
   |last            |integer|Last page number                                       |
   +----------------+-------+-------------------------------------------------------+
   |lastItemNumber  |integer|Absolute number of the last item on this page          |
   +----------------+-------+-------------------------------------------------------+
   |lastPageInRange |integer|Last page in the range returned by the scrolling style |
   +----------------+-------+-------------------------------------------------------+
   |next            |integer|Next page number                                       |
   +----------------+-------+-------------------------------------------------------+
   |pageCount       |integer|Number of pages                                        |
   +----------------+-------+-------------------------------------------------------+
   |pagesInRange    |array  |Array of pages returned by the scrolling style         |
   +----------------+-------+-------------------------------------------------------+
   |previous        |integer|Previous page number                                   |
   +----------------+-------+-------------------------------------------------------+
   |totalItemCount  |integer|Total number of items                                  |
   +----------------+-------+-------------------------------------------------------+




.. _`IteratorAggregate`: http://www.php.net/~helly/php/ext/spl/interfaceIteratorAggregate.html
