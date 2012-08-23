.. EN-Revision: none
.. _zend.mail.introduction:

Wprowadzenie
============

.. _zend.mail.introduction.getting-started:

Getting started
---------------

*Zend_Mail* zapewnia możliwość tworzenia i wysyłania tekstowych wiadomości e-mail oraz wieloczęściowych
wiadomości e-mail zgodnych z MIME. Wiadomość może być wysłana przez *Zend_Mail* za pomocą domyślnego
transportu *Zend_Mail_Transport_Sendmail* lub za pomocą *Zend_Mail_Transport_Smtp*.

.. _zend.mail.introduction.example-1:

.. rubric:: Wysyłanie prostego e-maila za pomocą Zend_Mail

Prosty e-mail składa się z odbiorców, z tematu, treści i z nadawcy. Aby wysłać taki e-mail używając
*Zend_Mail_Transport_Sendmail* możesz zrobić to w ten sposób:

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->setBodyText('Treść wiadomości e-mail.');
   $mail->setFrom('somebody@example.com', 'Nadawca');
   $mail->addTo('somebody_else@example.com', 'Odbiorca');
   $mail->setSubject('Testowy Temat');
   $mail->send();


.. note::

   **Minimalne definicje**

   Aby wysłać e-mail za pomocą *Zend_Mail* musisz określić chociaż jednego odbiorcę, nadawcę (np., za
   pomocą *setFrom()*), i treść wiadomości (tekst i/lub HTML).

Dla większości atrybutów obiektu mail są dostępne metody "get" w służące do odczytywania przechowywanych w
nim informacji. Więcej informacji można znaleść w dokumentacji API. Specjalną metodą jest *getRecipients()*.
Zwraca ona tablicę w wszystkimi adresami e-mail odbiorców, które zostały dodane.

Ze względów bezpieczeństwa, *Zend_Mail* filtruje wszystkie nagłówki aby zapobiec dołączeniu niechcianych
nagłówków za pomocą znaku nowej linii (*\n*).

You also can use most methods of the *Zend_Mail* object with a convenient fluent interface. A fluent interface
means that each method returns a reference to the object on which it was called, so you can immediately call
another method.

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->setBodyText('This is the text of the mail.')
       ->setFrom('somebody@example.com', 'Some Sender')
       ->addTo('somebody_else@example.com', 'Some Recipient')
       ->setSubject('TestSubject')
       ->send();


.. _zend.mail.introduction.sendmail:

Configuring the default sendmail transport
------------------------------------------

The default transport for a *Zend_Mail* instance is *Zend_Mail_Transport_Sendmail*. It is essentially a wrapper to
the PHP `mail()`_ function. If you wish to pass additional parameters to the `mail()`_ function, simply create a
new transport instance and pass your parameters to the constructor. The new transport instance can then act as the
default *Zend_Mail* transport, or it can be passed to the *send()* method of *Zend_Mail*.

.. _zend.mail.introduction.sendmail.example-1:

.. rubric:: Passing additional parameters to the Zend_Mail_Transport_Sendmail transport

This example shows how to change the Return-Path of the `mail()`_ function.

.. code-block:: php
   :linenos:

   $tr = new Zend_Mail_Transport_Sendmail('-freturn_to_me@example.com');
   Zend_Mail::setDefaultTransport($tr);

   $mail = new Zend_Mail();
   $mail->setBodyText('This is the text of the mail.');
   $mail->setFrom('somebody@example.com', 'Some Sender');
   $mail->addTo('somebody_else@example.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send();


.. note::

   **Safe mode restrictions**

   The optional additional parameters will be cause the `mail()`_ function to fail if PHP is running in safe mode.



.. _`mail()`: http://php.net/mail
