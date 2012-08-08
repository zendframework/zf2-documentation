.. EN-Revision: none
.. _zend.mail.html-mails:

HTML メール
========

*HTML* 形式のメールを送信するには、本文を作成する際に ``setBodyText()`` ではなく
``setBodyHTML()`` を使用します。 すると、 *MIME* content type が自動的に *text/html*
に設定されます。 *HTML* とプレーンテキストの両方を使用した場合は、
multipart/alternative な *MIME* メッセージが自動的に生成されます。

.. _zend.mail.html-mails.example-1:

.. rubric:: HTML メールの送信

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->setBodyText('My Nice Test Text');
   $mail->setBodyHtml('My Nice <b>Test</b> Text');
   $mail->setFrom('somebody@example.com', 'Some Sender');
   $mail->addTo('somebody_else@example.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send();


