.. _zend.mail.attachments:

E-mail Attachments
===========

In ZF1 files could be attached to an e-mail using ``Zend\Mail\Message`` ``createAttachment()`` and ``addAttachment()`` methods.

In ZF2 these methods are not available anymore, so the standard method of dealing with multipart e-mails is using the ``Zend\Mime`` package.

Using Zend\\Mime\\Part
----------------------

.. _zend.mail.attachments.example:

.. code-block:: php
   :linenos:

   // first create the parts
   $text = new Zend\Mime\Part();
   $text->type = Zend\Mime\Mime::TYPE_TEXT;
   $text->charset = 'utf-8';
   
   $fileContents = fopen($somefilePath, 'r');
   $attachment = new Zend\Mime\Part($fileContent);
   $attachment->type = 'image/jpg';
   $attachment->disposition = Zend\Mime\Mime::DISPOSITION_ATTACHMENT;
   
   // then add them to a MIME message
   $mimeMessage = new Zend\Mime\Message();
   $mimeMessage->setParts(array($text, $attachment));
   
   // and finally we create the actual email
   $message = new Message();
   $message->setBody($mimeMessage);


Please see the :ref:`Mail Message section <zend.mail.message>` for a more comprehensive guide.
