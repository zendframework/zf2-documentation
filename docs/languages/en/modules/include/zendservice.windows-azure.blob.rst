.. _zendservice.windowsazure.storage.blob:

ZendService\\WindowsAzure\\Storage\\Blob
========================================

Blob Storage stores sets of binary data. Blob storage offers the following three resources: the storage account,
containers, and blobs. Within your storage account, containers provide a way to organize sets of blobs within your
storage account.

Blob Storage is offered by Windows Azure as a *REST* *API* which is wrapped by the
``ZendService\WindowsAzure\Storage\Blob`` class in order to provide a native *PHP* interface to the storage
account.

.. _zendservice.windowsazure.storage.blob.api:

API Examples
------------

This topic lists some examples of using the ``ZendService\WindowsAzure\Storage\Blob`` class. Other features are
available in the download package, as well as a detailed *API* documentation of those features.

.. _zendservice.windowsazure.storage.blob.api.create-container:

Creating a storage container
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Using the following code, a blob storage container can be created on development storage.

.. _zendservice.windowsazure.storage.blob.api.create-container.example:

.. rubric:: Creating a storage container

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Blob();
   $result = $storageClient->createContainer('testcontainer');

   echo 'Container name is: ' . $result->Name;

.. _zendservice.windowsazure.storage.blob.api.delete-container:

Deleting a storage container
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Using the following code, a blob storage container can be removed from development storage.

.. _zendservice.windowsazure.storage.blob.api.delete-container.example:

.. rubric:: Deleting a storage container

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Blob();
   $storageClient->deleteContainer('testcontainer');

.. _zendservice.windowsazure.storage.blob.api.storing-blob:

Storing a blob
^^^^^^^^^^^^^^

Using the following code, a blob can be uploaded to a blob storage container on development storage. Note that the
container has already been created before.

.. _zendservice.windowsazure.storage.blob.api.storing-blob.example:

.. rubric:: Storing a blob

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Blob();

   // upload /home/maarten/example.txt to Azure
   $result = $storageClient->putBlob(
       'testcontainer', 'example.txt', '/home/maarten/example.txt'
   );

   echo 'Blob name is: ' . $result->Name;

.. _zendservice.windowsazure.storage.blob.api.copy-blob:

Copying a blob
^^^^^^^^^^^^^^

Using the following code, a blob can be copied from inside the storage account. The advantage of using this method
is that the copy operation occurs in the Azure cloud and does not involve downloading the blob. Note that the
container has already been created before.

.. _zendservice.windowsazure.storage.blob.api.copy-blob.example:

.. rubric:: Copying a blob

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Blob();

   // copy example.txt to example2.txt
   $result = $storageClient->copyBlob(
       'testcontainer', 'example.txt', 'testcontainer', 'example2.txt'
   );

   echo 'Copied blob name is: ' . $result->Name;

.. _zendservice.windowsazure.storage.blob.api.download-blob:

Downloading a blob
^^^^^^^^^^^^^^^^^^

Using the following code, a blob can be downloaded from a blob storage container on development storage. Note that
the container has already been created before and a blob has been uploaded.

.. _zendservice.windowsazure.storage.blob.api.download-blob.example:

.. rubric:: Downloading a blob

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Blob();

   // download file to /home/maarten/example.txt
   $storageClient->getBlob(
       'testcontainer', 'example.txt', '/home/maarten/example.txt'
   );

.. _zendservice.windowsazure.storage.blob.api.public-blob:

Making a blob publicly available
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

By default, blob storage containers on Windows Azure are protected from public viewing. If any user on the Internet
should have access to a blob container, its ACL can be set to public. Note that this applies to a complete
container and not to a single blob!

Using the following code, blob storage container ACL can be set on development storage. Note that the container has
already been created before.

.. _zendservice.windowsazure.storage.blob.api.public-blob.example:

.. rubric:: Making a blob publicly available

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Blob();

   // make container publicly available
   $storageClient->setContainerAcl(
       'testcontainer',
       ZendService\WindowsAzure\Storage\Blob::ACL_PUBLIC
   );

.. _zendservice.windowsazure.storage.blob.root:

Root container
--------------

Windows Azure Blob Storage provides support to work with a "root container". This means that a blob can be stored
in the root of your storage account, i.e. ``http://myaccount.blob.core.windows.net/somefile.txt``.

In order to work with the root container, it should first be created using the ``createContainer()`` method, naming
the container ``$root``. All other operations on the root container should be issued with the container name set to
``$root``.

.. _zendservice.windowsazure.storage.blob.wrapper:

Blob storage stream wrapper
---------------------------

The Windows Azure *SDK* for *PHP* provides support for registering a blob storage client as a *PHP* file stream
wrapper. The blob storage stream wrapper provides support for using regular file operations on Windows Azure Blob
Storage. For example, one can open a file from Windows Azure Blob Storage with the ``fopen()`` function:

.. _zendservice.windowsazure.storage.blob.wrapper.sample:

.. rubric:: Example usage of blob storage stream wrapper

.. code-block:: php
   :linenos:

   $fileHandle = fopen('azure://mycontainer/myfile.txt', 'r');

   // ...

   fclose($fileHandle);

