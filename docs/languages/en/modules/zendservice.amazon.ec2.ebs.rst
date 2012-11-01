.. _zendservice.amazon.ec2.ebs:

ZendService\Amazon\Ec2: Elastic Block Storage (EBS)
====================================================

Amazon Elastic Block Store (Amazon EBS) is a new type of storage designed specifically for Amazon EC2 instances.
Amazon EBS allows you to create volumes that can be mounted as devices by Amazon EC2 instances. Amazon EBS volumes
behave like raw unformatted external block devices. They have user supplied device names and provide a block device
interface. You can load a file system on top of Amazon EBS volumes, or use them just as you would use a block
device.

You can create up to twenty Amazon EBS volumes of any size (from one GiB up to one TiB). Each Amazon EBS volume can
be attached to any Amazon EC2 instance in the same Availability Zone or can be left unattached.

Amazon EBS provides the ability to create snapshots of your Amazon EBS volumes to Amazon S3. You can use these
snapshots as the starting point for new Amazon EBS volumes and can protect your data for long term durability.

.. _zendservice.amazon.ec2.ebs.creating:

Create EBS Volumes and Snapshots
--------------------------------

.. _zendservice.amazon.ec2.ebs.creating.volume:

.. rubric:: Create a new EBS Volume

Creating a brand new EBS Volume requires the size and which zone you want the EBS Volume to be in.

*createNewVolume* will return an array containing information about the new Volume which includes the volumeId,
size, zone, status and createTime.

.. code-block:: php
   :linenos:

   $ec2_ebs = new ZendService\Amazon\Ec2\Ebs('aws_key','aws_secret_key');
   $return = $ec2_ebs->createNewVolume(40, 'us-east-1a');

.. _zendservice.amazon.ec2.ebs.creating.volumesnapshot:

.. rubric:: Create an EBS Volume from a Snapshot

Creating an EBS Volume from a snapshot requires the snapshot_id and which zone you want the EBS Volume to be in.

*createVolumeFromSnapshot* will return an array containing information about the new Volume which includes the
volumeId, size, zone, status, createTime and snapshotId.

.. code-block:: php
   :linenos:

   $ec2_ebs = new ZendService\Amazon\Ec2\Ebs('aws_key','aws_secret_key');
   $return = $ec2_ebs->createVolumeFromSnapshot('snap-78a54011', 'us-east-1a');

.. _zendservice.amazon.ec2.ebs.creating.snapshot:

.. rubric:: Create a Snapshot of an EBS Volume

Creating a Snapshot of an EBS Volume requires the volumeId of the EBS Volume.

*createSnapshot* will return an array containing information about the new Volume Snapshot which includes the
snapshotId, volumeId, status, startTime and progress.

.. code-block:: php
   :linenos:

   $ec2_ebs = new ZendService\Amazon\Ec2\Ebs('aws_key','aws_secret_key');
   $return = $ec2_ebs->createSnapshot('volumeId');

.. _zendservice.amazon.ec2.ebs.describing:

Describing EBS Volumes and Snapshots
------------------------------------

.. _zendservice.amazon.ec2.ebs.describing.volume:

.. rubric:: Describing an EBS Volume

*describeVolume* allows you to get information on an EBS Volume or a set of EBS Volumes. If nothing is passed in
then it will return all EBS Volumes. If only one EBS Volume needs to be described a string can be passed in while
an array of EBS Volume Id's can be passed in to describe them.

*describeVolume* will return an array with information about each Volume which includes the volumeId, size, status
and createTime. If the volume is attached to an instance, an addition value of attachmentSet will be returned. The
attachment set contains information about the instance that the EBS Volume is attached to, which includes volumeId,
instanceId, device, status and attachTime.

.. code-block:: php
   :linenos:

   $ec2_ebs = new ZendService\Amazon\Ec2\Ebs('aws_key','aws_secret_key');
   $return = $ec2_ebs->describeVolume('volumeId');

.. _zendservice.amazon.ec2.ebs.describing.attachedvolumes:

.. rubric:: Describe Attached Volumes

To return a list of EBS Volumes currently attached to a running instance you can call this method. It will only
return EBS Volumes attached to the instance with the passed in instanceId.

