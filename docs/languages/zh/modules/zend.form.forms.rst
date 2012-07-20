.. _zend.form.forms:

使用 Zend_Form 生成表单
=================

*Zend_Form* 类用来聚合表单元素，显示组和子表单。它可以在这些条目中执行下列动作：

- 校验，包括读取错误代码和消息

- 值聚合，包括组装（populating）条目和从所有条目读取过滤的和未过滤的值

- 迭代所有条目，按它们键入的顺序或者从每个条目中读取的顺序提示来进行

- 解析（rendering）整个表单，通过执行定制解析的单个装饰器（decorator）或者迭代（iterating）表单中的所有条目

虽然由 *Zend_Form*
生成的表单可能复杂，可能最好的用法是做简单的表单，但是对于快速程序开发和生成原型（prototyping），它是最好的。

最基本的事情是实例化一个表单对象：

.. code-block::
   :linenos:
   <?php
   // Generic form object:
   $form = new Zend_Form();

   // Custom form object:
   $form = new My_Form()
   ?>
你可以可选地传递配置参数，它用来设置对象状态以及可能生成新元素：

.. code-block::
   :linenos:
   <?php
   // Passing in configuration options:
   $form = new Zend_Form($config);
   ?>
*Zend_Form*
是可迭代的（iterable），它将按照它们注册的顺序和任何拥有的索引迭代所有元素、显示组和子表单。当你想手动地按适当的顺序解析（render）元素的时候，这个很有用。

*Zend_Form* 的魔法在于它能够为元素和显示组提供工厂服务（serve as a
factory），并且通过装饰器来解析（render）自己。

.. _zend.form.forms.plugins:

插件加载器
-----

*Zend_Form* 利用 *Zend_Loader_PluginLoader*
使开发者指定替代元素和装饰器的位置。每个表单有和它一起伴随的插件加载器，总访问器用来读取和修改每个表单。

下列加载器类型和不同的插件加载器方法 'element' 和 'decorator'
一起来使用。类型名大小写敏感。

用来和插件加载器结合使用的方法如下：

- *setPluginLoader($loader, $type)*: $loader 是插件加载器对象自己，type
  是上述的类型之一。该方法为给定的类型设置插件加载器为新指定的加载器对象。

- *getPluginLoader($type)*: 按类型（$type）来获取插件加载器。

- *addPrefixPath($prefix, $path, $type = null)*: 添加一个 prefix/path 结合对给由 $type
  指定的加载器。如果 $type 是 null，通过追加前缀给 "\_Element" 和
  "\_Decorator"，它将尝试添加路径给所有的加载器，并用 "Element/" 和 "Decorator/"
  追加路径。如果在通用的等级下有所有额外的表单元素类，这是个很方便的给它们设置基础前缀的方法。

- *addPrefixPaths(array $spec)*:
  允许一次性添加多个路径给一个或多个插件加载器。它需要每个数组元素（item）是一个带有'path'、'prefix'和'type'键的数组。

另外，也可以用下列方法为所有通过 *Zend_Form*\ 实例生成元素和显示组指定前缀路径：

- *addElementPrefixPath($prefix, $path, $type = null)*: 就象 *addPrefixPath()*
  一样，必需指定一个类的前缀和路径。当指定 *$type*\ ，必需是由 *Zend_Form_Element*
  指定的插件加载器类型之一，更多关于有效 *$type*\ 值的信息参见 :ref:`element plugins
  section <zend.form.elements.loaders>`\ 。如果没有指定 *$type*\
  ，该方法假定它是一个用于所有类型的总的前缀。

- *addDisplayGroupPrefixPath($prefix, $path)*: 就象 *addPrefixPath()*
  一样，必需指定一个类的前缀和路径，然而，显示组只支持装饰器作为插件， *$type*
  不是必需的。

定制元素和装饰器是在表单和封装定制函数之间共享功能的简便方法。在元素文档（elements
documentation）中参见 :ref:`Custom Label example <zend.form.elements.loaders.customLabel>`
，看定制元素如何用来替换标准类。

.. _zend.form.forms.elements:

元素（Elements）
------------

*Zend_Form*
提供了若干访问器用来从表单中添加和删除元素。这些可以获得元素对象实例或以工厂模式来为实例化元素对象自己服务。

添加元素的最基本的方法是 *addElement()*\ 。该方法可以或者带有 *Zend_Form_Element*
（或者继承 *Zend_Form_Element* 的类 ）类型对象的参数，或者用于建立新元素的参数 －
包括元素类型、名称和任何配置选项。

如一些例子：

.. code-block::
   :linenos:
   <?php
   // Using an element instance:
   $element = new Zend_Form_Element_Text('foo');
   $form->addElement($element);

   // Using a factory
   //
   // Creates an element of type Zend_Form_Element_Text with the
   // name of 'foo':
   $form->addElement('text', 'foo');

   // Pass label option to the element:
   $form->addElement('text', 'foo', array('label' => 'Foo:'));
   ?>
