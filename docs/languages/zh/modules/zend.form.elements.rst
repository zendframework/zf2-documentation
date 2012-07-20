.. _zend.form.elements:

使用 Zend_Form_Element 生成表单元素
===========================================

表单由元素组成，它一般对应于 HTML 表单输入。Zend_Form_Element
封装了单个表单元素，并完成下列工作：

- 校验（提交的数据有效乎？）

  - 抓取校验错误代码和消息

- 过滤（在校验和/或输出之前元素如何转义或规范化？）

- 解析（元素如何显示？）

- 元数据和属性（什么信息进一步修饰元素？）

基础类 *Zend_Form_Element*
对许多类有合理的缺省设置，但最好还是继承这个类来完成特殊意图的元素。另外，Zend
Framework 带有许多标准的 XHTML 元素，请阅读 :ref:`在标准元素一章 <zend.form.standardElements>`
的有关文档。

.. _zend.form.elements.loaders:

插件加载器
---------------

*Zend_Form_Element* 利用 :ref:`Zend_Loader_PluginLoader <zend.loader.pluginloader>`
来使开发者指定替代校验器、过滤器和装饰器的位置。每个都有它自己携带的插件加载器，并使用通用的访问器来读取或修改它们。

下列加载器类型和各种各样的插件加载器方法一起使用：'validate'、 'filter' 和
'decorator'。类型名是大小写敏感的。

和插件加载器交互使用的方法如下：

- *setPluginLoader($loader, $type)*\ ： *$loader* 是插件加载器对象自己，而 *$type*
  是上述类型之一。这个方法为给定类型的插件加载器设置为最新的特定的载器对象。

- *getPluginLoader($type)*: 用携带的 *$type* 来读取插件加载器。

- *addPrefixPath($prefix, $path, $type = null)*: 添加 prefix/path 联合给由 *$type*
  指定的加载器。如果 *$type* 是 null，它将尝试通过追加前缀给 "\_Validate"、"\_Filter", 和
  "\_Decorator" 来添加路径到所有加载器，并用 "Validate/"、"Filter/" 和 "Decorator/".
  追加路径。如果你在通用的等级下有所有额外的表单元素类，这是个用来设置基础前缀给它们的方便的方法。

- *addPrefixPaths(array $spec)*:
  让你一次性添加许多路径给一个或多个插件加载器。它需要每个数组条目是个带有
  'path'、'prefix' 和 'type'. 键的数组。

定制的校验器、过滤器和装饰器是在表单和封装定制功能之间共享功能的简单的办法。

.. _zend.form.elements.loaders.customLabel:

.. rubric:: 定制标签

插件的一个普通用例是来为标准类提供替换。例如，如果想实现一个不同的 'Label'
装饰器 －－ 如总要追加冒号 －－你可以创建你自己的带有类前缀的 'Label'
装饰器，然后把它加到你的前缀路径。

让我们从定制标签装饰器来开始，给它一个类前缀 "My_Decorator"，类文件就是
"My/Decorator/Label.php"。

.. code-block::
   :linenos:
   <?php
   class My_Decorator_Label extends Zend_Form_Decorator_Abstract
   {
       protected $_placement = 'PREPEND';

       public function render($content)
       {
           if (null === ($element = $this->getElement())) {
               return $content;
           }
           if (!method_exists($element, 'getLabel')) {
               return $content;
           }

           $label = $element->getLabel() . ':';

           if (null === ($view = $element->getView())) {
               return $this->renderLabel($content, $label);
           }

           $label = $view->formLabel($element->getName(), $label);

           return $this->renderLabel($content, $label);
       }

       public function renderLabel($content, $label)
       {
           $placement = $this->getPlacement();
           $separator = $this->getSeparator();

           switch ($placement) {
               case 'APPEND':
                   return $content . $separator . $label;
               case 'PREPEND':
               default:
                   return $label . $separator . $content;
           }
       }
   }

现在，当元素寻找装饰器时，就使用这个插件路径：

.. code-block::
   :linenos:

   $element->addPrefixPath('My_Decorator', 'My/Decorator/', 'decorator');

另外，我们可以在表单一级来做以确保所有的装饰器使用这个路径：

.. code-block::
   :linenos:

   $form->addElementPrefixPath('My_Decorator', 'My/Decorator/', 'decorator');

