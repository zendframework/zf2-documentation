.. EN-Revision: none
.. _zend.mail.smtp-authentication:

SMTP-аутентификация
===================

``Zend_Mail`` поддерживает использование SMTP-аутентификации, которая
может быть включена путем передачи параметра 'auth' в
конфигурационном массиве конструктору ``Zend_Mail_Transport_Smtp``.
Доступные встроенные методы аутентификации - PLAIN, LOGIN и CRAM-MD5,
все они ожидают передачи значений 'username' и 'password' в
конфигурационном массиве.

.. _zend.mail.smtp-authentication.example-1:

.. rubric:: Включение аутентификации в Zend_Mail_Transport_Smtp

.. code-block:: php
   :linenos:

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

   **Типы аутентификации**

   Тип аутентификации является регистронезависимым, но не
   должен включать пунктуацию. Например, для того, чтобы
   использовать CRAM-MD5, передавайте 'auth' => 'crammd5' конструктору
   ``Zend_Mail_Transport_Smtp``.


