.. _zendservice.amazon.s3:

ZendService\Amazon\S3
======================

.. _zendservice.amazon.s3.introduction:

Introduction
------------

Amazon S3 provides a simple web services interface that can be used to store and retrieve any amount of data, at
any time, from anywhere on the web. It gives any developer access to the same highly scalable, reliable, fast,
inexpensive data storage infrastructure that Amazon uses to run its own global network of web sites. The service
aims to maximize benefits of scale and to pass those benefits on to developers.

.. _zendservice.amazon.s3.registering:

Registering with Amazon S3
--------------------------

Before you can get started with ``ZendService\Amazon\S3``, you must first register for an account. Please see the
`S3 FAQ`_ page on the Amazon website for more information.

After registering, you will receive an application key and a secret key. You will need both to access the S3
service.

.. _zendservice.amazon.s3.apiDocumentation:

API Documentation
-----------------

The ``ZendService\Amazon\S3`` class provides the *PHP* wrapper to the Amazon S3 REST interface. Please consult the
`Amazon S3 documentation`_ for detailed description of the service. You will need to be familiar with basic
concepts in order to use this service.

.. _zendservice.amazon.s3.features:

Features
--------

``ZendService\Amazon\S3`` provides the following functionality:



   - A single point for configuring your amazon.s3 authentication credentials that can be used across the amazon.s3
     namespaces.

   - A proxy object that is more convenient to use than an *HTTP* client alone, mostly removing the need to
     manually construct *HTTP* POST requests to access the REST service.

   - A response wrapper that parses each response body and throws an exception if an error occurred, alleviating
     the need to repeatedly check the success of many commands.

   - Additional convenience methods for some of the more common operations.



.. _zendservice.amazon.s3.storing-your-first:

Getting Started
---------------

Once you have registered with Amazon S3, you're ready to store your first data object on the S3. The objects on S3
are stored in containers, called "buckets". Bucket names are unique on S3, and each user can have no more than 100
buckets simultaneously. Each bucket can contain unlimited amount of objects, identified by name.

The following example demonstrates creating a bucket, storing and retrieving the data.

.. _zendservice.amazon.s3.storing-your-first.example:

.. rubric:: ZendService\Amazon\S3 Usage Example

.. code-block:: php
   :linenos:

   $s3 = new ZendService\Amazon\S3($my_aws_key, $my_aws_secret_key);

   $s3->createBucket("my-own-bucket");

   $s3->putObject("my-own-bucket/myobject", "somedata");

   echo $s3->getObject("my-own-bucket/myobject");

Since ``ZendService\Amazon\S3`` service requires authentication, you should pass your credentials (AWS key and
secret key) to the constructor. If you only use one account, you can set default credentials for the service:

.. code-block:: php
   :linenos:

   ZendService\Amazon\S3::setKeys($my_aws_key, $my_aws_secret_key);
   $s3 = new ZendService\Amazon\S3();

.. _zendservice.amazon.s3.buckets:

Bucket operations
-----------------

All objects in S3 system are stored in buckets. Bucket has to be created before any storage operation. Bucket name
is unique in the system, so you can not have bucket named the same as someone else's bucket.

Bucket name can contain lowercase letters, digits, periods (.), underscores (\_), and dashes (-). No other symbols
allowed. Bucket name should start with letter or digit, and be 3 to 255 characters long. Names looking like an IP
address (e.g. "192.168.16.255") are not allowed.

- ``createBucket()`` creates a new bucket.

- ``cleanBucket()`` removes all objects that are contained in a bucket.

- ``removeBucket()`` removes the bucket from the system. The bucket should be empty to be removed.

  .. _zendservice.amazon.s3.buckets.remove.example:

  .. rubric:: ZendService\Amazon\S3 Bucket Removal Example

  .. code-block:: php
     :linenos:

     $s3 = new ZendService\Amazon\S3($my_aws_key, $my_aws_secret_key);

     $s3->cleanBucket("my-own-bucket");
     $s3->removeBucket("my-own-bucket");

- ``getBuckets()`` returns the list of the names of all buckets belonging to the user.

  .. _zendservice.amazon.s3.buckets.list.example:

  .. rubric:: ZendService\Amazon\S3 Bucket Listing Example

  .. code-block:: php
     :linenos:

     $s3 = new ZendService\Amazon\S3($my_aws_key, $my_aws_secret_key);

     $list = $s3->getBuckets();
     foreach ($list as $bucket) {
       echo "I have bucket $bucket\n";
     }

- ``isBucketAvailable()`` check if the bucket exists and returns ``TRUE`` if it does.

.. _zendservice.amazon.s3.objects:

Object operations
-----------------

The object is the basic storage unit in S3. Object stores unstructured data, which can be any size up to 4
gigabytes. There's no limit on how many objects can be stored on the system.

The object are contained in buckets. Object is identified by name, which can be any utf-8 string. It is common to
use hierarchical names (such as *Pictures/Myself/CodingInPHP.jpg*) to organise object names. Object name is
prefixed with bucket name when using object functions, so for object "mydata" in bucket "my-own-bucket" the name
would be *my-own-bucket/mydata*.

Objects can be replaced (by rewriting new data with the same key) or deleted, but not modified, appended, etc.
Object is always stored whole.

By default, all objects are private and can be accessed only by their owner. However, it is possible to specify
object with public access, in which case it will be available through the *URL*:
*http://s3.amazonaws.com/[bucket-name]/[object-name]*.

