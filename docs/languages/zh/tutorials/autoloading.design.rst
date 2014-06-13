.. _learning.autoloading.design:

目标和构思
================

.. _learning.autoloading.design.naming:

类的命名约定
------------------------

要理解Zend Framework的autoloading，首先你得理解class names和class files之间的区别。

Zend Framework借鉴了 `PEAR`_ 的方法，即class names和class files保持1:1的对应关系。简而言之，即用下划线 ("\_") 作为目录分隔符，用 "``.php``" 放在末尾作为后缀。例如，在文件系统中，类 "``Foo_Bar_Baz``" 相当于 "``Foo/Bar/Baz.php``" 。类可以通过 *PHP* 的 ``include_path`` 设置， ``include_path`` 允许使用 ``include()`` 和 ``require()`` 两种方式，根据相对路径找到文件名。 另外，每个 *PEAR* 和 `PHP project`_，我们为或者推荐为vendor或project代码添加一个前缀。这样，你写的所有classes将公用一个class前缀；例如，Zend Framework的所有代码都有一个前缀 "Zend\_" 。这样的命名约定有助于防止命名冲突。在Zend Framework中，我们把它称作“命名空间”前缀；小心不要和 *PHP* 本身的命名空间混淆。

Zend Framework遵守这些简单的内部规则，建议您编写所有的类代码也遵循同样的规则。

.. _learning.autoloading.design.autoloader:

Autoloader 约定和构思
---------------------------------

Zend Framework支持autoloading，主要是通过 ``Zend\Loader\Autoloader`` ，有以下目标和构思元素：

- **支持命名空间匹配**。如果命名空间前缀没有注册，会立即返回 ``FALSE`` 。这样就可以更有弹性的匹配，也可以回滚到其他autoloaders。

- **允许autoloader作为fallback autoloader**。在团队广泛分布的情况下，或使用一组未确定的命名空间前缀，autoloader应该仍然是可配置的，它将尝试匹配任何命名空间前缀。但是注意，这种做法并不推荐，因为它可能会导致不必要的查找。

- **允许切换错误抑制**。我和伟大的 *PHP* 社区都认为错误抑制是个不好的主意。这样做的代价是很高的，这确实会给应用带来问题。所以，默认状态下，应该关闭它。但是，如果一个开发者 **坚持** 打开它，我们也允许这么做。

- **允许自动加载指定的自定义回调**。一些开发者不想用 ``Zend\Loader\Loader::loadClass()`` 自动加载，但是仍然想用 Zend Framework的机制。  ``Zend\Loader\Autoloader`` 允许自动加载指定的自定义回调。

- **允许SPL自动加载回调链的操作**。这样做的目的是允许指定其他自动加载机 -- 例如，没有1:1映射到文件系统的资源加载类，可以在Zend Framework自动加载之前或之后进行注册。


.. _`PEAR`: http://pear.php.net/
.. _`PHP project`: http://php.net/userlandnaming.tips
