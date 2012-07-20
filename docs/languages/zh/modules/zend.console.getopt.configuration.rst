.. _zend.console.getopt.configuration:

配置 Zend_Console_Getopt
======================

.. _zend.console.getopt.configuration.addrules:

添加选项规则
------

使用 *addRules()*\ 方法，可以添加更多除了在 *Zend_Console_Getopt*\
构造器中指定的选项规则。 *addRules()*
的参数和给这个类的构造器的第一个参数相同。它可以是符合短语法选项规范的字符串，也可以是符合长选项语法的联合数组。关于选项规范语法的细节参见
:ref:`声明 Getopt 规则 <zend.console.getopt.rules>`\ 。

.. _zend.console.getopt.configuration.addrules.example:

.. rubric:: 使用 addRules()

.. code-block::
   :linenos:

   $opts = new Zend_Console_Getopt('abp:');
   $opts->addRules(
     array(
       'verbose|v' => 'Print verbose output'
     )
   );


上述例子示例添加带有 "*-v*" 别名的 "*--verbose*"
选项给在定义在调用构造器的一组选项。注意你可以在 *Zend_Console_Getopt*\
的同一实例中混合使用短格式选项和长格式选项。

.. _zend.console.getopt.configuration.addhelp:

添加帮助信息
------

除了当声明选项规则为长（语法）格式时指定帮助字符串（帮助信息），也可以用
*setHelp()*\ 方法来联系帮助字符串和选项规则。 *setHelp()*\
方法的参数时一个联合数组，它的键是一个flag，值是一个相应的帮助字符串。

.. _zend.console.getopt.configuration.addhelp.example:

.. rubric:: 使用 setHelp()

.. code-block::
   :linenos:

   $opts = new Zend_Console_Getopt('abp:');
   $opts->setHelp(
       array(
           'a' => 'apple option, with no parameter',
           'b' => 'banana option, with required integer parameter',
           'p' => 'pear option, with optional string parameter'
       )
   );


如果被声明的选项带有别名，可使用任何一个别名来作为联合数组的键。

如果使用短语法声明选项， *setHelp()*\ 方法是定义帮助信息的唯一办法。

.. _zend.console.getopt.configuration.addaliases:

添加选项别名
------

你可以使用 *setAliases*\
方法为选项声明别名。参数是一个联合数组，它的键为一个先前声明的字符串，值是一个相应于那个
flag
的新的别名。这些别名和已存在的别名合并。换句话说，早先声明的别名仍然有效。

一个别名只能声明一次。如果企图重新定义一个别名， *Zend_Console_Getopt_Exception*
将被抛出。

.. _zend.console.getopt.configuration.addaliases.example:

.. rubric:: 使用 setAliases()

.. code-block::
   :linenos:

   $opts = new Zend_Console_Getopt('abp:');
   $opts->setAliases(
       array(
           'a' => 'apple',
           'a' => 'apfel',
           'p' => 'pear'
       )
   );


在上面的例子中，在声明这些别名后，"*-a*"、 "*--apple*" 和 "*--apfel*" 互为别名。"*-p*" 和
"*--pear*" 互为别名。

如果使用短语法声明选项， *setAliases()*\ 方法是定义帮助信息的唯一办法。

.. _zend.console.getopt.configuration.addargs:

添加参数列表
------

缺省地， *Zend_Console_Getopt* 使用 *$_SERVER['argv']*
作为用来解析的命令行参数数组。你可以另外指定参数数组作为第二个构造器参数。最后，你可以用
*addArguments()* 方法追加更多的参数给这些已经使用的参数，或者你可以使用 *setArguments()*
方法替换当前的参数数组。对于这两种情况，这些方法的参数是简单的字符串数组。前者追加数组到当前参数，后者替换当前参数的数组。

.. _zend.console.getopt.configuration.addargs.example:

.. rubric:: 使用 addArguments() 和 setArguments()

.. code-block::
   :linenos:

   // 缺省地，构造器使用 $_SERVER['argv']
   $opts = new Zend_Console_Getopt('abp:');

   // 追加数组给当前参数
   $opts->addArguments(array('-a', '-p', 'p_parameter', 'non_option_arg'));

   // 替换当前的参数
   $opts->setArguments(array('-a', '-p', 'p_parameter', 'non_option_arg'));


.. _zend.console.getopt.configuration.config:

添加配置
----

*Zend_Console_Getopt*
构造器的第三个参数是个影响返回的对象实例行为的配置选项数组。也可以使用
*setOptions()* 方法指定配置选项， 或者用 *setOption()* 方法设置一个独立的选项。

.. note::

   **阐明术语 "option"**

   *Zend_Console_Getopt*\ 类的配置使用术语 "option" 来匹配在Zend Framework
   其它地方使用的术语。这些和 *Zend_Console_Getopt* 类解析的命令行选项不是一回事。

当前支持的选项在类中有常量定义。它们的常量标识符（在括号中的文字）列表如下：

- *Zend_Console_Getopt::CONFIG_DASHDASH* ("dashDash")，如果为 true，允许特殊 flag "*--*" 表示 flag
  的结尾。带有双短横线的符号不被翻译为选项，即使参数以一个短横线开头。这个配置选项缺省为
  true。

- *Zend_Console_Getopt::CONFIG_IGNORECASE* ("ignoreCase")，如果为 true，如果它们不同，使 flags
  互为别名。这样，"*-a*" 和 "*-A*" 将被认为是同义 flags。这个配置选项缺省为 false。

- *Zend_Console_Getopt::CONFIG_RULEMODE*\ ("ruleMode") 可以有 *Zend_Console_Getopt::MODE_ZEND* ("zend") 和
  *Zend_Console_Getopt::MODE_GNU* ("gnu")
  的值。使用这个选项不是必须的除非你用另外的语法形式扩展这个类。这两个方法在
  *Zend_Console_Getopt* 类中明确地支持。如果指定器是字符串， 这个类就假定为 *MODE_GNU*
  ，否则它就假定为 *MODE_ZEND* 。但如果你扩展这个类并添加更多语法形式，
  你需要用这个选项来指定模式。

更多的选项可以将被添加为这个类的增强。

*setOption()* 方法的两个参数是配置选项名称和选项值。

.. _zend.console.getopt.configuration.config.example.setoption:

.. rubric:: 使用 setOption()

.. code-block::
   :linenos:

   $opts = new Zend_Console_Getopt('abp:');
   $opts->setOption('ignoreCase', true);


*setOptions()*
方法的参数是一个联合数组。这个数组的键是配置选项名称，（数组的）值是配置（选项）的值。这也是用于类构造器的数组格式。你指定的配置的值和当前配置合并，不需要列出所有的选项。

.. _zend.console.getopt.configuration.config.example.setoptions:

.. rubric:: 使用 setOptions()

.. code-block::
   :linenos:

   $opts = new Zend_Console_Getopt('abp:');
   $opts->setOptions(
       array(
           'ignoreCase' => true,
           'dashDash'   => false
       )
   );



