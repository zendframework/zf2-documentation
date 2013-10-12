.. _zendservice.amazon.ec2.reserved.instance:

ZendService\Amazon\Ec2: Reserved Instances
===========================================

With Amazon *EC2* Reserved Instances, you can make a low one-time payment for each instance to reserve and receive
a significant discount on the hourly usage charge for that instance.

Amazon *EC2* Reserved Instances are based on instance type and location (region and Availability Zone) for a
specified period of time (e.g., 1 year or 3 years) and are only available for Linux or UNIX instances.

.. _zendservice.amazon.ec2.reserved.instance.howitworks:

How Reserved Instances are Applied
----------------------------------

Reserved Instances are applied to instances that meet the type/location criteria during the specified period. In
this example, a user is running the following instances:

- (4) m1.small instances in Availability Zone us-east-1a

- (4) c1.medium instances in Availability Zone us-east-1b

- (2) c1.xlarge instances in Availability Zone us-east-1b

The user then purchases the following Reserved Instances.

- (2) m1.small instances in Availability Zone us-east-1a

- (2) c1.medium instances in Availability Zone us-east-1a

- (2) m1.xlarge instances in Availability Zone us-east-1a

Amazon *EC2* applies the two m1.small Reserved Instances to two of the instances in Availability Zone us-east-1a.
Amazon *EC2* doesn't apply the two c1.medium Reserved Instances because the c1.medium instances are in a different
Availability Zone and does not apply the m1.xlarge Reserved Instances because there are no running m1.xlarge
instances.

.. _zendservice.amazon.ec2.reserved.instance.operations:

Reserved Instances Usage
------------------------

.. _zendservice.amazon.ec2.reserved.instance.operations.describe:

.. rubric:: Describes Reserved Instances that you purchased

``describeInstances()`` will return information about a reserved instance or instances that you purchased.

``describeInstances()`` returns a multi-dimensional array that contains reservedInstancesId, instanceType,
availabilityZone, duration, fixedPrice, usagePrice, productDescription, instanceCount and state.

.. code-block:: php
   :linenos:

   $ec2_instance = new ZendService\Amazon\Ec2\Instance\Reserved('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_instance->describeInstances('instanceId');

.. _zendservice.amazon.ec2.reserved.instance.offerings.describe:

.. rubric:: Describe current Reserved Instance Offerings available

``describeOfferings()`` Describes Reserved Instance offerings that are available for purchase. With Amazon *EC2*
Reserved Instances, you purchase the right to launch Amazon *EC2* instances for a period of time (without getting
insufficient capacity errors) and pay a lower usage rate for the actual time used.

``describeOfferings()`` returns a multi-dimensional array that contains reservedInstancesId, instanceType,
availabilityZone, duration, fixedPrice, usagePrice and productDescription.

.. code-block:: php
   :linenos:

   $ec2_instance = new ZendService\Amazon\Ec2\Instance\Reserved('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_instance->describeOfferings();

.. _zendservice.amazon.ec2.reserved.instance.offerings.purchase:

.. rubric:: Turn off CloudWatch Monitoring on an Instance(s)

``purchaseOffering()`` Purchases a Reserved Instance for use with your account. With Amazon *EC2* Reserved
Instances, you purchase the right to launch Amazon *EC2* instances for a period of time (without getting
insufficient capacity errors) and pay a lower usage rate for the actual time used.

``purchaseOffering()`` returns the reservedInstanceId.

.. code-block:: php
   :linenos:

   $ec2_instance = new ZendService\Amazon\Ec2\Instance\Reserved('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_instance->purchaseOffering('offeringId', 'instanceCount');


