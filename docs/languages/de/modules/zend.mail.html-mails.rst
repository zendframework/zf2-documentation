.. _zend.mail.html-mails:

HTML E-Mail
===========

Um einen E-Mail im *HTML* Format zu versenden, muss der Hauptteil der Nachricht durch die ``setBodyHTML()`` statt
durch die ``setBodyText()`` gesetzt werden. Der *MIME* Inhaltstyp wird dann automatisch auf ``text/html`` gesetzt.
Wenn du sowohl *HTML* als auch Text Daten verwendest, wird automatisch eine multipart/alternative *MIME* E-Mail
erstellt:

.. _zend.mail.html-mails.example-1:

.. rubric:: Versand von HTML E-Mail

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->setBodyText('Mein netter Test Text');
   $mail->setBodyHtml('Mein netter <b>Test</b> Text');
   $mail->setFrom('somebody@example.com', 'Ein Versender');
   $mail->addTo('somebody_else@example.com', 'Ein Empfänger');
   $mail->setSubject('TestBetreff');
   $mail->send();


