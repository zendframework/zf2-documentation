.. _zend.mime.message:

Zend_Mime_Message
=================

.. _zend.mime.message.introduction:

Einführung
----------

``Zend_Mime_Message`` repräsentiert eine *MIME* konforme Nachricht, welche einen oder mehrere Abschnitte
(Repräsentiert durch :ref:`Zend_Mime_Part <zend.mime.part>` Objekte) beinhalten kann. Mit ``Zend_Mime_Message``
können *MIME* konforme Nachrichten, durch die Klasse, erstellt werden. Verschlüsselungs- und
BoundaryGrenzbehandlung werden transparent durch die Klasse behandelt. MimeMessage Objekte können auch durch
übergebene Strings rekonstruiert werden (Experimentell). Verwendet durch :ref:`Zend_Mail <zend.mail>`.

.. _zend.mime.message.instantiation:

Instanziierung
--------------

Es gibt keinen expliziten Konstruktor für ``Zend_Mime_Message``.

.. _zend.mime.message.addparts:

MIME Abschnitte hinzufügen
--------------------------

:ref:`Zend_Mime_Part <zend.mime.part>` Objekte können zu einem bestehenden ``Zend_Mime_Message`` Objekt
hinzugefügt werden durch aufruf von ``addPart($part)``

Ein Array mit allen ``Zend_Mime_Part`` Objekten der ``Zend_Mime_Message`` wird von der Methode ``getParts()``
zurück gegeben. Das ``Zend_Mime_Part`` Objekt kann dann geändert werden, da es im Array als Referenz gespeichert
wird. Wenn Abschnitte zum Array hinzugefügt werden oder die Sequenz geändert wird, muß das Array dem
``Zend_Mime_Message`` Objekt zurückgegeben werden, durch Aufruf von ``setParts($partsArray)``

Die Funktion ``isMultiPart()`` gibt ``TRUE`` zurück, wenn mehr als ein Abschnitt im ``Zend_Mime_Message`` Objekt
registriert wurde, und das Objekt deshalb bei der Erstellung des aktuellen Outputs eine Multipart-Mime-Message
erstellen würde.

.. _zend.mime.message.bondary:

Grenzbehandlung
---------------

``Zend_Mime_Message`` erzeugt und verwendet normalerweise sein eigenes ``Zend_Mime`` Objekt zur Erstellung einer
Grenze. Wenn eine eigene Grenze erstellt wird, oder dass das Verhalten des ``Zend_Mime`` Objekts geändert werden
muß, welches von ``Zend_Mime_Message`` verwendet wird, kann ein eigenes Zend Mime Objekt instanziiert und bei
``Zend_Mime_Message`` registriert werden. Normalerweise muß das nicht gemacht werden. ``setMime(Zend_Mime $mime)``
setzt eine spezielle Instanz von ``Zend_Mime`` welche durch diese ``Zend_Mime_Message`` verwendet wird.

``getMime()`` gibt eine Instanz von ``Zend_Mime`` zurück, welche zur Wiedergabe der Nachricht verwendet wird, wenn
``generateMessage()`` aufgerufen wird.

``generateMessage()`` gibt den ``Zend_Mime_Message`` Inhalt in einem String wieder.

.. _zend.mime.message.parse:

Parst einen String um ein Zend_Mime_Message Objekt zu erstellen (Experimentell)
-------------------------------------------------------------------------------

Eine übergebene *MIME* konforme Nachricht in einem String kann dazu verwendet werden, um daraus ein
``Zend_Mime_Message`` Objekt wieder herzustellen. ``Zend_Mime_Message`` hat eine statische Factory Methode um den
String zu parsen und gibt ein ``Zend_Mime_Message`` Objekt zurück.

``Zend_Mime_Message::createFromMessage($str, $boundary)`` entschlüsselt einen übergebenen String und gibt ein
``Zend_Mime_Message`` Objekt zurück welches anschließend durch ``getParts()`` überprüft werden kann.


