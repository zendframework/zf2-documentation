.. _zendservice.amazon.ec2.windows.instance:

ZendService\Amazon\Ec2: Windows Instances
==========================================

Using Amazon EC2 instances running Windows is similar to using instances running Linux and UNIX. The following are
the major differences between instances that use Linux or UNIX and Windows:

- Remote Desktop—To access Windows instances, you use Remote Desktop instead of SSH.

- Administrative Password—To access Windows instances the first time, you must obtain the administrative password
  using the ec2-get-password command.

- Simplified Bundling—To bundle a Windows instance, you use a single command that shuts down the instance, saves
  it as an *AMI*, and restarts it.

As part of this service, Amazon EC2 instances can now run Microsoft Windows Server 2003. Our base Windows image
provides you with most of the common functionality associated with Windows. However, if you require more than two
concurrent Windows users or need to leverage applications that require *LDAP*, Kerberos, RADIUS, or other
credential services, you must use Windows with Authentication Services. For example, Microsoft Exchange Server and
Microsoft SharePoint Server require Windows with Authentication Services.

.. note::

   To get started using Windows instances, we recommend using the *AWS* Management Console. There are differences
   in pricing between Windows and Windows with Authentication Services instances. For information on pricing, go to
   the Amazon EC2 Product Page.

Amazon EC2 currently provides the following Windows *AMI*\ s:

- Windows Authenticated (32-bit)

- Windows Authenticated (64-bit)

- Windows Anonymous (32-bit)

- Windows Anonymous (64-bit)

The Windows public *AMI*\ s that Amazon provides are unmodified versions of Windows with the following two
exceptions: we added drivers to improve the networking and disk I/O performance and we created the Amazon EC2
configuration service. The Amazon EC2 configuration service performs the following functions:

- Randomly sets the Administrator password on initial launch, encrypts the password with the user's SSH key, and
  reports it to the console. This operation happens upon initial *AMI* launch. If you change the password, *AMI*\ s
  that are created from this instance use the new password.

- Configures the computer name to the internal DNS name. To determine the internal DNS name, see Using Instance
  Addressing.

- Sends the last three system and application errors from the event log to the console. This helps developers to
  identify problems that caused an instance to crash or network connectivity to be lost.

.. _zendservice.amazon.ec2.windows.instance.operations:

Windows Instances Usage
-----------------------

.. _zendservice.amazon.ec2.windows.instance.operations.bundle:

.. rubric:: Bundles an Amazon EC2 instance running Windows

``bundle()`` has three require parameters and one optional

- **instanceId** The instance you want to bundle

- **s3Bucket** Where you want the ami to live on S3

- **s3Prefix** The prefix you want to assign to the *AMI* on S3

- **uploadExpiration** The expiration of the upload policy. Amazon recommends 12 hours or longer. This is based in
  number of minutes. Default is 1440 minutes (24 hours)

``bundle()`` returns a multi-dimensional array that contains instanceId, bundleId, state, startTime, updateTime,
progress s3Bucket and s3Prefix.

.. code-block:: php
   :linenos:

   $ec2_instance = new ZendService\Amazon\Ec2\Instance\Windows('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_instance->bundle('instanceId', 's3Bucket', 's3Prefix');

.. _zendservice.amazon.ec2.windows.instance.operations.describe:

.. rubric:: Describes current bundling tasks

``describeBundle()`` Describes current bundling tasks

``describeBundle()`` returns a multi-dimensional array that contains instanceId, bundleId, state, startTime,
updateTime, progress s3Bucket and s3Prefix.

.. code-block:: php
   :linenos:

   $ec2_instance = new ZendService\Amazon\Ec2\Instance\Windows('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_instance->describeBundle('bundleId');

.. _zendservice.amazon.ec2.windows.instance.operations.cancel:

.. rubric:: Cancels an Amazon EC2 bundling operation

``cancelBundle()`` Cancels an Amazon EC2 bundling operation

``cancelBundle()`` returns a multi-demential array that contains instanceId, bundleId, state, startTime,
updateTime, progress s3Bucket and s3Prefix.

.. code-block:: php
   :linenos:

   $ec2_instance = new ZendService\Amazon\Ec2\Instance\Windows('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_instance->cancelBundle('bundleId');


