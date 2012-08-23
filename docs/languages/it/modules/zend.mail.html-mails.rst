.. EN-Revision: none
.. _zend.mail.html-mails:

E-mail HTML
===========

Per inviare un'e-mail in formato HTML impostare il contenuto utilizzando il metodo *setBodyHTML()* al posto di
*setBodyText()*. Il tipo di contenuto MIME sarà impostato automaticamente a *text/html*. Se si fornisce un
contenuto sia in formato HTML sia Testo verrà automaticamente generato un messaggio di tipo multipart/alternative
MIME:

.. _zend.mail.html-mails.example-1:

.. rubric:: Invio di e-mail HTML

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   $mail->setBodyText('Un bel testo di test');
   $mail->setBodyHtml('Un bel testo di <b>Test</b>');
   $mail->setFrom('qualcuno@example.com', 'Un mittente');
   $mail->addTo('qualcunaltro@example.com', 'Un destinatario');
   $mail->setSubject('Oggetto testuale');
   $mail->send();


