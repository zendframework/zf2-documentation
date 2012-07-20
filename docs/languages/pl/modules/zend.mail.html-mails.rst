.. _zend.mail.html-mails:

E-mail w postaci HTML
=====================

Aby wysłać e-mail w formacie HTML, ustaw treść za pomocą metody *setBodyHTML()* zamiast *setBodyText()*. Typ
MIME zostanie automatycznie ustawiony na *text/html*. Jeśli używasz zarówno treści HTML jak i tekstowej to
automatycznie zostanie wygenerowana wiadomość o typie MIME *multipart/alternative*:

.. _zend.mail.html-mails.example-1:

.. rubric:: Wysyłanie e-maila w postaci HTML

.. code-block::
   :linenos:

   $mail = new Zend_Mail();
   $mail->setBodyText('Testowy tekst');
   $mail->setBodyHtml('<b>Testowy</b> tekst');
   $mail->setFrom('somebody@example.com', 'Nadawca');
   $mail->addTo('somebody_else@example.com', 'Odbiorca');
   $mail->setSubject('Testowy temat');
   $mail->send();



