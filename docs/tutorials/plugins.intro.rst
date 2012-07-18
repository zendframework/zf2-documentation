.. _learning.plugins.intro:

Introduction
============

Zend Framework makes heavy use of plugin architectures. Plugins allow for easy extensibility and customization of the framework while keeping your code separate from Zend Framework's code.

Typically, plugins in Zend Framework work as follows:

- Plugins are classes. The actual class definition will vary based on the component -- you may need to extend an abstract class or implement an interface, but the fact remains that the plugin is itself a class.

- Related plugins will share a common class prefix. For instance, if you have created a number of view helpers, they might all share the class prefix "``Foo_View_Helper_``".

- Everything after the common prefix will be considered the **plugin name** or **short name** (versus the "long name", which is the full classname). For example, if the plugin prefix is "``Foo_View_Helper_``", and the class name is "``Foo_View_Helper_Bar``", the plugin name will be simply "``Bar``".

- Plugin names are typically case sensitive. The one caveat is that the initial letter can often be either lower or uppercase; in our previous example, both "bar" and "Bar" would refer to the same plugin.

Now let's turn to using plugins.