In order to do this, the Windows Azure *SDK* for *PHP* blob storage client must be registered as a stream wrapper.
This can be done by calling the ``registerStreamWrapper()`` method:

.. _zendservice.windowsazure.storage.blob.wrapper.register:

.. rubric:: Registering the blob storage stream wrapper

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Blob();
   // registers azure:// on this storage client
   $storageClient->registerStreamWrapper();


   // or:

   // registers blob:// on this storage client
   $storageClient->registerStreamWrapper('blob://');

To unregister the stream wrapper, the ``unregisterStreamWrapper()`` method can be used.

.. _zendservice.windowsazure.storage.blob.sharedaccesssig:

Shared Access Signature
-----------------------

Windows Azure Bob Storage provides a feature called "Shared Access Signatures". By default, there is only one level
of authorization possible in Windows Azure Blob Storage: either a container is private or it is public. Shared
Access Signatures provide a more granular method of authorization: read, write, delete and list permissions can be
assigned on a container or a blob and given to a specific client using an URL-based model.

An example would be the following signature:


::

   http://phpstorage.blob.core.windows.net/phpazuretestshared1?st=2009-08-17T09%3A06%3A17Z&se=2009-08-17T09%3A56%3A17Z&sr=c&sp=w&sig=hscQ7Su1nqd91OfMTwTkxabhJSaspx%2BD%2Fz8UqZAgn9s%3D

The above signature gives write access to the "phpazuretestshared1" container of the "phpstorage" account.

.. _zendservice.windowsazure.storage.blob.sharedaccesssig.generate:

Generating a Shared Access Signature
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When you are the owner of a Windows Azure Bob Storage account, you can create and distribute a shared access key
for any type of resource in your account. To do this, the ``generateSharedAccessUrl()`` method of the
``ZendService\WindowsAzure\Storage\Blob`` storage client can be used.

The following example code will generate a Shared Access Signature for write access in a container named
"container1", within a timeframe of 3000 seconds.

.. _zendservice.windowsazure.storage.blob.sharedaccesssig.generate-2:

.. rubric:: Generating a Shared Access Signature for a container

.. code-block:: php
   :linenos:

   $storageClient   = new ZendService\WindowsAzure\Storage\Blob();
   $sharedAccessUrl = $storageClient->generateSharedAccessUrl(
       'container1',
       '',
       'c',
       'w',
       $storageClient ->isoDate(time() - 500),
       $storageClient ->isoDate(time() + 3000)
   );

The following example code will generate a Shared Access Signature for read access in a blob named ``test.txt`` in
a container named "container1" within a time frame of 3000 seconds.

.. _zendservice.windowsazure.storage.blob.sharedaccesssig-generate-3:

.. rubric:: Generating a Shared Access Signature for a blob

.. code-block:: php
   :linenos:

   $storageClient   = new ZendService\WindowsAzure\Storage\Blob();
   $sharedAccessUrl = $storageClient->generateSharedAccessUrl(
       'container1',
       'test.txt',
       'b',
       'r',
       $storageClient ->isoDate(time() - 500),
       $storageClient ->isoDate(time() + 3000)
   );

.. _zendservice.windowsazure.storage.blob.sharedaccesssig.consume:

Working with Shared Access Signatures from others
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When you receive a Shared Access Signature from someone else, you can use the Windows Azure *SDK* for *PHP* to work
with the addressed resource. For example, the following signature can be retrieved from the owner of a storage
account:


::

   http://phpstorage.blob.core.windows.net/phpazuretestshared1?st=2009-08-17T09%3A06%3A17Z&se=2009-08-17T09%3A56%3A17Z&sr=c&sp=w&sig=hscQ7Su1nqd91OfMTwTkxabhJSaspx%2BD%2Fz8UqZAgn9s%3D

The above signature gives write access to the "phpazuretestshared1" "container" of the phpstorage account. Since
the shared key for the account is not known, the Shared Access Signature can be used to work with the authorized
resource.

.. _zendservice.windowsazure.storage.blob.sharedaccesssig.consuming:

.. rubric:: Consuming a Shared Access Signature for a container

.. code-block:: php
   :linenos:

   $storageClient = new ZendService\WindowsAzure\Storage\Blob(
       'blob.core.windows.net', 'phpstorage', ''
   );
   $storageClient->setCredentials(
       new ZendService\WindowsAzure\Credentials\SharedAccessSignature()
   );
   $storageClient->getCredentials()->setPermissionSet(array(
       'http://phpstorage.blob.core.windows.net/phpazuretestshared1?st=2009-08-17T09%3A06%3A17Z&se=2009-08-17T09%3A56%3A17Z&sr=c&sp=w&sig=hscQ7Su1nqd91OfMTwTkxabhJSaspx%2BD%2Fz8UqZAgn9s%3D'
   ));
   $storageClient->putBlob(
       'phpazuretestshared1', 'NewBlob.txt', 'C:\Files\dataforazure.txt'
   );

Note that there was no explicit permission to write to a specific blob. Instead, the Windows Azure *SDK* for *PHP*
determined that a permission was required to either write to that specific blob, or to write to its container.
Since only a signature was available for the latter, the Windows Azure *SDK* for *PHP* chose those credentials to
perform the request on Windows Azure blob storage.