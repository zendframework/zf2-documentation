.. _zend.service.windowsazure.storage.table:

Zend_Service_WindowsAzure_Storage_Table
=======================================

The Table service offers structured storage in the form of tables.

Table Storage is offered by Windows Azure as a REST *API* which is wrapped by the
``Zend_Service_WindowsAzure_Storage_Table`` class in order to provide a native *PHP* interface to the storage
account.

This topic lists some examples of using the ``Zend_Service_WindowsAzure_Storage_Table`` class. Other features are
available in the download package, as well as a detailed *API* documentation of those features.

Note that development table storage (in the Windows Azure *SDK*) does not support all features provided by the
*API*. Therefore, the examples listed on this page are to be used on Windows Azure production table storage.

.. _zend.service.windowsazure.storage.table.api:

Operations on tables
--------------------

This topic lists some samples of operations that can be executed on tables.

.. _zend.service.windowsazure.storage.table.api.create:

Creating a table
^^^^^^^^^^^^^^^^

Using the following code, a table can be created on Windows Azure production table storage.

.. _zend.service.windowsazure.storage.table.api.create.example:

.. rubric:: Creating a table

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );
   $result = $storageClient->createTable('testtable');

   echo 'New table name is: ' . $result->Name;

.. _zend.service.windowsazure.storage.table.api.list:

Listing all tables
^^^^^^^^^^^^^^^^^^

Using the following code, a list of all tables in Windows Azure production table storage can be queried.

.. _zend.service.windowsazure.storage.table.api.list.example:

.. rubric:: Listing all tables

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );
   $result = $storageClient->listTables();
   foreach ($result as $table) {
       echo 'Table name is: ' . $table->Name . "\r\n";
   }

.. _zend.service.windowsazure.storage.table.entities:

Operations on entities
----------------------

Tables store data as collections of entities. Entities are similar to rows. An entity has a primary key and a set
of properties. A property is a named, typed-value pair, similar to a column.

The Table service does not enforce any schema for tables, so two entities in the same table may have different sets
of properties. Developers may choose to enforce a schema on the client side. A table may contain any number of
entities.

``Zend_Service_WindowsAzure_Storage_Table`` provides 2 ways of working with entities:

- Enforced schema

- No enforced schema

All examples will make use of the following enforced schema class.

.. _zend.service.windowsazure.storage.table.entities.schema:

.. rubric:: Enforced schema used in samples

.. code-block:: php
   :linenos:

   class SampleEntity extends Zend_Service_WindowsAzure_Storage_TableEntity
   {
       /**
       * @azure Name
       */
       public $Name;

       /**
       * @azure Age Edm.Int64
       */
       public $Age;

       /**
       * @azure Visible Edm.Boolean
       */
       public $Visible = false;
   }

Note that if no schema class is passed into table storage methods, ``Zend_Service_WindowsAzure_Storage_Table``
automatically works with ``Zend_Service_WindowsAzure_Storage_DynamicTableEntity``.

.. _zend.service.windowsazure.storage.table.entities.enforced:

Enforced schema entities
^^^^^^^^^^^^^^^^^^^^^^^^

To enforce a schema on the client side using the ``Zend_Service_WindowsAzure_Storage_Table`` class, you can create
a class which inherits ``Zend_Service_WindowsAzure_Storage_TableEntity``. This class provides some basic
functionality for the ``Zend_Service_WindowsAzure_Storage_Table`` class to work with a client-side schema.

Base properties provided by ``Zend_Service_WindowsAzure_Storage_TableEntity`` are:

- PartitionKey (exposed through ``getPartitionKey()`` and ``setPartitionKey()``)

- RowKey (exposed through ``getRowKey()`` and ``setRowKey()``)

- Timestamp (exposed through ``getTimestamp()`` and ``setTimestamp()``)

- Etag value (exposed through ``getEtag()`` and ``setEtag()``)

Here's a sample class inheriting ``Zend_Service_WindowsAzure_Storage_TableEntity``:

.. _zend.service.windowsazure.storage.table.entities.enforced.schema:

