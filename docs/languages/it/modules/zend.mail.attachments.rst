.. EN-Revision: none
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
   $mail = new Zend\Mail\Mail();
   // crea il messaggio...
   $mail->createAttachment($someBinaryString);
   $mail->createAttachment($myImage, 'image/gif', Zend\Mime\Mime::DISPOSITION_INLINE, Zend\Mime\Mime::ENCODING_8BIT);

Se si desidera maggiore controllo sul formato MIME generato per un singolo allegato è possibile utilizzare il
valore di ritorno di *createAttachment()* per modificarne gli attributi. Il metodo *createAttachment()* restituisce
un oggetto *Zend\Mime\Part*:

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend\Mail\Mail();

   $at = $mail->createAttachment($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend\Mime\Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend\Mime\Mime::ENCODING_8BIT;
   $at->filename    = 'test.gif';

   $mail->send();

Un'alternativa consiste nel creare un'istanza di Zend\Mime\Part ed aggiungere l'allegato con *addAttachment()*:

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend\Mail\Mail();

   $at = new Zend\Mime\Part($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend\Mime\Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend\Mime\Mime::ENCODING_8BIT;
   $at->filename    = 'test.gif';

   $mail->addAttachment($at);

   $mail->send();


