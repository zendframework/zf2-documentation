
Zend\\Cloud\\Infrastructure
===========================

.. _zend.cloud.infrastructure.intro:

Overview
--------

The ``Zend\Cloud\Infrastructure`` is a class to manage different cloud computing infrastructures using a common *API* .

In order to provide a common class API for different cloud vendors we implemented a small set of basic operations for the management of instances (servers) in a cloud infrastructure. These basic operations are:

    - create a new instance;
    - delete a new instance;
    - start/stop an instance;
    - reboot an instance;
    - list of the available instances;
    - get the status of an instance;
    - wait for a status change of an instance;
    - get the public IP or DNS name of the instance;
    - list all the available images for new instances;
    - list all the available geographical zones for new instances;
    - monitor an instance getting the systems information (CPU%, RAM%, DISK%, NETWORK% usage);
    - deploy of an instance (run arbitrary shell script on an instance);


.. note::
    **Deployment of an instance**

    For the deploy operations we used the `SSH2 PHP extension (ext/ssh2)`_ to connect on an instance and execute shell script. The SSH2 extensions can be used to connect only to Gnu/Linux instances (servers).

This class is managed by a factory to initialize specific cloud computing adapters.

.. _zend.cloud.infrastructure.quick-start:

Quick Start
-----------

To use this class you have to initialize the factory with a specific adapters. You can check the supported apadters in the specific Chapter :ref:`Zend\\Cloud\\Infrastructure\\Adapter <zend.cloud.infrastructure.adapter>` . We are planning to support other cloud computing vendors very soon.

For instance, to work with the AMAZON EC2 adapter you have to initialize the class with following parameters:

.. code-block:: php
    :linenos:
    
    use Zend\Cloud\Infrastructure\Adapter\Ec2 as Ec2Adapter,
        Zend\Cloud\Infrastructure\Factory as FactoryInfrastructure;
    
    $key    = 'key';
    $secret = 'secret';
    $region = 'region';
    
    $infrastructure = FactoryInfrastructure::getAdapter(array( 
        FactoryInfrastructure::INFRASTRUCTURE_ADAPTER_KEY => 'Zend\Cloud\Infrastructure\Adapter\Ec2', 
        Ec2Adapter::AWS_ACCESS_KEY => $key, 
        Ec2Adapter::AWS_SECRET_KEY => $secret,
        Ec2Adapter::AWS_REGION     => $region,
    )); 
    

``Zend\Cloud\Infrastructure`` has only a couple of methods that are vendor specific. These methods are the creation of a new instance and the monitoring of an instance. For instance, below is reported an example that shows how to create a new instance using the Amazon EC2 adapter:

.. code-block:: php
    :linenos:
    
    $param= array (
        'imageId'      => 'your-image-id',
        'instanceType' => 'your-instance-type',
    );
    
    $instance= $infrastructure->createInstance('name of the instance', $param);
    
    printf ("Name of the instance: %s\n", $instance->getName());
    printf ("ID of the instance  : %s\n", $instance->getId());
    

The interface of the ``createInstance`` is always the same, only the content of$paramis specific to the adapter. for more information about the adapter supported by Zend\\Cloud\\Infrastructure go to the specific :ref:`page of the manual <zend.cloud.infrastructure.adapter>` .

The ``Zend\Cloud\Infrastructure`` uses the classes ``Zend\Cloud\Infrastructure\Instance`` and ``Zend\Cloud\Infrastructure\Image`` to manage the instances (servers) and the images of an instance.

.. _zend.cloud.infrastructure.methods:

Available Methods
-----------------

.. _zend.cloud.infrastructure.methods.create-instance:


**createInstancestring $name, array $options**


Create an instance. The return value is an instance of ``Zend\Cloud\Infrastructure\Instance`` . In case of error the return isfalse.

$nameis the name of the instance to create

$optionsis the array contains the specific parameter for the cloud adapter. For more info read the Chapter of :ref:`Zend\\Cloud\\Infrastructure\\Adapter <zend.cloud.infrastructure.adapter>` .

.. _zend.cloud.infrastructure.methods.deploy-instance:


**deployInstancestring $id, array $param, string|array $cmd**


Run arbitrary shell scripts on an instance. Return a string or an array contains all the standard output (errors included) of the scripts executed in the instance.
.. note::
    **Requirement**

    In order to use the deployInstance method you have to install the SSH2 extension (ext/ssh2) of PHP. The SSH2 extensions can be used to connect only to Gnu/Linux instances (servers). For more info about the SSH2 extension, `click here`_ .


$idis the ID of the instance

$paramis an array contains the username and the password to be used for the SSH connection. The username and the password must be specified using the following constants key of the ``Zend\Cloud\Infrastructure\Instance`` : SSH_USERNAME, SSH_PASSWORD.

$cmdis a string (or an array) contains the commands line to be executed in the instance.

.. _zend.cloud.infrastructure.methods.destroy-instance:


**destroyInstancestring $id**


Destroy an instance. Returntruein case of success,falsein case of error.

$idis the ID of the instance

.. _zend.cloud.infrastructure.methods.get-adapter:


**getAdapter**


Return the adapter object.

