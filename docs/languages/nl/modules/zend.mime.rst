.. EN-Revision: none
.. _zend.mime.introduction:

Inleiding
=========

*Zend_Mime* is een hulpklasse voor het afhandelen van multipart MIME berichten. Ze wordt gebruikt door
:ref:`Zend_Mail <zend.mail>`, en kan gebruikt worden door toepassingen die MIME ondersteuning nodig hebben.

.. _zend.mime.static:

Statische Methodes en Constanten
--------------------------------

*Zend_Mime* verstrekt een set eenvoudige methodes om met MIME te werken:

   - *isPrintable()*: Geeft TRUE terug indien de gegeven string geen onafdrukbare tekens bevat, anders FALSE.

   - *encodeBase64()*: Encodeert een string met base64.

   - *encodeQuotedPrintable()*: Encodeert een string met het quoted-printable mechanisme.



*Zend_Mime* definieert een set van constanten die veel worden gebruikt in MIME Messages:

   - *Zend\Mime\Mime::TYPE_OCTETSTREAM*: 'application/octet-stream'

   - *Zend\Mime\Mime::TYPE_TEXT*: 'text/plain'

   - *Zend\Mime\Mime::TYPE_HTML*: 'text/html'

   - *Zend\Mime\Mime::ENCODING_7BIT*: '7bit'

   - *Zend\Mime\Mime::ENCODING_8BIT*: '8bit'

   - *Zend\Mime\Mime::ENCODING_QUOTEDPRINTABLE*: 'quoted-printable'

   - *Zend\Mime\Mime::ENCODING_BASE64*: 'base64'

   - *Zend\Mime\Mime::DISPOSITION_ATTACHMENT*: 'attachment'

   - *Zend\Mime\Mime::DISPOSITION_INLINE*: 'inline'



.. _zend.mime.instatiation:

Zend_Mime Instantiëren
----------------------

Wanneer je een *Zend_Mime* object instantieert word er een MIME boundary opgeslaan die word gebruikt voor alle
volgende niet-statische oproepen naar het object. Als de constructor word opgeroepen met een string parameter zal
de gegeven string worden gebruikt als MIME boundary. Indien niet zal er een willekeurige MIME boundary worden
gegenereerd tijdens het opbouwen van het object.

Een *Zend_Mime* object heeft de volgende methodes:

   - *boundary()*: Geeft de MIME boundary string terug.

   - *boundaryLine()*: Geeft de gehele MIME boundary regel terug.

   - *mimeEnd()*: Geeft de gehele MIME einde boundary regel terug.




