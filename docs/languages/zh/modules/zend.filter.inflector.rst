.. _zend.filter.inflector:

Zend_Filter_Inflector
=====================

*Zend_Filter_Inflector* 是一个为基于规则的把字符串变形到给定目标的一般意义上的工具。

例如，你可能发现你需要把混合大小写字（MixedCase）或驼峰字符（ camelCasedWords）
变成路径，对于可读性，OS 策略或其它原因，
你也需要把它变成小写，并且你想用短横线（'-'）来隔离单词。变形器（inflector）可以帮你做这些。

*Zend_Filter_Inflector* 实现 *Zend_Filter_Interface*\ ， 你可以通过在对象实例中调用 *filter()*
来执行变形。

.. _zend.filter.inflector.camel_case_example:

.. rubric:: 把混合大小写字（MixedCase）和驼峰字符 （camelCaseText） 变成其它格式

.. code-block::
   :linenos:
   <?php
   $inflector = new Zend_Filter_Inflector('pages/:page.:suffix');
   $inflector->setRules(array(
       ':page'  => array('Word_CamelCaseToDash', 'StringToLower'),
       'suffix' => 'html'
   ));

   $string   = 'camelCasedWords';
   $filtered = $inflector->filter(array('page' => $string)); // pages/camel-cased-words.html

   $string   = 'this_is_not_camel_cased';
   $filtered = $inflector->filter(array('page' => $string)); // pages/this_is_not_camel_cased.html
   ?>
.. _zend.filter.inflector.operation:

操作
--

变形器要求 **target** 和一个或多个 **rules**\ 。
目标基本上是个字符串，它为你想替换的变量定义了占位符。
这些由带有':'的前缀来指定： *:script*\ 。

当调用 *filter()* 时，传递一个和在目标中的变量相应的键/值对的数组。

在目标中的每个变量可以有零到多个规则。规则可以是 **静态的** 或指向 *Zend_Filter*
类的引用。
静态规则将用提供的文本替换，否则，和提供的规则匹配的类将用于变形这个文本。
类一般使用指示从任何普通前缀剥离的滤器名的短名来指定。

例如，你可以使用 *Zend_Filter* 的任何具体实现，然而，不用引用它们为 'Zend_Filter_Alpha'
或 'Zend_Filter_StringToLower'， 而是只指定 'Alpha' 或 'StringToLower'。

.. _zend.filter.inflector.paths:

设置到预备的过滤器的路径
------------

*Zend_Filter_Inflector* 使用 *Zend_Loader_PluginLoader* 来管理加载和变形一起使用的过滤器。
缺省地，任何带有 *Zend_Filter* 前缀的过滤器都可用。
为了访问带有那个前缀的过滤器，但发生在较深的等级结构里，如各种字过滤器，只需要剥离
Zend_Filter 前缀：

.. code-block::
   :linenos:
   <?php
   // use Zend_Filter_Word_CamelCaseToDash as a rule
   $inflector->addRules(array('script' => 'Word_CamelCaseToDash'));
   ?>
要设置备用的路径， *Zend_Filter_Inflector* 有个实用方法 *addFilterPrefixPath()*
来代理插件加载器：

.. code-block::
   :linenos:
   <?php
   $inflector->addFilterPrefixPath('My_Filter', 'My/Filter/');
   ?>
另外，你可以从变形器获取插件加载器并和它直接互动：

.. code-block::
   :linenos:
   <?php
   $loader = $inflector->getPluginLoader();
   $loader->addPrefixPath('My_Filter', 'My/Filter/');
   ?>
更多关于修改过滤器路径的选项，请参考 :ref:`插件加载器文档 <zend.loader.pluginloader>`\ 。

.. _zend.filter.inflector.targets:

设置变形器目标
-------

变形器目标是一个带有一些变量的占位符的字符串。
占位符表现为识别器的形式，缺省为冒号（':'），紧跟着变量名：':script'、 ':path'等。
*filter()* 方法寻找跟随着被替换的变量名的识别器。

可用使用 *setTargetReplacementIdentifier()*
方法来改变识别器，或把它当作第三个参数传递给构造器：

.. code-block::
   :linenos:
   <?php
   // Via constructor:
   $inflector = new Zend_Filter_Inflector('#foo/#bar.#sfx', null, '#');

   // Via accessor:
   $inflector->setTargetReplacementIdentifier('#');
   ?>
一般地，通过构造器来设置目标。然而，你想在稍后重置目标（例如，在核心部件里修改缺省变形器，如
*ViewRenderer* 或 *Zend_Layout* ）， 可使用 *setTarget()* ：

.. code-block::
   :linenos:
   <?php
   $inflector = $layout->getInflector();
   $inflector->setTarget('layouts/:script.phtml');
   ?>
另外，你可能希望在你的类中有类成员，类用来保持变形器目标是最新的 －
不需要每次直接更新目标 （这样节省调用方法）。 *setTargetReference()* 让你来做这个：

.. code-block::
   :linenos:
   <?php
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
   ?>
.. _zend.filter.inflector.rules:

变形规则
----

如在简介中所提到的，有两种类型的规则：静态的和基于过滤器的。

.. note::

   不论你添加规则给变形器的方法是一个接着一个还是一下子全部，顺序很重要。
   更具体的名字或可能包含其它规则名的名字必需在最不具体名之前添加。
   例如，假定令各规则名 'moduleDir' 和 'module'，'moduleDir' 规则应当在 'module' 之前出现，
   因为 'module' 包含在 'moduleDir' 中，如果 'module' 在 'moduleDir' 之前添加， 'module' 将匹配
   'moduleDir' 的一部分并且处理它把 'Dir' 留在在未变形的目标里。

