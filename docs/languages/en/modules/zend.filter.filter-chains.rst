.. _zend.filter.filter_chains:

Filter Chains
=============

Often multiple filters should be applied to some value in a particular order. For example, a login form accepts a
username that should be only lowercase, alphabetic characters. ``Zend\Filter\FilterChain`` provides a simple method
by which filters may be chained together. The following code illustrates how to chain together two filters for the
submitted username:

.. code-block:: php
   :linenos:

   // Create a filter chain and add filters to the chain
   $filterChain = new Zend\Filter\FilterChain();
   $filterChain->attach(new Zend\I18n\Filter\Alpha())
               ->attach(new Zend\Filter\StringToLower());

   // Filter the username
   $username = $filterChain->filter($_POST['username']);

Filters are run in the order they were added to ``Zend\Filter\FilterChain``. In the above example, the username is
first removed of any non-alphabetic characters, and then any uppercase characters are converted to lowercase.

Any object that implements ``Zend\Filter\FilterInterface`` may be used in a filter chain.

.. _zend.filter.filter_chains.order:

Setting Filter Chain Order
---------------------------

For each filter added to the ``FilterChain`` you can set a priority to define the chain order. The default value is
``1000``. In the following example, any uppercase characters are converted to lowercase before any non-alphabetic
characters are removed.

.. code-block:: php
   :linenos:

   // Create a filter chain and add filters to the chain
   $filterChain = new Zend\Filter\FilterChain();
   $filterChain->attach(new Zend\I18n\Filter\Alpha())
               ->attach(new Zend\Filter\StringToLower(), 500);

.. _zend.filter.filter_chains.plugin_manager:

Using the Plugin Manager
------------------------

To every ``FilterChain`` object an instance of the ``FilterPluginManager`` is attached. Every filter that is used
in a ``FilterChain`` must be know by this ``FilterPluginManager``. To add a filter that is known by the
``FilterPluginManager`` you can use the ``attachByName()`` method. The first parameter is the name of the filter
within the ``FilterPluginManager``. The second parameter takes any options for creating the filter instance. The
third parameter is the priority.

.. code-block:: php
   :linenos:

   // Create a filter chain and add filters to the chain
   $filterChain = new Zend\Filter\FilterChain();
   $filterChain->attachByName('alpha')
               ->attachByName('stringtolower', array('encoding' => 'utf-8'), 500);

The following example shows how to add a custom filter to the ``FilterPluginManager`` and the ``FilterChain``.

.. code-block:: php
   :linenos:

   $filterChain = new Zend\Filter\FilterChain();
   $filterChain->getPluginManager()->setInvokableClass(
       'myNewFilter', 'MyCustom\Filter\MyNewFilter'
   );
   $filterChain->attachByName('alpha')
               ->attachByName('myNewFilter');

You can also add your own ``FilterPluginManager`` implementation.

.. code-block:: php
   :linenos:

   $filterChain = new Zend\Filter\FilterChain();
   $filterChain->setPluginManager(new MyFilterPluginManager());
   $filterChain->attach(new Zend\I18n\Filter\Alpha())
               ->attach(new MyCustom\Filter\MyNewFilter());
