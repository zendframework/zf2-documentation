.. _zend.mime.mime:

Zend\\Mime
==========

.. _zend.mime.mime.introduction:

Introduction
------------

``Zend\Mime\Mime`` is a support class for handling multipart *MIME* messages. It is used by :ref:`Zend\\Mail <zend.mail>`
and :ref:`Zend\\Mime\\Message <zend.mime.message>` and may be used by applications requiring *MIME* support.

.. _zend.mime.mime.static:

Static Methods and Constants
----------------------------

``Zend\Mime\Mime`` provides a simple set of static helper methods to work with *MIME*:

- ``Zend\Mime\Mime::isPrintable()``: Returns ``TRUE`` if the given string contains no unprintable characters,
  ``FALSE`` otherwise.

- ``Zend\Mime\Mime::encode()``: Encodes a string with specified encoding.

- ``Zend\Mime\Mime::encodeBase64()``: Encodes a string into base64 encoding.

- ``Zend\Mime\Mime::encodeQuotedPrintable()``: Encodes a string with the quoted-printable mechanism.

- ``Zend\Mime\Mime::encodeBase64Header()``: Encodes a string into base64 encoding for Mail Headers.

- ``Zend\Mime\Mime::encodeQuotedPrintableHeader()``: Encodes a string with the quoted-printable mechanism for
  Mail Headers.



``Zend\Mime\Mime`` defines a set of constants commonly used with *MIME* messages:

- ``Zend\Mime\Mime::TYPE_OCTETSTREAM``: 'application/octet-stream'

- ``Zend\Mime\Mime::TYPE_TEXT``: 'text/plain'

- ``Zend\Mime\Mime::TYPE_HTML``: 'text/html'

- ``Zend\Mime\Mime::ENCODING_7BIT``: '7bit'

- ``Zend\Mime\Mime::ENCODING_8BIT``: '8bit'

- ``Zend\Mime\Mime::ENCODING_QUOTEDPRINTABLE``: 'quoted-printable'

- ``Zend\Mime\Mime::ENCODING_BASE64``: 'base64'

- ``Zend\Mime\Mime::DISPOSITION_ATTACHMENT``: 'attachment'

- ``Zend\Mime\Mime::DISPOSITION_INLINE``: 'inline'

- ``Zend\Mime\Mime::MULTIPART_ALTERNATIVE``: 'multipart/alternative'

- ``Zend\Mime\Mime::MULTIPART_MIXED``: 'multipart/mixed'

- ``Zend\Mime\Mime::MULTIPART_RELATED``: 'multipart/related'



.. _zend.mime.mime.instantiation:

Instantiating Zend\\Mime
------------------------

When instantiating a ``Zend\Mime\Mime`` object, a *MIME* boundary is stored that is used for all subsequent non-static
method calls on that object. If the constructor is called with a string parameter, this value is used as a *MIME*
boundary. If not, a random *MIME* boundary is generated during construction time.

A ``Zend\Mime\Mime`` object has the following methods:

- ``boundary()``: Returns the *MIME* boundary string.

- ``boundaryLine()``: Returns the complete *MIME* boundary line.

- ``mimeEnd()``: Returns the complete *MIME* end boundary line.


