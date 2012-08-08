.. EN-Revision: none
.. _zend.log.filters:

סינון
=====

סינון רשומות אשר נשמרות בלוג.

.. _zend.log.filters.all-writers:

סינון כל הרשומות
----------------

כדי לסנן לפני כל הכותבים, ניתן להוסיף מספר אינסופי של סינונים
לאובייקט לוגינג על ידי שימוש במתודת ה *addFilter()*:

   .. code-block:: php
      :linenos:

      $logger = new Zend_Log();

      $writer = new Zend_Log_Writer_Stream('php://output');
      $logger->addWriter($writer);

      $filter = new Zend_Log_Filter_Priority(Zend_Log::CRIT);
      $logger->addFilter($filter);

      // blocked
      $logger->info('Informational message');

      // logged
      $logger->emerg('Emergency message');


כשמוסיפים סינון אחד או יותר לאובייקט הלוגינג, ההודעה צריכה
לעבור דרך כל הסינונים לפני שאחד הכותבים של הלוגינג מקבל אותו.

.. _zend.log.filters.single-writer:

סינון לאובייקט של כתיבה
-----------------------

כדי להוסיף סינון לאובייקט כתיבה ספציפי, השתמשו במתודת *addFilter*
לאותו אובייקט כתיבה:

   .. code-block:: php
      :linenos:

      $logger = new Zend_Log();

      $writer1 = new Zend_Log_Writer_Stream('/path/to/first/logfile');
      $logger->addWriter($writer1);

      $writer2 = new Zend_Log_Writer_Stream('/path/to/second/logfile');
      $logger->addWriter($writer2);

      // add a filter only to writer2
      $filter = new Zend_Log_Filter_Priority(Zend_Log::CRIT);
      $writer2->addFilter($filter);

      // logged to writer1, blocked from writer2
      $logger->info('Informational message');

      // logged by both writers
      $logger->emerg('Emergency message');





