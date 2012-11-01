.. EN-Revision: none
.. _zend.mail.different-transports:

Verwendung von unterschiedlichen Versandwegen
=============================================

Falls du verschiedene E-Mails über verschiedene Verbindungen versenden möchtest, kannst du das Transport Objekt
auch ohne vorherigen Aufruf von ``setDefaultTransport()`` direkt an ``send()`` übergeben. Das übergebene Objekt
wird den standardmäßigen Versandweg für die aktuellen Anfrage von ``send()`` überschreiben.

.. _zend.mail.different-transports.example-1:

.. rubric:: Verwendung von unterschiedlichen Transportwegen

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Mail();
   // erstelle Nachricht...
   $tr1 = new Zend\Mail_Transport\Smtp('server@example.com');
   $tr2 = new Zend\Mail_Transport\Smtp('other_server@example.com');
   $mail->send($tr1);
   $mail->send($tr2);
   $mail->send();  // wieder Standardmethode verwenden

.. note::

   **Zusätzliche Versandwege**

   Weitere Versandwege können geschrieben werden, indem ``Zend\Mail_Transport\Interface`` implementiert wird.


