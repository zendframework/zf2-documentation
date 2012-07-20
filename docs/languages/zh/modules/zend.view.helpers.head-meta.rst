.. _zend.view.helpers.initial.headmeta:

HeadMeta 助手
===========

HTML *<meta>*\ 元素用来提供关于HTML文档的 meta 信息－如关键字，文档字符集，缓冲的
pragama 等。Meta标签可以是'http-equiv' 或 'name' 类型，必须包含'content'属性，并且也可以有
'lang' 或 'scheme' 修饰属性。

*HeadMeta* 助手提供下列方法来设置和添加 meta 标签：

- *appendName($keyValue, $content, $conditionalName)*

- *offsetSetName($index, $keyValue, $content, $conditionalName)*

- *prependName($keyValue, $content, $conditionalName)*

- *setName($keyValue, $content, $modifiers)*

- *appendHttpEquiv($keyValue, $content, $conditionalHttpEquiv)*

- *offsetSetHttpEquiv($index, $keyValue, $content, $conditionalHttpEquiv)*

- *prependHttpEquiv($keyValue, $content, $conditionalHttpEquiv)*

- *setHttpEquiv($keyValue, $content, $modifiers)*

*$keyValue* 参数用来定义'name'的值或'http-equive'键； *$content* 是'content' 键的值， *$modifiers*
是可选的包含'lang' 和/或 'scheme'键的联合数组。

也可以用 *headMeta()* 助手方法来设置 meta 标签： *headMeta($content, $keyValue, $keyType = 'name',
$modifiers = array(), $placement = 'APPEND')*\ 。 *$keyValue* 是指定在 *$keyType* 里的键的内容，
*$keyType* 应该是'name' 或 'http-equiv'。 *$placement* 可以是 'SET' （覆盖所有先前存储的值），
'APPEND' （添加到栈尾）或 'PREPEND'（添加到栈顶）。

*HeadMeta* 覆盖每个 *append()*\ 、 *offsetSet()*\ 、 *prepend()* 和 *set()*
来加强上面列出的特殊方法的用法。在内部，它存储每个条目为 *stdClass*
令牌，它稍后用 *itemToString()*
方法来序列化。这允许在堆栈的条目中执行检查，并可选地通过修改对象返回来修改这些条目。

*HeadMeta*\ 助手是 :ref:`占位符助手 <zend.view.helpers.initial.placeholder>` 的一个具体实现。

.. _zend.view.helpers.initial.headmeta.basicusage:

.. rubric:: HeadMeta 助手基本用法

你可以在任何时候指定一个新的meta标签。例如指定客户端缓冲规则或SEO关键字。

例如，如果想指定SEO关键字，要创建带有名为'keywords'和内容（在页面上和关键字有关联的）的meta名称标签：

.. code-block::
   :linenos:

   <?php // setting meta keywords
   $this->headMeta()->appendName('keywords', 'framework php productivity');
   ?>

如果想设置一些客户端缓冲规则，最好设置带有想执行的规则的 http-equiv 标签：

.. code-block::
   :linenos:

   <?php // 禁止客户端缓存
   $this->headMeta()->appendHttpEquiv('expires', 'Wed, 26 Feb 1997 08:21:57 GMT')
                    ->appendHttpEquiv('pragma', 'no-cache')
                    ->appendHttpEquiv('Cache-Control', 'no-cache');
   ?>

meta标签的另一个流行用法是设置内容类型，字符集和语言：

.. code-block::
   :linenos:

   <?php // setting content type and character set
   $this->headMeta()->appendHttpEquiv('Content-Type', 'text/html; charset=UTF-8')
                    ->appendHttpEquiv('Content-Language', 'en-US');
   ?>

最后一个例子，可以使用"meta refresh" 来让页面转向，一个简单的办法来显示过渡消息：

.. code-block::
   :linenos:

   <?php // 设置以下meta可使页面3秒钟后转向一个新的url
   $this->headMeta()->appendHttpEquiv('Refresh', '3;URL=http://www.some.org/some.html');
   ?>

在布局脚本(layout)中放置所有meta标签后，简单地echo助手，把所有内容输出：

.. code-block::
   :linenos:

   <?= $this->headMeta() ?>


