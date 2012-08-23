.. EN-Revision: none
.. _zend.service.windowsazure.storage.table:

Zend_Service_WindowsAzure_Storage_Table
=======================================

Der Table Service bietet einen strukturierten Speicher in der Form von Tabellen.

Tabellen Speicher wird von Windows Azure als REST *API* angeboten die von der Klasse
``Zend_Service_WindowsAzure_Storage_Table`` umhüllt ist um ein natives *PHP* Interface zum Speicher Konto zu
bieten.

Dieses Thema zeigt einige Beispiele der Verwendung der Klasse ``Zend_Service_WindowsAzure_Storage_Table``. Andere
Features sind im Download Paket enthalten sowie in den detailierten *API* Dokumentationen dieser Features.

Es ist zu beachten das bei der Entwicklung der Tabellen Speicher (in der *SDK* von Windows Azure) nicht alle
Features unterstützt welche von dieser *API* angeboten werden. Deshalb sind die Beispiele welche auf dieser Seite
aufgeführt sind, dazu gedacht auf Windows Azure Produktions Tabellen Speichern verwendet zu werden.

.. _zend.service.windowsazure.storage.table.api:

Operationen auf Tabellen
------------------------

Dieses Thema zeigt einige Beispiele für Operationen welche auf Tabellen ausgeführt werden können.

.. _zend.service.windowsazure.storage.table.api.create:

Erstellung einer Tabelle
^^^^^^^^^^^^^^^^^^^^^^^^

Bei Verwendung des folgenden Codes, kann eine Tabelle auf dem Windows Azure Produktions Tabellen Speicher erstellt
werden.

.. _zend.service.windowsazure.storage.table.api.create.example:

.. rubric:: Erstellen einer Tabelle

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );
   $result = $storageClient->createTable('testtable');

   echo 'Der neue Name der Tabelle ist: ' . $result->Name;

.. _zend.service.windowsazure.storage.table.api.list:

Ausgeben aller Tabellen
^^^^^^^^^^^^^^^^^^^^^^^

Bei Verwendung des folgendes Codes, kann eine Liste alle Tabellen im Windows Azure Produktions Tabellen Speicher
abgefragt werden.

.. _zend.service.windowsazure.storage.table.api.list.example:

.. rubric:: Ausgeben aller Tabellen

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );
   $result = $storageClient->listTables();
   foreach ($result as $table) {
       echo 'Der Name der Tabelle ist: ' . $table->Name . "\r\n";
   }

.. _zend.service.windowsazure.storage.table.entities:

Operationen auf Entitäten
-------------------------

Tabellen speichern Daten als Sammlung von Entitäten. Entitäten sind so ähnlich wie Zeilen. Eine Entität hat
einen primären Schlüssel und ein Set von Eigenschaften. Eine Eigenschaft ist ein benanntes, Typ-Werte Paar,
ähnlich einer Spalte.

Der Tabellen Service erzwingt kein Schema für Tabellen, deshalb können zwei Entitäten in der selben Tabelle
unterschiedliche Sets von Eigenschaften haben. Entwickler können auswählen das ein Schema auf Seite des Clients
erzwungen wird. Eine Tabelle kann eine beliebige Anzahl an Entitäten enthalten.

``Zend_Service_WindowsAzure_Storage_Table`` bietet 2 Wege um mit Entitäten zu arbeiten:

- Erzwungenes Schema

- Nicht erzwungenes Schema

Alle Beispiel verwenden die folgende erwzungene Schema Klasse.

.. _zend.service.windowsazure.storage.table.entities.schema:

.. rubric:: Erzwungenes Schema welches in Beispielen verwendet wird

.. code-block:: php
   :linenos:

   class SampleEntity extends Zend_Service_WindowsAzure_Storage_TableEntity
   {
       /**
       * @azure Name
       */
       public $Name;

       /**
       * @azure Age Edm.Int64
       */
       public $Age;

       /**
       * @azure Visible Edm.Boolean
       */
       public $Visible = false;
   }

Es ist zu beachten das ``Zend_Service_WindowsAzure_Storage_Table``, wenn keine Schema Klasse an die Tabellen
Speicher Methoden übergeben, automatisch mit ``Zend_Service_WindowsAzure_Storage_DynamicTableEntity`` arbeitet.

