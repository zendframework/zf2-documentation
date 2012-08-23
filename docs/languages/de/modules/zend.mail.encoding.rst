.. EN-Revision: none
.. _zend.mail.encoding:

Kodierung
=========

Text und *HTML* Nachrichten werden standardmäßig mit dem "quotedprintable" Mechanismus kodiert. Nachrichten
Header werden auch mit dem quotedprintable Mechanismus kodiert wenn in ``setHeaderEncoding()`` nicht base64
spezifiziert wurde. Wenn man eine Sprache verwendet die nicht auf römischen Buchstaben basiert, ist base64 besser
geeignet. Alle anderen Anhänge werden über "base64" kodiert, wenn an den *MIME* Teil keine andere Kodierung über
den ``addAttachment()`` Aufruf übergeben oder später zugewiesen worden ist. 7Bit und 8Bit Kodierung können
derzeit nur auf binärische Inhalte angewandt werden.

Die Kodierung des Headers, speziell die Kodierung des Subjects ist ein trickreiches Thema. ``Zend_Mime``
implementiert aktuell seinen eigenen Algorithmus um quotedprintable Header nach RFC-2045 zu kodieren. Der
Hintergrund ist das Problem von ``iconv_mime_encode()`` und ``mb_encode_mimeheader()`` in Bezug zu bestimmten
Zeichensätzen. Dieser Algorithmus unterbricht den Header nur bei Leerzeichen, das zu Headern führen könnte
welche die erwartete Länge von 76 Zeichen weit überschreiten. Für diesen Fall wird vorgeschlagen zur BASE64
Header Kodierung zu wechseln, wie im folgenden Beispiel beschrieben:

.. code-block:: php
   :linenos:

   // Standardmäßig Zend_Mime::ENCODING_QUOTEDPRINTABLE
   $mail = new Zend_Mail('KOI8-R');

   // Auf Base64 Kodierung zurücksetzen da russisch ausgedrückt in KOI8-R zu
   // Römisch basierten Buchstaben sehr unterschiedlich ist
   $mail->setHeaderEncoding(Zend_Mime::ENCODING_BASE64);

``Zend_Mail_Transport_Smtp`` kodiert die Zeilen beginnend mit einem oder zwei Punkten, so dass die Mail das SMTP
Protokoll nicht missachtet.


