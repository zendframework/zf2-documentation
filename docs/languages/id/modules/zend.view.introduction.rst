.. _zend.view.introduction:

Pendahuluan
===========

Zend_View adalah class yang dapat Anda gunakan untuk bekerja dengan bagian "view" dari pola model-view-controller.
Yaitu untuk menjaga view script terpisah dari model dan controller script. Zend_View menyediakan sebuah sistem
pembantu (helpers), output filters dan variable escaping.

Zend_View is template system agnostic; you may use PHP as your template language, or create instances of other
template systems and manipulate them within your view script.

Essentially, using Zend_View happens in two major steps: 1. Your controller script creates an instance of Zend_View
and assigns variables to that instance. 2. The controller tells the Zend_View to render a particular view, thereby
handing control over the view script, which generates the view output.

.. _zend.view.introduction.controller:

Controller Script
-----------------

As a simple example, let us say your controller has a list of book data that it wants to have rendered by a view.
The controller script might look something like this:

.. code-block::
   :linenos:
   <?php
   // use a model to get the data for book authors and titles.
   $data = array(
       array(
           'author' => 'Hernando de Soto',
           'title' => 'The Mystery of Capitalism'
       ),
       array(
           'author' => 'Henry Hazlitt',
           'title' => 'Economics in One Lesson'
       ),
       array(
           'author' => 'Milton Friedman',
           'title' => 'Free to Choose'
       )
   );

   // now assign the book data to a Zend_View instance
   Zend_Loader::loadClass('Zend_View');
   $view = new Zend_View();
   $view->books = $data;

   // and render a view script called "booklist.php"
   echo $view->render('booklist.php');

.. _zend.view.introduction.view:

View Script
-----------

Now we need the associated view script, "booklist.php". This is a PHP script like any other, with one exception: it
executes inside the scope of the Zend_View instance, which means that references to $this point to the Zend_View
instance properties and methods. (Variables assigned to the instance by the controller are public properties of the
Zend_View instance.) Thus, a very basic view script could look like this:

.. code-block::
   :linenos:
   <?php if ($this->books): ?>

       <!-- A table of some books. -->
       <table>
           <tr>
               <th>Author</th>
               <th>Title</th>
           </tr>

           <?php foreach ($this->books as $key => $val): ?>
           <tr>
               <td><?php echo $this->escape($val['author']) ?></td>
               <td><?php echo $this->escape($val['title']) ?></td>
           </tr>
           <?php endforeach; ?>

       </table>

   <?php else: ?>

       <p>There are no books to display.</p>

   <?php endif;

Note how we use the "escape()" method to apply output escaping to variables.

.. _zend.view.introduction.options:

Options
-------

*Zend_View* has several options that may be set to configure the behaviour of your view scripts.

- *basePath:* indicate a base path from which to set the script, helper, and filter path. It assumes a directory
  structure of:

  .. code-block::
     :linenos:

     base/path/
         helpers/
         filters/
         scripts/

  This may be set via *setBasePath()*, *addBasePath()*, or the *basePath* option to the constructor.

- *encoding:* indicate the character encoding to use with *htmlentities()*, *htmlspecialchars()*, and other
  operations. Defaults to ISO-8859-1 (latin1). May be set via *setEncoding()* or the *encoding* option to the
  constructor.

- *escape:* indicate a callback to be used by *escape()*. May be set via *setEscape()* or the *escape* option to
  the constructor.

- *filter:* indicate a filter to use after rendering a view script. May be set via *setFilter()*, *addFilter()*, or
  the *filter* option to the constructor.

- *strictVars:* force *Zend_View* to emit notices and warnings when uninitialized view variables are accessed. This
  may be set by calling *strictVars(true)* or passing the *strictVars* option to the constructor.

.. _zend.view.introduction.accessors:

Utility Accessors
-----------------

Typically, you'll only ever need to call on *assign()*, *render()*, or one of the methods for setting/adding
filter, helper, and script paths. However, if you wish to extend *Zend_View* yourself, or need access to some of
its internals, a number of accessors exist:

- *getVars()* will return all assigned variables.

- *clearVars()* will clear all assigned variables; useful when you wish to re-use a view object, but want to
  control what variables are available..

- *getScriptPath($script)* will retrieve the resolved path to a given view script.

- *getScriptPaths()* will retrieve all registered script paths.

- *getHelperPath($helper)* will retrieve the resolved path to the named helper class.

- *getHelperPaths()* will retrieve all registered helper paths.

- *getFilterPath($filter)* will retrieve the resolved path to the named filter class.

- *getFilterPaths()* will retrieve all registered filter paths.