.. _zend.service.windowsazure.storage.table.entities.enforced:

Erzwungene Schema Entitäten
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um ein Schema auf der Seite des Clients bei Verwendung der Klasse ``Zend_Service_WindowsAzure_Storage_Table`` zu
erzwingen muss eine Klasse erstellt werden welche sich von ``Zend_Service_WindowsAzure_Storage_TableEntity``
ableitet. Diese Klasse bietet einige grundsätzliche Funktionalitäten damit die Klasse
``Zend_Service_WindowsAzure_Storage_Table`` mit einem client-seitigen Schema arbeitet.

Grundsätzliche Eigenschaften welche von ``Zend_Service_WindowsAzure_Storage_TableEntity`` angeboten werden sind:

- PartitionKey (durch ``getPartitionKey()`` und ``setPartitionKey()`` bekanntgemacht)

- RowKey (durch ``getRowKey()`` und ``setRowKey()`` bekanntgemacht)

- Timestamp (durch ``getTimestamp()`` und ``setTimestamp()`` bekantgemacht)

- Etag Wert (durch ``getEtag()`` und ``setEtag()`` bekanntgemacht)

Hier ist eine Beispielklasse welche sich von ``Zend_Service_WindowsAzure_Storage_TableEntity`` ableitet:

.. _zend.service.windowsazure.storage.table.entities.enforced.schema:

.. rubric:: Beispiel einer erzwungenen Schema Klasse

.. code-block:: php
   :linenos:

   class SampleEntity extends Zend_Service_WindowsAzure_Storage_TableEntity
   {
       /**
        * @azure Name
        */
       public $Name;

       /**
        * @azure Age Edm.Int64
        */
       public $Age;

       /**
        * @azure Visible Edm.Boolean
        */
       public $Visible = false;
   }

Die Klasse ``Zend_Service_WindowsAzure_Storage_Table`` mappt jede Klasse welche sich von
``Zend_Service_WindowsAzure_Storage_TableEntity`` ableitet auf Windows Azure Tabellen Speicher Entitäten mit dem
richtigen Datentyp und dem Namen der Eigenschaft. Alles dort dient dem Speichern einer Eigenschaft in Windows Azure
indem ein Docblock Kommentar zu einer öffentlichen Eigenschaft oder einem öffentlichen Getter oder Setter, im
folgenden Format hinzugefügt wird:

.. _zend.service.windowsazure.storage.table.entities.enforced.schema-property:

.. rubric:: Erzwungene Eigenschaft

.. code-block:: php
   :linenos:

   /**
    * @azure <Name der Eigenschaft in Windows Azure> <optionaler Typ der Eigenschaft>
    */
   public $<Name der Eigenschaft in PHP>;

Sehen wir uns an wie eine Eigenschaft "Ago" als Integerwert eines Windows Azure Tabellen Speichers definiert wird:

.. _zend.service.windowsazure.storage.table.entities.enforced.schema-property-sample:

.. rubric:: Beispiel einer erzwungenen Eigenschaft

.. code-block:: php
   :linenos:

   /**
    * @azure Age Edm.Int64
    */
   public $Age;

Es ist zu beachten das die Eigenschaft im Windows Azure Tabellen Speicher nicht notwendigerweise gleich benannt
werden muss. Der Name der Windows Azure Tabellen Speicher Eigenschaft kann genauso definiert werden wie der Typ.

Die folgenden Datentypen werden unterstützt:

- ``Edm.Binary``- Ein Array von Types welche bis zu 64 KB Größe.

- ``Edm.Boolean``- Ein boolscher Wert.

- ``Edm.DateTime``- Ein 64-bit Wert welcher als koordinierte universelle Zeit (UTC) ausgedrückt wird. Der
  unterstützte DateTime Bereich beginnt an 1. Jänner 1601 A.D. (C.E.), koordinierter Universeller Zeit (UTC). Der
  Bereich endet am 31. Dezember 9999.

- ``Edm.Double``- Eine 64-bit Gleitkommazahl.

- ``Edm.Guid``- Ein 128-bit großer globaler eindeutiger Identifikator.

- ``Edm.Int32``- Ein 32-bit Integerwert.

- ``Edm.Int64``- Ein 64-bit Integerwert.

