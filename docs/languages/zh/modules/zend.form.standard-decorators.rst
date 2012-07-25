.. _zend.form.standardDecorators:

Zend Framework 带有的标准表单装饰器（Decorators）
=====================================

*Zend_Form* 带有若干标准装饰器，更多关于装饰器的一般用法，参见 :ref:`the Decorators
section <zend.form.decorators>`\ 。

.. _zend.form.standardDecorators.callback:

Zend_Form_Decorator_Callback
----------------------------

回调（callback）装饰器可以对解析内容执行任意回调。回调应当通过传递给装饰器配置的
'callback' 选项来指定，可以是任何有效的 PHP 回调类型。回调接受三个参数 *$content*
（传递给装饰器的原始内容）、 *$element* （被装饰的条目）和 一个 *$options*
数组。这是个回调的例子：

.. code-block:: php
   :linenos:

   <?php
   class Util
   {
       public static function label($content, $element, array $options)
       {
           return '<span class="label">' . $element->getLabel() . "</span>";
       }
   }
   ?>
这个回调被指定为 *array('Util','label')*\ ，并为标签（label）产生一些（坏的） HTML
markup。回调装饰器将替换追加或用这个返回值预先准备原始内容。

回调装饰器允许为替换选项指定一个 null
值，它将用回调返回值来替换原始内容，'prepend' 和 'append' 仍然有效。

.. _zend.form.standardDecorators.captcha:

Zend_Form_Decorator_Captcha
---------------------------

Captcha 装饰器用于 :ref:`Captcha 表单元素 <zend.form.standardElements.captcha>`\ 。 它利用 captcha
适配器的 *render()* 方法来生成输出。

Captcha 装饰器的一个变量，'Captcha_Word'，也常用，并生成两个元素，id 和 input。 id
表示比较依靠的会话识别符，input 用于 captcha 的校验。这些作为单个的元素被校验。

.. _zend.form.standardDecorators.description:

Zend_Form_Decorator_Description
-------------------------------

描述装饰器用来显示设置在 *Zend_Form*\ 、 *Zend_Form_Element* 或 *Zend_Form_DisplayGroup*
条目上的描述。它使用对象的 *getDescription()*
方法来取出描述。普通的用例用来为元素提供用户接口（UI）提示。

缺省地，如果没有描述，就不会生成输出。如果有描述，它将缺省地封装在 *p*
标签里，当生成装饰器时你可以通过传递一个 *tag*\ 选项或调用 *setTag()*
来指定一个标签。你也可以使用 *class* 选项或调用 *setClass()* 来指定一个类，缺省使用
'hint' 类。

缺省描述使用视图对象的转义机制来转义。你可以传递 *false* 值给装饰器的 'escape'
选项或 *setEscape()* 方法来关闭（disable）它。

.. _zend.form.standardDecorators.dtDdWrapper:

Zend_Form_Decorator_DtDdWrapper
-------------------------------

缺省装饰器使用定义列表 (*<dl>*)
来解析表单元素。因为表单条目可以以任何顺序出现，显示组和子表单可以用其它表单条目点缀。为在定义列表里保持这些特定的题目类型，DtDdWrapper
生成一个新的、空定义 term (*<dt>*) 并在新定义数据（ *<dd>*\ ）里封装它的内容
。输出看起来是这样的：

.. code-block:: php
   :linenos:

   <dt></dt>
   <dd><fieldset id="subform">
       <legend>User Information</legend>
       ...
   </fieldset></dd>

装饰器通过把提供给它的内容封装在 *<dd>* 元素里来替换它。

.. _zend.form.standardDecorators.errors:

Zend_Form_Decorator_Errors
--------------------------

元素错误用错误装饰器来获得它们自己的装饰器。这个装饰器代理 FormErrors
视图助手，它在无序的列表里 (*<ul>*) 解析错误消息作为列表条目。 *<ul>* 元素接收
"errors" 类。

