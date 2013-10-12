.. EN-Revision: none
.. _zendservice.windowsazure.storage.blob:

ZendService\WindowsAzure\Storage\Blob
======================================

Blob Speicher speichert ein Set von Binären Daten. Blog Speicher bietet die folgenden drei Ressourcen an: den
Speicher Account, Container und Blobs. Im eigenen Speicher Account bieten Container einen Weg um Sets von Blobs im
Speicher Account zu organisieren.

Blog Speicher wird von Windows Azure als *REST* *API* angeboten welcher von der Klasse
``ZendService\WindowsAzure\Storage\Blob`` umhüllt ist um ein natives *PHP* Interface zum Speicher Account zu
bieten.

.. _zendservice.windowsazure.storage.blob.api:

API Beispiele
-------------

Dieser Abschnitt zeigt einige Beispiele der Verwendung der Klasse ``ZendService\WindowsAzure\Storage\Blob``.
Andere Features sind im Download Paket vorhanden sowie in der detailierten *API* Dokumentation dieser Features.

.. _zendservice.windowsazure.storage.blob.api.create-container:

Erstellung einer Speicher Containers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Bei Verwendung des folgenden Codes kann ein Speicher Container auf dem Development Speicher erstellt werden.

.. _zendservice.windowsazure.storage.blob.api.create-container.example:

.. rubric:: Erstellung eines Speicher Containers

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Blob();
   $result = $storageClient->createContainer('testcontainer');

   echo 'Der Name des Containers ist: ' . $result->Name;

.. _zendservice.windowsazure.storage.blob.api.delete-container:

Löschen eines Speicher Containers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Bei Verwendung des folgenden Codes kann ein Blob Speicher Container vom Development Speicher entfernt werden.

.. _zendservice.windowsazure.storage.blob.api.delete-container.example:

.. rubric:: Löschen eines Speicher Containers

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Blob();
   $storageClient->deleteContainer('testcontainer');

.. _zendservice.windowsazure.storage.blob.api.storing-blob:

Speichern eines Blobs
^^^^^^^^^^^^^^^^^^^^^

Bei Verwendung des folgenden Codes kann ein Blob zu einem Blog Speicher Container auf dem Development Speichers
hochgeladen werden. Es ist zu beachten das der Container hierfür bereits vorher erstellt worden sein muss.

.. _zendservice.windowsazure.storage.blob.api.storing-blob.example:

.. rubric:: Speichern eines Blobs

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Blob();

   // /home/maarten/example.txt auf Azure hochladen
   $result = $storageClient->putBlob(
       'testcontainer', 'example.txt', '/home/maarten/example.txt'
   );

   echo 'Der Name des Blobs ist: ' . $result->Name;

.. _zendservice.windowsazure.storage.blob.api.copy-blob:

Kopieren eines Blobs
^^^^^^^^^^^^^^^^^^^^

Bei Verwendung des folgenden Codes kann ein Blob von innerhalb des Speicher Accounts kopiert werden. Der Vorteil
der Verwendung dieser Methode besteht darin das die Kopieroperation in der Azure Wolke stattfindet und kein
Downloaden vom Blob stattfinden muss. Es ist zu beachten das in diesem Fall der Container bereits vorher erstellt
worden sein muss.

.. _zendservice.windowsazure.storage.blob.api.copy-blob.example:

.. rubric:: Kopieren eines Blobs

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Blob();

   // Kopiert example.txt auf example2.txt
   $result = $storageClient->copyBlob(
       'testcontainer', 'example.txt', 'testcontainer', 'example2.txt'
   );

   echo 'Der Name des kopierten Blobs ist: ' . $result->Name;

.. _zendservice.windowsazure.storage.blob.api.download-blob:

Herunterladen eines Blobs
^^^^^^^^^^^^^^^^^^^^^^^^^

Bei Verwendung des folgenden Codes kann ein Blob von einem Blob Speicher Container auf den Development Speicher
heruntergeladen werden. Es ist zu beachten das der Container hierfür bereits vorher erstellt wurden sein und ein
Blob darauf hochgeladen sein muss.

.. _zendservice.windowsazure.storage.blob.api.download-blob.example:

.. rubric:: Herunterladen eines Blobs

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Blob();

   // Lädt die Datei /home/maarten/example.txt herunter
   $storageClient->getBlob(
       'testcontainer', 'example.txt', '/home/maarten/example.txt'
   );

.. _zendservice.windowsazure.storage.blob.api.public-blob:

Einen Blob öffentlich verfügbar machen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Standardmäßig sind Blob Speicher Container in Windows Azure geschützt vor öffentlichem Zugriff. Wenn ein
Benutzer im Internet Zugriff auf einen Blob Container haben soll, kann seine ACL auf öffentlich (public) gesetzt
werden. Es ist zu beachten dass das auf den kompletten Container angewendet wird, und nicht auf einen einzelnen
Blob!

Bei Verwendung des folgenden Codes kann die ACL eines Blob Speicher Containers auf den Development Speicher gesetzt
werden. Es ist zu beachten das der Container hierfür bereits vorher erstellt worden sein muss.

.. _zendservice.windowsazure.storage.blob.api.public-blob.example:

.. rubric:: Einen Blob öffentlich zugänglich machen

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Blob();

   // Den Container öffentlich zugänglich machen
   // (alle Blobs durchgehen und Blob Daten lesen)
   $storageClient->setContainerAcl(
       'testcontainer',
       ZendService\WindowsAzure\Storage\Blob::ACL_PUBLIC_CONTAINER
   );

.. _zendservice.windowsazure.storage.blob.root:

Stamm Container
---------------

Der Windows Azure Blob Speicher bietet Unterstützung für die Arbeit mit einem "Stamm Container" (root). Das
bedeutet das ein Blob im Stamm des Speicher Containers gespeichert werden kann, z.B.
``http://myaccount.blob.core.windows.net/somefile.txt``.

Um mit dem Stamm Container zu arbieten sollte er zuerst durch Verwendung der ``createContainer()`` Methode erstellt
worden sein, und der Container sollte ``$root`` heißen. Alle anderen Operationen auf dem Stamm Container sollten
ausgeführt werden indem der Containernamen auf ``$root`` gesetzt wird.

.. _zendservice.windowsazure.storage.blob.wrapper:

Blob Speicher Stream Wrapper
----------------------------

Die Windows Azure *SDK* für *PHP* bietet Unterstützung für die Registrierung eines Blob Speicher Clients als
*PHP* File Stream Wrapper. Der Blob Speicher Stream Wrapper bietet Unterstützung für die Verwendung von
regulären Datei Operationen auf dem Windows Azure Blob Speicher. Zum Beispiel kann eine Datei vom Windows Azure
Blob Speicher aus mit der Funktion ``fopen()`` geöffnet werden:

.. _zendservice.windowsazure.storage.blob.wrapper.sample:

.. rubric:: Beispiel der Verwendung des Blob Speicher Stream Wrappers

.. code-block:: php
   :linenos:

   $fileHandle = fopen('azure://mycontainer/myfile.txt', 'r');

   // ...

   fclose($fileHandle);

Um das zu tun muss die Windows Azure *SDK* für den *PHP* Blob Speicher Client als Stream Wrapper registriert
werden. Das kann getan werden indem die Methode ``registerStreamWrapper()`` aufgerufen wird:

.. _zendservice.windowsazure.storage.blob.wrapper.register:

.. rubric:: Den Blob Speicher Stream Wrapper registrieren

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Blob();
   // registriert azure:// auf diesem Speicher Client
   $storageClient->registerStreamWrapper();

   // oder:

   // registriert blob:// auf diesem Speicher Client
   $storageClient->registerStreamWrapper('blob://');

Um den Stream Wrapper zu deregistrieren kann die Methode ``unregisterStreamWrapper()`` verwendet werden.

.. _zendservice.windowsazure.storage.blob.sharedaccesssig:

Shared Access Signaturen
------------------------

Der Windows Azure Bolb Speicher bietet ein Feature welches "Shared Access Signatures" genannt wird. Standardmäßig
gibt es nur ein Level der Authorosierung welche in Windows Azure Blob Speicher möglich ist: entweder ist ein
Container privat oder er ist öffentlich. Shared Access Signaturen bieten eine feinere Methode der Authorisierung:
Lese-, Schreib-, Lösch- und Anzeigerechte können auf einem Container oder einem Blob für einen speziellen Client
zugeordnet werden indem ein URL-basierendes Modell verwendet wird.

Ein Beispiel würde die folgende Signatur sein:


::

   http://phpstorage.blob.core.windows.net/phpazuretestshared1?st=2009-08-17T09%3A06%3A17Z&se=2009-08-17T09%3A56%3A17Z&sr=c&sp=w&sig=hscQ7Su1nqd91OfMTwTkxabhJSaspx%2BD%2Fz8UqZAgn9s%3D

Die obige Signatur gibt Schreibrechte auf den Container "phpazuretestshared1" des Accounts "phpstorage".

