.. _zendservice.amazon.ec2.keypairs:

ZendService\Amazon\Ec2: Keypairs
=================================

Keypairs are used to access instances.

.. _zendservice.amazon.ec2.keypairs.create:

.. rubric:: Creating a new Amazon Keypair

*create*, creates a new 2048 bit RSA key pair and returns a unique ID that can be used to reference this key pair
when launching new instances.

*create* returns an array which contains the keyName, keyFingerprint and keyMaterial.

.. code-block:: php
   :linenos:

   $ec2_kp = new ZendService\Amazon\Ec2\Keypair('aws_key','aws_secret_key');
   $return = $ec2_kp->create('my-new-key');

.. _zendservice.amazon.ec2.keypairs.delete:

.. rubric:: Deleting an Amazon Keypair

*delete*, will delete the key pair. This will only prevent it from being used with new instances. Instances
currently running with the keypair will still allow you to access them.

*delete* returns boolean ``TRUE`` or ``FALSE``

.. code-block:: php
   :linenos:

   $ec2_kp = new ZendService\Amazon\Ec2\Keypair('aws_key','aws_secret_key');
   $return = $ec2_kp->delete('my-new-key');

.. _zendservice.amazon.ec2.describe:

.. rubric:: Describe an Amazon Keypair

*describe* returns information about key pairs available to you. If you specify key pairs, information about those
key pairs is returned. Otherwise, information for all registered key pairs is returned.

*describe* returns an array which contains keyName and keyFingerprint

.. code-block:: php
   :linenos:

   $ec2_kp = new ZendService\Amazon\Ec2\Keypair('aws_key','aws_secret_key');
   $return = $ec2_kp->describe('my-new-key');