错误装饰器可以预先准备或追加提供给它的内容。

.. _zend.form.standardDecorators.fieldset:

Zend_Form_Decorator_Fieldset
----------------------------

显示组和子表单缺省地在字段（fieldsets）里解析内容。字段装饰器在注册的元素里检查
'legend' 选项或 *getLegend()* 方法，如果非空，就用它作为
legend。任何传递进来的内容被封装在 HTML
字段里，替换原先的内容。任何在装饰器条目里的属性设置都作为 HTML
属性传递给字段。

.. _zend.form.standardDecorators.form:

Zend_Form_Decorator_Form
------------------------

*Zend_Form* 对象一般需要解析 HTML
表单标签（tag）。表单装饰器代理表单视图助手。它使用 *Zend_Form*
对象的动作和方法，封装任何提供给它的内容到 HTML 表单元素，和任何属性作为 HTML
属性。

.. _zend.form.standardDecorators.formElements:

Zend_Form_Decorator_FormElements
--------------------------------

表单、显示组和子表单是元素的集合。为了解析这些元素，它们使用 FormElements
装饰器（它迭代所有条目，在每个条目调用 *render()*
并用注册的分隔符连接它们）。它可以追加或预先准备传递给它的内容。

.. _zend.form.standardDecorators.htmlTag:

Zend_Form_Decorator_HtmlTag
---------------------------

HtmlTag 装饰器让你用 HTML 标签来装饰内容。通过传递 'tag' 选项和任何其它用作 HTML
属性的选项来使用标签。标签缺省地假定为 block
一级，通过封装在给定的标签里来替换内容。然而，你也可以指定一个追加或者预先准备的替换。

.. _zend.form.standardDecorators.image:

Zend_Form_Decorator_Image
-------------------------

图像装饰器让你生成一个 HTML 图像输入（ *<input type="image" ... />*\ ），并在另一个 HTML
标签里可选地解析它。

缺省地，（图像）装饰器使用元素的 src 属性，它可以用 *setImage()*
方法来设置图像源。另外，元素的标签（label）将用做 alt 标签（tag），并且 *imageValue*\
（用图像元素的 *setImageValue()* 和 *getImageValue()* 访问器来处理）将用于值的设置。

为指定一个封装元素的 HTML 标签，或者传递 'tag' 选项给装饰器，或者显式地调用
*setTag()*\ 。

.. _zend.form.standardDecorators.label:

Zend_Form_Decorator_Label
-------------------------

表单元素一般都有标签，标签装饰器用来解析这些标签。它代理 FormLabel
视图助手，用这个元素的 *getLabel()*
方法把元素标签读出来。如果没有标签，就不解析。缺省地，如果有翻译适配器和这个标签的翻译，标签就被翻译。

你可以可选地指定一个 'tag' 选项，如果提供了，它封装在 block
一级标签（tag）封装这个标签（label）。如果有 'tag'
选项而没有标签（label）存在，那么标签（tag）就被不带内容解析。你可以用 'class'
选项或调用 *setClass()* 来指定和标签（tag）一起使用的类。

另外，当显示元素（基于标签（label）是否用于可选的或必需的元素）时，你可以指定前缀和后缀来用。普通的用例是追加
':' 给标签（label），或者一个 '\*' 来表明元素是必需的。可以用下列选项和方法来做：

- *optionalPrefix*: 当元素是可选的时候，设置文本给标签带有的前缀。使用
  *setOptionalPrefix()* 和 *getOptionalPrefix()* 访问器来处理。

- *optionalSuffix*: 当元素是可选的时候，设置追加给标签的文本。使用 *setOptionalSuffix()* 和
  *getOptionalSuffix()* 访问器来处理。

- *requiredPrefix*: 当元素必需的时候，设置文本给标签带有的前缀。使用 *setRequiredPrefix()*
  和 *getRequiredPrefix()* 访问器来处理。

