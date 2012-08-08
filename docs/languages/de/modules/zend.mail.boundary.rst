.. EN-Revision: none
.. _zend.mail.boundary:

Die MIME Abgrenzung kontrollieren
=================================

In einer mehrteiligen Nachricht wird eine *MIME* Abgrenzung zum Trennen der verschiedenen Nachrichtenteile
normalerweise willkürlich generiert. In einigen Fällen möchtest Du jedoch die zu verwendene *MIME* Abgrenzung
selber angeben. Dies kann durch die ``setMimeBoundary()`` Methode erreicht werden, wie in dem folgenden Beispiel:

.. _zend.mail.boundary.example-1:

.. rubric:: Die MIME Abgrenzung ändern

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->setMimeBoundary('=_' . md5(microtime(1) . $someId++));
   // erstelle Nachricht...


