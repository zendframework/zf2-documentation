.. _zend.currency.usage:

如何使用货币
======

在自己的程序中使用 *Zend_Currency*\
，就是创建一个它的实例，不需要任何参数。它将创建一个带有实际地方、并定义了在这个地方使用的货币的
*Zend_Currency* 的一个实例。

.. _zend.currency.usage.example1:

.. rubric:: 从实际地方创建 Zend_Currency 的实例

期望通过用户（的输入）或环境，你有 'en_US'
设置作为实际地方，通过使用不带参数创建 *Zend_Currency*\ 的实例从地方 'en_US'
来使用实际货币，这导致带美元实例作为带有'en_US'格式规则的实际货币。

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency();


从 Zend Framework 1.7.0 开始， *Zend_Currency*
也支持程序范围的地方的用法。你可以简单地如下设置 *Zend_Locale* 实例到注册表。
如果你想多次使用同一地方，用这个符号你不需要记住对每个实例手工设置地方。

.. code-block:: php
   :linenos:

   // in your bootstrap file
   $locale = new Zend_Locale('de_AT');
   Zend_Registry::set('Zend_Locale', $locale);

   // somewhere in your application
   $currency = new Zend_Currency();


.. note::

   要知道，如果你的系统没有缺省地方，或者如果你系统的地方不能自动检测到，
   *Zend_Currency* 将抛出一个异常。如果这样，你应当手动设置地方。

当然，根据需要，若干参数可以在创建时给出，每个参数都是可选的和被禁止，甚至参数的顺序也可以交换。每个参数的意思描述如下：

- **currency**:

  一个地方可以有多种货币，因此第一个参数 **'currency'**
  可通过给出短名称或全名称来定义哪个货币应当被使用。
  如果某货币不被任何地方认识，那么就抛出一个异常。货币短名总是三个字母并且是大写。众所周知的货币短名有
  *USD* 或 *EUR* 。想知道所有货币请参考 *Zend_Currency* 的信息方法。

- **locale**:

  第三个参数 **'locale'**
  定义了哪个地方用来格式化货币，给出的地方也将用来获得标准脚本和货币（如果这些参数没有给出时的货币）。

  .. note::

     注意 Zend_Currency
     只接受包括地区的地方，这意味着所有给定的只包括语言地方将抛出一个异常。例如地方
     **en** 将抛出异常而地方 **en_US** 将返回 **USD** 作为货币。

.. _zend.currency.usage.example2:

.. rubric:: 创建 Zend_Currency 实例的其它例子

.. code-block:: php
   :linenos:

   // expect standard locale 'de_AT'

   // creates an instance from 'en_US' using 'USD' which is default
   // currency for 'en_US'
   $currency = new Zend_Currency('en_US');

   // creates an instance from the actual locale ('de_AT') using 'EUR' as
   // currency
   $currency = new Zend_Currency();

   // creates an instance using 'EUR' as currency, 'en_US' for number
   // formating
   $currency = new Zend_Currency('en_US', 'EUR');


如果想使用缺省值，你可以禁止任何参数，在处理货币方面没有副作用，例如这在当你不知道某地区的缺省货币很有用。

.. note::

   许多国家有多种货币，一种正在使用的和一些古老的。如果 '**currency**'
   参数被禁止，那么使用当前货币。例如在地区 '**de**' 有 '**EUR**' 和 '**DEM**'...'**EUR**'
   是当前使用的货币，如果这参数被禁止它将被使用。

.. _zend.currency.usage.tocurrency:

从货币创建输出
-------

可以用方法 **toCurrency()**
把存在的数值转换成格式化的货币输出，它带有一个可以被转换的数值，这个数值可以是任何标准化的数字。

如果有个需要转换的本地化的数字，首先用 :ref:`Zend_Locale_Format::getNumber()
<zend.locale.number.normalize>` 来标准化，然后用 *toCurrency()* 创建一个货币输出。

*toCurrency(array $options)*
接受带有选项的数组，这个选项可用来临时设置成另外的格式或货币表示，关于选项的细节参见
:ref:`Changing the format of a currency <zend.currency.usage.setformat>`\ 。