用这个添加的路径，当添加一个装饰器，将首先搜索 'My/Decorator/'
路径来检查是否存在装饰器。结果，如果请求 'Label' 装饰器，'My_Decorator_Label'
将被使用。

.. _zend.form.elements.filters:

过滤器
---------

在校验之前对输入执行规范化常常是有用的并/或必需的 － 例如，你可能想要剥离所有
HTML，在剩下的东东上运行校验来确保提交有效。或者你可能想把输入的数据两边的空格都消掉，这样
StringLength 校验器就不会返回失败。这些操作使用 *Zend_Filter* 来执行，并且
*Zend_Form_Element* 对过滤链有支持，让你指定多个连续的过滤器来用。在校验期间和通过
*getValue()* 读取元素值的时候都会发生校验：

.. code-block::
   :linenos:
   <?php
   $filtered = $element->getValue();
   ?>
有两个办法添加过滤器：

- 传递一个具体的过滤器实例

- 提供过滤器名称 － 短名或完整的类名都可以

看一些例子：

.. code-block::
   :linenos:
   <?php
   // 具体的过滤器实例：
   $element->addFilter(new Zend_Filter_Alnum());

   // 合格的全类名：
   $element->addFilter('Zend_Filter_Alnum');

   // 短过滤器名：
   $element->addFilter('Alnum');
   $element->addFilter('alnum');
   ?>
短名一般就是过滤器名去掉前缀，缺省就是去掉 'Zend_Filter\_'
前缀。另外，首字母不需要大写。

.. note::

   **使用定制的过滤器类**

   如果你有自己的一组过滤器，可以通过 *addPrefixPath()* 来告诉 *Zend_Form_Element*\
   。例如，如果你在 'My_Filter' 前缀下有过滤器，这样来告诉 *Zend_Form_Element*\ ：

   .. code-block::
      :linenos:
      <?php
      $element->addPrefixPath('My_Filter', 'My/Filter/', 'filter');
      ?>
   （回忆一下第三个参数用来指示哪个是执行这个动作的插件加载器）

任何时候需要非过滤的数据，使用 *getUnfilteredValue()* 方法：

.. code-block::
   :linenos:
   <?php
   $unfiltered = $element->getUnfilteredValue();
   ?>
参见 :ref:`Zend_Filter 文档 <zend.filter.introduction>` 有更多关于过滤器的信息。

过滤器带有这些方法：

- *addFilter($nameOfFilter, array $options = null)*

- *addFilters(array $filters)*

- *setFilters(array $filters)* （重写所有过滤器）

- *getFilter($name)* （按名字读取过滤器对象）

- *getFilters()* （读取所有过滤器）

- *removeFilter($name)* （按名字删除过滤器）

- *clearFilters()* （删除所有过滤器）

.. _zend.form.elements.validators:

校验器
---------

如果你赞同安全咒语“过滤输入，转义输出”，你将会校验（“过滤输入”）你的表单输入。
在 *Zend_Form* 里，每个元素包含它自己的由 *Zend_Validate_** 校验器组成的校验器链。

两个办法添加校验器到校验器链：

- 传递一个具体的校验器实例

- 提供一个校验器名 － 短名或者完整的类名都可以

看一些例子：

.. code-block::
   :linenos:
   <?php
   // Concrete validator instance:
   $element->addValidator(new Zend_Validate_Alnum());

   // Fully qualified class name:
   $element->addValidator('Zend_Validate_Alnum');

   // Short validator name:
   $element->addValidator('Alnum');
   $element->addValidator('alnum');
   ?>
短名一般就是校验器名去掉前缀，缺省就是去掉 'Zend_Validate\_'
前缀。另外，首字母不需要大写。

.. note::

   **使用定制的校验器类**

   如果你有自己的一组校验器，可以通过 *addPrefixPath()* 来告诉 *Zend_Form_Element*\
   。例如，如果你在 'My_Validator' 前缀下有校验器，这样来告诉 *Zend_Form_Element*\ ：

   .. code-block::
      :linenos:
      <?php
      $element->addPrefixPath('My_Validator', 'My/Validator/', 'validate');
      ?>
   （回忆一下第三个参数用来指示哪个是执行这个动作的插件加载器）

如果特定的校验失败，为阻止后面的校验工作，传递第二个参数 *true* （布尔型）：

.. code-block::
   :linenos:
   <?php
   $element->addValidator('alnum', true);
   ?>
