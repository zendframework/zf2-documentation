.. _zend.log.filters:

Filters
=======

A Filter object blocks a message from being written to the log.

You can add a filter to a specific Writer using ``addFilter()`` method of that Writer:

.. code-block:: php
   :linenos:

   use Zend\Log\Logger;

   $logger = new Logger();

   $writer1 = new Zend\Log\Writer\Stream('/path/to/first/logfile');
   $logger->addWriter($writer1);

   $writer2 = new Zend\Log\Writer\Stream('/path/to/second/logfile');
   $logger->addWriter($writer2);

   // add a filter only to writer2
   $filter = new Zend\Log\Filter\Priority(Logger::CRIT);
   $writer2->addFilter($filter);

   // logged to writer1, blocked from writer2
   $logger->info('Informational message');

   // logged by both writers
   $logger->emerg('Emergency message');

.. _zend.log.filters.type:

Available filters
-----------------

The Zend\\Log\\Filter available are:

- **Priority**, filter logging by $priority. By default, it will accept any log event whose priority value is less
  than or equal to $priority.

- **Regex**, filter out any log messages not matching the regex pattern. This filter use the preg_match() function
  of PHP.

- **SuppressFilter**, this is a simple boolean filter. Call suppress(true) to suppress all log events. Call
  suppress(false) to accept all log events.

- **Validator**, filter out any log messages not matching the Zend\\Validator\\Validator object passed to the
  filter.


