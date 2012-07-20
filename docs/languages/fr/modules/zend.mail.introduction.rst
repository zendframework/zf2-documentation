.. _zend.mail.introduction:

Introduction
============

.. _zend.mail.introduction.getting-started:

Pour commencer
--------------

``Zend_Mail`` fournit des fonctionnalités génériques pour écrire et envoyer des émail au format texte et
*MIME*. Un émail peut-être envoyé avec ``Zend_Mail`` via le transporteur par défaut
``Zend_Mail_Transport_Sendmail`` ou via ``Zend_Mail_Transport_Smtp``.

.. _zend.mail.introduction.example-1:

.. rubric:: Émail simple avec ``Zend_Mail``

Un émail simple est composé d'un destinataire, d'un sujet, d'un message et d'un expéditeur. Pour envoyer ce
genre de messages en utilisant ``Zend_Mail_Transport_Sendmail``, vous pouvez faire comme ceci :

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->setBodyText('Ceci est le texte du message.');
   $mail->setFrom('somebody@example.com', 'un expéditeur');
   $mail->addTo('somebody_else@example.com', 'un destinataire');
   $mail->setSubject('Sujet de test');
   $mail->send();

.. note::

   **Définitions minimales**

   Pour envoyer un émail avec ``Zend_Mail``, vous devez spécifier au moins un destinataire, un expéditeur (avec
   ``setFrom()``), et un message (texte et/ou HTML).

Pour la plupart des attributs de l'émail, il y a des méthodes "get" pour lire les informations stockées dans
l'objet mail. Pour plus de détails, merci de vous référer à la documentation de l'API. Une méthode spéciale
est ``getRecipients()``. Elle retourne un tableau avec toutes les adresses émail des destinataires qui ont été
ajoutés avant l'appel de cette méthode.

Pour des raisons de sécurité, ``Zend_Mail`` filtre tous les champs d'en-tête pour éviter tout problème
d'injection d'en-têtes avec des caractères de nouvelles lignes (*\n*). Les guillemets doubles sont changés en
guillemets simples et les crochets en parenthèses dans le nom des émetteurs et des destinataires. Si ces
caractères sont dans l'adresse émail, ils sont enlevés.

Vous pouvez aussi utiliser la plupart des méthodes de l'objet ``Zend_Mail`` via une interface fluide.

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->setBodyText('Ceci est le texte du message.')
       ->setFrom('somebody@example.com', 'un expéditeur')
       ->addTo('somebody_else@example.com', 'un destinataire')
       ->setSubject('Sujet de test')
       ->send();

.. _zend.mail.introduction.sendmail:

Configurer le transport sendmail par défaut
-------------------------------------------

Le transporteur par défaut pour une instance ``Zend_Mail`` est ``Zend_Mail_Transport_Sendmail``. C'est
essentiellement un paquet pour la fonction *PHP* `mail()`_. Si vous souhaitez fournir des paramètres additionnels
à la fonction `mail()`_, créez simplement une nouvelle instance du transporteur et fournissez vos paramètres au
constructeur. La nouvelle instance du transporteur peut ainsi devenir le transporteur par défaut ``Zend_Mail``, ou
il peut être fourni à la méthode ``send()`` de ``Zend_Mail``.

.. _zend.mail.introduction.sendmail.example-1:

.. rubric:: Fournir des paramètres additionnels au transporteur ``Zend_Mail_Transport_Sendmail``

Cet exemple montre comment changer le Return-Path de la fonction `mail()`_.

.. code-block:: php
   :linenos:

   $tr = new Zend_Mail_Transport_Sendmail('-freturn_to_me@example.com');
   Zend_Mail::setDefaultTransport($tr);

   $mail = new Zend_Mail();
   $mail->setBodyText('Ceci est le texte du message.');
   $mail->setFrom('somebody@example.com', 'un expéditeur');
   $mail->addTo('somebody_else@example.com', 'un destinataire');
   $mail->setSubject('TestSubject');
   $mail->send();

.. note::

   **Restrictions en mode Safe**

   Les paramètres additionnels optionnels peuvent entraînés un échec de la fonction `mail()`_ si *PHP*
   fonctionne en mode safe.

.. warning::

   **Transport Sendmail et Windows**

   Comme le spécifie le manuel PHP, la fonction ``mail()`` a des comportements différents sous Windows ou sur les
   systèmes de type \*nix. Utiliser le transport Sendmail sous Windows ne fonctionnera pas conjointement avec
   ``addBcc()``. La fonction ``mail()`` enverra vers le destinataire BCC de manière à ce que tous les
   destinataires puissent voir qu'il est destinataire !

   Ainsi si vous voulez utiliser BCC sur un serveur Windows, utilisez le transport SMTP pour l'envoi !



.. _`mail()`: http://php.net/mail