.. rubric:: Sample enforced schema class

.. code-block:: php
   :linenos:

   class SampleEntity extends Zend_Service_WindowsAzure_Storage_TableEntity
   {
       /**
        * @azure Name
        */
       public $Name;

       /**
        * @azure Age Edm.Int64
        */
       public $Age;

       /**
        * @azure Visible Edm.Boolean
        */
       public $Visible = false;
   }

The ``Zend_Service_WindowsAzure_Storage_Table`` class will map any class inherited from
``Zend_Service_WindowsAzure_Storage_TableEntity`` to Windows Azure table storage entities with the correct data
type and property name. All there is to storing a property in Windows Azure is adding a docblock comment to a
public property or public getter/setter, in the following format:

.. _zend.service.windowsazure.storage.table.entities.enforced.schema-property:

.. rubric:: Enforced property

.. code-block:: php
   :linenos:

   /**
    * @azure <property name in Windows Azure> <optional property type>
    */
   public $<property name in PHP>;

Let's see how to define a propety "Age" as an integer on Windows Azure table storage:

.. _zend.service.windowsazure.storage.table.entities.enforced.schema-property-sample:

.. rubric:: Sample enforced property

.. code-block:: php
   :linenos:

   /**
    * @azure Age Edm.Int64
    */
   public $Age;

Note that a property does not necessarily have to be named the same on Windows Azure table storage. The Windows
Azure table storage property name can be defined as well as the type.

The following data types are supported:

- ``Edm.Binary``- An array of bytes up to 64 KB in size.

- ``Edm.Boolean``- A boolean value.

- ``Edm.DateTime``- A 64-bit value expressed as Coordinated Universal Time (UTC). The supported DateTime range
  begins from 12:00 midnight, January 1, 1601 A.D. (C.E.), Coordinated Universal Time (UTC). The range ends at
  December 31st, 9999.

- ``Edm.Double``- A 64-bit floating point value.

- ``Edm.Guid``- A 128-bit globally unique identifier.

- ``Edm.Int32``- A 32-bit integer.

- ``Edm.Int64``- A 64-bit integer.

- ``Edm.String``- A UTF-16-encoded value. String values may be up to 64 KB in size.

.. _zend.service.windowsazure.storage.table.entities.dynamic:

No enforced schema entities (a.k.a. DynamicEntity)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To use the ``Zend_Service_WindowsAzure_Storage_Table`` class without defining a schema, you can make use of the
``Zend_Service_WindowsAzure_Storage_DynamicTableEntity`` class. This class inherits
``Zend_Service_WindowsAzure_Storage_TableEntity`` like an enforced schema class does, but contains additional logic
to make it dynamic and not bound to a schema.

Base properties provided by ``Zend_Service_WindowsAzure_Storage_DynamicTableEntity`` are:

- PartitionKey (exposed through ``getPartitionKey()`` and ``setPartitionKey()``)

- RowKey (exposed through ``getRowKey()`` and ``setRowKey()``)

- Timestamp (exposed through ``getTimestamp()`` and ``setTimestamp()``)

- Etag value (exposed through ``getEtag()`` and ``setEtag()``)

Other properties can be added on the fly. Their Windows Azure table storage type will be determined on-the-fly:

.. _zend.service.windowsazure.storage.table.entities.dynamic.schema:

.. rubric:: Dynamicaly adding properties Zend_Service_WindowsAzure_Storage_DynamicTableEntity

.. code-block:: php
   :linenos:

   $target = new Zend_Service_WindowsAzure_Storage_DynamicTableEntity(
       'partition1', '000001'
   );
   $target->Name = 'Name'; // Will add property "Name" of type "Edm.String"
   $target->Age  = 25;     // Will add property "Age" of type "Edm.Int32"

Optionally, a property type can be enforced:

.. _zend.service.windowsazure.storage.table.entities.dynamic.schema-forcedproperties:

.. rubric:: Forcing property types on Zend_Service_WindowsAzure_Storage_DynamicTableEntity

