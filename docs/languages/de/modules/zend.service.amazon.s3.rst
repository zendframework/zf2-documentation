.. EN-Revision: none
.. _zend.service.amazon.s3:

Zend\Service_Amazon\S3
======================

.. _zend.service.amazon.s3.introduction:

Einführung
----------

Amazon S3 bietet ein einfaches Webservice Interface das verwendet werden kann um beliebige Mengen an Daten,
jederzeit und von überall her aus dem Web, zu Speichern und erhalten. Es gibt Entwicklern den Zugriff auf die
gleiche, hoch skalierbare, verfügbare, schnelle und kostengünstige Datenspeicher Infrastruktur die Amazon
verwendet um sein eigenes globales Netzwerk an Websites zu betreiben. Der Service zielt darauf ab den Nutzen der
Skalierbarkeit zu erhöhen und diese Vorteile an Entwickler weiterzugeben.

.. _zend.service.amazon.s3.registering:

Registrierung mit Amazon S3
---------------------------

Bevor man mit ``Zend\Service_Amazon\S3`` beginnen kann, muß man einen Account registrieren. Sehen Sie bitte auf
die Amazon Website `S3 FAQ`_ für weitere Informationen.

Nach der Registrierung erhält man einen Anwendungsschlüssel und einen geheimen Schlüssel. Man benötigt beide um
auf den S3 Service zugreifen zu können.

.. _zend.service.amazon.s3.apiDocumentation:

API Dokumentation
-----------------

Die Klasse ``Zend\Service_Amazon\S3`` bietet einen *PHP* Wrapper zum Amazon S3 REST Interface. Schauen Sie bitte in
die `Amazon S3 Dokumentation`_ für eine detailierte Beschreibung des Services. Man muß mit dem grundsätzlichen
Konzept vertraut sein um dieses Service nutzen zu können.

.. _zend.service.amazon.s3.features:

Features
--------

``Zend\Service_Amazon\S3`` bietet die folgenden Funktionalitäten:



   - Einen einzelnen Punkt für die Konfiguration der eigenen amazon.s3 Zugangsdaten der über dem kompletten
     amazon.s3 Namespace verwendet werden kann.

   - Ein Proxy Objekt das bequemer zu verwenden ist als ein *HTTP* Client alleine, da er hauptsächlich die
     Notwendigkeit eliminiert manuell eine *HTTP* POST Anfrage über den REST Service zu erstellen.

   - Ein Antwort-Wrapper der jede Antwort erhebt und eine Exception wirft wenn ein Fehler aufgetreten ist, was die
     Notwendigkeit eliminiert den Erfolg vieler Kommandos wiederholt zu prüfen.

   - Zusätzliche bequeme Methoden für einige der üblicheren Operationen.



.. _zend.service.amazon.s3.storing-your-first:

Beginnen wir
------------

Sobald man sich mit Amazon S3 registriert hat, ist man bereit sein erstes Objekt auf S3 zu speichern. Die Objekte
werden auf S3 in Containern gespeichert, die "Buckets" genannt werden. Der Name der Buckets ist auf S3 eindeutig,
und jeder Benutzer kann nicht mehr als 100 Buckets simultan besitzen. Jeder Bucket kann eine unlimitierte Anzahl an
Objekten enthalten, die durch den Namen identifiziert werden.

Das folgende Beispiel demonstriert die Erstellung eines Buckets, und das Speichern und Empfangen von Daten.

.. _zend.service.amazon.s3.storing-your-first.example:

.. rubric:: Beispiel der Verwendung von Zend\Service_Amazon\S3

.. code-block:: php
   :linenos:

   require_once 'Zend/Service/Amazon/S3.php';

   $s3 = new Zend\Service_Amazon\S3($my_aws_key, $my_aws_secret_key);

   $s3->createBucket("my-own-bucket");

   $s3->putObject("my-own-bucket/myobject", "somedata");

   echo $s3->getObject("my-own-bucket/myobject");

Da der ``Zend\Service_Amazon\S3`` Service eine Authentifizierung benötigt, sollte man seine Zugangsdaten (AWS
Schlüssel und Geheimschlüssel) an den Konstruktor übergeben. Wenn man nur einen Account verwendet, kann man
Standard-Zugangsdaten für das Service setzen:

