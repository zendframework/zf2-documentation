.. _zend.form.decorators:

使用 Zend_Form_Decorator 生成定制的表单标识（Markup）
==================================================================

解析一个表单对象完全是可选的 －－ 你根本不需要使用 *Zend_Form* 的 render()
方法。然而，如果你用了，装饰器就用来解析各种各样的表单对象。

每个条目（元素、显示组、子表单或表单对象自己）可能附有任意数量的装饰器，然而，只有一个给定类型的装饰器可能附加给每个条目。装饰器按照注册的顺序被调用。依靠装饰器，它替换传递给它的内容，或追加或预先准备内容。

对象状态通过传递给构造器或构造器的 *setOptions()*
方法的配置选项来设置。当通过条目的 *addDecorator()*
或相关方法生成装饰器时，选项可以作为参数传递给方法。这些可用来指定
placement、在传递进的内容和新生成的内容之间的分隔符、和装饰器支持的选项。

在每个装饰器的 *render()* 方法被调用之前，当前条目用 *setElement()*
设置到装饰器，让装饰器知道条目要被解析。这让你生成只解析条目的特定部分的装饰器
－－
例如标签（label）、值（value）、错误消息等。通过把若干个解析特定元素部分的装饰器放到一起，你可以构建复杂的表示整个条目的标识（markup）。

.. _zend.form.decorators.operation:

操作
------

要配置装饰器，传递选项数组或 *Zend_Config* 对象给它的构造器、 传递 *setOptions()*
的数组参数或 *Zend_Config* 对象给 *setConfig()* 。

标准选项包括：

- *placement*: 布置（placement）可以是 'append' 或 'prepend' （大小写敏感），并指示传递给
  *render()*
  的内容是否分别被追加或预先准备。在装饰器替换内容的情况下，忽略这个设置。缺省设置为追加（append）。

- *separator*: 用于传递给 *render()*
  的内容和有装饰器生成的新内容之间的分隔符，或用于由装饰器（例如，FormElements
  使用每个被解析的条目之间的分隔符）解析的条目之间的分隔符。在装饰器替换内容的情况下，忽略这个设置。缺省设置为
  *PHP_EOL*\ 。

装饰器接口指定和选项交互使用的方法，包括：

- *setOption($key, $value)*: 设置一个单个选项。

- *getOption($key)*: 读取一个单个选项值。

- *getOptions()*: 读取所有选项。

- *removeOption($key)*: 删除一个单个选项。

- *clearOptions()*: 删除所有选项。

装饰器和各种 *Zend_Form* 类来交互使用： *Zend_Form*\ 、 *Zend_Form_Element*\ 、
*Zend_Form_DisplayGroup* 和它们派生的类。 *setElement()*
方法让你设置当前和装饰器一起工作的对象，而 *getElement()* 用于读取它。

每个装饰器的 *render()* 方法接受字符串 *$content*
。当调用第一个装饰器，这个字符串一般是空的，在随后的调用中，它就被放上内容。基于装饰器的类型和传递进的选项，装饰器将替换、预先准备或追加这个字符串，一个可选的分隔符将用于后两者。

.. _zend.form.decorators.standard:

标准装饰器
---------------

*Zend_Form* 带有许多标准装饰器，参见 :ref:`标准装饰器一章 <zend.form.standardDecorators>`
有更多细节。

.. _zend.form.decorators.custom:

定制装饰器
---------------

如果你觉得你的解析很复杂或需要大量定制，可以考虑构造一个定制的装饰器。

装饰器只需要实现 *Zend_Form_Decorator_Interface*\ 。接口说明如下：

.. code-block::
   :linenos:
   <?php
   interface Zend_Form_Decorator_Interface
   {
       public function __construct($options = null);
       public function setElement($element);
       public function getElement();
       public function setOptions(array $options);
       public function setConfig(Zend_Config $config);
       public function setOption($key, $value);
       public function getOption($key);
       public function getOptions();
       public function removeOption($key);
       public function clearOptions();
       public function render($content);
   }
   ?>
