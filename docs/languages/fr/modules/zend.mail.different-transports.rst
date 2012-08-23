.. EN-Revision: none
.. _zend.mail.different-transports:

Utiliser différents transports
==============================

Au cas où vous voudriez envoyer différent émail via des connexions différentes, vous pouvez aussi passer
l'objet de transport directement à ``send()`` sans être obligé d'appeler ``setDefaultTransport()`` avant.
L'objet passé va être prioritaire sur le transport par défaut pour la requête ``send()`` courante.

.. _zend.mail.different-transports.example-1:

.. rubric:: Utiliser différents transports

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   // construction du message
   $tr1 = new Zend_Mail_Transport_Smtp('serveur@exemple.com');
   $tr2 = new Zend_Mail_Transport_Smtp('autre_serveur@exemple.com');
   $mail->send($tr1);
   $mail->send($tr2);
   $mail->send();  // utilisation du transport par défaut

.. note::

   **Transports additionnels**

   Des transports additionnels peuvent-être écrit en implémentant ``Zend_Mail_Transport_Interface``.


