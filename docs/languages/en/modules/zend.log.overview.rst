.. _zend.log.overview:

Overview of Zend\\Log
=====================

``Zend\Log\Logger`` is a component for general purpose logging. It supports multiple log backends, formatting
messages sent to the log, and filtering messages from being logged. These functions are divided into the following
objects:

- A Logger (instance of ``Zend\Log\Logger``) is the object that your application uses the most. You can have as
  many Logger objects as you like; they do not interact. A Logger object must contain at least one Writer, and can
  optionally contain one or more Filters.

- A Writer (inherits from ``Zend\Log\Writer\AbstractWriter``) is responsible for saving data to storage.

- A Filter (implements ``Zend\Log\Filter\FilterInterface``) blocks log data from being saved. A filter is applied to an  individual
  writer. Filters can be chained.

- A Formatter (implements ``Zend\Log\Formatter\FormatterInterface``) can format the log data before it is
  written by a Writer. Each Writer has exactly one Formatter.

.. _zend.log.overview.creating-a-logger:

Creating a Log
--------------

To get started logging, instantiate a Writer and then pass it to a Logger instance:

.. code-block:: php
   :linenos:

   $logger = new Zend\Log\Logger;
   $writer = new Zend\Log\Writer\Stream('php://output');

   $logger->addWriter($writer);

It is important to note that the Logger must have at least one Writer. You can add any number of Writers using the
Log's ``addWriter()`` method.

You can also add a priority to each writer. The priority is specified as number and passed as second argument in
the ``addWriter()`` method.

Another way to add a writer to a Logger is to use the name of the writer as follow:

.. code-block:: php
   :linenos:

   $logger = new Zend\Log\Logger;

   $logger->addWriter('stream', null, array('stream' => 'php://output'));

In this example we passed the stream ``php://output`` as parameter (as array).

.. _zend.log.overview.logging-messages:

Logging Messages
----------------

To log a message, call the ``log()`` method of a Log instance and pass it the message with a corresponding
priority:

.. code-block:: php
   :linenos:

   $logger->log(Zend\Log\Logger::INFO, 'Informational message');

The first parameter of the ``log()`` method is an integer ``priority`` and the second parameter is a string
``message``. The priority must be one of the priorities recognized by the Logger instance. This is explained in the
next section. There is also an optional third parameter used to pass extra informations to the writer's log.

A shortcut is also available. Instead of calling the ``log()`` method, you can call a method by the same name as
the priority:

.. code-block:: php
   :linenos:

   $logger->log(Zend\Log\Logger::INFO, 'Informational message');
   $logger->info('Informational message');

   $logger->log(Zend\Log\Logger::EMERG, 'Emergency message');
   $logger->emerg('Emergency message');

.. _zend.log.overview.destroying-a-logger:

Destroying a Log
----------------

If the Logger object is no longer needed, set the variable containing it to ``NULL`` to destroy it. This will
automatically call the ``shutdown()`` instance method of each attached Writer before the Log object is destroyed:

.. code-block:: php
   :linenos:

   $logger = null;

Explicitly destroying the log in this way is optional and is performed automatically at *PHP* shutdown.

.. _zend.log.overview.builtin-priorities:

Using Built-in Priorities
-------------------------

The ``Zend\Log\Logger`` class defines the following priorities:

.. code-block:: php
   :linenos:

   EMERG   = 0;  // Emergency: system is unusable
   ALERT   = 1;  // Alert: action must be taken immediately
   CRIT    = 2;  // Critical: critical conditions
   ERR     = 3;  // Error: error conditions
   WARN    = 4;  // Warning: warning conditions
   NOTICE  = 5;  // Notice: normal but significant condition
   INFO    = 6;  // Informational: informational messages
   DEBUG   = 7;  // Debug: debug messages

These priorities are always available, and a convenience method of the same name is available for each one.

The priorities are not arbitrary. They come from the BSD syslog protocol, which is described in `RFC-3164`_. The
names and corresponding priority numbers are also compatible with another *PHP* logging system, `PEAR Log`_, which
perhaps promotes interoperability between it and ``Zend\Log\Logger``.

Priority numbers descend in order of importance. ``EMERG`` (0) is the most important priority. ``DEBUG`` (7) is the
least important priority of the built-in priorities. You may define priorities of lower importance than ``DEBUG``.
When selecting the priority for your log message, be aware of this priority hierarchy and choose appropriately.

.. _zend.log.overview.understanding-fields:

Understanding Log Events
------------------------

When you call the ``log()`` method or one of its shortcuts, a log event is created. This is simply an associative
array with data describing the event that is passed to the writers. The following keys are always created in this
array: ``timestamp``, ``message``, ``priority``, and ``priorityName``.

The creation of the ``event`` array is completely transparent.

.. _zend.log.overview.as-errorHandler:

Log PHP Errors
--------------

``Zend\Log\Logger`` can also be used to log *PHP* errors and intercept Exceptions. Calling the static method
``registerErrorHandler($logger)`` will add the $logger object before the current PHP error handler, and will pass
the error along as well.

.. code-block:: php
   :linenos:

   $logger = new Zend\Log\Logger;
   $writer = new Zend\Log\Writer\Stream('php://output');

   $logger->addWriter($writer);

   Zend\Log\Logger::registerErrorHandler($logger);

If you want to unregister the error handler you can use the ``unregisterErrorHandler()`` static method.

.. _zend.log.overview.as-errorHandler.properties.table:

.. table:: Zend\\Log\\Logger events from PHP errors fields matching handler ( int $errno , string $errstr [, string $errfile [, int $errline [, array $errcontext ]]] ) from set_error_handler

   +-------+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Name   |Error Handler Parameter|Description                                                                                                                                                                                                                                                           |
   +=======+=======================+======================================================================================================================================================================================================================================================================+
   |message|errstr                 |Contains the error message, as a string.                                                                                                                                                                                                                              |
   +-------+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |errno  |errno                  |Contains the level of the error raised, as an integer.                                                                                                                                                                                                                |
   +-------+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |file   |errfile                |Contains the filename that the error was raised in, as a string.                                                                                                                                                                                                      |
   +-------+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |line   |errline                |Contains the line number the error was raised at, as an integer.                                                                                                                                                                                                      |
   +-------+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |context|errcontext             |(optional) An array that points to the active symbol table at the point the error occurred. In other words, errcontext will contain an array of every variable that existed in the scope the error was triggered in. User error handler must not modify error context.|
   +-------+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

You can also configure a Logger to intercept Exceptions using the static method
``registerExceptionHandler($logger)``.



.. _`RFC-3164`: http://tools.ietf.org/html/rfc3164
.. _`PEAR Log`: http://pear.php.net/package/log
