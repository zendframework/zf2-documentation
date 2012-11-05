.. EN-Revision: none
.. _zend.service.amazon.ec2.ebs:

Zend\Service_Amazon\Ec2: Elastischer Block Speicher (EBS)
=========================================================

Amazon Elastischer Block Speicher (Amazon EBS) ist ein neuer Typ an Speicher der speziell für Amazon EC2 Instanzen
entwickelt wurde. Amazon EBS erlaubt es ein Volume zu erstellen das als Device von Amazon EC2 Instanzen gemountet
werden kann. Amazon EBS Volums verhalten sich wie rohe unformatierte externe Block Devices. Sie haben einen vom
Benutzer angegebenen Device Namen und bieten ein Block Device Interface. Man kann ein File System auf Amazon EBS
Volums laden, oder Sie genauso verwenden wie man ein Block Device verwenden würde.

Man kann bis zu zwanzig Amazon EBS Volums jeder Größe erstellen (von einem GiB bis zu einem TiB). Jedes Amazon
EBS Volume kann jeder Amazon EC2 Instanz angehängt werden welche in der selben Availability Zone ist, oder kann
auch un-angehängt bleiben.

Amazon EBS bietet die Möglichkeit einen Snapshot der eigenen Amazon EBS Volums auf Amazon S3 zu erstellen. Man
kann diese Snapshots als Startpunkt für neue Amazon EBS Volums verwenden und kann eigene Daten auf diese Art für
eine lange Zeit schützen.

.. _zend.service.amazon.ec2.ebs.creating:

EBS Volums und Snapshots erstellen
----------------------------------

.. _zend.service.amazon.ec2.ebs.creating.volume:

.. rubric:: Ein neues EBS Volume erstellen

Um ein brandneues EBS Volume zu erstellen benötigt man die Größe und die Zone in der das EBS Volume sein soll.

*createNewVolume* gibt ein Array zurück das Informationen über das neue Volume enthält. Diese beinhalten
volumeId, size, zone, status und createTime.

.. code-block:: php
   :linenos:

   $ec2_ebs = new Zend\Service\Amazon\Ec2\Ebs('aws_key','aws_secret_key');
   $return = $ec2_ebs->createNewVolume(40, 'us-east-1a');

.. _zend.service.amazon.ec2.ebs.creating.volumesnapshot:

.. rubric:: Ein EBS Volume von einem Snapshot erstellen

Um ein EBS Volume von einem Snapshot zu erstellen benötigt man die snapshot_id in die Zone in der man das EBS
Volume haben will.

*createVolumeFromSnapshot* gibt ein Array mit Informationen zurück. Diese enthalten volumeId, size, zone, status,
createTime und snapshotId.

.. code-block:: php
   :linenos:

   $ec2_ebs = new Zend\Service\Amazon\Ec2\Ebs('aws_key','aws_secret_key');
   $return = $ec2_ebs->createVolumeFromSnapshot('snap-78a54011', 'us-east-1a');

.. _zend.service.amazon.ec2.ebs.creating.snapshot:

.. rubric:: Einen Snapshot von einem EBS Volume erstellen

Um einen Snapshot von einem EBS Volume zu erstellen wird die volumeId des EBS Volums benötigt.

*createSnapshot* gibt ein Array zurück das Informationen über den neuen Volume Snapshot enthält. Dieses
beinhaltet snapshotId, volumeId, status, startTime und progress.

.. code-block:: php
   :linenos:

   $ec2_ebs = new Zend\Service\Amazon\Ec2\Ebs('aws_key','aws_secret_key');
   $return = $ec2_ebs->createSnapshot('volumeId');

.. _zend.service.amazon.ec2.ebs.describing:

EBS Volumes und Snapshots beschreiben
-------------------------------------

.. _zend.service.amazon.ec2.ebs.describing.volume:

.. rubric:: Ein EBS Volume beschreiben

*describeVolume* erlaubt es Informationen über ein EBS Volume oder ein Set von EBS Volums zu erhalten. Wenn nichts
angegeben wird, werden alle EBS Volums zurück gegeben. Wenn nur ein EBS Volume beschrieben werden soll, kann ein
String übergeben werden, wärend ein Array von EBS Volume Id's übergeben werden können um diese zu beschreiben.

*describeVolume* gibt ein Array mit Informationen über jedes Volume zurück. Dieses enthält die volumeId, size,
status und createTime. Wenn das Volume an eine Instanz angehängt ist, wird ein zusätzlicher Wert attachmentSet
zurückgegeben. Ein gesetztes Attachment enthält Informationen über die Instanz bei der das EBS Volume angehängt
ist. Diese enthalten volumeId, instanceId, device, status und attachTime.

.. code-block:: php
   :linenos:

   $ec2_ebs = new Zend\Service\Amazon\Ec2\Ebs('aws_key','aws_secret_key');
   $return = $ec2_ebs->describeVolume('volumeId');

.. _zend.service.amazon.ec2.ebs.describing.attachedvolumes:

.. rubric:: Angehängte Volumes beschreiben

Um eine Liste der EBS Volumes, die einer laufenden Instanz aktuell angehängt sind, zurückzugeben kann man diese
Methode aufrufen. Sie gibt nur EBS Volumes zurück die Instanzen angehängt sind, welche die übergebene instanceId
haben.

