.. _zend.mime.message:

Zend\\Mime\\Message
===================

.. _zend.mime.message.introduction:

Introduction
------------

``Zend\Mime\Message`` represents a *MIME* compliant message that can contain one or more separate Parts
(Represented as :ref:`Zend\\Mime\\Part <zend.mime.part>` objects). With ``Zend\Mime\Message``, *MIME* compliant
multipart messages can be generated from ``Zend\Mime\Part`` objects. Encoding and Boundary handling are handled
transparently by the class. ``Zend\Mime\Message`` objects can also be reconstructed from given strings. Used by
:ref:`Zend\\Mail <zend.mail>`.

.. _zend.mime.message.instantiation:

Instantiation
-------------

There is no explicit constructor for ``Zend\Mime\Message``.

.. _zend.mime.message.addparts:

Adding MIME Parts
-----------------

:ref:`Zend\\Mime\\Part <zend.mime.part>` Objects can be added to a given ``Zend\Mime\Message`` object by calling
``->addPart($part)``

An array with all :ref:`Zend\\Mime\\Part <zend.mime.part>` objects in the ``Zend\Mime\Message`` is returned from 
the method ``getParts()``. The ``Zend\Mime\Part`` objects can then be changed since they are stored in the array as
references. If parts are added to the array or the sequence is changed, the array needs to be given back to the
:ref:`Zend\\Mime\\Part <zend.mime.part>` object by calling ``setParts($partsArray)``.

The function ``isMultiPart()`` will return ``TRUE`` if more than one part is registered with the
``Zend\Mime\Message`` object and thus the object would generate a Multipart-Mime-Message when generating the actual
output.

.. _zend.mime.message.bondary:

Boundary handling
-----------------

``Zend\Mime\Message`` usually creates and uses its own ``Zend\Mime\Mime`` Object to generate a boundary. If you need
to define the boundary or want to change the behaviour of the ``Zend\Mime\Mime`` object used by ``Zend\Mime\Message``,
you can instantiate the ``Zend\Mime\Mime`` class yourself and then register it to ``Zend\Mime\Message``. Usually you
will not need to do this. ``setMime(Zend\Mime\Mime $mime)`` sets a special instance of ``Zend\Mime\Mime`` to be used
by this ``Zend\Mime\Message``.

``getMime()`` returns the instance of ``Zend\Mime\Mime`` that will be used to render the message when
``generateMessage()`` is called.

``generateMessage()`` renders the ``Zend\Mime\Message`` content to a string.

.. _zend.mime.message.parse:

Parsing a string to create a Zend\\Mime\\Message object
-------------------------------------------------------

A given *MIME* compliant message in string form can be used to reconstruct a ``Zend\Mime\Message`` object from it.
``Zend\Mime\Message`` has a static factory Method to parse this String and return a ``Zend\Mime\Message`` object.

``Zend\Mime\Message::createFromMessage($str, $boundary)`` decodes the given string and returns a
``Zend\Mime\Message`` object that can then be examined using ``getParts()``

Available methods
-----------------

A ``Zend\Mime\Message`` object has the following methods:

- ``getParts``: Get the all ``Zend\Mime\Part``\s in the message.

- ``setParts($parts)``: Set the array of ``Zend\Mime\Part``\s for the message.

- ``addPart(Zend\Mime\Part $part)``: Append a new ``Zend\Mime\Part`` to the message.

- ``isMultiPart``: Check if the message needs to be sent as a multipart *MIME* message.

- ``setMime(Zend\Mime\Mime $mime)``: Set a custom ``Zend\Mime\Mime`` object for the message.

- ``getMime``: Get the ``Zend\Mime\Mime`` object for the message.

- ``generateMessage($EOL=Zend\Mime\Mime::LINEEND)``: Generate a *MIME*-compliant message from the current
  configuration.

- ``getPartHeadersArray($partnum)``: Get the headers of a given part as an array.

- ``getPartHeaders($partnum,$EOL=Zend\Mime\Mime::LINEEND)``: Get the headers of a given part as a string.

- ``getPartContent($partnum,$EOL=Zend\Mime\Mime::LINEEND)``: Get the encoded content of a given part as a string.
