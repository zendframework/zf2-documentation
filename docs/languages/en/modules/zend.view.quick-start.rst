.. _zend.view.quick-start:

Zend\\View Quick Start
======================

.. _zend.view.quick-start.intro:

Overview
--------

``Zend\View`` provides the "View" layer of Zend Framework's MVC system. It is a multi-tiered system allowing a
variety of mechanisms for extension, substitution, and more.

The components of the view layer are as follows:

- **Variables containers**, which hold variables and callbacks that you wish to represent in the view. Often-times,
  a Variables container will also provide mechanisms for context-specific escaping of variables and more.

- **View Models**, which hold Variables containers, specify the template to use, if any, and optionally provide
  rendering options (more on that below). View Models may be nested in order to represent complex structures.

- **Renderers**, which take View Models and provide a representation of them to return. Zend Framework ships three
  renderers by default: a "PHP" renderer which utilizes PHP templates in order to generate markup; a JSON renderer;
  and a Feed renderer, capable of generating RSS and Atom feeds.

- **Resolvers**, which resolve a template name to a resource a Renderer may consume. As an example, a resolver may
  take the name "blog/entry" and resolve it to a PHP view script.

- **The View**, which consists of strategies that map the current Request to a Renderer, and strategies for
  injecting the Response with the result of rendering.

- **Renderer and Response Strategies**. Renderer Strategies listen to the "renderer" event of the View, and decide
  which Renderer should be selected, based on the Request or other criteria. Response strategies are used to inject
  the Response object with the results of rendering -- which may also include taking actions such as setting
  Content-Type headers.

Additionally, Zend Framework provides integration with the MVC via a number of event listeners in the
``Zend\Mvc\View`` namespace.

.. _zend.view.quick-start.usage:

Usage
-----

This manual section is designed to show you typical usage patterns of the view layer when using it within the Zend
Framework MVC. The assumptions are that you are using :ref:`Dependency Injection <zend.di>`, and that you are using
the :ref:`default MVC view strategies <zend.mvc.view>`.

.. _zend.view.quick-start.usage.config:

.. rubric:: Configuration

The default configuration for the framework will typically work out-of-the-box. However, you will still need to
select resolver strategies and configure them, as well as potentially indicate alternate template names for things
like the site layout, 404 (not found) pages, and error pages. The code snippets below can be added to your
configuration to accomplish this. We recommend adding it to a site-specific module, such as the "Application"
module from the framework's "ZendSkeletonApplication", or to one of your autoloaded configurations within the
``config/autoload/`` directory.

