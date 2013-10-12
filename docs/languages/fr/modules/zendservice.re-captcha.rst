.. EN-Revision: none
.. _zendservice.recaptcha:

ZendService\ReCaptcha\ReCaptcha
======================

.. _zendservice.recaptcha.introduction:

Introduction
------------

``ZendService\ReCaptcha\ReCaptcha`` fournit un client pour le `Service Web reCAPTCHA`_. D'après le site de reCAPTCHA,
"reCAPTCHA est un service gratuit de CAPTCHA qui aide à la numérisation de livres." Chaque reCAPTCHA requière
que l'utilisateur saisisse 2 mots, le premier est le CAPTCHA, et le second est issu de texte scanné que les OCR
(Optical Character Recognition) ne peuvent identifier.

Pour utiliser le service reCAPTCHA, vous devez `créer un compte`_ et enregistrer un ou plusieurs domaines
d'utilisation afin de générer une clé publique et une privée.

.. _zendservice.recaptcha.simplestuse:

Utilisation la plus simple
--------------------------

Instanciez un objet ``ZendService\ReCaptcha\ReCaptcha`` en lui passant vos clés publique et privée :

.. _zendservice.recaptcha.example-1:

.. rubric:: Créer une instance de service ReCaptcha

.. code-block:: php
   :linenos:

   $recaptcha = new ZendService\ReCaptcha\ReCaptcha($pubKey, $privKey);

Pour rendre le reCAPTCHA, appelez simplement la méthode ``getHTML()``:

.. _zendservice.recaptcha.example-2:

.. rubric:: Afficher le ReCaptcha

.. code-block:: php
   :linenos:

   echo $recaptcha->getHTML();

Lorsque le formulaire est envoyé, vous devriez recevoir 2 champs 'recaptcha_challenge_field' et
'recaptcha_response_field'. Passez les alors à la méthode ``verify()``:

.. code-block:: php
   :linenos:

   $result = $recaptcha->verify(
       $_POST['recaptcha_challenge_field'],
       $_POST['recaptcha_response_field']
   );

Une fois que vous possédez le résultat, vérifiez sa validité. Il s'agit d'un objet
``ZendService\ReCaptcha\Response`` qui possède une méthode ``isValid()``.

.. _zendservice.recaptcha.example-3:

.. rubric:: Vérifier les champs de formulaire

.. code-block:: php
   :linenos:

   if (!$result->isValid()) {
       // Validation échouée
   }

Encore plus simple : utilisez :ref:`l'adaptateur ReCaptcha <zend.captcha.adapters.recaptcha>` de ``Zend_Captcha``,
ou utilisez cet adaptateur comme backend pour :ref:`l'élément formulaire Captcha
<zend.form.standardElements.captcha>`. Dans ces 2 cas, le rendu et la validation du reCAPTCHA sont assurés pour
vous.

.. _zendservice.recaptcha.mailhide:

Hiding email addresses
----------------------

``ZendService\ReCaptcha\MailHide`` can be used to hide email addresses. It will replace a part of an email address
with a link that opens a popup window with a ReCaptcha challenge. Solving the challenge will reveal the complete
email address.

In order to use this component you will need `an account`_, and generate public and private keys for the mailhide
API.

.. _zendservice.recaptcha.mailhide.example-1:

.. rubric:: Using the mail hide component

.. code-block:: php
   :linenos:

   // The mail address we want to hide
   $mail = 'mail@example.com';

   // Create an instance of the mailhide component, passing it your public and private keys as well as
   // the mail address you want to hide
   $mailHide = new ZendService\ReCaptcha\Mailhide();
   $mailHide->setPublicKey($pubKey);
   $mailHide->setPrivateKey($privKey);
   $mailHide->setEmail($mail);

   // Display it
   print($mailHide);

The example above will display "m...@example.com" where "..." has a link that opens up a popup windows with a
ReCaptcha challenge.

The public key, private key and the email address can also be specified in the constructor of the class. A fourth
argument also exists that enables you to set some options for the component. The available options are listed in
the following table:



      .. _zendservice.recaptcha.mailhide.options.table:

      .. table:: ZendService\ReCaptcha\MailHide options

         +--------------+-------------------------------------+---------------+----------------------------+
         |Option        |Description                          |Expected Values|Default Value               |
         +==============+=====================================+===============+============================+
         |linkTitle     |The title attribute of the link      |string         |'Reveal this e=mail address'|
         +--------------+-------------------------------------+---------------+----------------------------+
         |linkHiddenText|The text that includes the popup link|string         |'...'                       |
         +--------------+-------------------------------------+---------------+----------------------------+
         |popupWidth    |The width of the popup window        |int            |500                         |
         +--------------+-------------------------------------+---------------+----------------------------+
         |popupHeight   |The height of the popup window       |int            |300                         |
         +--------------+-------------------------------------+---------------+----------------------------+



The configuration options can be set by sending it as the fourth argument to the constructor or by calling the
``setOptions($options)`` which takes an associative array or an instance of :ref:`Zend_Config <zend.config>`.

.. _zendservice.recaptcha.mailhide.example-2:

.. rubric:: Generating many hidden email addresses

.. code-block:: php
   :linenos:

   // Create an instance of the mailhide component, passing it your public and private keys as well as
   // well the mail address you want to hide
   $mailHide = new ZendService\ReCaptcha\Mailhide();
   $mailHide->setPublicKey($pubKey);
   $mailHide->setPrivateKey($privKey);
   $mailHide->setOptions(array(
       'linkTitle' => 'Click me',
       'linkHiddenText' => '+++++',
   ));

   // The addresses we want to hide
   $mailAddresses = array(
       'mail@example.com',
       'johndoe@example.com',
       'janedoe@example.com',
   );

   foreach ($mailAddresses as $mail) {
       $mailHide->setEmail($mail);
       print($mailHide);
   }



.. _`Service Web reCAPTCHA`: http://recaptcha.net/
.. _`créer un compte`: http://recaptcha.net/whyrecaptcha.html
.. _`an account`: http://recaptcha.net/whyrecaptcha.html
