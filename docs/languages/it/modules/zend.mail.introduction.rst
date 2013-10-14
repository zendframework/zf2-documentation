.. EN-Revision: none
.. _zend.mail.introduction:

Introduzione
============

.. _zend.mail.introduction.getting-started:

Come iniziare
-------------

*Zend_Mail* fornisce delle funzionalità generiche per scrivere ed inviare messaggi e-mail sia in formato testuale
sia compatibili con lo standard MIME multipart. *Zend_Mail* può inviare e-mail utilizzando il transpoter
predefinito *Zend\Mail_Transport\Sendmail* oppure via *Zend\Mail_Transport\Smtp*.

.. _zend.mail.introduction.example-1:

.. rubric:: Semplice e-mail con Zend_Mail

Una semplice e-mail è composta da alcuni destinatario, un oggetto, un contenuto ed un mittente. Ecco come inviare
l'e-mail via *Zend\Mail_Transport\Sendmail*:

.. code-block:: php
   :linenos:

   <?php
   $mail = new Zend\Mail\Mail();
   $mail->setBodyText('Questo è il testo.');
   $mail->setFrom('qualcuno@example.com', 'Un mittente');
   $mail->addTo('qualcunaltro@example.com', 'Un destinatario');
   $mail->setSubject('Oggetto testuale');
   $mail->send();

.. note::

   **Specifiche minime**

   Per poter inviare un'e-mail con *Zend_Mail* è necessario specificare almeno un destinatario, un mittente (con
   *setFrom()*) ed un messaggio (testo e/o HTML).

Per la maggior parte degli attributi sono disponibili specifici metodi "get" per leggere le informazioni salvate
nell'oggetto e-mail. Per ulteriori dettagli fare riferimento alle API della classe. Un metodo speciale è
*getRecipients()*. Restituisce un array contenente tutti gli indirizzi e-mail dei destinatari aggiunti prima della
chiamata del metodo.

Per ragioni di sicurezza, *Zend_Mail* filtra tutte le intestazioni per prevenire un attacco di tipo header
injection utilizzando il carattere di nuova riga (*\n*).

La maggior parte dei metodi di un oggetto Zend_Mail consente l'utilizzo di un'interfaccia fluida. Un'interfaccia
fluida significa che ogni metodo restituisce un riferimento al metodo dal quale è stato chiamato consentendo di
chiamare immediatamente un nuovo metodo in successione.

.. code-block:: php
   :linenos:

   <?php
   $mail = new Zend\Mail\Mail();
   $mail->setBodyText('Questo è il testo.')
       ->setFrom('qualcuno@example.com', 'Un mittente')
       ->addTo('qualcunaltro@example.com', 'Un destinaratio')
       ->setSubject('Oggetto testuale')
       ->send();

.. _zend.mail.introduction.sendmail:

Configurazione del transport sendmail predefinito
-------------------------------------------------

*Zend\Mail_Transport\Sendmail* è il transport predefinito per un'istanza di *Zend_Mail*. Consiste essenzialmente
in un wrapper alla funzione PHP `mail()`_. Se si desidera passare parametri aggiuntivi alla funzione `mail()`_ è
sufficiente creare una nuova istanza del transport e fornire i parametri al costruttore. La nuova istanza può sia
agire come transport predefinito per *Zend_Mail* sia essere passata al metodo *send()* di *Zend_Mail*.

.. _zend.mail.introduction.sendmail.example-1:

.. rubric:: Passaggio di parametri aggiuntivi al transport Zend\Mail_Transport\Sendmail

Questo esempio mostra come cambiare l'intestazione Return-Path della funzione `mail()`_.

.. code-block:: php
   :linenos:

   <?php

   $tr = new Zend\Mail_Transport\Sendmail('-fritorna_a_me@example.com');
   Zend\Mail\Mail::setDefaultTransport($tr);

   $mail = new Zend\Mail\Mail();
   $mail->setBodyText('Questo è il testo.');
   $mail->setFrom('qualcuno@example.com', 'Un mittente');
   $mail->addTo('qualcunaltro@example.com', 'Un destinatario');
   $mail->setSubject('Oggetto testuale');
   $mail->send();

.. note::

   **Restrizioni in Safe mode**

   In caso PHP sia configurato con safe mode attivo, i parametri opzionali aggiuntivi possono impedire il corretto
   funzionamento di `mail()`_ e l'invio dell'e-mail.



.. _`mail()`: http://php.net/mail
