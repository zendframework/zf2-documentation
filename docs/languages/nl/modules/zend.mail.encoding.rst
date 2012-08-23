.. EN-Revision: none
.. _zend.mail.encoding:

Encoding
========

Tekst en HTML berichtinhoud word standaard met het quotedprintable mechanisme geëncodeerd. Alle andere bijlagen
worden via base64 geëncodeerd indien geen andere encoding wordt opgegeven in de *addAttachment()* oproep of later
aan het MIME deel object wordt toegewezen. 7Bit and 8Bit encoding geven op dit moment alleen de binaire inhoud
door.

*Zend_Mail_Transport_Smtp* encodeert regels die met één of twee punten starten zodat het bericht het SMTP
protocol volgt.


