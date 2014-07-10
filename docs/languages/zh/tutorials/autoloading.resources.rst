.. _learning.autoloading.resources:

Resource Autoloading
====================

通常，开发应用的时候，由于Zend Framework推荐的使类名和文件保持1:1对应的麻烦，或者为了便于组织的目的而不这样做。但是，这意味着autoloader不能找到你的类文件。

如果你读过了autoloader的 :ref:`设计目标<学习.自动加载.设计>` ，那一节的最后一点表明，该解决方案应包括这种情况。Zend Framework是通过 ``Zend\Loader\Autoloader\Resource``实现的。

资源只是一个对应于一个组件命名空间（附加到自动加载器的命名空间）的名称和路径（相对于自动加载器基路径的相对路径）。实际上，我们是这样做的：

.. code-block:: php
   :linenos:

   $loader = new Zend\Application\Module\Autoloader(array(
       'namespace' => 'Blog',
       'basePath'  => APPLICATION_PATH . '/modules/blog',
   ));

一旦你装载到位，你需要通知到各种资源类型。这些资源类型只是几对简单的目录树和前缀。

例如，下面的树状目录：

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

我们的第一步是创建资源加载器：

.. code-block:: php
   :linenos:

   $loader = new Zend\Loader\Autoloader\Resource(array(
       'basePath'  => 'path/to/some/resources/',
       'namespace' => 'Foo',
   ));

接着，我们需要定义一些资源类型。 ``Zend\Loader\Autoloader\Resource::addResourceType()`` 有三个参数：资源的“类型”（任意的字符串），
资源类型基路径下的路径，资源类型的组件前缀。在上面的树状目录，我们有三种资源类型：form (in the subdirectory "forms", with a component prefix of "Form"), model (in the subdirectory "models",
with a component prefix of "Model"), and dbtable (in the subdirectory "``models/DbTable``", with a component prefix
of "``Model_DbTable``")。我们对其进行如下定义：

.. code-block:: php
   :linenos:

   $loader->addResourceType('form', 'forms', 'Form')
          ->addResourceType('model', 'models', 'Model')
          ->addResourceType('dbtable', 'models/DbTable', 'Model_DbTable');

一旦被定义，我们就可以使用这些类了：

.. code-block:: php
   :linenos:

   $form      = new Foo_Form_Guestbook();
   $guestbook = new Foo_Model_Guestbook();

.. 注意::

   **自动加载资源模块**

   Zend Framework's *MVC* layer encourages the use of "modules", which are self-contained applications within your
   site. Modules typically have a number of resource types by default, and Zend Framework even :ref:`recommends a
   standard directory layout for modules <project-structure.filesystem>`. Resource autoloaders are therefore quite
   useful in this paradigm -- so useful that they are enabled by default when you create a bootstrap class for your
   module that extends ``Zend\Application\Module\Bootstrap``. For more information, read the
   :ref:`Zend\Loader\Autoloader\Module documentation <zend.loader.autoloader-resource.module>`.


