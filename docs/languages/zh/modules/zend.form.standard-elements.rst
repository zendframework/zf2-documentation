.. _zend.form.standardElements:

Zend Framework 带有的标准表单元素
========================

Zend Framework 带有的具体元素类涵盖了大部分的 HTML
表单元素。其中大部分当装饰元素时，指定了特定的视图助手来用，但有一些还提供了另外的功能。下面是这些类的列表，还有它们提供的功能的描述。

.. _zend.form.standardElements.button:

Zend_Form_Element_Button
------------------------

用来生成 HTML 按钮元素， *Zend_Form_Element_Button* 继承 :ref:`Zend_Form_Element_Submit
<zend.form.standardElements.submit>`\ ，并派生它的定制功能。它为装饰指定 'formButton'
视图助手。

像提交元素一样，它使用元素的标签作为元素的值来显示，还句话说，通过设置元素的值来设置按钮上的文字。如果有翻译适配器，标签将显示翻译后的文字。

因为标签用作元素的一部分，但按钮元素只用 :ref:`ViewHelper
<zend.form.standardDecorators.viewHelper>` 和 :ref:`DtDdWrapper <zend.form.standardDecorators.dtDdWrapper>`
装饰器。

在组装和校验表单之后，我们可用 *isChecked()* 方法来检查是否给定的按钮被点击。

.. _zend.form.standardElements.checkbox:

Zend_Form_Element_Checkbox
--------------------------

HTML checkboxes 让你返回一个特定的值，但基本上以布尔来操作：当它被
check，值就被提交；当没有 check，什么都不提交。在内部， *Zend_Form_Element_Checkbox*
强制这个状态。

缺省地，已选的值是 '1'，未选的值是 '0'。你可以通过 *setCheckedValue()* 和
*setUncheckedValue()*
访问器分别来指定使用的值。在内部，任何时候你设置这个值，如果提供的值和已选的值匹配，那就是设置了，但是任何其它的值都可以使未选的值设置了。

另外，设置 checkbox 的 *checked* 属性的值。你可以用 *isChecked()* 或
访问这个属性来查询它。使用 *setChecked($flag)*
方法将设置标志的状态和元素中合适的已选的和未选的值。当设置 checkbox
元素的已选的状态请使用这个方法以确保设置合适的值。

*Zend_Form_Element_Checkbox* 使用 'formCheckbox' 视图助手。已选的值总用来组装它。

.. _zend.form.standardElements.hidden:

Zend_Form_Element_Hidden
------------------------

隐藏元素的数据只提交，用户不用处理。 *Zend_Form_Element_Hidden* 使用 'formHidden'
视图助手来完成它。

.. _zend.form.standardElements.hash:

Zend_Form_Element_Hash
----------------------

该元素提供保护以防止 CSRF
攻击表单，确保提交的数据来自于用户的会话，而不是流氓脚本。保护是通过添加一个哈希（hash）元素给表单并在表单提交时校验它来达成的。

哈希（hash）元素名是唯一的。建议使用 ``salt`` 选项，两个哈希有相同的名字和不同的
salt 会有冲突的：

.. code-block::
   :linenos:
   <?php
   $form->addElement('hash', 'no_csrf_foo', array('salt' => 'unique'));
   ?>
你可以稍后使用 *setSalt($salt)* 方法设置 salt。

在内部，元素用 *Zend_Session_Namespace*
存储一个独一无二的识别符，并在提交的时候检查它（检查 TTL 没有过期）。'Identical'
校验器用于确保提交和哈希和存储的哈希匹配。

'formHidden' 视图助手用来解析在表单中的元素。

.. _zend.form.standardElements.Image:

Zend_Form_Element_Image
-----------------------

图像也可以用作表单元素，并允许你指定图形元素作为表单按钮。

图像需要图像源文件。 *Zend_Form_Element_Image* 让你用 *setImage()* 指定它（或 'image'
配置键）。当提交图像时，你也可以用 *setImageValue()* 访问器（或 'imageValue'
配置键）可选地指定一个值给它来用。当元素值匹配 *imageValue* 时，访问器 *isChecked()*
返回 true。

图像元素使用 :ref:`图像装饰器 <zend.form.standardDecorators.image>` 来解析 （还有标准错误、
HtmlTag 和 Label 装饰器）。你可以可选地指定一个标签（tag）给 *图像*\
装饰器，它将封装图像元素。

.. _zend.form.standardElements.multiCheckbox:

Zend_Form_Element_MultiCheckbox
-------------------------------

你经常会有一组相关的 checkboxes，并且想把结果组成组，这个很像 :ref:`Multiselect
<zend.form.standardElements.multiselect>`\ ，但是这个不是下拉列表，而是需要显示
checkbox/值对。

*Zend_Form_Element_MultiCheckbox* makes this a
snap。像其它继承基础多重元素的元素，你可以指定一个选项列表，并很容易依靠这个列表来校验。'formMultiCheckbox'
视图助手确保这些在表单提交后返回数组。

你可以用下列方法操作各种 checkbox 选项：

- *addMultiOption($option, $value)*

- *addMultiOptions(array $options)*

- *setMultiOptions(array $options)* （重写已存在的选项）

- getMultiOption($option)

- getMultiOptions()

- *removeMultiOption($option)*

- *clearMultiOptions()*

为了标记选中的条目，需要传递一个数组给 *setValue()* 。下面代码片段将检查 "bar" 和
"bat":

