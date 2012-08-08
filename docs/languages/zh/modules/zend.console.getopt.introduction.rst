.. EN-Revision: none
.. _zend.console.getopt.introduction:

Getopt 简介
=========

*Zend_Console_Getopt* 类帮助命令行程序解析它们的选项和参数。

当执行你的程序时，用户可以指定命令行参数。这些参数对程序时有意义的，或改变程序的行为，或选择资源，或详细说明参数。许多选项有传统的意义，例如
"*--verbose*"
对大多数的程序都是允许输出执行细节。一些选项可能对不同的程序有不同的意义。例如
"*-c*" 在 ``grep``\ 、 ``ls`` 和 ``tar`` 里有不同的功能。

下面时一些术语的定义。术语的基本用法变化多样，但本文档使用下面的定义。

- "argument"：在命令之后的字符串。Arguments
  可以时选项或其它不带选项的形式，在命令操作时指出资源。

- "option"：表示命令应该改变其缺省行为的参数。

- "flag"：选项的第一部分，确定选项的意图。传统上 flag 前面有一个或两个短横线 ("*-*"
  或 "*--*")。一个单个的短横引导一个单字符的 flag 或 一组单字符的
  flags。双横线引导一个多字符的 flag。长的 flags 不能组合。

- "parameter"：选项的第二部分，如果它适用于给定的选项，就是随 flag
  带的数据值。例如，许多命令接受 "*--verbose*"
  选项，但一般这个选项没有参数（parameter）。但象 "*--user*"
  的选项几乎总是有一个参数（ parameter ）。

  parameter 可以作为在 flag 参数之后的分离的参数，或作为同一参数串的一部分，从 flag
  里用等号（"*=*"）分开。后者只被长的 flags 支持。例如， *-u username*\ 、 *--user username*
  和 *--user=username* 是被 *Zend_Console_Getopt* 支持的格式。

- "cluster"：在一个单字串参数里的多个单字符 flags
  组合，由单个短横线引导。例如，"``ls -1str``" 使用一组四个短 flags 。这个命令和 "``ls
  -1 -s -t -r``" 相同。只有单个字符 flags 可以被组成组，对长的 flags 不可以组合。

例如，在 "*mysql --user=root mydatabase*" 里，"*mysql*" 是 **命令**\ ，"*--user=root*" 是 **option**\
，"*--user*" 是 **flag**\ ，"*root*" 是 option 的 **parameter**\ ，根据我们的定义 "*mydatabase*" 是
argument 而不是 option 。

*Zend_Console_Getopt* 提供了接口来声明哪个 flags
对你的程序有效，如果使用了无效的flag，则输出错误和用法信息，并报告给你的程序代码。

.. note::

   **Getopt 不是应用程序框架**

   *Zend_Console_Getopt* **不** 不翻译 flags 和 parameters
   的意思，这个类也不实现程序流程或调用程序代码。你必需在你自己的程序代码中实现这些动作。你可以使用
   *Zend_Console_Getopt* 来解析命令行和提供面向对象的方法来查询由用户给定的 options
   ，但使用这些信息去调用程序的部分应当在其它 PHP 类里。

后面的章节描述 *Zend_Console_Getopt* 的用法。