如果你使用一个字符串名来添加一个校验器，并且这个校验器接受参数给构造器，你可以把这个第三个参数
*addValidator()* 作为数组传递：

.. code-block::
   :linenos:
   <?php
   $element->addValidator('StringLength', false, array(6, 20));
   ?>
这样传递参数应该按照它们在构造器里定义的顺序进行。上述例子将带参数 *$min* 和
*$max* 实例化 *Zend_Validate_StringLenth* 类：

.. code-block::
   :linenos:
   <?php
   $validator = new Zend_Validate_StringLength(6, 20);
   ?>
.. note::

   **提供定制的校验错误消息**

   有些开发者可能想为校验器提供定制的错误消息。 *Zend_Form_Element::addValidator()* 的
   *$options* 参数让你通过提供 'messages'
   键并把它设置为键/值对（用来设置消息模板）的数组来完成。你需要知道特定校验器的各种各样的校验错误类型的错误代码。

   稍好的选择是在表单中使用 *Zend_Translator_Adapter*\
   。错误代码通过缺省的错误装饰器自动传递给适配器，然后你可以通过为你的校验器的各种错误代码设置翻译来指定自己的错误消息字符串。

你也可以使用 *addValidators()*
一次性设置许多校验器。基本的用法是传递数组的数组，每个数组包含 1 到 3 个匹配
*addValidator()* 的构造器的值：

.. code-block::
   :linenos:
   <?php
   $element->addValidators(array(
       array('NotEmpty', true),
       array('alnum'),
       array('stringLength', false, array(6, 20)),
   ));
   ?>
如果你想做的更明确和更详细，可以使用数组键 'validator'、 'breakChainOnFailure' 和
'options'：

.. code-block::
   :linenos:
   <?php
   $element->addValidators(array(
       array(
           'validator'           => 'NotEmpty',
           'breakChainOnFailure' => true),
       array('validator' => 'alnum'),
       array(
           'validator' => 'stringLength',
           'options'   => array(6, 20)),
   ));
   ?>
这个用法展示如何在配置文件中配置校验器：

.. code-block::
   :linenos:

   element.validators.notempty.validator = "NotEmpty"
   element.validators.notempty.breakChainOnFailure = true
   element.validators.alnum.validator = "Alnum"
   element.validators.strlen.validator = "StringLength"
   element.validators.strlen.options.min = 6
   element.validators.strlen.options.max = 20

注意每个条目有一个键，不管是否需要，这是使用配置文件规定的
－－但它也帮助清楚理解哪个参数用于什么。请记住任何校验器选项必需按顺序指定。

为校验一个元素，传递值给 *isValid()*\ ：

.. code-block::
   :linenos:
   <?php
   if ($element->isValid($value)) {
       // valid
   } else {
       // invalid
   }
   ?>
.. note::

   **在过滤后的值上校验**

   *Zend_Form_Element::isValid()* 在校验之前通过提供过滤器链来过滤（输入）值。见 See
   :ref:`过滤器一节 <zend.form.elements.filters>` 有更多信息。

.. note::

   **校验上下文**

   *Zend_Form_Element::isValid()* 支持另外的参数 *$context*\ 。当校验一个表单 *Zend_Form::isValid()*
   传递由 *$context* 处理过的数据的整个数组， *Zend_Form_Element::isValid()*
   接着把它传递给每个校验器。这意味着你可以写知道数据传递给其它表单元素的校验器，例如，标准的注册表单有密码和密码确认元素，得有一个校验它们是否匹配。这样的校验器看起来如下：

   .. code-block::
      :linenos:
      <?php
      class My_Validate_PasswordConfirmation extends Zend_Validate_Abstract
      {
          const NOT_MATCH = 'notMatch';

          protected $_messageTemplates = array(
              self::NOT_MATCH => 'Password confirmation does not match'
          );

          public function isValid($value, $context = null)
          {
              $value = (string) $value;
              $this->_setValue($value);

              if (is_array($context)) {
                  if (isset($context['password_confirm'])
                      && ($value == $context['password_confirm']))
                  {
                      return true;
                  }
              } elseif (is_string($context) && ($value == $context)) {
                  return true;
              }

              $this->_error(self::NOT_MATCH);
              return false;
          }
      }
      ?>
