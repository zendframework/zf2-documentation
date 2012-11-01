.. _zendservice.amazon.ec2.securitygroups:

ZendService\Amazon\Ec2: Security Groups
========================================

A security group is a named collection of access rules. These access rules specify which ingress (i.e., incoming)
network traffic should be delivered to your instance. All other ingress traffic will be discarded.

You can modify rules for a group at any time. The new rules are automatically enforced for all running instances
and instances launched in the future.

.. note::

   **Maximum Security Groups**

   You can create up to 100 security groups.

.. _zendservice.amazon.ec2.securitygroups.maintenance:

Security Group Maintenance
--------------------------

.. _zendservice.amazon.ec2.securitygroups.maintenance.create:

.. rubric:: Create a new Security Group

*create* a new security group. Every instance is launched in a security group. If no security group is specified
during launch, the instances are launched in the default security group. Instances within the same security group
have unrestricted network access to each other. Instances will reject network access attempts from other instances
in a different security group.

*create* returns boolean ``TRUE`` or ``FALSE``

.. code-block:: php
   :linenos:

   $ec2_sg = new ZendService\Amazon\Ec2\Securitygroups('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_sg->create('mygroup', 'my group description');

.. _zendservice.amazon.ec2.securitygroups.maintenance.describe:

.. rubric:: Describe a Security Group

*describe* returns information about security groups that you own.

If you specify security group names, information about those security groups is returned. Otherwise, information
for all security groups is returned. If you specify a group that does not exist, a fault is returned.

*describe* will return an array containing information about security groups which includes the ownerId, groupName,
groupDescription and an array containing all the rules for that security group.

.. code-block:: php
   :linenos:

   $ec2_sg = new ZendService\Amazon\Ec2\Securitygroups('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_sg->describe('mygroup');

.. _zendservice.amazon.ec2.securitygroups.maintenance.delete:

.. rubric:: Delete a Security Group

*delete* will remove the security group. If you attempt to delete a security group that contains instances, a fault
is returned. If you attempt to delete a security group that is referenced by another security group, a fault is
returned. For example, if security group B has a rule that allows access from security group A, security group A
cannot be deleted until the allow rule is removed.

*delete* returns boolean ``TRUE`` or ``FALSE``.

.. code-block:: php
   :linenos:

   $ec2_sg = new ZendService\Amazon\Ec2\Securitygroups('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_sg->delete('mygroup');

.. _zendservice.amazon.ec2.securitygroups.authorize:

Authorizing Access
------------------

.. _zendservice.amazon.ec2.securitygroups.authorize.ip:

.. rubric:: Authorizing by IP

*authorizeIp* Adds permissions to a security group based on an IP address, protocol type and port range.

Permissions are specified by the IP protocol (TCP, UDP or ICMP), the source of the request (by IP range or an
Amazon EC2 user-group pair), the source and destination port ranges (for *TCP* and UDP), and the ICMP codes and
types (for ICMP). When authorizing ICMP, -1 can be used as a wildcard in the type and code fields.

Permission changes are propagated to instances within the security group as quickly as possible. However, depending
on the number of instances, a small delay might occur.

*authorizeIp* returns boolean ``TRUE`` or ``FALSE``

.. code-block:: php
   :linenos:

   $ec2_sg = new ZendService\Amazon\Ec2\Securitygroups('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_sg->authorizeIp('mygroup',
                                   'protocol',
                                   'fromPort',
                                   'toPort',
                                   'ipRange');

.. _zendservice.amazon.ec2.securitygroups.authorize.group:

.. rubric:: Authorize By Group

*authorizeGroup* Adds permissions to a security group.

Permission changes are propagated to instances within the security group as quickly as possible. However, depending
on the number of instances, a small delay might occur.

*authorizeGroup* returns boolean ``TRUE`` or ``FALSE``.

.. code-block:: php
   :linenos:

   $ec2_sg = new ZendService\Amazon\Ec2\Securitygroups('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_sg->authorizeGroup('mygroup', 'securityGroupName', 'ownerId');

.. _zendservice.amazon.ec2.securitygroups.revoke:

Revoking Access
---------------

.. _zendservice.amazon.ec2.securitygroups.revoke.ip:

.. rubric:: Revoke by IP

*revokeIp* Revokes permissions to a security group based on an IP address, protocol type and port range. The
permissions used to revoke must be specified using the same values used to grant the permissions.

Permissions are specified by the IP protocol (TCP, UDP or ICMP), the source of the request (by IP range or an
Amazon EC2 user-group pair), the source and destination port ranges (for *TCP* and UDP), and the ICMP codes and
types (for ICMP). When authorizing ICMP, -1 can be used as a wildcard in the type and code fields.

Permission changes are propagated to instances within the security group as quickly as possible. However, depending
on the number of instances, a small delay might occur.

*revokeIp* returns boolean ``TRUE`` or ``FALSE``

.. code-block:: php
   :linenos:

   $ec2_sg = new ZendService\Amazon\Ec2\Securitygroups('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_sg->revokeIp('mygroup',
                                'protocol',
                                'fromPort',
                                'toPort',
                                'ipRange');

.. _zendservice.amazon.ec2.securitygroups.revoke.group:

.. rubric:: Revoke By Group

*revokeGroup* Adds permissions to a security group. The permissions to revoke must be specified using the same
values used to grant the permissions.

Permission changes are propagated to instances within the security group as quickly as possible. However, depending
on the number of instances, a small delay might occur.

*revokeGroup* returns boolean ``TRUE`` or ``FALSE``.

.. code-block:: php
   :linenos:

   $ec2_sg = new ZendService\Amazon\Ec2\Securitygroups('aws_key',
                                                        'aws_secret_key');
   $return = $ec2_sg->revokeGroup('mygroup', 'securityGroupName', 'ownerId');


