.. EN-Revision: none
.. _zend.mail.introduction:

Einführung
==========

.. _zend.mail.introduction.getting-started:

Beginnen
--------

``Zend_Mail`` stellt verallgemeinerte Funktionalitäten zum Verfassen und Senden sowohl von Text E-Mails als auch
von *MIME*-konformen mehrteiligen E-Mails bereit. Mails können mit ``Zend_Mail`` durch den Standardtransport
``Zend\Mail\Transport\Sendmail`` oder über ``Zend\Mail\Transport\Smtp`` versendet werden.

.. _zend.mail.introduction.example-1:

.. rubric:: Einfache E-Mail mit Zend_Mail

Eine einfache E-Mail besteht aus einigen Empfängern, einem Betreff, einem Hauptteil und einem Versender. Um solch
eine Mail durch Verwenden von ``Zend\Mail\Transport\Sendmail`` zu Verwenden muß folgendes getan werden:

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Mail();
   $mail->setBodyText('Dies ist der Text dieser E-Mail.');
   $mail->setFrom('somebody@example.com', 'Ein Versender');
   $mail->addTo('somebody_else@example.com', 'Ein Empfänger');
   $mail->setSubject('TestBetreff');
   $mail->send();

.. note::

   **Minimale Definitionen**

   Um eine E-Mail mit ``Zend_Mail`` zu versenden, muß mindestens ein Empfänger, ein Versender (z.B., mit
   ``setFrom()``) und ein Nachrichtentext (Text und/oder *HTML*) angeben werden.

Für die meisten Mailattribute gibt es "Get" Methoden, um die im Mailobjekt abgelegten Informationen zu lesen. Für
weitere Einzelheiten kann in die *API* Dokumentation gesehen werden. Eine besondere Methode ist
``getRecipients()``. Sie gibt ein Array mit allen E-Mail Adressen der Empfänger zurück, die vor dem
Methodenaufruf hinzugefügt worden sind.

Aus Sicherheitsgründen filtert ``Zend_Mail`` alle Felder des Nachrichtenkopfs, um eine "Header Injection" mittels
Zeilenvorschubzeichen (**\n**) zu verhindern. Doppelte Anführungszeichen werden zu einzelnen gewechselt und runde
Klammern zu eckigen sowohl im Namen des Senders als auch des Empfängers. Wenn die Marken in Emailadressen sind,
werden diese Marken entfernt.

Die meisten Methoden des ``Zend_Mail`` Objekts können mit dem bequemen Flüssigen Interface verwendet werden.

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Mail();
   $mail->setBodyText('Das ist der Text der Nachricht.')
       ->setFrom('somebody@example.com', 'Einige Sender')
       ->addTo('somebody_else@example.com', 'Einige Empfänger')
       ->setSubject('TestBetreff')
       ->send();

.. _zend.mail.introduction.sendmail:

Den standardmäßigen Sendmail Transport konfigurieren
----------------------------------------------------

Der standard Transport für eine ``Zend_Mail`` Instanz ist ``Zend\Mail\Transport\Sendmail``. Es ist
notwendigerweise ein Wrapper für *PHP*'s `mail()`_ Funktion. Wenn der `mail()`_ Funktion zusätzliche Parameter
mitgegeben werden sollen muß einfach eine neue Transport Instanz erzeugt werden und die Parameter dem Konstruktor
übergeben werden. Die neue Transport Instanz kann dann als standard ``Zend_Mail`` Transport handeln oder der
``send()`` Methode von ``Zend_Mail`` übergeben werden.

.. _zend.mail.introduction.sendmail.example-1:

.. rubric:: Zusätzliche Parameter einem Zend\Mail\Transport\Sendmail Transport übergeben

Dieses Beispiel zeigt wie der Rückgabe-Pfad der `mail()`_ Funktion geändert werden kann.

.. code-block:: php
   :linenos:

   $tr = new Zend\Mail\Transport\Sendmail('-freturn_to_me@example.com');
   Zend\Mail\Mail::setDefaultTransport($tr);

   $mail = new Zend\Mail\Mail();
   $mail->setBodyText('Das ist ein Text der Mail.');
   $mail->setFrom('somebody@example.com', 'Einige Sender');
   $mail->addTo('somebody_else@example.com', 'Einige Empfänger');
   $mail->setSubject('TestBetreff');
   $mail->send();

.. note::

   **Safe Mode Einschränkungen**

   Der zusätzliche optionale Parameter verursacht das die `mail()`_ Funktion fehlschlägt wenn *PHP* im Safe Mode
   läuft.

.. warning::

   **Sendmail Transport und Windows**

   Das Handbuch von *PHP* sagt aus dass die Methode ``mail()`` ein unterschiedliches Verhalten auf Windows und auf
   \*nix basierten Systemen zeigt. Die Verwendung von Sendmail Transport wird auf Windows nicht in Verbindung mit
   ``addBcc()`` funktionieren. Die ``mail()`` Funktion sendet auf eine Art und Weise an den BCC Empfänger, das
   alle anderen Empfänger diesen als Empfänger sehen!

   Deswegen sollte man, wenn man BCC auf einem Windows Server verwenden will, den SMTP Transport für das Senden
   verwenden!



.. _`mail()`: http://php.net/mail
