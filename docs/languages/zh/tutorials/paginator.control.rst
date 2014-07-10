.. _learning.paginator.control:

Pagination Control and ScrollingStyles
======================================

Rendering the items for a page on the screen has been a good start. In the code snippets in previous section we
have also seen the ``setCurrentPageNumber()`` method to set the active page number. The next step is to navigate
through your pages. To do this, Paginator provides you with two important tools: the ability to render the
Paginator with help of a View Partial, and support for so-called ScrollingStyles.

The View Partial is a small view script that renders the Pagination controls, such as buttons to go to the next or
previous page. Which pagination controls are rendered depends on the contents of the view partial. Working with the
view partial requires that you have set up ``Zend_View``. To get started with the pagination control, create a new
view script somewhere in your view scripts path. You can name it anything you want, but we'll call it
"controls.phtml" in this text. The reference manual contains various examples of what might go in the view script.
Here is one example.

.. code-block:: php
   :linenos:

   <?php if ($this->pageCount): ?>
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

The next step is to tell ``Zend_Paginator`` which view partial can be used to render the navigation controls. Put
the following line in your application's bootstrap file.

.. code-block:: php
   :linenos:

   Zend\View\Helper\PaginationControl::setDefaultViewPartial('controls.phtml');

The last step is probably the easiest. Make sure you have assigned your Paginator object to the a script (NOT the
'controls.phtml' script!). The only thing left to do is echo the Paginator in the view script. This will
automatically render the Paginator using the PaginationControl view helper. In this next example, the Paginator
object has been assigned to the 'paginator' view variable. Don't worry if you don't fully get how it all works yet.
The next section will feature a complete example.

.. code-block:: php
   :linenos:

   <?php echo $this->paginator; ?>

``Zend_Paginator``, together with the 'controls.phtml' view script you wrote, makes sure your Paginator navigation
is rendered properly. In order to decide which page numbers need to be displayed on screen, Paginator uses
so-called ScrollingStyles. The default style is called "Sliding", which is similar to the way Yahoo's search result
navigation works. To mimick Google's ScrollingStyle, use the Elastic style. You can set a default ScrollingStyle
with the static ``setDefaultScrollingStyle()`` method, or you can specify a ScrollingStyle dynamically when
rendering the Paginator in your view script. This requires manual invocation of the view helper in your view
script.

.. code-block:: php
   :linenos:

   // $this->paginator is a Paginator object
   <?php echo $this->paginationControl($this->paginator, 'Elastic', 'controls.phtml'); ?>

For a list of all available ScrollingStyles, see the reference manual.


