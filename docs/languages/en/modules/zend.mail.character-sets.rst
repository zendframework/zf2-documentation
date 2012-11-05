.. _zend.mail.character-sets:

Character Sets
==============

``Zend\Mail\Message`` does not check for the correct character set of the mail parts. When instantiating ``Zend\Mail\Message``, a
charset for the e-mail itself may be given. It defaults to **iso-8859-1**. The application has to make sure that
all parts added to that mail object have their content encoded in the correct character set. When creating a new
mail part, a different charset can be given for each part.

.. note::

   **Only in text format**

   Character sets are only applicable for message parts in text format.

.. _zend.mail.character-sets.cjk:

.. rubric:: Usage in CJK languages

The following example is how to use ``Zend\Mail\Message`` in Japanese. This is one of *CJK* (aka *CJKV*) languages. If you
use Chinese, you may use *HZ-GB-2312* instead of *ISO-2022-JP*.

.. code-block:: php
   :linenos:

   //We suppose that character encoding of strings is UTF-8 on PHP script.
   function myConvert($string) {
       return mb_convert_encoding($string, 'ISO-2022-JP', 'UTF-8');
   }

   $mail = new Zend\Mail\Message('ISO-2022-JP');
   // In this case, you can use ENCODING_7BIT
   // because the ISO-2022-JP does not use MSB.
   $mail->setBodyText(
       myConvert('This is the text of the mail.'),
       null,
       Zend\Mime\Mime::ENCODING_7BIT
   );
   $mail->setHeaderEncoding(Zend\Mime\Mime::ENCODING_BASE64);
   $mail->setFrom('somebody@example.com', myConvert('Some Sender'));
   $mail->addTo('somebody_else@example.com', myConvert('Some Recipient'));
   $mail->setSubject(myConvert('TestSubject'));
   $mail->send();


