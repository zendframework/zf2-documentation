.. _zend.view.helpers.initial.headscript:

HeadScript 助手
=============

HTML *<script>*
元素用来提供内嵌的客户端脚本元素或链接到远程包含客户端脚本代码的资源。你可以用
*HeadScript* 助手来管理它们。

*HeadScript* 助手支持下列方法来设置和添加脚本：

- *appendFile($src, $type = 'text/javascript', $attrs = array())*

- *offsetSetFile($index, $src, $type = 'text/javascript', $attrs = array())*

- *prependFile($src, $type = 'text/javascript', $attrs = array())*

- *setFile($src, $type = 'text/javascript', $attrs = array())*

- *appendScript($script, $type = 'text/javascript', $attrs = array())*

- *offsetSetScript($index, $script, $type = 'text/javascript', $attrs = array())*

- *prependScript($script, $type = 'text/javascript', $attrs = array())*

- *setScript($script, $type = 'text/javascript', $attrs = array())*

对于所有 **File()*\ 方法， *$src* 是要加载的脚本的远程位置，常常以 URL
或路径的形式表示。 对于所有 **Script()*\ 方法， *$script*\
是客户端你想用于元素中的脚本。

*HeadScript*\
也允许抓取脚本，然后放到其它地方，如果你想通过程序生成客户端脚本，这将很有用。下面的例子里有它的用法。

最后，你也可以用 *headScript()*\ 方法 来快速地添加脚本元素，它的用法是：
*headScript($mode = 'FILE', $spec, $placement = 'APPEND')*\ 。 *$mode*
是指链接一个文件还是一个脚本，可以是'FILE' 或 'SCRIPT' ， *$spec*
是链接的脚本文件或脚本代码。$placement必须为'APPEND', 'PREPEND', 或'SET'其中之一.

*HeadScript* 覆盖 *append()*\ ， *offsetSet()*\ ， *prepend()* 和 *set()*
中的每一个来加强上述特殊方法的用法。在内部，它存储每个条目为 *stdClass*
令牌，它在稍后用 *itemToString()* 方法 serializes
。这允许在堆栈里检查条目，并可选地通过修改返回的对象来修改这些条目。

The *HeadScript* 助手是 :ref:`占位符助手 <zend.view.helpers.initial.placeholder>` 的一个具体实现。

.. note::

   **在HTML Body中使用 InlineScript**

   当包含脚本内嵌在 HTML *body*\ 里时，应当使用 *HeadScript* 的兄弟助手， :ref:`InlineScript
   <zend.view.helpers.initial.inlinescript>`\
   。为了加速页面的加载，提高用户访问速度，特别是当使用第三方分析脚本（比如Google
   Analytics等流量统计系统的javascript文件
   --Haohappy注），把脚本放在文档的最后是一个好的习惯。

.. note::

   **任意的属性缺省关闭 （Disabled）**

   缺省地， *HeadScript* 将只解析（render）由 W3C 赋予的 *<script>* 属性，包括 'type'、
   'charset'、 'defer'、 'language' 和 'src' 。 然而，一些 javascript 框架，如 `Dojo`_\
   ，利用定制的属性来修改行为。为了允许这样的属性，可以通过
   *setAllowArbitraryAttributes()* 方法来打开（enable）它们：

   .. code-block:: php
      :linenos:

      <?php
      $this->headScript()->setAllowArbitraryAttributes(true);
      ?>
.. _zend.view.helpers.initial.headscript.basicusage:

.. rubric:: HeadScript 助手基本用法

在任何时候可以指定一个新的脚本。如上所述，可以链接到外部资源文件或脚本自己。

.. code-block:: php
   :linenos:

   <?php // adding scripts
   $this->headScript()->appendFile('/js/prototype.js')
                      ->appendScript($onloadScript);
   ?>

在客户端脚本编程中，顺序常常很重要，因为依赖的缘故，需要确保按特定的顺序来加载库，使用
append、 prepend 和 offsetSet 指令来帮助完成任务：

.. code-block:: php
   :linenos:

   <?php // 按顺序放置脚本文件

   //设置偏移量来确保这个文件最后加载
   $this->headScript()->offsetSetScript(100, '/js/myfuncs.js');

   //使用scriptaculous效果文件，这时append动作使用索引101，接上行代码的索引
   $this->headScript()->appendScript('/js/scriptaculous.js');

   //但总是保证prototype文件首先加载
   $this->headScript()->prependScript('/js/prototype.js');
   ?>

当准备好输出所有脚本到布局脚本，简单地 echo 这个助手：

.. code-block:: php
   :linenos:

   <?= $this->headScript() ?>

.. _zend.view.helpers.initial.headscript.capture:

.. rubric:: Capturing Scripts Using the HeadScript Helper

有时候，需要“编程式”地生成客户端脚本。你可以使用字符串串联、heredoc或类似的技术（字符串串联即$string1.$string2这种形式，heredoc即使用<<<操作符－－Haohappy注），通常通过创建脚本和在PHP标签里做手脚会更容易些。
*HeadScript*
可以实现这个功能，把一段JavaScript代码抓取到堆栈中暂存（道理同缓冲输出－－Haohappy注）：

.. code-block:: php
   :linenos:

   <?php $this->headScript()->captureStart() ?>
   var action = '<?= $this->baseUrl ?>';
   $('foo_form').action = action;
   <?php $this->headScript()->captureEnd() ?>

下面是上例中的一些假设：

- 脚本将追加到堆栈。如果需要替换或者追加到堆栈顶部，那么需要分别把 'SET' 或
  'PREPEND' 作为第一个参数传递给 *captureStart()* 。

- 脚本 MIME 类型假定为
  'text/javascript'，如果想指定一个不同的类型，需要把它作为第二个参数传递给
  *captureStart()* 。

- 如果需要为 *<script>* 标签指定附加属性， 把它们放入数组作为第三个参数传递给
  *captureStart()* 。



.. _`Dojo`: http://www.dojotoolkit.org/
