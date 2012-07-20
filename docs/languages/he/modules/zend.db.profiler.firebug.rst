.. _zend.db.profiler.profilers.firebug:

פרופילינג בעזרת Firebug
=======================

*Zend_Db_Profiler_Firebug* שולח מידע פרופילינג ל `Firebug`_ `Console`_.

כל המידע נשלח באמצעות רכיב ה *Zend_Wildfire_Channel_HttpHeaders* אשר משתמש
בכותרי HTTP כדי לוודא שתוכן העמוד לא משובש. ניפוי בקשות AJAX אשר
דורשות תגובות XML ו JSON אפשרי בשיטה זו.

דרישות:

- דפדפן פיירפוקס גרסא 3 למרות שגרסא 2 גם נתמכת

- תוסף ה Firebug לפיירפוקס אשר ניתן להורדה דרך
  `https://addons.mozilla.org/en-US/firefox/addon/1843`_.

- תוסף ה FirePHP לפיירפוקס אשר ניתן להורדה דרך
  `https://addons.mozilla.org/en-US/firefox/addon/6149`_.

.. _zend.db.profiler.profilers.firebug.example.with_front_controller:

.. rubric:: פרופילינג מסד נתונים בעזרת *Zend_Controller_Front*

.. code-block::
   :linenos:

   // In your bootstrap file

   $profiler = new Zend_Db_Profiler_Firebug('All DB Queries');
   $profiler->setEnabled(true);

   // Attach the profiler to your db adapter
   $db->setProfiler($profiler)

   // Dispatch your front controller

   // All DB queries in your model, view and controller
   // files will now be profiled and sent to Firebug


.. _zend.db.profiler.profilers.firebug.example.without_front_controller:

.. rubric:: פרופילינג מסד נתונים ללא שימוש ב *Zend_Controller_Front*

.. code-block::
   :linenos:

   $profiler = new Zend_Db_Profiler_Firebug('All DB Queries');
   $profiler->setEnabled(true);

   // Attach the profiler to your db adapter
   $db->setProfiler($profiler)

   $request  = new Zend_Controller_Request_Http();
   $response = new Zend_Controller_Response_Http();
   $channel  = Zend_Wildfire_Channel_HttpHeaders::getInstance();
   $channel->setRequest($request);
   $channel->setResponse($response);

   // Start output buffering
   ob_start();

   // Now you can run your DB queries to be profiled

   // Flush profiling data to browser
   $channel->flush();
   $response->sendHeaders();




.. _`Firebug`: http://www.getfirebug.com/
.. _`Console`: http://getfirebug.com/logging.html
.. _`https://addons.mozilla.org/en-US/firefox/addon/1843`: https://addons.mozilla.org/en-US/firefox/addon/1843
.. _`https://addons.mozilla.org/en-US/firefox/addon/6149`: https://addons.mozilla.org/en-US/firefox/addon/6149
