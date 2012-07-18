.. _zend.validator.Db:

Db\\RecordExists and Db\\NoRecordExists
=======================================

``Zend\Validator\Db\RecordExists`` and ``Zend\Validator\Db\NoRecordExists`` provide a means to test whether a record exists in a given table of a database, with a given value.

.. _zend.validator.set.db.options:

Supported options for Zend\\Validator\\Db_*
-------------------------------------------

The following options are supported for ``Zend\Validator\Db\NoRecordExists`` and ``Zend\Validator\Db\RecordExists``:

- **adapter**: The database adapter which will be used for the search.

- **exclude**: Sets records which will be excluded from the search.

- **field**: The database field within this table which will be searched for the record.

- **schema**: Sets the schema which will be used for the search.

- **table**: The table which will be searched for the record.

.. _zend.validator.db.basic-usage:

Basic usage
-----------

An example of basic usage of the validators:

.. code-block:: php
   :linenos:

   //Check that the email address exists in the database
   $validator = new Zend\Validator\Db\RecordExists(
       array(
           'table' => 'users',
           'field' => 'emailaddress'
       )
   );

   if ($validator->isValid($emailaddress)) {
       // email address appears to be valid
   } else {
       // email address is invalid; print the reasons
       foreach ($validator->getMessages() as $message) {
           echo "$message\n";
       }
   }

The above will test that a given email address is in the database table. If no record is found containing the value of ``$emailaddress`` in the specified column, then an error message is displayed.

.. code-block:: php
   :linenos:

   //Check that the username is not present in the database
   $validator = new Zend\Validator\Db\NoRecordExists(
       array(
           'table' => 'users',
           'field' => 'username'
       )
   );
   if ($validator->isValid($username)) {
       // username appears to be valid
   } else {
       // username is invalid; print the reason
       $messages = $validator->getMessages();
       foreach ($messages as $message) {
           echo "$message\n";
       }
   }

The above will test that a given username is not in the database table. If a record is found containing the value of ``$username`` in the specified column, then an error message is displayed.

.. _zend.validator.db.excluding-records:

Excluding records
-----------------

``Zend\Validator\Db\RecordExists`` and ``Zend\Validator\Db\NoRecordExists`` also provide a means to test the database, excluding a part of the table, either by providing a where clause as a string, or an array with the keys "field" and "value".

When providing an array for the exclude clause, the **!=** operator is used, so you can check the rest of a table for a value before altering a record (for example on a user profile form)

.. code-block:: php
   :linenos:

   //Check no other users have the username
   $user_id   = $user->getId();
   $validator = new Zend\Validator\Db\NoRecordExists(
       array(
           'table' => 'users',
           'field' => 'username',
           'exclude' => array(
               'field' => 'id',
               'value' => $user_id
           )
       )
   );

   if ($validator->isValid($username)) {
       // username appears to be valid
   } else {
       // username is invalid; print the reason
       $messages = $validator->getMessages();
       foreach ($messages as $message) {
           echo "$message\n";
       }
   }

The above example will check the table to ensure no records other than the one where ``id = $user_id`` contains the value $username.

You can also provide a string to the exclude clause so you can use an operator other than **!=**. This can be useful for testing against composite keys.

.. code-block:: php
   :linenos:

   $email     = 'user@example.com';
   $clause    = $db->quoteInto('email = ?', $email);
   $validator = new Zend\Validator\Db\RecordExists(
       array(
           'table'   => 'users',
           'field'   => 'username',
           'exclude' => $clause
       )
   );

   if ($validator->isValid($username)) {
       // username appears to be valid
   } else {
       // username is invalid; print the reason
       $messages = $validator->getMessages();
       foreach ($messages as $message) {
           echo "$message\n";
       }
   }

The above example will check the 'users' table to ensure that only a record with both the username ``$username`` and with the email ``$email`` is valid.

.. _zend.validator.db.database-adapters:

Database Adapters
-----------------

You can also specify an adapter. This will allow you to work with applications using multiple database adapters, or where you have not set a default adapter. As in the example below:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Db\RecordExists(
       array(
           'table' => 'users',
           'field' => 'id',
           'adapter' => $dbAdapter
       )
   );

.. _zend.validator.db.database-schemas:

Database Schemas
----------------

You can specify a schema within your database for adapters such as PostgreSQL and DB/2 by simply supplying an array with ``table`` and ``schema`` keys. As in the example below:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Db\RecordExists(
       array(
           'table'  => 'users',
           'schema' => 'my',
           'field'  => 'id'
       )
   );


