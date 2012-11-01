.. _zendservice.rackspace.servers:

Zend\\Service\\Rackspace\\Servers
=================================

.. _zendservice.rackspace.servers.intro:

Overview
--------

The ``ZendService\Rackspace\Servers`` is a class that provides a simple *API* to manage the `Rackspace Cloud
Servers`_. Using this class you can:

- Create new servers

- List and get information on each server

- Delete a server

- Manage the public/private IP addresses of a server

- Resize the server capacity

- Reboot a server

- Create new images for a server

- Manage the backup of a server

- Create a group of server to share the IP addresses for High Availability architecture

.. _zendservice.rackspace.servers.terminology:

Terminology
-----------

A **server** is a virtual machine instance in the Cloud Servers system. Flavor and image are requisite elements
when creating a server.

A **server** is managed using the the class ``ZendService\Rackspace\Servers\Server``.

A **flavor** is an available hardware configuration for a server. Each flavor has a unique combination of disk
space, memory capacity and priority for CPU time.

An **image** is a collection of files used to create or rebuild a server. Rackspace provides a number of pre-built
OS images by default. You may also create custom images from cloud servers you have launched. These custom images
are useful for backup purposes or for producing “gold” server images if you plan to deploy a particular server
configuration frequently.

An **image** is managed using the the class ``ZendService\Rackspace\Servers\Image``.

A **backup schedule** can be defined to create server images at regular intervals (daily and weekly). Backup
schedules are configurable per server.

**Public IP addresses** can be shared across multiple servers for use in various high availability scenarios. When
an IP address is shared to another server, the cloud network restrictions are modified to allow each server to
listen to and respond on that IP address (you may optionally specify that the target server network configuration
be modified). Shared IP addresses can be used with many standard heartbeat facilities (e.g. keepalived) that
monitor for failure and manage IP failover.

A **shared IP group** is a collection of servers that can share IPs with other members of the group. Any server in
a group can share one or more public IPs with any other server in the group. With the exception of the first server
in a shared IP group, servers must be launched into shared IP groups. A server may only be a member of one shared
IP group.

A **shared IP group** is managed using the the class ``ZendService\Rackspace\Servers\SharedIpGroup``.

.. _zendservice.rackspace.servers.quick-start:

Quick Start
-----------

To use this class you have to pass the username and the API's key of Rackspace in the construction of the class.

.. code-block:: php
   :linenos:

   $user = 'username';
   $key  = 'secret key';

   $rackspace = new ZendService\Rackspace\Servers($user,$key);

To create a new server you can use the **createServer** method.

.. code-block:: php
   :linenos:

   $data = array (
       'name'     => 'test',
       'imageId'  => '49',
       'flavorId' => '1',
   );

   $server= $rackspace->createServer($data);

   if (!$rackspace->isSuccessful()) {
       die('ERROR: '.$rackspace->getErrorMsg());
   }

   printf("Server name    : %s\n",$server->getName());
   printf("Server Id      : %s\n",$server->getId());
   printf("Admin password : %s\n",$server->getAdminPass());

This example create a server with name **test**, imageId 49, and flavorId 1. The attributes **name**, **imageId**
and **flavorId** are required to create a new server. The result of **createServer** is an instance of
``ZendService\Rackspace\Servers\Server``.

To get the public and private IP addresses of a server you can use the **getServerIp** method.

.. code-block:: php
   :linenos:

   $id  = '20054631';
   $ips = $rackspace->getServerIp($id);

   if (!$rackspace->isSuccessful()) {
       die('ERROR: '.$rackspace->getErrorMsg());
   }

   echo "Private IPs:\n";
   print_r($ips['private']);
   echo "Public IPs:\n";
   print_r($ips['public']);

This example get the IP addresses of the server with Id **20054631**. The result of **getServerIp** is an
associative arrays with keys 'private' and 'public' contains all the private IP addresses and the public IP
addresses of the server.

To get the list of all the available servers you can use the **listServers** method.

.. code-block:: php
   :linenos:

   $servers= $rackspace->listServer(true);

   if (!$rackspace->isSuccessful()) {
       die('ERROR: '.$rackspace->getErrorMsg());
   }

   foreach ($servers as $srv) {
       printf("Name      : %s\n",$srv->getName());
       printf("Server Id : %s\n",$srv->getId());
       printf("Image  Id : %s\n",$srv->getImageId());
       printf("Flavor Id : %s\n",$srv->getFlavorId());
       printf("Status    : %s (%d\%)\n",$srv->getStatus(),$srv->getProgress());
   }

.. _zendservice.rackspace.servers.methods:

Available Methods
-----------------