.. _zend.currency.usage.tocurrency.example:

.. rubric:: 为货币创建输出

.. code-block:: php
   :linenos:

   // creates an instance with 'en_US' using 'USD' which is the default
   // values for 'en_US'
   $currency = new Zend_Currency('en_US');

   // prints '$ 1,000.00'
   echo $currency->toCurrency(1000);

   // prints '$ 1.000,00'
   echo $currency->toCurrency(1000, array('format' => 'de_AT'));

   // prints '$ ١٬٠٠٠٫٠٠'
   echo $currency->toCurrency(1000, array('script' => 'Arab'));


.. _zend.currency.usage.setformat:

修改货币格式
------

用来创建 *Zend_Currency*
实例的格式当然是标准格式，但有时候也需要为自己的意图需要这个格式。

货币输出的格式包括下面部分：

- **货币符号，短名或名字**:

  或不符号一般显示在货币输出之内，如果需要或重写，它可以被禁止。

- **货币位置**:

  货币符号的位置一般由地方来自动定义，如果需要，它可以被修改。

- **Script**:

  Script 用来显示数字，它的详细用法可以从 *Zend_Locale* 的文档 :ref:`被支持的数字 scripts
  <zend.locale.appendix.numberscripts.supported>`\ 找到。

- **数字格式**:

  货币的数量 （ 就是钱的数量 ）用在地方( locale
  )里的格式化规则来格式化，例如在英语中 ',' 用来分离每一千，在德国就用
  '.'符号（例如一百万，在英语中就是1,000,000 而在德语中就是1.000.000
  好像在德语中容易和小数点混淆 by Jason Qi）。

如果确实需要修改格式，你可以用 **setFormat()**
方法。它带有一个数组，包括所有你向修改的选项。 *options* 数组支持下列设置：

- **position**: 定义货币显示位置，从 :ref:`this table <zend.currency.usage.setformat.constantsposition>`
  可以找到被支持的位置。

- **script**: 定义哪个 script 被用来显示数字，大部分地方的缺省的 script 是 **'Latn'**
  ，它包括数字 0 到 9 。并且其它的 scripts 如 'Arab'(Arabian) 也可以用。所有被支持的
  scipts 可以从 :ref:`this table <zend.locale.appendix.numberscripts.supported>` 找到。

- **format**:
  定义哪个地方（locale）用来显示数字，数字格式包括千为分隔符。如果没有指定格式，就使用
  *Zend_Currency* 对象中的地方（ locale ）。

- **display**: 定义货币中的哪个部分用来显示货币表示，有四中表示法可用，都在
  :ref:`this table <zend.currency.usage.setformat.constantsdescription>` 中描述。

- **precision**: 定义用于货币表示的精确位数，它的缺省值是 **2**\ 。

- **name**: 定义被显示的货币名称，它重写通过创建 *Zend_Currency* 产生的任何货币名称。

- **currency**: 定义被显示的国际缩写，它重写通过创建 *Zend_Currency* 产生的任何缩写。

- **symbol**: 定义被显示的货币符号，它重写通过创建 *Zend_Currency* 产生的任何符号。

.. _zend.currency.usage.setformat.constantsdescription:

.. table:: 选择货币描述的常量

   +-------------+-------------+
   |常量           |描述           |
   +=============+=============+
   |NO_SYMBOL    |不显示任何货币表示    |
   +-------------+-------------+
   |USE_SYMBOL   |显示货币符号       |
   +-------------+-------------+
   |USE_SHORTNAME|显示三个字母的国际货币缩写|
   +-------------+-------------+
   |USE_NAME     |显示货币全名       |
   +-------------+-------------+

.. _zend.currency.usage.setformat.constantsposition:

.. table:: 选择货币位置的常量

   +--------+-------------+
   |常量      |描述           |
   +========+=============+
   |STANDARD|设置在地方里定义标准位置 |
   +--------+-------------+
   |RIGHT   |在数的右面显示货币表示符 |
   +--------+-------------+
   |LEFT    |在数值的左面显示货币表示符|
   +--------+-------------+

.. _zend.currency.usage.setformat.example:

