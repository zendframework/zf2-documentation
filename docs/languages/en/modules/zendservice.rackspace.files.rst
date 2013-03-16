.. _zendservice.rackspace.files:

Zend\\Service\\Rackspace\\Files
===============================

.. _zendservice.rackspace.files.intro:

Overview
--------

The ``ZendService\Rackspace\Files`` is a class that provides a simple *API* to manage the `Rackspace Cloud
Files`_.

.. _zendservice.rackspace.files.quick-start:

Quick Start
-----------

To use this class you have to pass the username and the API's key of Rackspace in the construction of the class.

.. code-block:: php
   :linenos:

   $user = 'username';
   $key  = 'secret key';

   $rackspace = new ZendService\Rackspace\Files($user,$key);

A container is a storage compartment for your data and provides a way for you to organize your data. You can think
of a container as a folder in Windows® or a directory in UNIX®. The primary difference between a container and
these other file system concepts is that containers cannot be nested. You can, however, create an unlimited number
of containers within your account. Data must be stored in a container so you must have at least one container
defined in your account prior to uploading data.

The only restrictions on container names is that they cannot contain a forward slash (/) and must be less than 256
bytes in length (please note that the length restriction applies to the name using the URL encoded format).

The containers are managed using the class ``ZendService\Rackspace\Files\Container``.

An object (file) is the basic storage entity and any optional metadata that represents the files you store in the
Cloud Files system. When you upload data to Cloud Files, the data is stored as-is (no compression or encryption)
and consists of a location (container), the object's name, and any metadata consisting of key/value pairs. For
instance, you may chose to store a backup of your digital photos and organize them into albums. In this case, each
object could be tagged with metadata such as Album : Caribbean Cruise or Album : Aspen Ski Trip.

The only restriction on object names is that they must be less than 1024 bytes in length after URL encoding. Cloud
Files has a limit on the size of a single uploaded object; by default this is 5 GB. For metadata, you should not
exceed 90 individual key/value pairs for any one object and the total byte length of all key/value pairs should not
exceed 4KB (4096 bytes).

The objects are managed using the class ``ZendService\Rackspace\Files\Object``.

To create a new container you can use the **createContainer** method.

.. code-block:: php
   :linenos:

   $container= $rackspace->createContainer('test');

   if (!$rackspace->isSuccessful()) {
       die('ERROR: '.$rackspace->getErrorMsg());
   }

   printf("Name: %s",$container->getName());

This example create a container with name **test**. The result of **createContainer** is a new instance of
``ZendService\Rackspace\Files\Container``.

To store an object (file) in a container you can use the **storeObject** method.

.. code-block:: php
   :linenos:

   $name= 'example.jpg';
   $file= file_get_contents($name);

   $metadata= array (
       'foo' => 'bar'
   );

   $rackspace->storeObject('test',$name,$file,$metadata);

   if ($rackspace->isSuccessful()) {
       echo 'Object stored successfully';
   } else {
       printf("ERROR: %s",$rackspace->getErrorMsg());
   }

This example store a file image **example.jpg** in the container **test** with the metadata specified in the array
**$metadata**.

To delete an object (file) you can use the **deleteObject** method.

.. code-block:: php
   :linenos:

   $rackspace->deleteObject('test','example.jpg');

   if ($rackspace->isSuccessful()) {
       echo 'Object deleted successfully';
   } else {
       printf("ERROR: %s",$rackspace->getErrorMsg());
   }

This example delete the object **example.jpg** in the container **test**.

To publish a container as *CDN* (Content Delivery Network) you can use the **enableCdnContainer** method.

.. code-block:: php
   :linenos:

   $cdnInfo= $rackspace->enableCdnContainer('test');

   if ($rackspace->isSuccessful()) {
       print_r($cdnInfo);
   } else {
       printf("ERROR: %s",$rackspace->getErrorMsg());
   }

This example publish the container **test** as *CDN*. If the operation is successful returns an associative arrays
with the following values:

- **cdn_uri**, the url of the CDN container;

- **cdn_uri_ssl**, the ssl url of the CDN container;

.. _zendservice.rackspace.files.methods:

Available Methods
-----------------

.. _zendservice.rackspace.files.methods.copy-object:

**copyObject**
   ``copyObject(string $container_source,string $obj_source,string $container_dest,string $obj_dest,$metadata=array(),string $content_type=null)``

   Copy an object from a container to another. The return is **true** in case of success and **false** in case of
   error.

   The **$container_source** is the name of the source container.

   The **$obj_source** is the name of the source object.

   The **$container_dest** is the name of the destination container.

   The **$obj_dest** is the name of the destination object.

   The **$metadata** array contains the metadata information related to the destination object.

   The **$content_type** is the optional content type of the destination object (file).

.. _zendservice.rackspace.files.methods.create-container:

**createContainer**
   ``createContainer(string $container, $metadata=array())``

   Create a container. The return is an instance of ``ZendService\Rackspace\Files\Container``. In case of error
   the return is **false**.

   The **$container** is the name of the container to create.

   The **$metadata** array contains the metadata information related to the container.

.. _zendservice.rackspace.files.methods.delete-container:

**deleteContainer**
   ``deleteContainer(string $container)``

   Delete a container. The return is **true** in case of success and **false** in case of error.

   The **$container** is the name of the container to delete.

.. _zendservice.rackspace.files.methods.delete-object:

**deleteObject**
   ``deleteObject(string $container,string $object)``

   Delete an object in a specific container. Return **true** in case of success, **false** in case of error.

   The **$container** is the name of the container.

   The **$object** is the name of the object to delete.

.. _zendservice.rackspace.files.methods.enable-cdn-container:

**enableCdnContainer**
   ``enableCdnContainer(string $container,integer $ttl=900)``

   Publish a container as *CDN* (Content Delivery Network). Return an associative array contains the CDN url and
   SSL url. In case of error the return is **false**.

   The **$container** is the name of the container.

   The **$ttl** is the time to live for the CDN cache content. The default value is 15 minutes (900 seconds). The
   minimum TTL that can be set is 15 minutes (900 seconds); the maximum TTL is 50 years (range of 900 to 1577836800
   seconds).

.. _zendservice.rackspace.files.methods.get-cdn-containers:

**getCdnContainers**
   ``getCdnContainers($options=array())``

   Returns all the CDN containers available. The return is an instance of
   ``ZendService\Rackspace\Files\ContainerList``. In case of error the return is **false**.

   The **$options** contains the following optional parameters:

      - **limit**, for an integer value n, limits the number of results to at most n values.

      - **marker**, given a string value x, return object names greater in value than the specified marker.



.. _zendservice.rackspace.files.methods.get-containers:

**getContainers**
   ``getContainers($options=array())``

   Returns all the containers available. The return is an instance of
   ``ZendService\Rackspace\Files\ContainerList`` In case of error the return is **false**.

   The **$options** contains the following optional parameters:

      - **limit**, for an integer value n, limits the number of results to at most n values.

      - **marker**, given a string value x, return object names greater in value than the specified marker.



.. _zendservice.rackspace.files.methods.get-container:

**getContainer**
   ``getContainer(string $container)``

   Returns the container specified as instance of ``ZendService\Rackspace\Files\Container`` In case of error the
   return is **false**.

   The **$container** is the name of the container.

.. _zendservice.rackspace.files.methods.get-count-containers:

**getCountContainers**
   ``getCountContainers()``

   Return the total count of containers.

.. _zendservice.rackspace.files.methods.get-count-objects:

**getCountObjects**
   ``getCountObjects()``

   Return the count of objects contained in all the containers.

.. _zendservice.rackspace.files.methods.get-info-cdn-container:

**getInfoCdnContainer**
   ``getInfoCdnContainer(string $container)``

   Get the information of a CDN container. The result is an associative array with all the CDN information. In case
   of error the return is **false**.

   The **$container** is the name of the container.

.. _zendservice.rackspace.files.methods.get-info-containers:

**getInfoContainers**
   ``getInfoContainers()``

   Get the information about all the containers available. Return an associative array with the following values:

      - **tot_containers**, the total number of containers stored

      - **size_containers**, the total size, in byte, of all the containers.

      - **tot_objects**, the total number of objects (file) stored in all the containers.

   In case of error the return is **false**.

.. _zendservice.rackspace.files.methods.get-metadata-container:

