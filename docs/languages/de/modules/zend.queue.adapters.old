.. _zend.queue.adapters:

Adapter
=======

``Zend_Queue`` unterstützt alle Queues die das Interface ``Zend_Queue_Adapter_AdapterInterface`` implementieren.
Die folgenden Nachrichten Queue Services werden unterstützt:

- `Apache ActiveMQ`_.

- Eine Datenbank verwendende Queue über ``Zend_Db``.

- Eine `MemcacheQ`_ verwendende Queue über ``Memcache``.

- Die Job Queue von `Zend Platform's`_.

- Ein lokales Array. Nützlich für Unit Tests.

.. note::

   **Einschränkungen**

   Das Transaction Handling für Nachrichten wird nicht unterstützt.

.. _zend.queue.adapters.configuration:

Spezielle Adapter - Konfigurations Optionen
-------------------------------------------

Wenn eine Standardeinstellung angezeigt wird, dann ist der Parameter optional. Wenn keine Standardeinstellung
spezifiziert ist dann wird der Parameter benötigt.

.. _zend.queue.adapters.configuration.apachemq:

Apache ActiveMQ - Zend_Queue_Adapter_Activemq
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Hier aufgeführte Optionen sind bekannte Notwendigkeiten. Nicht alle Nachrichten Server benötigen username oder
password.

- **$options['name'] = '/temp/queue1';**

  Das ist der Name der Queue die man anfangen will zu verwenden. (Benötigt)

- **$options['driverOptions']['host'] = 'host.domain.tld';**

  **$options['driverOptions']['host'] = '127.0.0.1';**

  Man kann host auf eine IP Adresse oder einen Hostnamen setzen.

  Der Standardwert für host ist '127.0.0.1'.

- **$options['driverOptions']['port'] = 61613;**

  Die Standardeinstellung für port ist 61613.

- **$options['driverOptions']['username'] = 'username';**

  Optional für einige Nachrichten Server. Lesen Sie das Handbuch für Ihren Nachrichten Server.

- **$options['driverOptions']['password'] = 'password';**

  Optional für einige Nachrichten Server. Lesen Sie das Handbuch für Ihren Nachrichten Server.

- **$options['driverOptions']['timeout_sec'] = 2;**

  **$options['driverOptions']['timeout_usec'] = 0;**

  Das ist die Menge an Zeit die ``Zend_Queue_Adapter_Activemq`` für einen Lesezugriff auf einem Socket wartet
  bevor keine Nachricht zurückgegeben wird.

.. _zend.queue.adapters.configuration.Db:

Db - Zend_Queue_Adapter_Db
^^^^^^^^^^^^^^^^^^^^^^^^^^

Optionen des Treibers werden für wenige benötigte Optionen geprüft so wie **type**, **host**, **username**,
**password** und **dbname**. Man kann zusätzliche Parameter für ``Zend_DB::factory()`` als Paramerter in
``$options['driverOptions']`` übergeben. Ein Beispiel für eine zusätzliche Option die hier nicht aufgeführt
ist, aber übergeben werden könnte ist **port**.

.. code-block:: php
   :linenos:

   $options = array(
       'driverOptions' => array(
           'host'      => 'db1.domain.tld',
           'username'  => 'my_username',
           'password'  => 'my_password',
           'dbname'    => 'messaging',
           'type'      => 'pdo_mysql',
           'port'      => 3306, // Optionaler Parameter
       ),
       'options' => array(
           // Verwenden von Zend_Db_Select für das Update, nicht alle Datenbanken
           // unterstützen dieses Feature.
           Zend_Db_Select::FOR_UPDATE => true
       )
   );

   // Eine Datenbank Queue erstellen.
   $queue = new Zend_Queue('Db', $options);



- **$options['name'] = 'queue1';**

  Das ist der Name der Queue die man anfangen will zu verwenden. (Benötigt)

- **$options['driverOptions']['type'] = 'Pdo';**

  **type** ist der Adapter von dem man will das Ihn ``Zend_Db::factory()`` verwendet. Das ist der erste Parameter
  für den Aufruf der Klassenmethode ``Zend_Db::factory()``

- **$options['driverOptions']['host'] = 'host.domain.tld';**

  **$options['driverOptions']['host'] = '127.0.0.1';**

  Man kann host auf eine IP Adresse oder einen Hostnamen setzen.

  Der Standardwert für host ist '127.0.0.1'.

- **$options['driverOptions']['username'] = 'username';**

- **$options['driverOptions']['password'] = 'password';**

- **$options['driverOptions']['dbname'] = 'dbname';**

  Der Name der Datenbank für die man die benötigten Tabellen erstellt hat. Siehe das unten stehende Notizen
  Kapitel.

.. _zend.queue.adapters.configuration.memcacheq:

MemcacheQ - Zend_Queue_Adapter_Memcacheq
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **$options['name'] = 'queue1';**

  Das ist der Name der Queue die man anfangen will zu verwenden. (Benötigt)

