.. _zend.view.helpers:

视图助手（View Helper）
=================

在你的视图脚本中，经常需要执行某些特定的复杂的功能：例如，格式化日期，生成表单对象，或者显示action的链接等等。你可以使用助手类来完成这些工作。

助手就是简单的类。假设你想要一个名为'fooBar'的助手，缺省地，类的前缀是
*'Zend_View_Helper_'*
（当设定助手路径时，你可以指定定制的前缀），类名的最后一部分就是助手名称；这一部分应该是TitleCapped（即像英文文章的标题一样，例如fooBar就要写成FooBar，by
Jason Qi）;所以，类的全名就是 *Zend_View_Helper_FooBar*
。这个类应当至少有一个在助手之后命名的方法，并且是驼峰格式（即首字母小写，之后的每个单词首字母大写，例如thisIsAnExample。详见http://c2.com/cgi/wiki?CamelCase　--
Haohappy注）： *fooBar()* 。

.. note::

   **注意大小写**

   助手名称总是遵循驼峰格式，例如，它们从不以大写字母开头。类名是混合大小写字格式，但方法在执行时是驼峰格式。

.. note::

   **缺省助手路径**

   即使调用 *setHelperPath()* 来重写当前的路径，缺省助手路径总是指向 Zend Framework
   视图助手， 例如：'Zend/View/Helper/'，设置这个路径来确保缺省的助手工作。

在视图脚本中，你可以用 *$this->helperName()*\ 来调用helper。这时 *Zend_View*\ 会加载
*Zend_View_Helper_HelperName*\ 类，建立一个对象实例，并调用它的 *helperName()*\
方法。对象的实例会在 *Zend_View*\ 的实例内一直存在，并可以被 *$this->helperName()*\
重复调用。

.. _zend.view.helpers.initial:

基本的助手
-----

*Zend_View*\
自带了几个helper类，大部分是用来生成组件的和有自动转义变量的功能。另外，有些助手用来创建基于路由的URL和HTML列表以及声明变量。当前的助手包括：

- *declareVars():* 当使用 *strictVars()*
  时很有用，这个助手可用来声明已经或还没有在View对象里设置的模板变量，并设置缺省值。当作参数传递改方法的数组将用来设置缺省值；否则，如果变量不存在，就设置一个空的字符串。

- *fieldset($name, $content, $attribs):* 生成一个 XHTML fieldset. 如果 *$attribs* 包含一个 'legend'
  键，它的值将用于 fieldset legend。 Fieldset 将环绕在 *$content* 周围提供给助手。

- *form($name, $attribs, $content):* 生成一个 XHTML 表单。所有 *$attribs*
  转义和解析成表单标签的 XHTML 属性。如果 *$content* 不以布尔 false
  出现，那么内容就是在表单标签内被解析，如果 *$content* 是布尔 false
  （缺省），只有开头的表单标签被生成。

- *formButton($name, $value, $attribs):* 生成 <button /> 元素;

