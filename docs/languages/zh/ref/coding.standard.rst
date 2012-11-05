.. EN-Revision: none
.. _coding-standard:

*************************
Zend Framework 的 PHP 编码标准
*************************

.. _coding-standard.overview:

绪论
--

.. _coding-standard.overview.scope:

适用范围
^^^^

本文档提供的代码格式和文档的指南是给参与 Zend Framework
的个人和团队使用的，许多使用 Zend Framework 的开发者
也发现编码标准很有用，因为他们的代码风格和 Zend Framework
的代码保持一致。值得注意的是它要求切实努力来全面 详细说明编码标准。
注：有时候开发者认为在最详细的设计级别上标准的建立比标准所建议的更重要。Zend
Framework 编码标准的指南 实践上很好地工作于 ZF 项目。你可以根据我们的 `license`_
中的条款来修改或使用它们。

ZF 编码标准的话题包括：



   - PHP File 文件格式

   - 命名约定

   - 编码风格

   - 注释文档



.. _coding-standard.overview.goals:

目标
^^

编码标准对任何开发项目都很重要，特别是很多开发者在同一项目上工作。编码标准帮助确保代码的高质量、少
bug 和容易维护。

.. _coding-standard.php-file-formatting:

PHP File 文件格式
-------------

.. _coding-standard.php-file-formatting.general:

常规
^^

对于只包含有 PHP
代码的文件，结束标志（"?>"）是不允许存在的，PHP自身不需要（"?>"）, 这样做,
可以防止它的末尾的被意外地注入相应。

**重要：** 由 *__HALT_COMPILER()* 允许的任意的二进制代码的内容被 Zend Framework 中的 PHP
文件或由它们产生的文件禁止。 这个功能的使用只对一些安装脚本开放。

.. _coding-standard.php-file-formatting.indentation:

缩进
^^

缩进由四个空格组成，禁止使用制表符 TAB 。

.. _coding-standard.php-file-formatting.max-line-length:

行的最大长度
^^^^^^

一行 80 字符以内是比较合适，就是说，ZF
的开发者应当努力在可能的情况下保持每行代码少于 80
个字符，在有些情况下，长点也可以, 但最多为 120 个字符。

.. _coding-standard.php-file-formatting.line-termination:

行结束标志
^^^^^

行结束标志遵循 Unix
文本文件的约定，行必需以单个换行符（LF）结束。换行符在文件中表示为
10，或16进制的 0x0A。

注：不要使用 苹果操作系统的回车（0x0D）或 Windows
电脑的回车换行组合如（0x0D,0x0A）。

.. _coding-standard.naming-conventions:

命名约定
----

.. _coding-standard.naming-conventions.classes:

类
^

Zend Framework 的类命名总是对应于其所属文件的目录结构的，ZF 标准库的根目录是
“Zend/”，ZF 特别（extras）库的根目录是 "ZendX/"，所有 Zend Framework
的类在其下按等级存放。

类名只允许有字母数字字符，在大部分情况下不鼓励使用数字。下划线只允许做路径分隔符；例如
Zend/Db/Table.php 文件里对应的类名称是 Zend\Db\Table。

如果类名包含多个单词，每个单词的第一个字母必须大写，连续的大写是不允许的，例如
“ZendPDF” 是不允许的，而 "ZendPdf" 是可接受的。

这些约定为 Zend Framework
定义了一个伪命名空间机制。如果对开发者在他们的程序中切实可行，Zend Framework
将采用 PHP 命名空间特性（如果有的话）。

参见在标准和特别库中类名作为类名约定的例子。 **重要：** 依靠 ZF
库展开的代码，但又不是标准或特别库的一部分（例如程序代码或不是 Zend
发行的库），不要以 "Zend\_" 或 "ZendX\_" 开头。

.. _coding-standard.naming-conventions.filenames:

文件名
^^^

对于其它文件，只有字母数字字符、下划线和短横线（"-"）可用，空格是绝对不允许的。

包含任何 PHP 代码的任何文件应当以 ".php"
扩展名结尾，众所周知的视图脚本除外。下面这些例子给出 Zend Framework
类可接受的文件名：

   .. code-block:: php
      :linenos:

      Zend/Db.php

      Zend/Controller/Front.php

      Zend/View/Helper/FormRadio.php

文件名必须遵循上述的对应类名的规则。

.. _coding-standard.naming-conventions.functions-and-methods:

函数和方法
^^^^^

函数名只包含字母数字字符，下划线是不允许的。数字是允许的但大多数情况下不鼓励。

