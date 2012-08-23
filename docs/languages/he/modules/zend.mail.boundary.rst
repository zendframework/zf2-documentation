.. EN-Revision: none
.. _zend.mail.boundary:

שליטה בגבולות הודעות האימיילים
==============================

בהודעות אימייל אשר מחולקות לכמה חלקים, גבול ההודעות אשר
מפרידות אחת את השנייה נוצרות על ידי סטרינג רנדומלי. בחלק
מהמקרים, לעומת זאת, תרצו להגדיר את הגבול של כל הודעה בעצמכם. את
זה תוכלו לבצע בעזרת שימוש במתודת ה *setMimeBoundary()*, כפי שמוצג בדוגמא:

.. _zend.mail.boundary.example-1:

.. rubric:: Changing the MIME Boundary

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->setMimeBoundary('=_' . md5(microtime(1) . $someId++));
   // build message...