.. _zendservice.rackspace.servers.methods.change-backup-schedule:

**changeBackupSchedule**
   ``changeBackupSchedule(string $id, string $weekly, string $daily)``

   This operation creates a new backup schedule or updates an existing backup schedule for the specified server.
   Return **true** in case of success, **false** in case of error.

   **$id** is the ID of the server

   **$weekly**, the day of the week for the backup (for instance "THURSDAY")

   **$daily**, specify the hours for the backup (for instance "H_0400_0600")

.. _zendservice.rackspace.servers.methods.change-server-name:

**changeServerName**
   ``changeServerName(string $id, string $name)``

   Change the name of a server. Return **true** in case of success, **false** in case of error.

   **$id** is the ID of the server

   **$name** is an optional parameter that specify the new name of the server

.. _zendservice.rackspace.servers.methods.change-server-password:

**changeServerPassword**
   ``changeServerPassword(string $id, string $password)``

   Change the admin password of a server. Return **true** in case of success, **false** in case of error.

   **$id** is the ID of the server

   **$password** is an optional parameter that specify the new admin password of the server

.. _zendservice.rackspace.servers.methods.confirm-resize-server:

**confirmResizeServer**
   ``confirmResizeServer(string $id)``

   Confirm the resize of a server. During a resize operation, the original server is saved for a period of time to
   allow roll back if there is a problem. Once the newly resized server is tested and has been confirmed to be
   functioning properly, use this operation to confirm the resize. After confirmation, the original server is
   removed and cannot be rolled back to. All resizes are automatically confirmed after 24 hours if they are not
   explicitly confirmed or reverted. Return **true** in case of success, **false** in case of error.

   **$id** is Id of the server.

.. _zendservice.rackspace.servers.methods.create-image:

**createImage**
   ``createImage(string $serverId,string $name)``

   Create an image from a server. Return a new instance of ``ZendService\Rackspace\Servers\Image``. In case of
   error the return is **false**.

   **$serverId** is the Id of the server to use to create the image.

   **$name**, is the name of image to create

.. _zendservice.rackspace.servers.methods.create-shared-ip-group:

**createSharedIpGroup**
   ``createSharedIpGroup(string $name, string $serverId)``

   This operation creates a new shared IP group. Please note, on a create request, the shared IP group can be
   created empty or can be initially populated with a single server. Return the shared IP group as instance of
   ``ZendService\Rackspace\Servers\SharedIpGroup`` In case of error the return is **false**.

   **$name** is the name of the shared IP group to create.

   **$serverId** is the Id of the server.

.. _zendservice.rackspace.servers.methods.create-server:

**createServer**
   ``createServer(array $data, $metadata=array(),$files=array())``

   Create a server with the attributes specified in **$data**. You can specify also optional parameters:
   **metadata** and **files**. Metadata is an array contains key/value of metadata related to the server and files
   is an array contains the paths of some files to upload into the server. The syntax used for the uploading of the
   files is 'serverPath' => 'localPath'. Return a new instance of ``ZendService\Rackspace\Servers\Server``. In
   case of error the return is **false**.

   **$data** contains the parameters for the server. The required attributes to create a new server are:

      - **name**, contains the name of the server

      - **flavorId**, contains the flavor's Id to use

      - **imageId**, contains the image's Id to use



   **$metadata**, contains the array of metadata information

   **$files**, contains the path of the files to upload in the server using the syntax 'serverPath' => 'localPath'.

.. _zendservice.rackspace.servers.methods.disable-backup-schedule:

**disableBackupSchedule**
   ``disableBackupSchedule(string $id)``

   Disable the backup of a server. Return **true** in case of success, **false** in case of error.

   **$id** is the Id of the server.

.. _zendservice.rackspace.servers.methods.delete-image:

**deleteImage**
   ``deleteImage(string $id)``

   Delete a image. Return **true** in case of success, **false** in case of error.

   **$id** is the Id of the image.

.. _zendservice.rackspace.servers.methods.delete-shared-ip-group:

**deleteSharedIpGroup**
   ``deleteSharedIpGroup(string $id)``

   Delete a shared IP group. Return **true** in case of success, **false** in case of error.

   **$id** is the Id of the shared IP group.

.. _zendservice.rackspace.servers.methods.delete-server:

**deleteServer**
   ``deleteServer(string $id)``

   Delete a server. Return **true** in case of success, **false** in case of error.

   **$id** is the Id of the server.

.. _zendservice.rackspace.servers.methods.get-backup-schedule:

**getBackupSchedule**
   ``getBackupSchedule(string $id)``

   Return the backup schedule of a server. The return is an associative array with the following values: enabled,
   weekly, daily. In case of error the return is **false**.

   **$id** is the Id of the server.