.. code-block:: php
   :linenos:

   $target = new Zend_Service_WindowsAzure_Storage_DynamicTableEntity(
       'partition1', '000001'
   );
   $target->Name = 'Name'; // Will add property "Name" of type "Edm.String"
   $target->Age  = 25;     // Will add property "Age" of type "Edm.Int32"

   // Change type of property "Age" to "Edm.Int32":
   $target->setAzurePropertyType('Age', 'Edm.Int64');

The ``Zend_Service_WindowsAzure_Storage_Table`` class automatically works with
``Zend_Service_WindowsAzure_Storage_TableEntity`` if no specific class is passed into Table Storage methods.

.. _zend.service.windowsazure.storage.table.entities.api:

Entities API examples
^^^^^^^^^^^^^^^^^^^^^

.. _zend.service.windowsazure.storage.table.entities.api.insert:

Inserting an entity
^^^^^^^^^^^^^^^^^^^

Using the following code, an entity can be inserted into a table named "testtable". Note that the table has already
been created before.

.. _zend.service.windowsazure.storage.table.api.entities.insert.example:

.. rubric:: Inserting an entity

.. code-block:: php
   :linenos:

   $entity = new SampleEntity ('partition1', 'row1');
   $entity->FullName = "Maarten";
   $entity->Age = 25;
   $entity->Visible = true;

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );
   $result = $storageClient->insertEntity('testtable', $entity);

   // Check the timestamp and etag of the newly inserted entity
   echo 'Timestamp: ' . $result->getTimestamp() . "\n";
   echo 'Etag: ' . $result->getEtag() . "\n";

.. _zend.service.windowsazure.storage.table.entities.api.retrieve-by-id:

Retrieving an entity by partition key and row key
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Using the following code, an entity can be retrieved by partition key and row key. Note that the table and entity
have already been created before.

.. _zend.service.windowsazure.storage.table.entities.api.retrieve-by-id.example:

.. rubric:: Retrieving an entity by partition key and row key

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );
   $entity= $storageClient->retrieveEntityById(
       'testtable', 'partition1', 'row1', 'SampleEntity'
   );

.. _zend.service.windowsazure.storage.table.entities.api.updating:

Updating an entity
^^^^^^^^^^^^^^^^^^

Using the following code, an entity can be updated. Note that the table and entity have already been created
before.

.. _zend.service.windowsazure.storage.table.api.entities.updating.example:

.. rubric:: Updating an entity

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );
   $entity = $storageClient->retrieveEntityById(
       'testtable', 'partition1', 'row1', 'SampleEntity'
   );

   $entity->Name = 'New name';
   $result = $storageClient->updateEntity('testtable', $entity);

If you want to make sure the entity has not been updated before, you can make sure the *Etag* of the entity is
checked. If the entity already has had an update, the update will fail to make sure you do not overwrite any newer
data.

.. _zend.service.windowsazure.storage.table.entities.api.updating.example-etag:

.. rubric:: Updating an entity (with Etag check)

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );
   $entity = $storageClient->retrieveEntityById(
       'testtable', 'partition1', 'row1', 'SampleEntity'
   );

   $entity->Name = 'New name';

   // last parameter instructs the Etag check:
   $result = $storageClient->updateEntity('testtable', $entity, true);

.. _zend.service.windowsazure.storage.table.entities.api.delete:

Deleting an entity
^^^^^^^^^^^^^^^^^^

Using the following code, an entity can be deleted. Note that the table and entity have already been created
before.

.. _zend.service.windowsazure.storage.table.entities.api.delete.example:

.. rubric:: Deleting an entity

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );
   $entity = $storageClient->retrieveEntityById(
       'testtable', 'partition1', 'row1', 'SampleEntity'
   );
   $result = $storageClient->deleteEntity('testtable', $entity);

.. _zend.service.windowsazure.storage.table.entities.querying:

Performing queries
^^^^^^^^^^^^^^^^^^

Queries in ``Zend_Service_WindowsAzure_Storage_Table`` table storage can be performed in two ways:

- By manually creating a filter condition (involving learning a new query language)

