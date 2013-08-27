.. _zend.session.save-handler.db-table-gateway:

DbTableGateway
--------------

``Zend\Session\SaveHandler\DbTableGateway`` allows you to utilize ``Zend\Db`` as a session save handler.
Setup of the DbTableGateway requires an instance of ``Zend\Db\TableGateway\TableGateway`` and an instance
of ``Zend\Session\SaveHandler\DbTableGatewayOptions``.  In the most basic setup, a TableGateway object and
using the defaults of the DbTableGatewayOptions will provide you with what you need.

Creating the database table
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: sql
   :linenos:

   CREATE TABLE `session` (
       `id` char(32),
       `name` char(32),
       `modified` int,
       `lifetime` int,
       `data` text,
        PRIMARY KEY (`id`, `name`)
   );

Basic usage
^^^^^^^^^^^

A basic example is one like the following:

.. code-block:: php
   :linenos:

   use Zend\Db\TableGateway\TableGateway;
   use Zend\Session\SaveHandler\DbTableGateway;
   use Zend\Session\SaveHandler\DbTableGatewayOptions;
   use Zend\Session\SessionManager;

   $tableGateway = new TableGateway('session', $adapter);
   $saveHandler  = new DbTableGateway($tableGateway, new DbTableGatewayOptions());
   $manager      = new SessionManager();
   $manager->setSaveHandler($saveHandler);