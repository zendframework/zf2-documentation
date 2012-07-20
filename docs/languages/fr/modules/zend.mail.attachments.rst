.. _zend.mail.attachments:

Fichiers joints
===============

Des fichiers peuvent-être attachés à un émail en utilisant la méthode ``createAttachment()``. Le comportement
par défaut de ``Zend_Mail`` est de définir que le fichier joint est un objet binaire (application/octet-stream),
qui devra être transféré avec un encodage de type base64, et est définit comme une pièce jointe. Ce
comportement peut être redéfinit en passant plus de paramètres à ``createAttachment()``:

.. _zend.mail.attachments.example-1:

.. rubric:: Émail avec fichiers joints

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   // construction du message
   $mail->createAttachment($uneChaineBinaire);
   $mail->createAttachment($monImage,
                           'image/gif',
                           Zend_Mime::DISPOSITION_INLINE,
                           Zend_Mime::ENCODING_BASE64);

Si vous voulez contrôler la partie MIME générée pour un fichier joint, vous pouvez utiliser la valeur
retournée de ``createAttachment()`` pour modifier ses attributs. La méthodes ``createAttachment()`` retourne un
objet de type ``Zend_Mime_Part``:

   .. code-block:: php
      :linenos:

      $mail = new Zend_Mail();

      $at = $mail->createAttachment($monImage);
      $at->type        = 'image/gif';
      $at->disposition = Zend_Mime::DISPOSITION_INLINE;
      $at->encoding    = Zend_Mime::ENCODING_BASE64;
      $at->filename    = 'test.gif';

      $mail->send();



Une façon alternative est de créer une instance de ``Zend_Mime_Part`` et de l'ajouter avec la méthode
``addAttachment()``:

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();

   $at = new Zend_Mime_Part($monImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend_Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend_Mime::ENCODING_BASE64;
   $at->filename    = 'test.gif';

   $mail->addAttachment($at);

   $mail->send();