.. _zendservice.rackspace.servers.methods.get-flavor:

**getFlavor**
   ``getFlavor(string $flavorId)``

   Return the information about a flavor. The return is an associative array with the following values: id, ram,
   disk, name. In case of error the return is **false**.

   **$flavorId** is the Id of the flavor.

.. _zendservice.rackspace.servers.methods.get-image:

**getImage**
   ``getImage(string $id)``

   Return an image as instance of ``ZendService\Rackspace\Servers\Image``. In case of error the return is
   **false**.

   **$id** is the Id of the image.

.. _zendservice.rackspace.servers.methods.get-shared-ip-group:

**getSharedIpGroup**
   ``getSharedIpGroup(string $id)``

   Return the shared IP group as instance of ``ZendService\Rackspace\Servers\SharedIpGroup`` In case of error the
   return is **false**.

   **$id** is the Id of the shared IP group.

.. _zendservice.rackspace.servers.methods.get-server:

**getServer**
   ``getServer(string $id)``

   Return the server specified by the Id as instance of ``ZendService\Rackspace\Servers\Server``. In case of error
   the return is **false**.

   **$id** is Id of the server.

.. _zendservice.rackspace.servers.methods.get-server-ip:

**getServerIp**
   ``getServerIp(string $id)``

   Return the public and private IP addresses of a server. Return an associative array contains the key
   **'public'** and **'private'** for the IP addresses. In case of error the return is **false**.

   **$id** is Id of the server.

.. _zendservice.rackspace.servers.methods.get-server-private-ip:

**getServerPrivateIp**
   ``getServerPrivateIp(string $id)``

   Return the private IP addresses of the server. Return an associative array contains the IP addresses. In case of
   error the return is **false**.

   **$id** is Id of the server.

.. _zendservice.rackspace.servers.methods.get-server-public-ip:

**getServerPublicIp**
   ``getServerPublicIp(string $id)``

   Return the public IP addresses of the server. Return an associative array contains the IP addresses. In case of
   error the return is **false**.

   **$id** is Id of the server.

.. _zendservice.rackspace.servers.methods.list-flavors:

**listFlavors**
   ``listFlavors(boolean $details=false)``

   Return all the available flavors as associative array. In case of error the return is **false**.

   If **$details** is **true** return a detailed list, if is **false** return only the **name** and the **Id** of
   the flavor.

.. _zendservice.rackspace.servers.methods.list-images:

**listImages**
   ``listImages(boolean $details=false)``

   Return all the available images as instance of ``ZendService\Rackspace\Servers\ImageList`` In case of error the
   return is **false**.

   If **$details** is **true** return a detailed list, if is **false** return only the **name** and the **Id** of
   the Image.

.. _zendservice.rackspace.servers.methods.list-server:

**listServer**
   ``listServer(boolean $details=false)``

   Return all the available servers with a new instance of ``ZendService\Rackspace\Servers\ServerList``. In case
   of error the return is **false**.

   If **$details** is **true** return a detailed list, if is **false** return only the **name** and the **Id** of
   the server.

.. _zendservice.rackspace.servers.methods.list-shared-ip-groups:

**listSharedIpGroups**
   ``listSharedIpGroups(boolean $details=false)``

   Return all the shared IP groups as instance of ``ZendService\Rackspace\Servers\SharedIpGroupList`` In case of
   error the return is **false**.

   If **$details** is **true** return a detailed list, if is **false** return only the **name** and the **Id** of
   the shared IP group.

.. _zendservice.rackspace.servers.methods.reboot-server:

**rebootServer**
   ``rebootServer(string $id, boolean $hard=false)``

   Reboot a server. Return **true** in case of success, **false** in case of error.

   **$id** is Id of the server.

   If **$hard** is **false** (default) the server is rebooted in soft mode. That means the operating system is
   signaled to restart, which allows for a graceful shutdown of all processes. If **$hard** is **true** the server
   is rebooted in hard mode. A hard reboot is the equivalent of power cycling the server.

.. _zendservice.rackspace.servers.methods.rebuild-server:

**rebuildServer**
   ``rebuildServer(string $id, string $imageId)``

   Rebuild a server. The rebuild function removes all data on the server and replaces it with the specified image,
   server's Id and IP addresses will remain the same. Return **true** in case of success, **false** in case of
   error.

   **$id** is Id of the server.

   **$imageId** is the new Image Id of the server.

.. _zendservice.rackspace.servers.methods.resize-server:

