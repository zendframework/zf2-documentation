.. _zend.mail.html-mails:

HTML E-Mail
===========

To send an e-mail in *HTML* format, set the body using the method ``setBodyHTML()`` instead of ``setBodyText()``.
The *MIME* content type will automatically be set to ``text/html`` then. If you use both *HTML* and Text bodies, a
multipart/alternative *MIME* message will automatically be generated:

.. _zend.mail.html-mails.example-1:

.. rubric:: Sending HTML E-Mail

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Message();
   $mail->setBodyText('My Nice Test Text');
   $mail->setBodyHtml('My Nice <b>Test</b> Text');
   $mail->setFrom('somebody@example.com', 'Some Sender');
   $mail->addTo('somebody_else@example.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send();


