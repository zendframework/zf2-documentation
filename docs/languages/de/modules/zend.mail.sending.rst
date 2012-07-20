.. _zend.mail.sending:

Versand über SMTP
=================

Um eine E-Mail über SMTP zu versenden, muss ``Zend_Mail_Transport_Smtp`` erstellt und in ``Zend_Mail`` registriert
werden, bevor die ``send()`` Methode aufgerufen wird. Für alle verbleibenden Aufrufe von ``Zend_Mail::send()`` im
aktuellen Skript wird dann der SMTP Versand verwendet:

.. _zend.mail.sending.example-1:

.. rubric:: E-Mail Versand über SMTP

.. code-block:: php
   :linenos:

   $tr = new Zend_Mail_Transport_Smtp('mail.example.com');
   Zend_Mail::setDefaultTransport($tr);

Die ``setDefaultTransport()`` Methode und der Konstruktor von ``Zend_Mail_Transport_Smtp`` sind nicht aufwendig.
Diese beiden Zeilen können beim Start des Skriptes (z.B., config.inc oder ähnliches) abgearbeitet werden, um das
Verhalten der ``Zend_Mail`` Klasse für den Rest des Skriptes zu konfigurieren. Somit bleiben Informationen zur
Konfiguration außerhalb der Anwendungslogik - ob E-Mail über SMTP oder `mail()`_ versandt werden, welcher
Mailserver verwendet wird, usw.



.. _`mail()`: http://php.net/mail
