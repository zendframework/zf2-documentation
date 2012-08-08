.. EN-Revision: none
.. _zend.mail.additional-headers:

Zusätzliche Kopfzeilen
======================

``Zend_Mail`` bietet verschiedene Methode um zusätzliche Mail Header zu setzen:



   - ``setReplyTo($email, $name=null)``: Setzt den Reply-To: Header.

   - ``setDate($date = null)``: Setzt den Date: Header. Diese Methode verwendet standardmäßig den aktuellen
     Zeitpunkt. Man kann dieser Methode auch einen Zeitpunkt, einen Datumsstring oder eine Instanz von
     ``Zend_Date`` übergeben.

   - ``setMessageId($id = true)``: Setzt den Message-Id: Header. Diese Methode erzeugt standardmäßig automatisch
     eine Message ID. Oder man übergibt der Methode einen eigenen Message ID String. Diese Methode ruft intern
     ``createMessageId()`` auf.



.. note::

   **Return-Path**

   Wenn man den Return-Path in eigenen Mail setzen will, sollte man unter :ref:`Konfiguration des Sendmail
   Transports <zend.mail.introduction.sendmail>` nachsehen. Unglücklicherweise führt die
   ``setReturnPath($email)`` Methode dies nicht aus.

Weiters können eigene Mail Header gesetzt werden indem man die ``addHeader()`` Methode verwendet. Sie benötigt
zwei Parameter welche den Namen und den Wert des Header Fields enthalten. Ein optionaler dritter Parameter zeigt an
ob der Header nur einen oder mehrere Werte enthalten soll:

.. _zend.mail.additional-headers.example-1:

.. rubric:: Eine E-Mail Kopfzeile hinzufügen

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->addHeader('X-MailGenerator', 'MeineCooleAnwendung');
   $mail->addHeader('X-greetingsTo', 'Mom', true); // mehrer Werte
   $mail->addHeader('X-greetingsTo', 'Dad', true);


