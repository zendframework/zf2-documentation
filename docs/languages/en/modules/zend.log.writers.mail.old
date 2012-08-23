.. _zend.log.writers.mail:

Writing to Email
================

``Zend\Log\Writer\Mail`` writes log entries in an email message by using ``Zend\Mail``. The
``Zend\Log\Writer\Mail`` constructor takes a ``Zend\Mail\Message`` object to compose the message, and an optional
``Zend\Mail\Transport`` object to send the email (the default transport is ``Zend\Mail\Transport\Sendmail``).

The primary use case for ``Zend\Log\Writer\Mail`` is notifying developers, systems administrators, or any concerned
parties of errors that might be occurring with *PHP*-based scripts. ``Zend\Log\Writer\Mail`` was born out of the
idea that if something is broken, a human being needs to be alerted of it immediately so they can take corrective
action.

Basic usage is outlined below:

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Message();
   $mail->setFrom('errors@example.org')
        ->addTo('project_developers@example.org');

   $writer = new Zend\Log\Writer\Mail($mail);

   // Set subject text for use; summary of number of errors is appended to the
   // subject line before sending the message.
   $writer->setSubjectPrependText('Errors with script foo.php');

   // Only email warning level entries and higher.
   $writer->addFilter(Zend\Log\Logger::WARN);

   $log = new Zend\Log\Logger();
   $log->addWriter($writer);

   // Something bad happened!
   $log->error('unable to connect to database');

   // On writer shutdown, send() is triggered to send an email with
   // all log entries at or above the Zend\Log\Logger filter level.

``Zend\Log\Writer\Mail`` will render the email body as plain text.

One email is sent containing all log entries at or above the filter level. For example, if warning-level entries an
up are to be emailed, and two warnings and five errors occur, the resulting email will contain a total of seven log
entries.