要简化这个，可以继承 *Zend_Form_Decorator_Abstract*\ ，它实现了除 *render()*
之外的所有方法。

例如，你想减少装饰器的数量，构造一个在 HTML *div* 中的 "composite"
装饰器来处理标签（label）、元素、任何错误消息和描述的解析。你可以构造如下例的一个
'Composite' 装饰器：

.. code-block::
   :linenos:
   <?php
   class My_Decorator_Composite extends Zend_Form_Decorator_Abstract
   {
       public function buildLabel()
       {
           $element = $this->getElement();
           $label = $element->getLabel();
           if ($translator = $element->getTranslator()) {
               $label = $translator->translate($label);
           }
           if ($element->isRequired()) {
               $label .= '*';
           }
           $label .= ':';
           return $element->getView()->formLabel($element->getName(), $label);
       }

       public function buildInput()
       {
           $element = $this->getElement();
           $helper  = $element->helper;
           return $element->getView()->$helper(
               $element->getName(),
               $element->getValue(),
               $element->getAttribs(),
               $element->options
           );
       }

       public function buildErrors()
       {
           $element  = $this->getElement();
           $messages = $element->getMessages();
           if (empty($messages)) {
               return '';
           }
           return '<div class="errors">' . $element->getView()->formErrors($messages) . '</div>';
       }

       public function buildDescription()
       {
           $element = $this->getElement();
           $desc    = $element->getDescription();
           if (empty($desc)) {
               return '';
           }
           return '<div class="description">' . $desc . '</div>';
       }

       public function render($content)
       {
           $element = $this->getElement();
           if (!$element instanceof Zend_Form_Element) {
               return $content;
           }
           if (null === $element->getView()) {
               return $content;
           }

           $separator = $this->getSeparator();
           $placement = $this->getPlacement();
           $label     = $this->buildLabel();
           $input     = $this->buildInput();
           $errors    = $this->buildErrors();
           $desc      = $this->buildDescription();

           $output = '<div class="form element">'
                   . $label
                   . $input
                   . $errors
                   . $desc
                   . '</div>';

           switch ($placement) {
               case (self::PREPEND):
                   return $output . $separator . $content;
               case (self::APPEND):
               default:
                   return $content . $separator . $output;
           }
       }
   }
   ?>
接着把它放到装饰器路径里：

.. code-block::
   :linenos:
   <?php
   // for an element:
   $element->addPrefixPath('My_Decorator', 'My/Decorator/', 'decorator');

   // for all elements:
   $form->addElementPrefixPath('My_Decorator', 'My/Decorator/', 'decorator');
   ?>
然后指定这个装饰器为 'Composite' 并附加到一个元素：

.. code-block::
   :linenos:
   <?php
   // Overwrite existing decorators with this single one:
   $element->setDecorators(array('Composite'));
   ?>
虽然这个例子示范了如何生成从若干元素的属性解析复杂输出装饰器，你也可以生成元素的一个单方面的装饰器，'Decorator'
和 'Label' 装饰器是这个练习的优秀示范。这样做让你混合和匹配装饰器来完成复杂输出
－－ 并且也覆盖（override）装饰器的单个方面来符合你的需求。

例如，如果你想在校验元素时显示发生的错误，但不想显示每个独立的校验错误消息，可以生成
'Errors' 装饰器：

.. code-block::
   :linenos:
   <?php
   class My_Decorator_Errors
   {
       public function render($content = '')
       {
           $output = '<div class="errors">The value you provided was invalid;
               please try again</div>';

           $placement = $this->getPlacement();
           $separator = $this->getSeparator();

           switch ($placement) {
               case 'PREPEND':
                   return $output . $separator . $content;
               case 'APPEND':
               default:
                   return $content . $separator . $output;
           }
       }
   }
   ?>
在这个特定的例子中，因为装饰器的最后一节，'Errors'，匹配 *Zend_Form_Decorator_Errors*\
，它将 **代替** 那个装饰器被解析 －－
你不需要修改任何装饰器来修改输出。通过在已存在的标准装饰器之后命名你的装饰器，你可以不需要修改元素的装饰器来修改装饰。


