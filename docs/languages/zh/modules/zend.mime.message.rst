.. EN-Revision: none
.. _zend.mime.message:

Zend\Mime\Message
=================

.. _zend.mime.message.introduction:

简介
--

*Zend\Mime\Message*\ 表示一个包含一个或多个段（段以 :ref:`Zend\Mime\Part <zend.mime.part>`\
对象表示）的符合MIME标准的消息。 在 *Zend\Mime\Message*\ 中，符合MIME标准的多段消息由
*Zend\Mime\Part*\ 对象产生。 编码和分段也是在Zend\Mime\Message中被处理。 *Zend\Mime\Message*\
对象也可从给定的字符串中重构出来（实验性的）。 Zend\Mime\Message也被 :ref:`Zend_Mail
<zend.mail>`\ 使用（译注：Zend_Mail继承了Zend\Mime\Message）。

.. _zend.mime.message.instantiation:

实例化
---

*Zend\Mime\Message*\ 没有构造函数。

.. _zend.mime.message.addparts:

增加MIME消息段
---------

*Zend\Mime\Message*\ 对象通过调用 *addPart($part)*\ 方法， 可以添加 :ref:`Zend\Mime\Part
<zend.mime.part>`\ 对象。

调用 *Zend\Mime\Message*\ 对象的 *getParts()*\ 方法， 返回 :ref:`Zend\Mime\Part <zend.mime.part>`
对象数组。
Zend\Mime\Part对象可以被更改，因为他们以引用的方式存储在Zend\Mime\Message对象的数组中。
如果数组中有新的段加入或者改变了段的顺序，该数组需通过调用 *setParts($partsArray)*\
方法，反馈到 *Zend\Mime\Message*\ 中去。

当 *Zend\Mime\Message*\ 中存在多个段，方法 *isMultiPart()*\ 将返回TRUE。 *Zend\Mime\Message*\
在产生实际输出产生多段的MIME消息。

.. _zend.mime.message.bondary:

分界线处理
-----

*Zend\Mime\Message*\ 通常创建和使用自身的 *Zend_Mime*\ 对象来产生MINE分界线。
如果你想自己定义分界线或想更改 *Zend\Mime\Message*\ 自身的 *Zend_Mime*\
对象的缺省的行为， 你可以自己实例化 *Zend_Mime*\ 对象，然后通过 *setMime(Zend_Mime $mime)*\
方法注册到 *Zend\Mime\Message*\ 对象中去，通常你不需要这么做。

*->getMime()*\ 方法，返回 *Zend_Mime*\ 实例，当 *generateMessage()*\ 被调用时 *Zend_Mime*\
实例用来渲染MIME消息。

*->generateMessage()*\ 方法，渲染 *Zend\Mime\Message*\ 的内容为字符串。

.. _zend.mime.message.parse:

解析字符串，创建Zend\Mime\Message对象（实验性的）
---------------------------------

给定一个字符串形式的符合MIME标准的消息，可以重构出 *Zend\Mime\Message*\ 对象。
*Zend\Mime\Message*\ 有一个静态的工厂方法，解析字符串，返回 *Zend\Mime\Message*\ 对象。

*Zend\Mime\Message::createFromMessage($str, $boundary)*\ 将给定的字符串解码， 返回 *Zend\Mime\Message*\
对象，可以用 *getParts()*\ 方法来检验一下。


