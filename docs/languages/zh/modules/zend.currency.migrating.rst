.. _zend.currency.migration:

从前面的版本迁移
========================

*Zend_Currency* 的 API 已经被修改来增加可用性。如果你从一个在本章提到的版本开始使用
*Zend_Currency*\ ， 请遵循下面的指南来迁移你的脚本到新的 API。

.. _zend.currency.usage.migration.fromonezerotwo:

从 1.0.2 到 1.0.3 或更新的迁移
--------------------------------------

创建 *Zend_Currency* 的对象变得容易了。现在你不再需要给一个脚本或把它设置为
null。可选的脚本参数现在可以通过 *setFormat()* 方法来设置。

.. code-block::
   :linenos:

   $currency = new Zend_Currency($currency, $locale);


*setFormat()*
方法现在带有一个可以被设置的选项数组。这些选项被设置成永久并覆盖所有先前设置的值，并且又加了一个新的选项
'precision'，下面的选项都被集成了：



   - **position**: 替换旧的 'rules' 参数。

     **script**: 替换旧的 'script' 参数。

     **format**: 替换旧的 'locale' 参数，它不设置新的货币，只设置数字格式。

     **display**: 替换旧的 'rules' 参数。

     **precision**: 新参数。

     **name**: 替换旧的 'rules' 参数。设置货币全名。

     **currency**: 新参数。

     **symbol**: 新参数。



.. code-block::
   :linenos:

   $currency->setFormat(array $options);


The *toCurrency()* 方法不再支持可选的 'script' 和 'locale'
参数，而是它它带有一个选项数组，数组中包含和 *setFormat* 方法相同的键。

.. code-block::
   :linenos:

   $currency->toCurrency($value, array $options);


方法 *getSymbol()*\ 、 *getShortName()*\ 、 *getName()*\ 、 *getRegionList()* 和 *getCurrencyList()*
不再是静态并可以在对象中被调用。如果没有参数被设定，它们返回一组对象设的值。


