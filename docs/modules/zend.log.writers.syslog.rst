.. _zend.log.writers.syslog:

Writing to the System Log
=========================

``Zend\Log\Writer\Syslog`` writes log entries to the system log (syslog). Internally, it proxies to *PHP*'s ``openlog()``, ``closelog()``, and ``syslog()`` functions.

One useful case for ``Zend\Log\Writer\Syslog`` is for aggregating logs from clustered machines via the system log functionality. Many systems allow remote logging of system events, which allows system administrators to monitor a cluster of machines from a single log file.

By default, all syslog messages generated are prefixed with the string "Zend_Log". You may specify a different "application" name by which to identify such log messages by either passing the application name to the constructor or the application accessor:

.. code-block:: php
   :linenos:

   // At instantiation, pass the "application" key in the options:
   $writer = new Zend\Log\Writer\Syslog(array('application' => 'FooBar'));

   // Any other time:
   $writer->setApplicationName('BarBaz');

The system log also allows you to identify the "facility," or application type, logging the message; many system loggers will actually generate different log files per facility, which again aids administrators monitoring server activity.

You may specify the log facility either in the constructor or via an accessor. It should be one of the ``openlog()`` constants defined on the `openlog() manual page`_.

.. code-block:: php
   :linenos:

   // At instantiation, pass the "facility" key in the options:
   $writer = new Zend\Log\Writer\Syslog(array('facility' => LOG_AUTH));

   // Any other time:
   $writer->setFacility(LOG_USER);

When logging, you may continue to use the default ``Zend\Log\Logger`` priority constants; internally, they are mapped to the appropriate ``syslog()`` priority constants.



.. _`openlog() manual page`: http://php.net/openlog
