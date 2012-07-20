.. _zend.mail.html-mails:

HTML邮件
======

发送HTML格式的邮件，使用 *setBodyHTML()*\ 方法来设置邮件正文而不是 *setBodyText()*\
方法，MIME类型会被自动设置为 *text/html*\ 。如果你既使用HTML又使用纯文本,
那么multipart/alternative MIME类型的邮件消息将会自动产生：

.. _zend.mail.html-mails.example-1:

.. rubric:: 发送HTML邮件

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   $mail->setBodyText('My Nice Test Text');
   $mail->setBodyHtml('My Nice <b>Test</b> Text');
   $mail->setFrom('somebody@example.com', 'Some Sender');
   $mail->addTo('somebody_else@example.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send();


