.. _zend.debug.dumping:

输出变量的值 (Dumping Variables)
======================================

静态方法 *Zend_Debug::dump()*
打印或返回某个表达式或变量的信息。这个简单的调试技术很常用，因为在特别时髦和要求没有初始化、特殊工具或调试环境时很容易使用。

.. _zend.debug.dumping.example:

.. rubric:: dump()方法使用示例

.. code-block::
   :linenos:


   Zend_Debug::dump($var, $label=null, $echo=true);


*$var* 参数指定了 *Zend_Debug::dump()* 输出信息的表达式或变量。

*$label* 标签参数是用来加在 *Zend_Debug::dump()*
输出信息之前的一段文本。这非常有用，例如你一次要查看多个变量的信息。（你可以为不同变量设置不同label，如“user”，“password”等等，这样不会弄乱--Haohappy注)

*Zend_Debug::dump()* 是否输出，这取决于 *$echo*\ 参数，如果为 *true*\
，则会输出结果。无论是否指定 *$echo*\
参数的值，该方法的返回值都包含表达式或变量的信息。

深入地理解它很有帮助， *Zend_Debug::dump()* 方法封装 PHP 函数 `var_dump()`_\
。如果输出流被检测为 web 表达， *var_dump()* 的输出结果使用 `htmlspecialchars()`_\
转义，并封装(X)HTML *<pre>*\ 标签。

.. tip::

   **使用 Zend_Log 进行调试**

   使用 *Zend_Debug::dump()* 很方便在开发项目时Debug，你可以很容易地增加或移除它。

   你也可以考虑使用 :ref:`Zend_Log <zend.log.overview>`
   来调试，用于更长期的非短暂性的调试和监控。例如，你可以使用 *DEBUG* 记录级别和
   Stream 记录器来输出 *Zend_Debug::dump()* 返回的信息。



.. _`var_dump()`: http://php.net/var_dump
.. _`htmlspecialchars()`: http://php.net/htmlspecialchars
