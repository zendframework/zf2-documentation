.. EN-Revision: none
.. _zend.mail.html-mails:

Сообщение в формате HTML
========================

Для отправки сообщения электронной почты в формате HTML
устанавливайте тело сообщения через метод ``setBodyHTML()`` вместо
использования ``setBodyText()``. Тип содержимого *MIME* будет
автоматически установлен в *text/html*. Если вы используете как
текстовый, так и HTML-формат, то будет автоматически
сгенерировано MIME-сообщение типа *multipart/alternative*:

.. _zend.mail.html-mails.example-1:

.. rubric:: Отправка сообщения в формате HTML

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->setBodyText('My Nice Test Text');
   $mail->setBodyHtml('My Nice <b>Test</b> Text');
   $mail->setFrom('somebody@example.com', 'Some Sender');
   $mail->addTo('somebody_else@example.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send();


