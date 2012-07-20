.. _zend.console.getopt.rules:

声明 Getopt 规则
============

*Zend_Console_Getopt*
类的构造器带有一到三个参数。第一个参数声明哪个选项被应用程序支持。这个类支持交替（alternative）语法形式来声明选项。参见下面的章节关于这些语法形式的格式和用法。

构造器带有的另外两个参数都是可选的。第二个参数可以包含命令行参数，缺省为
*$_SERVER['argv']* 。

第三个参数包含一个配置选项来定制 *Zend_Console_Getopt*
的行为（behavior）。关于可用选项的引用（reference），参见 :ref:`添加配置
<zend.console.getopt.configuration.config>`

.. _zend.console.getopt.rules.short:

用短语法声明选项
--------

*Zend_Console_Getopt* 支持紧凑的语法 （类似用于 GNU Getopt的语法，参见
`http://www.gnu.org/software/libc/manual/html_node/Getopt.html`_ ）。这个语法只支持单字符 flag
。在一个单个的字符串中，每个字母对应于被程序支持的 flag。字母后跟着冒号 ("*:*")
表示这个 flag 需要参数。

.. _zend.console.getopt.rules.short.example:

.. rubric:: 使用短语法

.. code-block::
   :linenos:

   $opts = new Zend_Console_Getopt('abp:');


上面的例子示例使用 *Zend_Console_Getopt* 来声明选项，这个选项也可以以 "*-a*"、"*-b*" 或
"*-p*"的形式给出。后面的 flag 需要一个参数。

短语法限于单个字符的flag。别名，参数类型和帮助字符串不被短语法支持。

.. _zend.console.getopt.rules.long:

用长语法声明选项
--------

带有更多功能的不同的语法也是可用的。这个语法允许为 flag
指定别名、选项参数的类型和用来描述用法的帮助字符串。在短语法中使用单字符串来声明选项，而在常语法中使用联合数组作为构造器的第一个参数。

联合数组的每个元素的键是一个字符串，这个字符串带有给flag命名的格式，用管道符号("*|*")来隔离每个别名。在这些别名后面，如果选项需要参数，则用等号("*=*")和紧跟一个字母来表示参数的
**类型**\ ：

- "*=s*" 表示字符串参数

- "*=w*" 表示一个字的参数（不包含空白的字符串）

- "*=i*" 表示整数参数

如果参数是可选的，使用短横线 ("*-*")而不使用等号。

在联合数组中的每个元素的值是帮助字符串，用来描述如何使用程序。

.. _zend.console.getopt.rules.long.example:

.. rubric:: 使用长语法

.. code-block::
   :linenos:

   $opts = new Zend_Console_Getopt(
     array(
       'apple|a'    => 'apple option, with no parameter',
       'banana|b=i' => 'banana option, with required integer parameter',
       'pear|p-s'   => 'pear option, with optional string parameter'
     )
   );


在上面的声明例子中，有三个选项："*--apple*" 和 "*-a*" 互为别名，不带参数；"*--banana*"
and "*-b*" 互为别名，带有强制的整形参数；最后，"*--pear*" and "*-p*"
互为别名，带有可选的字符串参数。



.. _`http://www.gnu.org/software/libc/manual/html_node/Getopt.html`: http://www.gnu.org/software/libc/manual/html_node/Getopt.html