**getMetadataContainer**
   ``getMetadataContainer(string $container)``

   Get the metadata information of a container. The result is an associative array with all the metadata
   keys/values. In case of error the return is **false**.

   The **$container** is the name of the container.

.. _zendservice.rackspace.files.methods.get-metadata-object:

**getMetadataObject**
   ``getMetadataObject(string $container, string $object)``

   Get the metadata information of an object. The result is an associative array with all the metadata keys/values.
   In case of error the return is **false**.

   The **$container** is the name of the container.

   The **$object** is the name of the object.

.. _zendservice.rackspace.files.methods.get-objects:

**getObjects**
   ``getObjects(string $container, $options=array())``

   Returns all the objects of a container. The return is an instance of ``ZendService\Rackspace\Files\ObjectList``
   In case of error the return is **false**.

   The **$container** is the name of the container.

   The **$options** contains the following optional parameters:

      - **limit**, for an integer value n, limits the number of results to at most n values.

      - **marker**, given a string value x, return object names greater in value than the specified marker.

      - **prefix**, for a string value x, causes the results to be limited to object names beginning with the
        substring x.

      - **path**, for a string value x, return the object names nested in the pseudo path.

      - **delimiter**, for a character c, return all the object names nested in the container (without the need for
        the directory marker objects).



.. _zendservice.rackspace.files.methods.get-object:

**getObject**
   ``getObject(string $container, string $object, $headers=array())``

   Returns an object of a container. The return is an instance of ``ZendService\Rackspace\Files\Object`` In case
   of error the return is **false**.

   The **$container** is the name of the container.

   The **$object** is the name of the object.

   The **$headers** contains the following optional parameters (See the `RFC-2616`_ for more info):

      - **If-Match**, a client that has one or more entities previously obtained from the resource can verify that
        one of those entities is current by including a list of their associated entity tags in the If-Match header
        field.

      - **If-None-Match**, a client that has one or more entities previously obtained from the resource can verify
        that none of those entities is current by including a list of their associated entity tags in the
        If-None-Match header field.

      - **If-Modified-Since**, if the requested variant has not been modified since the time specified in this
        field, an entity will not be returned from the server.

      - **If-Unmodified-Since**, if the requested resource has not been modified since the time specified in this
        field, the server SHOULD perform the requested operation as if the If-Unmodified-Since header were not
        present.

      - **Range**, Rackspace supports a sub-set of Range and do not adhere to the full RFC-2616 specification. We
        support specifying OFFSET-LENGTH where either OFFSET or LENGTH can be optional (not both at the same time).
        The following are supported forms of the header:

           - **Range: bytes=-5**, last five bytes of the object

           - **Range: bytes=10-15**, the five bytes after a 10-byte offset

           - **Range: bytes=32-**, all data after the first 32 bytes of the object





.. _zendservice.rackspace.files.methods.get-size-containers:

**getSizeContainers**
   ``getSizeContainers()``

   Return the size, in bytes, of all the containers.

.. _zendservice.rackspace.files.methods.set-metadata-object:

**setMetadataObject**
   ``setMetadataObject(string $container,string $object, array $metadata)``

   Update metadata information to the object (all the previous metadata will be deleted). Return **true** in case
   of success, **false** in case of error.

   The **$container** is the name of the container.

   The **$object** is the name of the object to store.

   The **$metadata** array contains the metadata information related to the object.

.. _zendservice.rackspace.files.methods.store-object:

**storeObject**
   ``storeObject(string $container,string $object,string $file,$metadata=array())``

   Store an object in a specific container. Return **true** in case of success, **false** in case of error.

   The **$container** is the name of the container.

   The **$object** is the name of the object to store.

   The **$file** is the content of the object to store.

   The **$metadata** array contains the metadata information related to the object to store.

.. _zendservice.rackspace.files.methods.update-cdn-container:

**updateCdnContainer**
   ``updateCdnContainer(string $container,integer $ttl=null,$cdn_enabled=null,$log=null)``

   Update the attribute of a *CDN* container. Return an associative array contains the CDN url and SSL url. In case
   of error the return is **false**.

   The **$container** is the name of the container.

   The **$ttl** is the time to live for the CDN cache content. The default value is 15 minutes (900 seconds). The
   minimum TTL that can be set is 15 minutes (900 seconds); the maximum TTL is 50 years (range of 900 to 1577836800
   seconds).

   The **$cdn_enabled** is the flag to swith on/off the CDN. **True** switch on, **false** switch off.

   The **$log** enable or disable the log retention. **True** switch on, **false** switch off.

