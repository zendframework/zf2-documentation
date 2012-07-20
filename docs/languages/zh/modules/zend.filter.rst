.. _zend.filter.introduction:

简介
==

Zend_Filter 组件提供了一系列普遍使用的数据过滤器(data
filter)，同时也提供了一个简单的过滤器链机制，使多个过滤器以用户定义的顺序对一个单一的数据进行过滤。

.. _zend.filter.introduction.definition:

什么是过滤器(filter)？
---------------

在现实世界中，过滤器被用来过滤掉输入物中不需要的部分，并期望产出部分输出物（比如，咖啡）。在这样的情景下，过滤器就像是一个操作员，生产出输入物的子集。这种类型的过滤对Web应用程序来说是很有用的－移除非法的输入数据，去除不必要的空格，等等。

这个过滤器基本的定义，可延伸出包括一般化的输入数据的转化。HTML
实体的转义，是Web应用程序中一个普遍的转化。例如，一个表单字段的值附带着不受信任的数据（比如，来自web浏览器的数据），为了防止不期望的行为发生和安全漏洞，这个值应该不包括
HTML 实体，或只包含已转义的 HTML 实体。为了满足这个需求，输入数据中的 HTML
实体被移除或被转义，当然，这得视具体情况而定。过滤器的第一种定义中就涵盖了过滤器移除
HTML 实体的意思－操作员生产出输入数据的一个子集。然而，过滤器也可转义 HTML
实体，转化输入数据（比如，"*&*" 被转义成 "*&amp;*"）。为 Web
开发者支持这样的用例是非常重要的，且在使用Zend_Filter的上下文中，”to
filter”的意思是对输入数据执行一些转化。

.. _zend.filter.introduction.using:

过滤器的基本用法
--------

确立了这样的过滤器定义，为 *Zend_Filter_Interface*
接口奠定了理论基础，需要过滤器类实现一个名为 *filter()* 的方法。

下面一个简单的例子，示范了在2个输入数据上使用过滤器，"*&*" 符号和双引号 (*"*)
字符：

   .. code-block::
      :linenos:

      $htmlEntities = new Zend_Filter_HtmlEntities();

      echo $htmlEntities->filter('&'); // &
      echo $htmlEntities->filter('"'); // "




.. _zend.filter.introduction.static:

使用静态 get() 方法
-------------

如果不方便加载给定的过滤器类和创建过滤器的实例，可以使用静态方法
*Zend_Filter::get()* 作为备用的调用风格。这个方法的第一个参数是数据输入值，将传递给
*filter()* 方法，第二个参数是个字符串，对应于过滤器类的基本名，和 Zend_Filter
名称空间有关。 *get()* 方法自动加载这个类，创建一个实例，并应用 *filter()*
方法给数据输入。

   .. code-block::
      :linenos:

      echo Zend_Filter::get('&', 'HtmlEntities');




如果过滤器类需要，也可以传递一个数组构造参数

   .. code-block::
      :linenos:

      echo Zend_Filter::get('"', 'HtmlEntities', array(ENT_QUOTES));




静态用法对调用过滤器特别方便，但如果对多个输入运行过滤器，按上面第一个例子做更有效，创建一个过滤器对象的实例并调用它的
*filter()* 方法。

并且，Zend_Filter_Input
类允许初始化和运行多重过滤器，按需的校验器类来处理输入数据，参见 :ref:`
<zend.filter.input>`\ 。


