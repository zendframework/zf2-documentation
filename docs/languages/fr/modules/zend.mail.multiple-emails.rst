.. _zend.mail.multiple-emails:

Envoyer plusieurs émail par connexion SMTP
==========================================

Par défaut un transport SMTP unique crée une connexion unique et la réutilise pour toute la durée de la vie du
script. Vous pouvez envoyer plusieurs émail à travers cette connexion SMTP. Une commande RSET doit être envoyée
avant chaque distribution pour garantir que le dialogue SMTP correct est respecté.

Optionally, you can also define a default From email address and name, as well as a default reply-to header. This
can be done through the static methods ``setDefaultFrom()`` and ``setDefaultReplyTo()``. These defaults will be
used when you don't specify a From/Reply-to Address or -Name until the defaults are reset (cleared). Resetting the
defaults can be done through the use of the ``clearDefaultFrom()`` and ``clearDefaultReplyTo``.

.. _zend.mail.multiple-emails.example-1:

.. rubric:: Envoyer plusieurs émail par connexion SMTP

.. code-block:: php
   :linenos:

   // Créer un transport
   $config = array('name' => 'sender.example.com');
   $transport = new Zend_Mail_Transport_Smtp('mail.example.com', $config);

   // Ajouter les nom et adresses "From" & "Reply-To" pour tous les émails
   // à envoyer
   Zend_Mail::setDefaultFrom('sender@example.com', 'John Doe');
   Zend_Mail::setDefaultReplyTo('replyto@example.com','Jane Doe');

   // Boucle à travers les messages
   for ($i = 0; $i < 5; $i++) {
       $mail = new Zend_Mail();
       $mail->addTo('studio@example.com', 'Test');
       $mail->setSubject(
           'Démonstration - Envoyer plusieurs emails par connexion SMTP'
       );
       $mail->setBodyText('...Votre message ici...');
       $mail->send($transport);
   }

   // Effacer les valeurs par défaut
   Zend_Mail::clearDefaultFrom();
   Zend_Mail::clearDefaultReplyTo();

Si vous voulez avoir une connexion SMTP séparée pour chaque distribution d'émail, vous devez créer et détruire
votre transport avant et après chaque appel de la méthode ``send()``. Ou sinon, vous pouvez manipuler la
connexion entre chaque distribution en accédant à l'objet de protocole de transport.

.. _zend.mail.multiple-emails.example-2:

.. rubric:: Contrôler manuellement la connexion de transport

.. code-block:: php
   :linenos:

   // Créer un transport
   $transport = new Zend_Mail_Transport_Smtp();

   $protocol = new Zend_Mail_Protocol_Smtp('mail.example.com');
   $protocol->connect();
   $protocol->helo('sender.example.com');

   $transport->setConnection($protocol);

   // Boucle à travers les messages
   for ($i = 0; $i < 5; $i++) {
       $mail = new Zend_Mail();
       $mail->addTo('studio@example.com', 'Test');
       $mail->setFrom('studio@example.com', 'Test');
       $mail->setSubject(
           'Démonstration - Envoyer plusieurs emails par connexion SMTP'
       );
       $mail->setBodyText('...Votre message ici...');

       // Contrôler manuellement la connexion
       $protocol->rset();
       $mail->send($transport);
   }

   $protocol->quit();
   $protocol->disconnect();