.. note::

   **addElement() 实现 Fluent Interface**

   *addElement()* 实现一个 fluent interface，就是说，它返回 *Zend_Form*
   对象，而不是元素。这样做来允许你把多个 addElement()方法或者其它实现 fluent interface
   的表单方法链接起来（所有 Zend_Form 中的设置器（ setters） 都实现这个模式）。

   如果你想返回元素，使用 *createElement()*\ ，下面是要点。然而请注意， *createElement()*
   不把元素加到表单上。

   在内部， *addElement()* 实际上用 *createElement()* 来生成元素之后把它加到表单上。

一旦元素被添加到表单，可以用名字来读取。通过使用 *getElement()*
方法或者通过重载（overloading）使元素作为对象属性来访问：

.. code-block::
   :linenos:
   <?php
   // getElement():
   $foo = $form->getElement('foo');

   // As object property:
   $foo = $form->foo;
   ?>
偶尔地，你只想生成一个元素并不想把它加到表单上（例如，你想利用众多的用表单注册的插件路径，但稍后把这些对象加到子表单上）。
*createElement()* 方法可以完成这些：

.. code-block::
   :linenos:
   <?php
   // $username becomes a Zend_Form_Element_Text object:
   $username = $form->createElement('text', 'username');
   ?>
.. _zend.form.forms.elements.values:

组装和读取数值
^^^^^^^

校验表单之后，你一般需要读取它的数值以便执行其它操作，如更新数据库或通知一个
web 服务。你可以通过 *getValues()* 来读取所有元素的值， *getValue($name)*
可以通过名字来读取一个单个的值：

.. code-block::
   :linenos:
   <?php
   // Get all values:
   $values = $form->getValues();

   // Get only 'foo' element's value:
   $value = $form->getValue('foo');
   ?>
有时候，在解析之前，你想用特定的值来组装表单，可以通过 *setDefaults()* 或 *populate()*
方法来完成：

.. code-block::
   :linenos:
   <?php
   $form->setDefaults($data);
   $form->populate($data);
   ?>
在另一面，你可能想在组装和校验之前清除一个表单，可使用 *reset()* 方法来完成：

.. code-block::
   :linenos:

   $form->reset();

.. _zend.form.forms.elements.global:

全局操作
^^^^

偶尔，你想用对所有元素进行特定的操作，一般的情形包括需要为所有元素设置插件前缀路径、装饰器和过滤器，如下例：

.. _zend.form.forms.elements.global.allpaths:

.. rubric:: 为所有元素设置前缀路径

可以通过类型来为所有的元素设置前缀路径，或者使用全局前缀，如这些例子：

.. code-block::
   :linenos:
   <?php
   // Set global prefix path:
   // Creates paths for prefixes My_Foo_Filter, My_Foo_Validate,
   // and My_Foo_Decorator
   $form->addElementPrefixPath('My_Foo', 'My/Foo/');

   // Just filter paths:
   $form->addElementPrefixPath('My_Foo_Filter', 'My/Foo/Filter', 'filter');

   // Just validator paths:
   $form->addElementPrefixPath('My_Foo_Validate', 'My/Foo/Validate', 'validate');

   // Just decorator paths:
   $form->addElementPrefixPath('My_Foo_Decorator', 'My/Foo/Decorator', 'decorator');
   ?>
.. _zend.form.forms.elements.global.decorators:

.. rubric:: 为所有元素设置装饰器（Decorators）

你可以为所有元素设置装饰器。 *setElementDecorators()* 接受一个装饰器数组， 就象
*setDecorators()*
一样，并对每个元素重写（overwrite）先前设置的装饰器。在本例中，我们为 ViewHelper
和一个 Label 设置装饰器：

.. code-block::
   :linenos:
   <?php
   $form->setElementDecorators(array(
       'ViewHelper',
       'Label'
   ));
   ?>
.. _zend.form.forms.elements.global.decoratorsFilter:

.. rubric:: 为某些元素设置装饰器

你也可以对一个元素的子集设置装饰器，包含和排除都可以。 *setElementDecorators()*
的第二个参数可以是元素名数组；
缺省地，指定这样一个数组将只对这些元素设置指定的装饰器。
你也可以传递第三个参数，用来指示是包含还是排除这个元素列表的标志。 如果是
false，它将装饰 **除了** 这些在列表中的元素 **之外**
的所有元素。使用方法的标准用法，在每个元素中，任何传递的装饰器将覆盖任何先前设置的装饰器。

在下面的片段中，我们只对 'foo' 和 'bar' 元素使用视图助手和标签装饰器：

.. code-block::
   :linenos:

   $form->setElementDecorators(
       array(
           'ViewHelper',
           'Label'
       ),
       array(
           'foo',
           'bar'
       )
   );