.. code-block:: php
   :linenos:

   return array(
       'di' => array(
           'instance' => array(
           // The above lines will likely already be present; it's the following
           // definitions that you will want to ensure are present within the DI
           // instance configuration.

               // Setup the View layer
               // This sets up an "AggregateResolver", which allows you to have
               // multiple template resolution strategies. We recommend using the
               // TemplateMapResolver as the primary solution, with the
               // TemplatePathStack as a backup.
               'Zend\View\Resolver\AggregateResolver' => array(
                   'injections' => array(
                       'Zend\View\Resolver\TemplateMapResolver',
                       'Zend\View\Resolver\TemplatePathStack',
                   ),
               ),

               // The TemplateMapResolver allows you to directly map template names
               // to specific templates. The following map would provide locations
               // for a "home" template, as well as for the "site/layout",
               // "site/error", and "site/404" templates, resolving them to view
               // scripts in this module.
               'Zend\View\Resolver\TemplateMapResolver' => array(
                   'parameters' => array(
                       'map'  => array(
                           'home'        => __DIR__ . '/../view/home.phtml',
                           'site/layout' => __DIR__ . '/../view/site/layout.phtml',
                           'site/error'  => __DIR__ . '/../view/site/error.phtml',
                           'site/404'    => __DIR__ . '/../view/site/404.phtml',
                       ),
                   ),
               ),

               // The TemplatePathStack takes an array of directories. Directories
               // are then searched in LIFO order (it's a stack) for the requested
               // view script. This is a nice solution for rapid application
               // development, but potentially introduces performance expense in
               // production due to the number of stat calls necessary.
               //
               // The following maps adds an entry pointing to the view directory
               // of the current module. Make sure your keys differ between modules
               // to ensure that they are not overwritten!
               'Zend\View\Resolver\TemplatePathStack' => array(
                   'parameters' => array(
                       'paths'  => array(
                           'application' => __DIR__ . '/../view',
                       ),
                   ),
               ),

               // We'll now define the PhpRenderer, and inject it with the
               // AggregateResolver we defined earlier. By default, the MVC layer
               // registers a rendering strategy that uses the PhpRenderer.
               'Zend\View\Renderer\PhpRenderer' => array(
                   'parameters' => array(
                       'resolver' => 'Zend\View\Resolver\AggregateResolver',
                   ),
               ),

               // By default, the MVC's default rendering strategy uses the
               // template name "layout" for the site layout. Let's tell it to use
               // "site/layout" (which we mapped via the TemplateMapResolver,
               // above).
               'Zend\Mvc\View\DefaultRenderingStrategy' => array(
                   'parameters' => array(
                       'layoutTemplate' => 'site/layout',
                   ),
               ),

               // By default, the MVC registers an "exception strategy", which is
               // triggered when a requested action raises an exception; it creates
               // a custom view model that wraps the exception, and selects a
               // template. This template is "error" by default; let's change it to
               // "site/error" (which we mapped via the TemplateMapResolver,
               // above).
               //
               // Additionally, we'll tell it that we want to display an exception
               // stack trace; you'll likely want to disable this by default.
               'Zend\Mvc\View\ExceptionStrategy' => array(
                   'parameters' => array(
                       'displayExceptions' => true,
                       'exceptionTemplate' => 'site/error',
                   ),
               ),

               // Another strategy the MVC registers by default is a "route not
               // found" strategy. Basically, this gets triggered if (a) no route
               // matches the current request, (b) the controller specified in the
               // route match cannot be found in the locator, (c) the controller
               // specified in the route match does not implement the DispatchableInterface
               // interface, or (d) if a response from a controller sets the
               // response status to 404.
               //
               // The default template used in such situations is "error", just
               // like the exception strategy. Let's tell it to use the "site/404"
               // template, (which we mapped via the TemplateMapResolver, above).
               //
               // You can opt in to inject the reason for a 404 situation; see the
               // various Application::ERROR_* constants for a list of values.
               // Additionally, a number of 404 situations derive from exceptions
               // raised during routing or dispatching. You can opt-in to display
               // these.
               'Zend\Mvc\View\RouteNotFoundStrategy' => array(
                   'parameters' => array(
                       'displayExceptions'     => true,
                       'displayNotFoundReason' => true,
                       'notFoundTemplate'      => 'site/404',
                   ),
               ),
           ),
       ),
   );

.. _zend.view.quick-start.usage.controllers:

.. rubric:: Controllers and View Models

``Zend\View\View`` consumes ``ViewModels``, passing them to the selected renderer. Where do you create these,
though?

The most explicit way is to create them in your controllers and return them.

.. code-block:: php
   :linenos:

   namespace Foo\Controller;

   use Zend\Mvc\Controller\AbstractActionController;
   use Zend\View\Model\ViewModel;

   class BarController extends AbstractActionController
   {
       public function doSomethingAction()
       {
           $view = new ViewModel(array(
               'message' => 'Hello world',
           ));
           $view->setTemplate('bar/do-something');
           return $view;
       }
   }

This sets a "message" variable in the view model, and sets the template name "bar/do-something". The view model is
then returned.

Considering that in most cases, you'll likely have a template name based on the controller and action, and simply
be passing some variables, could this be made simpler? Definitely.

The MVC registers a couple of listeners for controllers to automate this. The first will look to see if you
returned an associative array from your controller; if so, it will create a view model and inject this associative
array as the view variables container; this view model then replaces the MVC event's result. It will also look to
see if you returned nothing or null; if so, it will create a view model without any variables attached; this view
model also replaces the MVC event's result.