- **$options['driverOptions']['host'] = 'host.domain.tld';**

  **$options['driverOptions']['host'] = '127.0.0.1;'**

  Man kann host auf eine IP Adresse oder einen Hostnamen setzen.

  Der Standardwert für host ist '127.0.0.1'.

- **$options['driverOptions']['port'] = 22201;**

  Die Standardeinstellung für port ist 22201.

.. _zend.queue.adapters.configuration.platformjq:

Zend Platform Job Queue - Zend_Queue_Adapter_PlatformJobQueue
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **$options['daemonOptions']['host'] = '127.0.0.1:10003';**

  Hostname und Port die mit dem Daemon der Zend Platform Job Queue korrespondieren, die man verwenden will.
  (Benötigt)

- **$options['daemonOptions']['password'] = '1234';**

  Das Passwort welches für den Zugriff auf den Daemon der Zend Platform Job Queue benötigt wird. (Benötigt)

.. _zend.queue.adapters.configuration.array:

Array - Zend_Queue_Adapter_Array
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **$options['name'] = 'queue1';**

  Das ist der Name der Queue die man anfangen will zu verwenden. (Benötigt)

.. _zend.queue.adapters.notes:

Hinweise für spezielle Adapter
------------------------------

Die folgenden Adapter haben Hinweise:

.. _zend.queue.adapters.notes.activemq:

Apache ActiveMQ
^^^^^^^^^^^^^^^

Die Dauer der Sichtbarkeit (visibility duration) ist für ``Zend_Queue_Adapter_Activemq`` nicht vorhanden.

Wärend Apache's ActiveMQ mehrere Einschreibungen unterstützt, wird das von ``Zend_Queue`` nicht unterstützt. Man
muss ein neues ``Zend_Queue`` Objekt für jede individuelle Einschreibung erstellen.

ActiveMQ Queue oder Topic Namen müssen mit einem der folgenden beginnen:

- ``/queue/``

- ``/topic/``

- ``/temp-queue/``

- ``/temp-topic/``

Zum Beispiel: ``/queue/testing``

Die folgenden Funktionen werden nicht unterstützt:

- ``create()``- Erstellt eine Queue. Der Aufruf dieser Funktion wird eine Exception werfen.

- ``delete()``- Löscht eine Queue. Der Aufruf dieser Funktion wird eine Exception werfen.

- ``getQueues()``- Auflisten von Queues. Der Aufruf dieser Funktion wird eine Exception werden.

.. _zend.queue.adapters.notes.zend_db:

Zend_Db
^^^^^^^

Das Datenbank *SQL* Statement **CREATE TABLE ( ... )** kann in ``Zend/Queue/Adapter/Db/mysql.sql`` gefunden werden.

.. _zend.queue.adapters.notes.memcacheQ:

MemcacheQ
^^^^^^^^^

Memcache kann von `http://www.danga.com/memcached/`_ heruntergeladen werden.

MemcacheQ kann von `http://memcachedb.org/memcacheq/`_ heruntergeladen werden.

- ``deleteMessage()``- Nachrichten werden von der Queue gelöscht nachdem Sie von der Queue empfangen werden. Der
  Aufruf dieser Funktion hätte keinen Effekt. Der Aufruf dieser Funktion wird keinen Fehler werfen.

- ``count()`` oder ``count($adapter)``- MemcacheQ unterstützt keine Methode für das Zählen der Anzahl an
  Elementen in einer Queue. Der Aufruf dieser Funktion wird keinen Fehler werfen.

.. _zend.queue.adapters.notes.platformjq:

Zend Platform Job Queue
^^^^^^^^^^^^^^^^^^^^^^^

Job Queue ist ein Feature das von Zend Platform's Enterprise Solution angeboten wird. Es ist keine traditionelle
Nachrichten Queue, sondern erlaubt es ein Skript zu queuen um es auszuführen, zusammen mit den Parametern die man
an dieses übergeben will. Man kann mehr über die Job Queue `auf der Webseite von zend.com`_ herausfinden.

Nachfolgend ist eine Liste von Methoden bei denen sich das Verhalten dieses Adapters vom Standardverhalten
unterscheidet:

- ``create()``- Zend Platform hat kein Konzept von diskreten Queues; stattdessen erlaubt es Administratoren Skripte
  für die Bearbeitung der Queue anzugeben. Da das hinzufügen von neuen Skripten auf das Administrations Interface
  begrenzt ist, wirft diese Methode einfach eine Exception um anzuzeigen das diese Aktion verboten ist.

- ``isExists()``- Genauso wie ``create()``, und da die Job Queue keine Notation für benannte Queues hat wirft
  diese Methode eine Exception wenn Sie aufgerufen wird.

- ``delete()``- Ähnlich wie ``create()``, ist das Löschen von JQ Skripten nicht möglich, ausser über das Admin
  Interface; diese Methode wirft eine Exception.

