.. _zend.view.renderer.php-renderer:

The PhpRenderer
===============

``Zend\View\Renderer\PhpRenderer`` "renders" view scripts written in PHP, capturing and returning the output. It
composes Variable containers and/or View Models, a helper plugin manager for :ref:`helpers <zend.view.helpers>`,
and optional filtering of the captured output.

The ``PhpRenderer`` is template system agnostic; you may use *PHP* as your template language, or create instances
of other template systems and manipulate them within your view script. Anything you can do with PHP is available to
you.

.. _zend.view.renderer.php-renderer.usage:

Usage
-----

Basic usage consists of instantiating or otherwise obtaining an instance of the ``PhpRenderer``, providing it with
a resolver which will resolve templates to PHP view scripts, and then calling its ``render()`` method.

Instantiating a renderer is trivial:

.. code-block:: php
   :linenos:

   use Zend\View\Renderer\PhpRenderer;

   $renderer = new PhpRenderer();

Zend Framework ships with several types of "resolvers", which are used to resolve a template name to a resource a
renderer can consume. The ones we will usually use with the ``PhpRenderer`` are:

- ``Zend\View\Resolver\TemplateMapResolver``, which simply maps template names directly to view scripts.

- ``Zend\View\Resolver\TemplatePathStack``, which creates a LIFO stack of script directories in which to search for
  a view script. By default, it appends the suffix ".phtml" to the requested template name, and then loops through
  the script directories; if it finds a file matching the requested template, it returns the full file path.

- ``Zend\View\Resolver\AggregateResolver``, which allows attaching a FIFO queue of resolvers to consult.

We suggest using the ``AggregateResolver``, as it allows you to create a multi-tiered strategy for resolving
template names.

Programmatically, you would then do something like this:

.. code-block:: php
   :linenos:

   use Zend\View\Renderer\PhpRenderer;
   use Zend\View\Resolver;

   $renderer = new PhpRenderer();

   $resolver = new Resolver\AggregateResolver();

   $renderer->setResolver($resolver);

   $map = new Resolver\TemplateMapResolver(array(
       'layout'      => __DIR__ . '/view/layout.phtml',
       'index/index' => __DIR__ . '/view/index/index.phtml',
   ));
   $stack = new Resolver\TemplatePathStack(array(
       'script_paths' => array(
           __DIR__ . '/view',
           $someOtherPath
       )
   ));

   $resolver->attach($map)    // this will be consulted first
            ->attach($stack);

You can also specify a specific priority value when registering resolvers, with high, positive integers getting
higher priority, and low, negative integers getting low priority, when resolving.

In an MVC application, you can configure this via DI quite easily:

.. code-block:: php
   :linenos:

   return array(
       'di' => array(
           'instance' => array(
               'Zend\View\Resolver\AggregateResolver' => array(
                   'injections' => array(
                       'Zend\View\Resolver\TemplateMapResolver',
                       'Zend\View\Resolver\TemplatePathStack',
                   ),
               ),

               'Zend\View\Resolver\TemplateMapResolver' => array(
                   'parameters' => array(
                       'map'  => array(
                           'layout'      => __DIR__ . '/view/layout.phtml',
                           'index/index' => __DIR__ . '/view/index/index.phtml',
                       ),
                   ),
               ),
               'Zend\View\Resolver\TemplatePathStack' => array(
                   'parameters' => array(
                       'paths'  => array(
                           'application' => __DIR__ . '/view',
                           'elsewhere'   => $someOtherPath,
                       ),
                   ),
               ),
               'Zend\View\Renderer\PhpRenderer' => array(
                   'parameters' => array(
                       'resolver' => 'Zend\View\Resolver\AggregateResolver',
                   ),
               ),
           ),
       ),
   );

Now that we have our ``PhpRenderer`` instance, and it can find templates, let's inject some variables. This can be
done in 4 different ways.

