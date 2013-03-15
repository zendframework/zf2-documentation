.. _zendservice.amazon.ec2.images:

ZendService\Amazon\Ec2: Amazon Machine Images (AMI)
====================================================

Amazon Machine Images (AMIs) are preconfigured with an ever-growing list of operating systems.

.. _zendservice.amazon.ec2.images.info:

AMI Information Utilities
-------------------------

.. _zendservice.amazon.ec2.images.register:

.. rubric:: Register an AMI with EC2

*register* Each *AMI* is associated with an unique ID which is provided by the Amazon EC2 service through the
RegisterImage operation. During registration, Amazon EC2 retrieves the specified image manifest from Amazon S3 and
verifies that the image is owned by the user registering the image.

*register* returns the imageId for the registered Image.

.. code-block:: php
   :linenos:

   $ec2_img = new ZendService\Amazon\Ec2\Image('aws_key','aws_secret_key');
   $ip = $ec2_img->register('imageLocation');

.. _zendservice.amazon.ec2.images.deregister:

.. rubric:: Deregister an AMI with EC2

*deregister*, Deregisters an *AMI*. Once deregistered, instances of the *AMI* can no longer be launched.

*deregister* returns boolean ``TRUE`` or ``FALSE``.

.. code-block:: php
   :linenos:

   $ec2_img = new ZendService\Amazon\Ec2\Image('aws_key','aws_secret_key');
   $ip = $ec2_img->deregister('imageId');

.. _zendservice.amazon.ec2.images.describe:

.. rubric:: Describe an AMI

*describe* Returns information about *AMI*\ s, AKIs, and ARIs available to the user. Information returned includes
image type, product codes, architecture, and kernel and *RAM* disk IDs. Images available to the user include public
images available for any user to launch, private images owned by the user making the request, and private images
owned by other users for which the user has explicit launch permissions.





      .. _zendservice.amazon.ec2.images.describe-table:

      .. table:: Launch permissions fall into three categories

         +--------+-------------------------------------------------------------------------------------------------------------------------------+
         |Name    |Description                                                                                                                    |
         +========+===============================================================================================================================+
         |public  |The owner of the AMI granted launch permissions for the AMI to the all group. All users have launch permissions for these AMIs.|
         +--------+-------------------------------------------------------------------------------------------------------------------------------+
         |explicit|The owner of the AMI granted launch permissions to a specific user.                                                            |
         +--------+-------------------------------------------------------------------------------------------------------------------------------+
         |implicit|A user has implicit launch permissions for all AMIs he or she owns.                                                            |
         +--------+-------------------------------------------------------------------------------------------------------------------------------+



The list of *AMI*\ s returned can be modified by specifying *AMI* IDs, *AMI* owners, or users with launch
permissions. If no options are specified, Amazon EC2 returns all *AMI*\ s for which the user has launch
permissions.

If you specify one or more *AMI* IDs, only *AMI*\ s that have the specified IDs are returned. If you specify an
invalid *AMI* ID, a fault is returned. If you specify an *AMI* ID for which you do not have access, it will not be
included in the returned results.

If you specify one or more *AMI* owners, only *AMI*\ s from the specified owners and for which you have access are
returned. The results can include the account IDs of the specified owners, amazon for *AMI*\ s owned by Amazon or
self for *AMI*\ s that you own.

If you specify a list of executable users, only users that have launch permissions for the *AMI*\ s are returned.
You can specify account IDs (if you own the *AMI*\ (s)), self for *AMI*\ s for which you own or have explicit
permissions, or all for public *AMI*\ s.

*describe* returns an array for all the images that match the criteria that was passed in. The array contains the
imageId, imageLocation, imageState, imageOwnerId, isPublic, architecture, imageType, kernelId, ramdiskId and
platform.

.. code-block:: php
   :linenos:

   $ec2_img = new ZendService\Amazon\Ec2\Image('aws_key','aws_secret_key');
   $ip = $ec2_img->describe();

.. _zendservice.amazon.ec2.images.attribute:

AMI Attribute Utilities
-----------------------

.. _zendservice.amazon.ec2.images.attribute.modify:

.. rubric:: Modify Image Attributes

Modifies an attribute of an *AMI*





      .. _zendservice.amazon.ec2.images.attribute.modify-table:

      .. table:: Valid Attributes

         +----------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
         |Name            |Description                                                                                                                                                                                                                                             |
         +================+========================================================================================================================================================================================================================================================+
         |launchPermission|Controls who has permission to launch the AMI. Launch permissions can be granted to specific users by adding userIds. To make the AMI public, add the all group.                                                                                        |
         +----------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
         |productCodes    |Associates a product code with AMIs. This allows developers to charge users for using AMIs. The user must be signed up for the product before they can launch the AMI. This is a write once attribute; after it is set, it cannot be changed or removed.|
         +----------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+



*modifyAttribute* returns boolean ``TRUE`` or ``FALSE``.

.. code-block:: php
   :linenos:

   $ec2_img = new ZendService\Amazon\Ec2\Image('aws_key','aws_secret_key');
   // modify the launchPermission of an AMI
   $return = $ec2_img->modifyAttribute('imageId',
                                       'launchPermission',
                                       'add',
                                       'userId',
                                       'userGroup');

   // set the product code of the AMI.
   $return = $ec2_img->modifyAttribute('imageId',
                                       'productCodes',
                                       'add',
                                       null,
                                       null,
                                       'productCode');

.. _zendservice.amazon.ec2.images.attribute.reset:

.. rubric:: Reset an AMI Attribute

*resetAttribute* will reset the attribute of an *AMI* to its default value. **The productCodes attribute cannot be
reset.**

.. code-block:: php
   :linenos:

   $ec2_img = new ZendService\Amazon\Ec2\Image('aws_key','aws_secret_key');
   $return = $ec2_img->resetAttribute('imageId', 'launchPermission');

.. _zendservice.amazon.ec2.images.attribute.describe:

.. rubric:: Describe AMI Attribute

*describeAttribute* returns information about an attribute of an *AMI*. Only one attribute can be specified per
call. Currently only launchPermission and productCodes are supported.

*describeAttribute* returns an array with the value of the attribute that was requested.

.. code-block:: php
   :linenos:

   $ec2_img = new ZendService\Amazon\Ec2\Image('aws_key','aws_secret_key');
   $return = $ec2_img->describeAttribute('imageId', 'launchPermission');


