.. _zend.mail.introduction:

简介
==

.. _zend.mail.introduction.getting-started:

起步
--

*Zend_Mail* 提供了通用化的功能来撰写和发送文本以及兼容 MIME
标准的含有多个段的邮件消息。邮件在 *Zend_Mail* 里通过缺省的 *Zend_Mail_Transport_Sendmail*
传输或通过 *Zend_Mail_Transport_Smtp* 来发送。

.. _zend.mail.introduction.example-1:

.. rubric:: 使用Zend_Mail发送简单邮件

一个简单邮件由一个或者几个收件人，一个主题，一个邮件主体和一个发件人组成。下面的步骤，使用
*Zend_Mail_Transport_Sendmail* 来发送邮件：

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   $mail->setBodyText('This is the text of the mail.');
   $mail->setFrom('somebody@example.com', 'Some Sender');
   $mail->addTo('somebody_else@example.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send();

.. note::

   **Minimum definitions**

   使用 *Zend_Mail*\ 来发送邮件，你至少得指定一个收件人, 一个发件人(例如通过
   *setFrom()*\ 方法)和一个邮件消息主体(文本 和/或者 HTML)。

通过“get”方法可以读取绝大多数储存在“mail”对象中的邮件属性，更进一步的细节请参阅API文档。
*getRecipients()*\ 是一个特例，它返回一个含有所有先前被加入的收件人地址的数组。

出于安全原因， *Zend_Mail*
过滤了邮件头中所有字段，以防止基于换行符(*\n*)邮件头注入(header injection)漏洞攻击。

你也可以使用大部分带有方便的 fluent interface 的 *Zend_Mail* 对象的方法。 Fluent interface
意思是每个方法返回一个引用到它被调用的对象，所以你可以立即调用其它方法。

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   $mail->setBodyText('This is the text of the mail.')
       ->setFrom('somebody@example.com', 'Some Sender')
       ->addTo('somebody_else@example.com', 'Some Recipient')
       ->setSubject('TestSubject')
       ->send();

.. _zend.mail.introduction.sendmail:

配置缺省的 sendmail 传送器（transport）
-----------------------------

*Zend_Mail* 实例的缺省的传送器是 *Zend_Mail_Transport_Sendmail*\ ，它是 PHP `mail()`_
函数的基本封装。如果你想传递另外的参数给 `mail()`_
函数，只需要创建一个新的传送器实例并传递参数给构造器。新的传送器实例可以当作缺省的
*Zend_Mail* 的传送器，或者它可以被传递给 *Zend_Mail* 的 *send()* 方法。

.. _zend.mail.introduction.sendmail.example-1:

.. rubric:: 传递另外的参数给 Zend_Mail_Transport_Sendmail 传送器

这个例子示范如何修改 `mail()`_ 函数的返回路径。

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Mail.php';
   require_once 'Zend/Mail/Transport/Sendmail.php';

   $tr = new Zend_Mail_Transport_Sendmail('-freturn_to_me@example.com');
   Zend_Mail::setDefaultTransport($tr);

   $mail = new Zend_Mail();
   $mail->setBodyText('This is the text of the mail.');
   $mail->setFrom('somebody@example.com', 'Some Sender');
   $mail->addTo('somebody_else@example.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send();

.. note::

   **安全模式限制**

   如果 PHP 运行在安全模式，另外的可选参数将导致 `mail()`_ 函数失败。



.. _`mail()`: http://php.net/mail
