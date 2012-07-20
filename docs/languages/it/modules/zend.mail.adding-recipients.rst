.. _zend.mail.adding-recipients:

Inserimento dei destinatari
===========================

E' possibile aggiungere i destinatari in tre modi:

   - *addTo()*: aggiunge un destinatario all'e-mail con intestazione "a"

   - *addCc()*: aggiunge un destinatario all'e-mail con intestazione "Cc" (in copia)

   - *addBcc()*: aggiunge un destinatario all'e-mail con intestazione "Ccn" (in copia nascosta)



.. note::

   **Parametri aggiuntivi**

   I metodi *addTo()* e *addCc()* accettano un secondo parametro opzionale utile per indicare il nome del
   destinatario in formato leggibile.