.. _zend.cloud.infrastructure.methods.get-adapter-result:


**getAdapterResult**


Return the original adapter result.

.. _zend.cloud.infrastructure.methods.get-last-http-request:


**getLastHttpRequest**


Return the last HTTP Request of the adapter.

.. _zend.cloud.infrastructure.methods.get-last-http-response:


**getLastHttpResponse**


Return the last HTTP Response of the adapter.

.. _zend.cloud.infrastructure.methods.images-instance:


**imagesInstance**


Return all the available images to use for an instance. The return value is an instance of ``Zend\Cloud\Infrastructure\ImageList`` 

.. _zend.cloud.infrastructure.methods.list-instances:


**listInstances**


Return the list of of the available instances. The return is an instance of ``Zend\Cloud\Infrastructure\InstanceList`` .

.. _zend.cloud.infrastructure.methods.monitor-instance:


**monitorInstancestring $id,string $metric,array $options=null**


Monitor an instance. Return the system information about the metric of an instance. The return value is an array that contains samples of values, timestamp and the elaboration of the average value.

$idis the ID of the instance;

$metricis the metric to be monitored. The allowed metrics are reported as contants of the ``Zend\Cloud\Infrastructure\Instance`` class: MONITOR_CPU, MONITOR_RAM, MONITOR_NETWORK_IN, MONITOR_NETWORK_OUT, MONITOR_DISK, MONITOR_DISK_WRITE, MONITOR_DISK_READ.

$optionsis the optional array contains the adapter specific options.

.. _zend.cloud.infrastructure.methods.public-dns-instance:


**publicDnsInstancestring $id**


Return the public DNS name or the IP address of the instance. The return value is a string. In case of error the return isfalse.

$idis the ID of the instance

.. _zend.cloud.infrastructure.methods.reboot-instance:


**rebootInstancestring $id**


Reboot an instance. Returntruein case of success,falsein case of error.

$idis the ID of the instance

.. _zend.cloud.infrastructure.methods.start-instance:


**startInstancestring $id**


Start an instance. Returntruein case of success,falsein case of error.

$idis the ID of the instance

.. _zend.cloud.infrastructure.methods.status-instance:


**statusInstancestring $id**


Get the status of an instance. The return value is a string. The available status are reported in the following constants of the class ``Zend\Cloud\Infrastructure\Instance`` : STATUS_STOPPED, STATUS_RUNNING, STATUS_SHUTTING_DOWN, STATUS_REBOOTING, STATUS_TERMINATED, STATUS_PENDING, STATUS_REBUILD. In case of error the return isfalse.

$idis the ID of the instance

.. _zend.cloud.infrastructure.methods.stop-instance:


**stopInstancestring $id**


Stop an instance. Returntruein case of success,falsein case of error.

$idis the ID of the instance

.. _zend.cloud.infrastructure.methods.wait-status-instance:


**waitStatusInstancestring $id, string $status,integer $timeout=30**


Wait the status change of an instance for a maximum time ofnseconds. Returntrueif the status changes as expected,falseif not.

$idis the ID of the instance;

$statusis the status to wait for;

$timeoutis the maximum time, in seconds, to wait for the status change. This parametr is optional and the default value is 30 seconds.

.. _zend.cloud.infrastructure.methods.zones-instance:


**zonesInstance**


Return all the available zones for an instance. The return value is an array.

.. _zend.cloud.infrastructure.examples:

Examples
--------

.. _zend.cloud.infrastructure.examples.authenticate:

Get the datetime system information of an instance
--------------------------------------------------

Get the result of thedatecommand line.

.. code-block:: php
    :linenos:
    
    $param = array (
        Instance::SSH_USERNAME => 'username',
        Instance::SSH_PASSWORD => 'password',
    );
    
    $cmd    = 'date';
    $output = $infrastructure->deployInstance('instance-id', $param, $cmd);
    
    echo $output;
    

.. _zend.cloud.infrastructure.examples.get-datetime:

Get the datetime system information of an instance
--------------------------------------------------

Get the result of thedatecommand line.

.. code-block:: php
    :linenos:
    
    $param = array (
        Instance::SSH_USERNAME => 'username',
        Instance::SSH_PASSWORD => 'password',
    );
    
    $cmd    = 'date';
    $output = $infrastructure->deployInstance('instance-id', $param, $cmd);
    
    echo $output;
    

.. _zend.cloud.infrastructure.examples.reboot:

Reboot an instance and wait for the running status
--------------------------------------------------

Reboot an instance and wait 60 seconds for the running status.

.. code-block:: php
    :linenos:
    
    use Zend\Cloud\Infrastructure\Instance;
    
    if (!$infrastructure->rebootInstance('instance-id')) {
        die ('Error in the execution of the reboot command');
    }
    echo 'Reboot command executed successfully';
    
    if ($rackspace->waitStatusInstance('instance-id', Instance::STATUS_RUNNING, 60)) {
        echo 'The instance is ready';
    } else {
        echo 'The instance is not ready yet';
    }
    


.. _`SSH2 PHP extension (ext/ssh2)`: http://www.php.net/manual/en/book.ssh2.php
.. _`click here`: http://www.php.net/manual/en/book.ssh2.php