**resizeServer**
   ``resizeServer(string $id, string $flavorId)``

   Resize a server. The resize function converts an existing server to a different flavor, in essence, scaling the
   server up or down. The original server is saved for a period of time to allow rollback if there is a problem.
   All resizes should be tested and explicitly confirmed, at which time the original server is removed. All resizes
   are automatically confirmed after 24 hours if they are not explicitly confirmed or reverted. Return **true** in
   case of success, **false** in case of error.

   **$id** is Id of the server.

   **$flavorId** is the new flavor Id of the server.

.. _zendservice.rackspace.servers.methods.revert-resize-server:

**revertResizeServer**
   ``revertResizeServer(string $id)``

   Revert the resize of a server. During a resize operation, the original server is saved for a period of time to
   allow for roll back if there is a problem. If you determine there is a problem with a newly resized server, use
   this operation to revert the resize and roll back to the original server. All resizes are automatically
   confirmed after 24 hours if they have not already been confirmed explicitly or reverted. Return **true** in case
   of success, **false** in case of error.

   **$id** is Id of the server.

.. _zendservice.rackspace.servers.methods.share-ip-address:

**shareIpAddress**
   ``shareIpAddress(string $id, string $ip, string $groupId, boolean $configure=true)``

   Share an IP address for a server. Return **true** in case of success, **false** in case of error.

   **$id** is Id of the server.

   **$ip** is the IP address to share.

   **$groupId** is the group Id to use.

   If **$configure** attribute is set to true, the server is configured with the new address, though the address is
   not enabled. Note that configuring the server does require a reboot.

.. _zendservice.rackspace.servers.methods.unshare-ip-address:

**unshareIpAddress**
   ``unshareIpAddress(string $id, string $ip)``

   Unshare an IP address for a server. Return **true** in case of success, **false** in case of error.

   **$id** is Id of the server.

   **$ip** is the IP address to share.

.. _zendservice.rackspace.servers.methods.update-server:

**updateServer**
   ``updateServer(string $id,string $name=null,string $password=null)``

   Change the name or/and the admin password of a server. In case of error the return is **false**.

   **$id** is the ID of the server

   **$name** is an optional parameter that specify the new name of the server

   **$password** is an optional parameter that specify the new admin password of the server

.. _zendservice.rackspace.servers.examples:

Examples
--------

.. _zendservice.rackspace.servers.examples.authenticate:

.. rubric:: Authenticate

Check if the username and the key are valid for the Rackspace authentication.

.. code-block:: php
   :linenos:

   $user = 'username';
   $key  = 'secret key';

   $rackspace = new ZendService\Rackspace\Servers($user,$key);

   if ($rackspace->authenticate()) {
       printf("Authenticated with token: %s",$rackspace->getToken());
   } else {
       printf("ERROR: %s",$rackspace->getErrorMsg());
   }

.. _zendservice.rackspace.servers.examples.create-server:

.. rubric:: Create a server with metadata information and upload of a file

Create a server with some metadata information and upload the file **build.sh** from the local path **/home/user**
to the remote path **/root**.

.. code-block:: php
   :linenos:

   $data = array (
       'name'     => 'test',
       'imageId'  => '49',
       'flavorId' => '1',
   );
   $metadata = array (
       'foo' => 'bar',
   );
   $files = array (
       '/root/build.sh' => '/home/user/build.sh',
   );
   $server= $rackspace->createServer($data,$metadata,$files);

   if (!$rackspace->isSuccessful()) {
       die('ERROR: '.$rackspace->getErrorMsg());
   }

   $publicIp= $server->getPublicIp();

   printf("Server name    : %s\n",$server->getName());
   printf("Server Id      : %s\n",$server->getId());
   printf("Public IP      : %s\n",$publicIp[0]);
   printf("Admin password : %s\n",$server->getAdminPass());

.. _zendservice.rackspace.servers.examples.reboot-server:

.. rubric:: Reboot a server

Reboot a server in hard mode (is the equivalent of power cycling the server).

.. code-block:: php
   :linenos:

   $flavors= $rackspace->rebootServer('server id',true)

   if (!$rackspace->isSuccessful()) {
       die('ERROR: '.$rackspace->getErrorMsg());
   }

   echo "The server has been rebooted successfully";

.. _zendservice.rackspace.servers.examples.list-flavors:

.. rubric:: List all the available flavors

List all the available flavors with all the detailed information.

.. code-block:: php
   :linenos:

   $flavors= $rackspace->listFlavors(true);

   if (!$rackspace->isSuccessful()) {
       die('ERROR: '.$rackspace->getErrorMsg());
   }

   print_r($flavors);



.. _`Rackspace Cloud Servers`: http://www.rackspace.com/cloud/cloud_hosting_products/servers/
