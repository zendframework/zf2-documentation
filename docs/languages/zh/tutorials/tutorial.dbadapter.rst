.. _dbadapter:

################################################
Setting up a database adapter
################################################

.. _dbadapter.introduction:

Introduction
------------

In most cases, e.g. in your controllers, your database adapter can be fetched directly from the service manager. Some
classes however, like ``Zend\Validator\DbRecordExists`` isn't aware of the service manager, but still needs an adapter
to function.

There are many different ways to provide this functionality to your application. Below are a few examples.

.. _dbadapter.basic-setup:

Basic setup
-----------

Normally you will setup your database adapter using a factory in the service manager in your configuration. It might
look something like this:

.. code-block:: php
   :linenos:

   // config/autoload/global.php

   return array(
      'db' => array(
         'driver'         => 'Pdo',
         'dsn'            => 'mysql:dbname=zf2tutorial;host=localhost',
      ),
      'service_manager' => array(
         'factories' => array(
            'Zend\Db\Adapter\Adapter' => 'Zend\Db\Adapter\AdapterServiceFactory',
         ),
      ),
   );

The adapter can then be accessed in any ServiceLocatorAware classes.

.. code-block:: php
   :linenos:
   
   public function getAdapter()
   {
      if (!$this->adapter) {
         $sm = $this->getServiceLocator();
         $this->adapter = $sm->get('Zend\Db\Adapter\Adapter');
      }
      return $this->adapter;
   }

More information on adapter options can be found in the docs for :ref:`Zend\\Db\\Adapter <zend.db.adapter>`.

.. _dbadapter.setting-a-static-adapter:

Setting a static adapter
------------------------

In order to utilize this adapter in non-ServiceLocatorAware classes, you can use
``Zend\Db\TableGateway\Feature\GlobalAdapterFeature::setStaticAdapter()`` to set a static adapter:

.. code-block:: php
   :linenos:

   // config/autoload/global.php

   return array(
      'db' => array(
         'driver'         => 'Pdo',
         'dsn'            => 'mysql:dbname=zf2tutorial;host=localhost',
      ),
      'service_manager' => array(
         'factories' => array(
            'Zend\Db\Adapter\Adapter' => function ($serviceManager) {
               $adapterFactory = new Zend\Db\Adapter\AdapterServiceFactory();
                  $adapter = $adapterFactory->createService($serviceManager);

                  \Zend\Db\TableGateway\Feature\GlobalAdapterFeature::setStaticAdapter($adapter);

                  return $adapter;
            }
         ),
      ),
   );

The adapter can then later be fetched using ``Zend\Db\TableGateway\Feature\GlobalAdapterFeature::getStaticAdapter()``
for use in e.g. ``Zend\Validator\DbRecordExists``:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Db\RecordExists(
      array(
         'table'   => 'users',
         'field'   => 'emailaddress',
         'adapter' => \Zend\Db\TableGateway\Feature\GlobalAdapterFeature::getStaticAdapter()
      )
   );