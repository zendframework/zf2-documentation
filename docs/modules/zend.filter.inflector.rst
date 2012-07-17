
.. _zend.filter.inflector:

Zend_Filter_Inflector
=====================

``Zend_Filter_Inflector`` is a general purpose tool for rules-based inflection of strings to a given target.

As an example, you may find you need to transform MixedCase or camelCasedWords into a path; for readability, OS policies, or other reasons, you also need to lower case this, and you want to separate the words using a dash ('-'). An inflector can do this for you.

``Zend_Filter_Inflector`` implements ``Zend_Filter_Interface``; you perform inflection by calling ``filter()`` on the object instance.


.. _zend.filter.inflector.camel_case_example:

.. rubric:: Transforming MixedCase and camelCaseText to another format

.. code-block:: php
   :linenos:

   $inflector = new Zend_Filter_Inflector('pages/:page.:suffix');
   $inflector->setRules(array(
       ':page'  => array('Word_CamelCaseToDash', 'StringToLower'),
       'suffix' => 'html'
   ));

   $string   = 'camelCasedWords';
   $filtered = $inflector->filter(array('page' => $string));
   // pages/camel-cased-words.html

   $string   = 'this_is_not_camel_cased';
   $filtered = $inflector->filter(array('page' => $string));
   // pages/this_is_not_camel_cased.html


.. _zend.filter.inflector.operation:

Operation
---------

An inflector requires a **target** and one or more **rules**. A target is basically a string that defines placeholders for variables you wish to substitute. These are specified by prefixing with a ':': **:script**.

When calling ``filter()``, you then pass in an array of key and value pairs corresponding to the variables in the target.

Each variable in the target can have zero or more rules associated with them. Rules may be either **static** or refer to a ``Zend_Filter`` class. Static rules will replace with the text provided. Otherwise, a class matching the rule provided will be used to inflect the text. Classes are typically specified using a short name indicating the filter name stripped of any common prefix.

As an example, you can use any ``Zend_Filter`` concrete implementations; however, instead of referring to them as '``Zend_Filter_Alpha``' or '``Zend_Filter_StringToLower``', you'd specify only '``Alpha``' or '``StringToLower``'.


.. _zend.filter.inflector.paths:

Setting Paths To Alternate Filters
----------------------------------

``Zend_Filter_Inflector`` uses ``Zend_Loader_PluginLoader`` to manage loading filters to use with inflection. By default, any filter prefixed with ``Zend_Filter`` will be available. To access filters with that prefix but which occur deeper in the hierarchy, such as the various Word filters, simply strip off the ``Zend_Filter`` prefix:

.. code-block:: php
   :linenos:

   // use Zend_Filter_Word_CamelCaseToDash as a rule
   $inflector->addRules(array('script' => 'Word_CamelCaseToDash'));

To set alternate paths, ``Zend_Filter_Inflector`` has a utility method that proxies to the plugin loader, ``addFilterPrefixPath()``:

.. code-block:: php
   :linenos:

   $inflector->addFilterPrefixPath('My_Filter', 'My/Filter/');

Alternatively, you can retrieve the plugin loader from the inflector, and interact with it directly:

.. code-block:: php
   :linenos:

   $loader = $inflector->getPluginLoader();
   $loader->addPrefixPath('My_Filter', 'My/Filter/');

For more options on modifying the paths to filters, please see :ref:`the PluginLoader documentation <zend.loader.pluginloader>`.


.. _zend.filter.inflector.targets:

Setting the Inflector Target
----------------------------

The inflector target is a string with some placeholders for variables. Placeholders take the form of an identifier, a colon (':') by default, followed by a variable name: ':script', ':path', etc. The ``filter()`` method looks for the identifier followed by the variable name being replaced.

You can change the identifier using the ``setTargetReplacementIdentifier()`` method, or passing it as the third argument to the constructor:

.. code-block:: php
   :linenos:

   // Via constructor:
   $inflector = new Zend_Filter_Inflector('#foo/#bar.#sfx', null, '#');

   // Via accessor:
   $inflector->setTargetReplacementIdentifier('#');