另一方面，在这个片段中，我们对 **除了**'foo' 元素 'bar'**之外**\
的所以元素使用视图助手和标签装饰器：

.. code-block::
   :linenos:

   $form->setElementDecorators(
       array(
           'ViewHelper',
           'Label'
       ),
       array(
           'foo',
           'bar'
       ),
       false
   );

.. note::

   **有些装饰器不适合某些元素**

   虽然 *setElementDecorators()*
   可能是个好方案，但有时候不会得到所期望的结果。例如，各种各样的按钮元素（Submit,
   Button, Reset）。当前使用标签（label）作为按钮（button）的值（value），并只使用
   ViewHelper 和 DtDdWrapper 装饰器 －－
   防止解析另外的标签、错误、和提示，上述例子可能重复（duplicate）一些内容（标签）。

   你可以使用 包含/排除 数组来克服在前面例子中所述的问题。

   所以，要灵活使用这个方法，你需要排除或手工修改一些元素的装饰器来防止不希望的输出。

.. _zend.form.forms.elements.global.filters:

.. rubric:: 为所有元素设置过滤器

大多数情况下，你想对所有元素应用同一个过滤器，一个通常的用法是 *修整（trim()）*
所有的值：

.. code-block::
   :linenos:
   <?php
   $form->setElementFilters(array('StringTrim'));
   ?>
.. _zend.form.forms.elements.methods:

和元素交互使用的方法
^^^^^^^^^^

下面的方法用来和元素交互使用：

- *createElement($element, $name = null, $options = null)*

- *addElement($element, $name = null, $options = null)*

- *addElements(array $elements)*

- *setElements(array $elements)*

- *getElement($name)*

- *getElements()*

- *removeElement($name)*

- *clearElements()*

- *setDefaults(array $defaults)*

- *setDefault($name, $value)*

- *getValue($name)*

- *getValues()*

- *getUnfilteredValue($name)*

- *getUnfilteredValues()*

- *setElementFilters(array $filters)*

- *setElementDecorators(array $decorators)*

- *addElementPrefixPath($prefix, $path, $type = null)*

- *addElementPrefixPaths(array $spec)*

.. _zend.form.forms.displaygroups:

显示组（Display Groups）
-------------------

显示组是生成要显示的虚拟元素组的一种方法。所有元素在表单中保持用名字可访问，但是当迭代或解析（rendering）所有表单的时候，任何在显示组中的元素将被一起解析（rendered）。最普通的用例是把（数据库表中的）字段组成一组元素。

显示组的基本类是 *Zend_Form_DisplayGroup*\ 。虽然它可以直接实例化，但是一般最好是用
*Zend_Form* 的 *addDisplayGroup()*
方法来做。该方法带有一个元素数组作为第一个参数，和一个显示组的名称作为第二个参数。也可以传递一个选项数组或
*Zend_Config* 对象作为第三个参数。

假定元素 'username' 和 'password'已经在表单中，下面的代码将把它们组成一个
'login'显示组：

.. code-block::
   :linenos:
   <?php
   $form->addDisplayGroup(array('username', 'password'), 'login');
   ?>
你可以用 *getDisplayGroup()* 方法来访问显示组，或用显示组的名称来重载（overloading）：

.. code-block::
   :linenos:
   <?php
   // Using getDisplayGroup():
   $login = $form->getDisplayGroup('login');

   // Using overloading:
   $login = $form->login;
   ?>
.. note::

   **不需要加载缺省的装饰器**

   缺省地，缺省的装饰器在对象初始化过程中加载。你可以在生成显示组的时候通过传递
   'disableLoadDefaultDecorators' 选项来关闭（disable）它。

   .. code-block::
      :linenos:
      <?php
      $form->addDisplayGroup(
          array('foo', 'bar'),
          'foobar',
          array('disableLoadDefaultDecorators' => true)
      );

   该选项可以和其它选项混合，它们都是数组或者 *Zend_Config* 对象。

.. _zend.form.forms.displaygroups.global:

全局操作
^^^^

就像对元素一样，一些操作可能影响所有的显示组，包括设置装饰器和寻找装饰器的插件路径。

.. _zend.form.forms.displaygroups.global.paths:

.. rubric:: 为所有的显示组设置装饰器前缀路径

缺省地，显示组继承表单所使用的任何一个装饰器的路径，然而，如果它们在另外的位置，可以使用这个方法：
*addDisplayGroupPrefixPath()*\ 。

.. code-block::
   :linenos:
   <?php
   $form->addDisplayGroupPrefixPath('My_Foo_Decorator', 'My/Foo/Decorator');
   ?>
.. _zend.form.forms.displaygroups.global.decorators:

.. rubric:: 为所有显示组设置装饰器