.. _zendservice.rackspace.files.examples:

Examples
--------

.. _zendservice.rackspace.files.examples.authenticate:

.. rubric:: Authenticate

Check if the username and the key are valid for the Rackspace authentication.

.. code-block:: php
   :linenos:

   $user = 'username';
   $key  = 'secret key';

   $rackspace = new ZendService\Rackspace\Files($user,$key);

   if ($rackspace->authenticate()) {
       printf("Authenticated with token: %s",$rackspace->getToken());
   } else {
       printf("ERROR: %s",$rackspace->getErrorMsg());
   }

.. _zendservice.rackspace.files.examples.get-object:

.. rubric:: Get an object

Get an image file (**example.gif**) from the cloud and render it in the browser

.. code-block:: php
   :linenos:

   $user = 'username';
   $key  = 'secret key';

   $rackspace = new ZendService\Rackspace\Files($user,$key);

   $object= $rackspace->getObject('test','example.gif');

   if (!$rackspace->isSuccessful()) {
       die('ERROR: '.$rackspace->getErrorMsg());
   }

   header('Content-type: image/gif');
   echo $object->getFile();

.. _zendservice.rackspace.files.examples.create-container:

.. rubric:: Create a container with metadata

Create a container (**test**) with some metadata information (**$metadata**)

.. code-block:: php
   :linenos:

   $user = 'username';
   $key  = 'secret key';

   $rackspace = new ZendService\Rackspace\Files($user,$key);

   $metadata= array (
       'foo'  => 'bar',
       'foo2' => 'bar2',
   );

   $container= $rackspace->createContainer('test',$metadata);

   if ($rackspace->isSuccessful()) {
       echo 'Container created successfully';
   }

.. _zendservice.rackspace.files.examples.get-metadata-container:

.. rubric:: Get the metadata of a container

Get the metadata of the container **test**

.. code-block:: php
   :linenos:

   $user = 'username';
   $key  = 'secret key';

   $rackspace = new ZendService\Rackspace\Files($user, $key);

   $container= $rackspace->getContainer('test');

   if (!$rackspace->isSuccessful()) {
       die('ERROR: ' . $rackspace->getErrorMsg());
   }

   $metadata= $container->getMetadata();
   print_r($metadata);

.. _zendservice.rackspace.files.examples.store-object-container:

.. rubric:: Store an object in a container

Store an object using a ``ZendService\Rackspace\Files\Container`` instance

.. code-block:: php
   :linenos:

   $user = 'username';
   $key  = 'secret key';

   $rackspace = new ZendService\Rackspace\Files($user, $key);

   $container= $rackspace->getContainer('test');

   if (!$rackspace->isSuccessful()) {
       die('ERROR: ' . $rackspace->getErrorMsg());
   }

   $file     = file_get_contents('test.jpg');
   $metadata = array (
       'foo' => 'bar',
   );

   if ($container->addObject('test.jpg', $file, $metadata)) {
       echo 'Object stored successfully';
   }

.. _zendservice.rackspace.files.examples.check-cdn-enabled:

.. rubric:: Check if a container is CDN enabled

Check if the **test** container is CDN enabled. If it is not we enable it.

.. code-block:: php
   :linenos:

   $user = 'username';
   $key  = 'secret key';

   $rackspace = new ZendService\Rackspace\Files($user, $key);

   $container= $rackspace->getContainer('test');

   if (!$rackspace->isSuccessful()) {
       die('ERROR: ' . $rackspace->getErrorMsg());
   }

   if (!$container->isCdnEnabled()) {
       if (!$container->enableCdn()) {
           die('ERROR: ' . $rackspace->getErrorMsg());
       }
   }
   printf(
       "The container is CDN enabled with the following URLs:\n %s\n %s\n",
       $container->getCdnUri(),
       $container->getCdnUriSsl()
   );



.. _`Rackspace Cloud Files`: http://www.rackspace.com/cloud/cloud_hosting_products/files/
.. _`RFC-2616`: http://www.ietf.org/rfc/rfc2616.txt