- ``Edm.String``- Ein UTF-16-kodierter Wert. Stringwerte können bis zu 64 KB groß sein.

.. _zend.service.windowsazure.storage.table.entities.dynamic:

Entitäten ohne erzwungenes Schema (a.k.a. DynamicEntity)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um die Klasse ``Zend_Service_WindowsAzure_Storage_Table`` ohne Definition eines Schemas zu verwenden kann die
Klasse ``Zend_Service_WindowsAzure_Storage_DynamicTableEntity`` verwendet werden. Diese Klasse erweitert
``Zend_Service_WindowsAzure_Storage_TableEntity`` wie es eine Klasse für ein erzwungenes Schema machen würde,
enthält aber zusätzliche Logik um Sie dynamisch zu machen und nicht an ein Schema zu binden.

Die grundsätzlichen Eigenschaften welche von ``Zend_Service_WindowsAzure_Storage_DynamicTableEntity`` angeboten
werden sind:

- PartitionKey (durch ``getPartitionKey()`` und ``setPartitionKey()`` bekanntgemacht)

- RowKey (durch ``getRowKey()`` und ``setRowKey()`` bekanntgemacht)

- Timestamp (durch ``getTimestamp()`` und ``setTimestamp()`` bekanntgemacht)

- Etag Wert (durch ``getEtag()`` und ``setEtag()`` bekanntgemacht)

Andere Eigenschaften können on the Fly hinzugefügt werden. Ihre Windows Azure Tabellen Speicher Typen werden auch
on the Fly ermittelt:

.. _zend.service.windowsazure.storage.table.entities.dynamic.schema:

.. rubric:: Eigenschaften zu Zend_Service_WindowsAzure_Storage_DynamicTableEntity dynamisch hinzufügen

.. code-block:: php
   :linenos:

   $target = new Zend_Service_WindowsAzure_Storage_DynamicTableEntity(
       'partition1', '000001'
   );
   $target->Name = 'Name'; // Fügt die Eigenschaft "Name" vom Typ "Edm.String" hinzu
   $target->Age  = 25;     // Fügt die Eigenschaft "Age" vom Typ "Edm.Int32" hinzu

Optional kann der Typ einer Eigenschaft erzwungen werden:

.. _zend.service.windowsazure.storage.table.entities.dynamic.schema-forcedproperties:

.. rubric:: Erzwingen von Eigenschaftstypen auf Zend_Service_WindowsAzure_Storage_DynamicTableEntity

.. code-block:: php
   :linenos:

   $target = new Zend_Service_WindowsAzure_Storage_DynamicTableEntity(
       'partition1', '000001'
   );
   $target->Name = 'Name'; // Fügt die Eigenschaft "Name" vom Typ "Edm.String" hinzu
   $target->Age  = 25;     // Fügt die Eigenschaft "Age" vom Typ "Edm.Int32" hinzu

   // Ändert den Typ der Eigenschaft "Age" auf "Edm.Int32":
   $target->setAzurePropertyType('Age', 'Edm.Int64');

Die Klasse ``Zend_Service_WindowsAzure_Storage_Table`` arbeitet automatisch mit
``Zend_Service_WindowsAzure_Storage_TableEntity`` wenn an die Tabellen Speicher Methoden keine spezielle Klasse
übergeben wurde.

.. _zend.service.windowsazure.storage.table.entities.api:

API Beispiele für Entitäten
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.service.windowsazure.storage.table.entities.api.insert:

Eine Entität hinzufügen
^^^^^^^^^^^^^^^^^^^^^^^

Bei Verwendung des folgenden Codes kann eine Entität in eine Tabelle hinzugefügt werden welche "testtable"
heißt. Es ist zu beachten das die Tabelle vorher schon erstellt worden sein muss.

.. _zend.service.windowsazure.storage.table.api.entities.insert.example:

.. rubric:: Eine Entität einfügen

.. code-block:: php
   :linenos:

   $entity = new SampleEntity ('partition1', 'row1');
   $entity->FullName = "Maarten";
   $entity->Age = 25;
   $entity->Visible = true;

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );
   $result = $storageClient->insertEntity('testtable', $entity);

   // Prüfen des Zeitpunktes und von Etag der neu erstellten Entität
   echo 'Zeitpunkt: ' . $result->getTimestamp() . "\n";
   echo 'Etag: ' . $result->getEtag() . "\n";