校验器按顺序处理，除非用 *breakChainOnFailure* 为 true
创建的校验器并且校验失败，否则每个校验器都要处理。确认按合理的顺序指定你的校验器。

校验失败后，你可以从校验器链读取错误代码和消息：

.. code-block::
   :linenos:
   <?php
   $errors   = $element->getErrors();
   $messages = $element->getMessages();
   ?>
（注意：错误消息返回的是一个有错误代码/错误消息对的联合数组）

除了校验器外，你可以用 *setRequired(true)* 指定必需的元素。缺省地，这个标志是
false，如果没有值传递给 *isValid()*\
，校验器链将被跳过。你也可以用许多办法来修改它的行为：

- 缺省地，当元素是必需的，标志 'allowEmpty'也是 true。这意味着如果传递给 *isValid()*
  的值为空，校验器将被跳过。可以用访问器 *setAllowEmpty($flag)*
  来切换这个标志。当标志为 false，并且传递了一个值，校验器将仍然运行。

- 缺省地，如果元素是必需的，但不包括 'NotEmpty' 校验器， *isValid()* 就用
  *breakChainOnFailure*
  标志设置添加一个到栈顶。这使得要求的标志有语义意义：如果没有传递值，我们立即使提交的数据无效并通知用户，并防止其它校验器继续校验我们已知的无效数据。

  如果你不想这样，传递给 *setAutoInsertNotEmptyValidator($flag)* 一个 false
  值使它关闭。这将防止 *isValid()* 在校验器链里放置一个 'NotEmpty' 校验器。

关于校验器的更多信息，参见 :ref:`Zend_Validate 文档 <zend.validate.introduction>`\ 。

.. note::

   **使用 Zend_Form_Elements 作为通用的校验器**

   *Zend_Form_Element* 实现 *Zend_Validate_Interface*\
   ，意味着元素可以在其它非表单相关的校验链里被用做校验器。

校验相关的方法包括：

- *setRequired($flag)* 和 *isRequired()* 让你设置和读取 'required' 标志的状态。当设置为布尔
  *true*\ ，这个标志要求元素在由 *Zend_Form* 处理的数据中。

- *setAllowEmpty($flag)* 和 *getAllowEmpty()* 让你修改可选元素的行为（例如，要求的标志为
  false 的元素）。当 'allow empty' 标志为 true 时，空值将传递给校验器链。

- *setAutoInsertNotEmptyValidator($flag)* 当元素是必需时，让你指定是否 'NotEmpty'
  校验器预先准备给校验器链。缺省地，这个标志为 true 。

- *addValidator($nameOrValidator, $breakChainOnFailure = false, array $options = null)*

- *addValidators(array $validators)*

- *setValidators(array $validators)* （重写所有校验器）

- *getValidator($name)* （按名读取校验器对象）

- *getValidators()* （读取所有校验器）

- *removeValidator($name)* （按名删除校验器）

- *clearValidators()* （删除所有校验器）

.. _zend.form.elements.validators.errors:

定制错误消息
^^^^^^^^^^^^^^^^^^

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

- *hasErrors()*: 确定是否元素有失败校验或标记为无效。

- *addError($message)*: 添加一条消息给定制错误消息栈并标记表单无效。

- *addErrors(array $messages)*: 添加数条消息给定制错误消息栈并标记表单无效。

- *setErrors(array $messages)*: 覆盖定制的错误消息堆栈并标记表单无效。

所有用这个方式设置的错误可以被翻译。

.. _zend.form.elements.decorators:

装饰器
---------

对许多 web 开发者来说一个特别的痛苦是 XHTML
表单自己的生成。对于每个元素，开发者需要为元素自己生成 markup，label
是一个典型，并且，如果他们对用户很好，需要为显示校验错误消息生成
markup。在页面元素越多，任务就越不琐碎。

*Zend_Form_Element* 试图用 "装饰器"
来解决这个问题。装饰器就是个类，可以访问元素和用于解析内容的方法。更多关于装饰器如何工作，参见
:ref:`Zend_Form_Decorator <zend.form.decorators>`\ 。

*Zend_Form_Element* 所使用的缺省的装饰器是：

- **ViewHelper**: 指定一个视图助手用于解析元素。'helper'
  元素属性可用来指定使用哪个视图助手。缺省地， *Zend_Form_Element* 指定 'formText'
  视图助手，但个别的子类指定不同的助手。

