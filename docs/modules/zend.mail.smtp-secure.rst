
.. _zend.mail.smtp-secure:

Securing SMTP Transport
=======================

``Zend_Mail`` also supports the use of either TLS or *SSL* to secure a SMTP connection. This can be enabled be passing the 'ssl' parameter to the configuration array in the ``Zend_Mail_Transport_Smtp`` constructor with a value of either 'ssl' or 'tls'. A port can optionally be supplied, otherwise it defaults to 25 for TLS or 465 for *SSL*.


.. _zend.mail.smtp-secure.example-1:

.. rubric:: Enabling a secure connection within Zend_Mail_Transport_Smtp

.. code-block:: php
   :linenos:

   $config = array('ssl' => 'tls',
                   'port' => 25); // Optional port number supplied

   $transport = new Zend_Mail_Transport_Smtp('mail.server.com', $config);

   $mail = new Zend_Mail();
   $mail->setBodyText('This is the text of the mail.');
   $mail->setFrom('sender@test.com', 'Some Sender');
   $mail->addTo('recipient@test.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send($transport);


