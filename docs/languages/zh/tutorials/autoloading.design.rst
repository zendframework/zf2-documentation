.. _learning.autoloading.design:

目标和规则
================

.. _learning.autoloading.design.naming:

类的命名约定
------------------------

要理解Zend Framework的autoloading，首先你得理解class names和class files之间的区别。

Zend Framework借鉴了 `PEAR`_ 的方法，即class names和class files保持1:1的对应关系。
简而言之，即用下划线 ("\_") 作为目录分隔符，用 "``.php``" 放在末尾作为后缀。
例如，在文件系统中，类 "``Foo_Bar_Baz``" 相当于 "``Foo/Bar/Baz.php``" 。
类可以通过 *PHP* 的 ``include_path`` 设置，
 ``include_path`` 允许使用 ``include()`` 和 ``require()`` 两种方式，根据相对路径找到文件名。
 另外，每个 *PEAR* 和 `PHP project`_，我们为或者推荐为vendor或project代码添加一个前缀。
 这样，你写的所有classes将公用一个class前缀；例如，Zend Framework的所有代码都有一个前缀 "Zend\_" 。
这样的命名约定有助于防止命名冲突。在Zend Framework中，我们把它称作“命名空间”前缀；
小心不要和 *PHP* 本身的命名空间混淆。
Zend Framework遵守这些简单的内部规则，建议您编写所有的类代码也遵循同样的规则。

.. _learning.autoloading.design.autoloader:

Autoloader Conventions and Design
---------------------------------

Zend Framework's autoloading support, provided primarily via ``Zend\Loader\Autoloader``, has the following goals
and design elements:

- **Provide namespace matching**. If the class namespace prefix is not in a list of registered namespaces, return
  ``FALSE`` immediately. This allows for more optimistic matching, as well as fallback to other autoloaders.

- **Allow the autoloader to act as a fallback autoloader**. In the case where a team may be widely distributed, or
  using an undetermined set of namespace prefixes, the autoloader should still be configurable such that it will
  attempt to match any namespace prefix. It will be noted, however, that this practice is not recommended, as it
  can lead to unnecessary lookups.

- **Allow toggling error suppression**. We feel -- and the greater *PHP* community does as well -- that error
  suppression is a bad idea. It's expensive, and it masks very real application problems. So, by default, it should
  be off. However, if a developer **insists** that it be on, we allow toggling it on.

- **Allow specifying custom callbacks for autoloading**. Some developers don't want to use
  ``Zend\Loader\Loader::loadClass()`` for autoloading, but still want to make use of Zend Framework's mechanisms.
  ``Zend\Loader\Autoloader`` allows specifying an alternate callback for autoloading.

- **Allow manipulation of the SPL autoload callback chain**. The purpose of this is to allow specifying additional
  autoloaders -- for instance, resource loaders for classes that don't have a 1:1 mapping to the filesystem -- to
  be registered before or after the primary Zend Framework autoloader.



.. _`PEAR`: http://pear.php.net/
.. _`PHP project`: http://php.net/userlandnaming.tips
