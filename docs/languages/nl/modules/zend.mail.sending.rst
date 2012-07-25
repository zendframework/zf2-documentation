.. _zend.mail.sending:

E-mail sturen via SMTP
======================

Om e-mail te sturen via SMTP moet een *Zend_Mail_Transport_Smtp* worden gemaakt en geregistreerd aan *Zend_Mail*
voordat de *send()* methode wordt opgeroepen. Het SMTP transport zal dan voor alle verdere oproepen in het huidige
script aan *Zend_Mail::send()* worden gebruikt:

.. rubric:: E-mail sturen via SMTP

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail/Transport/Smtp.php';
   $tr = new Zend_Mail_Transport_Smtp('mail.example.com');
   Zend_Mail::setDefaultTransport($tr);
   ?>
De *setDefaultTransport()* methode en de constructor van *Zend_Mail_Transport_Smtp* zijn geen dure operaties. Deze
twee regels kunnen worden behandeld terwijl je de setup van het script doet (bv: config.inc of iets dergelijks) om
het gedrag van de *Zend_Mail* klasse voor de rest van het script te configureren. Dit houdt de configuratielogica
uit de toepassingslogica - of mail gezonden word via SMTP of `mail()`_, welke mail server te gebruiken enz...



.. _`mail()`: http://php.net/mail