.. _zend.service.windowsazure.storage.table.entities.api.retrieve-by-id:

Empfangen einer Entität durch Partitionsschlüssel und Zeilenschlüssel
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Durch Verwendung des folgenden Codes kann eine Entität durch seinen Partitions- und Zeilenschlüssel. Es ist zu
beachten das die Tabelle und die Entität bereits vorher erstellt worden sein müssen.

.. _zend.service.windowsazure.storage.table.entities.api.retrieve-by-id.example:

.. rubric:: Empfangen einer Entität durch dessen Partitions- und Zeilenschlüssel

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );
   $entity= $storageClient->retrieveEntityById(
       'testtable', 'partition1', 'row1', 'SampleEntity'
   );

.. _zend.service.windowsazure.storage.table.entities.api.updating:

Eine Entität aktualisieren
^^^^^^^^^^^^^^^^^^^^^^^^^^

Bei Verwendung des folgenden Codes kann eine Entität aktualisiert werden. Es ist zu beachten das die Tabelle und
die Entität hierfür bereits vorher erstellt worden sein muss.

.. _zend.service.windowsazure.storage.table.api.entities.updating.example:

.. rubric:: Aktualisieren einer Entität

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );
   $entity = $storageClient->retrieveEntityById(
       'testtable', 'partition1', 'row1', 'SampleEntity'
   );

   $entity->Name = 'Neuer Name';
   $result = $storageClient->updateEntity('testtable', $entity);

Wenn man sicherstellen will das die Entität vorher noch nicht aktualisiert wurde kann man prüfen ob das *Etag*
der Entität angehakt ist. Wenn die Entität bereits aktualisiert wurde, schlägt das Update fehl um
sicherzustellen das neuere Daten nicht überschrieben werden.

.. _zend.service.windowsazure.storage.table.entities.api.updating.example-etag:

.. rubric:: Aktualisieren einer Entität (mit Etag Prüfung)

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );
   $entity = $storageClient->retrieveEntityById(
       'testtable', 'partition1', 'row1', 'SampleEntity'
   );

   $entity->Name = 'Neuer Name';

   // Der letzte Parameter instruiert den Etag Check:
   $result = $storageClient->updateEntity('testtable', $entity, true);

.. _zend.service.windowsazure.storage.table.entities.api.delete:

Löschen einer Entität
^^^^^^^^^^^^^^^^^^^^^

Bei Verwendung des folgenden Codes kann eine Entität gelöscht werden. Es ist zu beachten das die Tabelle und die
Entität hierfür bereits erstellt worden sein müssen.

.. _zend.service.windowsazure.storage.table.entities.api.delete.example:

.. rubric:: Löschen einer Entität

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );
   $entity = $storageClient->retrieveEntityById(
       'testtable', 'partition1', 'row1', 'SampleEntity'
   );
   $result = $storageClient->deleteEntity('testtable', $entity);

.. _zend.service.windowsazure.storage.table.entities.querying:

Durchführen von Abfragen
^^^^^^^^^^^^^^^^^^^^^^^^

Abfragen im ``Zend_Service_WindowsAzure_Storage_Table`` Tabellen Speicher können auf zwei Wegen durchgeführt
werden:

- Durch manuelles Erstellen einer Filter Kondition (was das Lernen einer neuen Abfrage Sprache beinhaltet)

- Durch Verwendung des fluent Interfaces welches von ``Zend_Service_WindowsAzure_Storage_Table`` angeboten wird.

Bei Verwendung des folgenden Codes kann eine Tabelle abgefragt werden indem eine Filter Kondition verwendet wird.
Es ist zu beachten das die Tabelle und die Entitäten hierfür vorher bereits erstellt worden sein müssen.

.. _zend.service.windowsazure.storage.table.entities.querying.query-filter:

.. rubric:: Durchführen einer Abfrage bei Verwendung einer Filter Kondition

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );
   $entities = $storageClient->storageClient->retrieveEntities(
       'testtable',
       'Name eq \'Maarten\' and PartitionKey eq \'partition1\'',
       'SampleEntity'
   );

   foreach ($entities as $entity) {
       echo 'Name: ' . $entity->Name . "\n";
   }

