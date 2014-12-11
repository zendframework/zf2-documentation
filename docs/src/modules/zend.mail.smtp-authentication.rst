.. _zend.mail.smtp-authentication:

SMTP Authentication
===================

``Zend\Mail`` supports the use of SMTP authentication, which can be enabled be passing the 'auth' parameter to the
configuration array in the ``Zend\Mail\Transport\Smtp`` constructor. The available built-in authentication methods
are PLAIN, LOGIN and CRAM-MD5 which all expect a 'username' and 'password' value in the configuration array.

.. _zend.mail.smtp-authentication.example-1:

.. rubric:: Enabling authentication within Zend\Mail\Transport\Smtp

.. code-block:: php
   :linenos:

   $config = array('auth' => 'login',
                   'username' => 'myusername',
                   'password' => 'password');

   $transport = new Zend\Mail\Transport\Smtp('mail.server.com', $config);

   $mail = new Zend\Mail\Message();
   $mail->setBodyText('This is the text of the mail.');
   $mail->setFrom('sender@test.com', 'Some Sender');
   $mail->addTo('recipient@test.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send($transport);

.. note::

   **Authentication types**

   The authentication type is case-insensitive but has no punctuation. E.g. to use CRAM-MD5 you would pass 'auth'
   => 'crammd5' in the ``Zend\Mail\Transport\Smtp`` constructor.


