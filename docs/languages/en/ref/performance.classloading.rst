.. _performance.classloading:

Class Loading
=============

Anyone who ever performs profiling of a Zend Framework application will immediately recognize that class loading is
relatively expensive in Zend Framework. Between the sheer number of class files that need to be loaded for many
components, to the use of plugins that do not have a 1:1 relationship between their class name and the file system,
the various calls to ``include_once()`` and ``require_once()`` can be problematic. This chapter intends to provide
some concrete solutions to these issues.

.. _performance.classloading.includepath:

How can I optimize my include_path?
-----------------------------------

One trivial optimization you can do to increase the speed of class loading is to pay careful attention to your
include_path. In particular, you should do four things: use absolute paths (or paths relative to absolute paths),
reduce the number of include paths you define, have your Zend Framework include_path as early as possible, and only
include the current directory path at the end of your include_path.

.. _performance.classloading.includepath.abspath:

Use absolute paths
^^^^^^^^^^^^^^^^^^

While this may seem a micro-optimization, the fact is that if you don't, you'll get very little benefit from
*PHP*'s realpath cache, and as a result, opcode caching will not perform nearly as you may expect.

There are two easy ways to ensure this. First, you can hardcode the paths in your ``php.ini``, ``httpd.conf``, or
``.htaccess``. Second, you can use *PHP*'s ``realpath()`` function when setting your include_path:

.. code-block:: php
   :linenos:

   $paths = array(
       realpath(dirname(__FILE__) . '/../library'),
       '.',
   );
   set_include_path(implode(PATH_SEPARATOR, $paths);

You **can** use relative paths -- so long as they are relative to an absolute path:

.. code-block:: php
   :linenos:

   define('APPLICATION_PATH', realpath(dirname(__FILE__)));
   $paths = array(
       APPLICATION_PATH . '/../library'),
       '.',
   );
   set_include_path(implode(PATH_SEPARATOR, $paths);

However, even so, it's typically a trivial task to simply pass the path to ``realpath()``.

.. _performance.classloading.includepath.reduce:

Reduce the number of include paths you define
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Include paths are scanned in the order in which they appear in the include_path. Obviously, this means that you'll
get a result faster if the file is found on the first scan rather than the last. Thus, a rather obvious enhancement
is to simply reduce the number of paths in your include_path to only what you need. Look through each include_path
you've defined, and determine if you actually have any functionality in that path that is used in your application;
if not, remove it.

Another optimization is to combine paths. For instance, Zend Framework follows *PEAR* naming conventions; thus, if
you are using *PEAR* libraries (or libraries from another framework or component library that follows *PEAR* CS),
try to put all of these libraries on the same include_path. This can often be achieved by something as simple as
symlinking one or more libraries into a common directory.

.. _performance.classloading.includepath.early:

Define your Zend Framework include_path as early as possible
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Continuing from the previous suggestion, another obvious optimization is to define your Zend Framework include_path
as early as possible in your include_path. In most cases, it should be the first path in the list. This ensures
that files included from Zend Framework are found on the first scan.

.. _performance.classloading.includepath.currentdir:

Define the current directory last, or not at all
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Most include_path examples show using the current directory, or '.'. This is convenient for ensuring that scripts
in the same directory as the file requiring them can be loaded. However, these same examples typically show this
path item as the first item in the include_path -- which means that the current directory tree is always scanned
first. In most cases, with Zend Framework applications, this is not desired, and the path may be safely pushed to
the last item in the list.

.. _performance.classloading.includepath.example:

.. rubric:: Example: Optimized include_path

Let's put all of these suggestions together. Our assumption will be that you are using one or more *PEAR* libraries
in conjunction with Zend Framework -- perhaps the PHPUnit and ``Archive_Tar`` libraries -- and that you
occasionally need to include files relative to the current file.

First, we'll create a library directory in our project. Inside that directory, we'll symlink our Zend Framework's
``library/Zend`` directory, as well as the necessary directories from our *PEAR* installation:

.. code-block:: php
   :linenos:

   library
       Archive/
       PEAR/
       PHPUnit/
       Zend/

This allows us to add our own library code if necessary, while keeping shared libraries intact.

Next, we'll opt to create our include_path programmatically within our ``public/index.php`` file. This allows us to
move our code around on the file system, without needing to edit the include_path every time.

We'll borrow ideas from each of the suggestions above: we'll use absolute paths, as determined using
``realpath()``; we'll include Zend Framework's include path early; we've already consolidated include_paths; and
we'll put the current directory as the last path. In fact, we're doing really well here -- we're going to end up
with only two paths.

.. code-block:: php
   :linenos:

   $paths = array(
       realpath(dirname(__FILE__) . '/../library'),
       '.'
   );
   set_include_path(implode(PATH_SEPARATOR, $paths));

.. _performance.classloading.striprequires:

How can I eliminate unnecessary require_once statements?
--------------------------------------------------------

Lazy loading is an optimization technique designed to push the expensive operation of loading a class file until
the last possible moment -- i.e., when instantiating an object of that class, calling a static class method, or
referencing a class constant or static property. *PHP* supports this via autoloading, which allows you to define
one or more callbacks to execute in order to map a class name to a file.

However, most benefits you may reap from autoloading are negated if your library code is still performing
``require_once()`` calls -- which is precisely the case with Zend Framework. So, the question is: how can you
eliminate those ``require_once()`` calls in order to maximize autoloader performance?

.. _performance.classloading.striprequires.sed:

Strip require_once calls with find and sed
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

An easy way to strip ``require_once()`` calls is to use the *UNIX* utilities 'find' and 'sed' in conjunction to
comment out each call. Try executing the following statements (where '%' indicates the shell prompt):

.. code-block:: console
   :linenos:

   % cd path/to/ZendFramework/library
   % find . -name '*.php' -not -wholename '*/Loader/Autoloader.php' \
     -not -wholename '*/Application.php' -print0 | \
     xargs -0 sed --regexp-extended --in-place 's/(require_once)/\/\/ \1/g'

This one-liner (broken into two lines for readability) iterates through each *PHP* file and tells it to replace
each instance of 'require_once' with '// require_once', effectively commenting out each such statement. (It
selectively keeps ``require_once()`` calls within ``Zend_Application`` and ``Zend\Loader\Autoloader``, as these
classes will fail without them.)

This command could be added to an automated build or release process trivially, helping boost performance in your
production application. It should be noted, however, that if you use this technique, you **must** utilize
autoloading; you can do that from your "``public/index.php``" file with the following code:

.. code-block:: php
   :linenos:

   require_once 'Zend/Loader/Autoloader.php';
   Zend\Loader\Autoloader::getInstance();

.. _performance.classloading.pluginloader:

How can I speed up plugin loading?
----------------------------------

Many components have plugins, which allow you to create your own classes to utilize with the component, as well as
to override existing, standard plugins shipped with Zend Framework. This provides important flexibility to the
framework, but at a price: plugin loading is a fairly expensive task.

The plugin loader allows you to register class prefix / path pairs, allowing you to specify class files in
non-standard paths. Each prefix can have multiple paths associated with it. Internally, the plugin loader loops
through each prefix, and then through each path attached to it, testing to see if the file exists and is readable
on that path. It then loads it, and tests to see that the class it is looking for is available. As you might
imagine, this can lead to many stat calls on the file system.

Multiply this by the number of components that use the PluginLoader, and you get an idea of the scope of this
issue. At the time of this writing, the following components made use of the PluginLoader:

- ``Zend\Controller_Action\HelperBroker``: helpers

- ``Zend\File\Transfer``: adapters

- ``Zend\Filter\Inflector``: filters (used by the ViewRenderer action helper and ``Zend_Layout``)

- ``Zend\Filter\Input``: filters and validators

- ``Zend_Form``: elements, validators, filters, decorators, captcha and file transfer adapters

- ``Zend_Paginator``: adapters

- ``Zend_View``: helpers, filters

How can you reduce the number of such calls made?

.. _performance.classloading.pluginloader.includefilecache:

Use the PluginLoader include file cache
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Zend Framework 1.7.0 adds an include file cache to the PluginLoader. This functionality writes "``include_once()``"
calls to a file, which you can then include in your bootstrap. While this introduces extra ``include_once()`` calls
to your code, it also ensures that the PluginLoader returns as early as possible.

The PluginLoader documentation :ref:`includes a complete example of its use
<zend.loader.pluginloader.performance.example>`.


