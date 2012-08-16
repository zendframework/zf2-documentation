.. EN-Revision: none
.. _zend.mail.attachments:

Załączniki
==========

Pliki mogą być dołączone do e-maila za pomocą metody *createAttachment()*. Domyślnie *Zend_Mail* założy,
że załącznik jest obiektem binarnym (application/octet-stream), który będzie zakodowany w base64. Te
założenie może być nadpisane przez przekazanie opcjonalnych parametrów do metody *createAttachment()*:

.. _zend.mail.attachments.example-1:

.. rubric:: Wiadomości e-mail z załącznikami

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   // tworzymy wiadomość
   $mail->createAttachment($someBinaryString);
   $mail->createAttachment($myImage,
                           'image/gif',
                           Zend_Mime::DISPOSITION_INLINE,
                           Zend_Mime::ENCODING_8BIT);


Jeśli chcesz mieć większą kontrolę nad częścią MIME wygenerowaną dla tego załącznika możesz użyć
wartości zwróconej przez *createAttachment()* aby zmodyfikować jej atrybuty. Metoda *createAttachment()* zwraca
obiekt *Zend_Mime_Part*:

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();

   $at = $mail->createAttachment($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend_Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend_Mime::ENCODING_8BIT;
   $at->filename    = 'test.gif';

   $mail->send();


Alternatywą jest utworzenie instancji klasy *Zend_Mime_Part* i dodanie jej za pomocą metody *createAttachment()*:

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();

   $at = new Zend_Mime_Part($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend_Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend_Mime::ENCODING_8BIT;
   $at->filename    = 'test.gif';

   $mail->createAttachment($at);

   $mail->send();



