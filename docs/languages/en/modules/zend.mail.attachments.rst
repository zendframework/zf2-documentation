.. _zend.mail.attachments:

E-mail Attachments
==================

In ZF1 files could be attached to an e-mail using ``Zend_Mail::createAttachment()`` and ``Zend_Mail::addAttachment()`` methods.

In ZF2 these methods are not available anymore, so the correct way of dealing with multipart e-mails is using the ``Zend\Mime`` package.

Using Zend\\Mime\\Part
----------------------

.. _zend.mail.attachments.example:

.. code-block:: php
   :linenos:

   Use Zend\Mime, Zend\Mail\Message;
    
   // first create the parts
   $text = new Mime\Part();
   $text->type = Mime\Mime::TYPE_TEXT;
   $text->charset = 'utf-8';
   
   $fileContents = fopen($somefilePath, 'r');
   $attachment = new Mime\Part($fileContent);
   $attachment->type = 'image/jpg';
   $attachment->filename = 'image-file-name.jpg';
   $attachment->disposition = Mime\Mime::DISPOSITION_ATTACHMENT;
   // Setting the encoding is recommended for binary data
   $attachment->encoding = Mime\Mime::ENCODING_BASE64; 
   
   // then add them to a MIME message
   $mimeMessage = new Mime\Message();
   $mimeMessage->setParts(array($text, $attachment));
   
   // and finally we create the actual email
   $message = new Message();
   $message->setBody($mimeMessage);


Please see :ref:`Zend\\Mail\\Message<zend.mail.message>` documentation for more informations.
