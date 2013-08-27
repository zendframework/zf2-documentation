.. _zend.session.save-handler.mongodb:

MongoDB
-------

``Zend\Session\SaveHandler\MongoDB`` allows you to provide a MongoDB instance to be utilized as a session
save handler.  You provide the options in the ``Zend\Session\SaveHandler\MongoDBOptions`` class.

Basic Usage
^^^^^^^^^^^

A basic example is one like the following:

.. code-block:: php
   :linenos:

   use Mongo;
   use Zend\Session\SaveHandler\MongoDB;
   use Zend\Session\SaveHandler\MongoDBOptions;
   use Zend\Session\SessionManager;

   $mongo = new Mongo();
   $options = new MongoDBOptions(array(
       'database'   => 'myapp',
       'collection' => 'sessions',
   ));
   $saveHandler = new MongoDB($mongo, $options);
   $manager     = new SessionManager();
   $manager->setSaveHandler($saveHandler);

