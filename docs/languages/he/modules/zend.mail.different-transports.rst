.. _zend.mail.different-transports:

שימוש בחיבורים שונים
====================

במידה ותרצו לשלוח אימיילים שונים בחיבורים שונים, תוכלו להעביר
את אובייקט השליחה ישירות ל *send()* ללא שום קריאה קודם ל
*setDefaultTransport()*. האובייקט שהועבר ידרוס את החיבור ברירת המחדל
לבקשת השליחה הנוכחית של *send()*.

.. _zend.mail.different-transports.example-1:

.. rubric:: שימוש בחיבורים שונים

.. code-block::
   :linenos:

   $mail = new Zend_Mail();
   // build message...
   $tr1 = new Zend_Mail_Transport_Smtp('server@example.com');
   $tr2 = new Zend_Mail_Transport_Smtp('other_server@example.com');
   $mail->send($tr1);
   $mail->send($tr2);
   $mail->send();  // use default again


.. note::

   **חיבורים נוספים**

   ניתן לכתוב ולהוסיף תמיכה בחיבורים נוספים על ידי שימוש ב
   *Zend_Mail_Transport_Interface*.