你可以为所有的显示组设置装饰器。 *setDisplayGroupDecorators()* 接受一个装饰器数组，就像
*setDecorators()*
一样，并将在每个显示组重写（overwrite）先前设置的装饰器。在这个例子中，我们给字段（为确保元素被迭代，FormElements
装饰器是必需的）设置装饰器：

.. code-block::
   :linenos:
   <?php
   $form->setDisplayGroupDecorators(array(
       'FormElements',
       'Fieldset'
   ));
   ?>
.. _zend.form.forms.displaygroups.customClasses:

使用定制的显示组类
^^^^^^^^^

缺省地， *Zend_Form* 为显示组使用 *Zend_Form_DisplayGroup*
类，你可能需要继承这个类来提供定制的功能。 *addDisplayGroup()*
不允许传递一个具体的实例，但确实允许用 'displayGroupClass'
键来指定一个类来作为它的一个选项：

.. code-block::
   :linenos:
   <?php
   // Use the 'My_DisplayGroup' class
   $form->addDisplayGroup(
       array('username', 'password'),
       'user',
       array('displayGroupClass' => 'My_DisplayGroup')
   );
   ?>
如果类没有加载， *Zend_Form* 将用 *Zend_Loader* 来加载。

你也可以指定一个缺省的显示组类来和表单一起使用，这样所有用这个表单对象生成的显示组将使用那个类：

.. code-block::
   :linenos:
   <?php
   // Use the 'My_DisplayGroup' class for all display groups:
   $form->setDefaultDisplayGroupClass('My_DisplayGroup');
   ?>
这个设置可能在配置中指定为
'defaultDisplayGroupClass'，并在早期加载以确保所有的显示组使用那个类。

.. _zend.form.forms.displaygroups.interactionmethods:

和显示组交互使用的方法
^^^^^^^^^^^

下列方法用来和显示组一起交互使用：

- *addDisplayGroup(array $elements, $name, $options = null)*

- *addDisplayGroups(array $groups)*

- *setDisplayGroups(array $groups)*

- *getDisplayGroup($name)*

- *getDisplayGroups()*

- *removeDisplayGroup($name)*

- *clearDisplayGroups()*

- *setDisplayGroupDecorators(array $decorators)*

- *addDisplayGroupPrefixPath($prefix, $path)*

- *setDefaultDisplayGroupClass($class)*

- *getDefaultDisplayGroupClass($class)*

.. _zend.form.forms.displaygroups.methods:

Zend_Form_DisplayGroup 方法
^^^^^^^^^^^^^^^^^^^^^^^^^

*Zend_Form_DisplayGroup* 有下列方法，以类来分组：

- Configuration:

  - *setOptions(array $options)*

  - *setConfig(Zend_Config $config)*

- Metadata:

  - *setAttrib($key, $value)*

  - *addAttribs(array $attribs)*

  - *setAttribs(array $attribs)*

  - *getAttrib($key)*

  - *getAttribs()*

  - *removeAttrib($key)*

  - *clearAttribs()*

  - *setName($name)*

  - *getName()*

  - *setDescription($value)*

  - *getDescription()*

  - *setLegend($legend)*

  - *getLegend()*

  - *setOrder($order)*

  - *getOrder()*

- Elements:

  - *createElement($type, $name, array $options = array())*

  - *addElement($typeOrElement, $name, array $options = array())*

  - *addElements(array $elements)*

  - *setElements(array $elements)*

  - *getElement($name)*

  - *getElements()*

  - *removeElement($name)*

  - *clearElements()*

- Plugin loaders:

  - *setPluginLoader(Zend_Loader_PluginLoader $loader)*

  - *getPluginLoader()*

  - *addPrefixPath($prefix, $path)*

  - *addPrefixPaths(array $spec)*

- Decorators:

  - *addDecorator($decorator, $options = null)*

  - *addDecorators(array $decorators)*

  - *setDecorators(array $decorators)*

  - *getDecorator($name)*

  - *getDecorators()*

  - *removeDecorator($name)*

  - *clearDecorators()*

- Rendering:

  - *setView(Zend_View_Interface $view = null)*

  - *getView()*

  - *render(Zend_View_Interface $view = null)*

- I18n:

  - *setTranslator(Zend_Translator_Adapter $translator = null)*

  - *getTranslator()*

  - *setDisableTranslator($flag)*

  - *translatorIsDisabled()*

.. _zend.form.forms.subforms:

子表单
---

子表单服务于如干目的：

- 生成逻辑元素组。因为子表单只是个表单，你可以把它当作独立的实体来校验。

- 生成多页表单。因为子表单只是个表单，你可以在每页上显示一个子表单，建立每个子表单都有自己的校验逻辑的多页表单。只有一旦所有的子表单校验了，整个表单才算完整。

- 成组地显示。像显示组一样，当子表单作为大表单的一部分解析，可以被用做组元素。然而要小心，主表单对象不知道子表单中的元素。

