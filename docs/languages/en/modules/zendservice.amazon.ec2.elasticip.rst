.. _zendservice.amazon.ec2.elasticip:

ZendService\Amazon\Ec2: Elastic IP Addresses
=============================================

By default, all Amazon EC2 instances are assigned two IP addresses at launch: a private (RFC 1918) address and a
public address that is mapped to the private IP address through Network Address Translation (NAT).

If you use dynamic DNS to map an existing DNS name to a new instance's public IP address, it might take up to 24
hours for the IP address to propagate through the Internet. As a result, new instances might not receive traffic
while terminated instances continue to receive requests.

To solve this problem, Amazon EC2 provides elastic IP addresses. Elastic IP addresses are static IP addresses
designed for dynamic cloud computing. Elastic IP addresses are associated with your account, not specific
instances. Any elastic IP addresses that you associate with your account remain associated with your account until
you explicitly release them. Unlike traditional static IP addresses, however, elastic IP addresses allow you to
mask instance or Availability Zone failures by rapidly remapping your public IP addresses to any instance in your
account.

.. _zendservice.amazon.ec2.elasticip.allocate:

.. rubric:: Allocating a new Elastic IP

*allocate* will assign your account a new Elastic IP Address.

*allocate* returns the newly allocated ip.

.. code-block:: php
   :linenos:

   $ec2_eip = new ZendService\Amazon\Ec2\Elasticip('aws_key','aws_secret_key');
   $ip = $ec2_eip->allocate();

   // print out your newly allocated elastic ip address;
   print $ip;

.. _zendservice.amazon.ec2.elasticip.describe:

.. rubric:: Describing Allocated Elastic IP Addresses

*describe* has an optional parameter to describe all of your allocated Elastic IP addresses or just some of your
allocated addresses.

*describe* returns an array that contains information on each Elastic IP Address which contains the publicIp and
the instanceId if it is associated.

.. code-block:: php
   :linenos:

   $ec2_eip = new ZendService\Amazon\Ec2\Elasticip('aws_key','aws_secret_key');
   // describe all
   $ips = $ec2_eip->describe();

   // describe a subset
   $ips = $ec2_eip->describe(array('ip1', 'ip2', 'ip3'));

   // describe a single ip address
   $ip = $ec2_eip->describe('ip1');

.. _zendservice.amazon.ec2.elasticip.release:

.. rubric:: Releasing Elastic IP

*release* will release an Elastic IP to Amazon.

Returns a boolean ``TRUE`` or ``FALSE``.

.. code-block:: php
   :linenos:

   $ec2_eip = new ZendService\Amazon\Ec2\Elasticip('aws_key','aws_secret_key');
   $ec2_eip->release('ipaddress');

.. _zendservice.amazon.ec2.elasticip.associate:

.. rubric:: Associates an Elastic IP to an Instance

*associate* will assign an Elastic IP to an already running instance.

Returns a boolean ``TRUE`` or ``FALSE``.

.. code-block:: php
   :linenos:

   $ec2_eip = new ZendService\Amazon\Ec2\Elasticip('aws_key','aws_secret_key');
   $ec2_eip->associate('instance_id', 'ipaddress');

.. _zendservice.amazon.ec2.elasticip.disassociate:

.. rubric:: Disassociate an Elastic IP from an instance

*disassociate* will disassociate an Elastic IP from an instance. If you terminate an Instance it will automatically
disassociate the Elastic IP address for you.

Returns a boolean ``TRUE`` or ``FALSE``.

.. code-block:: php
   :linenos:

   $ec2_eip = new ZendService\Amazon\Ec2\Elasticip('aws_key','aws_secret_key');
   $ec2_eip->disassociate('ipaddress');