The second listener checks to see if the MVC event result is a view model, and, if so, if it has a template
associated with it. If not, it will inspect the controller matched during routing, and, if available, it's "action"
parameter in order to create a template name. This will be "controller/action", with the controller and action
normalized to lowercase, dash-separated words.

As an example, the controller ``Foo\Controller\BazBatController``, with action "doSomethingCrazy", would be mapped
to the template ``baz-bat/do-something-crazy``.

In practice, that means our previous example could be re-written as follows:

.. code-block:: php
   :linenos:

   namespace Foo\Controller;

   use Zend\Mvc\Controller\AbstractActionController;

   class BazBatController extends AbstractActionController
   {
       public function doSomethingCrazyAction()
       {
           return array(
               'message' => 'Hello world',
           );
       }
   }

The above method will likely work for a majority of use cases. When you need to specify a different template,
explicitly create and return a view model, and specify the template manually.

The other use case you may have for explicit view models is if you wish to **nest** view models. Use cases include
if you want to render templates to include within the main view you return.

As an example, you may want the view from the action to be one primary section that includes both an "article" and
a couple of sidebars; one of the sidebars may include content from multiple views as well.

.. code-block:: php
   :linenos:

   namespace Content\Controller;

   use Zend\Mvc\Controller\AbstractActionController;
   use Zend\View\Model\ViewModel;

   class ArticleController extends AbstractActionController
   {
       public function viewAction()
       {
           // get the article from the persistence layer, etc...

           $view = new ViewModel();

           $articleView = new ViewModel(array('article' => $article));
           $articleView->setTemplate('content/article');

           $primarySidebarView = new ViewModel();
           $primarySidebarView->setTemplate('content/main-sidebar');

           $secondarySidebarView = new ViewModel();
           $secondarySidebarView->setTemplate('content/secondary-sidebar');

           $sidebarBlockView = new ViewModel();
           $sidebarBlockView->setTemplate('content/block');

           $secondarySidebarView->addChild($sidebarBlockView, 'block');

           $view->addChild($articleView, 'article')
                ->addChild($primarySidebarView, 'sidebar_primary')
                ->addChild($secondarySidebarView, 'sidebar_secondary');

           return $view;
       }
   }

The above will create and return a view model specifying the template "content/article". When the view is rendered,
it will render three child views, the ``$articleView``, ``$primarySidebarView``, and ``$secondarySidebarView``;
these will be captured to the ``$view``'s "article", "sidebar_primary", and "sidebar_secondary" variables,
respectively, so that when it renders, you may include that content. Additionally, the ``$secondarySidebarView``
will include an additional view model, ``$sidebarBlockView``, which will be captured to its "block" view variable.

To better visualize this, let's look at what the final content might look like, with comments detailing where each
nested view model is injected.

Here are the templates:

.. code-block:: php
   :linenos:

   <?php // "article/view" template ?>
   <div class="sixteen columns content">
       <?php echo $this->article ?>

       <?php echo $this->sidebar_primary ?>

       <?php echo $this->sidebar_secondary ?>
   </div>

   <?php // "content/article" template ?>
       <!-- This is from the $articleView view model, and the "content/article"
            template -->
       <article class="twelve columns">
           <?php echo $this->escapeHtml('article') ?>
       </article>

   <?php // "content/main-sidebar template ?>
       <!-- This is from the $primarySidebarView view model, and the
            "content/main-sidebar template -->
       <div class="two columns sidebar">
           sidebar content...
       </div>

   <?php // "content/secondary-sidebar template ?>
       <!-- This is from the $secondarySidebarView view model, and the
            "content/secondary-sidebar template -->
       <div class="two columns sidebar">
           <?php echo $this->block ?>
       </div>

   <?php // "content/block template ?>
           <!-- This is from the $sidebarBlockView view model, and the
               "content/block template -->
           <div class="block">
               block content...
           </div>

And here is the aggregate, generated content:

.. code-block:: html
   :linenos:

   <!-- This is from the $view view model, and the "article/view" template -->
   <div class="sixteen columns content">
       <!-- This is from the $articleView view model, and the "content/article"
            template -->
       <article class="twelve columns">
           Lorem ipsum ....
       </article>

       <!-- This is from the $primarySidebarView view model, and the
            "content/main-sidebar template -->
       <div class="two columns sidebar">
           sidebar content...
       </div>

       <!-- This is from the $secondarySidebarView view model, and the
            "content/secondary-sidebar template -->
       <div class="two columns sidebar">
           <!-- This is from the $sidebarBlockView view model, and the
               "content/block template -->
           <div class="block">
               block content...
           </div>
       </div>
   </div>

As you can see, you can achieve very complex markup using nested views, while simultaneously keeping the details of
rendering isolated from the request/reponse lifecycle of the controller.

.. _zend.view.quick-start.usage.layouts:

.. rubric:: Dealing with Layouts

Most sites enforce a cohesive look-and-feel, which we typically call the site "layout". The site layout includes
the default stylesheets and JavaScript necessary, if any, as well as the basic markup structure into which all site
content will be injected.

Within Zend Framework, layouts are handled via nesting of view models (see the :ref:`previous example
<zend.view.quick-start.usage.controllers>` for examples of view model nesting). The MVC event composes a View Model
which acts as the "root" for nested view models, as such, it should contain the skeleton, or layout, template for
the site (configuration refers to this as the "layoutTemplate"). All other content is then rendered and captured to
view variables of this root view model.

The default rendering strategy sets the layout template as "layout". To change this, you can add some configuration
for the Dependency Injector.

.. code-block:: php
   :linenos:

   return array(
       'di' => array(
           'instance' => array(
           // The above lines will likely already be present; it's the following
           // definitions that you will want to ensure are present within the DI
           // instance configuration.

               // By default, the MVC's default rendering strategy uses the
               // template name "layout" for the site layout. Let's tell it to use
               // "site/layout" (which we mapped via the TemplateMapResolver,
               // above).
               'Zend\Mvc\View\DefaultRenderingStrategy' => array(
                   'parameters' => array(
                       'baseTemplate' => 'site/layout',
                   ),
               ),
           ),
       ),
   );

A listener on the controllers, ``Zend\Mvc\View\InjectViewModelListener``, will take a view model returned from a
controller and inject it as a child of the root (layout) view model. By default, view models will capture to the
"content" variable of the root view model. This means you can do the following in your layout view script:

.. code-block:: php
   :linenos:

   <html>
       <head>
           <title><?php echo $this->headTitle() ?></title>
       </head>
       <body>
           <?php echo $this->content; ?>
       </body>
   </html>

If you want to specify a different view variable for which to capture, explicitly create a view model in your
controller, and set its "capture to" value:

.. code-block:: php
   :linenos:

   namespace Foo\Controller;

   use Zend\Mvc\Controller\AbstractActionController;
   use Zend\View\Model\ViewModel;

   class BarController extends AbstractActionController
   {
       public function doSomethingAction()
       {
           $view = new ViewModel(array(
               'message' => 'Hello world',
           ));

           // Capture to the layout view's "article" variable
           $view->setCaptureTo('article');

           return $view;
       }
   }

There will be times you don't want to render a layout. For example, you might be answering an API call which
expects JSON or an XML payload, or you might be answering an XHR request that expects a partial HTML payload. The
simplest way to do this is to explicitly create and return a view model from your controller, and mark it as
"terminal", which will hint to the MVC listener that normally injects the returned view model into the layout view
model to instead replace the layout view model.

.. code-block:: php
   :linenos:

   namespace Foo\Controller;

   use Zend\Mvc\Controller\AbstractActionController;
   use Zend\View\Model\ViewModel;

   class BarController extends AbstractActionController
   {
       public function doSomethingAction()
       {
           $view = new ViewModel(array(
               'message' => 'Hello world',
           ));

           // Disable layouts; use this view model in the MVC event instead
           $view->setTerminal(true);

           return $view;
       }
   }