.. _zend.filter.inflector.rules.static:

静态规则
^^^^

静态规则做简单的字符替换，当在静态目标里有片段，但你想让开发者修改的时候使用它们。
使用 *setStaticRule()* 方法来设置或修改规则：

.. code-block::
   :linenos:
   <?php
   $inflector = new Zend_Filter_Inflector(':script.:suffix');
   $inflector->setStaticRule('suffix', 'phtml');

   // change it later:
   $inflector->setStaticRule('suffix', 'php');
   ?>
很像目标自己，你也可以绑定静态规则到一个引用，让你来更新单个变量而不是请求一个方法调用。
当你的类在内部使用变形器，并且你不想让用户为更新而抓取变形器，这通常很有用，
*setStaticRuleReference()* 方法用来完成这个：

.. code-block::
   :linenos:
   <?php
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
   ?>
.. _zend.filter.inflector.rules.filters:

过滤变形器规则
^^^^^^^

*Zend_Filter*
过滤器也可以当作变形器来使用。像静态规则的一方面是可以绑定到目标变量；
不像静态规则一方面是当变形时你可以定义多重过滤器来用。
这些过滤器按顺序来处理，所以小心地按顺序来注册它们，这样对你接收到的数据有意义。

规则可以用 *setFilterRule()* 它重写任何以前这个变量的规则）或 *addFilterRule()*
（它在已存在的变量的规则上追加新规则）来添加。 过滤器用下列方法之一来指定：

- **String**. 字符串可以是过滤器的类名，或者一个类名段去掉任何
  在变形器的插件加载器里的前缀（缺省地，去掉 'Zend_Filter' 前缀）。

- **Filter object**. 任何实现 *Zend_Filter_Interface* 的对象实例可当作过滤器来传递。

- **Array**. 如上所定义的一个或多个字符串或过滤器对象数组。

.. code-block::
   :linenos:
   <?php
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
   ?>
.. _zend.filter.inflector.rules.multiple:

一次设置多个规则
^^^^^^^^

一般地，一次设置多个规则比每次配置一个单个的变量和它的变形器规则要容易。
*Zend_Filter_Inflector* 的 *addRules()* 和 *setRules()* 方法允许这样做。

每个方法带有一个变量/规则对的数组，这里规则是接受的任何规则（字符串、过滤器对象或数组）。
变量名接受一个特殊的符号来允许设置静态规则和过滤器规则，符号有：

- **':' 前缀**: 过滤器规则。

- **没有前缀**: 静态规则。

.. _zend.filter.inflector.rules.multiple.example:

.. rubric:: 一次设置多重规则

.. code-block::
   :linenos:
   <?php
   // Could also use setRules() with this notation:
   $inflector->addRules(array(
       // filter rules:
       ':controller' => array('CamelCaseToUnderscore','StringToLower'),
       ':action'     => array('CamelCaseToUnderscore','StringToLower'),

       // Static rule:
       'suffix'      => 'phtml'
   ));
   ?>
.. _zend.filter.inflector.utility:

实用方法
----

*Zend_Filter_Inflector*
有很多实用方法用来读取和设置插件加载器、处理和读取规则以及当有异常抛出时的控制。

- 当你配置了自己的插件加载器并希望它和 *Zend_Filter_Inflector*\ 一起使用， 可以使用
  *setPluginLoader()*\ ； *getPluginLoader()* 读取当前设置的一个。

- 当给定的替换识别器传递给它，并在目标中找不到， *setThrowTargetExceptionsOn()*
  可以用来控制 *filter()* 是否抛出一个异常。 缺省是没有异常抛出。
  *isThrowTargetExceptionsOn()* 将告诉你当前值是什么。

- *getRules($spec = null)*
  可用来读取所有注册的变量规则，或者仅仅是一个单个变量的规则。

- *getRule($spec, $index)* 根据给定的变量读取一个单个的规则；
  对于有过滤器链的变量读取特定的过滤器规则，这很有用。 必需传递 *$index*\ 。

- *clearRules()* 将清除所有当前注册的规则。

.. _zend.filter.inflector.config:

对 Zend_Filter_Inflector 使用 Zend_Config
--------------------------------------

你可以通过传递 *Zend_Config* 对象给构造器或 *setConfig()*\ 来使用 *Zend_Config*
设置规则、过滤器前缀路径和其它在你的变形器里的对象。 可以指定下列设置：

- *target* 指定变形目标。

- *filterPrefixPath* 指定一个或多个过滤器前缀/路径对给变形器的使用。

- *throwTargetExceptionsOn*
  是个布尔值，指示当替换识别器在变形后仍存在的时候是否抛出异常。

- *targetReplacementIdentifier* 当在目标字符串里识别替换变量时，指定字符来使用。

- *rules* 指定变形器规则数组；它应当包含指定值或值的数组的键，和 *addRules()* 一致。

.. _zend.filter.inflector.config.example:

.. rubric:: 使用 Zend_Config with Zend_Filter_Inflector

.. code-block::
   :linenos:
   <?php
   // With the constructor:
   $config    = new Zend_Config($options);
   $inflector = new Zend_Filter_Inflector($config);

   // Or with setConfig():
   $inflector = new Zend_Filter_Inflector();
   $inflector->setConfig($config);
   ?>

