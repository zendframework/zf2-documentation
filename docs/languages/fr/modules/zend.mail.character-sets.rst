.. EN-Revision: none
.. _zend.mail.character-sets:

Jeux de caractères
==================

``Zend_Mail`` ne recherche pas le jeu de caractères des parties de l'émail. Lorsque vous instanciez
``Zend_Mail``, un jeu de caractères pour l'émail peut être fournit. La valeur par défaut est *iso-8859-1*.
L'application doit vérifier que toutes les parties ajoutées à cet émail ont leurs contenus encodés avec le bon
jeu de caractères. Lors de la création d'une nouvelle partie de l'émail, un jeu de caractères différent
peut-être définit pour chaque partie.

.. note::

   **Seulement au format texte**

   Les jeux de caractères ne s'appliquent que pour les parties du message au format texte.

.. _zend.mail.character-sets.cjk:

.. rubric:: Usage in CJK languages

The following example is how to use ``Zend_Mail`` in Japanese. This is one of *CJK* (aka *CJKV*) languages. If you
use Chinese, you may use *HZ-GB-2312* instead of *ISO-2022-JP*.

.. code-block:: php
   :linenos:

   //We suppose that character encoding of strings is UTF-8 on PHP script.
   function myConvert($string) {
       return mb_convert_encoding($string, 'ISO-2022-JP', 'UTF-8');
   }

   $mail = new Zend\Mail\Mail('ISO-2022-JP');
   // In this case, You can use ENCODING_7BIT
   // because the ISO-2022-JP does not use MSB.
   $mail->setBodyText(myConvert('This is the text of the mail.'),
                      null,
                      Zend\Mime\Mime::ENCODING_7BIT);
   $mail->setHeaderEncoding(Zend\Mime\Mime::ENCODING_BASE64);
   $mail->setFrom('somebody@example.com', myConvert('Some Sender'));
   $mail->addTo('somebody_else@example.com', myConvert('Some Recipient'));
   $mail->setSubject(myConvert('TestSubject'));
   $mail->send();


