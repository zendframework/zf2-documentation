.. _zend.mail.sending:

Envoyer des émail en utilisant SMTP
===================================

Pour envoyer des émail via SMTP, ``Zend_Mail_Transport_Smtp`` a besoin d'être créé et enregistré avant que la
méthode soit appelée. Pour tout appel de ``Zend_Mail::send()`` dans le script en cours, le transport SMTP sera
utilisé :

.. _zend.mail.sending.example-1:

.. rubric:: Envoyer un émail via SMTP

.. code-block:: php
   :linenos:

   $tr = new Zend_Mail_Transport_Smtp('mail.example.com');
   Zend_Mail::setDefaultTransport($tr);

La méthode ``setDefaultTransport()`` et le constructeur de ``Zend_Mail_Transport_Smtp`` ne sont pas coûteux en
terme de performances. Ces deux lignes peuvent être traitées lors de l'initialisation du script (par exemple dans
un fichier ``config.inc``) pour configurer le comportement de la classe ``Zend_Mail`` pour le reste du script. Cela
garde les informations de configuration en dehors de la logique applicative - si les émail doivent être envoyés
via SMTP ou via `mail()`_, quel serveur est utilisé, etc.



.. _`mail()`: http://php.net/mail
