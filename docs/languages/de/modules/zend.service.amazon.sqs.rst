.. EN-Revision: none
.. _zend.service.amazon.sqs:

Zend\Service\Amazon\Sqs
=======================

.. _zend.service.amazon.sqs.introduction:

Einführung
----------

`Amazon Simple Queue Service (Amazon SQS)`_ bietet eine einfache, hoch skalierbare, gehostete Queue für das
Speichern von Nachrichten die zwischen Computern verschickt werden. Durch die Verwendung von Amazon SQS können
Entwickler Daten einfach zwischen entfernten Komponenten Ihrer Anwendung verschieben, welche unterschiedliche
Arbeiten durchführen, ohne das Nachrichten verloren gehen und auch ohne der Notwendigkeit das jede Komponente
immer verfügbar sein muß. Amazon SQS macht es einfach einen automatischen Arbeitsablauf zu erstellen, und in
enger Verknüpfung mit Amazon Elastic Compute Cloud (Amazon EC2) und auch den anderen *AWS* Infrastruktur Web
Services zu arbeiten.

Amazon SQS arbeitet durch die Bereitstellung von Amazon's Web-Scale Nachrichten Infrastruktur als Web Service.
Jeder Computer im Internet kann Nachrichten hinzufügen und lesen ohne das Software installiert werden muß oder
die Firewall Konfiguration zu ändern ist. Componenten von Anwendungen die Amazon SQS verwenden können unabhängig
laufen und müssen nicht im gleichen Netzwerk sein, mit der gleichen Technologie entwickelt worden sein, oder zur
gleichen Zeit laufen.

.. _zend.service.amazon.sqs.registering:

Bei Amazon SQS registrieren
---------------------------

Bevor man mit ``Zend\Service\Amazon\Sqs`` beginnt muß man einen Account registrieren. Sehen Sie bitte in die `SQS
FAQ`_ Seite auf der Amazon Website für weitere Informationen.

Nach der Registrierung, bekommt man einen Anwendungsschlüssel und einen geheimen Schlüssel. Man benötigt beide
um auf den SQS Service zugreifen zu können.

.. _zend.service.amazon.sqs.apiDocumentation:

API Dokumentation
-----------------

Die ``Zend\Service\Amazon\Sqs`` Klasse bietet den *PHP* Wrapper zum Amazon SQS REST Interface. Bitte konsultieren
Sie die `Amazon SQS Dokumentation`_ für eine detailierte Beschreibung des Services. Man muß mit dem
grundsätzlichen Konzept vertraut sein um dieses Service verwenden zu können.

.. _zend.service.amazon.sqs.features:

Features
--------

``Zend\Service\Amazon\Sqs`` bietet die folgende Funktionalität:

- Einen einzelnen Punkt für die Konfiguration des Authentifizierungsdaten von amazon.sqs die über den kompletten
  amazon.sqs Namespace verwendet werden können.

- Ein Proxy Objekt das viel bequemer zu verwenden ist als ein *HTTP* Client alleine, indem er hauptsächlich die
  Notwendigkeit entfernt die *HTTP* POST Anfrage manuell zu erstellen und auf den REST Service zuzugreifen.

- Ein Antwort Wrapper der jeden Antwort Body durchsucht und eine Exception wirft wenn ein Fehler auftritt, und es
  unnötig macht die vielen Kommandos wiederholt auf Erfolg zu prüfen.

- Zusätzliche bequeme Methoden für einige der üblicheren Operationen.

.. _zend.service.amazon.sqs.storing-your-first:

Beginnen
--------

Sobald man sich bei Amazon SQS registriert hat ist man bereit seine eigene Queue zu erstellen und einige
Nachrichten auf SQS zu speichern. Jede Queue kann eine unbegrenzte Anzahl an Nachrichten enthalten, die durch Ihren
Namen identifiziert werden.

Das folgende Beispiel demonstriert die Erstellung einer Queue, und das speichern sowie empfangen von Nachrichten.

.. _zend.service.amazon.sqs.storing-your-first.example:

.. rubric:: Beispiel der Verwendung von Zend\Service\Amazon\Sqs

.. code-block:: php
   :linenos:

   $sqs = new Zend\Service\Amazon\Sqs($my_aws_key, $my_aws_secret_key);

   $queue_url = $sqs->create('test');

   $message = 'Das ist ein Test';
   $message_id = $sqs->send($queue_url, $message);

   foreach ($sqs->receive($queue_url) as $message) {
       echo $message['body'].'<br/>';
   }

Das der ``Zend\Service\Amazon\Sqs`` Service eine Authentifizierung benötigt, kann man seine Zugangsdaten (AWS
Schlüssel und geheimer Schlüssel) im Constructor angeben. Wenn man nur einen Account verwendet kann man
standardmäßige Zugangsdaten für den Service setzen:

.. code-block:: php
   :linenos:

   Zend\Service\Amazon\Sqs::setKeys($my_aws_key, $my_aws_secret_key);
   $sqs = new Zend\Service\Amazon\Sqs();

.. _zend.service.amazon.sqs.queues:

Operationen der Queue
---------------------

Alle SQS Nachrichten werden in Queues gespeichert. Eine Queue muß erstellt werden bevor irgendwelche Operationen
mit Nachrichten durchgeführt werden. Die Namen der Queues müssen in Verbindung mit dem Zugriffsschlüssel und den
geheimen Schlüssel einmalig sein.

