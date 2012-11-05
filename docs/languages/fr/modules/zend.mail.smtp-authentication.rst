.. EN-Revision: none
.. _zend.mail.smtp-authentication:

Authentification SMTP
=====================

``Zend_Mail`` supporte l'utilisation de l'authentification SMTP, qui peut être activé en passant le paramètre
"auth" au tableau de configuration du constructeur de ``Zend\Mail_Transport\Smtp``. Les méthodes
d'authentification intégrées disponibles sont PLAIN, LOGIC et CRAM-MD5 qui ont tous besoins des valeurs
"username" et "password" dans le tableau de configuration.

.. _zend.mail.smtp-authentication.example-1:

.. rubric:: Activer l'authentification dans Zend\Mail_Transport\Smtp

.. code-block:: php
   :linenos:

   $config = array('auth' => 'login',
                   'username' => 'myusername',
                   'password' => 'password');

   $transport = new Zend\Mail_Transport\Smtp('mail.server.com', $config);

   $mail = new Zend\Mail\Mail();
   $mail->setBodyText('Ceci est le texte de l\'email.');
   $mail->setFrom('emetteur@test.com', 'Un émetteur');
   $mail->addTo('destinataire@test.com', 'Un destinataire');
   $mail->setSubject('Sujet de test');
   $mail->send($transport);

.. note::

   **Type d'authentification**

   Le type d'authentification est sensible à la casse mais ne contient pas de ponctuation. Par exemple, pour
   utiliser CRAM-MD5 vous devez passer *'auth' => 'crammd5'* dans le constructeur de ``Zend\Mail_Transport\Smtp``.