*describeAttachedVolumes* returns the same information as the *describeVolume* but only for the EBS Volumes that
are currently attached to the specified instanceId.

.. code-block:: php
   :linenos:

   $ec2_ebs = new ZendService\Amazon\Ec2\Ebs('aws_key','aws_secret_key');
   $return = $ec2_ebs->describeAttachedVolumes('instanceId');

.. _zendservice.amazon.ec2.ebs.describing.snapshot:

.. rubric:: Describe an EBS Volume Snapshot

*describeSnapshot* allows you to get information on an EBS Volume Snapshot or a set of EBS Volume Snapshots. If
nothing is passed in then it will return information about all EBS Volume Snapshots. If only one EBS Volume
Snapshot needs to be described its snapshotId can be passed in while an array of EBS Volume Snapshot Id's can be
passed in to describe them.

*describeSnapshot* will return an array containing information about each EBS Volume Snapshot which includes the
snapshotId, volumeId, status, startTime and progress.

.. code-block:: php
   :linenos:

   $ec2_ebs = new ZendService\Amazon\Ec2\Ebs('aws_key','aws_secret_key');
   $return = $ec2_ebs->describeSnapshot('volumeId');

.. _zendservice.amazon.ec2.ebs.attachdetach:

Attach and Detaching Volumes from Instances
-------------------------------------------

.. _zendservice.amazon.ec2.ebs.attachdetach.attach:

.. rubric:: Attaching an EBS Volume

*attachVolume* will attach an EBS Volume to a running Instance. To attach a volume you need to specify the
volumeId, the instanceId and the device **(ex: /dev/sdh)**.

*attachVolume* will return an array with information about the attach status which contains volumeId, instanceId,
device, status and attachTime

.. code-block:: php
   :linenos:

   $ec2_ebs = new ZendService\Amazon\Ec2\Ebs('aws_key','aws_secret_key');
   $return = $ec2_ebs->attachVolume('volumeId', 'instanceid', '/dev/sdh');

.. _zendservice.amazon.ec2.ebs.attachdetach.detach:

.. rubric:: Detaching an EBS Volume

*detachVolume* will detach an EBS Volume from a running Instance. *detachVolume* requires that you specify the
volumeId with the optional instanceId and device name that was passed when attaching the volume. If you need to
force the detachment you can set the fourth parameter to be ``TRUE`` and it will force the volume to detach.

*detachVolume* returns an array containing status information about the EBS Volume which includes volumeId,
instanceId, device, status and attachTime.

.. code-block:: php
   :linenos:

   $ec2_ebs = new ZendService\Amazon\Ec2\Ebs('aws_key','aws_secret_key');
   $return = $ec2_ebs->detachVolume('volumeId');

.. note::

   **Forced Detach**

   You should only force a detach if the previous detachment attempt did not occur cleanly (logging into an
   instance, unmounting the volume, and detaching normally). This option can lead to data loss or a corrupted file
   system. Use this option only as a last resort to detach a volume from a failed instance. The instance will not
   have an opportunity to flush file system caches or file system meta data. If you use this option, you must
   perform file system check and repair procedures.

.. _zendservice.amazon.ec2.ebs.deleting:

Deleting EBS Volumes and Snapshots
----------------------------------

.. _zendservice.amazon.ec2.ebs.deleting.volume:

.. rubric:: Deleting an EBS Volume

*deleteVolume* will delete an unattached EBS Volume.

*deleteVolume* will return boolean ``TRUE`` or ``FALSE``.

.. code-block:: php
   :linenos:

   $ec2_ebs = new ZendService\Amazon\Ec2\Ebs('aws_key','aws_secret_key');
   $return = $ec2_ebs->deleteVolume('volumeId');

.. _zendservice.amazon.ec2.ebs.deleting.snapshot:

.. rubric:: Deleting an EBS Volume Snapshot

*deleteSnapshot* will delete an EBS Volume Snapshot.

*deleteSnapshot* returns boolean ``TRUE`` or ``FALSE``.

.. code-block:: php
   :linenos:

   $ec2_ebs = new ZendService\Amazon\Ec2\Ebs('aws_key','aws_secret_key');
   $return = $ec2_ebs->deleteSnapshot('snapshotId');