- Pass an associative array (or ``ArrayAccess`` instance, or ``Zend\View\Variables`` instance) of items as the
  second argument to ``render()``: *$renderer->render($templateName, array('foo' => 'bar))*

- Assign a ``Zend\View\Variables`` instance, associative array, or ``ArrayAccess`` instance to the ``setVars()``
  method.

- Assign variables as instance properties of the renderer: *$renderer->foo = 'bar'*. This essentially proxies to an
  instance of ``Variables`` composed internally in the renderer by default.

- Create a ViewModel instance, assign variables to that, and pass the ViewModel to the ``render()`` method:

  .. code-block:: php
     :linenos:

     use Zend\View\Model\ViewModel;
     use Zend\View\Renderer\PhpRenderer;

     $renderer = new PhpRenderer();

     $model    = new ViewModel();
     $model->setVariable('foo', 'bar');
     // or
     $model = new ViewModel(array('foo' => 'bar'));

     $model->setTemplate($templateName);
     $renderer->render($model);

Now, let's render something. As a simple example, let us say you have a list of book data.

.. code-block:: php
   :linenos:

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

   // now assign the book data to a renderer instance
   $renderer->books = $data;

   // and render the template "booklist"
   echo $renderer->render('booklist');

More often than not, you'll likely be using the MVC layer. As such, you should be thinking in terms of view models.
Let's consider the following code from within an action method of a controller.

.. code-block:: php
   :linenos:

   namespace Bookstore\Controller;

   use Zend\Mvc\Controller\AbstractActionController;

   class BookController extends AbstractActionController
   {
       public function listAction()
       {
           // do some work...

           // Assume $data is the list of books from the previous example
           $model = new ViewModel(array('books' => $data));

           // Optionally specify a template; if we don't, by default it will be
           // auto-determined based on the module name, controller name and this action.
           // In this example, the template would resolve to "bookstore/book/list",
           // and thus the file "bookstore/book/list.phtml"; the following overrides
           // that to set the template to "booklist", and thus the file "booklist.phtml"
           // (note the lack of directory preceding the filename).
           $model->setTemplate('booklist');

           return $model
       }
   }

This will then be rendered as if the following were executed:

.. code-block:: php
   :linenos:

   $renderer->render($model);

Now we need the associated view script. At this point, we'll assume that the template "booklist" resolves to the
file ``booklist.phtml``. This is a *PHP* script like any other, with one exception: it executes inside the scope of
the ``PhpRenderer`` instance, which means that references to ``$this`` point to the ``PhpRenderer`` instance
properties and methods. Thus, a very basic view script could look like this:

.. code-block:: php
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
               <td><?php echo $this->escapeHtml($val['author']) ?></td>
               <td><?php echo $this->escapeHtml($val['title']) ?></td>
           </tr>
           <?php endforeach; ?>

       </table>

   <?php else: ?>

       <p>There are no books to display.</p>

   <?php endif;?>

.. note::

   **Escape Output**

   The security mantra is "Filter input, escape output." If you are unsure of the source of a given variable --
   which is likely most of the time -- you should escape it based on which HTML context it is being injected into.
   The primary contexts to be aware of are HTML Body, HTML Attribute, Javascript, CSS and URI. Each context has a
   dedicated helper available to apply the escaping strategy most appropriate to each context. You should be aware
   that escaping does vary significantly between contexts - there is no one single escaping strategy that can be
   globally applied.

   In the example above, there are calls to an ``escapeHtml()`` method. The method is actually a :ref:`helper
   <zend.view.helpers>`, a plugin available via method overloading. Additional escape helpers provide the
   ``escapeHtmlAttr()``, ``escapeJs()``, ``escapeCss()``, and ``escapeUrl()`` methods for each of the HTML contexts
   you are most likely to encounter.

   By using the provided helpers and being aware of your variables' contexts, you will prevent your templates from
   running afoul of `Cross-Site Scripting (XSS)`_ vulnerabilities.

We've now toured the basic usage of the ``PhpRenderer``. By now you should know how to instantiate the renderer,
provide it with a resolver, assign variables and/or create view models, create view scripts, and render view
scripts.

.. _zend.view.renderer.php-renderer.options:

Options and Configuration
-------------------------

``Zend\View\Renderer\PhpRenderer`` utilizes several collaborators in order to do its work. use the following
methods to configure the renderer.

.. _zend.view.renderer.php-renderer.options.plugin-manager:

.. function:: setHelperPluginManager(string|Zend\\View\\HelperPluginManager $helpers)
   :noindex:

   Set the helper plugin manager instance used to load, register, and retrieve :ref:`helpers <zend.view.helpers>`.

   :rtype: Zend\\View\\Renderer\\PhpRenderer

.. _zend.view.renderer.php-renderer.options.resolver:

.. function:: setResolver(Zend\\View\\Resolver\\ResolverInterface $resolver)
   :noindex:

   Set the resolver instance.

   :rtype: Zend\\View\\Renderer\\PhpRenderer

.. _zend.view.renderer.php-renderer.options.filter-chain:

.. function:: setFilterChain(Zend\\Filter\\FilterChain $filters)
   :noindex:

   Set a filter chain to use as an output filter on rendered content.

   :rtype: Zend\\View\\Renderer\\PhpRenderer

.. _zend.view.renderer.php-renderer.options.vars:

.. function:: setVars(array|ArrayAccess|Zend\\View\\Variables $variables)
   :noindex:

   Set the variables to use when rendering a view script/template.

   :rtype: mixed

.. _zend.view.renderer.php-renderer.options.can-render-trees:

.. function:: setCanRenderTrees(boolean $canRenderTrees)
   :noindex:

   Set flag indicating whether or not we should render trees of view models. If set to true, the ``Zend\View\View``
   instance will not attempt to render children separately, but instead pass the root view model directly to the
   ``PhpRenderer``. It is then up to the developer to render the children from within the view script. This is
   typically done using the ``RenderChildModel`` helper: *$this->renderChildModel('child_name')*.

   :rtype: Zend\\View\\Renderer\\PhpRenderer

.. _zend.view.renderer.php-renderer.methods:

Additional Methods
------------------

Typically, you'll only ever access variables and :ref:`helpers <zend.view.helpers>` within your view scripts or
when interacting with the ``PhpRenderer``. However, there are a few additional methods you may be interested in.

.. _zend.view.renderer.php-renderer.methods.render:

.. function:: render(string|Zend\\View\\Model\\ModelInterface $nameOrModel, array|Traversable $values = null)
   :noindex:

   Render a template/view model.

   If ``$nameOrModel`` is a string, it is assumed to be a template name. That template will be resolved using the
   current resolver, and then rendered. If ``$values`` is non-null, those values, and those values only, will be
   used during rendering, and will replace whatever variable container previously was in the renderer; however, the
   previous variable container will be reset when done. If ``$values`` is empty, the current variables container
   (see :ref:`setVars() <zend.view.renderer.php-renderer.options.vars>`) will be injected when rendering.

   If ``$nameOrModel`` is a ``Model`` instance, the template name will be retrieved from it and used. Additionally,
   if the model contains any variables, these will be used when rendering; otherwise, the variables container
   already present, if any, will be used.

   It will return the script output.

   :rtype: string

.. _zend.view.renderer.php-renderer.methods.resolver:

.. function:: resolver()
   :noindex:

   Retrieves the ``Resolver`` instance.

   :rtype: string|Zend\\View\\Resolver\\ResolverInterface

.. _zend.view.renderer.php-renderer.methods.vars:

.. function:: vars(string $key = null)
   :noindex:

   Retrieve a single variable from the container if a key is provided, otherwise it will return the variables
   container.

   :rtype: mixed

.. _zend.view.renderer.php-renderer.methods.plugin:

.. function:: plugin(string $name, array $options = null)
   :noindex:

   Get a plugin/helper instance. Proxies to the plugin manager's ``get()`` method; as such, any ``$options`` you
   pass will be passed to the plugin's constructor if this is the first time the plugin has been retrieved. See
   the section on :ref:`helpers <zend.view.helpers>` for more information.

   :rtype: Zend\\View\\Helper\\HelperInterface

.. _zend.view.renderer.php-renderer.methods.add-template:

.. function:: addTemplate(string $template)
   :noindex:

   Add a template to the stack. When used, the next call to ``render()`` will loop through all template added using
   this method, rendering them one by one; the output of the last will be returned.

   :rtype: Zend\\View\\Renderer\\PhpRenderer

.. _`Cross-Site Scripting (XSS)`: http://en.wikipedia.org/wiki/Cross-site_scripting
