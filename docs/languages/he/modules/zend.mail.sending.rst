.. EN-Revision: none
.. _zend.mail.sending:

שליחת אימייל דרך SMTP
=====================

כדי לשלוח אימייל דרך SMTP, *Zend_Mail_Transport_Smtp* צריך להווצר ולהרשם ביחד
עם *Zend_Mail* לפני קריאה למתודת ה *send()*. בכל שאר קריאות ל *Zend_Mail::send()*
בסקריפט הנוכחי, השליחה תתבצעה בעזרת פרוטוקול ה SMTP:

.. _zend.mail.sending.example-1:

.. rubric:: שליחת אימייל דרך SMTP

.. code-block:: php
   :linenos:

   $tr = new Zend_Mail_Transport_Smtp('mail.example.com');
   Zend_Mail::setDefaultTransport($tr);


מתודת ה *setDefaultTransport()* ומתודת ה \__construct של *Zend_Mail_Transport_Smtp* הם לא
יקרים מבחינת משאבים. שני השורות הללו יכולות להווצר בזמן תהליך
ההתקנה של הסקריפט (לדוגמא בקובץ config.inc או דומים אחרים) כדי
להגדיר את ההתנהגות של המחלקה *Zend_Mail* לכל מהלך הסקריפט. זה דואג
לשמור את הגדרות המערכת מחוץ לכתיבה הלוגית של המערכת, בין אם
האימיילים שנשלחים ישלחו בעזרת SMTP או `mail()`_, באיזה שרת דואר
להשתמש וכדומה.



.. _`mail()`: http://php.net/mail