:ref:`When discussing controllers and view models <zend.view.quick-start.usage.controllers>`, we detailed a nested
view model which contained an article and sidebars. Sometimes, you may want to provide additional view models to
the layout, instead of nesting in the returned layout. This may be done by using the "layout" controller plugin,
which returns the root view model; you can then call the same ``addChild()`` method on it as we did in that
previous example.

.. code-block:: php
   :linenos:

   namespace Content\Controller;

   use Zend\Mvc\Controller\AbstractActionController;
   use Zend\View\Model\ViewModel;

   class ArticleController extends AbstractActionController
   {
       public function viewAction()
       {
           // get the article from the persistence layer, etc...

           // Get the "layout" view model and inject a sidebar
           $layout = $this->layout();
           $sidebarView = new ViewModel();
           $sidebarView->setTemplate('content/sidebar');
           $layout->addChild($sidebarView, 'sidebar');

           // Create and return a view model for the retrieved article
           $view = new ViewModel(array('article' => $article));
           $view->setTemplate('content/article');
           return $view;
       }
   }

You could also use this technique to select a different layout, by simply calling the ``setTemplate()`` method of
the layout view model.

.. code-block:: php
   :linenos:

   namespace Content\Controller;

   use Zend\Mvc\Controller\AbstractActionController;
   use Zend\View\Model\ViewModel;

   class ArticleController extends AbstractActionController
   {
       public function viewAction()
       {
           // get the article from the persistence layer, etc...

           // Get the "layout" view model and set an alternate template
           $layout = $this->layout();
           $layout->setTemplate('article/layout');

           // Create and return a view model for the retrieved article
           $view = new ViewModel(array('article' => $article));
           $view->setTemplate('content/article');
           return $view;
       }
   }

Sometimes, you may want to access the layout from within your actual view scripts when using the ``PhpRenderer``.
Reasons might include wanting to change the layout template, or wanting to access or inject layout view variables.
Similar to controllers, you can use the "layout" view plugin/helper. If you provide a string argument to it, you
will change the template; if you provide no arguments the root layout view model is returned.

.. code-block:: php
   :linenos:

   // Change the layout:
   $this->layout('alternate/layout'); // OR
   $this->layout()->setTemplate('alternate/layout');

   // Access a layout variable.
   // Since access to the base view model is relatively easy, it becomes a
   // reasonable place to store things such as API keys, which other view scripts
   // may need.
   $layout       = $this->layout();
   $disqusApiKey = false;
   if (isset($layout->disqusApiKey)) {
       $disqusApiKey = $layout->disqusApiKey;
   }

   // Set a layout variable
   $this->layout()->footer = $this->render('article/footer');

Commonly, you may want to alter the layout based on the module currently selected.

Another frequently requested feature is the ability to change a layout based on the current **module**. This
requires (a) detecting if the controller matched in routing belongs to this module, and then (b) changing the
template of the view model.

The place to do these actions is in a listener. It should listen either to the "route" event at low (negative)
priority, or on the "dispatch" event, at any priority. Typically, you will register this during the bootstrap
event.

.. code-block:: php
   :linenos:

   namespace Content;

   class Module
   {
       public function onBootstrap($e)
       {
           // Register a dispatch event
           $app = $e->getParam('application');
           $app->getEventManager()->attach('dispatch', array($this, 'setLayout'), -100);
       }

       public function setLayout($e)
       {
           $matches    = $e->getRouteMatch();
           $controller = $matches->getParam('controller');
           if (0 !== strpos($controller, __NAMESPACE__, 0)) {
               // not a controller from this module
               return;
           }

           // Set the layout template
           $viewModel = $e->getViewModel();
           $viewModel->setTemplate('content/layout');
       }
   }

.. _zend.view.quick-start.usage.strategies:

.. rubric:: Creating and Registering Alternate Rendering and Response Strategies

