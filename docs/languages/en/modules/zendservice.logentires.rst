.. _zendservice.logentries:

ZendService\\LogEntries
========================

.. _zendservice.logentries.introduction:

Introduction
------------

``ZendService\LogEntries`` is a writer for the `LogEntries <https://logentries.com/>`_ Service`.

The writer is based on the token socket writer: <https://logentries.com/doc/input-token/>

.. _zendservice.logentries.quickstart:

Quick Start
------------

In order to write to Log Entries, you will need you token created for the app.  Once you have your token, you can create 
the writer:

.. code-block:: php
   :linenos:   

   use Zend\Log\Logger;
   use ZendService\LogEntries\Writer\Token;
   
   $logger = new Logger();
   $writer = new Token('your-logentries-token');
   $logger->addWriter($writer);
   $logger->warn('Test');


The writer will open a persistent TCP connection.  When creating the writer, you can specifiy using TLS, psersistance or the timeout 
for the socket.

.. code-block:: php
   :linenos:   

   use Zend\Log\Logger;
   use ZendService\LogEntries\Writer\Token;
   
   $logger     = new Logger();
   $useTLS     = true;  // defaults to false
   $persistent = false; // defaults to true 
   $timeout    = 120;   // detaults to 60 seconds
   
   $writer     = new Token('your-logentries-token', $useTLS, $persistent, $timeout);
   $logger->addWriter($writer);
   $logger->warn('Test');
   
This writer does not allow setting log formatters 