- ``getQueues()``- Zend Platform erlaubt es nicht über die *API* die angehängten Job Handling Skripte einzusehen.
  Diese Methode wirft eine Exception.

- ``count()``- Gibt die totale Anzahl an Jobs zurück die aktuell in der Job Queue aktiv sind.

- ``send()``- Diese Methode ist möglicherweise die eine Methode welche sich am meisten von den anderen Adaptern
  unterscheidet. Das ``$message`` Argument kann eine von drei möglichen Typen sein und arbeitet unterschiedlich,
  basierend auf dem übergebenen Wert:

  - *string*- Der Name eines betroffenen Skripts das in der Job Queue registriert ist. Wenn es auf diesem Weg
    übergeben wird, werden keine Argumente an das Skript übergeben.

  - *array*- Ein Array von Werte mit denen ein ``ZendApi_Job`` Objekt konfiguriert werden soll. Dieses kann
    folgendes enthalten:

    - ``script``- Den Namen des betroffenen Job Queue Skripts. (Benötigt)

    - ``priority``- Die Priorität des Jobs die verwendet werden soll wenn er in der Queue registriert wird.

    - ``name``- Ein kurzer String der den Job beschreibt.

    - ``predecessor``- Die ID eines Jobs von der dieser abhängt, und welches aufgeführt werden muß bevor dieses
      anfangen kann.

    - ``preserved``- Ob der Job in der History der Job Queue behalten werden soll. Standardmäßig aus; wenn ein
      ``TRUE`` Wert übergeben wird, dann wird er behalten.

    - ``user_variables``- Ein Assoziatives Array aller Variablen die man wärend der Ausführung des Jobs im
      Geltungsbereich haben will (ähnlich benannten Argumenten).

    - ``interval``- Wie oft, in Sekunden, der Job ausgeführt werden soll. Standardmäßig ist das auf 0 gesetzt,
      was anzeigt das er einmal, und nur einmal ausgeführt werden soll.

    - ``end_time``- Eine abgelaufene Zeit, nach welcher der Job nicht ausgeführt werden soll. Wenn der Job so
      gesetzt wurde das er nur einmal ausgeführt wird, und ``end_time`` übergeben wurde, dann wird der Job nicht
      ausgeführt. Wenn der Job so gesetzt wurde das er in einem Intervall ausgeführt wird, das wird er nicht mehr
      ausgeführt bis ``end_time`` abgelaufen ist.

    - ``schedule_time``- Ein *UNIX* Zeitstempel der anzeigt wann der Job ausgeführt werden soll; standardmäßig
      0, was anzeigt das der Job so früh wie möglich ausgeführt werden soll.

    - ``application_id``- Der Identifikator der Anwendung für den Job. Standardmäßig ist er ``NULL``, was
      anzeigt das automatisch einer von der Queue zugeordnet wird, wenn die Queue einer Anwendungs ID zugeordnet
      wird.

    Wie erwähnt, wird nur das ``script`` Argument benötigt; alle anderen anderen nur nur einfach vorhanden um es
    zu erlauben feinkörnigere Details darüber zu übergeben, wie und wann ein Job ausgeführt werden soll.

  - ``ZendApi_Job``- Letztendlich kann einfach eine Instanz von ``ZendApi_Job`` übergeben werden und Sie wird zur
    Job Queue der Plattform übergeben.

  In allen Instanzen gibt ``send()`` ein ``Zend_Queue_Message_PlatformJob`` Objekt zurück, welches Zugriff zum
  ``ZendApi_Job`` Objekt gibt und verwendet wird um mit der Job Queue zu kommunizieren.

- ``receive()``- Empfängt eine Liste von aktiven Jobs von der Job Queue. Jeder Job im zurückgegebenen Set ist
  eine Instanz von ``Zend_Queue_Message_PlatformJob``.

- ``deleteMessage()``- Da dieser Adapter nur mit der Job Queue arbeitet, erwartet diese Methode das die übergebene
  ``$message`` eine Instanz von ``Zend_Queue_Message_PlatformJob`` ist, und wirft andernfalls eine Exception.

.. _zend.queue.adapters.notes.array:

Array (Lokal)
^^^^^^^^^^^^^

Die Array Queue ist ein *PHP* ``array()`` im lokalen Speicher. ``Zend_Queue_Adapter_Array`` ist gut für das Unit
Testen.



.. _`Apache ActiveMQ`: http://activemq.apache.org/
.. _`MemcacheQ`: http://memcachedb.org/memcacheq/
.. _`Zend Platform's`: http://www.zend.com/en/products/platform/
.. _`http://www.danga.com/memcached/`: http://www.danga.com/memcached/
.. _`http://memcachedb.org/memcacheq/`: http://memcachedb.org/memcacheq/
.. _`auf der Webseite von zend.com`: http://www.zend.com/en/products/platform/
