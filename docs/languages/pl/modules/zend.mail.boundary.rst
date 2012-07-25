.. _zend.mail.boundary:

Pole rozgraniczające MIME
=========================

W wieloczęściowej wiadomości pole rozgraniczające MIME używane do oddzielania różnych części wiadomości
zwykle jest generowane losowo. W niektórych przypadkach możesz chciec określić jakie wartości ma mieć pole
rozgraniczające. Możesz to zrobić używając metody *setMimeBoundary()* jak w poniższym przykładzie:

.. _zend.mail.boundary.example-1:

.. rubric:: Zmiana pola rozgraniczającego MIME

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->setMimeBoundary('=_' . md5(microtime(1) . $someId++));
   // tworzymy wiadomość



