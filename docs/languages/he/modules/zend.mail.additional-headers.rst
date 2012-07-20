.. _zend.mail.additional-headers:

כותרים נוספים
=============

כדי להגדיר כותרים נוספים לאימייל ניתן לבצע זאת על ידי שימוש
במתודת *addHeader()*. מתודה זו דורשת שני פרמטרים אשר מגדירים את שם
הכותרת והערך שלו. פרמטר שלישי ואופציונלי מגדיר אם אותו כותר
שנשלח יכול להכיל יותר מערך אחד מוגדר. כפי שמוצג בדוגמא:

.. _zend.mail.additional-headers.example-1:

.. rubric:: הוספת כותרים להודעות אימייל

.. code-block::
   :linenos:

   $mail = new Zend_Mail();
   $mail->addHeader('X-MailGenerator', 'MyCoolApplication');
   $mail->addHeader('X-greetingsTo', 'Mom', true); // multiple values
   $mail->addHeader('X-greetingsTo', 'Dad', true);



