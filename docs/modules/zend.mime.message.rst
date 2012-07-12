
Zend_Mime_Message
=================

.. _zend.mime.message.introduction:

Introduction
------------

``Zend_Mime_Message`` represents a *MIME* compliant message that can contain one or more separate Parts (Represented as :ref:`Zend_Mime_Part <zend.mime.part>` objects). With ``Zend_Mime_Message`` , *MIME* compliant multipart messages can be generated from ``Zend_Mime_Part`` objects. Encoding and Boundary handling are handled transparently by the class. ``Zend_Mime_Message`` objects can also be reconstructed from given strings (experimental). Used by :ref:`Zend_Mail <zend.mail>` .

.. _zend.mime.message.instantiation:

Instantiation
-------------

There is no explicit constructor for ``Zend_Mime_Message`` .

.. _zend.mime.message.addparts:

Adding MIME Parts
-----------------

:ref:`Zend_Mime_Part <zend.mime.part>` Objects can be added to a given ``Zend_Mime_Message`` object by calling ``->addPart($part)`` 

An array with all :ref:`Zend_Mime_Part <zend.mime.part>` objects in the ``Zend_Mime_Message`` is returned from the method ``getParts()`` . The ``Zend_Mime_Part`` objects can then be changed since they are stored in the array as references. If parts are added to the array or the sequence is changed, the array needs to be given back to the :ref:`Zend_Mime_Part <zend.mime.part>` object by calling ``setParts($partsArray)`` .

The function ``isMultiPart()`` will return ``TRUE`` if more than one part is registered with the ``Zend_Mime_Message`` object and thus the object would generate a Multipart-Mime-Message when generating the actual output.

.. _zend.mime.message.bondary:

Boundary handling
-----------------

``Zend_Mime_Message`` usually creates and uses its own ``Zend_Mime`` Object to generate a boundary. If you need to define the boundary or want to change the behaviour of the ``Zend_Mime`` object used by ``Zend_Mime_Message`` , you can instantiate the ``Zend_Mime`` object yourself and then register it to ``Zend_Mime_Message`` . Usually you will not need to do this. ``setMime(Zend_Mime $mime)`` sets a special instance of ``Zend_Mime`` to be used by this ``Zend_Mime_Message`` 

``getMime()`` returns the instance of ``Zend_Mime`` that will be used to render the message when ``generateMessage()`` is called.

``generateMessage()`` renders the ``Zend_Mime_Message`` content to a string.

.. _zend.mime.message.parse:

parsing a string to create a Zend_Mime_Message object (experimental)
--------------------------------------------------------------------

A given *MIME* compliant message in string form can be used to reconstruct a ``Zend_Mime_Message`` Object from it. ``Zend_Mime_Message`` has a static factory Method to parse this String and return a ``Zend_Mime_Message`` Object.

``Zend_Mime_Message::createFromMessage($str, $boundary)`` decodes the given string and returns a ``Zend_Mime_Message`` Object that can then be examined using ``getParts()`` 