.. rubric:: 修改货币的显示格式

.. code-block:: php
   :linenos:

   // creates an instance with 'en_US' using 'USD', 'Latin' and 'en_US' as
   // these are the default values from 'en_US'
   $currency = new Zend_Currency('en_US');

   // prints 'US$ 1,000.00'
   echo $currency->toCurrency(1000);

   $currency->setFormat('display' => Zend_Currency::USE_NAME,
                        'position' => Zend_Currency::RIGHT);
   // prints '1.000,00 US Dollar'
   echo $currency->toCurrency(1000);

   $currency->setFormat('name' => 'American Dollar');
   // prints '1.000,00 American Dollar'
   echo $currency->toCurrency(1000);


.. _zend.currency.usage.informational:

Zend_Currency 的信息方法
-------------------

当然， *Zend_Currency* 也支持从 *Zend_Locale*
获得任何存在的和许多古老货币的信息。支持的方法是：

- **getSymbol()**:

  返回实际货币或给定货币的已知符号。例如 **$** 在 **en_US** 地方表示美元。

- **getShortName()**:

  返回实际货币或给定货币的缩写。例如 **USD** 在 **en_US** 地方表示美元。

- **getName()**:

  返回实际货币或给定货币的全名。例如 **US Dollar** 在 **en_US** 地方表示美元。

- **getRegionList()**:

  返回实际货币或给定被使用货币的地区列表。因为某种货币可能被用于多个地区，所以返回值总是一个数组。

- **getCurrencyList()**:

  返回用于给定地区的已知货币的列表。

函数 *getSymbol()*\ 、 *getShortName()* 和 *getName()*
带两个可选的参数。如果没有给出参数，期望的数据将从当前设置货币返回。第一个参数是货币的短名，短名总是三个字母，例如
EUR 是欧元，USD 是美元。第二个参数定义从哪个地方（ locale
）读数据。如果没有给出地方，就使用当前使用的地方设置。

.. _zend.currency.usage.informational.example:

.. rubric:: 从货币中获取信息

.. code-block:: php
   :linenos:

   // creates an instance with 'en_US' using 'USD', 'Latin' and 'en_US'
   // as these are the default values from 'en_US'
   $currency = new Zend_Currency('en_US');

   // prints '$'
   echo $currency->getSymbol();

   // prints 'EUR'
   echo $currency->getShortName('EUR');

   // prints 'Österreichische Schilling'
   echo $currency->getName('ATS', 'de_AT');

   // returns an array with all regions where USD is used
   print_r($currency->getRegionList();

   // returns an array with all currencies which were ever used in this
   // region
   print_r($currency->getCurrencyList('de_AT');


.. _zend.currency.usage.setlocale:

设置新缺省值
------

*setLocale* 方法允许设置新的地方给 *Zend_Currency*
。当调用这个函数所有的货币的缺省值就被重写，包括货币名、缩写和符号。

.. _zend.currency.usage.setlocale.example:

.. rubric:: 设置新地方

.. code-block:: php
   :linenos:

   // 获得 US 货币
   $currency = new Zend_Currency('en_US');
   print $currency->toCurrency(1000);

   // 获得 AT 货币
   $currency->setLocale('de_AT');
   print $currency->toCurrency(1000);


.. _zend.currency.usage.cache:

加速 Zend_Currency
----------------

通过 *Zend_Cache* 的使用可以加速 *Zend_Currency* 的工作。通过使用静态方法
*Zend_Currency::setCache($cache)* ，它接受一个选项， *Zend_Cache* 适配器，当设置它，Zend_Currency
方法的本地化数据就被缓存。 也有个静态方法 *Zend_Currency::getCache()* 方便你的使用。

.. _zend.currency.usage.cache.example:

.. rubric:: 缓存货币

.. code-block:: php
   :linenos:

   // 创建一个缓存对象
   $cache = Zend_Cache::factory('Core',
                                'File',
                                array('lifetime' => 120,
                                      'automatic_serialization' => true),
                                array('cache_dir'
                                          => dirname(__FILE__) . '/_files/'));
   Zend_Currency::setCache($cache);