- **Errors**: 使用 *Zend_View_Helper_FormErrors*
  追加错误消息给元素，如果没有错误，就不追加。

- **HtmlTag**: 在一个 HTML <dd> 标签里封装元素和错误。

- **Label**: 使用 *Zend_View_Helper_FormLabel* 预先准备一个标签给元素，并把它封装在一个 <dt>
  标签里。如果没有提供标签（Label），就解析定义术语（definition term）标签（tag）。

.. note::

   **不需要加载缺省装饰器**

   缺省地，在对象初始化过程中加载缺省装饰器。你可以通过传递
   'disableLoadDefaultDecorators' 选项给构造器来关闭它：

   .. code-block::
      :linenos:
      <?php
      $element = new Zend_Form_Element('foo', array('disableLoadDefaultDecorators' => true));

   该选项可以和企图选项混合，它们都是数组选项或在 *Zend_Config* 对象里。

因为装饰器注册顺序的原因
－－先注册先执行－－你需要确保按合适的顺序来注册装饰器，或者确保以健全的方式设置替换选项。这个是注册缺省装饰器的例子：

.. code-block::
   :linenos:
   <?php
   $this->addDecorators(array(
       array('ViewHelper'),
       array('Errors'),
       array('HtmlTag', array('tag' => 'dd')),
       array('Label', array('tag' => 'dt')),
   ));
   ?>
初始内容由 'ViewHelper' 装饰器生成，它生成表单元素自己。接着，'Errors'
装饰器从元素里抓取错误消息。如果有任何错误，就传递给 'FormErrors'
视图助手来解析。下一个装饰器 'HtmlTag' 在一个 HTML <dd>
标签里封装元素和错误。最后，'label' 装饰器读取元素的标签并传递给 'FormLabel'
视图助手，封装在一个 HTML <dt>
标签里。缺省地，数据预先准备给内容，输出结果基本上是这样的：

.. code-block::
   :linenos:

   <dt><label for="foo" class="optional">Foo</label></dt>
   <dd>
       <input type="text" name="foo" id="foo" value="123" />
       <ul class="errors">
           <li>"123" is not an alphanumeric value</li>
       </ul>
   </dd>

关于装饰器的更多信息，请阅读 :ref:`Zend_Form_Decorator 一节 <zend.form.decorators>`\ 。

.. note::

   **使用同类型的多重装饰器**

   在内部，当读取装饰器时， *Zend_Form_Element*
   使用装饰器的类作为查询机制。结果，你不能注册同类型的多重装饰器，后来的装饰器就重写以前存在的装饰器。

   为解决这个问题，你可以使用 **aliases**\
   。不是传递装饰器或装饰器名作为第一个参数给 *addDecorator()*\
   ，而是传递带有一个单个元素的数组，并且别名指向装饰器对象或名字：

   .. code-block::
      :linenos:
      <?php
      // Alias to 'FooBar':
      $element->addDecorator(array('FooBar' => 'HtmlTag'), array('tag' => 'div'));

      // And retrieve later:
      $decorator = $element->getDecorator('FooBar');
      ?>
   在 *addDecorators()* 和 *setDecorators()* 方法中，你需要在表示装饰器的数组中传递
   'decorator' 选项：

   .. code-block::
      :linenos:
      <?php
      // Add two 'HtmlTag' decorators, aliasing one to 'FooBar':
      $element->addDecorators(
          array('HtmlTag', array('tag' => 'div')),
          array(
              'decorator' => array('FooBar' => 'HtmlTag'),
              'options' => array('tag' => 'dd')
          ),
      );

      // And retrieve later:
      $htmlTag = $element->getDecorator('HtmlTag');
      $fooBar  = $element->getDecorator('FooBar');
      ?>
装饰器带有的方法包括：

- *addDecorator($nameOrDecorator, array $options = null)*

- *addDecorators(array $decorators)*

- *setDecorators(array $decorators)* （重写所有装饰器）

- *getDecorator($name)* （按名读取装饰器对象）

- *getDecorators()* （读取所有装饰器）

- *removeDecorator($name)* （按名删除装饰器）

- *clearDecorators()* （删除所有装饰器）

.. _zend.form.elements.metadata:

元数据和属性
------------------

*Zend_Form_Element* 处理广泛的属性和元素元数据，基本属性包括：