子表单可以是 *Zend_Form* 对象，或者更一般地是 *Zend_Form_SubForm*
对象。后者包含适合包含在大表单（例如，它不解析另外的 HTML
表单标签，但解析组元素）里的装饰器。为了加上子表单，简单地把它添加到一个表单并给出名字：

.. code-block::
   :linenos:
   <?php
   $form->addSubForm($subForm, 'subform');
   ?>
可以用 *getSubForm($name)* 或用子表单名重载（overloading）它来读取子表单：

.. code-block::
   :linenos:
   <?php
   // Using getSubForm():
   $subForm = $form->getSubForm('subform');

   // Using overloading:
   $subForm = $form->subform;
   ?>
虽然子表单包含的元素不包含在表单迭代中，但子表单包含在其中。

.. _zend.form.forms.subforms.global:

全局操作
^^^^

像元素和显示组一样，有些操作可以影响所有的子表单。然而不像显示组和元素，子表单从主表单对象继承了最多的功能，并且唯一的需要全局执行的操作是为子表单设置装饰器，
*setSubFormDecorators()*
方法来完成此任务。在下一个例子中，我们将为所有作为字段（为确保迭代它的元素，FormElements
装饰器是必需的）的子表单设置装饰器：

.. code-block::
   :linenos:
   <?php
   $form->setSubFormDecorators(array(
       'FormElements',
       'Fieldset'
   ));
   ?>
.. _zend.form.forms.subforms.methods:

和子表单交互使用的方法
^^^^^^^^^^^

下列方法用来和子表单交互使用：

- *addSubForm(Zend_Form $form, $name, $order = null)*

- *addSubForms(array $subForms)*

- *setSubForms(array $subForms)*

- *getSubForm($name)*

- *getSubForms()*

- *removeSubForm($name)*

- *clearSubForms()*

- *setSubFormDecorators(array $decorators)*

.. _zend.form.forms.metadata:

元数据（Metadata）和属性（Attributes）
----------------------------

虽然表单的有效性基本源于它所包含的元素，但它也可以包含其它元数据，如名称（在
HTML 标记语言中经常用作唯一的
ID）、表单动作和方法、许多元素、组、它所包含的子表单和属性元数据（通常用做为表单标签自己设置
HTML 属性）。

可以使用名字访问器来设置和读取表单的名字：

.. code-block::
   :linenos:
   <?php
   // Set the name:
   $form->setName('registration');

   // Retrieve the name:
   $name = $form->getName();
   ?>
为了设置动作（到表单提交的 url ）和方法（提交的方法如 'POST' 或
'GET'），使用动作和方法访问器：

.. code-block::
   :linenos:
   <?php
   // Set the action and method:
   $form->setAction('/user/login')
        ->setMethod('post');
   ?>
你也可以指定特别使用 enctype 访问器的表单编码类型。 Zend_Form 定义了两个常量，
*Zend_Form::ENCTYPE_URLENCODED* 和 *Zend_Form::ENCTYPE_MULTIPART*\ ，分别对应值为
'application/x-www-form-urlencoded' 和 'multipart/form-data'；
然而，你可以把它设置为任意的编码类型。

.. code-block::
   :linenos:
   <?php
   // Set the action, method, and enctype:
   $form->setAction('/user/login')
        ->setMethod('post')
        ->setEnctype(Zend_Form::ENCTYPE_MULTIPART);
   ?>
.. note::

   方法、动作和 enctype 只用来内部解析，不用于任何校验。

*Zend_Form* 实现 *Countable* 接口，允许把它当作参数传递给计数器（count）：

.. code-block::
   :linenos:
   <?php
   $numItems = count($form);
   ?>
设置任意元数据可通过属性访问器来完成。因为在 *Zend_Form*
中重载用于访问元素、显示组和子表单，这是唯一的访问元数据的方法。

.. code-block::
   :linenos:
   <?php
   // Setting attributes:
   $form->setAttrib('class', 'zend-form')
        ->addAttribs(array(
            'id'       => 'registration',
            'onSubmit' => 'validate(this)',
        ));

   // Retrieving attributes:
   $class = $form->getAttrib('class');
   $attribs = $form->getAttribs();

   // Remove an attribute:
   $form->removeAttrib('onSubmit');

   // Clear all attributes:
   $form->clearAttribs();
   ?>
.. _zend.form.forms.decorators:

装饰器
---

为表单生成 markup 通常是一件耗时的任务，特别是如果打算重复使用同一个 markup
来显示校验错误、提交的值等。 *Zend_Form* 的解决办法是 **装饰器（decorators）**\ 。

*Zend_Form* 对象的装饰器可用来解析表单。FormElements 装饰器将迭代所有在表单中的条目
－－元素、显示组、子表单
－－并解析它们和返回结果。另外，装饰器可以用来封装内容、或追加、或预先准备它。

*Zend_Form* 的缺省装饰器是 FormElements，HtmlTag（ 封装在定义列表 ）和
Form，生成它们的等同的代码如下：

