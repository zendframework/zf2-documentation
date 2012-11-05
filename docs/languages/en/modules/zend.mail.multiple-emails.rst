.. _zend.mail.multiple-emails:

Sending Multiple Mails per SMTP Connection
==========================================

By default, a single SMTP transport creates a single connection and re-uses it for the lifetime of the script
execution. You may send multiple e-mails through this SMTP connection. A RSET command is issued before each
delivery to ensure the correct SMTP handshake is followed.

Optionally, you can also define a default From email address and name, as well as a default reply-to header. This
can be done through the static methods ``setDefaultFrom()`` and ``setDefaultReplyTo()``. These defaults will be
used when you don't specify a From/Reply-to Address or -Name until the defaults are reset (cleared). Resetting the
defaults can be done through the use of the ``clearDefaultFrom()`` and ``clearDefaultReplyTo``.

.. _zend.mail.multiple-emails.example-1:

.. rubric:: Sending Multiple Mails per SMTP Connection

.. code-block:: php
   :linenos:

   // Create transport
   $config = array('name' => 'sender.example.com');
   $transport = new Zend\Mail\Transport\Smtp('mail.example.com', $config);

   // Set From & Reply-To address and name for all emails to send.
   Zend\Mail\Message::setDefaultFrom('sender@example.com', 'John Doe');
   Zend\Mail\Message::setDefaultReplyTo('replyto@example.com','Jane Doe');

   // Loop through messages
   for ($i = 0; $i < 5; $i++) {
       $mail = new Zend\Mail\Message();
       $mail->addTo('studio@example.com', 'Test');

       $mail->setSubject(
           'Demonstration - Sending Multiple Mails per SMTP Connection'
       );
       $mail->setBodyText('...Your message here...');
       $mail->send($transport);
   }

   // Reset defaults
   Zend\Mail\Message::clearDefaultFrom();
   Zend\Mail\Message::clearDefaultReplyTo();

If you wish to have a separate connection for each mail delivery, you will need to create and destroy your
transport before and after each ``send()`` method is called. Or alternatively, you can manipulate the connection
between each delivery by accessing the transport's protocol object.

.. _zend.mail.multiple-emails.example-2:

.. rubric:: Manually controlling the transport connection

.. code-block:: php
   :linenos:

   // Create transport
   $transport = new Zend\Mail\Transport\Smtp();

   $protocol = new Zend\Mail\Protocol\Smtp('mail.example.com');
   $protocol->connect();
   $protocol->helo('sender.example.com');

   $transport->setConnection($protocol);

   // Loop through messages
   for ($i = 0; $i < 5; $i++) {
       $mail = new Zend\Mail\Message();
       $mail->addTo('studio@example.com', 'Test');
       $mail->setFrom('studio@example.com', 'Test');
       $mail->setSubject(
           'Demonstration - Sending Multiple Mails per SMTP Connection'
       );
       $mail->setBodyText('...Your message here...');

       // Manually control the connection
       $protocol->rset();
       $mail->send($transport);
   }

   $protocol->quit();
   $protocol->disconnect();