- By using the fluent interface provided by the ``Zend_Service_WindowsAzure_Storage_Table``

Using the following code, a table can be queried using a filter condition. Note that the table and entities have
already been created before.

.. _zend.service.windowsazure.storage.table.entities.querying.query-filter:

.. rubric:: Performing queries using a filter condition

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );
   $entities = $storageClient->storageClient->retrieveEntities(
       'testtable',
       'Name eq \'Maarten\' and PartitionKey eq \'partition1\'',
       'SampleEntity'
   );

   foreach ($entities as $entity) {
       echo 'Name: ' . $entity->Name . "\n";
   }

Using the following code, a table can be queried using a fluent interface. Note that the table and entities have
already been created before.

.. _zend.service.windowsazure.storage.table.api.entities.query-fluent:

.. rubric:: Performing queries using a fluent interface

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );
   $entities = $storageClient->storageClient->retrieveEntities(
       'testtable',
       $storageClient->select()
                     ->from($tableName)
                     ->where('Name eq ?', 'Maarten')
                     ->andWhere('PartitionKey eq ?', 'partition1'),
       'SampleEntity'
   );

   foreach ($entities as $entity) {
       echo 'Name: ' . $entity->Name . "\n";
   }

.. _zend.service.windowsazure.storage.table.entities.batch:

Batch operations
^^^^^^^^^^^^^^^^

This topic demonstrates how to use the table entity group transaction features provided by Windows Azure table
storage. Windows Azure table storage supports batch transactions on entities that are in the same table and belong
to the same partition group. A transaction can include at most 100 entities.

The following example uses a batch operation (transaction) to insert a set of entities into the "testtable" table.
Note that the table has already been created before.

.. _zend.service.windowsazure.storage.table.api.batch:

.. rubric:: Executing a batch operation

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );

   // Start batch
   $batch = $storageClient->startBatch();

   // Insert entities in batch
   $entities = generateEntities();
   foreach ($entities as $entity) {
       $storageClient->insertEntity($tableName, $entity);
   }

   // Commit
   $batch->commit();

.. _zend.service.windowsazure.storage.table.sessionhandler:

Table storage session handler
-----------------------------

When running a *PHP* application on the Windows Azure platform in a load-balanced mode (running 2 Web Role
instances or more), it is important that *PHP* session data can be shared between multiple Web Role instances. The
Windows Azure *SDK* for *PHP* provides the ``Zend_Service_WindowsAzure_SessionHandler`` class, which uses Windows
Azure Table Storage as a session handler for *PHP* applications.

To use the ``Zend_Service_WindowsAzure_SessionHandler`` session handler, it should be registered as the default
session handler for your *PHP* application:

.. _zend.service.windowsazure.storage.table.api.sessionhandler-register:

.. rubric:: Registering table storage session handler

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );

   $sessionHandler = new Zend_Service_WindowsAzure_SessionHandler(
       $storageClient , 'sessionstable'
   );
   $sessionHandler->register();

The above classname registers the ``Zend_Service_WindowsAzure_SessionHandler`` session handler and will store
sessions in a table called "sessionstable".

After registration of the ``Zend_Service_WindowsAzure_SessionHandler`` session handler, sessions can be started and
used in the same way as a normal *PHP* session:

.. _zend.service.windowsazure.storage.table.api.sessionhandler-usage:

.. rubric:: Using table storage session handler

.. code-block:: php
   :linenos:

   $storageClient = new Zend_Service_WindowsAzure_Storage_Table(
       'table.core.windows.net', 'myaccount', 'myauthkey'
   );

   $sessionHandler = new Zend_Service_WindowsAzure_SessionHandler(
       $storageClient , 'sessionstable'
   );
   $sessionHandler->register();

   session_start();

   if (!isset($_SESSION['firstVisit'])) {
       $_SESSION['firstVisit'] = time();
   }

   // ...

.. warning::

   The ``Zend_Service_WindowsAzure_SessionHandler`` session handler should be registered before a call to
   ``session_start()`` is made!