Namen von Queues können kleingeschriebene Buchstaben, Ziffern, Punkte (.), Unterstriche (\_) und Bindestriche (-)
enthalten. Es sind keine anderen Symbole erlaubt. Die Namen von Queues dürfen eine maximal Länge von 80 Zeichen
haben.

- ``create()`` erstellt eine neue Queue.

- ``delete()`` entfernt alle Nachrichten in der Queue.

  .. _zend.service.amazon.sqs.queues.removalExample:

  .. rubric:: Beispiel für das Entfernen von Queues aus Zend\Service\Amazon\Sqs

  .. code-block:: php
     :linenos:

     $sqs = new Zend\Service\Amazon\Sqs($my_aws_key, $my_aws_secret_key);
     $queue_url = $sqs->create('test_1');
     $sqs->delete($queue_url);

- ``count()`` gibt die erwartete Anzahl von Nachrichten in der Queue zurück.

  .. _zend.service.amazon.sqs.queues.countExample:

  .. rubric:: Beispiel für das Zählen von Queues in Zend\Service\Amazon\Sqs

  .. code-block:: php
     :linenos:

     $sqs = new Zend\Service\Amazon\Sqs($my_aws_key, $my_aws_secret_key);
     $queue_url = $sqs->create('test_1');
     $sqs->send($queue_url, 'Das ist ein Test');
     $count = $sqs->count($queue_url); // Gibt '1' zurück

- ``getQueues()`` gibt eine Liste der Namen aller Queues zurück die dem Benutzer gehören.

  .. _zend.service.amazon.sqs.queues.listExample:

  .. rubric:: Beispiel für das Auflisten von Queues in Zend\Service\Amazon\Sqs

  .. code-block:: php
     :linenos:

     $sqs = new Zend\Service\Amazon\Sqs($my_aws_key, $my_aws_secret_key);
     $list = $sqs->getQueues();
     foreach ($list as $queue) {
        echo "Ich habe $queue Queues\n";
     }

.. _zend.service.amazon.sqs.messages:

Operationen für Nachrichten
---------------------------

Nachdem eine Queue erstellt wurde, können Nachrichten einfach in die Queue gesendet und zu einem späteren
Zeitpunkt von Ihr empfangen werden. Nachrichten können eine Länge von bis zu 8kB haben. Wenn längere Nachrichten
benötigt werden sollte in das Kapitel `S3`_ gesehen werden. Es gibt keine Begrenzung in der Anzahl der Nachrichten
die eine Queue enthalten kann.

- ``sent($queue_url, $message)`` sendet die Nachricht ``$message`` an die *URL* *$queue_url* der SQS Queue.

  .. _zend.service.amazon.sqs.messages.sendExample:

  .. rubric:: Beispiel für das Senden von Nachrichten an Zend\Service\Amazon\Sqs

  .. code-block:: php
     :linenos:

     $sqs = new Zend\Service\Amazon\Sqs($my_aws_key, $my_aws_secret_key);
     $queue_url = $sqs->create('test_queue');
     $sqs->send($queue_url, 'Das ist eine Test Nachricht');

- ``receive($queue_url)`` empfängt Nachrichten von der Queue.

  .. _zend.service.amazon.sqs.messages.receiveExample:

  .. rubric:: Beispiel für das Empfangen von Nachrichten von Zend\Service\Amazon\Sqs

  .. code-block:: php
     :linenos:

     $sqs = new Zend\Service\Amazon\Sqs($my_aws_key, $my_aws_secret_key);
     $queue_url = $sqs->create('test_queue');
     $sqs->send($queue_url, 'Das ist eine Test Nachricht');
     foreach ($sqs->receive($queue_url) as $message) {
         echo "Nachricht ".$message['body'].' empfangen<br/>';
     }

- ``deleteMessage($queue_url, $handle)`` löscht eine Nachricht von einer Queue. Die Nachricht muß zuerst durch
  Verwendung der ``receive()`` Methode empfangen werden bevor Sie gelöscht werden kann.

  .. _zend.service.amazon.sqs.messages.deleteExample:

  .. rubric:: Beispiel für das Löschen von Nachrichten aus Zend\Service\Amazon\Sqs

  .. code-block:: php
     :linenos:

     $sqs = new Zend\Service\Amazon\Sqs($my_aws_key, $my_aws_secret_key);
     $queue_url = $sqs->create('test_queue');
     $sqs->send($queue_url, 'Das ist eine Test Nachricht');
     foreach ($sqs->receive($queue_url) as $message) {
         echo "Nachricht ".$message['body'].' empfangen<br/>';

         if ($sqs->deleteMessage($queue_url, $message['handle'])) {
             echo "Nachricht gelöscht";
         }
         else {
             echo "Nachricht nicht gelöscht";
         }
     }



.. _`Amazon Simple Queue Service (Amazon SQS)`: http://aws.amazon.com/sqs/
.. _`SQS FAQ`: http://aws.amazon.com/sqs/faqs/
.. _`Amazon SQS Dokumentation`: http://developer.amazonwebservices.com/connect/kbcategory.jspa?categoryID=31
.. _`S3`: http://framework.zend.com/manual/en/zend.service.amazon.s3.html