.. _zendservice.windowsazure.storage.blob.sharedaccesssig.generate:

Erstellen einer Shared Access Signature
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wenn man Eigentümer eines Windows Azure Blob Speicher Accounts ist kann man einen geteilten Zugriffsschlüssel
für jeden Typ einer Ressource im eigenen Account erstellen und teilen. Um das zu tun kann die Methode
``generateSharedAccessUrl()`` des ``ZendService\WindowsAzure\Storage\Blob`` Speicher Clients verwendet werden.

Der folgende Beispielcode erzeugt eine Shared Access Signatur für den Schreibzugriff in einem Container der
"container1" heißt, in einem Zeitrahmen von 3000 Sekunden.

.. _zendservice.windowsazure.storage.blob.sharedaccesssig.generate-2:

.. rubric:: Erstellung einer Shared Access Signatur für einen Container

.. code-block:: php
   :linenos:

   $storageClient   = new ZendService\WindowsAzure\Storage\Blob();
   $sharedAccessUrl = $storageClient->generateSharedAccessUrl(
       'container1',
       '',
       'c',
       'w',
       $storageClient ->isoDate(time() - 500),
       $storageClient ->isoDate(time() + 3000)
   );

Der folgende Beispielcode erzeugt eine Shared Access Signatur für den Lesezugriff in einem Blob der ``test.txt``
heißt und einem Container der "container1" heißt, in einem Zeitrahmen von 3000 Sekunden.

.. _zendservice.windowsazure.storage.blob.sharedaccesssig-generate-3:

.. rubric:: Erzeugen einer Shared Access Signatur für einen Blob

.. code-block:: php
   :linenos:

   $storageClient   = new ZendService\WindowsAzure\Storage\Blob();
   $sharedAccessUrl = $storageClient->generateSharedAccessUrl(
       'container1',
       'test.txt',
       'b',
       'r',
       $storageClient ->isoDate(time() - 500),
       $storageClient ->isoDate(time() + 3000)
   );

.. _zendservice.windowsazure.storage.blob.sharedaccesssig.consume:

Arbeiten mit Shared Access Signaturen von anderen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wenn man eine Shared Access Signatur von jemandem anderen erhält kann man die Windows Azure *SDK* für *PHP*
verwenden um mit der adressierten Ressource zu arbeiten. Zum Beispiel kann man die folgende Signatur vom
Eigentümer eines Speicher Accounts erhalten:


::

   http://phpstorage.blob.core.windows.net/phpazuretestshared1?st=2009-08-17T09%3A06%3A17Z&se=2009-08-17T09%3A56%3A17Z&sr=c&sp=w&sig=hscQ7Su1nqd91OfMTwTkxabhJSaspx%2BD%2Fz8UqZAgn9s%3D

Die obige Signatur gibt Schreibzugriff auf "phpazuretestshared1" "container" des PhpSpeicher Accounts. Da der
geteilte Schlüssel für den Account nicht bekannt ist, kann die Shared Access Signatur verwendet werden um mit der
authorisierten Ressource zu arbeiten.

.. _zendservice.windowsazure.storage.blob.sharedaccesssig.consuming:

.. rubric:: Verwenden einer Shared Access Signatur für einen Container

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Blob(
       'blob.core.windows.net', 'phpstorage', ''
   );
   $storageClient->setCredentials(
       new ZendService\WindowsAzure\Credentials\SharedAccessSignature()
   );
   $storageClient->getCredentials()->setPermissionSet(array(
       'http://phpstorage.blob.core.windows.net/phpazuretestshared1?st=2009-08-17T09%3A06%3A17Z&se=2009-08-17T09%3A56%3A17Z&sr=c&sp=w&sig=hscQ7Su1nqd91OfMTwTkxabhJSaspx%2BD%2Fz8UqZAgn9s%3D'
   ));
   $storageClient->putBlob(
       'phpazuretestshared1', 'NewBlob.txt', 'C:\Files\dataforazure.txt'
   );

Es ist zu beachten das es keine explizite Erlaubnis für das Schreiben eines spezifischen Blobs gab. Stattdessen
hat die Windows Azure *SDK* für *PHP* festgestellt das eine Erlaubnis benötigt wurde um entweder an den
spezifischen Blob zu schreiben, oder an seinen Container zu schreiben. Da nur eine Signatur für das letztere
vorhanden war, hat die Windows Azure *SDK* für *PHP* diese Zugriffsrechte ausgewählt um die Anfrage auf den
Windows Azure Blob Speicher durchzuführen.


