.. _zend.db.profiler:

Zend_Db_Profiler
================

.. _zend.db.profiler.introduction:

Einführung
----------

``Zend_Db_Profiler`` kann aktiviert werden, um das Erstellen von Profilen für Abfragen zu erlauben. Die Profile
enthalten die Abfragen, die durch den Adapter verarbeitet worden sind, sowie die Laufzeit der Abfragen, um die
Kontrolle der verarbeiteten Abfragen zu ermöglichen, ohne das extra Code für das Debugging zu den Klassen
hinzugefügt werden muß. Die erweiterte Verwendung ermöglicht den Entwickler sogar zu filtern, welche Abfragen
aufgezeichnet werden sollen.

Der Profiler wird entweder durch die Übergabe eines Parameters an den Konstruktor des Adapters oder zu einem
späteren Zeitpunkt direkt an den Adapter aktiviert.

.. code-block:: php
   :linenos:

   $params = array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test',
       'profiler' => true  // aktiviere den Profiler; false, um ihn zu
                           // deaktivieren (standardmäßig deaktiviert)
   );

   $db = Zend_Db::factory('PDO_MYSQL', $params);

   // deaktiviere Profiler
   $db->getProfiler()->setEnabled(false);

   // aktiviere Profiler
   $db->getProfiler()->setEnabled(true);

Der Wert der ``profiler`` Option ist flexibel. Er wird unterschiedlich interpretiert, abhängig von seinem Typ.
Meistens sollte ein einfacher Boolscher Wert verwendet werden, aber andere Typen ermöglichen es das Verhalten des
Profilers anzupassen.

Ein boolsches Argument aktiviert den Profiler wenn es der Wert ``TRUE`` ist, oder schaltet ihn mit ``FALSE`` aus.
Die Profiler Klasse ist die Standard Profiler Klasse des Adapters ``Zend_Db_Profiler``.

.. code-block:: php
   :linenos:

   $params['profiler'] = true;
   $db = Zend_Db::factory('PDO_MYSQL', $params);

Eine Instanz eines Profiler Objektes führt dazu das der Adapter dieses Objekt verwendet. Der Typ des Objektes muß
hierfür ``Zend_Db_Profiler`` oder eine Subklasse sein. Der Profiler muß separat eingeschaltet werden.

.. code-block:: php
   :linenos:

   $profiler = MyProject_Db_Profiler();
   $profiler->setEnabled(true);
   $params['profiler'] = $profiler;
   $db = Zend_Db::factory('PDO_MYSQL', $params);

Ein Argument kann ein assoziatives Array sein das eines oder alle der folgenden Schlüssel enthält: '``enabled``',
'``instance``', oder '``class``'. Die Schlüssel '``enabled``' und '``instance``' korrespondieren zu den zuvor
dokumentierten boolschen und Instanz Typen. Der '``class``' Schlüssel wird verwendet um die Klasse die für einen
eigenen Profiler verwendet werden soll, zu benennen. Die Klasse muß ``Zend_Db_Profiler`` oder eine Subklasse sein.
Die Klasse wird ohne Konstruktor Argumente instanziert. Die '``class``' Option wird ignoriert wenn die
'``instance``' Option angegeben wurde.

.. code-block:: php
   :linenos:

   $params['profiler'] = array(
       'enabled' => true,
       'class'   => 'MyProject_Db_Profiler'
   );
   $db = Zend_Db::factory('PDO_MYSQL', $params);

Letztendlich kann das Argument ein Objekt des Typs ``Zend_Config`` sein das Eigenschaften enthält welche als Array
Schlüssel verwendet werden wie anbei beschrieben. Zum Beispiel könnte die Datei "``config.ini``" die folgenden
Daten enthalten:

.. code-block:: php
   :linenos:

   [main]
   db.profiler.class   = "MyProject_Db_Profiler"
   db.profiler.enabled = true

Diese Konfiguration kann durch den folgenden *PHP* Code angesprochen werden:

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Ini('config.ini', 'main');
   $params['profiler'] = $config->db->profiler;
   $db = Zend_Db::factory('PDO_MYSQL', $params);

Die Eigenschaft '``instance``' kann wie folgt verwendet werden:

.. code-block:: php
   :linenos:

   $profiler = new MyProject_Db_Profiler();
   $profiler->setEnabled(true);
   $configData = array(
       'instance' => $profiler
       );
   $config = new Zend_Config($configData);
   $params['profiler'] = $config;
   $db = Zend_Db::factory('PDO_MYSQL', $params);

