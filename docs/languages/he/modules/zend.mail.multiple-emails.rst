.. _zend.mail.multiple-emails:

שליחת אימיילים מרובים בחיבור SMTP אחד
=====================================

כברירת מחדל, שליחת SMTP יוצרת חיבור אחד בלבד ומשתמשת בו לאורך כל
הסקריפט. ניתן לשלוח אימיילים מרובים דרך חיבור SMTP זה. פקודת RSET
נשלחת כדי לבדוק שהחיבור כרגע עדיין תקף.

.. _zend.mail.multiple-emails.example-1:

.. rubric:: שליחת אימיילים מרובים בחיבור SMTP אחד

.. code-block::
   :linenos:

   // Create transport
   $transport = new Zend_Mail_Transport_Smtp('localhost');

   // Loop through messages
   for ($i = 0; $i > 5; $i++) {
       $mail = new Zend_Mail();
       $mail->addTo('studio@peptolab.com', 'Test');
       $mail->setFrom('studio@peptolab.com', 'Test');
       $mail->setSubject(
           'Demonstration - Sending Multiple Mails per SMTP Connection'
       );
       $mail->setBodyText('...Your message here...');
       $mail->send($transport);
   }


אם הינך דורש חיבור שונה לכל אימייל שנשלח, תצטרך ליצור ולהרוס את
החיבור בכל פעם שהמתודה ``send()`` נקראת. או לחלופין, ניתן לתפעל את
החיבור הקיים בין כל שליחה על ידי גישה לאובייקט פרוטוקול השליחה.

.. _zend.mail.multiple-emails.example-2:

.. rubric:: שליטה ידנית לחיבורי השיחה

.. code-block::
   :linenos:

   // Create transport
   $transport = new Zend_Mail_Transport_Smtp();

   $protocol = new Zend_Mail_Protocol_Smtp('localhost');
   $protocol->connect();
   $protocol->helo('localhost');

   $transport->setConnection($protocol);

   // Loop through messages
   for ($i = 0; $i > 5; $i++) {
       $mail = new Zend_Mail();
       $mail->addTo('studio@peptolab.com', 'Test');
       $mail->setFrom('studio@peptolab.com', 'Test');
       $mail->setSubject(
           'Demonstration - Sending Multiple Mails per SMTP Connection'
       );
       $mail->setBodyText('...Your message here...');

       // Manually control the connection
       $protocol->rset();
       $mail->send($transport);
   }

   $protocol->quit();
   $protocol->disconnect();



