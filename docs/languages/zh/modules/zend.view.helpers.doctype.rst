.. _zend.view.helpers.initial.doctype:

文档类型助手（Doctype Helper）
======================

有效的HTML和XHTML文档应当包括一个 *DOCTYPE*
声明。但是文档类型声明很难记忆，而且会影响到文档中的特定元素的解析（例如，在
*<script>* 和 *<style>* 元素中转义的CDATA）。

*Doctype* 助手允许指定下列类型之一：

- *XHTML11*

- *XHTML1_STRICT*

- *XHTML1_TRANSITIONAL*

- *XHTML1_FRAMESET*

- *XHTML_BASIC1*

- *HTML4_STRICT*

- *HTML4_LOOSE*

- *HTML4_FRAMESET*

你也可以指定一个自己定制的带有良好结构的文档类型。

*Doctype*\ 助手是 :ref:`占位符助手 <zend.view.helpers.initial.placeholder>` 的一个具体的实现。

.. _zend.view.helpers.initial.doctype.basicusage:

.. rubric:: Doctype 助手的基本用法

在任何时候都可以指定 doctype。然而，依赖 doctype
输出的助手只在你设置后才认识它，所以最简单的用法是在 bootstrap 脚本中指定：

.. code-block::
   :linenos:

   $doctypeHelper = new Zend_View_Helper_Doctype();
   $doctypeHelper->doctype('XHTML1_STRICT');

然后在布局脚本中输出：

.. code-block::
   :linenos:

   <?php echo $this->doctype() ?>

.. _zend.view.helpers.initial.doctype.retrieving:

.. rubric:: 获取 Doctype

如果需要知道文档类型，可以在由调用助手返回的对象中调用 *getDoctype()*\ 。

.. code-block::
   :linenos:
   <?php
   $doctype = $view->doctype()->getDoctype();
   ?>
很常见地，你需要知道doctype是否XHTML；那么， *isXhtml()*\ 方法已经足够：

.. code-block::
   :linenos:
   <?php
   if ($view->doctype()->isXhtml()) {
       // do something differently
   }
   ?>