Durch Verwendung des folgenden Codes kann eine tabelle abgefragt werden indem ein fluid Interface verwendet wird.
Es ist zu beachten das die Tabelle und die Entität hierfür bereits vorher erstellt worden sein müssen.

.. _zend.service.windowsazure.storage.table.api.entities.query-fluent:

.. rubric:: Durchführen einer Abfrage bei Verwendung eines Fluid Interfaces

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );
   $entities = $storageClient->storageClient->retrieveEntities(
       'testtable',
       $storageClient->select()
                     ->from($tableName)
                     ->where('Name eq ?', 'Maarten')
                     ->andWhere('PartitionKey eq ?', 'partition1'),
       'SampleEntity'
   );

   foreach ($entities as $entity) {
       echo 'Name: ' . $entity->Name . "\n";
   }

.. _zend.service.windowsazure.storage.table.entities.batch:

Batch Operationen
^^^^^^^^^^^^^^^^^

Dieser Abschnitt demonstriert wie die Tabellen Entitäts Gruppen Transaktions Features verwendet werden können
welche vom Windows Azure Tabellen Speicher angeboten werden. Der Windows Azure Tabellen Speicher unterstützt Batch
Transaktionen auf Entitäten welche in der gleichen Tabelle sind und der gleichen Partitionsgruppe angehören. Eine
Transaktion kann bis zu 100 Entitäten enthalten.

Das folgende Beispiel verwendet eine Batch Operation (Transaktion) um ein Set von Entitäten in die Tabelle
"testtable" einzufügen. Es ist zu beachten das die Tabelle hierfür bereits vorher erstellt worden sein muss.

.. _zend.service.windowsazure.storage.table.api.batch:

.. rubric:: Ausführen einer Batch Operation

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );

   // Batch starten
   $batch = $storageClient->startBatch();

   // Entitäten mit Batch einfügen
   $entities = generateEntities();
   foreach ($entities as $entity) {
       $storageClient->insertEntity($tableName, $entity);
   }

   // Übermitteln
   $batch->commit();

.. _zend.service.windowsazure.storage.table.sessionhandler:

Session Handler für Tabellen Speicher
-------------------------------------

Wenn eine *PHP* Anwendung auf der Windows Azure Plattform in einem Load-Balanced Modus läuft (wenn 2 oder mehr Web
Rollen Instanzen laufen), ist es wichtig dass *PHP* Session Daten zwischen mehreren Web Rollen Instanzen verwendet
werden können. Die Windows Azure *SDK* von *PHP* bietet die Klasse ``Zend_Service_WindowsAzure_SessionHandler`` an
welche den Windows Azure Tabellen Speicher als Session Handler für *PHP* Anwendungen verwendet.

Um den ``Zend_Service_WindowsAzure_SessionHandler`` Session Handler zu verwenden sollte er als Default Session
Handler für die *PHP* Anwendung registriert sein:

.. _zend.service.windowsazure.storage.table.api.sessionhandler-register:

.. rubric:: Registrierung des Tabellen Speicher Session Handlers

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );

   $sessionHandler = new Zend_Service_WindowsAzure_SessionHandler(
       $storageClient , 'sessionstable'
   );
   $sessionHandler->register();

Der obenstehende Klassenname registriert den ``Zend_Service_WindowsAzure_SessionHandler`` Session Handler und
speichert Sessions in einer Tabelle die "sessionstable" genannt wird.

Nach der Registrierung des ``Zend_Service_WindowsAzure_SessionHandler`` Session Handlers können Session gestartet
und auf dem gleichen Weg wie normale *PHP* Sessions verwendet werden:

.. _zend.service.windowsazure.storage.table.api.sessionhandler-usage:

.. rubric:: Verwendung des Tabellen Speicher Session Handlers

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );

   $sessionHandler = new Zend_Service_WindowsAzure_SessionHandler(
       $storageClient , 'sessionstable'
   );
   $sessionHandler->register();

   session_start();

   if (!isset($_SESSION['firstVisit'])) {
       $_SESSION['firstVisit'] = time();
   }

   // ...

.. warning::

   Der ``Zend_Service_WindowsAzure_SessionHandler`` Session Handler sollte registriert werden bevor ein Aufruf zu
   ``session_start()`` durchgeführt wird!


