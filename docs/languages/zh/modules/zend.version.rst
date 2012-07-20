.. _zend.version.reading:

读取Zend Framework的当前版本
=====================

常量 *Zend_Version::VERSION*\ 的值为Zend Framework的当前版本号，例如0.9.0beta。

静态方法 *Zend_Version::compareVersion($version)*\ 基于PHP函数 `version_compare()`_\ 。如果指定的
*$version*\
比当前ZF的版本旧，则该方法返回-1，如果相等则返回0，如果比当前版本更新返回+1。

.. _zend.version.reading.example:

.. rubric:: compareVersion()方法示例：

.. code-block::
   :linenos:

   // returns -1, 0 or 1
   $cmp = Zend_Version::compareVersion('1.0.0');





.. _`version_compare()`: http://php.net/version_compare
