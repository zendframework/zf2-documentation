.. EN-Revision: none
.. _zend.mail.boundary:

Controllo del separatore MIME
=============================

In un messaggio multipart, un separatore MIME (MIME boundary) viene normalmente generato in modo casuale per
delimitarne le diverse parti. Tuttavia, in alcuni casi, potrebbe essere necessario specificare il separatore MIME
da utilizzare. Questo è possibile grazie al metodo *setMimeBoundary()*, come dimostra l'esempio seguente:

.. _zend.mail.boundary.example-1:

.. rubric:: Cambio del separatore MIME

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   $mail->setMimeBoundary('=_' . md5(microtime(1) . $someId++);
   // crea il messaggio...