.. _zend.db.profiler.using:

Den Profiler verwenden
----------------------

Der Profiler kann jederzeit über die Adapter Methode ``getProfiler()`` geholt werden:

.. code-block:: php
   :linenos:

   $profiler = $db->getProfiler();

Dies gibt eine ``Zend_Db_Profiler`` Objektinstanz zurück. Mit dieser Instanz kann der Entwickler seine Abfragen
mit Hilfe von verschiedenen Methoden untersuchen:

- ``getTotalNumQueries()`` gibt die Gesamtzeit aller aufgezeichneten Abfragen zurück.

- ``getTotalElapsedSecs()`` gibt die gesamte Anzahl an Sekunden für alle aufgezeichneten Abfragen zurück.

- ``getQueryProfiles()`` gibt ein Array mit allen aufgezeichneten Abfragen zurück.

- ``getLastQueryProfile()`` gibt das Profil der letzten (neuesten) Abfrage zurück, gleichgültig ob die Abfrage
  beendet werden konnte oder nicht (wenn nicht, wird die Endzeit ``NULL`` sein)

- ``clear()`` löscht jedes vorherige Abfrageprofile vom Stapel.

Der Rückgabewert von ``getLastQueryProfile()`` und die einzelnen Elemente von ``getQueryProfiles()`` sind
``Zend_Db_Profiler_Query`` Objekte, welche die Möglichkeit bieten, die individuellen Abfragen zu untersuchen:

- ``getQuery()`` gibt den *SQL* Text der Abfrage zurück. Der *SQL* Text des vorbereiteten Statements mit
  Parametern ist der Text, zu der Zeit als die Abfrage vorbereitet wurde, er enthält also Platzhalter für
  Parameter, nicht die Werte die verwendet werden wenn das Statement ausgeführt wird.

- ``getQueryParams()`` gibt ein Array von Parameter Werten zurück die verwendet werden wenn eine vorbereitete
  Abfrage ausgeführt wird. Das beinhaltet beide, gebundene Parameter und Argumente für die ``execute()`` Methode
  des Statements. Die Schlüssel des Arrays sind die Positionierten (1-basierend) oder benannten (Zeichenkette)
  Parameter Indezes.

- ``getElapsedSecs()`` gibt die Anzahl der Sekunden zurück, wie lange die Abfrage gelaufen ist.

Die Informationen, die ``Zend_Db_Profiler`` bereitstellt, sind nützlich, um Engpässe in der Anwendung zu
ermitteln und um Abfragen zu überprüfen, die durchgeführt worden sind. Um zum Beispiel die genaue Abfrage zu
sehen, die zuletzt durchgeführt worden ist:

.. code-block:: php
   :linenos:

   $query = $profiler->getLastQueryProfile();

   echo $query->getQuery();

Vielleicht wird eine Seite langsam erstellt; verwende den Profiler, um zuerst die gesamte Laufzeit aller Abfragen
zu ermitteln und dann durchlaufe die Abfragen, um die am längsten laufende zu finden:

.. code-block:: php
   :linenos:

   $totalTime    = $profiler->getTotalElapsedSecs();
   $queryCount   = $profiler->getTotalNumQueries();
   $longestTime  = 0;
   $longestQuery = null;

   foreach ($profiler->getQueryProfiles() as $query) {
       if ($query->getElapsedSecs() > $longestTime) {
           $longestTime  = $query->getElapsedSecs();
           $longestQuery = $query->getQuery();
       }
   }

   echo 'Executed ' . $queryCount . ' queries in ' . $totalTime .
        ' seconds' . "\n";
   echo 'Average query length: ' . $totalTime / $queryCount .
        ' seconds' . "\n";
   echo 'Queries per second: ' . $queryCount / $totalTime . "\n";
   echo 'Longest query length: ' . $longestTime . "\n";
   echo "Longest query: \n" . $longestQuery . "\n";

.. _zend.db.profiler.advanced:

Fortgeschrittene Profiler Verwendung
------------------------------------

Zusätzlich zum Untersuchen von Anfragen erlaubt der Profiler dem Entwickler auch zu filtern, welche Abfragen
aufgezeichnet werden sollen. Die folgenden Methoden arbeiten mit einer ``Zend_Db_Profiler`` Instanz:

.. _zend.db.profiler.advanced.filtertime:

