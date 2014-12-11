.. _zendservice.windowsazure:

ZendService\\WindowsAzure
=========================

.. _zendservice.windowsazure.introduction:

Introduction
------------

Windows Azure is the name for Microsoft's Software + Services platform, an operating system in the cloud providing
services for hosting, management, scalable storage with support for simple blobs, tables, and queues, as well as a
management infrastructure for provisioning and geo-distribution of cloud-based services, and a development platform
for the Azure Services layer.

.. _zendservice.windowsazure.sdk:

Installing the Windows Azure SDK
--------------------------------

There are two development scenario's when working with Windows Azure.

- You can develop your application using ``ZendService\WindowsAzure\WindowsAzure`` and the Windows Azure *SDK*, which provides
  a local development environment of the services provided by Windows Azure's cloud infrastructure.

- You can develop your application using ``ZendService\WindowsAzure\WindowsAzure``, working directly with the Windows Azure
  cloud infrastructure.

The first case requires you to install the `Windows Azure SDK`_ on your development machine. It is currently only
available for Windows environments; progress is being made on a Java-based version of the *SDK* which can run on
any platform.

The latter case requires you to have an account at `Azure.com`_.

.. _zendservice.windowsazure.apiDocumentation:

API Documentation
-----------------

The ``ZendService\WindowsAzure\WindowsAzure`` class provides the *PHP* wrapper to the Windows Azure *REST* interface. Please
consult the `REST documentation`_ for detailed description of the service. You will need to be familiar with basic
concepts in order to use this service.

.. _zendservice.windowsazure.features:

Features
--------

``ZendService\WindowsAzure\WindowsAzure`` provides the following functionality:

- *PHP* classes for Windows Azure Blobs, Tables and Queues (for *CRUD* operations)

- Helper Classes for *HTTP* transport, AuthN, AuthZ, *REST* and Error Management

- Manageability, Instrumentation and Logging support

.. _zendservice.windowsazure.architecture:

Architecture
------------

``ZendService\WindowsAzure\WindowsAzure`` provides access to Windows Azure's storage, computation and management interfaces by
abstracting the *REST*-*XML* interface Windows Azure provides into a simple *PHP* *API*.

An application built using ``ZendService\WindowsAzure\WindowsAzure`` can access Windows Azure's features, no matter if it is
hosted on the Windows Azure platform or on an in-premise web server.

.. include:: zendservice.windows-azure.blob.rst
.. include:: zendservice.windows-azure.table.rst
.. include:: zendservice.windows-azure.queue.rst


.. _`Windows Azure SDK`: http://www.microsoft.com/downloads/details.aspx?FamilyID=6967ff37-813e-47c7-b987-889124b43abd&displaylang=en
.. _`Azure.com`: http://www.azure.com
.. _`REST documentation`: http://msdn.microsoft.com/en-us/library/dd179355.aspx
