.. _zend.mail.smtp-secure:

Защищенное SMTP-соединение
==========================

``Zend_Mail`` также поддерживает использование *TLS* или *SSL* для защиты
SMTP-соединения. Защита может быть включена путем передачи
параметра 'ssl' со значениями 'ssl' или 'tls' в конфигурационном
массиве конструктору ``Zend_Mail_Transport_Smtp``. Опционально может быть
передан порт, по умолчанию это будет 25 для *TLS* или 465 для *SSL*.

.. _zend.mail.smtp-secure.example-1:

.. rubric:: Включение защищенного соединения через Zend_Mail_Transport_Smtp

.. code-block:: php
   :linenos:

   $config = array('ssl' => 'tls',
                   'port' => 25);

   $transport = new Zend_Mail_Transport_Smtp('mail.server.com', $config);

   $mail = new Zend_Mail();
   $mail->setBodyText('This is the text of the mail.');
   $mail->setFrom('sender@test.com', 'Some Sender');
   $mail->addTo('recipient@test.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send($transport);