.. code-block:: php
   :linenos:

   require_once 'Zend/Service/Amazon/S3.php';

   Zend\Service_Amazon\S3::setKeys($my_aws_key, $my_aws_secret_key);
   $s3 = new Zend\Service_Amazon\S3();

.. _zend.service.amazon.s3.buckets:

Bucket Operationen
------------------

Alle Objekte im S3 System werden in Buckets gespeichert. Buckets müssen erstellt werden bevor Speicheroperationen
durchgeführt werden. Der Name des Buckets ist im System eindeutig, so das man den Bucket nicht so benennen kann
wie den Bucket einer anderen Person.

Namen von Buckets können Kleinbuchstaben, Ziffern, Punkte (.), Unterstriche (\_), und Bindestriche (-) enthalten.
Es sind keine anderen Symbole erlaubt. Bucketnamen sollten mit einem Buchstaben oder einer Ziffer beginnen, und 3
bis 255 Zeichen lang sein. Namen die wie eine IP Adresse aussehen (z.B. "192.168.16.255") sind nicht erlaubt.

- ``createBucket()`` erstellt einen neuen Bucket.

- ``cleanBucket()`` entfernt alle Objekte die in einem Bucket enthalten sind.

- ``removeBucket()`` entfernt den Bucket vom System. Der Bucket sollte leer sein damit er entfernt werden kann.

  .. _zend.service.amazon.s3.buckets.remove.example:

  .. rubric:: Beispiel für das Entfernen eines Buckets in Zend\Service_Amazon\S3

  .. code-block:: php
     :linenos:

     require_once 'Zend/Service/Amazon/S3.php';

     $s3 = new Zend\Service_Amazon\S3($my_aws_key, $my_aws_secret_key);

     $s3->cleanBucket("my-own-bucket");
     $s3->removeBucket("my-own-bucket");

- ``getBuckets()`` gibt eine Liste der Namen aller Buckets zurück die einem Benutzer gehören.

  .. _zend.service.amazon.s3.buckets.list.example:

  .. rubric:: Beispiel für das Auflisten der Buckets in Zend\Service_Amazon\S3

  .. code-block:: php
     :linenos:

     require_once 'Zend/Service/Amazon/S3.php';

     $s3 = new Zend\Service_Amazon\S3($my_aws_key, $my_aws_secret_key);

     $list = $s3->getBuckets();
     foreach ($list as $bucket) {
       echo "Ich habe das Bucket $bucket\n";
     }

- ``isBucketAvailable()`` prüft ob das Bucket existiert und gibt ``TRUE`` zurück wenn das der Fall ist.

.. _zend.service.amazon.s3.objects:

Operationen am Objekt
---------------------

Das Objekte ist die grundsätzliche Speichereinheit in S3. Objekte speichern nicht strukturierte Daten, welche jede
Größe, bis zu 4 Gigabyte, haben können. Es gibt kein Limit in der Anzahl der Objekte die auf dem System
gespeichert werden können.

