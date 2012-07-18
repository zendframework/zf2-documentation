.. _zend.mime.mime:

Zend_Mime
=========

.. _zend.mime.mime.introduction:

Introduction
------------

``Zend_Mime`` is a support class for handling multipart *MIME* messages. It is used by :ref:`Zend_Mail <zend.mail>`
and :ref:`Zend_Mime_Message <zend.mime.message>` and may be used by applications requiring *MIME* support.

.. _zend.mime.mime.static:

Static Methods and Constants
----------------------------

``Zend_Mime`` provides a simple set of static helper methods to work with *MIME*:



   - ``Zend_Mime::isPrintable()``: Returns ``TRUE`` if the given string contains no unprintable characters,
     ``FALSE`` otherwise.

   - ``Zend_Mime::encode()``: Encodes a string with specified encoding.

   - ``Zend_Mime::encodeBase64()``: Encodes a string into base64 encoding.

   - ``Zend_Mime::encodeQuotedPrintable()``: Encodes a string with the quoted-printable mechanism.

   - ``Zend_Mime::encodeBase64Header()``: Encodes a string into base64 encoding for Mail Headers.

   - ``Zend_Mime::encodeQuotedPrintableHeader()``: Encodes a string with the quoted-printable mechanism for Mail
     Headers.



``Zend_Mime`` defines a set of constants commonly used with *MIME* Messages:



   - ``Zend_Mime::TYPE_OCTETSTREAM``: 'application/octet-stream'

   - ``Zend_Mime::TYPE_TEXT``: 'text/plain'

   - ``Zend_Mime::TYPE_HTML``: 'text/html'

   - ``Zend_Mime::ENCODING_7BIT``: '7bit'

   - ``Zend_Mime::ENCODING_8BIT``: '8bit'

   - ``Zend_Mime::ENCODING_QUOTEDPRINTABLE``: 'quoted-printable'

   - ``Zend_Mime::ENCODING_BASE64``: 'base64'

   - ``Zend_Mime::DISPOSITION_ATTACHMENT``: 'attachment'

   - ``Zend_Mime::DISPOSITION_INLINE``: 'inline'

   - ``Zend_Mime::MULTIPART_ALTERNATIVE``: 'multipart/alternative'

   - ``Zend_Mime::MULTIPART_MIXED``: 'multipart/mixed'

   - ``Zend_Mime::MULTIPART_RELATED``: 'multipart/related'



.. _zend.mime.mime.instantiation:

Instantiating Zend_Mime
-----------------------

When Instantiating a ``Zend_Mime`` Object, a *MIME* boundary is stored that is used for all subsequent non-static
method calls on that object. If the constructor is called with a string parameter, this value is used as a *MIME*
boundary. If not, a random *MIME* boundary is generated during construction time.

A ``Zend_Mime`` object has the following Methods:



   - ``boundary()``: Returns the *MIME* boundary string.

   - ``boundaryLine()``: Returns the complete *MIME* boundary line.

   - ``mimeEnd()``: Returns the complete *MIME* end boundary line.