``Zend\View\View`` does very little. Its workflow is essentially to martial a ``ViewEvent``, and then trigger two
events, "renderer" and "response". You can attach "strategies" to these events, using the methods
``addRendererStrategy()`` and ``addResponseStrategy()``, respectively. A "renderer strategy" investigates the
Request object (or any other criteria) in order to select a renderer (or fail to select one). A "response strategy"
determines how to populate the Response based on the result of rendering.

Zend Framework ships with three rendering/response strategies that you can use within your application.

- ``Zend\View\Strategy\PhpRendererStrategy``. This strategy is a "catch-all" in that it will always return the
  ``Zend\View\Renderer\PhpRenderer``, and populate the Response body with the results of rendering.

- ``Zend\View\Strategy\JsonStrategy``. This strategy inspects the Accept HTTP header, if present, and determines if
  the client has indicated it accepts an "application/json" response. If so, it will return the
  ``Zend\View\Renderer\JsonRenderer``, and populate the Response body with the JSON value returned, as well as set
  a Content-Type header with a value of "application/json".

- ``Zend\View\Strategy\FeedStrategy``. This strategy inspects the Accept HTTP header, if present, and determines if
  the client has indicated it accepts either an "application/rss+xml" or "application/atom+xml" response. If so, it
  will return the ``Zend\View\Renderer\FeedRenderer``, setting the feed type to either "rss" or "atom", based on
  what was matched. Its Response strategy will populate the Response body with the generated feed, as well as set a
  Content-Type header with the appropriate value based on feed type.

By default, only the ``PhpRendererStrategy`` is registered, meaning you will need to register the other strategies
yourself if you want to use them. Additionally, it means that you will likely want to register these at higher
priority to ensure they match before the ``PhpRendererStrategy``. As an example, let's register the
``JsonStrategy``.

.. code-block:: php
   :linenos:

   namespace Application;

   class Module
   {
       public function onBootstrap($e)
       {
           // Register a "render" event, at high priority (so it executes prior
           // to the view attempting to render)
           $app = $e->getParam('application');
           $app->getEventManager()->attach('render', array($this, 'registerJsonStrategy'), 100);
       }

       public function registerJsonStrategy($e)
       {
           $app          = $e->getTarget();
           $locator      = $app->getServiceManager();
           $view         = $locator->get('Zend\View\View');
           $jsonStrategy = $locator->get('ViewJsonStrategy');

           // Attach strategy, which is a listener aggregate, at high priority
           $view->getEventManager()->attach($jsonStrategy, 100);
       }
   }


The above will register the ``JsonStrategy`` with the "render" event, such that it executes prior to the
``PhpRendererStrategy``, and thus ensure that a JSON payload is created when requested.

What if you want this to happen only in specific modules, or specific controllers? One way is similar to the last
example in the :ref:`previous section on layouts <zend.view.quick-start.usage.layouts>`, where we detailed changing
the layout for a specific module.

.. code-block:: php
   :linenos:

   namespace Content;

   class Module
   {
       public function onBootstrap($e)
       {
           // Register a render event
           $app = $e->getParam('application');
           $app->getEventManager()->attach('render', array($this, 'registerJsonStrategy'), 100);
       }

       public function registerJsonStrategy($e)
       {
           $matches    = $e->getRouteMatch();
           $controller = $matches->getParam('controller');
           if (0 !== strpos($controller, __NAMESPACE__, 0)) {
               // not a controller from this module
               return;
           }

           // Potentially, you could be even more selective at this point, and test
           // for specific controller classes, and even specific actions or request
           // methods.

           // Set the JSON strategy when controllers from this module are selected
           $app          = $e->getTarget();
           $locator      = $app->getServiceManager();
           $view         = $locator->get('Zend\View\View');
           $jsonStrategy = $locator->get('ViewJsonStrategy');

           // Attach strategy, which is a listener aggregate, at high priority
           $view->getEventManager()->attach($jsonStrategy, 100);
       }
   }

While the above examples detail using the JSON strategy, the same could be done for the ``FeedStrategy``.

