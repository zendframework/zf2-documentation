.. EN-Revision: none
.. _zend.mime.mime:

Zend_Mime
=========

.. _zend.mime.mime.introduction:

简介
--

*Zend_Mime*\ 是一个用来处理多段MIME消息的辅助类， 在 :ref:`Zend_Mail <zend.mail>`\ 和
:ref:`Zend\Mime\Message <zend.mime.message>`\ 中使用了它，
也可在需要MIME支持的应用程序中使用。

.. _zend.mime.mime.static:

静态方法和常量
-------

*Zend_Mime*\ 提供了一系列静态辅助方法来处理MIME：

   - *Zend\Mime\Mime::isPrintable()*:
     给定的字符串中不含不可打印(unprintable)的字符，则返回TRUE，否则返回FALSE。

   - *Zend\Mime\Mime::encodeBase64()*: 将一个字符串用base64编码。

   - *Zend\Mime\Mime::encodeQuotedPrintable()*: 将一个字符串以quoted-printable机制编码。



*Zend_Mime*\ 定义了一系列通常在处理MIME消息的时候要用到的常量：

   - *Zend\Mime\Mime::TYPE_OCTETSTREAM*: 'application/octet-stream'

   - *Zend\Mime\Mime::TYPE_TEXT*: 'text/plain'

   - *Zend\Mime\Mime::TYPE_HTML*: 'text/html'

   - *Zend\Mime\Mime::ENCODING_7BIT*: '7bit'

   - *Zend\Mime\Mime::ENCODING_8BIT*: '8bit'

   - *Zend\Mime\Mime::ENCODING_QUOTEDPRINTABLE*: 'quoted-printable'

   - *Zend\Mime\Mime::ENCODING_BASE64*: 'base64'

   - *Zend\Mime\Mime::DISPOSITION_ATTACHMENT*: 'attachment'

   - *Zend\Mime\Mime::DISPOSITION_INLINE*: 'inline'



.. _zend.mime.mime.instantiation:

实例化Zend_Mime
------------

在实例化 *Zend_Mime* 对象时，指定了MIME分界线(MIME boundary)，
在调用下面的非静态函数都会用到它(MIME分界线)。
如果传递给构造函数一个字符串参数，那么这个参数就用来指定MIME分界线；
如果没有给出参数，那么构造器在调用的时候会随机产生一个MIME分界线。

*Zend_Mime*\ 对象拥有以下方法：

   - *boundary()*: 返回MIME分界线字符串。

   - *boundaryLine()*: 返回完整的MIME分界线行。

   - *mimeEnd()*: 返回完整的MIME结束的分界线行。




