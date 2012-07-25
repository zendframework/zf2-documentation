.. _zend.mime.part:

Zend_Mime_Part
==============

.. _zend.mime.part.introduction:

简介
--

*Zend_Mime_Part*\ 表示 MIME
消息的一个段。它包含了MIME消息段的实际内容以及编码、内容类型和原始的文件名等一些附加信息。它也提供了一个方法，用来从存储的数据产生字符串。
*Zend_Mime_Part*\ 对象可以被添加到 :ref:`Zend_Mime_Message <zend.mime.message>`\
中去，来聚合产生一个完整的多段的MIME消息。

.. _zend.mime.part.instantiation:

实例化
---

*Zend_Mime_Part*\
通过表示段的内容的字符串来实例化。缺省的内容类型为OCTET-STREAM，编码为8Bit。在
*Zend_Mime_Part*\ 实例化之后, 可以直接访问它的属性来设置元信息：

.. code-block:: php
   :linenos:

   <?php
   public $type = ZMime::TYPE_OCTETSTREAM;
   public $encoding = ZMime::ENCODING_8BIT;
   public $id;
   public $disposition;
   public $filename;
   public $description;
   public $charset;

.. _zend.mime.part.methods:

解析（rendering）消息段为字符串的方法
-----------------------

*getContent()*\
方法，返回经过编码的消息段字符串，编码方式由属性$encoding指定。有效的编码方式为Zend_Mime::ENCODING_*。字符集的转换还未实现。

*getHeaders()*\
方法，返回产自对象公有属性的MIME消息段的消息头。在该方法调用之前，对象的这些共有属性必须被正确的设置。


   - *$charset* 如果内容为Text类型(纯文本或HTML)，该属性被设置为实际的字符集。

   - *$id* 可能被设置，用来标识HTML邮件中内嵌图片的content-id。

   - *$filename* 给出了当文件被下载时的文件名。

   - *$disposition* 指定了文件是当作附件，还是当作邮件的内嵌资源。

   - *$description* 只用在提供信息上。




