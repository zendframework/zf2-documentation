.. _zend.mail.attachments:

Allegati
========

Si possono allegare file ad un'e-mail utilizzando il metodo *createAttachment()*. Per impostazione predefinita,
*Zend_Mail* assume che l'allegato corrisponda ad un oggetto binario (application/octet-stream), adotta una codifica
base64 per il trasferimento e gestisce l'oggetto come allegato. Queste convenzioni possono essere sovrascritte
passando uno o più parametri al metodo *createAttachment()*:

.. _zend.mail.attachments.example-1:

.. rubric:: Messaggi e-mail con allegati

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   // crea il messaggio...
   $mail->createAttachment($someBinaryString);
   $mail->createAttachment($myImage, 'image/gif', Zend_Mime::DISPOSITION_INLINE, Zend_Mime::ENCODING_8BIT);

Se si desidera maggiore controllo sul formato MIME generato per un singolo allegato è possibile utilizzare il
valore di ritorno di *createAttachment()* per modificarne gli attributi. Il metodo *createAttachment()* restituisce
un oggetto *Zend_Mime_Part*:

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();

   $at = $mail->createAttachment($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend_Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend_Mime::ENCODING_8BIT;
   $at->filename    = 'test.gif';

   $mail->send();

Un'alternativa consiste nel creare un'istanza di Zend_Mime_Part ed aggiungere l'allegato con *addAttachment()*:

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();

   $at = new Zend_Mime_Part($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend_Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend_Mime::ENCODING_8BIT;
   $at->filename    = 'test.gif';

   $mail->addAttachment($at);

   $mail->send();


