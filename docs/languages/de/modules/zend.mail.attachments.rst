.. EN-Revision: none
.. _zend.mail.attachments:

Anhänge
=======

Dateien können durch die ``createAttachment()`` Methode an eine E-Mail angehängt werden. Standardmäßig nimmt
``Zend_Mail`` an, dass der Anhang ein binäres Objekt (``application/octet-stream``) ist, über eine base64
Kodierung übertragen werden soll und als Anhang verarbeitet wird. Diese Annahmen können durch die Übergabe von
weiteren Parametern an ``createAttachment()`` überschrieben werden:

.. _zend.mail.attachments.example-1:

.. rubric:: E-Mail Nachrichten mit Anhängen

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Mail();
   // erstelle Nachricht...
   $mail->createAttachment($someBinaryString);
   $mail->createAttachment($myImage,
                           'image/gif',
                           Zend\Mime\Mime::DISPOSITION_INLINE,
                           Zend\Mime\Mime::ENCODING_BASE64);

Wenn du weitere Kontrolle über den für diesen Anhang generierten *MIME* Teil benötigst, kannst du
zurückgegebenen Wert von ``createAttachment()`` verwenden, um die Attributes zu verändern. Die
``createAttachment()`` Methode gibt ein ``Zend\Mime\Part`` Objekt zurück:

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Mail();

   $at = $mail->createAttachment($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend\Mime\Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend\Mime\Mime::ENCODING_BASE64;
   $at->filename    = 'test.gif';

   $mail->send();

Eine Alternative ist die Erstellung einer Instanz von ``Zend\Mime\Part`` und das Hinzufügen von Ihr mit
``addAttachment()``:

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Mail();

   $at = new Zend\Mime\Part($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend\Mime\Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend\Mime\Mime::ENCODING_BASE64;
   $at->filename    = 'test.gif';

   $mail->addAttachment($at);

   $mail->send();


