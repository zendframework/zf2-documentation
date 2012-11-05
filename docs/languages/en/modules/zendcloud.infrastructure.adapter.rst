.. _zendcloud.infrastructure.adapter:

Zend\\Cloud\\Infrastructure\\Adapter
====================================

.. _zendcloud.infrastructure.adapter.intro:

Adapters
--------

The ``Zend\Cloud\Infrastructure`` supports the following adapters:

- `Amazon EC2`_;

- `Rackspace Cloud Servers`_.

.. _zendcloud.infrastructure.adapter.ec2:

AMAZON EC2
----------

To initialize the AMAZON EC2 adapter you have to use the following code:

.. code-block:: php
   :linenos:

   use Zend\Cloud\Infrastructure\Adapter\Ec2 as Ec2Adapter;
   use Zend\Cloud\Infrastructure\Factory as FactoryInfrastructure;

   $key    = 'key';
   $secret = 'secret';
   $region = 'region';

   $infrastructure = FactoryInfrastructure::getAdapter(array(
       FactoryInfrastructure::INFRASTRUCTURE_ADAPTER_KEY => 'Zend\Cloud\Infrastructure\Adapter\Ec2',
       Ec2Adapter::AWS_ACCESS_KEY => $key,
       Ec2Adapter::AWS_SECRET_KEY => $secret,
       Ec2Adapter::AWS_REGION     => $region,
   ));

To create a new instance for AMAZON EC2 adapter you have to use the following parameters:

.. code-block:: php
   :linenos:

   $param = array (
       'imageId'      => 'your-image-id',
       'instanceType' => 'your-instance-type',
   );

   $instance = $infrastructure->createInstance('name of the instance', $param);

   printf("Name of the instance: %s\n", $instance->getName());
   printf("ID of the instance  : %s\n", $instance->getId());

The monitor an instance of AMAZON EC2 you can use the starting time and ending time optional parameters. The times
must be specified using the ISO 8601 format.

.. code-block:: php
   :linenos:

   use Zend\Cloud\Infrastructure\Instance;

   $options= array (
       Instance::MONITOR_START_TIME => '2008-02-26T19:00:00+00:00',
       Instance::MONITOR_END_TIME   => '2008-02-26T20:00:00+00:00',
   );

   $cpuUsage= $infrastructure->monitorInstance('id-instance', Instance::MONITOR_CPU, $options);

   print_r($cpuUsage);

The **instanceType** parameter is optional. This parameter specify the type of the instance to create (for
instance, 't1.micro').

.. _zendcloud.infrastructure.adapter.rackspace:

Rackspace Cloud Servers
-----------------------

To initialize the Rackspace Cloud Servers adapter you have to use the following code:

.. code-block:: php
   :linenos:

   use Zend\Cloud\Infrastructure\Adapter\Rackspace as RackspaceAdapter;
   use Zend\Cloud\Infrastructure\Factory as FactoryInfrastructure;

   $user = 'username';
   $key  = 'API key';

   $infrastructure = FactoryInfrastructure::getAdapter(array(
       FactoryInfrastructure::INFRASTRUCTURE_ADAPTER_KEY => 'Zend\Cloud\Infrastructure\Adapter\Rackspace',
       RackspaceAdapter::RACKSPACE_USER => $user,
       RackspaceAdapter::RACKSPACE_KEY  => $key,
   ));

To create a new instance for Rackspace Cloud Servers adapter you have to use the following parameters:

.. code-block:: php
   :linenos:

   $param = array (
       'imageId'  => 'image-id-of-the-instance',
       'flavorId' => 'flavor-id-of-the-instance',
       'metadata' => array (
           'foo' => 'bar',
       ),
       'file' => array (
           'remote-instance-path' => 'local-path',
       ),
   );

   $instance = $infrastructure->createInstance('name of the instance', $param);

   printf("Name of the instance: %s\n", $instance->getName());
   printf("ID of the instance  : %s\n", $instance->getId());

The **metadata** array and the **file** array are optional parameters.

To monitor an instance of Rackspace Cloud Servers we can use only the SSH2 extension. The Rackspace API does not
offer a dedicated service to monitor the instance. The monitoring features using the SSH2 connection are limited to
the CPU usage, the RAM usage and the DISK usage.

.. code-block:: php
   :linenos:

   $options = array (
       'username' => 'your-username',
       'password' => 'your-password',
   );

   $cpuUsage  = $infrastructure->monitorInstance('id-instance', Instance::MONITOR_CPU, $options);
   $ramUsage  = $infrastructure->monitorInstance('id-instance', Instance::MONITOR_RAM, $options);
   $diskUsage = $infrastructure->monitorInstance('id-instance', Instance::MONITOR_DISK, $options);

   print_r($cpuUsage);
   print_r($ramUsage);
   print_r($diskUsage);

The **$options** contains the username and the password to be used for the SSH connection.



.. _`Amazon EC2`: http://aws.amazon.com/ec2/
.. _`Rackspace Cloud Servers`: http://www.rackspace.com/cloud/cloud_hosting_products/servers/