- **name**: 元素名，使用 *setName()* 和 *getName()* 访问器。

- **label**: 元素标签，使用 *setLabel()* 和 *getLabel()* 访问器。

- **order**: 在表单中出现的元素的索引，使用 *setOrder()* 和 *getOrder()* 访问器。

- **value**: 当前元素的值，使用 *setValue()* 和 *getValue()* 访问器。

- **description**: 元素的描述，常用于提供工具提示或 javascript
  上下文提示，描述元素的意图，使用 *setDescription()* 和 *getDescription()* 访问器。

- **required**: 当执行表单校验时，指示元素是否必需的标志，使用 *setRequired()* 和
  *getRequired()* 访问器，缺省为 false。

- **allowEmpty**: 指示可选的元素是否应该校验空值的标志，当为 true，并且要求的标志为
  false，空值就不传递给校验器链，并假定为 true。使用 *setAllowEmpty()* 和 *getAllowEmpty()*
  访问器，缺省为 true。

- **autoInsertNotEmptyValidator**: 当元素是必需时，指示是否插入一个 'NotEmpty'
  校验器。缺省地，这个标志为 true，用 *setAutoInsertNotEmptyValidator($flag)*
  来设置该标志并用 *autoInsertNotEmptyValidator()* 来确定它的值。

表单元素可能要求另外的元数据。例如，对于 XHTML 表单元素，你可能想指定属性如类或
id，有一组访问器来完成它：

- **setAttrib($name, $value)**: 添加属性

- **setAttribs(array $attribs)**: 像 addAttribs() 一样，但重写

- **getAttrib($name)**: 读取一个单个的属性值

- **getAttribs()**: 以键/值对读取所有属性

然而大多数时候，你可以把它们当作对象属性来访问，因为 *Zend_Form_Element*
利用重载来简便访问它们：

.. code-block::
   :linenos:
   <?php
   // Equivalent to $element->setAttrib('class', 'text'):
   $element->class = 'text;
   ?>
缺省地，在解析过程中所有属性传递给由元素使用的视图助手，并当作该元素标签的
HTML 属性来解析。

.. _zend.form.elements.standard:

标准元素
------------

*Zend_Form* 带有许多标准元素，请阅读 :ref:`标准元素 <zend.form.standardElements>`
一章有全部细节。

.. _zend.form.elements.methods:

Zend_Form_Element 方法
------------------------

*Zend_Form_Element* 有许多许多方法。下面是一个快速概要，按类分组：

- 配置：

  - *setOptions(array $options)*

  - *setConfig(Zend_Config $config)*

- I18n:

  - *setTranslator(Zend_Translator_Adapter $translator = null)*

  - *getTranslator()*

  - *setDisableTranslator($flag)*

  - *translatorIsDisabled()*

- 属性：

  - *setName($name)*

  - *getName()*

  - *setValue($value)*

  - *getValue()*

  - *getUnfilteredValue()*

  - *setLabel($label)*

  - *getLabel()*

  - *setDescription($description)*

  - *getDescription()*

  - *setOrder($order)*

  - *getOrder()*

  - *setRequired($flag)*

  - *getRequired()*

  - *setAllowEmpty($flag)*

  - *getAllowEmpty()*

  - *setAutoInsertNotEmptyValidator($flag)*

  - *autoInsertNotEmptyValidator()*

  - *setIgnore($flag)*

  - *getIgnore()*

  - *getType()*

  - *setAttrib($name, $value)*

  - *setAttribs(array $attribs)*

  - *getAttrib($name)*

  - *getAttribs()*

- 插件加载器和路径：

  - *setPluginLoader(Zend_Loader_PluginLoader_Interface $loader, $type)*

  - *getPluginLoader($type)*

  - *addPrefixPath($prefix, $path, $type = null)*

  - *addPrefixPaths(array $spec)*

- 校验：

  - *addValidator($validator, $breakChainOnFailure = false, $options = array())*

  - *addValidators(array $validators)*

  - *setValidators(array $validators)*

  - *getValidator($name)*

  - *getValidators()*

  - *removeValidator($name)*

  - *clearValidators()*

  - *isValid($value, $context = null)*

  - *getErrors()*

  - *getMessages()*

- 过滤器：

  - *addFilter($filter, $options = array())*

  - *addFilters(array $filters)*

  - *setFilters(array $filters)*

  - *getFilter($name)*

  - *getFilters()*

  - *removeFilter($name)*

  - *clearFilters()*

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

