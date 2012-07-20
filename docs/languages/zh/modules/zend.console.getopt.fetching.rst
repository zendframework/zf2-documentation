.. _zend.console.getopt.fetching:

读取（Fetching）选项和参数
===================================

在声明 *Zend_Console_Getopt*
对象认可的选项和从命令行或数组提供参数后，可以查询这个对象来找出哪个选项被用户在程序中给定的命令行调用中被指定。这个类实现魔术方法，所以可以用名字来查询选项。

数据的解析被延迟到第一个依靠 *Zend_Console_Getopt*
对象查询是否发现一个选项被给出，然后这个对象来执行解析。它允许在解析发生之前使用若干个方法调用来配置选项、参数、帮助内容和配置选项。

.. _zend.console.getopt.fetching.exceptions:

操作 Getopt 异常
--------------------

如果用户在命令行中给出任何无效选项，解析函数抛出一个 *Zend_Console_Getopt_Exception*\
。你应当在程序代码理捕捉这个异常。可以使用 *parse()*\
方法强制对象来解析参数。这很有用，因为可以在 *try* 块中调用 *parse()*\
。如果通过，解析不再抛出异常。异常的抛出有一个定制的方法 *getUsageMessage()*\
，它作为字符串返回，这个字符串是所有被声明的选项的用法信息。

.. _zend.console.getopt.fetching.exceptions.example:

.. rubric:: 捕捉 Getopt 异常

.. code-block::
   :linenos:

   try {
       $opts = new Zend_Console_Getopt('abp:');
       $opts->parse();
   } catch (Zend_Console_Getopt_Exception $e) {
       echo $e->getUsageMessage();
       exit;
   }


解析抛出异常的情况包括：

- 给出的选项不被认可。

- 选项需要参数，但没有给出。

- 选项参数类型错误。例如，当要求整数却给出一个非数字字符串。

.. _zend.console.getopt.fetching.byname:

通过名字读取 （Fetching）选项
---------------------------------------

可以使用 *getOption()*
方法来查询选项的值。如果选项有一个参数，这个方法返回参数的值。如果选项不带参数但用户的确在命令行中指定了，这个方法返回
*true*\ ，否则，返回 *null*\ 。

.. _zend.console.getopt.fetching.byname.example.setoption:

.. rubric:: 使用 getOption()

.. code-block::
   :linenos:

   $opts = new Zend_Console_Getopt('abp:');
   $b = $opts->getOption('b');
   $p_parameter = $opts->getOption('p');


另外，可以使用魔术函数 *__get()* 来获取选项的值，好像它是类成员变量。 *__isset()*
魔术方法也可以实现。

.. _zend.console.getopt.fetching.byname.example.magic:

.. rubric:: 使用 \__get() 和 \__isset() 魔术方法

.. code-block::
   :linenos:

   $opts = new Zend_Console_Getopt('abp:');
   if (isset($opts->b)) {
       echo "I got the b option.\n";
   }
   $p_parameter = $opts->p; // null if not set


如果选项被带有别名声明，在上面的方法中可以使用任何别名。

.. _zend.console.getopt.fetching.reporting:

报告选项
------------

有若干方法来报告由用户在当前命令行给出的选项的全集。

- 作为字符串：使用 *toString()*\
  方法。选项被返回为用空格分隔的"*flag=value*"对的字符串。没有参数的选项值是字面上的"*true*"。

- 作为数组：使用 *toArray()*\
  方法。选项被返回在一个简单的整数索引的字符串数组，flag
  字符串在参数字符串之后，如果有的话。

- 作为包含JSON数据的字符串：使用 *toJson()* 方法。

- 作为包含 XML 数据的字符串： 使用 *toXml()* 方法。

在上述所有的方法中，flag
字符串是对应于别名列表中的第一个字符串。例如：如果选项别名被声明如"*verbose|v*"，那么第一个字符串，"*verbose*"，被用作选项的规范名称。选项flag的名称不包括任何前面所述的短横线。

.. _zend.console.getopt.fetching.remainingargs:

读取非选项参数
---------------------

在选项参数和它们的参数从命令行中解析后，可能还有另外的参数剩余。可以使用
*getRemainingArgs()*\
方法来查询这些参数。这个方法返回一个不属于任何选项的字符串数组。

.. _zend.console.getopt.fetching.remainingargs.example:

.. rubric:: 使用 getRemainingArgs()

.. code-block::
   :linenos:

   $opts = new Zend_Console_Getopt('abp:');
   $opts->setArguments(array('-p', 'p_parameter', 'filename'));
   $args = $opts->getRemainingArgs(); // returns array('filename')


*Zend_Console_Getopt*\ 支持 GNU
惯例，在参数中包含双短横线表示选项的结尾。在这个符号后面的任何参数必须当作非选项参数。如果有以一个短横线开头的非选项参数，这很有用。例如："``rm
-- -filename-with-dash``"。


