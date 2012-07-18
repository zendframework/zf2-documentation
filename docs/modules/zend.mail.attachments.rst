.. _zend.mail.attachments:

Attachments
===========

Files can be attached to an e-mail using the ``createAttachment()`` method. The default behavior of ``Zend_Mail`` is to assume the attachment is a binary object (``application/octet-stream``), that it should be transferred with base64 encoding, and that it is handled as an attachment. These assumptions can be overridden by passing more parameters to ``createAttachment()``:

.. _zend.mail.attachments.example-1:

.. rubric:: E-Mail Messages with Attachments

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   // build message...
   $mail->createAttachment($someBinaryString);
   $mail->createAttachment($myImage,
                           'image/gif',
                           Zend_Mime::DISPOSITION_INLINE,
                           Zend_Mime::ENCODING_BASE64);

If you want more control over the *MIME* part generated for this attachment you can use the return value of ``createAttachment()`` to modify its attributes. The ``createAttachment()`` method returns a ``Zend_Mime_Part`` object:

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();

   $at = $mail->createAttachment($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend_Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend_Mime::ENCODING_BASE64;
   $at->filename    = 'test.gif';

   $mail->send();

An alternative is to create an instance of ``Zend_Mime_Part`` and add it with ``addAttachment()``:

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();

   $at = new Zend_Mime_Part($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend_Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend_Mime::ENCODING_BASE64;
   $at->filename    = 'test.gif';

   $mail->addAttachment($at);

   $mail->send();


