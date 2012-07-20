.. _zend.mail.html-mails:

Émail HTML
==========

Pour envoyer un émail au format HTML, définissez le corps du message en utilisant la méthode ``setBodyHTML()``
à la place de ``setBodyText()``. Le type de contenu *MIME* sera automatiquement définit à *text/html*. Si vous
utilisez les formats textes et HTML, un message *MIME* de type multipart/alternative sera automatiquement généré
:

.. _zend.mail.html-mails.example-1:

.. rubric:: Envoyer des émail HTML

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->setBodyText('Mon texte de test');
   $mail->setBodyHtml('Mon texte de test');
   $mail->setFrom('somebody@exemple.com', 'Un expéditeur');
   $mail->addTo('somebody_else@exemple.com', 'Un destinataire');
   $mail->setSubject('Sujet de test');
   $mail->send();


