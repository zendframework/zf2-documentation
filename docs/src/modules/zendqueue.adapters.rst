.. _zendqueue.adapters:

Adapters
========

``ZendQueue\Queue`` supports all queues implementing the interface ``Zend\Queue\Adapter\AdapterInterface``. The
following Message Queue services are supported:

- `Apache ActiveMQ`_.

- A database driven queue via ``Zend\Db``.

- A `MemcacheQ`_ queue driven via ``Memcache``.

- `Zend Platform's`_ Job Queue.

- A local array. Useful for unit testing.

.. note::

   **Limitations**

   Message transaction handling is not supported.

.. _zendqueue.adapters.configuration:

Specific Adapters - Configuration settings
------------------------------------------

If a default setting is indicated then the parameter is optional. If a default setting is not specified then the
parameter is required.

.. _zendqueue.adapters.configuration.activemq:

Apache ActiveMQ - Zend\Queue\Adapter\Activemq
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Options listed here are known requirements. Not all messaging servers require username or password.

- **$options['name'] = '/temp/queue1';**

  This is the name of the queue that you wish to start using. (Required)

- **$options['driverOptions']['host'] = 'host.domain.tld';**

  **$options['driverOptions']['host'] = '127.0.0.1';**

  You may set host to an IP address or a hostname.

  Default setting for host is '127.0.0.1'.

- **$options['driverOptions']['port'] = 61613;**

  Default setting for port is 61613.

- **$options['driverOptions']['username'] = 'username';**

  Optional for some messaging servers. Read the manual for your messaging server.

- **$options['driverOptions']['password'] = 'password';**

  Optional for some messaging servers. Read the manual for your messaging server.

- **$options['driverOptions']['timeout_sec'] = 2;**

  **$options['driverOptions']['timeout_usec'] = 0;**

  This is the amount of time that ``Zend\Queue\Adapter\Activemq`` will wait for read activity on a socket before
  returning no messages.

.. _zendqueue.adapters.configuration.Db:

Db - Zend\Queue\Adapter\Db
^^^^^^^^^^^^^^^^^^^^^^^^^^

Driver options are checked for a few required options such as **type**, **host**, **username**, **password**, and
**dbname**. You may pass along additional parameters for ``Zend\DB\DB::factory()`` as parameters in
``$options['driverOptions']``. An example of an additional option not listed here, but could be passed would be
**port**.

.. code-block:: php
   :linenos:

   $options = array(
       'driverOptions' => array(
           'host'      => 'db1.domain.tld',
           'username'  => 'my_username',
           'password'  => 'my_password',
           'dbname'    => 'messaging',
           'type'      => 'pdo_mysql',
           'port'      => 3306, // optional parameter.
       ),
       'options' => array(
           // use Zend\Db\Select for update, not all databases can support this
           // feature.
           Zend\Db\Select::FOR_UPDATE => true
       )
   );

   // Create a database queue.
   $queue = new Zend\Queue\Queue('Db', $options);



- **$options['name'] = 'queue1';**

  This is the name of the queue that you wish to start using. (Required)

- **$options['driverOptions']['type'] = 'Pdo';**

  **type** is the adapter you wish to have ``Zend\Db\Db::factory()`` use. This is the first parameter for the
  ``Zend\Db\Db::factory()`` class method call.

- **$options['driverOptions']['host'] = 'host.domain.tld';**

  **$options['driverOptions']['host'] = '127.0.0.1';**

  You may set host to an IP address or a hostname.

  Default setting for host is '127.0.0.1'.

- **$options['driverOptions']['username'] = 'username';**

- **$options['driverOptions']['password'] = 'password';**

- **$options['driverOptions']['dbname'] = 'dbname';**

  The database name that you have created the required tables for. See the notes section below.

.. _zendqueue.adapters.configuration.memcacheq:

MemcacheQ - Zend\Queue\Adapter\Memcacheq
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **$options['name'] = 'queue1';**

  This is the name of the queue that you wish to start using. (Required)

- **$options['driverOptions']['host'] = 'host.domain.tld';**

  **$options['driverOptions']['host'] = '127.0.0.1;'**

  You may set host to an IP address or a hostname.

  Default setting for host is '127.0.0.1'.

- **$options['driverOptions']['port'] = 22201;**

  The default setting for port is 22201.

.. _zendqueue.adapters.configuration.platformjq:

Zend Platform Job Queue - Zend\Queue\Adapter\PlatformJobQueue
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **$options['daemonOptions']['host'] = '127.0.0.1:10003';**

  The hostname and port corresponding to the Zend Platform Job Queue daemon you will use. (Required)

- **$options['daemonOptions']['password'] = '1234';**

  The password required for accessing the Zend Platform Job Queue daemon. (Required)

.. _zendqueue.adapters.configuration.array:

Array - Zend\Queue\Adapter\Array
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **$options['name'] = 'queue1';**

  This is the name of the queue that you wish to start using. (Required)

.. _zendqueue.adapters.notes:

Notes for Specific Adapters
---------------------------

The following adapters have notes:

.. _zendqueue.adapters.notes.activemq:

Apache ActiveMQ
^^^^^^^^^^^^^^^

Visibility duration for ``Zend\Queue\Adapter\Activemq`` is not available.

