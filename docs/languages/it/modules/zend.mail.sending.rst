.. _zend.mail.sending:

Invio via SMTP
==============

Per inviare e-mail via SMTP è necessario creare e registrare *Zend_Mail_Transport_Smtp* con *Zend_Mail* prima
della chiamata del metodo *send()*. In seguito, ogni successiva chiamata a *Zend_Mail::send()* utilizzerà SMTP
come transport.

.. _zend.mail.sending.example-1:

.. rubric:: Invio di e-mail via SMTP

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Mail/Transport/Smtp.php';
   $tr = new Zend_Mail_Transport_Smtp('mail.example.com');
   Zend_Mail::setDefaultTransport($tr);

Il metodo *setDefaultTransport()* ed il costruttore di *Zend_Mail_Transport_Smtp* non sono costosi in termini di
performance. Queste due linee possono essere processate in fase di inizializzazione dello script (es. config.inc o
simile) per configurare il comportamento predefinito di *Zend_Mail* per il resto dell'esecuzione. Questa
impostazione consente di mantenere le informazioni di configurazione fuori dalla logica dell'applicazione - l'invio
avviene via SMTP o `mail()`_, quale mail server utilizzare, ecc.



.. _`mail()`: http://php.net/mail
