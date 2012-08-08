.. EN-Revision: none
.. _zend.mail.attachments:

צירופים
=======

ניתן לצרף קבצים לאימייל בעזרת מתודת ה *createAttachment()*. פעולת ברירת
המחדל של *Zend_Mail* היא לחשוב שהצירוף הוא קובץ בינארי
(application/octet-stream), ולכן ידרוש העברה בעזרת קידוד base64, ומטופל כצירוף.
השערות אלו ניתנות לדריסה על ידי העברת פרמטרים נוספים למתודה
*createAttachment()*:

.. _zend.mail.attachments.example-1:

.. rubric:: שליחת אימיילים עם צירוף קבצים

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   // build message...
   $mail->createAttachment($someBinaryString);
   $mail->createAttachment($myImage,
                           'image/gif',
                           Zend_Mime::DISPOSITION_INLINE,
                           Zend_Mime::ENCODING_8BIT);


אם דרושה שליטה נוספת על סוג ה MIME שנוצר ונשלח לאותו צירוף, ניתן
להשתמש בערך שמוחזר ממתודת ה *createAttachment()* כדי לערוך את הערכים שלה.
מתודת ה *createAttachment()* מחזירה אובייקט מסוג *Zend_Mime_Part*:

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();

   $at = $mail->createAttachment($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend_Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend_Mime::ENCODING_8BIT;
   $at->filename    = 'test.gif';

   $mail->send();


לחלופין ניתן ליצור אובייקט של *Zend_Mime_Part* ולהוסיף אותו ל
*addAttachment()*:

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



