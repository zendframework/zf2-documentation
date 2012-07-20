.. _zend.currency.introduction:

Zend_Currency 简介
================

*Zend_Currency* 是Zend_Framework I18n
核心的一部分。它处理所有关于货币、钱的表示和格式。它也提供另外的信息方法，包括货币的本地化信息、关于哪个货币在哪个地区使用等等。

.. _zend.currency.introduction.list:

为什么使用 Zend_Currency ？
---------------------

*Zend_Currency* 提供了下列函数来处理货币和钱相关的工作。

- **完全本地支持**

  *Zend_Currency* 支持所有有效地区并因此有能力知道超过 100
  中不同的本地货币信息，包括例如货币名称、缩写、钱的符合等等。

- **可重用的货币定义**

  *Zend_Currency* 不包括货币的值。这就是为什么它的函数不包括在 *Zend_Locale_Format*
  里，但好处是已经定义的货币表示可以被重用。

- **Fluent 接口**

  *Zend_Currency* 按需包含 fluent 接口。

- **另外的信息方法**

  *Zend_Currency*
  包括另外的方法，这方法提供关于哪个地区使用哪种货币或哪种货币被用于被定义的地区的信息。