What if you want to use a custom renderer? or if your app might allow a combination of JSON, Atom feeds, and HTML?
At this point, you'll need to create your own custom strategies. Below is an example that more appropriately loops
through the HTTP Accept header, and selects the appropriate renderer based on what is matched first.

.. code-block:: php
   :linenos:

   namespace Content\View;

   use Zend\EventManager\EventCollection;
   use Zend\EventManager\ListenerAggregate;
   use Zend\Feed\Writer\Feed;
   use Zend\View\Renderer\FeedRenderer;
   use Zend\View\Renderer\JsonRenderer;
   use Zend\View\Renderer\PhpRenderer;

   class AcceptStrategy implements ListenerAggregate
   {
       protected $feedRenderer;
       protected $jsonRenderer;
       protected $listeners = array();
       protected $phpRenderer;

       public function __construct(
           PhpRenderer $phpRenderer,
           JsonRenderer $jsonRenderer,
           FeedRenderer $feedRenderer
       ) {
           $this->phpRenderer  = $phpRenderer;
           $this->jsonRenderer = $jsonRenderer;
           $this->feedRenderer = $feedRenderer;
       }

       public function attach(EventCollection $events, $priority = null)
       {
           if (null === $priority) {
               $this->listeners[] = $events->attach('renderer', array($this, 'selectRenderer'));
               $this->listeners[] = $events->attach('response', array($this, 'injectResponse'));
           } else {
               $this->listeners[] = $events->attach('renderer', array($this, 'selectRenderer'), $priority);
               $this->listeners[] = $events->attach('response', array($this, 'injectResponse'), $priority);
           }
       }

       public function detach(EventCollection $events)
       {
           foreach ($this->listeners as $index => $listener) {
               if ($events->detach($listener)) {
                   unset($this->listeners[$index]);
               }
           }
       }

       public function selectRenderer($e)
       {
           $request = $e->getRequest();
           $headers = $request->getHeaders();

           // No Accept header? return PhpRenderer
           if (!$headers->has('accept')) {
               return $this->phpRenderer;
           }

           $accept = $headers->get('accept');
           foreach ($accept->getPrioritized() as $mediaType) {
               if (0 === strpos($mediaType, 'application/json')) {
                   return $this->jsonRenderer;
               }
               if (0 === strpos($mediaType, 'application/rss+xml')) {
                   $this->feedRenderer->setFeedType('rss');
                   return $this->feedRenderer;
               }
               if (0 === strpos($mediaType, 'application/atom+xml')) {
                   $this->feedRenderer->setFeedType('atom');
                   return $this->feedRenderer;
               }
           }

           // Nothing matched; return PhpRenderer. Technically, we should probably
           // return an HTTP 415 Unsupported response.
           return $this->phpRenderer;
       }

       public function injectResponse($e)
       {
           $renderer = $e->getRenderer();
           $response = $e->getResponse();
           $result   = $e->getResult();

           if ($renderer === $this->jsonRenderer) {
               // JSON Renderer; set content-type header
               $headers = $response->getHeaders();
               $headers->addHeaderLine('content-type', 'application/json');
           } elseif ($renderer === $this->feedRenderer) {
               // Feed Renderer; set content-type header, and export the feed if
               // necessary
               $feedType  = $this->feedRenderer->getFeedType();
               $headers   = $response->getHeaders();
               $mediatype = 'application/'
                          . (('rss' == $feedType) ? 'rss' : 'atom')
                          . '+xml';
               $headers->addHeaderLine('content-type', $mediatype);

               // If the $result is a feed, export it
               if ($result instanceof Feed) {
                   $result = $result->export($feedType);
               }
           } elseif ($renderer !== $this->phpRenderer) {
               // Not a renderer we support, therefor not our strategy. Return
               return;
           }

           // Inject the content
           $response->setContent($result);
       }
   }

This strategy would be registered just as we demonstrated registering the ``JsonStrategy`` earlier. You would also
need to define DI configuration to ensure the various renderers are injected when you retrieve the strategy from
the application's locator instance.


