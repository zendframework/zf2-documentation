.. _zend.view.helpers.initial.headtitle:

HeadTitle Helper
----------------

The *HTML* **<title>** element is used to provide a title for an *HTML* document. The ``HeadTitle`` helper allows
you to programmatically create and store the title for later retrieval and output.

The ``HeadTitle`` helper is a concrete implementation of the :ref:`Placeholder helper
<zend.view.helpers.initial.placeholder>`. It overrides the ``toString()`` method to enforce generating a
**<title>** element, and adds a ``headTitle()`` method for quick and easy setting and aggregation of title
elements. The signature for that method is ``headTitle($title, $setType = null)``; by default, the value is
appended to the stack (aggregating title segments) if left at null, but you may also specify either 'PREPEND'
(place at top of stack) or 'SET' (overwrite stack).

Since setting the aggregating (attach) order on each call to ``headTitle`` can be cumbersome, you can set a default
attach order by calling ``setDefaultAttachOrder()`` which is applied to all ``headTitle()`` calls unless you
explicitly pass a different attach order as the second parameter.

.. _zend.view.helpers.initial.headtitle.basicusage:

.. rubric:: HeadTitle Helper Basic Usage

You may specify a title tag at any time. A typical usage would have you setting title segments for each level of
depth in your application: site, module, controller, action, and potentially resource. This could be achieved in
the module class.

.. code-block:: php
   :linenos:

   // module/MyModule/Module.php
   <?php

   namespace MyModule;

   class Module
   {
       /**
        * @param  \Zend\Mvc\MvcEvent $e The MvcEvent instance
        * @return void
        */
       public function onBootstrap($e)
       {
           // Register a render event
           $app = $e->getParam('application');
           $app->getEventManager()->attach('render', array($this, 'setLayoutTitle'));
       }

       /**
        * @param  \Zend\Mvc\MvcEvent $e The MvcEvent instance
        * @return void
        */
       public function setLayoutTitle($e)
       {
           $matches    = $e->getRouteMatch();
           $action     = $matches->getParam('action');
           $controller = $matches->getParam('controller');
           $module     = __NAMESPACE__;
           $siteName   = 'Zend Framework';

           // Getting the view helper manager from the application service manager
           $viewHelperManager = $e->getApplication()->getServiceManager()->get('viewHelperManager');

           // Getting the headTitle helper from the view helper manager
           $headTitleHelper   = $viewHelperManager->get('headTitle');

           // Setting a separator string for segments
           $headTitleHelper->setSeparator(' - ');

           // Setting the action, controller, module and site name as title segments
           $headTitleHelper->append($action);
           $headTitleHelper->append($controller);
           $headTitleHelper->append($module);
           $headTitleHelper->append($siteName);
       }
   }

When you're finally ready to render the title in your layout script, simply echo the helper:

.. code-block:: php
   :linenos:

   <!-- renders <action> - <controller> - <module> - Zend Framework -->
   <?php echo $this->headTitle() ?>


