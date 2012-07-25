.. _zend.mail.smtp-authentication:

אימות SMTP
==========

*Zend_Mail* מאפשר שימוש באימות SMTP, אשר ניתן להפעילו על ידי הוספת
הפרמטר 'auth' למערך ההגדרות במתודת ההתחלה של *Zend_Mail_Transport_Smtp*.
המתודות המובנות הנתמכות הן PLAIN, LOGIN, CRAM-MD5 שכולם מקבלים פרמטרים
של שם משתמש וסיסמא דרך מערך ההגדרות.

.. _zend.mail.smtp-authentication.example-1:

.. rubric:: הפעלת האימות במחלקה *Zend_Mail_Transport_Smtp*

.. code-block:: php
   :linenos:

   $config = array('auth' => 'login',
                   'username' => 'myusername',
                   'password' => 'password');

   $transport = new Zend_Mail_Transport_Smtp('mail.server.com', $config);

   $mail = new Zend_Mail();
   $mail->setBodyText('This is the text of the mail.');
   $mail->setFrom('sender@test.com', 'Some Sender');
   $mail->addTo('recipient@test.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send($transport);


.. note::

   **סוגי אימות**

   סוג האימות אינו רגיש לאותיות קטנות או גדולות לדוגמא כדי
   להשתמש ב CRAM-MD5 תצטרכו להזין במערך של המחלקה *Zend_Mail_Transport_Smtp*
   ההגדרות את הפרמטרים 'auth' => 'crammd5'.


