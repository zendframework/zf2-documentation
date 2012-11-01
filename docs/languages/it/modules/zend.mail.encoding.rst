.. EN-Revision: none
.. _zend.mail.encoding:

Codifica
========

Per impostazione predefinita, i contenuti dei messaggi Testo e HTML sono codificati con il meccanismo
"quoted-printable". Tutti gli altri allegati sono codificati via base64 se non è stata specificata un'importazione
differente con il metodo *addAttachment()* o con un'assegnazione successiva alla parte MIME dell'oggetto. Le
codifiche 7Bit e 8Bit attualmente sono concesse solo per i dati con contenuto binario.

*Zend\Mail_Transport\Smtp* codifica le linee cominciando con uno o due punti così che l'e-mail non vìoli il
protocollo SMTP.


