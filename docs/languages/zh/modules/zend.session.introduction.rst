.. _zend.session.introduction:

简介
==

Zend Framework Auth 团队也非常期望大家在邮件列表中进行反馈和贡献： `fw-auth@lists.zend.com`_

在基于 PHP 开发的 Web 应用程序中， **会话(session)**
代表服务器端和特定的用户代理客户端(比如 web
浏览器)之间的一对一的持久的状态数据。 *Zend_Session*
用来在由相同客户端发起的多个页面请求之间，管理和保护会话数据
。逻辑上来说，会话数据是 cookie 数据的扩展。 和 cookie
数据不同，会话数据不储存在客户端，仅当服务器端程序源代码使得会话数据可用，
才通过回应来自客户端的请求与客户端共享会话数据。在该组件及其文档中，术语“session
data”代表服务器端存储在 `$_SESSION`_ 中的数据。该数据使用 *Zend_Session* 来管理，由
*Zend_Session_Namespace* 采用对象的方式来控制。 **会话命名空间(Session Namespaces)**
提供了使用经典的 `命名空间`_
方式来访问会话数据，命名空间逻辑上就是一系列被命名（键名为字符串）的联合数组（类似于普通的
PHP 数组）。

*Zend_Session_Namespace* 的实例用对象存储的方式实现了 *$_SESSION* 的命名空间。 *Zend_Session*
组件包装了PHP内置的会话模块，提供了一个管理会话的接口，也为 *Zend_Session_Namespace*
持久化命名空间数据提供了API。 *Zend_Session_Namespace*
为会话命名空间数据到PHP内部会话机制的持久化提供了一个标准的、面向对象的接口。
*Zend_Session* 支持现有无名的会话，同时也支持“登录会话”。Zend Framework
的用户验证组件 *Zend_Auth*\ ，使用了 *Zend_Session_Namespace*\
，把用户的鉴别信息储存到了"Zend_Auth"命名空间下。 因为 *Zend_Session*
使用了PHP内置的会话函数，常用的配置选项和设置都仍然适用(请参考
`http://www.php.net/session`_)。
如此，储存在cookie或者URL中的会话标识，保持了客户端与服务器端会话状态数据之间的联系。

PHP 默认的 `session_save_handler 函数`_
没有解决当客户端连接到了集群服务器中的一些服务器的情况下，保持客户端与服务器端会话状态数据之间联系的问题，
因为会话状态数据只能储存在本地服务器当中（译注：也就是在各服务器间不能共享session数据）。
当一组附加的且合理的save
handlers可用时，我们会提供它。我们鼓励社区成员在我们的邮件列表 `fw-auth@lists.zend.com`_
中发表你的建议或者提交save handlers。 与Zend_Db兼容的save handler已经发表在邮件列表中。



.. _`fw-auth@lists.zend.com`: mailto:fw-auth@lists.zend.com
.. _`$_SESSION`: http://www.php.net/manual/en/reserved.variables.php#reserved.variables.session
.. _`命名空间`: http://en.wikipedia.org/wiki/Namespace_%28computer_science%29
.. _`http://www.php.net/session`: http://www.php.net/session
.. _`session_save_handler 函数`: http://www.php.net/manual/en/function.session-set-save-handler.php
