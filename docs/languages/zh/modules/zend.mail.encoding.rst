.. _zend.mail.encoding:

Encoding
========

Text and *HTML* message bodies are encoded with the quotedprintable mechanism by default. Message headers are also
encoded with the quotedprintable mechanism if you do not specify base64 in ``setHeaderEncoding()``. If you use
language that is not Roman letters-based, the base64 would be more suitable. All other attachments are encoded via
base64 if no other encoding is given in the ``addAttachment()`` call or assigned to the *MIME* part object later.
7Bit and 8Bit encoding currently only pass on the binary content data.

Header Encoding, especially the encoding of the subject, is a tricky topic. ``Zend\Mail\Message`` currently implements its
own algorithm to encode quoted printable headers according to RFC-2045. This due to the problems of
``iconv_mime_encode()`` and ``mb_encode_mimeheader`` with regards to certain charsets. This algorithm only breaks
the header at spaces, which might lead to headers that far exceed the suggested length of 76 chars. For this cases
it is suggested to switch to BASE64 header encoding same as the following example describes:

.. code-block:: php
   :linenos:

   // By default Zend\Mime\Mime::ENCODING_QUOTEDPRINTABLE
   $mail = new Zend\Mail\Message('KOI8-R');

   // Reset to Base64 Encoding because Russian expressed in KOI8-R is
   // different from Roman letters-based languages greatly.
   $mail->setHeaderEncoding(Zend\Mime\Mime::ENCODING_BASE64);

``Zend\Mail\Transport\Smtp`` encodes lines starting with one dot or two dots so that the mail does not violate the
SMTP protocol.