.. code-block::
   :linenos:

   $element = new Zend_Form_Element_MultiCheckbox('foo', array(
       'multiOptions' => array(
           'foo' => 'Foo Option',
           'bar' => 'Bar Option',
           'baz' => 'Baz Option',
           'bat' => 'Bat Option',
       );
   ));

   $element->setValue(array('bar', 'bat'));

注意即使是设置一个单个的值，也必需传递一个数组。

.. _zend.form.standardElements.multiselect:

Zend_Form_Element_Multiselect
-----------------------------

XHTML *select* 元素允许一个 'multiple' 属性，表明可以提交多重选项，而不是一个。
*Zend_Form_Element_Multiselect* 继承 :ref:`Zend_Form_Element_Select <zend.form.standardElements.select>`
并设置 *multiple* 属性为 'multiple' 。像其它从 *Zend_Form_Element_Multi*
基础类继承的类一样，你可以使用下列函数来处理选项的选择：

- *addMultiOption($option, $value)*

- *addMultiOptions(array $options)*

- *setMultiOptions(array $options)* （重写已存在的选项）

- getMultiOption($option)

- getMultiOptions()

- *removeMultiOption($option)*

- *clearMultiOptions()*

如果翻译适配器随表单和/或元素注册，选项值将被翻译用于显示。

.. _zend.form.standardElements.password:

Zend_Form_Element_Password
--------------------------

密码元素基本上是普通的文本元素 －－
除了你不想它以错误消息的形式显示或重新显示表单的时候显示出来。

*Zend_Form_Element_Password*
在每个校验器（确保密码在校验器错误消息上是不透明的）通过调用 *setValueObscured(true)*
和使用 'formPassword' 视图助手（它不显示传递给它的值）来完成它。

.. _zend.form.standardElements.radio:

Zend_Form_Element_Radio
-----------------------

Radio 元素让你指定若干选项，而你只需要一个返回值。 *Zend_Form_Element_Radio* 继承基础类
*Zend_Form_Element_Multi*\ ，让你指定若干选项并使用 *formRadio* 视图助手来显示。

像其它所有继承多重元素基础类的元素，下列方法可用来处理 radio 选项的显示：

- *addMultiOption($option, $value)*

- *addMultiOptions(array $options)*

- *setMultiOptions(array $options)* （重写已存在的选项）

- getMultiOption($option)

- getMultiOptions()

- *removeMultiOption($option)*

- *clearMultiOptions()*

.. _zend.form.standardElements.reset:

Zend_Form_Element_Reset
-----------------------

Reset
按钮一般用于清理表单，而不是要提交的数据。然而，因为它们用于显示，所以它们属于标准元素。

*Zend_Form_Element_Reset* 继承 :ref:`Zend_Form_Element_Submit <zend.form.standardElements.submit>`\
。这样，标签（label）用于按钮显示，如果有翻译适配器，显示的内容就被翻译。它只使用
'ViewHelper' 和 'DtDdWrapper'装饰器，因为绝对不会有错误消息，也不会有标签（label）。

.. _zend.form.standardElements.select:

Zend_Form_Element_Select
------------------------

Select boxes 是限定从给定数据里选择的一个通用的办法。 *Zend_Form_Element_Select*
让你迅速简便地完成它。

因为它继承基础多重元素，下列方法可用来处理选择选项：

- *addMultiOption($option, $value)*

- *addMultiOptions(array $options)*

- *setMultiOptions(array $options)* (overwrites existing options)

- getMultiOption($option)

- getMultiOptions()

- *removeMultiOption($option)*

- *clearMultiOptions()*

*Zend_Form_Element_Select* 使用 'formSelect' 视图助手来装饰。

.. _zend.form.standardElements.submit:

Zend_Form_Element_Submit
------------------------

提交按钮用于提交表单。你可以使用多个提交按钮，你可以使用按钮提交表单来决定哪个动作处理提交的数据。
*Zend_Form_Element_Submit* 通过添加 *isChecked()*\
方法使决定变得容易。因为只有一个按钮由表单来提交，在处理和校验表单之后，你可以在每个提交按钮上调用这个方法来确定使用了哪个。

*Zend_Form_Element_Submit* 使用标签作为提交按钮的 "value"，如果有翻译适配器就翻译它。
*isChecked()* 为了确定是否使用了该按钮，依靠标签（label）来检查提交的值。

:ref:`ViewHelper <zend.form.standardDecorators.viewHelper>` 和 :ref:`DtDdWrapper
<zend.form.standardDecorators.dtDdWrapper>`
装饰器解析元素。没有使用标签（label）装饰器，因为当解析元素时使用了按钮标签，一般地，对于提交元素不需要错误（代码或消息）。

.. _zend.form.standardElements.text:

Zend_Form_Element_Text
----------------------

到目前为止，大部分流行的表单元素是文本元素，对于有限的文本输入，对大部分数据输入来说是个理想的元素。
*Zend_Form_Element_Text* 使用 'formText' 视图助手来显示元素。

.. _zend.form.standardElements.textarea:

Zend_Form_Element_Textarea
--------------------------

Textareas
用于大量的文本处理，对提交的文本的长度没有限制（除非你的服务器或PHP有限制）。
*Zend_Form_Element_Textarea* 使用 'textArea' 视图助手来显示元素，值就是元素的内容。


