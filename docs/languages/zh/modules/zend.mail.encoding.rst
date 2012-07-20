.. _zend.mail.encoding:

编码
======

文本和HTML信息在缺省下以Quoted-printable机制编码。在调用 *addAttachment()*\
方法添加附件的时候，
如果没有指定编码方式，都将以base64方式编码，或稍后通过给MIME段对象(*Zend_Mime_Part*)相应属性赋值来指定编码方式。
7Bit和8Bit编码目前仅仅在二进制数据上可行。

*Zend_Mail_Transport_Smtp*\
编码行以一个点(.)或者两个点(..)起始，以确保邮件不违反SMTP协议。


