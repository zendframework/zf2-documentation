.. _zend.log.writers.syslog:

In das Systemlog schreiben
==========================

``Zend_Log_Writer_Syslog`` schreibt Logeinträge in das Systemlog (syslog). Intern werden *PHP*'s ``openlog()``,
``closelog()``, und ``syslog()`` Funktionen aufgerufen.

Ein nützlicher Fall für ``Zend_Log_Writer_Syslog`` ist das zusammenführen von Logs von geclusterted Maschinen
über die Funktionalität vom Systemlog. Viele Systeme erlauben das entfernte Loggen von Systemevents, das es
Systemadministratoren erlaubt einen Cluster von Maschinen von einer einzelnen Logdatei aus zu monitoren.

Standardmäßig wird allen erzeugen Syslog Nachrichten der String "Zend_Log" vorangestellt. Man kann einen anderen
"application" Namen spezifizieren durch den solche Logmeldungen identifiziert werden können, entweder durch die
Angabe des Anwendungsnamens an den Constructor oder dem Accessor der Anwendung:

.. code-block:: php
   :linenos:

   // Bei der Instanziierung den "application" Schlüssel in den Optionen übergeben:
   $writer = new Zend_Log_Writer_Syslog(array('application' => 'FooBar'));

   // Zu jeder anderen Zeit:
   $writer->setApplicationName('BarBaz');

Das Systemlog erlaubt es auch die "facility", oder den Anwendungstyp zu identifizieren, der die Nachricht loggt;
viele Systemlogger erzeugen in Wirklichkeit unterschiedliche Logdateien pro Facility, welche wiederum die
Aktivitäten von Administratoren unterstützen die Server monitoren wollen.

Man kann die Log Facility entweder über den Constructor oder über einen Accessor spezifizieren. Das sollte eine
der ``openlog()`` Konstanten sein die in der `openlog() Dokumentations Seite`_ definiert sind.

.. code-block:: php
   :linenos:

   // Bei der Instanziierung den "facility" Schlüssel in den Optionen übergeben:
   $writer = new Zend_Log_Writer_Syslog(array('facility' => LOG_AUTH));

   // Zu jeder anderen Zeit:
   $writer->setFacility(LOG_USER);

Beim Loggen kann man weiterhin die standardmäßigen ``Zend_Log`` Prioritäts Konstanten verwenden; intern
entsprechen diese den Prioritäts Konstanten von ``syslog()``.



.. _`openlog() Dokumentations Seite`: http://php.net/openlog
