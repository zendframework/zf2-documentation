.. _zend.layout.introduction:

简介
==

*Zend_Layout*\
实现经典的两步视图模型，允许开发者把应用程序内容包装在另一个视图，通常是站点的模板。这样的模板被其它项目在术语上称之为
**layouts**\ 。Zend Framework采用这个术语以保持一致性。

*Zend_Layout*\ 的主要目标如下：

- 当和Zend Framework MVC 组件一起使用时自动选择和布局的解析（rendering）.

- 为布局相关的变量和内容提供分离的范围。

- 允许配置包括布局名称、布局脚本分解（变形）、布局脚本路径。

- 允许禁止布局、修改布局脚本和其它状态；允许这些在动作控制器和视图脚本里的动作。

- 象 :ref:`ViewRenderer <zend.controller.actionhelpers.viewrenderer>`
  一样遵循相同的脚本分解规则（变形），但允许它们也使用不同的规则。

- 允许在没有 Zend Framework MVC 组件的情况下使用。