*describeAttachedVolumes* gibt die gleichen Informationen wie *describeVolume* zurück, allerdings nur für die EBS
Volumes die der spezifizierten instanceId aktuell angehängt sind.

.. code-block:: php
   :linenos:

   $ec2_ebs = new Zend\Service\Amazon\Ec2\Ebs('aws_key','aws_secret_key');
   $return = $ec2_ebs->describeAttachedVolumes('instanceId');

.. _zend.service.amazon.ec2.ebs.describing.snapshot:

.. rubric:: Einen EBS Volume Snapshot beschreiben

*describeSnapshot* erlaub es Informationen über einen EBS Volume Snapshot oder ein Set von EBS Volume Snapshots zu
erhalten. Wenn nichts übergeben wurde, dann werden Informationen über alle EBS Volume Snapshots zurückgegeben.
Wenn nur die Beschreibung eines EBS Volume Snapshot benötigt wird kann dessen snapshotId übergeben werden,
wärend ein Array von EBS Volume Snapshot Id's übergeben werden kann um mehrere zu beschreiben.

*describeSnapshot* gibt ein Array mit Informationen über jedes EBS Volume Snapshot zurück. Dieses enthält
snapshotId, volumeId, status, startTime und progress.

.. code-block:: php
   :linenos:

   $ec2_ebs = new Zend\Service\Amazon\Ec2\Ebs('aws_key','aws_secret_key');
   $return = $ec2_ebs->describeSnapshot('volumeId');

.. _zend.service.amazon.ec2.ebs.attachdetach:

Anhängen und Entfernen von Volumes an Instanzen
-----------------------------------------------

.. _zend.service.amazon.ec2.ebs.attachdetach.attach:

.. rubric:: Ein EBS Volume anhängen

*attachVolume* hängt ein EBS Volume an eine laufende Instanz an. Um ein Volume anzuhängen muß man die volumeId,
die instanceId und das device **(ex: /dev/sdh)** spezifizieren.

*attachVolume* gibt ein Array mit Informationen über über den angehängten Status zurück. Dieses enthält
volumeId, instanceId, device, status und attachTime.

.. code-block:: php
   :linenos:

   $ec2_ebs = new Zend\Service\Amazon\Ec2\Ebs('aws_key','aws_secret_key');
   $return = $ec2_ebs->attachVolume('volumeId', 'instanceid', '/dev/sdh');

.. _zend.service.amazon.ec2.ebs.attachdetach.detach:

.. rubric:: Ein EBS Volume entfernen

*detachVolume* entfernt ein EBS Volume von einer laufenden Instanz. *detachVolume* benötigt die Spezifikation der
volumeId mit der optionalen instanceId und dem device name die beim Anhängen des Volumes angegeben wurden. Wenn
man das Entfernen erzwingen will kann man den vierten Parameter auf ``TRUE`` setzen und er wird das Volume
zwangsweise entfernen.

*detachVolume* gibt ein Array zurück das Statusinformationen über das EBS Volume enthält. Diese sind volumeId,
instanceId, device, status und attachTime.

.. code-block:: php
   :linenos:

   $ec2_ebs = new Zend\Service\Amazon\Ec2\Ebs('aws_key','aws_secret_key');
   $return = $ec2_ebs->detachVolume('volumeId');

.. note::

   **Erzwungene Entfernung**

   Man sollte eine Entfernung nur dann erzwingen wenn der vorhergehende Entfernungsversuch nicht sauber
   durchgeführt wurde (Loggen in eine Instanz, das Volume unmounten, und normal entfernen). Diese Option kann zu
   Datenverlusten oder einem beschädigten Dateisystem führen. Diese Option sollte nur als letzter Weg verwendet
   werden um ein Volume von einer fehlerhaften Instanz zu entfernen. Die Instanz hat keine Möglichkeit die Caches
   vom Dateisystem zu flushen oder die Metadaten des Dateisystems. Wenn man diese Option verwendet muß man
   anschließend eine Prüfung des Dateisystems und Reparatur Maßnahmen durchführen.

.. _zend.service.amazon.ec2.ebs.deleting:

EBS Volumes und Snapshots löschen
---------------------------------

.. _zend.service.amazon.ec2.ebs.deleting.volume:

.. rubric:: Löschen eines EBS Volums

*deleteVolume* löscht ein entferntes EBS Volume.

*deleteVolume* gibt ein boolsches ``TRUE`` oder ``FALSE`` zurück.

.. code-block:: php
   :linenos:

   $ec2_ebs = new Zend\Service\Amazon\Ec2\Ebs('aws_key','aws_secret_key');
   $return = $ec2_ebs->deleteVolume('volumeId');

.. _zend.service.amazon.ec2.ebs.deleting.snapshot:

.. rubric:: Löschen eines EBS Volume Snapshots

*deleteSnapshot* löscht einen EBS Volume Snapshot.

*deleteSnapshot* gibt ein boolsches ``TRUE`` oder ``FALSE`` zurück.

.. code-block:: php
   :linenos:

   $ec2_ebs = new Zend\Service\Amazon\Ec2\Ebs('aws_key','aws_secret_key');
   $return = $ec2_ebs->deleteSnapshot('snapshotId');


