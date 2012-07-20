.. _zend.view.helpers.initial.translator:

翻译助手
============

通常，网站支持多种语言。使用 :ref:`Zend 翻译 <zend.translator.introduction>`
来翻译网站的内容并且 使用 *翻译* 视图助手来在视图里集成 *Zend 翻译*\ 。

在下面所有的例子里我们使用简单的数组翻译适配器（Array Translation
Adapter）。当然你也可以使用任何 *Zend_Translator* 的实例和 *Zend_Translator_Adapter*
的任何子类。有若干方法来实例化 *翻译*\ 视图助手：

- 已注册的，通过先前注册的实例

- 后来地，通过 fluent interface （流利的接口？我还没有找到合适的词汇，by Jason Qi）

- 直接地，通过实例化类

*Zend_Translator*
的已注册的实例是这个助手的首选用法。你也可以简单地在添加适配器到注册表之前选择被使用的地点（locale）

.. note::

   我们用地点（locales）而不用语言是因为一种语音也可以包含一个地区。例如英语有不同的方言，有英国英语和美国英语，因此我们用“地点”而不说“语言”。

.. _zend.view.helpers.initial.translator.registered:

.. rubric:: 已注册的实例

为使用已注册的实例就是创建一个 *Zend_Translator* 或者 *Zend_Translator_Adapter* 的实例并在
*Zend_Registry* 里用 *Zend_Translator* 作为它的键。

.. code-block::
   :linenos:
   <?php
   // 我们的例子适配器
   $adapter = new Zend_Translator('array', array('simple' => 'einfach'), 'de');
   Zend_Registry::set('Zend_Translator', $adapter);

   // 在视图中
   echo $this->translate('simple');
   // 返回 'einfach'
   ?>
如果你熟悉 fluent interface ，那么也可以在视图里创建一个实例然后实例化这个助手。

.. _zend.view.helpers.initial.translator.afterwards:

.. rubric:: 在视图里

为了使用 fluent interface ，创建一个 *Zend_Translator* 或者 *Zend_Translator_Adapter*
的实例，调用不带参数的助手并调用 *setTranslator* 方法。

.. code-block::
   :linenos:
   <?php
   // 在视图里
   $adapter = new Zend_Translator('array', array('simple' => 'einfach'), 'de');
   $this->translate()->setTranslator($adapter)->translate('simple');
   // 返回 'einfach'
   ?>
如果你使用没有 *Zend_View*\ 的助手，那么你也可以直接使用它。

.. _zend.view.helpers.initial.translator.directly:

.. rubric:: 直接用法

.. code-block::
   :linenos:
   <?php
   // 我们的例子适配器
   $adapter = new Zend_Translator('array', array('simple' => 'einfach'), 'de');

   // 实例化适配器
   $translate = new Zend_View_Helper_Translator($adapter);
   print $translate->translate('simple'); // this returns 'einfach'
   ?>
如果你不用 *Zend_View* 你将需要这样做并需要创建一个已翻译的输出。

就象已经知道， *translate()* 方法用来返回翻译。用需要的翻译适配器的信息 id
来调用它。但它也可以在翻译字符串里替换参数。因此，它有两个方法接受变量参数。或者是参数类表，或者是参数数组。如下例：

.. _zend.view.helpers.initial.translator.parameter:

.. rubric:: 单个参数

使用单个参数就把它添加到这个方法。

.. code-block::
   :linenos:
   <?php
   // 在视图里
   $date = "Monday";
   $this->translate("Today is %1\$s", $date);
   // 应当返回 'Heute ist Monday'
   ?>
.. note::

   记住如果使用的参数也是文本，你可能也要翻译这些参数。

.. _zend.view.helpers.initial.translator.parameterlist:

.. rubric:: 参数列表

使用参数列表并添加给方法。

.. code-block::
   :linenos:
   <?php
   // 在视图里
   $date = "Monday";
   $month = "April";
   $time = "11:20:55";
   $this->translate("Today is %1\$s in %2\$s. Actual time: %3\$s", $date, $month, $time);
   // 应当返回 'Heute ist Monday in April. Aktuelle Zeit: 11:20:55'
   ?>
.. _zend.view.helpers.initial.translator.parameterarray:

.. rubric:: 参数数组

使用参数数组并添加到方法。

.. code-block::
   :linenos:
   <?php
   // 在视图里
   $date = array("Monday", "April", "11:20:55");
   $this->translate("Today is %1\$s in %2\$s. Actual time: %3\$s", $date);
   // 应当返回 'Heute ist Monday in April. Aktuelle Zeit: 11:20:55'
   ?>
有时候必需要修改翻译的地点。可以通过动态翻译或者把所有的静态翻译来完成。并且你可以使用参数类表和参数数组。在这两种情况下，地点被当作最后一个单个参数给出。

.. _zend.view.helpers.initial.translator.dynamic:

.. rubric:: 动态修改地点 （locale）

.. code-block::
   :linenos:
   <?php
   // 在视图里
   $date = array("Monday", "April", "11:20:55");
   $this->translate("Today is %1\$s in %2\$s. Actual time: %3\$s", $date, 'it');
   ?>
这个例子为 messageid
返回意大利语的翻译。但它将只能用一次。下个翻译将从适配器里设置地点。通常地在添加它到注册表之前你将在翻译适配器里设置期望的地点。但你也可以从助手里设置地点：

.. _zend.view.helpers.initial.translator.static:

.. rubric:: 静态修改地点 （locale）

.. code-block::
   :linenos:
   <?php
   // 在视图里
   $date = array("Monday", "April", "11:20:55");
   $this->translate()->setLocale('it');
   $this->translate("Today is %1\$s in %2\$s. Actual time: %3\$s", $date);
   ?>
在上面的例子里设置 *'it'* 为新的缺省地点，它将被用来给所有将来的翻译。

当然，还有 *getLocale()* 方法来获得当前设置的地点。

.. _zend.view.helpers.initial.translator.getlocale:

.. rubric:: 获得当前设置的地点

.. code-block::
   :linenos:
   <?php
   // 在视图里
   $date = array("Monday", "April", "11:20:55");

   // 从上面的例子里返回 'de' 作为缺省地点
   $this->translate()->getLocale();

   $this->translate()->setLocale('it');
   $this->translate("Today is %1\$s in %2\$s. Actual time: %3\$s", $date);

   // 返回 'it' 为新的缺省地点
   $this->translate()->getLocale();
   ?>

