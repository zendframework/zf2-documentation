.. EN-Revision: none
.. _zend.mail.smtp-secure:

Sécuriser les transports SMTP
=============================

``Zend_Mail`` supporte aussi l'utilisation des connexions SMTP sécurisées via TLSS ou *SSL*. Ceci peut être
activé en passant le paramètre "ssl" ou "tls" au tableau de configuration du constructeur de
``Zend_Mail_Transport_Smtp``. Un port peut optionnellement être fourni, sinon il vaut par défaut 25 pour TLS et
465 pour *SSL*.

.. _zend.mail.smtp-secure.example-1:

.. rubric:: Activer une connexion sécurisée dans Zend_Mail_Transport_Smtp

.. code-block:: php
   :linenos:

   $config = array('ssl' => 'tls',
                   'port' => 25); // Port optionel fourni

   $transport = new Zend_Mail_Transport_Smtp('mail.server.com', $config);

   $mail = new Zend_Mail();
   $mail->setBodyText('Ceci est le texte de l\'email.');
   $mail->setFrom('emetteur@test.com', 'Un émetteur');
   $mail->addTo('destinataire@test.com', 'Un destinataire');
   $mail->setSubject('Sujet de test');
   $mail->send($transport);