Typically, you will set the target via the constructor. However, you may want to re-set the target later (for instance, to modify the default inflector in core components, such as the ``ViewRenderer`` or ``Zend_Layout``). ``setTarget()`` can be used for this purpose:

.. code-block:: php
   :linenos:

   $inflector = $layout->getInflector();
   $inflector->setTarget('layouts/:script.phtml');

Additionally, you may wish to have a class member for your class that you can use to keep the inflector target updated -- without needing to directly update the target each time (thus saving on method calls). ``setTargetReference()`` allows you to do this:

.. code-block:: php
   :linenos:

   class Foo
   {
       /**
        * @var string Inflector target
        */
       protected $_target = 'foo/:bar/:baz.:suffix';

       /**
        * Constructor
        * @return void
        */
       public function __construct()
       {
           $this->_inflector = new Zend_Filter_Inflector();
           $this->_inflector->setTargetReference($this->_target);
       }

       /**
        * Set target; updates target in inflector
        *
        * @param  string $target
        * @return Foo
        */
       public function setTarget($target)
       {
           $this->_target = $target;
           return $this;
       }
   }


.. _zend.filter.inflector.rules:

Inflection Rules
----------------

As mentioned in the introduction, there are two types of rules: static and filter-based.

.. note::
   It is important to note that regardless of the method in which you add rules to the inflector, either one-by-one, or all-at-once; the order is very important. More specific names, or names that might contain other rule names, must be added before least specific names. For example, assuming the two rule names 'moduleDir' and 'module', the 'moduleDir' rule should appear before module since 'module' is contained within 'moduleDir'. If 'module' were added before 'moduleDir', 'module' will match part of 'moduleDir' and process it leaving 'Dir' inside of the target uninflected.



.. _zend.filter.inflector.rules.static:

Static Rules
^^^^^^^^^^^^

Static rules do simple string substitution; use them when you have a segment in the target that will typically be static, but which you want to allow the developer to modify. Use the ``setStaticRule()`` method to set or modify the rule:

.. code-block:: php
   :linenos:

   $inflector = new Zend_Filter_Inflector(':script.:suffix');
   $inflector->setStaticRule('suffix', 'phtml');

   // change it later:
   $inflector->setStaticRule('suffix', 'php');

Much like the target itself, you can also bind a static rule to a reference, allowing you to update a single variable instead of require a method call; this is often useful when your class uses an inflector internally, and you don't want your users to need to fetch the inflector in order to update it. The ``setStaticRuleReference()`` method is used to accomplish this:

.. code-block:: php
   :linenos:

   class Foo
   {
       /**
        * @var string Suffix
        */
       protected $_suffix = 'phtml';

       /**
        * Constructor
        * @return void
        */
       public function __construct()
       {
           $this->_inflector = new Zend_Filter_Inflector(':script.:suffix');
           $this->_inflector->setStaticRuleReference('suffix', $this->_suffix);
       }

       /**
        * Set suffix; updates suffix static rule in inflector
        *
        * @param  string $suffix
        * @return Foo
        */
       public function setSuffix($suffix)
       {
           $this->_suffix = $suffix;
           return $this;
       }
   }


.. _zend.filter.inflector.rules.filters:

Filter Inflector Rules
^^^^^^^^^^^^^^^^^^^^^^

``Zend_Filter`` filters may be used as inflector rules as well. Just like static rules, these are bound to a target variable; unlike static rules, you may define multiple filters to use when inflecting. These filters are processed in order, so be careful to register them in an order that makes sense for the data you receive.

Rules may be added using ``setFilterRule()`` (which overwrites any previous rules for that variable) or ``addFilterRule()`` (which appends the new rule to any existing rule for that variable). Filters are specified in one of the following ways:

- **String**. The string may be a filter class name, or a class name segment minus any prefix set in the inflector's plugin loader (by default, minus the '``Zend_Filter``' prefix).