- *requiredSuffix*: 当元素是必需的时候，设置追加给标签的文本。使用 *setRequiredSuffix()* 和
  *getRequiredSuffix()* 访问器来处理。

缺省地，标签装饰器预先准备给要提供的内容，指定一个 'append' 的 'placement'
选项来把它放在内容的后面。

.. _zend.form.standardDecorators.viewHelper:

Zend_Form_Decorator_ViewHelper
------------------------------

大部分元素使用 *Zend_View* 助手来解析，这是通过 ViewHelper
装饰器来完成的。这样，你可以指定一个 'helper'
标签（tag）来显式地设置视图助手来使用。如果什么也没有提供，它使用元素类名的最后一节来确定助手，用字符串
'form'来预先准备：例如，'Zend_Form_Element_Text' 寻找一个叫 'formText' 的视图助手。

任何提供的元素的属性被当作元素属性来传递给视图助手。

缺省地，这个装饰器追加内容，使用 'placement' 选项类指定另外的布置（placement）。

.. _zend.form.standardDecorators.viewScript:

Zend_Form_Decorator_ViewScript
------------------------------

有时候你可能想用视图脚本来生成元素，这样你可以对元素有精细的控制，把视图脚本交给（页面）设计者，或者基于你所使用的模块来构造一个简便地覆盖（override）设置的办法（每个模块可以可选地覆盖元素视图脚本来符合它们的需求）。ViewScript
装饰器解决了这个问题。

ViewScript 装饰器要求一个 'viewScript'
选项，或者提供给装饰器，或者作为元素的属性。它接着解析哪个视图脚本为部分脚本，意思是每次调用它有自己的变量范围。没有从视图来的变量将注入除非元素它自己。若干变量如下：

- *element*: 被装饰的元素

- *content*: 传递给装饰器的内容

- *decorator*: 装饰器对象自己

- 另外，所有通过 *setOptions()* 传递给装饰器的不用于内部（如 placement、 separator
  等）的选项作为视图变量传递给视图脚本。

作为例子，你可以有下列元素：

.. code-block:: php
   :linenos:

   <?php
   // Setting the decorator for the element to a single, ViewScript, decorator,
   // specifying the viewScript as an option, and some extra options:
   $element->setDecorators(array(array('ViewScript', array(
       'viewScript' => '_element.phtml',
       'class'      => 'form element'
   ))));

   // OR specifying the viewScript as an element attribute:
   $element->viewScript = '_element.phtml';
   $element->setDecorators(array(array('ViewScript', array('class' => 'form element'))));
   ?>
你可以接着有一个如下的视图脚本：

.. code-block:: php
   :linenos:

   <div class="<?= $this->class ?>">
       <?= $this->formLabel($this->element->getName(), $this->element->getLabel()) ?>
       <?= $this->{$this->element->helper}(
           $this->element->getName(),
           $this->element->getValue(),
           $this->element->getAttribs()
       ) ?>
       <?= $this->formErrors($this->element->getMessages()) ?>
       <div class="hint"><?= $this->element->getDescription() ?></div>
   </div>

.. note::

   **用视图脚本替换内容**

   你可能发现用视图脚本来替换提供给装饰器的内容很有用 －－
   例如，如果你想封装它。你可以通过指定一个布尔 false 值给装饰器的 'placement'
   选项来做：

   .. code-block:: php
      :linenos:

      <?php
      // At decorator creation:
      $element->addDecorator('ViewScript', array('placement' => false));

      // Applying to an existing decorator instance:
      $decorator->setOption('placement', false);

      // Applying to a decorator already attached to an element:
      $element->getDecorator('ViewScript')->setOption('placement', false);

      // Within a view script used by a decorator:
      $this->decorator->setOption('placement', false);
      ?>
当你想对元素的解析有个非常精细的控制，建议使用 ViewScript 装饰器。