Filtern anhand der Laufzeit der Abfragen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``setFilterElapsedSecs()`` ermöglicht dem Entwickler, eine minimale Laufzeit anzugeben, bevor eine Abfrage
aufzeichnet werden soll. Um den Filter zu entfernen, muss nur der Wert ``NULL`` an die Methode übergeben werden.

.. code-block:: php
   :linenos:

   // Zeichne nur Abfragen auf, die mindestens 5 Sekunden laufen:
   $profiler->setFilterElapsedSecs(5);

   // Zeichne alle Abfragen unabhängig von deren Laufzeit auf:
   $profiler->setFilterElapsedSecs(null);

.. _zend.db.profiler.advanced.filtertype:

Filtern anhand des Abfragetyp
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``setFilterQueryType()`` ermöglicht dem Entwickler anzugeben, welche Abfragetypen aufgezeichnet werden sollen; um
mehrere Typen aufzuzeichnen, verwende das logische OR. Abfragetypen sind mit den folgenden ``Zend_Db_Profiler``
Konstanten definiert:

- ``Zend_Db_Profiler::CONNECT``: Verbindungsoperationen oder Auswahl einer Datenbank .

- ``Zend_Db_Profiler::QUERY``: allgemeine Datenbankabfragen, die keinem der anderen Typen entsprechen.

- ``Zend_Db_Profiler::INSERT``: jede Abfrage, die neue Daten zur Datenbank hinzufügt, normalerweise ein *SQL*
  *INSERT*.

- ``Zend_Db_Profiler::UPDATE``: jede Abfrage, die vorhandene Daten aktualisiert, normalerweise ein *SQL* *UPDATE*.

- ``Zend_Db_Profiler::DELETE``: jede Abfrage, die vorhandene Daten löscht, normalerweise ein *SQL* ``DELETE``.

- ``Zend_Db_Profiler::SELECT``: jede Abfrage, die vorhandene Daten selektiert, normalerweise ein *SQL* *SELECT*.

- ``Zend_Db_Profiler::TRANSACTION``: jede Transaktionsoperation, wie zum Beispiel START TRANSACTION, COMMIT oder
  ROLLBACK.

Mit ``setFilterElapsedSecs()`` kannst du jeden vorhandenen Filtern entfernen, indem du ``NULL`` als einziges
Argument übergibst.

.. code-block:: php
   :linenos:

   // zeichne nur SELECT Abfragen auf
   $profiler->setFilterQueryType(Zend_Db_Profiler::SELECT);

   // zeichne SELECT, INSERT und UPDATE Abfragen auf
   $profiler->setFilterQueryType(Zend_Db_Profiler::SELECT |
                                 Zend_Db_Profiler::INSERT |
                                 Zend_Db_Profiler::UPDATE);

   // zeichne DELETE Abfragen auf
   $profiler->setFilterQueryType(Zend_Db_Profiler::DELETE);

   // Remove all filters
   $profiler->setFilterQueryType(null);

.. _zend.db.profiler.advanced.getbytype:

Hole Profil nach Abfragetyp zurück
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die Verwendung von ``setFilterQueryType()`` kann die Anzahl der aufgezeichneten Abfragen reduzieren. Allerdings
kann es sinnvoller sein, alle Abfragen auzuzeichnen, baer nur diese anzuschauen, die im Moment gebraucht werden.
Ein weiteres Feature von ``getQueryProfiles()`` ist das Filtern der Abfragen "on-the-fly" durch Übergabe eines
Abfragetyps (oder eine logischen Kombination von Abfragetypen) als erstes Argument; beachte :ref:`dieses Kapitel
<zend.db.profiler.advanced.filtertype>` für eine Liste der Konstanten für Abfragetypen.

.. code-block:: php
   :linenos:

   // Hole nur SELECT Abfragen zurück
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::SELECT);

   // Hole nur SELECT, INSERT un UPDATE Abfragen zurück
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::SELECT |
                                           Zend_Db_Profiler::INSERT |
                                           Zend_Db_Profiler::UPDATE);

   // Hole DELETE Abfragen zurück
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::DELETE);

.. _zend.db.profiler.profilers:

Specialized Profilers
---------------------

Ein spezialisierter Profiler ist ein Objekt das von ``Zend_Db_Profiler`` abgeleitet ist. Spezialisierte Profiler
behandeln die Profilinginformationen auf speziellen Wegen.

.. include:: zend.db.profiler.firebug.rst

