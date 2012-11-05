.. _learning.paginator.together:

Putting it all Together
=======================

You have seen how to create a Paginator object, how to render the items on the current page, and how to render a
navigation element to browse through your pages. In this section you will see how Paginator fits in with the rest
of your MVC application.

In the following examples we will ignore the best practice implementation of using a Service Layer to keep the
example simple and easier to understand. Once you get familiar with using Service Layers, it should be easy to see
how Paginator can fit in with the best practice approach.

Lets start with the controller. The sample application is simple, and we'll just put everything in the
IndexController and the IndexAction. Again, this is for demonstration purposes only. A real application should not
use controllers in this manner.

.. code-block:: php
   :linenos:

   class IndexController extends Zend\Controller\Action
   {
       public function indexAction()
       {
           // Setup pagination control view script. See the pagation control tutorial page
           // for more information about this view script.
           Zend\View_Helper\PaginationControl::setDefaultViewPartial('controls.phtml');

           // Fetch an already instantiated database connection from the registry
           $db = Zend\Registry\Registry::get('db');

           // Create a select object which fetches blog posts, sorted decending by date of creation
           $select = $db->select()->from('posts')->order('date_created DESC');

           // Create a Paginator for the blog posts query
           $paginator = Zend\Paginator\Paginator::factory($select);

           // Read the current page number from the request. Default to 1 if no explicit page number is provided.
           $paginator->setCurrentPageNumber($this->_getParam('page', 1));

           // Assign the Paginator object to the view
           $this->view->paginator = $paginator;
       }
   }

The following view script is the index.phtml view script for the IndexController's indexAction. The view script can
be kept simple. We're assuming the use of the default ScrollingStyle.

.. code-block:: php
   :linenos:

   <ul>
   <?php
   // Render each the title of each post for the current page in a list-item
   foreach ($this->paginator as $item) {
       echo '<li>' . $item["title"] . '</li>';
   }
   ?>
   </ul>
   <?php echo $this->paginator; ?>

Now navigate to your project's index and see Paginator in action. What we have discussed in this tutorial is just
the tip of the iceberg. The reference manual and *API* documentation can tell you more about what you can do with
``Zend_Paginator``.


