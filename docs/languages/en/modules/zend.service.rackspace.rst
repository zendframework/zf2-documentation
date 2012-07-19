.. _zend.service.rackspace:

Zend\\Service\\Rackspace
========================

.. _zend.service.rackspace.introduction:

Introduction
------------

The ``Zend\Service\Rackspace`` is a class that provides a simple *API* to manage the Rackspace services Cloud Files
and Cloud Servers.

.. note:: Load balancers service

   The load balancers service of Rackspace is not implemented yet. We are planning to release it in the next
   future.

.. _zend.service.rackspace.registering:

Registering with Rackspace
--------------------------

Before you can get started with ``Zend\Service\Rackspace``, you must first register for an account. Please see the
`Cloud services`_ page on the Rackspace website for more information.

After registering, you can get the Username and the API Key from the Rackspace management console under the menu
"Your Account" > "API Access". These informations are required to use the ``Zend\Service\Rackspace`` classes.

.. _zend.service.rackspace.feature.files:

Cloud Files
-----------

The Cloud Files is a service to store any files in a cloud environment. A user can store an unlimited quantity of
files and each file can be as large as 5 gigabytes. The files can be private or public. The private files can be
accessed using the API of Rackspace. The public files are accessed using a *CDN* (Content Delivery Network).
Rackspace exposes a *REST* API to manage the Cloud Files.

``Zend\Service\Rackspace\Files`` provides the following functionality:



   - Upload files programmatically for tight integration with your application

   - Enable Cloud Files CDN integration on any container for public distribution

   - Create Containers programmatically

   - Retrieve lists of containers and files



.. _zend.service.rackspace.feature.servers:

Cloud Servers
-------------

Rackspace Cloud Servers is a compute service that provides server capacity in the cloud. Cloud Servers come in
different flavors of memory, disk space, and CPU.

``Zend\Service\Rackspace\Servers`` provides the following functionality:



   - Create/delete new servers

   - List and get information on each server

   - Manage the public/private IP addresses of a server

   - Resize the server capacity

   - Reboot a server

   - Create new images for a server

   - Manage the backup of a server

   - Create a group of server to share the IP addresses for High Availability architecture



.. _zend.service.rackspace.methods:

Available Methods
-----------------

Eeach service class (Files, Servers) of Rackspace extends the ``Zend\Service\Rackspace`` abstract class. This class
contains a set of public methods shared with all the service. This public methods are reported as follow:

.. _zend.service.rackspace.files.methods.authenticate:

**authenticate**
   ``authenticate()``

   Authenticate the Rackspace API using the user and the key specified in the concrete class that extend
   ``Zend\Service\Rackspace``. Return **true** in case of success and **false** in case of error.

.. _zend.service.rackspace.files.methods.get-auth-url:

**getAuthUrl**
   ``getAuthUrl()``

   Get the authentication URL of Rackspace. Returns a string.

.. _zend.service.rackspace.files.methods.get-cdn-url:

**getCdnUrl**
   ``getCdnUrl()``

   Get the URL for the CDN. Returns a string.

.. _zend.service.rackspace.files.methods.get-error-code:

**getErrorCode**
   ``getErrorCode()``

   Get the last HTTP error code. Returns a string.

.. _zend.service.rackspace.files.methods.get-error-msg:

**getErrorMsg**
   ``getErrorMsg()``

   Get the last error message. Returns a string.

.. _zend.service.rackspace.files.methods.get-http-client:

**getHttpClient**
   ``getHttpClient()``

   Get the HTTP client used to call the API of the Rackspace. Returns a ``Zend\Http\Client`` instance.

.. _zend.service.rackspace.files.methods.get-key:

**getKey**
   ``getKey()``

   Get the authentication key. Returns a string.

.. _zend.service.rackspace.files.methods.get-management-url:

**getManagementUrl**
   ``getManagementUrl()``

   Get the URL for the management services. Returns a string.

.. _zend.service.rackspace.files.methods.get-storage-url:

**getStorageUrl**
   ``getStorageUrl()``

   Get the URL for the storage (files) service. Returns a string.

.. _zend.service.rackspace.files.methods.get-token:

**getToken**
   ``getToken()``

   Get the token returned after a successful authentication. Returns a string.

.. _zend.service.rackspace.files.methods.get-user:

**getUser**
   ``getUser()``

   Get the user authenticated with the Rackspace service. Returns a string.

.. _zend.service.rackspace.files.methods.is-successful:

**isSuccessful**
   ``isSuccessful()``

   Return **true** if the last service call was successful, false otherwise.

.. _zend.service.rackspace.files.methods.set-auth-url:

**setAuthUrl**
   ``setAuthUrl(string $url)``

   Set the authentication URL to be used.

   **$url** is the URL for the authentication

.. _zend.service.rackspace.files.methods.set-key:

**setKey**
   ``setKey(string $key)``

   Set the key for the API authentication.

   **$key** is the key string for the authentication

.. _zend.service.rackspace.files.methods.set-user:

**setUser**
   ``setUser(string $user)``

   Set the user for the API authentication.

   **$user** is the user string for the authentication



.. _`Cloud services`: http://www.rackspace.com/cloud/
