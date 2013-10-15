.. EN-Revision: none
.. _zend.mail.smtp-authentication:

SMTP-аутентификация
===================

``Zend_Mail`` поддерживает использование SMTP-аутентификации, которая
может быть включена путем передачи параметра 'auth' в
конфигурационном массиве конструктору ``Zend\Mail\Transport\Smtp``.
Доступные встроенные методы аутентификации - PLAIN, LOGIN и CRAM-MD5,
все они ожидают передачи значений 'username' и 'password' в
конфигурационном массиве.

.. _zend.mail.smtp-authentication.example-1:

.. rubric:: Включение аутентификации в Zend\Mail\Transport\Smtp

.. code-block:: php
   :linenos:

   $config = array('auth' => 'login',
                   'username' => 'myusername',
                   'password' => 'password');

   $transport = new Zend\Mail\Transport\Smtp('mail.server.com', $config);

   $mail = new Zend\Mail\Mail();
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
   ``Zend\Mail\Transport\Smtp``.


