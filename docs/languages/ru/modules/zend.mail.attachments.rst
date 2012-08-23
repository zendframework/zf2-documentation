.. EN-Revision: none
.. _zend.mail.attachments:

Вложения
========

Файлы могут быть прикреплены к сообщению электронной почты с
использованием метода ``addAttachment()``. По умолчанию ``Zend_Mail``
предполагает, что прикрепляемый файл является бинарным
(application/octet-stream), должен передаваться в кодировке base64 и
обрабатываться как вложение. Эти предположения могут быть
переопределены передачей дополнительных параметров методу
*addAttachment()*.

.. _zend.mail.attachments.example-1:

.. rubric:: Почтовые сообщения со вложениями

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   // Формирование сообщения...
   $mail->createAttachment($someBinaryString);
   $mail->createAttachment($myImage,
                           'image/gif',
                           Zend_Mime::DISPOSITION_INLINE,
                           Zend_Mime::ENCODING_8BIT);

Если требуется больший контроль над частями *MIME*,
генерируемыми для данного вложения, то можно использовать
возвращаемое методом ``createAttachment()`` значение для изменения
атрибутов. Метод ``createAttachment()`` возвращает объект *Zend_Mime_Part*:

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();

   $at = $mail->createAttachment($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend_Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend_Mime::ENCODING_8BIT;
   $at->filename    = 'test.gif';

   $mail->send();

Альтернативным способом является создание экземпляра
``Zend_Mime_Part`` и его добавление через ``addAttachment()``:

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();

   $at = new Zend_Mime_Part($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend_Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend_Mime::ENCODING_8BIT;
   $at->filename    = 'test.gif';

   $mail->addAttachment($at);

   $mail->send();


