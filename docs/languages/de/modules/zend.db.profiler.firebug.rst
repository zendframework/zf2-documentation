.. _zend.db.profiler.profilers.firebug:

Profilen mit Firebug
====================

``Zend_Db_Profiler_Firebug`` sendet Profilinginformationen an die `Firebug`_ `Console`_.

Alle Daten werden über die ``Zend_Wildfire_Channel_HttpHeaders`` Komponente gesendet welche *HTTP* Header
verwendet um sicherzustellen das der Seiteninhalt nicht gestört wird. Das Debuggen von *AJAX* Anfragen die klare
*JSON* und *XML* Antworten benötigen ist mit diesem Weg möglich.

Notwendigkeiten:

- Ein Firefox Browser idealerweise Version 3 aber auch Version 2 wird unterstützt.

- Die Firebug Firefox Erweiterung welche unter `https://addons.mozilla.org/en-US/firefox/addon/1843`_
  heruntergeladen werden kann.

- Die FirePHP Filefox Erweiterung welche unter `https://addons.mozilla.org/en-US/firefox/addon/6149`_
  heruntergeladen werden kann.

.. _zend.db.profiler.profilers.firebug.example.with_front_controller:

.. rubric:: DB Profiling mit Zend_Controller_Front

.. code-block:: php
   :linenos:

   // In der Bootstrap Datei

   $profiler = new Zend_Db_Profiler_Firebug('All DB Queries');
   $profiler->setEnabled(true);

   // Den Profiler an den DB Adapter anfügen
   $db->setProfiler($profiler);

   // Den Frontcontroller ausführen

   // Alle DB Abfragen im Modell, View und Controller Dateien
   // werden nun profiled und an Firebug gesendet

.. _zend.db.profiler.profilers.firebug.example.without_front_controller:

.. rubric:: DB Profiling ohne Zend_Controller_Front

.. code-block:: php
   :linenos:

   $profiler = new Zend_Db_Profiler_Firebug('All DB Queries');
   $profiler->setEnabled(true);

   // Den Profiler an den DB Adapter anfügen
   $db->setProfiler($profiler);

   $request  = new Zend_Controller_Request_Http();
   $response = new Zend_Controller_Response_Http();
   $channel  = Zend_Wildfire_Channel_HttpHeaders::getInstance();
   $channel->setRequest($request);
   $channel->setResponse($response);

   // Ausgabe buffering starten
   ob_start();

   // Jetzt können DB Abfragen durchgeführt werden die auch profiled werden

   // Die Profilingdaten an den Browser senden
   $channel->flush();
   $response->sendHeaders();



.. _`Firebug`: http://www.getfirebug.com/
.. _`Console`: http://getfirebug.com/logging.html
.. _`https://addons.mozilla.org/en-US/firefox/addon/1843`: https://addons.mozilla.org/en-US/firefox/addon/1843
.. _`https://addons.mozilla.org/en-US/firefox/addon/6149`: https://addons.mozilla.org/en-US/firefox/addon/6149
