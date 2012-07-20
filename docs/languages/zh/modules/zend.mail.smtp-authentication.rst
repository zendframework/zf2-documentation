.. _zend.mail.smtp-authentication:

SMTP 身份验证
=========

*Zend_Mail* 支持使用 SMTP 身份验证，通过配置数组传递“auth”参数到 *Zend_Mail_Transport_Smtp*
的构造函数中。可用的内建身份验证方法为 PLAIN，LOGIN 和
CRAM-MD5，这些都需要在配置数组中设置“username”和“password”。

.. _zend.mail.smtp-authentication.example-1:

.. rubric:: 在 Zend_Mail_Transport_Smtp 中使用身份验证

.. code-block::
   :linenos:
   <?php

               require_once 'Zend/Mail.php';
               require_once 'Zend/Mail/Transport/Smtp.php';

               $config = array('auth' => 'login',
               'username' => 'myusername',
               'password' => 'password');

               $transport = new Zend_Mail_Transport_Smtp('mail.server.com', $config);

               $mail = new Zend_Mail();
               $mail->setBodyText('This is the text of the mail.');
               $mail->setFrom('sender@test.com', 'Some Sender');
               $mail->addTo('recipient@test.com', 'Some Recipient');
               $mail->setSubject('TestSubject');
               $mail->send($transport);

.. note::

   **身份验证类型**

   身份验证的类型是大小写不敏感的，但是不能有标点符号。例如，使用 CRAM-MD5
   类型，则应当传递 'auth' => 'crammd5' 到 *Zend_Mail_Transport_Smtp* 的构造函数中。


