.. _zend.view.helpers.initial.object:

HTML 对象助手
=========

HTML *<object>* 元素在网页里用于嵌入媒体如 Flash 或 QuickTime。
对象视图助手用最小的代价来帮助嵌入媒体。

有四个初始的对象助手：

- *formFlash* 为嵌入 Flash 文件生成 markup。

- *formObject* 为嵌入定制对象生成 markup。

- *formPage* 为嵌入其它 (X)HTML 页面生成 markup。

- *formQuicktime* 为嵌入 QuickTime 文件生成 markup。

所有这些助手使用相似的接口。这样，本文档只包含两个助手的例子。

.. _zend.view.helpers.initial.object.flash:

.. rubric:: Flash 助手

使用助手嵌入 Flash 到你的页面相当简单。唯一需要的参数是资源 URI。

.. code-block:: php
   :linenos:

   <?php echo $this->htmlFlash('/path/to/flash.swf'); ?>
它输出下列 HTML:

.. code-block:: php
   :linenos:

   <object data="/path/to/flash.swf" type="application/x-shockwave-flash"
       classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
       codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab">
   </object>

另外你可以指定可以和 *<object>* 一起解析的属性、参数和内容。 这个用 *htmlObject*
助手来示范。

.. _zend.view.helpers.initial.object.object:

.. rubric:: 通过传递另外的参数来定制对象

对象助手里的第一个参数总是必需的，它是你想嵌入的资源的 URI。 第二个参数只对
*htmlObject* 助手是必需的，其它助手对这个参数已经有了正确的值。
第三个参数用来传递属性到对象元素，它只接受带有key-value对的数组， *classid* 和
*codebase* 是这个属性的例子。 第四个参数也用带有key-value对的数组并用它们生成 *<param>*
元素，你将很快看到一个这样的例子。
最后一个是提供另外的内容给对象的选项。来看一下使用所有参数的例子。

.. code-block:: php
   :linenos:

   echo $this->htmlObject(
       '/path/to/file.ext',
       'mime/type',
       array(
           'attr1' => 'aval1',
           'attr2' => 'aval2'
       ),
       array(
           'param1' => 'pval1',
           'param2' => 'pval2'
       ),
       'some content'
   );

   /*
   这将输出:

   <object data="/path/to/file.ext" type="mime/type"
       attr1="aval1" attr2="aval2">
       <param name="param1" value="pval1" />
       <param name="param2" value="pval2" />
       some content
   </object>
   */


