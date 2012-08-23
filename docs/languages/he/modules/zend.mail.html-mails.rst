.. EN-Revision: none
.. _zend.mail.html-mails:

אימייל בפורמט HTML
==================

כדי לשלוח אימייל בפורמט HTML, יש להגדיר את התוכן של האימייל בעזרת
המתודה *setBodyHTML()* במקום ב *setBodyText()*. הכותרים הדרושים יוגדרו
אוטומטית ומייד לכותר מסוג *text/html*. אם הנכם משתמשים גם בתוכן אשר
מציג HTML וגם בתוכן אשר מציג רק טקסט, יתווספו הכותרים המתאימים
כדי להציג את שני התכנים בצורה בה הם צריכים להיות מוצגים:

.. _zend.mail.html-mails.example-1:

.. rubric:: שליחת אימייל בפורמט HTML

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->setBodyText('My Nice Test Text');
   $mail->setBodyHtml('My Nice <b>Test</b> Text');
   $mail->setFrom('somebody@example.com', 'Some Sender');
   $mail->addTo('somebody_else@example.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send();



