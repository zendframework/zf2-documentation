.. _zend.form.i18n:

Zend_Form 的国际化
======================

开发者日益需要制作网站内容支持多种语言和地区。Zend_Form
把这样的任务变得简单并利用 :ref:`Zend_Translator <zend.translator>` 和 :ref:`Zend_Validate
<zend.validate>` 来完成。

缺省地， *Zend_Form* 不支持国际化（I18n）。要打开在 *Zend_Form* 中的 I18n
功能，需要带适当的适配器实例化一个 *Zend_Translator* 对象，并把它附加到 *Zend_Form*
和/或 *Zend_Validate* 中。参见 :ref:`Zend_Translator 文档 <zend.translator>`
有更多关于生成翻译对象和翻译文件的信息。

.. note::

   **可以对每个元素关闭翻译**

   你可以通过调用 *setDisableTranslator($flag)* 方法或传递 *disableTranslator*
   选项给对象来对任何表单、元素、显示组或子表单关闭翻译。当你想有选择地对独立的元素或一组元素关闭翻译，这个很有用。

.. _zend.form.i18n.initialization:

在表单中初始化 I18n
--------------------------

要在表单中初始化 I18n，你需要或者 *Zend_Translator* 对象或者 *Zend_Translator_Adapter*
对象，详细请见 *Zend_Translator* 文档。一旦你有一个翻译对象，你将有若干选项：

- **Easiest:** 添加它到注册表。Zend Framework 中所有 I18n
  相关的组件将自动发现一个翻译对象（这个对象在注册表中在 'Zend_Translator'
  键之下）并用它翻译和/或本地化：

  .. code-block::
     :linenos:
     <?php
     // use the 'Zend_Translator' key; $translate is a Zend_Translator object:
     Zend_Registry::set('Zend_Translator', $translate);
     ?>
  这将由 *Zend_Form*\ 、 *Zend_Validate* 和 *Zend_View_Helper_Translator* 来获得。

- 如果你所担心的是翻译校验错误消息，可以用 *Zend_Validate_Abstract* 来注册翻译对象：

  .. code-block::
     :linenos:
     <?php
     // Tell all validation classes to use a specific translate adapter:
     Zend_Validate_Abstract::setDefaultTranslator($translate);
     ?>
- 另外，你可以（把它）附加到 *Zend_Form*
  对象作为全局翻译器。这个也有翻译校验错误消息的副作用：

  .. code-block::
     :linenos:
     <?php
     // Tell all form classes to use a specific translate adapter, as well as use
     // this adapter to translate validation error messages:
     Zend_Form::setDefaultTranslator($translate);
     ?>
- 最后，你可以用 *setTranslator()*
  方法附加一个翻译器到一个特定的表单实例或特定的元素：

  .. code-block::
     :linenos:
     <?php
     // Tell *this* form instance to use a specific translate adapter; it will also
     // be used to translate validation error messages for all elements:
     $form->setTranslator($translate);

     // Tell *this* element to use a specific translate adapter; it will also be used
     // to translate validation error messages for this particular element:
     $element->setTranslator($translate);
     ?>
.. _zend.form.i18n.standard:

标准 I18n 目标
------------------

既然你已经附加了翻译对象，那么到底什么是缺省翻译？

- **Validation error messages.** 校验错误消息可以被翻译。使用从 *Zend_Validate*
  校验类来的各种错误代码常数作为消息的 IDs。更多关于这些代码的信息，参见
  :ref:`Zend_Validate <zend.validate>` 文档。

  另外，到 1.6.0 版，你可使用实际的错误消息作为消息识别符来提供翻译。我们倾向在
  1.6.0 版及以上使用这个办法，因为我们在将来的版本中废除消息键翻译。

- **Labels.** 如果翻译存在，元素标签 （labels）将被翻译。

- **Fieldset Legends.**
  显示组和子表单缺省地在字段中解析。字段装饰器在解析字段钱尝试翻译 legend。

- **Form and Element Descriptions.**
  所有表单类型（元素、表单、显示组、子表单）允许指定一个可选的条目描述。描述装饰器可用来解析它，缺省地它将尝试翻译它。

- **Multi-option Values.** 对于各种从 *Zend_Form_Element_Multi* 继承的条目（包括 MultiCheckbox、
  Multiselect 和 Radio
  元素），如果翻译可用，选项值（不是键）将被翻译。这意味着显示给用户的选项标签将被翻译。

- **Submit and Button Labels.**
  各种提交和按钮元素（按钮，提交和重置）将翻译显示给用户的标签。


