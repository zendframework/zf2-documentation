.. _zend.mail.multiple-emails:

通过一个SMTP连接发送多个邮
=====================================

在缺省状态下，单个的 SMTP
传送器创建一个单个的连接并在整个脚本执行的生命周期重用，你可以这个 SMTP
连接发送多个邮件。每次投递之前发出一个 RSET 命令确保正确的 SMTP 握手被跟随。

.. _zend.mail.multiple-emails.example-1:

.. rubric:: 通过一个SMTP连接发送多个邮件

.. code-block::
   :linenos:
   <?php
   // Load classes
   require_once 'Zend/Mail.php';

   // Create transport
   require_once 'Zend/Mail/Transport/Smtp.php';
   $transport = new Zend_Mail_Transport_Smtp('localhost');

   // Loop through messages
   for ($i = 0; $i > 5; $i++) {
       $mail = new Zend_Mail();
       $mail->addTo('studio@peptolab.com', 'Test');
       $mail->setFrom('studio@peptolab.com', 'Test');
       $mail->setSubject('Demonstration - Sending Multiple Mails per SMTP Connection');
       $mail->setBodyText('...Your message here...');
       $mail->send($transport);
   }

如果想给每个邮件投递配备一个单独的连接，你需要在 ``send()``\
方法备调用的之前和之后创建和毁灭传送器；或者，在每个通过访问传送器协议对象投递之间处理连接。

.. _zend.mail.multiple-emails.example-2:

.. rubric:: 手工控制传送器连接

.. code-block::
   :linenos:
   <?php

   // Load classes
   require_once 'Zend/Mail.php';

   // Create transport
   require_once 'Zend/Mail/Transport/Smtp.php';
   $transport = new Zend_Mail_Transport_Smtp();

   require_once 'Zend/Mail/Protocol/Smtp.php';
   $protocol = new Zend_Mail_Protocol_Smtp('localhost');
   $protocol->connect();
   $protocol->helo('localhost');

   $transport->setConnection($protocol);

   // Loop through messages
   for ($i = 0; $i > 5; $i++) {
       $mail = new Zend_Mail();
       $mail->addTo('studio@peptolab.com', 'Test');
       $mail->setFrom('studio@peptolab.com', 'Test');
       $mail->setSubject('Demonstration - Sending Multiple Mails per SMTP Connection');
       $mail->setBodyText('...Your message here...');

       // Manually control the connection
       $protocol->rset();
       $mail->send($transport);
   }

   $protocol->quit();
   $protocol->disconnect();