- *formCheckbox($name, $value, $attribs,$options):* 生成 <input type="checkbox" /> 元素。

  缺省地，当没有提供 $value 并且没有 $options，'0' 被假定为未选的值，'1'为选中的值。
  如果传递 $value，但没有 $options，选中的值就被假定为传递的值。

  $options 应当是数组。如果数组被索引，第一个值就是选中的值，第二个是未选的值，
  所有其它值被忽略。 你也可传递一个带有键为 'checked' 和 'unChecked' 的联合数组。

  如果传递了 $options，如果 $value 匹配选中的值，元素将标记为选中。你也通过传递
  一个布尔值给属性 'checked' 来标记元素为选中或未选。

  上述内容可能最好汇总成一些例子：

  .. code-block::
     :linenos:
     <?php
     // '1' and '0' as checked/unchecked options; not checked
     echo $this->formCheckbox('foo');

     // '1' and '0' as checked/unchecked options; checked
     echo $this->formCheckbox('foo', null, array('checked' => true));

     // 'bar' and '0' as checked/unchecked options; not checked
     echo $this->formCheckbox('foo', 'bar');

     // 'bar' and '0' as checked/unchecked options; checked
     echo $this->formCheckbox('foo', 'bar', array('checked' => true));

     // 'bar' and 'baz' as checked/unchecked options; unchecked
     echo $this->formCheckbox('foo', null, null, array('bar', 'baz');

     // 'bar' and 'baz' as checked/unchecked options; unchecked
     echo $this->formCheckbox('foo', null, null, array(
         'checked' => 'bar',
         'unChecked' => 'baz'
     ));

     // 'bar' and 'baz' as checked/unchecked options; checked
     echo $this->formCheckbox('foo', 'bar', null, array('bar', 'baz');
     echo $this->formCheckbox('foo', null, array('checked' => true), array('bar', 'baz');

     // 'bar' and 'baz' as checked/unchecked options; unchecked
     echo $this->formCheckbox('foo', 'baz', null, array('bar', 'baz');
     echo $this->formCheckbox('foo', null, array('checked' => false), array('bar', 'baz');

  对所有情况，标记预先准备一个带有未选的值的隐藏元素。
  这样，如果值是未选的，你将仍获得有效的返回到表单的值。

- *formErrors($errors, $options):* 生成一个无顺序的 XHTML 列表来显示错误。 *$errors*
  是个字符串或字符串数组； *$options* 是你想放入开头列表标签的任何属性。

  当通过调用助手中的方法时，你可以指定替代的开头，结尾和分隔符：

  - *setElementStart($string)*; 缺省为 '<ul class="errors"%s"><li>', 其中 %s 是在 *$options*
    中被替换的属性。

  - *setElementSeparator($string)*; 缺省为 '</li><li>'。

  - *setElementEnd($string)*; 缺省为 '</li></ul>'。

- *formFile($name, $value, $attribs):* 生成<input type="file" />

- *formHidden($name, $value, $attribs):* 生成<input type="hidden" />

- *formLabel($name, $value, $attribs):* 生成 <label>设置 *for* 属性给 *$name*\ ，实际的标签字符给
  *$value*\ 。 如果 *disable* 传递给 *attribs*\ ，什么都不返回。

- *formMultiCheckbox($name, $value, $attribs, $options, $listsep):* 生成一个 checkboxes 列表。 *$options*
  是个联合数组，可以有任意的深度。 *$value* 可以是单个的值或者是可选的匹配在
  *$options* 数组中的键的一个数组。 *$listsep* 缺省为一个 HTML break ("<br
  />")。缺省地，这个元素被当作数组，所有 checkboxes
  共享同一个名称，并以数组的形式提交。

- *formPassword($name, $value, $attribs):* Creates an <input type="password" /> element.

- *formRadio($name, $value, $attribs, $options):* 生成一系列<input type="button"
  />，每个$options数组元素一个，key为radio的值，并且元素的值是radio的标签。

- *formReset($name, $value, $attribs):* 生成<input type="reset" />

- *formSelect($name, $value, $attribs, $options):*
  生成<select>...</select>其中的每个<option>对应于一个$option数组元素。元素的key是option的值，元素的值是option的标签。$value这个值的option默认为选中。

- *formSubmit($name, $value, $attribs):* 生成<input type="submit" />

- *formText($name, $value, $attribs):* 生成<input type="text" />

- *formTextarea($name, $value, $attribs):* 生成<textarea>...</textarea>

- *url($urlOptions, $name, $reset):* 基于已命名的路由生成URL字符串。 *$urlOptions*
  必须是一个键/值对应的关联数组，用于特定的路由。

- *htmlList($items, $ordered, $attribs):* 基于传递给它的 *$items* 生成无序的和有序的列表。如果
  *$items* 是多维数组，将创建嵌套的列表。

以上helper的使用非常简单，下面是个例子。注意你只需要调用即可，它们会根据需要自己加载并实例化。

.. code-block::
   :linenos:
   <?php
   // 在你的view脚本内部, $this 指向 Zend_View 实例.
   //
   // 假设你已经为select对应的变量$countries指定一系列option值，
   // array('us' => 'United States', 'il' =>
   // 'Israel', 'de' => 'Germany').
   ?>
   <form action="action.php" method="post">
       <p><label>Your Email:
           <?php echo $this->formText('email', 'you@example.com', array('size' => 32)) ?>
       </label></p>
       <p><label>Your Country:
           <?php echo $this->formSelect('country', 'us', null, $this->countries) ?>
       </label></p>
       <p><label>Would you like to opt in?
           <?php echo $this->formCheckbox('opt_in', 'yes', null, array('yes', 'no')) ?>
       </label></p>
   </form>

以上视图脚本会输出这样的结果：

.. code-block::
   :linenos:
   <form action="action.php" method="post">
       <p><label>Your Email:
           <input type="text" name="email" value="you@example.com" size="32" />
       </label></p>
       <p><label>Your Country:
           <select name="country">
               <option value="us" selected="selected">United States</option>
               <option value="il">Israel</option>
               <option value="de">Germany</option>
           </select>
       </label></p>
       <p><label>Would you like to opt in?
           <input type="hidden" name="opt_in" value="no" />
           <input type="checkbox" name="opt_in" value="yes" checked="checked" />
       </label></p>
   </form>

.. include:: zend.view.helpers.action.rst
.. include:: zend.view.helpers.partial.rst
.. include:: zend.view.helpers.placeholder.rst
.. include:: zend.view.helpers.doctype.rst
.. include:: zend.view.helpers.head-link.rst
.. include:: zend.view.helpers.head-meta.rst
.. include:: zend.view.helpers.head-script.rst
.. include:: zend.view.helpers.head-style.rst
.. include:: zend.view.helpers.head-title.rst
.. include:: zend.view.helpers.html-object.rst
.. include:: zend.view.helpers.inline-script.rst
.. include:: zend.view.helpers.json.rst
.. include:: zend.view.helpers.translator.rst
.. _zend.view.helpers.paths:

助手的路径
-----

就像可以指定视图脚本的路径，控制器也可以为 *Zend_View*\
设定助手类的路径。默认地， *Zend_View*\ 会到 “Zend/View/Helper/”下查找助手类。可以用
*setHelperPath()* 和 *addHelperPath()* 方法来告诉 *Zend_View*
从其它地方来找路径。另外，你也可以指定类名的前缀，用于指定助手类所在的路径，允许给助手类命名空间。默认情况下，如果没有给出前缀，会假设使用“Zend_View_Helper_”。

.. code-block::
   :linenos:
   <?php
   $view = new Zend_View();

   // 设置路径为：/path/to/more/helpers, 通过使用前缀 'My_View_Helper'
   $view->setHelperPath('/path/to/more/helpers', 'My_View_Helper');

你可以用 *addHelperPath()*\ 来增加helper的路径， *Zend_View*\
将使用最近增加的路径。这样你可以使用自己的helper。

.. code-block::
   :linenos:
   <?php
   $view = new Zend_View();
   // Add /path/to/some/helpers with class prefix 'My_View_Helper'
   $view->addHelperPath('/path/to/some/helpers', 'My_View_Helper');
   // Add /other/path/to/helpers with class prefix 'Your_View_Helper'
   $view->addHelperPath('/other/path/to/helpers', 'Your_View_Helper');

   // now when you call $this->helperName(), Zend_View will look first for
   // "/path/to/some/helpers/HelperName" using class name "Your_View_Helper_HelperName",
   // then for "/other/path/to/helpers/HelperName.php" using class name "My_View_Helper_HelperName",
   // and finally for "Zend/View/Helper/HelperName.php" using class name "Zend_View_Helper_HelperName".

.. _zend.view.helpers.custom:

编写自定义的助手类
---------

编写自定义的助手类很容易，只要遵循以下几个原则即可：

- helper的类名最后部分必须是helper的名称，并使用混合大小写字格式。例如，你在写一个名为“specialPurpose”的类，类名将至少是"SpecialPurpose"，另外你还应该给类名加上前缀，建议将“View_Helper”作为前缀的一部份：“My_View_Helper_SpecialPurpose”。（注意大小写）你将需要将前缀（包含或不包含下划线）传递给
  *addHelperPath()* 或 *setHelperPath()*\ 。

- 类中必须有一个public的方法，该方法名与helper类名相同。该方法将在你的模板调用"$this->specialPurpose()"时执行。在我们的“specialPurpose”例子中，相应的方法声明可以是“public
  function specialPurpose()”。

- 一般来说，助手类不应该echo或print或有其它形式的输出。它只需要返回值就可以了。返回的数据应当被转义。

- 类文件的命名应该是助手类的名称，比如在"specialPurpose"例子中，文件要存为“SpecialPurpose.php”。

把助手类的文件放在你的助手路径下， *Zend_View*\
就会自动加载，实例化，持久化，并执行。

下面是一个 *SpecialPurpose* 助手代码的例子：

.. code-block::
   :linenos:
   <?php
   class My_View_Helper_SpecialPurpose
   {
       protected $_count = 0;
       public function specialPurpose()
       {
           $this->_count++;
           $output = "I have seen 'The Jerk' {$this->_count} time(s).";
           return htmlspecialchars($output);
       }
   }

在视图代码中，可以调用 *SpecialPurpose* 助手任意次。它将被实例化一次，并且会在
*Zend_View*\ 实例的生命周期内持久存在。

.. code-block::
   :linenos:
   <?php
   // remember, in a view script, $this refers to the Zend_View instance.
   echo $this->specialPurpose();
   echo $this->specialPurpose();
   echo $this->specialPurpose();

输出结果如下所示：

.. code-block::
   :linenos:
   I have seen 'The Jerk' 1 time(s).
   I have seen 'The Jerk' 2 time(s).
   I have seen 'The Jerk' 3 time(s).

有时候需要访问调用 *Zend_View*
对象－例如，如果需要使用已指定的编码字符集，或想解析其它视图脚本作为助手的一部分。为了访问视图对象，助手类应该有一个
*setView($view)* 方法，如下：

.. code-block::
   :linenos:
   <?php
   class My_View_Helper_ScriptPath
   {
       public $view;

       public function setView(Zend_View_Interface $view)
       {
           $this->view = $view;
       }

       public function scriptPath($script)
       {
           return $this->view->getScriptPath($script);
       }
   }

如果助手类有一个 *setView()*
方法，它将在助手类第一次实例化时被调用，并接受当前视图对象作为参数。是否让它在类里持久和如何访问，都完全取决于你。


