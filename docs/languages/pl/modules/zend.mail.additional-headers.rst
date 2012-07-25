.. _zend.mail.additional-headers:

Dodatkowe nagłówki
==================

Dodatkowe nagłówki wiadomości mogą być ustawione za pomocą metody *addHeader()*. Wymaga ona dwóch
parametrów: nazwy nagłówka oraz jej wartości. Trzeci opcjonalny parametr decyduje o tym, czy nagłówek
powinien mieć jedną czy wiele wartości:

.. _zend.mail.additional-headers.example-1:

.. rubric:: Dodawanie nagłówków do wiadomości e-mail

.. code-block:: php
   :linenos:

   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   $mail->addHeader('X-MailGenerator', 'MyCoolApplication');
   $mail->addHeader('X-greetingsTo', 'Mom', true); // wiele wartości
   $mail->addHeader('X-greetingsTo', 'Dad', true);