.. code-block::
   :linenos:
   <?php
   $form->setDecorators(array(
       'FormElements',
       array('HtmlTag', array('tag' => 'dl')),
       'Form'
   ));
   ?>
生成输出如下：

.. code-block::
   :linenos:

   <form action="/form/action" method="post">
   <dl>
   ...
   </dl>
   </form>

在表单对象中的任何属性设置将用做 *<form>* 标签的 HTML 属性。

.. note::

   **不需要加载缺省的装饰器**

   缺省地，缺省的装饰器在对象初始化过程中加载。可通过传递 'disableLoadDefaultDecorators'
   选项给构造器来关闭（disable）它：

   .. code-block::
      :linenos:
      <?php
      $form = new Zend_Form(array('disableLoadDefaultDecorators' => true));

   该选项可以和其它任何选项混合，它们都是数组或在一个 *Zend_Config* 对象里。

.. note::

   **使用同类型的多个装饰器**

   在内部，当读取装饰器时， *Zend_Form*
   使用装饰器的类做为查找机制。结果，可以注册同类型的多个装饰器，后来的装饰器将重些以前的（装饰器）。

   To get around this,可以使用别名。不用传递装饰器或装饰器名称为第一个参数给
   *addDecorator()*\
   ，而是传递一个带有单个元素的、带有指向装饰器对象或名字的别名的数组：

   .. code-block::
      :linenos:
      <?php
      // Alias to 'FooBar':
      $form->addDecorator(array('FooBar' => 'HtmlTag'), array('tag' => 'div'));

      // And retrieve later:
      $form = $element->getDecorator('FooBar');
      ?>
   在 *addDecorators()* 和 *setDecorators()* 方法中，需要传递在表示装饰器的数组中的
   'decorator' 选项：

   .. code-block::
      :linenos:
      <?php
      // Add two 'HtmlTag' decorators, aliasing one to 'FooBar':
      $form->addDecorators(
          array('HtmlTag', array('tag' => 'div')),
          array(
              'decorator' => array('FooBar' => 'HtmlTag'),
              'options' => array('tag' => 'dd')
          ),
      );

      // And retrieve later:
      $htmlTag = $form->getDecorator('HtmlTag');
      $fooBar  = $form->getDecorator('FooBar');
      ?>
为生成表单，你可以生成自己的装饰器。一个通常的用例是如果你知道额外的你想用的
HTML，你的装饰器可以潜在地使用从独立的元素或显示组来的装饰器生成额外的 HTML
并返回它。

下列方法可以用来和装饰器交互使用：

- *addDecorator($decorator, $options = null)*

- *addDecorators(array $decorators)*

- *setDecorators(array $decorators)*

- *getDecorator($name)*

- *getDecorators()*

- *removeDecorator($name)*

- *clearDecorators()*

.. _zend.form.forms.validation:

校验
--

表单的一个基本用例是校验提交的数据。 *Zend_Form*
让你一次性校验整个表单或部分表单，还有对 XmlHttpRequests
(AJAX)的自动校验响应。如果提交的数据无效，它有一些方法用来为元素和子表单校验失败而读取各种各样的错误代码和消息。

为了校验整个表单，使用 *isValid()* 方法：

.. code-block::
   :linenos:
   <?php
   if (!$form->isValid($_POST)) {
       // failed validation
   }
   ?>
*isValid()* 校验每个必需的元素和任何包括在提交的数据中的非必需的元素。

有时候你可能只需要校验数据的一个子集，可以使用 *isValidPartial($data)*\ ：

.. code-block::
   :linenos:
   <?php
   if (!$form->isValidPartial($data)) {
       // failed validation
   }
   ?>
*isValidPartial()*
只尝试校验那些数据中匹配的元素，如果某个元素不在数据中，那就跳过。

当为 AJAX 请求校验元素或元素组，你一般要校验表单的一个子集，并想要响应返回到
JSON。用 *processAjax()* 正好：

.. code-block::
   :linenos:
   <?php
   $json = $form->processAjax($data);
   ?>
你可以发送 JSON 响应到客户端。如果表单有效，这将是个布尔 true
响应，如果表单无效，则是个包含 key/message 对的 javascript 对象，这里，每个 'message'
是校验错误消息的数组。

对于校验失败的表单，你可以分别使用 *getErrors()* 和 *getMessages()*
获取错误代码和错误消息：

.. code-block::
   :linenos:
   <?php
   $codes = $form->getErrors();
   $messages = $form->getMessage();
   ?>
.. note::

   因为由 *getMessages()* 返回的消息是 error code/message 对的数组，一般不需要 *getErrors()*\
   。

你可以通过传递元素名为单个元素来获取代码和错误消息；

.. code-block::
   :linenos:
   <?php
   $codes = $form->getErrors('username');
   $messages = $form->getMessages('username');
   ?>
