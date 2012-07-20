.. _introduction.installation:

安装
==

Zend Framework 要求 PHP版本不低于5.1.4，但强烈建议使用 5.2.3
或更高版本，因为在这两个版本之间有 许多重大安全和性能方面的改善和提高。请查阅
:ref:`附录 需求 <requirements>` 了解更多信息。

安装 Zend Framework 非常简单。只要你下载并解压它，并把发行版里的 /library
文件夹加到你的 include 路径里就行了。 你也可以把 library
文件夹移动到其它可共享的位置。

   - `下载最新的稳定版本。`_ 这个版本有 *.zip* 和 *.tar.gz* 两种格式，对于 Zend Framework
     的新手来说是不错的选择。

   - `下载最新的每日快照（nightly snapshot）。`_\
     对于用于勇于面对困难的人更加适用。每日快照可以体现出 Zend Framework
     的开发进展。 快照同时含有英文版本和其他可用语言的文档。 如果希望使用最新的
     Zend Framework 进行开发，请使用 SVN （Subversion）客户端下载最新的代码。

   - 使用 `Subversion`_\ （SVN）客户端。Zend Framework 是开源软件，开发所使用的 Subversionu
     仓库也是可公开访问的。如果已经在开发中使用了 SVN 的代码，
     或者希望对框架有所贡献，或者想使用比公开发布版本更新的代码，则可以考虑从
     SVN 中获得 Zend Framework。

     `导出`_ 功能可以获得在工作目录中没有 *.svn* 文件夹的指定版本的框架副本。

     `检出`_ 对于向 Zend Framework 进行贡献是很方便的，同时工作副本可以在任何时候使用
     `提交`_\ 来更新。

     `外部定义`_ 可以让开发者在他们的应用中方便的使用 SVN 同步框架版本。

     Zend Framework 的 SVN 仓库 URL 地址是： `http://framework.zend.com/svn/framework/standard/trunk`_



当拥有了一个可用的 Zend Framework 副本时，应用程序需要能够访问到框架中的类。虽然有
`许多的方法来达到这个目的`_\ ，PHP 的 `include_path`_ 必须含有 Zend Framework 库的路径。

Zend 提供了 `快速入门指南`_ 可以让你尽快入门。 这是一个极好的用实际的例子来学习
Zend Framework的方法。

因为 Zend Framework 的组件是松耦合的，
在你的程序里可以使用一些独一无二的它们的组合。
本文档下面的章节基于组件划分，全面介绍了 Zend Framework 的使用。



.. _`下载最新的稳定版本。`: http://framework.zend.com/download
.. _`下载最新的每日快照（nightly snapshot）。`: http://framework.zend.com/download/snapshot
.. _`Subversion`: http://subversion.tigris.org
.. _`导出`: http://svnbook.red-bean.com/nightly/zh/svn.ref.svn.c.export.html
.. _`检出`: http://svnbook.red-bean.com/nightly/zh/svn.ref.svn.c.checkout.html
.. _`提交`: http://svnbook.red-bean.com/nightly/zh/svn.ref.svn.c.update.html
.. _`外部定义`: http://svnbook.red-bean.com/nightly/zh/svn.advanced.externals.html
.. _`http://framework.zend.com/svn/framework/standard/trunk`: http://framework.zend.com/svn/framework/standard/trunk
.. _`许多的方法来达到这个目的`: http://www.php.net/manual/zh/configuration.changes.php
.. _`include_path`: http://www.php.net/manual/zh/ini.core.php#ini.include-path
.. _`快速入门指南`: http://framework.zend.com/docs/quickstart
