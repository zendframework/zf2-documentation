.. EN-Revision: none
.. _zend.mail.multiple-emails:

Wysyłanie wielu maili podczas jednego połączenia SMTP
=====================================================

Domyślnie, połączenie SMTP jest tworzone jeden raz i używane przez cały czas działania skryptu. Możesz
wysłać wiele wiadomości używając tego samego połączenia. Aby upewnić się że połączenie SMTP jest
utrzymane, przed każdym dostarczeniem widomości wysyłana jest komenda RSET.

.. _zend.mail.multiple-emails.example-1:

.. rubric:: Wysyłanie wielu maili podczas jednego połączenia SMTP

.. code-block:: php
   :linenos:

   // Tworzenie transportu
   $transport = new Zend_Mail_Transport_Smtp('localhost');

   // Pętla wysyłająca wiadomości
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


Jeśli potrzebujesz oddzielnego połączenia do każdego wysłania wiadomości, musisz tworzyć i niszczyć
transport przed i po każdym wywołaniu metody ``send()``. Alternatywnie możesz manipulować połączeniem między
każdym wysyłaniem, poprzez dostęp do obiektu protokołu transportu.

.. _zend.mail.multiple-emails.example-2:

.. rubric:: Ręczna obsługa połączenia

.. code-block:: php
   :linenos:

   // Tworzenie transportu
   $transport = new Zend_Mail_Transport_Smtp();

   require_once 'Zend/Mail/Protocol/Smtp.php';
   $protocol = new Zend_Mail_Protocol_Smtp('localhost');
   $protocol->connect();
   $protocol->helo('localhost');

   $transport->setConnection($protocol);

   // Pętla wysyłająca wiadomości
   for ($i = 0; $i > 5; $i++) {
       $mail = new Zend_Mail();
       $mail->addTo('studio@peptolab.com', 'Test');
       $mail->setFrom('studio@peptolab.com', 'Test');
       $mail->setSubject(
           'Demonstration - Sending Multiple Mails per SMTP Connection'
       );
       $mail->setBodyText('...Your message here...');

       // Ręczna obsługa połączenia
       $protocol->rset();
       $mail->send($transport);
   }

   $protocol->quit();
   $protocol->disconnect();



