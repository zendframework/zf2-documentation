.. _zend.mime.part:

Zend\\Mime\\Part
================

.. _zend.mime.part.introduction:

Introduction
------------

This class represents a single part of a *MIME* message. It contains the actual content of the message part plus
information about its encoding, content type and original filename. It provides a method for generating a string
from the stored data. ``Zend\Mime\Part`` objects can be added to :ref:`Zend\\Mime\\Message <zend.mime.message>` to
assemble a complete multipart message.

.. _zend.mime.part.instantiation:

Instantiation
-------------

``Zend\Mime\Part`` is instantiated with a string that represents the content of the new part. The type is assumed
to be OCTET-STREAM, encoding is 8Bit. After instantiating a ``Zend\Mime\Part``, meta information can be set by
accessing its attributes directly:

.. code-block:: php
   :linenos:

   public $type = Zend\Mime\Mime::TYPE_OCTETSTREAM;
   public $encoding = Zend\Mime\Mime::ENCODING_8BIT;
   public $id;
   public $disposition;
   public $filename;
   public $description;
   public $charset;
   public $boundary;
   public $location;
   public $language;

.. _zend.mime.part.methods:

Methods for rendering the message part to a string
--------------------------------------------------

``getContent()`` returns the encoded content of the ``Zend\Mime\Part`` as a string using the encoding specified in
the attribute ``$encoding``. Valid values are Zend\Mime\Mime::ENCODING_*. Characterset conversions are not performed.

``getHeaders()`` returns the Mime-Headers for the ``Zend\Mime\Part`` as generated from the information in the publicly
accessible attributes. The attributes of the object need to be set correctly before this method is called.


- ``$charset`` has to be set to the actual charset of the content if it is a text type (Text or *HTML*).

- ``$id`` may be set to identify a content-id for inline images in a *HTML* mail.

- ``$filename`` contains the name the file will get when downloading it.

- ``$disposition`` defines if the file should be treated as an attachment or if it is used inside the (HTML-) mail
  (inline).

- ``$description`` is only used for informational purposes.

- ``$boundary`` defines string as boundary.

- ``$location`` can be used as resource *URI* that has relation to the content.

- ``$language`` defines languages in the content.

Available methods
-----------------

A ``Zend\Mime\Part`` object has the following methods:

- ``isStream``: Check if this ``Zend\Mime\Part`` can be read as a stream.

- ``getEncodedStream``: If this ``Zend\Mime\Part`` was created with a stream, return a filtered stream for reading
  the content. Useful for large file attachments.

- ``getContent($EOL=Zend\Mime\Mime::LINEEND)``: Get the content of the current ``Zend\Mime\Part`` in the given 
  encoding.

- ``getRawContent``: Get the raw, unencoded for the current ``Zend\Mime\Part``.

- ``getHeadersArray($EOL=Zend\Mime\Mime::LINEEND)``: Create and return the array of headers for the current
  ``Zend\Mime\Part``.

- ``getHeaders($EOL=Zend\Mime\Mime::LINEEND)``: Return the headers for the current ``Zend\Mime\Part`` as a string.
