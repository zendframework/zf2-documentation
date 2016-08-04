.. _learning.autoloading.intro:

简介
============
自动加载机制，解决了手工加载需要的 *PHP* 代码的麻烦。 
通过 `the PHP autoload manual`_，一旦一个autoloader已经被定义，当你使用一个未定义的类或者接口时，它会被自动的加载。使用自动加载，你不用担心一个类放在你项目的 **哪里** 。有了完善的autoloaders，你就不用担心一个类文件相对于当前类所在文件的相对位置；你只用简单的使用它们，autoloader会去进行查找。

此外，自动加载，因为它延迟到最后一刻才加载，确保只匹配一次，所以能显著地提升性能 -- 尤其是项目部署前你愿意花点功夫剔除 ``require_once()`` 的时候。

Zend Framework鼓励使用自动加载，并且提供了几种工具来支持类代码和应用代码的自动加载。这个教程涵盖这些工具，并且会教你更好地使用它们。

.. _`the PHP autoload manual`: http://php.net/autoload
