.. _zend.view.helpers.initial.inlinescript:

InlineScript 助手
===============

HTML *<script>*
标签用来提供内嵌的客户端脚本，或者链接到远程包含客户端脚本代码的资源。
*InlineScript* 助手允许你管理这两者。它由 :ref:`HeadScript <zend.view.helpers.initial.headscript>`\
派生，并且HeadScript助手的任何方法都可用，唯一不同的是需要用 *inlineScript()* 方法代替
*headScript()*\ 。

.. note::

   **在 HTML Body 里脚本使用 InlineScript**

   如果想在HTML *body*\ 里内嵌脚本，应当使用 *InlineScript*
   。为了加快页面加载速度（特别是使用第三方分析脚本时），把脚本放到文档的尾部是个很好的习惯。

   一些 JS 库必须包含在 HTML *head*\ 部分，对于这些类库请使用 :ref:`HeadScript
   <zend.view.helpers.initial.headscript>` 。