函数名总是以小写开头，当函数名包含多个单词，每个子的首字母必须大写，这就是所谓的
“驼峰” 格式。

我们一般鼓励使用冗长的名字，函数名应当长到足以说明函数的意图和行为。

这些是可接受的函数名的例子：

   .. code-block:: php
      :linenos:

      filterInput()

      getElementById()

      widgetFactory()



对于面向对象编程，实例或静态变量的访问器总是以 "get" 或 "set"
为前缀。在设计模式实现方面，如单态模式（singleton）或工厂模式（factory），
方法的名字应当包含模式的名字，这样名字更能描述整个行为。

在对象中的方法，声明为 "private" 或 "protected" 的，
名称的首字符必须是一个单个的下划线，这是唯一的下划线在方法名字中的用法。声明为
"public" 的从不包含下划线。

全局函数 (如："floating functions")
允许但大多数情况下不鼓励，建议把这类函数封装到静态类里。

.. _coding-standard.naming-conventions.variables:

变量
^^

变量只包含数字字母字符，大多数情况下不鼓励使用数字，下划线不接受。

声明为 "private" 或 "protected"
的实例变量名必须以一个单个下划线开头，这是唯一的下划线在程序中的用法，声明为
"public" 的不应当以下划线开头。

对函数名（见上面 3.3
节）一样，变量名总以小写字母开头并遵循“驼峰式”命名约定。

我们一般鼓励使用冗长的名字，这样容易理解代码，开发者知道把数据存到哪里。除非在小循环里，不鼓励使用简洁的名字如
"$i" 和 "$n" 。如果一个循环超过 20
行代码，索引的变量名必须有个具有描述意义的名字。

.. _coding-standard.naming-conventions.constants:

常量
^^

常量包含数字字母字符和下划线，数字允许作为常量名。

常量名的所有字母必须大写。

常量中的单词必须以下划线分隔，例如可以这样 *EMBED_SUPPRESS_EMBED_EXCEPTION* 但不许这样
*EMBED_SUPPRESSEMBEDEXCEPTION*\ 。

常量必须通过 "const" 定义为类的成员，强烈不鼓励使用 "define" 定义的全局常量。

.. _coding-standard.coding-style:

编码风格
----

.. _coding-standard.coding-style.php-code-demarcation:

PHP 代码划分（Demarcation）
^^^^^^^^^^^^^^^^^^^^^

PHP 代码总是用完整的标准的 PHP 标签定界：

   .. code-block:: php
      :linenos:

      <?php

      ?>


短标签（ ）是不允许的，只包含 PHP 代码的文件，不要结束标签 （参见 :ref:`
<coding-standard.php-file-formatting.general>`\ ）。

.. _coding-standard.coding-style.strings:

字符串
^^^

.. _coding-standard.coding-style.strings.literals:

字符串文字
^^^^^

当字符串是文字(不包含变量)，应当用单引号（ apostrophe ）来括起来：

   .. code-block:: php
      :linenos:

      $a = 'Example String';



.. _coding-standard.coding-style.strings.literals-containing-apostrophes:

包含单引号（'）的字符串文字
^^^^^^^^^^^^^^

当文字字符串包含单引号（apostrophe ）就用双引号括起来，特别在 SQL 语句中有用：

   .. code-block:: php
      :linenos:

      $sql = "SELECT `id`, `name` from `people` WHERE `name`='Fred' OR `name`='Susan'";

在转义单引号时，上述语法是首选的，因为很容易阅读。

.. _coding-standard.coding-style.strings.variable-substitution:

变量替换
^^^^

变量替换有下面这些形式：

   .. code-block:: php
      :linenos:

      $greeting = "Hello $name, welcome back!";

      $greeting = "Hello {$name}, welcome back!";



为保持一致，这个形式不允许：

   .. code-block:: php
      :linenos:

      $greeting = "Hello ${name}, welcome back!";



.. _coding-standard.coding-style.strings.string-concatenation:

字符串连接
^^^^^

字符串必需用 "." 操作符连接，在它的前后加上空格以提高可读性：

   .. code-block:: php
      :linenos:

      $company = 'Zend' . ' ' . 'Technologies';



当用 "."
操作符连接字符串，鼓励把代码可以分成多个行，也是为提高可读性。在这些例子中，每个连续的行应当由
whitespace 来填补，例如 "." 和 "=" 对齐：

   .. code-block:: php
      :linenos:

      $sql = "SELECT `id`, `name` FROM `people` "
           . "WHERE `name` = 'Susan' "
           . "ORDER BY `name` ASC ";



.. _coding-standard.coding-style.arrays:

数组
^^

.. _coding-standard.coding-style.arrays.numerically-indexed:

数字索引数组
^^^^^^

索引不能为负数

建议数组索引从 0 开始。

当用 *array* 函数声明有索引的数组，在每个逗号的后面间隔空格以提高可读性：

   .. code-block:: php
      :linenos:

      $sampleArray = array(1, 2, 3, 'Zend', 'Studio');



可以用 "array" 声明多行有索引的数组，在每个连续行的开头要用空格填补对齐：

   .. code-block:: php
      :linenos:

      $sampleArray = array(1, 2, 3, 'Zend', 'Studio',
                           $a, $b, $c,
                           56.44, $d, 500);



.. _coding-standard.coding-style.arrays.associative:

关联数组
^^^^

当用声明关联数组， *array*
我们鼓励把代码分成多行，在每个连续行的开头用空格填补来对齐键和值：

   .. code-block:: php
      :linenos:

      $sampleArray = array('firstKey'  => 'firstValue',
                           'secondKey' => 'secondValue');



.. _coding-standard.coding-style.classes:

类
^

.. _coding-standard.coding-style.classes.declaration:

类的声明
^^^^

用 Zend Framework 的命名约定来命名类。

花括号应当从类名下一行开始(the "one true brace" form)。

每个类必须有一个符合 PHPDocumentor 标准的文档块。

类中所有代码必需用四个空格的缩进。

每个 PHP 文件中只有一个类。

放另外的代码到类里允许但不鼓励。在这样的文件中，用两行空格来分隔类和其它代码。

下面是个可接受的类的例子： // 459 9506 － 441 9658 下次从这里开始

   .. code-block:: php
      :linenos:

      /**
       * Documentation Block Here
       */
      class SampleClass
      {
          // 类的所有内容
          // 必需缩进四个空格
      }



.. _coding-standard.coding-style.classes.member-variables:

类成员变量
^^^^^

必须用Zend Framework的变量名约定来命名类成员变量。

变量的声明必须在类的顶部，在方法的上方声明。

不允许使用 *var* （因为 ZF 是基于 PHP 5 的 ），要用 *private*\ 、 *protected* 或 *public*\ 。
直接访问 public 变量是允许的但不鼓励，最好使用访问器 （set/get）。

.. _coding-standard.coding-style.functions-and-methods:

函数和方法
^^^^^

.. _coding-standard.coding-style.functions-and-methods.declaration:

函数和方法声明
^^^^^^^

必须用Zend Framework的函数名约定来命名函数。

在类中的函数必须用 *private*\ 、 *protected* 或 *public* 声明它们的可见性。

象类一样，花括号从函数名的下一行开始(the "one true brace" form)。

函数名和括参数的圆括号中间没有空格。

强烈反对使用全局函数。

下面是可接受的在类中的函数声明的例子：

   .. code-block:: php
      :linenos:

      /**
       * Documentation Block Here
       */
      class Foo
      {
          /**
           * Documentation Block Here
           */
          public function bar()
          {
              // 函数的所有内容
              // 必需缩进四个空格
          }
      }



**注：** 传址（Pass-by-reference）是在方法声明中允许的唯一的参数传递机制。

   .. code-block:: php
      :linenos:

      /**
       * Documentation Block Here
       */
      class Foo
      {
          /**
           * Documentation Block Here
           */
          public function bar(&$baz)
          {}
      }



传址在调用时是严格禁止的。

返回值不能在圆括号中，这妨碍可读性而且如果将来方法被修改成传址方式，代码会有问题。


   .. code-block:: php
      :linenos:

      /**
       * Documentation Block Here
       */
      class Foo
      {
          /**
           * WRONG
           */
          public function bar()
          {
              return($this->bar);
          }

          /**
           * RIGHT
           */
          public function bar()
          {
              return $this->bar;
          }
      }



.. _coding-standard.coding-style.functions-and-methods.usage:

函数和方法的用法
^^^^^^^^

函数的参数应当用逗号和紧接着的空格分开，下面可接受的调用的例子中的函数带有三个参数：


   .. code-block:: php
      :linenos:

      threeArguments(1, 2, 3);



传址方式在调用的时候是严格禁止的，参见函数的声明一节如何正确使用函数的传址方式。

带有数组参数的函数，函数的调用可包括 "array"
提示并可以分成多行来提高可读性，同时，书写数组的标准仍然适用：

   .. code-block:: php
      :linenos:

      threeArguments(array(1, 2, 3), 2, 3);

      threeArguments(array(1, 2, 3, 'Zend', 'Studio',
                           $a, $b, $c,
                           56.44, $d, 500), 2, 3);



