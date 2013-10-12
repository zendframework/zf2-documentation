.. _learning.plugins.usage:

Using Plugins
=============

Components that make use of plugins typically use ``Zend\Loader\PluginLoader`` to do their work. This class has you
register plugins by specifying one or more "prefix paths". The component will then call the PluginLoader's
``load()`` method, passing the plugin's short name to it. The PluginLoader will then query each prefix path to see
if a class matching that short name exists. Prefix paths are searched in LIFO (last in, first out) order, so it
will match those prefix paths registered last first -- allowing you to override existing plugins.

Some examples will make all of this more clear.

.. _learning.plugins.usage.basic:

.. rubric:: Basic Plugin Example: Adding a single prefix path

In this example, we will assume some validators have been written and placed in the directory
``foo/plugins/validators/``, and that all these classes share the class prefix "Foo_Validate\_"; these two bits of
information form our "prefix path". Furthermore, let's assume we have two validators, one named "Even" (ensuring a
number to be validated is even), and another named "Dozens" (ensuring the number is a multiple of 12). The tree
might look like this:

.. code-block:: text
   :linenos:

   foo/
   |-- plugins/
   |   |-- validators/
   |   |   |-- Even.php
   |   |   |-- Dozens.php

Now, we'll inform a ``Zend\Form\Element`` instance of this prefix path. ``Zend\Form\Element``'s ``addPrefixPath()``
method expects a third argument that indicates the type of plugin for which the path is being registered; in this
case, it's a "validate" plugin.

.. code-block:: php
   :linenos:

   $element->addPrefixPath('Foo_Validate', 'foo/plugins/validators/', 'validate');

Now we can simply tell the element the short name of the validators we want to use. In the following example, we're
using a mix of standard validators ("NotEmpty", "Int") and custom validators ("Even", "Dozens"):

.. code-block:: php
   :linenos:

   $element->addValidator('NotEmpty')
           ->addValidator('Int')
           ->addValidator('Even')
           ->addValidator('Dozens');

When the element needs to validate, it will then request the plugin class from the PluginLoader. The first two
validators will resolve to ``Zend\Validate\NotEmpty`` and ``Zend\Validate\Int``, respectively; the next two will
resolve to ``Foo_Validate_Even`` and ``Foo_Validate_Dozens``, respectively.

.. note::

   **What happens if a plugin is not found?**

   What happens if a plugin is requested, but the PluginLoader is unable to find a class matching it? For instance,
   in the above example, if we registered the plugin "Bar" with the element, what would happen?

   The plugin loader will look through each prefix path, checking to see if a file matching the plugin name is
   found on that path. If the file is not found, it then moves on to the next prefix path.

   Once the stack of prefix paths has been exhausted, if no matching file has been found, it will throw a
   ``Zend\Loader\PluginLoader\Exception``.

.. _learning.plugins.usage.override:

.. rubric:: Intermediate Plugin Usage: Overriding existing plugins

One strength of the PluginLoader is that its use of a LIFO stack allows you to override existing plugins by
creating your own versions locally with a different prefix path, and registering that prefix path later in the
stack.

For example, let's consider ``Zend\View\Helper\FormButton`` (view helpers are one form of plugin). This view helper
accepts three arguments, an element name (also used as the element's DOM identifier), a value (used as the button
label), and an optional array of attributes. The helper then generates *HTML* markup for a form input element.

Let's say you want the helper to instead generate a true *HTML* ``button`` element; don't want the helper to
generate a DOM identifier, but instead use the value for a CSS class selector; and that you have no interest in
handling arbitrary attributes. You could accomplish this in a couple of ways. In both cases, you'd create your own
view helper class that implements the behavior you want; the difference is in how you would name and invoke them.

Our first example will be to name the element with a unique name: ``Foo_View_Helper_CssButton``, which implies the
plugin name "CssButton". While this certainly is a viable approach, it poses several issues: if you've already used
the Button view helper in your code, you now have to refactor; alternately, if another developer starts writing
code for your application, they may inadvertently use the Button view helper instead of your new view helper.

So, the better example is to use the plugin name "Button", giving us the class name ``Foo_View_Helper_Button``. We
then register the prefix path with the view:

.. code-block:: php
   :linenos:

   // Zend\View\View::addHelperPath() utilizes the PluginLoader; however, it inverts
   // the arguments, as it provides a default value of "Zend\View\Helper" for the
   // plugin prefix.
   //
   // The below assumes your class is in the directory 'foo/view/helpers/'.
   $view->addHelperPath('foo/view/helpers', 'Foo_View_Helper');

Once done, anywhere you now use the "Button" helper will delegate to your custom ``Foo_View_Helper_Button`` class!


