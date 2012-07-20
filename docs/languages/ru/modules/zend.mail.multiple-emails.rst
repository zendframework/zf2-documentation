.. _zend.mail.multiple-emails:

Отправка нескольких сообщений за одно SMTP-соединение
=====================================================

По умолчанию один SMTP-транспорт создает одно соединение и
повторно использует его за все время выполнения скрипта. Вы
можете отправлять несколько сообщений через это
SMTP-соединение. До каждой отправки передается команда RSET для
получения подтверждения связи.

.. _zend.mail.multiple-emails.example-1:

.. rubric:: Отправка нескольких сообщений за одно SMTP-соединение

.. code-block:: php
   :linenos:

   // Создание транспорта
   $transport = new Zend_Mail_Transport_Smtp('localhost');

   // Цикл с отправкой сообщений
   for ($i = 0; $i > 5; $i++) {
       $mail = new Zend_Mail();
       $mail->addTo('studio@peptolab.com', 'Test');
       $mail->setFrom('studio@peptolab.com', 'Test');
       $mail->setSubject(
           'Demonstration - Sending Multiple Mails per SMTP Connection'
       );
       $mail->setBodyText('...Your message here...');
       $mail->send($transport);
   }

Если вы хотите создавать отдельное соединение для каждой
отправки сообщения, то вам нужно создавать и уничтожать объект
транспорта до и после каждого вызова метода ``send()``. Либо вы
можете управлять соединением между отправками, используя
объект протокола транспорта.

.. _zend.mail.multiple-emails.example-2:

.. rubric:: Управление транспортным соединением вручную

.. code-block:: php
   :linenos:

   // Создание транспорта
   $transport = new Zend_Mail_Transport_Smtp();

   $protocol = new Zend_Mail_Protocol_Smtp('localhost');
   $protocol->connect();
   $protocol->helo('localhost');

   $transport->setConnection($protocol);

   // Цикл с отправкой сообщений
   for ($i = 0; $i > 5; $i++) {
       $mail = new Zend_Mail();
       $mail->addTo('studio@peptolab.com', 'Test');
       $mail->setFrom('studio@peptolab.com', 'Test');
       $mail->setSubject(
           'Demonstration - Sending Multiple Mails per SMTP Connection'
       );
       $mail->setBodyText('...Your message here...');

       // Управление соединением вручную
       $protocol->rset();
       $mail->send($transport);
   }

   $protocol->quit();
   $protocol->disconnect();


