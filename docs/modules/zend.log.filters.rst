
.. _zend.log.filters:

Filters
=======

A Filter object blocks a message from being written to the log.


.. _zend.log.filters.all-writers:

Filtering for All Writers
-------------------------

To filter before all writers, you can add any number of Filters to a Logger object using the ``addFilter()`` method:

.. code-block:: php
   :linenos:

   use Zend\Log\Logger;

   $logger = new Logger();

   $writer = new Zend\Log\Writer\Stream('php://output');
   $logger->addWriter($writer);

   $filter = new Zend\Log\Filter\Priority(Logger::CRIT);
   $logger->addFilter($filter);

   // blocked
   $logger->info('Informational message');

   // logged
   $logger->emerg('Emergency message');

When you add one or more Filters to the Log object, the message must pass through all of the Filters before any Writers receives it.


.. _zend.log.filters.single-writer:

Filtering for a Writer Instance
-------------------------------

To filter only on a specific Writer instance, use the ``addFilter()`` method of that Writer:

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

- **Priority**, filter logging by $priority. By default, it will accept any log event whose priority value is less than or equal to $priority.

- **Regex**, filter out any log messages not matching the regex pattern. This filter use the preg_match() function of PHP.

- **SuppressFilter**, this is a simple boolean filter. Call suppress(true) to suppress all log events. Call suppress(false) to accept all log events.

- **Validator**, filter out any log messages not matching the Zend\\Validator\\Validator object passed to the filter.


