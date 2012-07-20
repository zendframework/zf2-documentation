.. _zend.filter.set:

标准过滤器类
======

Zend Framework 带有一组标准的过滤器。

.. _zend.filter.set.alnum:

Alnum
-----

返回只保留字母和数字的字符串 *$value*\ ，这个过滤器包括一个允许空白字符的选项。

.. _zend.filter.set.alpha:

Alpha
-----

返回只保留字母的字符串 *$value*\ ，这个过滤器包括一个允许空白字符的选项。

.. _zend.filter.set.basename:

BaseName
--------

给定包含一个文件的路径字符串，这个过路器将返回这个文件的基本名（base name）。

.. _zend.filter.set.digits:

Digits
------

返回只保留数字的字符串 *$value*\ 。

.. _zend.filter.set.dir:

Dir
---

返回路径的名字部分。

.. _zend.filter.set.htmlentities:

HtmlEntities
------------

返回转换成它们对应 HTML 实体的字符串 *$value*\ 。

.. _zend.filter.set.int:

Int
---

返回整数 *$value*\ 。

.. _zend.filter.set.stripnewlines:

StripNewlines
-------------

返回不带任何新行控制符的字符串 *$value* 。

.. _zend.filter.set.realpath:

RealPath
--------

扩展所有符号的链接和解析指向在输入路径里的 '/./', '/../' 和额外的 '/'
字符并且返回规范化后的绝对路径名，返回的结果路径将没有符号链接 '/./' 或 '/../'
部分。

如果失败，例如文件不存在， *Zend_Filter_RealPath* 将返回 *FALSE*\ 。在 BSD
系统，如果只有路径最后部分不存在， *Zend_Filter_RealPath* 不会失败，但其它系统返回
*FALSE*\ 。

.. _zend.filter.set.stringtolower:

StringToLower
-------------

返回按需转换字母成小写的字符串 *$value*\ 。

.. _zend.filter.set.stringtoupper:

StringToUpper
-------------

返回按需转换字母成大写的字符串 *$value*\ 。

.. _zend.filter.set.stringtrim:

StringTrim
----------

返回从头到尾整理过的字符串 *$value*\ 。

.. _zend.filter.set.striptags:

StripTags
---------

返回把 HTML 和 PHP
标签已剥离的（声明为允许的标签不会剥离）输入的字符串。除了能指定允许哪个标签，开发者也可以在所有允许的标签（或只对特定的标签）中指定哪个属性被允许。最后，这个过滤器提供控制是否注释（如
*<!-- ... -->*\ ）被删除或允许。


