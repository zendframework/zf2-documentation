.. EN-Revision: none
.. _zend.mime.mime:

Zend_Mime
=========

.. _zend.mime.mime.introduction:

Einführung
----------

``Zend_Mime`` ist eine Hilfsklasse für die Verarbeitung von mehrteiligen *MIME* Nachrichten. Es wird von
:ref:`Zend_Mail <zend.mail>` und :ref:`Zend\Mime\Message <zend.mime.message>` verwendet und kann von anderen
Anwendungen verwendet werden, die *MIME* Unterstützung benötigen.

.. _zend.mime.mime.static:

Statische Methoden und Konstanten
---------------------------------

``Zend_Mime`` stellt einige einfache statische Hilfsmethoden für die *MIME* Verarbeitung bereit:



   - ``Zend\Mime\Mime::isPrintable()``: Gibt ``TRUE`` zurück, wenn der String keine nicht druckbaren Zeichen enthält,
     ansonsten wird ``FALSE`` zurückgegeben.

   - ``Zend\Mime\Mime::encode()``: Codiert einen String mit der spezifizierten Kodierung.

   - ``Zend\Mime\Mime::encodeBase64()``: Codiert einen String in die base64 Codierung.

   - ``Zend\Mime\Mime::encodeQuotedPrintable()``: Codiert einen String mit dem "quoted-printable" Mechanismus.

   - ``Zend\Mime\Mime::encodeBase64Header()``: Codiert einen String zu einer base64 Kodierung für Mail Header.

   - ``Zend\Mime\Mime::encodeQuotedPrintableHeader()``: Codiert einen String mit dem Quoted-Printable Mechanismus für
     Mail Header.



``Zend_Mime`` definiert einen Satz Konstanten, die üblicherweise von *MIME* Nachrichten verwendet werden:



   - ``Zend\Mime\Mime::TYPE_OCTETSTREAM``: 'application/octet-stream'

   - ``Zend\Mime\Mime::TYPE_TEXT``: 'text/plain'

   - ``Zend\Mime\Mime::TYPE_HTML``: 'text/html'

   - ``Zend\Mime\Mime::ENCODING_7BIT``: '7bit'

   - ``Zend\Mime\Mime::ENCODING_8BIT``: '8bit';

   - ``Zend\Mime\Mime::ENCODING_QUOTEDPRINTABLE``: 'quoted-printable'

   - ``Zend\Mime\Mime::ENCODING_BASE64``: 'base64'

   - ``Zend\Mime\Mime::DISPOSITION_ATTACHMENT``: 'attachment'

   - ``Zend\Mime\Mime::DISPOSITION_INLINE``: 'inline'

   - ``Zend\Mime\Mime::MULTIPART_ALTERNATIVE``: 'multipart/alternative'

   - ``Zend\Mime\Mime::MULTIPART_MIXED``: 'multipart/mixed'

   - ``Zend\Mime\Mime::MULTIPART_RELATED``: 'multipart/related'



.. _zend.mime.mime.instantiation:

Zend_Mime instanziieren
-----------------------

Wenn ein ``Zend_Mime`` instanziiert wird, wird eine *MIME* Abgrenzung gespeichert, die von allen nachfolgenden
nicht statischen Methodenaufrufen für dieses Objekt verwendet wird. Wenn der Konstruktur mit einem String
Parameter aufgerufen wird, wird dieser Wert als *MIME* Abgrenzung verwendet. Anderfalls wird eine zufällige *MIME*
Abgrenzung während der Konstruktionsphase generiert.

Ein ``Zend_Mime`` Objekt hat die folgenden Methoden:



   - ``boundary()``: Gibt den String mit der *MIME* Abgrenzung zurück.

   - ``boundaryLine()``: Gibt die komplette Zeile der *MIME* Abgrenzung zurück.

   - ``mimeEnd()``: Gibt die komplette Endzeile der *MIME* Abgrenzung zurück.




