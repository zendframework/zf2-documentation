.. _learning.paginator.simple:

Simple Examples
===============

In this first example we won't do anything spectacular, but hopefully it will give you a good idea of what
``Zend_Paginator`` is designed to do. Let's say we have an array called $data with the numbers 1 to 100 in it,
which we want to divide over a number of pages. We can use the static ``factory()`` method in the
``Zend_Paginator`` class to get a ``Zend_Paginator`` object with our array in it.

.. code-block:: php
   :linenos:

   // Create an array with numbers 1 to 100
   $data = range(1, 100);

   // Get a Paginator object using Zend_Paginator's built-in factory.
   $paginator = Zend_Paginator::factory($data);

We're already almost done! The $paginator variable now contains a reference to the Paginator object. By default it
is setup to display 10 items per page. To display the items for the currently active page, all you need to do is
iterate over the Paginator object with a foreach loop. The currently active page defaults to the first page if it's
not explicitly specified. We will see how you can select a specific page later on. The snippet below will display
an unordered list containing the numbers 1 to 10, which are the numbers on the first page.

.. code-block:: php
   :linenos:

   // Create an array with numbers 1 to 100
   $data = range(1, 100);

   // Get a Paginator object using Zend_Paginator's built-in factory.
   $paginator = Zend_Paginator::factory($data);

   ?><ul><?php

   // Render each item for the current page in a list-item
   foreach ($paginator as $item) {
       echo '<li>' . $item . '</li>';
   }

   ?></ul>

Now let's try and render the items on the second page. You can use the ``setCurrentPageNumber()`` method to select
which page you want to view.

.. code-block:: php
   :linenos:

   // Create an array with numbers 1 to 100
   $data = range(1, 100);

   // Get a Paginator object using Zend_Paginator's built-in factory.
   $paginator = Zend_Paginator::factory($data);

   // Select the second page
   $paginator->setCurrentPageNumber(2);

   ?><ul><?php

   // Render each item for the current page in a list-item
   foreach ($paginator as $item) {
       echo '<li>' . $item . '</li>';
   }

   ?></ul>

As expected, this little snippet will render an unordered list with the numbers 11 to 20 in it.

These simple examples demonstrate a small portion of what can be achieved with ``Zend_Paginator``. However, a real
application rarely reads its data from a plain array, so the next section is dedicated to showing you how you can
use Paginator to paginate the results of a database query. Before reading on, make sure you're familiar with the
way ``Zend_Db_Select`` works!

In the database examples we will look at a table with blog posts called 'posts'. The 'posts' table has four
columns: id, title, body, date_created. Let's dive right in and have a look at a simple example.

.. code-block:: php
   :linenos:

   // Create a select query. $db is a Zend_Db_Adapter object, which we assume
   // already exists in your script.
   $select = $db->select()->from('posts')->order('date_created DESC');

   // Get a Paginator object using Zend_Paginator's built-in factory.
   $paginator = Zend_Paginator::factory($select);

   // Select the second page
   $paginator->setCurrentPageNumber(2);

   ?><ul><?php

   // Render each the title of each post for the current page in a list-item
   foreach ($paginator as $item) {
       echo '<li>' . $item->title . '</li>';
   }

   ?></ul>

As you can see, this example is not that different from the previous one. The only difference is that you pass a
``Zend_Db_Select`` object to the Paginator's ``factory()`` method, rather than an array. For more details on how
the database adapter makes sure that your query is being executed efficiently, see the ``Zend_Paginator`` chapter
in the reference manual on the DbSelect and DbTableSelect adapters.


