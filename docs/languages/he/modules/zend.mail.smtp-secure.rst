.. EN-Revision: none
.. _zend.mail.smtp-secure:

אבטחת שליחת SMTP
================

*Zend_Mail* מאפשר גם תמיכה בשימוש ב TLS או SSL כדי לאבטח את שליחת וחיבור
ה STMP. ניתן להפעיל את המנגנון על ידי העברת הערך 'ssl' כפרמטר למערך
הההגדרות במתודה של *Zend\Mail_Transport\Smtp* ברגע שיוצרים את האובייקט.
ניתן להעביר ערך של 'ssl' או 'tls' בהתאם. ניתן גם להגדיר פורט שימוש,
אחרת כברירת מחדל זה ישתמש ב 25 ל TLS או 465 ל SSL/

.. _zend.mail.smtp-secure.example-1:

.. rubric:: הפעלת חיבור מאובטח בעזרת *Zend\Mail_Transport\Smtp*

.. code-block:: php
   :linenos:

   $config = array('ssl' => 'tls',
                   'port' => 25); // Optional port number supplied

   $transport = new Zend\Mail_Transport\Smtp('mail.server.com', $config);

   $mail = new Zend\Mail\Mail();
   $mail->setBodyText('This is the text of the mail.');
   $mail->setFrom('sender@test.com', 'Some Sender');
   $mail->addTo('recipient@test.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send($transport);



