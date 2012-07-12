
Zend Framework 1.0
==================

When upgrading from a previous release to Zend Framework 1.0 or higher you should note the following migration notes.

.. _migration.10.zend.controller:

Zend_Controller
---------------

The principal changes introduced in 1.0.0RC1 are the introduction of and default enabling of the :ref:`ErrorHandler <zend.controller.plugins.standard.errorhandler>` plugin and the :ref:`ViewRenderer <zend.controller.actionhelpers.viewrenderer>` action helper. Please read the documentation to each thoroughly to see how they work and what effect they may have on your applications.

The ``ErrorHandler`` plugin runs during ``postDispatch()`` checking for exceptions, and forwarding to a specified error handler controller. You should include such a controller in your application. You may disable it by setting the front controller parameter ``noErrorHandler`` :

.. code-block:: php
    :linenos:
    
    $front->setParam('noErrorHandler', true);
    

The ``ViewRenderer`` action helper automates view injection into action controllers as well as autorendering of view scripts based on the current action. The primary issue you may encounter is if you have actions that do not render view scripts and neither forward or redirect, as the ``ViewRenderer`` will attempt to render a view script based on the action name.

There are several strategies you can take to update your code. In the short term, you can globally disable the ``ViewRenderer`` in your front controller bootstrap prior to dispatching:

.. code-block:: php
    :linenos:
    
    // Assuming $front is an instance of Zend_Controller_Front
    $front->setParam('noViewRenderer', true);
    

However, this is not a good long term strategy, as it means most likely you'll be writing more code.

When you're ready to start using the ``ViewRenderer`` functionality, there are several things to look for in your controller code. First, look at your action methods (the methods ending in 'Action'), and determine what each is doing. If none of the following is happening, you'll need to make changes:

    - Calls to $this->render();Calls to $this->_forward();Calls to $this->_redirect();Calls to the Redirector action helper


The easiest change is to disable auto-rendering for that method:

.. code-block:: php
    :linenos:
    
    $this->_helper->viewRenderer->setNoRender();
    

If you find that none of your action methods are rendering, forwarding, or redirecting, you will likely want to put the above line in your ``preDispatch()`` or ``init()`` methods:

.. code-block:: php
    :linenos:
    
    public function preDispatch()
    {
        // disable view script autorendering
        $this->_helper->viewRenderer->setNoRender()
        // .. do other things...
    }
    

If you are calling ``render()`` , and you're using :ref:`the Conventional Modular directory structure <zend.controller.modular>` , you'll want to change your code to make use of autorendering:

    - If you're rendering multiple view scripts in a single
    - action, you don't need to change a thing.
    - If you're simply calling render() with no
    - arguments, you can remove such lines.
    - If you're calling render() with arguments, and
    - not doing any processing afterwards or rendering multiple
    - view scripts, you can change these calls to read
    - $this->_helper->viewRenderer();.


If you're not using the conventional modular directory structure, there are a variety of methods for setting the view base path and script path specifications so that you can make use of the ``ViewRenderer`` . Please read the :ref:`ViewRenderer documentation <zend.controller.actionhelpers.viewrenderer>` for information on these methods.

If you're using a view object from the registry, or customizing your view object, or using a different view implementation, you'll want to inject the ``ViewRenderer`` with this object. This can be done easily at any time.

    - Prior to dispatching a front controller instance:
    - // Assuming $view has already been defined
    - $viewRenderer = new Zend_Controller_Action_Helper_ViewRenderer($view);
    - Zend_Controller_Action_HelperBroker::addHelper($viewRenderer);
    - Any time during the bootstrap process:
    - $viewRenderer =
    - Zend_Controller_Action_HelperBroker::getStaticHelper('viewRenderer');
    - $viewRenderer->setView($view);


There are many ways to modify the ``ViewRenderer`` , including setting a different view script to render, specifying replacements for all replaceable elements of a view script path (including the suffix), choosing a response named segment to utilize, and more. If you aren't using the conventional modular directory structure, you can even associate different path specifications with the ``ViewRenderer`` .

We encourage you to adapt your code to use the ``ErrorHandler`` and ``ViewRenderer`` as they are now core functionality.

.. _migration.10.zend.currency:

Zend_Currency
-------------

Creating an object of ``Zend_Currency`` has become simpler. You no longer have to give a script or set it to ``NULL`` . The optional script parameter is now an option which can be set through the ``setFormat()`` method.

.. code-block:: php
    :linenos:
    
    $currency = new Zend_Currency($currency, $locale);
    

The ``setFormat()`` method takes now an array of options. These options are set permanently and override all previously set values. Also a new option 'precision' has been added. The following options have been refactored:

    - position:
    - Replacement for the old 'rules' parameter.
    - script:
    - Replacement for the old 'script' parameter.
    - format:
    - Replacement for the old 'locale' parameter which does not
    - set new currencies but only the number format.
    - display:
    - Replacement for the old 'rules' parameter.
    - precision:
    - New parameter.
    - name:
    - Replacement for the ole 'rules' parameter. Sets the full
    - currencies name.
    - currency:
    - New parameter.
    - symbol:
    - New parameter.


.. code-block:: php
    :linenos:
    
    $currency->setFormat(array $options);
    

The ``toCurrency()`` method no longer supports the optional 'script' and 'locale' parameters. Instead it takes an options array which can contain the same keys as for the ``setFormat()`` method.

.. code-block:: php
    :linenos:
    
    $currency->toCurrency($value, array $options);
    

The methods ``getSymbol()`` , ``getShortName()`` , ``getName()`` , ``getRegionList()`` and ``getCurrencyList()`` are no longer static and can be called from within the object. They return the set values of the object if no parameter has been set.


