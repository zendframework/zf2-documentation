.. _learning.autoloading.design:

Goals and Design
================

.. _learning.autoloading.design.naming:

Class Naming Conventions
------------------------

To understand autoloading in Zend Framework, first you need to understand the relationship between class names and
class files.

Zend Framework has borrowed an idea from `PEAR`_, whereby class names have a 1:1 relationship with the filesystem.
Simply put, the underscore character ("\_") is replaced by a directory separator in order to resolve the path to
the file, and then the suffix "``.php``" is added. For example, the class "``Foo_Bar_Baz``" would correspond to
"``Foo/Bar/Baz.php``" on the filesystem. The assumption is also that the classes may be resolved via *PHP*'s
``include_path`` setting, which allows both ``include()`` and ``require()`` to find the filename via a relative
path lookup on the ``include_path``.

Additionally, per *PEAR* as well as the `PHP project`_, we use and recommend using a vendor or project prefix for
your code. What this means is that all classes you write will share a common class prefix; for example, all code in
Zend Framework has the prefix "Zend\_". This naming convention helps prevent naming collisions. Within Zend
Framework, we often refer to this as the "namespace" prefix; be careful not to confuse it with *PHP*'s native
namespace implementation.

Zend Framework follows these simple rules internally, and our coding standards encourage that you do so as well for
all library code.

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