- ``putObject($object, $data, $meta)`` created an object with name ``$object`` (should contain the bucket name as
  prefix!) having ``$data`` as its content.

  Optional ``$meta`` parameter is the array of metadata, which currently supports the following parameters as keys:

  **S3_CONTENT_TYPE_HEADER**
     *MIME* content type of the data. If not specified, the type will be guessed according to the file extension of
     the object name.

  **S3_ACL_HEADER**
     The access to the item. Following access constants can be used:

        **S3_ACL_PRIVATE**
           Only the owner has access to the item.

        **S3_ACL_PUBLIC_READ**
           Anybody can read the object, but only owner can write. This is setting may be used to store publicly
           accessible content.

        **S3_ACL_PUBLIC_WRITE**
           Anybody can read or write the object. This policy is rarely useful.

        **S3_ACL_AUTH_READ**
           Only the owner has write access to the item, and other authenticated S3 users have read access. This is
           useful for sharing data between S3 accounts without exposing them to the public.

     By default, all the items are private.

     .. _zendservice.amazon.s3.objects.public.example:

     .. rubric:: ZendService\Amazon\S3 Public Object Example

     .. code-block:: php
        :linenos:

        $s3 = new ZendService\Amazon\S3($my_aws_key, $my_aws_secret_key);

        $s3->putObject("my-own-bucket/Pictures/Me.png", file_get_contents("me.png"),
            array(ZendService\Amazon\S3::S3_ACL_HEADER =>
                  ZendService\Amazon\S3::S3_ACL_PUBLIC_READ));
        // or:
        $s3->putFile("me.png", "my-own-bucket/Pictures/Me.png",
            array(ZendService\Amazon\S3::S3_ACL_HEADER =>
                  ZendService\Amazon\S3::S3_ACL_PUBLIC_READ));
        echo "Go to http://s3.amazonaws.com/my-own-bucket/Pictures/Me.png to see me!\n";

- ``getObject($object)`` retrieves object data from the storage by name.

- ``removeObject($object)`` removes the object from the storage.

- ``getInfo($object)`` retrieves the metadata information about the object. The function will return array with
  metadata information. Some of the useful keys are:

     **type**
        The *MIME* type of the item.

     **size**
        The size of the object data.

     **mtime**
        UNIX-type timestamp of the last modification for the object.

     **etag**
        The ETag of the data, which is the MD5 hash of the data, surrounded by quotes (").

  The function will return ``FALSE`` if the key does not correspond to any existing object.

- ``getObjectsByBucket($bucket)`` returns the list of the object keys, contained in the bucket.

  .. _zendservice.amazon.s3.objects.list.example:

  .. rubric:: ZendService\Amazon\S3 Object Listing Example

  .. code-block:: php
     :linenos:

     $s3 = new ZendService\Amazon\S3($my_aws_key, $my_aws_secret_key);

     $list = $s3->getObjectsByBucket("my-own-bucket");
     foreach ($list as $name) {
       echo "I have $name key:\n";
       $data = $s3->getObject("my-own-bucket/$name");
       echo "with data: $data\n";
     }

- ``isObjectAvailable($object)`` checks if the object with given name exists.

- ``putFile($path, $object, $meta)`` puts the content of the file in ``$path`` into the object named ``$object``.

  The optional ``$meta`` argument is the same as for *putObject*. If the content type is omitted, it will be
  guessed basing on the source file name.

.. _zendservice.amazon.s3.streaming:

Data Streaming
--------------

It is possible to get and put objects using not stream data held in memory but files or *PHP* streams. This is
especially useful when file sizes are large in order not to overcome memory limits.

To receive object using streaming, use method ``getObjectStream($object, $filename)``. This method will return
``Zend\Http\Response\Stream``, which can be used as described in :ref:`HTTP Client Data Streaming
<zend.http.client.streaming>` section.



      .. _zendservice.amazon.s3.streaming.example1:

      .. rubric:: ZendService\Amazon\S3 Data Streaming Example

      .. code-block:: php
         :linenos:

         $response = $amazon->getObjectStream("mybycket/zftest");
         // copy file
         copy($response->getStreamName(), "my/downloads/file");
         // use stream
         $fp = fopen("my/downloads/file2", "w");
         stream_copy_to_stream($response->getStream(), $fp);



Second parameter for ``getObjectStream()`` is optional and specifies target file to write the data. If not
specified, temporary file is used, which will be deleted after the response object is destroyed.

To send object using streaming, use ``putFileStream()`` which has the same signature as ``putFile()`` but will use
streaming and not read the file into memory.

Also, you can pass stream resource to ``putObject()`` method data parameter, in which case the data will be read
from the stream when sending the request to the server.

.. _zendservice.amazon.s3.streams:

Stream wrapper
--------------

In addition to the interfaces described above, ``ZendService\Amazon\S3`` also supports operating as a stream
wrapper. For this, you need to register the client object as the stream wrapper:

.. _zendservice.amazon.s3.streams.example:

.. rubric:: ZendService\Amazon\S3 Streams Example

.. code-block:: php
   :linenos:

   $s3 = new ZendService\Amazon\S3($my_aws_key, $my_aws_secret_key);

   $s3->registerStreamWrapper("s3");

   mkdir("s3://my-own-bucket");
   file_put_contents("s3://my-own-bucket/testdata", "mydata");

   echo file_get_contents("s3://my-own-bucket/testdata");

Directory operations (*mkdir*, *rmdir*, *opendir*, etc.) will operate on buckets and thus their arguments should be
of the form of *s3://bucketname*. File operations operate on objects. Object creation, reading, writing, deletion,
stat and directory listing is supported.



.. _`S3 FAQ`: http://aws.amazon.com/s3/faqs/
.. _`Amazon S3 documentation`: http://developer.amazonwebservices.com/connect/kbcategory.jspa?categoryID=48
