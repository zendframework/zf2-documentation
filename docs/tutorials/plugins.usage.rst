
Using Plugins
=============

Components that make use of plugins typically use ``Zend_Loader_PluginLoader`` to do their work. This class has you register plugins by specifying one or more "prefix paths". The component will then call the PluginLoader's ``load()`` method, passing the plugin's short name to it. The PluginLoader will then query each prefix path to see if a class matching that short name exists. Prefix paths are searched in LIFO (last in, first out) order, so it will match those prefix paths registered last first -- allowing you to override existing plugins.

Some examples will make all of this more clear.

.. note::
    **What happens if a plugin is not found?**

    What happens if a plugin is requested, but the PluginLoader is unable to find a class matching it? For instance, in the above example, if we registered the plugin "Bar" with the element, what would happen?

    The plugin loader will look through each prefix path, checking to see if a file matching the plugin name is found on that path. If the file is not found, it then moves on to the next prefix path.

    Once the stack of prefix paths has been exhausted, if no matching file has been found, it will throw aZend_Loader_PluginLoader_Exception.


