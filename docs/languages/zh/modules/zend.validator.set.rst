.. EN-Revision: none
.. _zend.validator.set:

标准校验类
=====

Zend Framework 带有一组标准的校验类供你使用。

.. _zend.validator.set.alnum:

Alnum
-----

当且仅当 *$value*\ 只包含字母和数字字符，返回 *true*\
。这个校验器包括一个考虑空白字符是否有效的选项。

.. _zend.validator.set.alpha:

Alpha
-----

当且仅当 *$value*\ 只包含字母字符，返回 *true*\
。这个校验器包括一个考虑空白字符是否有效的选项。

.. _zend.validator.set.barcode:

Barcode
-------

这个校验器是个带有条码类型的实例，条码类型是根据你希望用来校验条码值而定。它目前支持
"*UPC-A*" （通用产品码）和 "*EAN-13*"
（欧洲商品码）条码类型，当且仅当输入成功通过条码校验算法的校验， *isValid()* 返回
true。你应该从输入中删除除了数字0到9（0-9）以外的其它字符，然后传递给校验器。

.. _zend.validator.set.between:

Between
-------

当且仅当 *$value*\ 在最小值和最大值之间，返回 *true*\ 。缺省地，比较包含边界值（
*$value*\
可以等于边界值），尽管为了做精确地比较这个可以被覆盖。所谓精确地比较，就是
*$value*\ 必须大于最小值和小于最大值。

.. _zend.validator.set.ccnum:

Ccnum
-----

当且仅当 *$value*\ 遵循Luhn(mod-10 checksum)算法，返回 *true* 。

.. _zend.validator.set.date:

日期
--

当 *$value*\ 是一个格式为 *YYYY-MM-DD*\ 的有效日期，返回 *true* 。如果 *locale*
选项被设置那么日期将根据locale来校验，如果 *format*
选项被设置成这个格式用来校验。关于选项参数的细节参见 :ref:`Zend\Date\Date::isDate()
<zend.date.others.comparison.table>`\ 。

.. _zend.validator.set.digits:

数字
--

当且仅当 *$value*\ 只包含数字字符，返回 *true*\ 。

.. include:: zend.validator.email-address.rst
.. _zend.validator.set.float:

浮点数
---

当且仅当 *$value*\ 是一个浮点数值，返回 *true*\ 。

.. _zend.validator.set.greater_than:

GreaterThan
-----------

当且仅当 *$value*\ 大于最小值，返回 *true*\ 。

.. _zend.validator.set.hex:

十六进制数
-----

当且仅当 *$value*\ 只包含十六进制的数字字符，返回 *true*\ 。

.. include:: zend.validator.hostname.rst
.. _zend.validator.set.in_array:

InArray
-------

当且仅当一个"needle"*$value*\ 包含在一个"haystack"数组，返回 *true*\ 。如果精确选项是
*true*\ ，那么 *$value*\ 的类型也被检查。

.. _zend.validator.set.int:

整数
--

当且仅当 *$value*\ 是一个有效的整数，返回 *true*\ 。

.. _zend.validator.set.ip:

Ip
--

当且仅当 *$value*\ 是一个有效的IP地址，返回 *true*\ 。

.. _zend.validator.set.less_than:

LessThan
--------

当且仅当 *$value*\ 小于最大值，返回 *true*\ 。

.. _zend.validator.set.not_empty:

NotEmpty
--------

当且仅当 *$value*\ 非空，返回 *true*\ 。

.. _zend.validator.set.regex:

Regex
-----

当且仅当 *$value*\ 匹配一个正则表达式，返回 *true*\ 。

.. _zend.validator.set.string_length:

StringLength
------------

当且仅当字串长度值 *$value*\ 至少是最小值并不大于最大值（当max选项不是 *null*\
），返回 *true*\
。从1.5.0版开始，如果最小长度被设置为一个大于已设定的最大长度的值， *setMin()*\
方法抛出一个异常，并且如果最大长度值被设置为小于一个已设定的最小长度的值，
*setMax()*\ 方法抛出一个异常。从1.0.2版开始，基于 `iconv.internal_encoding`_
的当前值，这个类支持UTF-8和其它字符编码。



.. _`iconv.internal_encoding`: http://www.php.net/manual/en/ref.iconv.php#iconv.configuration