.. note::

   注意：当校验元素时， *Zend_Form* 发送第二个参数给每个元素的 *isValid()*
   方法：被校验的数据的数组。当确定数据和合法性时，单个的校验器可以用这个来让它们来利用其它提交的值。一个典型的例子是注册表单，密码和密码确认都是必需的；密码元素可以使用密码确认做为它的校验的一部分。

.. _zend.form.forms.validation.errors:

定制错误消息
^^^^^^

有时，你想定制一条或多条特定的错误消息来替代由附加到元素上的校验器所带的错误消息。
另外，有时候你想自己标记表单无效，从 1.6.0 版开始，通过下列方法来实现这个功能。

- *addErrorMessage($message)*: 添加一条来显示当校验失败时的错误消息。
  可以多次调用，新消息就追加到堆栈。

- *addErrorMessages(array $messages)*: 添加多条错误消息来显示校验错误。

- *setErrorMessages(array $messages)*:
  添加多条错误消息来显示校验错误，并覆盖先前的错误消息。

- *getErrorMessages()*: 读取已定义的定制的错误消息列表。

- *clearErrorMessages()*: 删除已定义的定制的错误消息。

- *markAsError()*: 标记表单已经有失败的校验。

- *addError($message)*: 添加一条消息给定制错误消息栈并标记表单无效。

- *addErrors(array $messages)*: 添加数条消息给定制错误消息栈并标记表单无效。

- *setErrors(array $messages)*: 覆盖定制的错误消息堆栈并标记表单无效。

所有用这个方式设置的错误可以被翻译。 另外，你可以插入占位符 "%value%"
来表示元素的值；当读取到错误消息时，这个当前元素值将被替换。

.. _zend.form.forms.methods:

方法
--

下面是 *Zend_Form* 的方法大全，按类分组：

- 配置和选项：

  - *setOptions(array $options)*

  - *setConfig(Zend_Config $config)*

- 插件加载器和路径：

  - *setPluginLoader(Zend_Loader_PluginLoader_Interface $loader, $type = null)*

  - *getPluginLoader($type = null)*

  - *addPrefixPath($prefix, $path, $type = null)*

  - *addPrefixPaths(array $spec)*

  - *addElementPrefixPath($prefix, $path, $type = null)*

  - *addElementPrefixPaths(array $spec)*

  - *addDisplayGroupPrefixPath($prefix, $path)*

- 元数据:

  - *setAttrib($key, $value)*

  - *addAttribs(array $attribs)*

  - *setAttribs(array $attribs)*

  - *getAttrib($key)*

  - *getAttribs()*

  - *removeAttrib($key)*

  - *clearAttribs()*

  - *setAction($action)*

  - *getAction()*

  - *setMethod($method)*

  - *getMethod()*

  - *setName($name)*

  - *getName()*

- 元素：

  - *addElement($element, $name = null, $options = null)*

  - *addElements(array $elements)*

  - *setElements(array $elements)*

  - *getElement($name)*

  - *getElements()*

  - *removeElement($name)*

  - *clearElements()*

  - *setDefaults(array $defaults)*

  - *setDefault($name, $value)*

  - *getValue($name)*

  - *getValues()*

  - *getUnfilteredValue($name)*

  - *getUnfilteredValues()*

  - *setElementFilters(array $filters)*

  - *setElementDecorators(array $decorators)*

- 子表单：

  - *addSubForm(Zend_Form $form, $name, $order = null)*

  - *addSubForms(array $subForms)*

  - *setSubForms(array $subForms)*

  - *getSubForm($name)*

  - *getSubForms()*

  - *removeSubForm($name)*

  - *clearSubForms()*

  - *setSubFormDecorators(array $decorators)*

- 显示组：

  - *addDisplayGroup(array $elements, $name, $options = null)*

  - *addDisplayGroups(array $groups)*

  - *setDisplayGroups(array $groups)*

  - *getDisplayGroup($name)*

  - *getDisplayGroups()*

  - *removeDisplayGroup($name)*

  - *clearDisplayGroups()*

  - *setDisplayGroupDecorators(array $decorators)*

- 校验

  - *populate(array $values)*

  - *isValid(array $data)*

  - *isValidPartial(array $data)*

  - *processAjax(array $data)*

  - *persistData()*

  - *getErrors($name = null)*

  - *getMessages($name = null)*

- 解析：

  - *setView(Zend_View_Interface $view = null)*

  - *getView()*

  - *addDecorator($decorator, $options = null)*

  - *addDecorators(array $decorators)*

  - *setDecorators(array $decorators)*

  - *getDecorator($name)*

  - *getDecorators()*

  - *removeDecorator($name)*

  - *clearDecorators()*

  - *render(Zend_View_Interface $view = null)*

- I18n:

  - *setTranslator(Zend_Translator_Adapter $translator = null)*

  - *getTranslator()*

  - *setDisableTranslator($flag)*

  - *translatorIsDisabled()*

