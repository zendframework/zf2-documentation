.. _zendservice.recaptcha:

ZendService\\ReCaptcha
======================

.. _zendservice.recaptcha.introduction:

Introduction
------------

``ZendService\ReCaptcha\ReCaptcha`` provides a client for the `reCAPTCHA Web Service`_. Per the reCAPTCHA site, "reCAPTCHA
is a free CAPTCHA service that helps to digitize books." Each reCAPTCHA requires the user to input two words, the
first of which is the actual CAPTCHA, and the second of which is a word from some scanned text that Optical
Character Recognition (OCR) software has been unable to identify. The assumption is that if a user correctly
provides the first word, the second is likely correctly entered as well, and can be used to improve OCR software
for digitizing books.

In order to use the reCAPTCHA service, you will need to `sign up for an account`_ and register one or more domains
with the service in order to generate public and private keys.

.. _zendservice.recaptcha.simplestuse:

Simplest use
------------

Instantiate a ``ZendService\ReCaptcha\ReCaptcha`` object, passing it your public and private keys:

.. _zendservice.recaptcha.simplestuse.example-1:

Creating an instance of the reCAPTCHA service
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   $recaptcha = new ZendService\ReCaptcha\ReCaptcha($pubKey, $privKey);

To render the reCAPTCHA, simply call the ``getHTML()`` method:

.. _zendservice.recaptcha.simplestuse.example-2:

Displaying the reCAPTCHA
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   echo $recaptcha->getHTML();

When the form is submitted, you should receive two fields, 'recaptcha_challenge_field' and
'recaptcha_response_field'. Pass these to the reCAPTCHA object's ``verify()`` method:

.. _zendservice.recaptcha.simplestuse.example-3:

Verifying the form fields
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   $result = $recaptcha->verify(
       $_POST['recaptcha_challenge_field'],
       $_POST['recaptcha_response_field']
   );

Once you have the result, test against it to see if it is valid. The result is a
``ZendService\ReCaptcha\Response`` object, which provides an ``isValid()`` method.

.. _zendservice.recaptcha.simplestuse.example-4:

Validating the reCAPTCHA
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   if (!$result->isValid()) {
       // Failed validation
   }

It is even simpler to use :ref:`the reCAPTCHA <zend.captcha.adapters.recaptcha>` ``Zend\Captcha`` adapter, or to
use that adapter as a backend for the :ref:`CAPTCHA form element <zend.form.standardElements.captcha>`. In each
case, the details of rendering and validating the reCAPTCHA are automated for you.

.. _zendservice.recaptcha.mailhide:

Hiding email addresses
----------------------

``ZendService\ReCaptcha\MailHide`` can be used to hide email addresses. It will replace a part of an email address
with a link that opens a popup window with a reCAPTCHA challenge. Solving the challenge will reveal the complete
email address.

In order to use this component you will need `an account`_ to generate public and private keys for the mailhide
*API*.

.. _zendservice.recaptcha.mailhide.example-1:

Using the mail hide component
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   // The mail address we want to hide
   $mail = 'mail@example.com';

   // Create an instance of the mailhide component, passing it your public
   // and private keys, as well as the mail address you want to hide
   $mailHide = new ZendService\ReCaptcha\Mailhide();
   $mailHide->setPublicKey($pubKey);
   $mailHide->setPrivateKey($privKey);
   $mailHide->setEmail($mail);

   // Display it
   print($mailHide);

The example above will display "m...@example.com" where "..." has a link that opens up a popup window with a
reCAPTCHA challenge.

The public key, private key, and the email address can also be specified in the constructor of the class. A fourth
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



The configuration options can be set by sending them as the fourth argument to the constructor or by calling
``setOptions($options)``, which takes an associative array or an instance of :ref:`Zend\Config\Config <zend.config>`.

.. _zendservice.recaptcha.mailhide.example-2:

Generating many hidden email addresses
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   // Create an instance of the mailhide component, passing it your public
   // and private keys, as well as some configuration options
   $mailHide = new ZendService\ReCaptcha\Mailhide();
   $mailHide->setPublicKey($pubKey);
   $mailHide->setPrivateKey($privKey);
   $mailHide->setOptions(array(
       'linkTitle' => 'Click me',
       'linkHiddenText' => '+++++',
   ));

   // The mail addresses we want to hide
   $mailAddresses = array(
       'mail@example.com',
       'johndoe@example.com',
       'janedoe@example.com',
   );

   foreach ($mailAddresses as $mail) {
       $mailHide->setEmail($mail);
       print($mailHide);
   }



.. _`reCAPTCHA Web Service`: http://recaptcha.net/
.. _`sign up for an account`: http://recaptcha.net/whyrecaptcha.html
.. _`an account`: http://recaptcha.net/whyrecaptcha.html