.. _zend.form.elements.config:

配置
------

*Zend_Form_Element* 的构造器接受选项数组或包含选项的 *Zend_Config* 的对象，它也可以用
*setOptions()* 或 *setConfig()* 来配置。一般来说，命名键如下：

- 如果 'set' + 键指向 *Zend_Form_Element* 方法，那么提供的值就传递给这个方法。

- 否则，这个值就用来设置属性。

该规则的例外包括如下：

- *prefixPath* 将传递给 *addPrefixPaths()*

- 下面的设置器不能用这个办法：

  - *setAttrib* （通过 *setAttribs* **来工作**\ ）

  - *setConfig*

  - *setOptions*

  - *setPluginLoader*

  - *setTranslator*

  - *setView*

这里是一个例子，为每个配置数据类型传递配置的配置文件：

.. code-block::
   :linenos:

   [element]
   name = "foo"
   value = "foobar"
   label = "Foo:"
   order = 10
   required = true
   allowEmpty = false
   autoInsertNotEmptyValidator = true
   description = "Foo elements are for examples"
   ignore = false
   attribs.id = "foo"
   attribs.class = "element"
   onclick = "autoComplete(this, '/form/autocomplete/element')" ; sets 'onclick' attribute
   prefixPaths.decorator.prefix = "My_Decorator"
   prefixPaths.decorator.path = "My/Decorator/"
   disableTranslator = 0
   validators.required.validator = "NotEmpty"
   validators.required.breakChainOnFailure = true
   validators.alpha.validator = "alpha"
   validators.regex.validator = "regex"
   validators.regex.options.pattern = "/^[A-F].*/$"
   filters.ucase.filter = "StringToUpper"
   decorators.element.decorator = "ViewHelper"
   decorators.element.options.helper = "FormText"
   decorators.label.decorator = "Label"

.. _zend.form.elements.custom:

定制元素
------------

通过继承 *Zend_Form_Element* 类，你可以生成自己的定制元素，这样做的原因是：

- 共享通用的校验器和/或过滤器的元素

- 有定制装饰器功能的元素

有两个方法一般用来扩展元素： *init()* 可为元素添加定制的初始化逻辑；
*loadDefaultDecorators()* 可用于设置一个用于元素的缺省装饰器的列表。

用例子来说明，你在一个表单里生成的所有文本元素需要用 *StringTrim*
来过滤、用通用的规则表达式来校验，并且你想用你生成的定制的装饰器来显示它们，'My_Decorator_TextItem'。另外，你有许多想指定的标准属性，包括
'size'、 'maxLength' 和 'class'。你可以定义这样的元素如下：

.. code-block::
   :linenos:
   <?php
   class My_Element_Text extends Zend_Form_Element
   {
       public function init()
       {
           $this->addPrefixPath('My_Decorator', 'My/Decorator/', 'decorator')
                ->addFilters('StringTrim')
                ->addValidator('Regex', false, array('/^[a-z0-9]{6,}$/i'))
                ->addDecorator('TextItem')
                ->setAttrib('size', 30)
                ->setAttrib('maxLength', 45)
                ->setAttrib('class', 'text');
       }
   }
   ?>
你接着可以通知表单对象关于元素的前缀路径并开始生成元素：

.. code-block::
   :linenos:
   <?php
   $form->addPrefixPath('My_Element', 'My/Element/', 'element')
        ->addElement('foo', 'text');
   ?>
'foo' 元素现在是 *My_Element_Text* 类型并展示你描画的行为。

当继承 *Zend_Form_Element* 时你想 override 的另一个特殊方法是 *loadDefaultDecorators()*\
。这个方法有条件地为你的元素加载一组缺省装饰器，你可能想在你的继承类里替换你自己的装饰器。

.. code-block::
   :linenos:
   <?php
   class My_Element_Text extends Zend_Form_Element
   {
       public function loadDefaultDecorators()
       {
           $this->addDecorator('ViewHelper')
                ->addDecorator('DisplayError')
                ->addDecorator('Label')
                ->addDecorator('HtmlTag', array('tag' => 'div', 'class' => 'element'));
       }
   }
   ?>
有许多办法定制元素。别忘了阅读 *Zend_Form_Element* API 文档来获知所有的可用方法。