- **Filter object**. Any object instance implementing ``Zend_Filter_Interface`` may be passed as a filter.

- **Array**. An array of one or more strings or filter objects as defined above.

.. code-block:: php
   :linenos:

   $inflector = new Zend_Filter_Inflector(':script.:suffix');

   // Set rule to use Zend_Filter_Word_CamelCaseToDash filter
   $inflector->setFilterRule('script', 'Word_CamelCaseToDash');

   // Add rule to lowercase string
   $inflector->addFilterRule('script', new Zend_Filter_StringToLower());

   // Set rules en-masse
   $inflector->setFilterRule('script', array(
       'Word_CamelCaseToDash',
       new Zend_Filter_StringToLower()
   ));


.. _zend.filter.inflector.rules.multiple:

Setting Many Rules At Once
^^^^^^^^^^^^^^^^^^^^^^^^^^

Typically, it's easier to set many rules at once than to configure a single variable and its inflection rules at a time. ``Zend_Filter_Inflector``'s ``addRules()`` and ``setRules()`` method allow this.

Each method takes an array of variable and rule pairs, where the rule may be whatever the type of rule accepts (string, filter object, or array). Variable names accept a special notation to allow setting static rules and filter rules, according to the following notation:

- **':' prefix**: filter rules.

- **No prefix**: static rule.


.. _zend.filter.inflector.rules.multiple.example:

.. rubric:: Setting Multiple Rules at Once

.. code-block:: php
   :linenos:

   // Could also use setRules() with this notation:
   $inflector->addRules(array(
       // filter rules:
       ':controller' => array('CamelCaseToUnderscore','StringToLower'),
       ':action'     => array('CamelCaseToUnderscore','StringToLower'),

       // Static rule:
       'suffix'      => 'phtml'
   ));


.. _zend.filter.inflector.utility:

Utility Methods
---------------

``Zend_Filter_Inflector`` has a number of utility methods for retrieving and setting the plugin loader, manipulating and retrieving rules, and controlling if and when exceptions are thrown.

- ``setPluginLoader()`` can be used when you have configured your own plugin loader and wish to use it with ``Zend_Filter_Inflector``; ``getPluginLoader()`` retrieves the currently set one.

- ``setThrowTargetExceptionsOn()`` can be used to control whether or not ``filter()`` throws an exception when a given replacement identifier passed to it is not found in the target. By default, no exceptions are thrown. ``isThrowTargetExceptionsOn()`` will tell you what the current value is.

- ``getRules($spec = null)`` can be used to retrieve all registered rules for all variables, or just the rules for a single variable.

- ``getRule($spec, $index)`` fetches a single rule for a given variable; this can be useful for fetching a specific filter rule for a variable that has a filter chain. ``$index`` must be passed.

- ``clearRules()`` will clear all currently registered rules.


.. _zend.filter.inflector.config:

Using Zend_Config with Zend_Filter_Inflector
--------------------------------------------

You can use ``Zend_Config`` to set rules, filter prefix paths, and other object state in your inflectors, either by passing a ``Zend_Config`` object to the constructor or ``setOptions()``. The following settings may be specified:

- ``target`` specifies the inflection target.

- ``filterPrefixPath`` specifies one or more filter prefix and path pairs for use with the inflector.

- ``throwTargetExceptionsOn`` should be a boolean indicating whether or not to throw exceptions when a replacement identifier is still present after inflection.

- ``targetReplacementIdentifier`` specifies the character to use when identifying replacement variables in the target string.

- ``rules`` specifies an array of inflection rules; it should consist of keys that specify either values or arrays of values, consistent with ``addRules()``.


.. _zend.filter.inflector.config.example:

.. rubric:: Using Zend_Config with Zend_Filter_Inflector

.. code-block:: php
   :linenos:

   // With the constructor:
   $config    = new Zend_Config($options);
   $inflector = new Zend_Filter_Inflector($config);

   // Or with setOptions():
   $inflector = new Zend_Filter_Inflector();
   $inflector->setOptions($config);


