.. _zend.mail.additional-headers:

外加邮件头信息
=====================

使用 *addHeader()*\
方法可以外加任意的邮件头信息。它需要两个参数，头信息的名称和值，第三个可选的参数，它决定了该邮件头信息是否可以有多个值：

.. _zend.mail.additional-headers.example-1:

.. rubric:: 外加邮件头信息

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   $mail->addHeader('X-MailGenerator', 'MyCoolApplication');
   $mail->addHeader('X-greetingsTo', 'Mom', true); // multiple values
   $mail->addHeader('X-greetingsTo', 'Dad', true);


