.. _zend.mail.attachments:

Attachments
===========

Files can be attached to an e-mail using the ``createAttachment()`` method. The default behavior of ``Zend\Mail\Message``
is to assume the attachment is a binary object (``application/octet-stream``), that it should be transferred with
base64 encoding, and that it is handled as an attachment. These assumptions can be overridden by passing more
parameters to ``createAttachment()``:

.. _zend.mail.attachments.example-1:

.. rubric:: E-Mail Messages with Attachments

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Message();
   // build message...
   $mail->createAttachment($someBinaryString);
   $mail->createAttachment($myImage,
                           'image/gif',
                           Zend\Mime\Mime::DISPOSITION_INLINE,
                           Zend\Mime\Mime::ENCODING_BASE64);

If you want more control over the *MIME* part generated for this attachment you can use the return value of
``createAttachment()`` to modify its attributes. The ``createAttachment()`` method returns a ``Zend\Mime\Part``
object:

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Message();

   $at = $mail->createAttachment($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend\Mime\Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend\Mime\Mime::ENCODING_BASE64;
   $at->filename    = 'test.gif';

   $mail->send();

An alternative is to create an instance of ``Zend\Mime\Part`` and add it with ``addAttachment()``:

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Message();

   $at = new Zend\Mime\Part($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend\Mime\Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend\Mime\Mime::ENCODING_BASE64;
   $at->filename    = 'test.gif';

   $mail->addAttachment($at);

   $mail->send();


