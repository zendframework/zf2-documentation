.. _zend.config.theory_of_operation:

操作理论
====

配置数据在 *Zend_Config*\ 构造器通过关联数组(associative
arrary)可访问，为了支持从通用到特殊组织数据，它可以是多维的。具体的适配器类函数为
*Zend_Config*\
的构造器从存储到处理关联数组来适应配置数据。用户脚本可以直接提供这样的数组给
*Zend_Config*\ 构造器，不需要使用适配器类，因为它可以很好地工作在特定的情形下。

为了很容易简单地访问配置数据， *Zend_Config*\ 实现了 *Countable* 和 *Iterator*
接口。这样，可以基于 *Zend_Config*\ 对象使用 `count()`_\ 函数和PHP语句如 `foreach`_\ 。

缺省地，配置数据通过 *Zend_Config*\ 可用是只读的，并且赋值（例如，
*$config->database->host = 'example.com'*\
）导致抛出异常。这个缺省的行为可以通过构造器重载，然而，需要允许修改数据值。并且，当修改被允许时，
*Zend_Config*\ 支持未设定的值（例如 *unset($config->database->host);*\ ）。

   .. note::

      不要混淆如在内存中更改和保存配置数据到指定的存储媒体很重要。创建和更改配置数据给不同的存储媒体的工具超出了
      *Zend_Config*\
      的范围。为创建和更改配置数据给不同的存储媒体的第三方开源方案很容易实现。



适配器类从 *Zend_Config*\ 类继承，因为它们使用它的函数。

*Zend_Config*\ 函数家族把配置数据组织成节（section）。 *Zend_Config*\
适配器对象可以带一个指定的节加载，或者带有多个指定的节，或者所有节（如果没有指定）。

*Zend_Config*\
适配器类支持单继承模型，它允许配置数据从一个节到另一个节被继承，这是为了为不同目的而减少或消除复制配置数据而提供的。一个继承的节也可以重写从父节继承过来的值。象PHP类继承，一个节可以从一个父节继承，这个父节可能是从祖父节继承的，等等，但是多重继承（例如，节C直接从父节A和B继承）不被支持。

如果你有两个 *Zend_Config*\ 对象，你可以用 *merge()*\
函数把它们合并成一个单个的对象。例如，对 *$config*\ 和 *$localConfig*\ ，使用
*$config->merge($localConfig);*\ ，你可以把数据从 *$localConfig*\ 合并到 *$config*\ 。在
*$localConfig*\ 中的条目将覆盖在 *$config*\ 中同名的条目。



.. _`count()`: http://php.net/count
.. _`foreach`: http://php.net/foreach
