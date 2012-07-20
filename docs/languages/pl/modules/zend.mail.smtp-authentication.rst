.. _zend.mail.smtp-authentication:

Uwierzytelnianie SMTP
=====================

Klasa *Zend_Mail* obsługuje uwierzytelnianie SMTP, które może być aktywowane przez przekazanie parametru 'auth'
w tablicy konfiguracyjnej do konstruktora klasy *Zend_Mail_Transport_Smtp*. Dostępnymi wbudowanymi metodami
uwierzytelniania są metody PLAIN, LOGIN oraz CRAM-MD5. Wszystkie wymagają wartości 'username' oraz 'password' w
tablicy konfiguracyjnej.

.. _zend.mail.smtp-authentication.example-1:

.. rubric:: Aktywowanie uwierzytelniania w klasie Zend_Mail_Transport_Smtp

.. code-block::
   :linenos:

   $config = array('auth' => 'login',
                   'username' => 'myusername',
                   'password' => 'password');

   $transport = new Zend_Mail_Transport_Smtp('mail.server.com', $config);

   $mail = new Zend_Mail();
   $mail->setBodyText('To jest treść wiadomości e-mail.');
   $mail->setFrom('sender@test.com', 'Nadawca');
   $mail->addTo('recipient@test.com', 'Adresat');
   $mail->setSubject('Testowy temat');
   $mail->send($transport);


.. note::

   **Typy uwierzytelniania**

   Nie znaczenia czy nazwę typu uwierzytelniania podamy używając wielkich czy małych liter, ale podajemy ją
   bez znaków interpunkcyjnych. Np. aby użyć adaptera CRAM-MD5 powinieneś przekazać parametr 'auth' =>
   'crammd5' do konstruktora klasy *Zend_Mail_Transport_Smtp*.


