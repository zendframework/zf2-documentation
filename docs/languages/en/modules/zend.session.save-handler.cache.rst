.. _zend.session.save-handler.cache:

Cache
-----

``Zend\Session\SaveHandler\Cache`` allows you to provide an instance of ``Zend\Cache`` to be utilized as a
session save handler.  Generally if you are utilizing the Cache save handler; you are likely using products
such as memcached.

Basic usage
^^^^^^^^^^^

A basic example is one like the following:

.. code-block:: php
   :linenos:

   use Zend\Cache\StorageFactory;
   use Zend\Session\SaveHandler\Cache;
   use Zend\Session\SessionManager;

   $cache = StorageFactory::factory(array(
       'name' => 'memcached',
       'options' => array(
           'server' => '127.0.0.1',
       ),
   ));
   $saveHandler = new Cache($cache);
   $manager = new SessionManager();
   $manager->setSaveHandler($saveHandler);

