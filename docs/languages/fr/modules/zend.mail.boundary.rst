.. _zend.mail.boundary:

Contrôler les limites MIME
==========================

Dans un message en plusieurs parties, une limite *MIME* est normalement générée aléatoirement pour séparer les
différentes parties du message. Cependant dans le cas où vous souhaiteriez spécifier vous-même la limite *MIME*
utilisée, vous pouvez appeler la méthode ``setMimeBoundary()``, comme le montre l'exemple suivant :

.. _zend.mail.boundary.example-1:

.. rubric:: Changer la limite MIME

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->setMimeBoundary('=_' . md5(microtime(1) . $someId++));
   // construction du message...