.. _zend.form.forms.config:

配置
--

*Zend_Form* 可以通过 *setOptions()* 和 *setConfig()* （或者通过传递选项或 *Zend_Config* 对象 ）
进行全面配置。使用这些方法，你可以指定表单元素、显示组、装饰器和元数据。

作为通用的规则，如果 'set' + 选项键涉及 *Zend_Form*
方法，那么提供的值将传递给那个方法。
如果访问器不存在，键被假定引用一个属性并将传递给 *setAttrib()* 。

规则的异常包括下列这些：

- *prefixPaths* 将传递给 *addPrefixPaths()*

- *elementPrefixPaths* 将传递给 *addElementPrefixPaths()*

- *displayGroupPrefixPaths* 将传递给 *addDisplayGroupPrefixPaths()*

- 下列设置器不能用这个方法设置：

  - *setAttrib (though setAttribs *will* work)*

  - *setConfig*

  - *setDefault*

  - *setOptions*

  - *setPluginLoader*

  - *setSubForms*

  - *setTranslator*

  - *setView*

作为一个例子，这里是一个为每个可配置数据传递配置的配置文件：

.. code-block::
   :linenos:

   [element]
   name = "registration"
   action = "/user/register"
   method = "post"
   attribs.class = "zend_form"
   attribs.onclick = "validate(this)"

   disableTranslator = 0

   prefixPath.element.prefix = "My_Element"
   prefixPath.element.path = "My/Element/"
   elementPrefixPath.validate.prefix = "My_Validate"
   elementPrefixPath.validate.path = "My/Validate/"
   displayGroupPrefixPath.prefix = "My_Group"
   displayGroupPrefixPath.path = "My/Group/"

   elements.username.type = "text"
   elements.username.options.label = "Username"
   elements.username.options.validators.alpha.validator = "Alpha"
   elements.username.options.filters.lcase = "StringToLower"
   ; more elements, of course...

   elementFilters.trim = "StringTrim"
   ;elementDecorators.trim = "StringTrim"

   displayGroups.login.elements.username = "username"
   displayGroups.login.elements.password = "password"
   displayGroupDecorators.elements.decorator = "FormElements"
   displayGroupDecorators.fieldset.decorator = "Fieldset"

   decorators.elements.decorator = "FormElements"
   decorators.fieldset.decorator = "FieldSet"
   decorators.fieldset.decorator.options.class = "zend_form"
   decorators.form.decorator = "Form"
   ?>
上述可以很容易被抽象成 XML 或 PHP 基于数组的配置文件。

.. _zend.form.forms.custom:

定制表单
----

一个使用基于配置的表单的替代方法是继承 *Zend_Form* 类，有若干优点：

- 可以容易进行单元测试来确保校验和解析如愿执行。

- 精细地控制每个元素。

- 重使用表单对象，最大化可移植性（不需要跟踪配置文件）。

- 实现定制功能。

最典型的用例是使用 *init()* 方法来设置指定的表单元素和配置：

.. code-block::
   :linenos:
   <?php
   class My_Form_Login extends Zend_Form
   {
       public function init()
       {
           $username = new Zend_Form_Element_Text('username');
           $username->class = 'formtext';
           $username->setLabel('Username:')
                    ->setDecorators(array(
                        array('ViewHelper', array('helper' => 'formText')),
                        array('Label', array('class' => 'label'))
                    ));

           $password = new Zend_Form_Element_Password('password');
           $password->class = 'formtext';
           $password->setLabel('Username:')
                    ->setDecorators(array(
                        array('ViewHelper', array('helper' => 'formPassword')),
                        array('Label', array('class' => 'label'))
                    ));

           $submit = new Zend_Form_Element_Submit('login');
           $submit->class = 'formsubmit';
           $submit->setValue('Login')
                  ->setDecorators(array(
                      array('ViewHelper', array('helper' => 'formSubmit'))
                  ));

           $this->addElements(array(
               $username,
               $password,
               $submit
           ));

           $this->setDecorators(array(
               'FormElements',
               'Fieldset',
               'Form'
           ));
       }
   }
   ?>
这个表单可以简单地实例化：

.. code-block::
   :linenos:
   <?php
   $form = new My_Form_Login();
   ?>
所有的功能已经设置并准备好了，不需要配置文件。（注意这个例子非常简化，因为它没有为元素包含校验器和过滤器。）

另一个普通的扩展原因是定义一组缺省的装饰器，可以通过覆盖（overriding）
*loadDefaultDecorators()* 方法来完成：

.. code-block::
   :linenos:
   <?php
   class My_Form_Login extends Zend_Form
   {
       public function loadDefaultDecorators()
       {
           $this->setDecorators(array(
               'FormElements',
               'Fieldset',
               'Form'
           ));
       }
   }


