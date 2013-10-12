.. _learning.autoloading.resources:

Resource Autoloading
====================

Often, when developing an application, it's either difficult to package classes in the 1:1 classname:filename
standard Zend Framework recommends, or it's advantageous for purposes of packaging not to do so. However, this
means you class files will not be found by the autoloader.

If you read through :ref:`the design goals <learning.autoloading.design>` for the autoloader, the last point in
that section indicated that the solution should cover this situation. Zend Framework does so with
``Zend\Loader\Autoloader\Resource``.

A resource is just a name that corresponds to a component namespace (which is appended to the autoloader's
namespace) and a path (which is relative to the autoloader's base path). In action, you'd do something like this:

.. code-block:: php
   :linenos:

   $loader = new Zend\Application\Module\Autoloader(array(
       'namespace' => 'Blog',
       'basePath'  => APPLICATION_PATH . '/modules/blog',
   ));

Once you have the loader in place, you then need to inform it of the various resource types it's aware of. These
resource types are simply pairs of subtree and prefix.

As an example, consider the following tree:

.. code-block:: text
   :linenos:

   path/to/some/resources/
   |-- forms/
   |   `-- Guestbook.php        // Foo_Form_Guestbook
   |-- models/
   |   |-- DbTable/
   |   |   `-- Guestbook.php    // Foo_Model_DbTable_Guestbook
   |   |-- Guestbook.php        // Foo_Model_Guestbook
   |   `-- GuestbookMapper.php  // Foo_Model_GuestbookMapper

Our first step is creating the resource loader:

.. code-block:: php
   :linenos:

   $loader = new Zend\Loader\Autoloader\Resource(array(
       'basePath'  => 'path/to/some/resources/',
       'namespace' => 'Foo',
   ));

Next, we need to define some resource types. ``Zend\Loader\Autoloader\Resource::addResourceType()`` has three
arguments: the "type" of resource (an arbitrary string), the path under the base path in which the resource type
may be found, and the component prefix to use for the resource type. In the above tree, we have three resource
types: form (in the subdirectory "forms", with a component prefix of "Form"), model (in the subdirectory "models",
with a component prefix of "Model"), and dbtable (in the subdirectory "``models/DbTable``", with a component prefix
of "``Model_DbTable``"). We'd define them as follows:

.. code-block:: php
   :linenos:

   $loader->addResourceType('form', 'forms', 'Form')
          ->addResourceType('model', 'models', 'Model')
          ->addResourceType('dbtable', 'models/DbTable', 'Model_DbTable');

Once defined, we can simply use these classes:

.. code-block:: php
   :linenos:

   $form      = new Foo_Form_Guestbook();
   $guestbook = new Foo_Model_Guestbook();

.. note::

   **Module Resource Autoloading**

   Zend Framework's *MVC* layer encourages the use of "modules", which are self-contained applications within your
   site. Modules typically have a number of resource types by default, and Zend Framework even :ref:`recommends a
   standard directory layout for modules <project-structure.filesystem>`. Resource autoloaders are therefore quite
   useful in this paradigm -- so useful that they are enabled by default when you create a bootstrap class for your
   module that extends ``Zend\Application\Module\Bootstrap``. For more information, read the
   :ref:`Zend\Loader\Autoloader\Module documentation <zend.loader.autoloader-resource.module>`.


