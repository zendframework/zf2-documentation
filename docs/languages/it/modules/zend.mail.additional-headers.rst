.. _zend.mail.additional-headers:

Intestazioni aggiuntive
=======================

E' possibile impostare intestazioni e-mail arbitrarie utilizzando il metodo *addHeader()*. Richiede due parametri:
il nome dell'intestazione ed il suo valore. Un terzo parametro opzionale determina se l'intestazione debba avere
uno o più valori:

.. _zend.mail.additional-headers.example-1:

.. rubric:: Aggiunta di intestazioni al messaggio e-mail

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   $mail->addHeader('X-MailGenerator', 'MyCoolApplication');
   $mail->addHeader('X-salutiA', 'Mom', true); // valori multipli
   $mail->addHeader('X-salutiA', 'Dad', true);


