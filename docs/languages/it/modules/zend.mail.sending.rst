.. EN-Revision: none
.. _zend.mail.sending:

Invio via SMTP
==============

Per inviare e-mail via SMTP è necessario creare e registrare *Zend\Mail\Transport\Smtp* con *Zend_Mail* prima
della chiamata del metodo *send()*. In seguito, ogni successiva chiamata a *Zend\Mail\Mail::send()* utilizzerà SMTP
come transport.

.. _zend.mail.sending.example-1:

.. rubric:: Invio di e-mail via SMTP

.. code-block:: php
   :linenos:

   <?php
   $tr = new Zend\Mail\Transport\Smtp('mail.example.com');
   Zend\Mail\Mail::setDefaultTransport($tr);

Il metodo *setDefaultTransport()* ed il costruttore di *Zend\Mail\Transport\Smtp* non sono costosi in termini di
performance. Queste due linee possono essere processate in fase di inizializzazione dello script (es. config.inc o
simile) per configurare il comportamento predefinito di *Zend_Mail* per il resto dell'esecuzione. Questa
impostazione consente di mantenere le informazioni di configurazione fuori dalla logica dell'applicazione - l'invio
avviene via SMTP o `mail()`_, quale mail server utilizzare, ecc.



.. _`mail()`: http://php.net/mail