While Apache's ActiveMQ will support multiple subscriptions, the ``ZendQueue\Queue`` does not. You must create a new
``ZendQueue\Queue`` object for each individual subscription.

ActiveMQ queue/topic names must begin with one of:

- ``/queue/``

- ``/topic/``

- ``/temp-queue/``

- ``/temp-topic/``

For example: ``/queue/testing``

The following functions are not supported:

- ``create()``- create queue. Calling this function will throw an exception.

- ``delete()``- delete queue. Calling this function will throw an exception.

- ``getQueues()``- list queues. Calling this function will throw an exception.

.. _zendqueue.adapters.notes.zend_db:

Zend\Db
^^^^^^^

The database **CREATE TABLE ( ... )** *SQL* statement can be found in ``Zend/Queue/Adapter/Db/mysql.sql``.

.. _zendqueue.adapters.notes.memcacheQ:

MemcacheQ
^^^^^^^^^

Memcache can be downloaded from http://www.danga.com/memcached/.

MemcacheQ can be downloaded from http://memcachedb.org/memcacheq/.

- ``deleteMessage()``- Messages are deleted upon reception from the queue. Calling this function would have no
  effect. Calling this function will throw an error.

- ``count()`` or ``count($adapter)``- MemcacheQ does not support a method for counting the number of items in a
  queue. Calling this function will throw an error.

.. _zendqueue.adapters.notes.platformjq:

Zend Platform Job Queue
^^^^^^^^^^^^^^^^^^^^^^^

Job Queue is a feature of Zend Platform's Enterprise Solution offering. It is not a traditional message queue, and
instead allows you to queue a script to execute, along with the parameters you wish to pass to it. You can find out
more about Job Queue `on the zend.com website`_.

The following is a list of methods where this adapter's behavior diverges from the standard offerings:

- ``create()``- Zend Platform does not have the concept of discrete queues; instead, it allows administrators to
  provide scripts for processing jobs. Since adding new scripts is restricted to the administration interface, this
  method simply throws an exception indicating the action is forbidden.

- ``isExists()``- Just like ``create()``, since Job Queue does not have a notion of named queues, this method
  throws an exception when invoked.

- ``delete()``- similar to ``create()``, deletion of JQ scripts is not possible except via the admin interface;
  this method raises an exception.

- ``getQueues()``- Zend Platform does not allow introspection into the attached job handling scripts via the *API*.
  This method throws an exception.

- ``count()``- returns the total number of jobs currently active in the Job Queue.

- ``send()``- this method is perhaps the one method that diverges most from other adapters. The ``$message``
  argument may be one of three possible types, and will operate differently based on the value passed:

  - *string*- the name of a script registered with Job Queue to invoke. If passed in this way, no arguments are
    provided to the script.

  - *array*- an array of values with which to configure a ``ZendApi\Job`` object. These may include the following:

    - ``script``- the name of the Job Queue script to invoke. (Required)

    - ``priority``- the job priority to use when registering with the queue.

    - ``name``- a short string describing the job.

    - ``predecessor``- the ID of a job on which this one depends, and which must be executed before this one may
      begin.

    - ``preserved``- whether or not to retain the job within the Job Queue history. By default, off; pass a
      ``TRUE`` value to retain it.

    - ``user_variables``- an associative array of all variables you wish to have in scope during job execution
      (similar to named arguments).

    - ``interval``- how often, in seconds, the job should run. By default, this is set to 0, indicating it should
      run once, and once only.

    - ``end_time``- an expiry time, past which the job should not run. If the job was set to run only once, and
      ``end_time`` has passed, then the job will not be executed. If the job was set to run on an interval, it will
      not execute again once ``end_time`` has passed.

    - ``schedule_time``- a *UNIX* timestamp indicating when to run the job; by default, 0, indicating the job
      should run as soon as possible.

    - ``application_id``- the application identifier of the job. By default, this is ``NULL``, indicating that one
      will be automatically assigned by the queue, if the queue was assigned an application ID.

    As noted, only the ``script`` argument is required; all others are simply available to allow passing more
    fine-grained detail on how and when to run the job.

  - ``ZendApi\Job``- finally, you may simply pass a ``ZendApi\Job`` instance, and it will be passed along to
    Platform's Job Queue.

  In all instances, ``send()`` returns a ``Zend\Queue\Message\PlatformJob`` object, which provides access to the
  ``ZendApi\Job`` object used to communicate with Job Queue.

- ``receive()``- retrieves a list of active jobs from Job Queue. Each job in the returned set will be an instance
  of ``Zend\Queue\Message\PlatformJob``.

- ``deleteMessage()``- since this adapter only works with Job Queue, this method expects the provided ``$message``
  to be a ``Zend\Queue\Message\PlatformJob`` instance, and will throw an exception otherwise.

.. _zendqueue.adapters.notes.array:

Array (local)
^^^^^^^^^^^^^

The Array queue is a *PHP* ``array()`` in local memory. The ``Zend\Queue\Adapter\Array`` is good for unit testing.



.. _`Apache ActiveMQ`: http://activemq.apache.org/
.. _`MemcacheQ`: http://memcachedb.org/memcacheq/
.. _`Zend Platform's`: http://www.zend.com/en/products/platform/
.. _`on the zend.com website`: http://www.zend.com/en/products/platform/