Objekte werden in Buckets abgelegt. Sie werden durch den Namen identifiziert, der jeder UTF-8 String sein kann. Es
ist üblich hierarchische Namen zu verwenden (wie z.B. *Pictures/Myself/CodingInPHP.jpg* um Objektnamen zu
organisieren. Objektnamen wird der Bucketname vorangestellt wenn Objektfunktionen verwendet werden, so dass das
Objekt "mydata" im Bucket "my-own-bucket" den Namen *my-own-bucket/mydata* haben würde.

Objekte können ersetzt (durch Überschreiben neuer Daten mit dem gleichen Schlüssel) oder gelöscht werden, aber
nicht geändert, angefügt, usw. Objekte werden immer als Ganzes gespeichert.

Standardmäßig sind alle Objekte privat und es kann nur durch Ihren Besitzer auf Sie zugegriffen werden. Trotzdem
ist es möglich Objekte mit öffentlichem Zugriff zu spezifizieren, wodurch man auf Sie mit der folgenden *URL*
zugreifen kann: *http://s3.amazonaws.com/[bucket-name]/[object-name]*.

- ``putObject($object, $data, $meta)`` erstellt ein Objekt mit dem Namen ``$object`` (Sollte den Bucketnamen als
  Präfix enthalten!) das ``$data`` als seinen Inhalt besitzt.

  Der optionale ``$meta`` Parameter ist das Array von Metadaten, welches aktuell die folgenden Schlüssel enthalten
  kann:

  **S3_CONTENT_TYPE_HEADER**
     *MIME* Content Type der Daten. Wenn nicht angegeben, wird der Typ anhand der Dateiextension des Objektnamens
     geschätzt.

  **S3_ACL_HEADER**
     Der Zugriff auf das Element. Folgende Zugriffskonstanten können verwendet werden:

        **S3_ACL_PRIVATE**
           Nur der Besitzer hat auf das Element Zugriff.

        **S3_ACL_PUBLIC_READ**
           Jeder kann das Objekt lesen, aber nur der Besitzer kann schreiben. Diese Eigenschaft kann verwendet
           werden um öffentlich zugängliche Inhalte zu speichern.

        **S3_ACL_PUBLIC_WRITE**
           Jeder kann das Objekt schreiben oder lesen. Diese Eigenschaft sollte sehr spärlich verwendet werden.

        **S3_ACL_AUTH_READ**
           Nur der Besitzer hat Schreibzugriff auf das Element, und andere authentifizierte S3 Benutzer haben
           Leserechte. Das ist nützlich um Daten zwischen S3 Accounts zu teilen ohne Sie der Öffentlichkeit
           zugänglich zu machen.

     Standardmäßig sind alle diese Elemente privat.

     .. _zend.service.amazon.s3.objects.public.example:

     .. rubric:: Beispiel für ein öffentliches Objekt in Zend\Service_Amazon\S3

     .. code-block:: php
        :linenos:

        require_once 'Zend/Service/Amazon/S3.php';

        $s3 = new Zend\Service_Amazon\S3($my_aws_key, $my_aws_secret_key);

        $s3->putObject("my-own-bucket/Pictures/Me.png", file_get_contents("me.png"),
            array(Zend\Service_Amazon\S3::S3_ACL_HEADER =>
                  Zend\Service_Amazon\S3::S3_ACL_PUBLIC_READ));
        // oder:
        $s3->putFile("me.png", "my-own-bucket/Pictures/Me.png",
            array(Zend\Service_Amazon\S3::S3_ACL_HEADER =>
                  Zend\Service_Amazon\S3::S3_ACL_PUBLIC_READ));
        echo "Go to http://s3.amazonaws.com/my-own-bucket/Pictures/Me.png to see me!\n";

- ``getObject($object)`` empfängt Objektdaten vom Speicher anhand des Namens.

- ``removeObject($object)`` entfernt das Objekt vom Speicher.

- ``getInfo($object)`` empfängt die Metadaten des Objekts. Diese Funktion gibt ein Array mit Metadaten zurück.
  Einige der nützlichen Schlüssel sind:

     **type**
        Der *MIME* Typ des Elements.

     **size**
        Die Größe der Objektdaten.

     **mtime**
        UNIX-artiger Zeitstempel der letzten Änderung für das Objekt.

     **etag**
        Das ETag der Daten, welches ein MD5 Hash der Daten ist, eingeklammert von Hochkomma (").

  Die Funktion gibt ``FALSE`` zurück wenn der Schlüssel keinem der existierenden Objekte entspricht.

- ``getObjectsByBucket($bucket)`` gibt eine Liste der Objektschlüssel zurüc, die im Bucket enthalten sind.

  .. _zend.service.amazon.s3.objects.list.example:

  .. rubric:: Beispiel für die Auflistung eines Zend\Service_Amazon\S3 Objekts

  .. code-block:: php
     :linenos:

     require_once 'Zend/Service/Amazon/S3.php';

     $s3 = new Zend\Service_Amazon\S3($my_aws_key, $my_aws_secret_key);

     $list = $s3->getObjectsByBucket("my-own-bucket");
     foreach ($list as $name) {
       echo "Ich habe $name Schlüssel:\n";
       $data = $s3->getObject("my-own-bucket/$name");
       echo "with data: $data\n";
     }

- ``isObjectAvailable($object)`` prüft ob das Objekt mit dem angegebenen Namen existiert.

- ``putFile($path, $object, $meta)`` fügt den Inhalt der Datei unter ``$path`` in das Objekt mit dem Namen
  ``$object`` ein.

  Das optionale Argument ``$meta`` ist das gleiche wie für *putObject*. Wenn der Content-Typ nicht angegeben wird,
  wird er anhand des Dateinamens vermutet.

.. _zend.service.amazon.s3.streaming:

Daten Streamen
--------------

Es ist möglich Objekte zu Holen und Setzen wobei keine Stream Daten verwendet werden die im Speicher sind, sondern
Dateien oder *PHP* Streams. Das ist Speziell dann nützlich wenn Dateien sehr groß sind um nicht über
Speichergrenzen zu kommen.

Um ein Objekt mit Streaming zu Empfangen muss die Methode ``getObjectStream($object, $filename)`` verwendet werden.
Diese Methode gibt einen ``Zend\Http_Response\Stream`` zurück, welcher wie im Kapitel :ref:`HTTP Client Daten
Streaming <zend.http.client.streaming>` verwendet werden kann.



      .. _zend.service.amazon.s3.streaming.example1:

      .. rubric:: Beispiel für das Streamen von Daten mit Zend\Service_Amazon\S3

      .. code-block:: php
         :linenos:

         $response = $amazon->getObjectStream("mybycket/zftest");
         // Datei kopieren
         copy($response->getStreamName(), "my/downloads/file");
         // Hinauf Streamen
         $fp = fopen("my/downloads/file2", "w");
         stream_copy_to_stream($response->getStream(), $fp);



Der zweite Parameter für ``getObjectStream()`` ist optional und spezifiziert die Zieldatei in welche die dAten
geschrieben werden. Wenn er nicht spezifiziert ist, wird eine temporäre Datei verwendet. Diese wird gelöscht
nachdem das Antwort-Objekt gelöscht wurde.

Um ein Objekt mit Streaming zu Senden kann ``putFileStream()`` verwendet werden. Es hat die gleiche Signatur wie
``putFile()`` verwendet aber Streaming und liest die Datei nicht in den Speicher ein.

Man kann auch eine Stream Ressource an die ``putObject()`` Methode als Daten Parameter übergeben. In diesem Fall
werden die Daten vom Stream gelesen wenn die Anfrage an den Server gesendet wird.

.. _zend.service.amazon.s3.streams:

Stream wrapper
--------------

Zusätzlich zum oben beschriebenen Interface unterstützt ``Zend\Service_Amazon\S3`` das Arbeiten als Stream
Wrapper. Hierfür muß das Client-Objekt als Stream Wrapper registriert werden:

.. _zend.service.amazon.s3.streams.example:

.. rubric:: Beispiel für Streams mit Zend\Service_Amazon\S3

.. code-block:: php
   :linenos:

   require_once 'Zend/Service/Amazon/S3.php';

   $s3 = new Zend\Service_Amazon\S3($my_aws_key, $my_aws_secret_key);

   $s3->registerStreamWrapper("s3");

   mkdir("s3://my-own-bucket");
   file_put_contents("s3://my-own-bucket/testdata", "mydata");

   echo file_get_contents("s3://my-own-bucket/testdata");

Die Verzeichnis-Operationen (*mkdir*, *rmdir*, *opendir*, usw.) werden an Buckets ausgeführt und deshalb sollten
deren Argumente in der Form *s3://bucketname* angegeben werden. Dateioperationen werden an Objekten ausgeführt.
Objekt Erstellung, Lesen, Schreiben, Löschen, Stat und Anzeigen von Verzeichnissen wird unterstützt.



.. _`S3 FAQ`: http://aws.amazon.com/s3/faqs/
.. _`Amazon S3 Dokumentation`: http://developer.amazonwebservices.com/connect/kbcategory.jspa?categoryID=48
