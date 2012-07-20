.. _zend.json.introduction:

简介
==

*Zend_Json*
提供一个方便的方式来串联(native的)PHP(的变量)和JSON，并将JSON(对象)解码到PHP中。
关于JSON的更多信息， `请参考 JSON 项目网站`_\ 。

JSON, JavaScript Object Notation, 可以被应用于JS和其他语言的轻量级数据交换。
因为JSON(对象)可以直接被Javascript执行，对于web2.0接口来说,它是一种理想的格式；它是使用XML作为AJAX接口的一个更简单的替换方案。

另外， *Zend_Json* 提供把字符串从任意的 XML 格式转换到 JSON 格式。这个内置的功能使 PHP
开发者能够在把企业数据发送到基于浏览器的 Ajax客户程序之前把它（企业数据）从 XML
格式转换到 JSON
格式。它提供了简便的方法在服务器端做动态数据转换，因而避免了在浏览器端进行不必要的
XML 解析。 它提供了很好的实用函数，能够容易地实现 application-specific 数据处理技术。



.. _`请参考 JSON 项目网站`: http://www.json.org/
