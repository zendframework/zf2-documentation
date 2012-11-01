.. EN-Revision: none
.. _zend.mail.character-sets:

Zeichensätze
============

``Zend_Mail`` prüft nicht auf die richtigen Zeichensätze für die Mailbestandteile. Wenn ``Zend_Mail``
instanziiert wird, kann ein Zeichensatz für die Mail selbst angegeben werden. Der Standardwert ist **iso-8859-1**.
Die Anwendung muss sicherstellen, dass die Inhalte aller Bestandteile des Mailobjektes im richtigen Zeichensatz
codiert sind. Wenn ein neuer Mailbestandteil erstellt wird, kann für jeden Bestandteil ein anderer Zeichensatz
angegeben werden.

.. note::

   **Nur im Textformat**

   Zeichensätze sind nur auf Mailbestandteile im Textformat anwendbar.

.. _zend.mail.character-sets.cjk:

.. rubric:: Verwendung in CJK Sprachen

Das folgende Beispiel zeigt wie ``Zend_Mail`` im japanischen verwendet werden kann. Das ist eine der *CJK* (oder
auch *CJKV*) Sprachen. Wenn man Chinesisch verwendet, kann man auch *HZ-GB-2312* statt *ISO-2022-JP* verwenden.

.. code-block:: php
   :linenos:

   // Wir nehmen an das die Zeichenkodierung der Strings in PHP Skripten UTF-8 ist
   function myConvert($string) {
       return mb_convert_encoding($string, 'ISO-2022-JP', 'UTF-8');
   }

   $mail = new Zend\Mail\Mail('ISO-2022-JP');
   // In diesem Fall kann ENCODING_7BIT verwendet werden,
   // weil ISO-2022-JP MSB nicht verwendet
   $mail->setBodyText(myConvert('This is the text of the mail.'),
                                null,
                                Zend\Mime\Mime::ENCODING_7BIT);
   $mail->setHeaderEncoding(Zend\Mime\Mime::ENCODING_BASE64);
   $mail->setFrom('somebody@example.com', myConvert('Some Sender'));
   $mail->addTo('somebody_else@example.com', myConvert('Some Recipient'));
   $mail->setSubject(myConvert('TestSubject'));
   $mail->send();