.. _coding-standard.coding-style.control-statements:

控制语句
^^^^

.. _coding-standard.coding-style.control-statements.if-else-elseif:

if/Else/Elseif
^^^^^^^^^^^^^^

使用 *if* and *elseif* 的控制语句在条件语句的圆括号前后都必须有一个空格。

在圆括号里的条件语句，操作符必须用空格分开，鼓励使用多重圆括号以提高在复杂的条件中划分逻辑组合。

前花括号必须和条件语句在同一行，后花括号单独在最后一行，其中的内容用四个空格缩进。


   .. code-block:: php
      :linenos:

      if ($a != 2) {
          $a = 2;
      }



对包括"elseif" 或 "else"的 "if" 语句，和 "if" 结构的格式类似， 下面的例子示例 "if"
语句， 包括 "elseif" 或 "else" 的格式约定：

   .. code-block:: php
      :linenos:

      if ($a != 2) {
          $a = 2;
      } else {
          $a = 7;
      }


      if ($a != 2) {
          $a = 2;
      } elseif ($a == 3) {
          $a = 4;
      } else {
          $a = 7;
      }

在有些情况下， PHP 允许这些语句不用花括号，但在(ZF) 代码标准里，它们（"if"、
"elseif" 或 "else" 语句）必须使用花括号。

"elseif" 是允许的但强烈不鼓励，我们支持 "else if" 组合。

.. _coding-standards.coding-style.control-statements.switch:

Switch
^^^^^^

在 "switch" 结构里的控制语句在条件语句的圆括号前后必须都有一个单个的空格。

"switch" 里的代码必须有四个空格缩进，在"case"里的代码再缩进四个空格。

.. code-block:: php
   :linenos:

   switch ($numPeople) {
       case 1:
           break;

       case 2:
           break;

       default:
           break;
   }

*switch* 语句应当有 *default*\ 。

**注：** 有时候，在 falls through 到下个 case 的 *case* 语句中不写 *break* or *return* 很有用。
为了区别于 bug，任何 *case* 语句中，所有不写 *break* or *return* 的地方应当有一个 "// break
intentionally omitted" 这样的注释来表明 break 是故意忽略的。

.. _coding-standards.inline-documentation:

注释文档
^^^^

.. _coding-standards.inline-documentation.documentation-format:

格式
^^

所有文档块 ("docblocks") 必须和 phpDocumentor 格式兼容，phpDocumentor
格式的描述超出了本文档的范围，关于它的详情，参考： `http://phpdoc.org/`_\ 。

所有类文件必须在文件的顶部包含文件级 （"file-level"）的 docblock
，在每个类的顶部放置一个 "class-level" 的 docblock。下面是一些例子：

.. _coding-standards.inline-documentation.files:

文件
^^

每个包含 PHP 代码的文件必须至少在文件顶部的 docblock 包含这些 phpDocumentor 标签：

   .. code-block:: php
      :linenos:

      /**
       * 文件的简短描述
       *
       * 文件的详细描述（如果有的话）... ...
       *
       * LICENSE: 一些 license 信息
       *
       * @copyright  Copyright (c) 2005-2012 Zend Technologies USA Inc. (http://www.zend.com)
       * @license    http://framework.zend.com/license/3_0.txt   BSD License
       * @link       http://framework.zend.com/package/PackageName
       * @since      File available since Release 1.5.0
      */



.. _coding-standards.inline-documentation.classes:

类
^

每个类必须至少包含这些 phpDocumentor 标签：

   .. code-block:: php
      :linenos:

      /**
       * 类的简述
       *
       * 类的详细描述 （如果有的话）... ...
       *
       * @copyright  Copyright (c) 2005-2012 Zend Technologies USA Inc. (http://www.zend.com)
       * @license    http://framework.zend.com/license/   BSD License
       * @version    Release: @package_version@
       * @link       http://framework.zend.com/package/PackageName
       * @since      Class available since Release 1.5.0
       * @deprecated Class deprecated in Release 2.0.0
       */



.. _coding-standards.inline-documentation.functions:

函数
^^

每个函数，包括对象方法，必须有最少包含下列内容的文档块（docblock）：



   - 函数的描述

   - 所有参数

   - 所有可能的返回值



因为访问级已经通过 "public"、 "private" 或 "protected" 声明， 不需要使用 "@access"。

如果函数/方法抛出一个异常，使用 @throws 于所有已知的异常类：

   .. code-block:: php
      :linenos:

      @throws exceptionclass [description]





.. _`license`: http://framework.zend.com/license
.. _`http://phpdoc.org/`: http://phpdoc.org/
