.. EN-Revision: none
.. _zend.mail.additional-headers:

Iné e-mail hlavičky
===================

Iné e-mail hlavičky je možné pridať pomocou metódy *addHeader()*. Prvý parameter obsahuje meno hlavičky a
druhý jej hodnotu. Tretí parameter je nepovinný a určuje či daná hlavička môže mať jednu, alebo viac
hodnôt:

.. rubric:: Pridavanie iných e-mail hlavičiek

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   $mail->addHeader('X-MailGenerator', 'MyCoolApplication');
   $mail->addHeader('X-greetingsTo', 'Mom', true); // multiple values
   $mail->addHeader('X-greetingsTo', 'Dad', true);
   ?>

