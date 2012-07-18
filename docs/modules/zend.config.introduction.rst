.. _zend.config.introduction:

Introduction
============

``Zend\Config`` is designed to simplify the access to, and the use of, configuration data within applications. It provides a nested object property based user interface for accessing this configuration data within application code. The configuration data may come from a variety of media supporting hierarchical data storage. Currently ``Zend\Config`` provides adapters for read and write configuration data that are stored in Ini or XML files.

.. _zend.config.introduction.example.using:

.. rubric:: Using Zend\\Config

Normally it is expected that users would use one of the reader classes to read a configuration file using :ref:`Zend\\Config\\Reader\\Ini <zend.config.reader.ini>` or :ref:`Zend\\Config\\Reader\\Xml <zend.config.reader.xml>`, but if configuration data are available in a *PHP* array, one may simply pass the data to the ``Zend\Config\Config`` constructor in order to utilize a simple object-oriented interface:

.. code-block:: php
   :linenos:

   // Given an array of configuration data
   $configArray = array(
       'webhost'  => 'www.example.com',
       'database' => array(
           'adapter' => 'pdo_mysql',
           'params'  => array(
               'host'     => 'db.example.com',
               'username' => 'dbuser',
               'password' => 'secret',
               'dbname'   => 'mydatabase'
           )
       )
   );

   // Create the object-oriented wrapper upon the configuration data
   $config = new Zend\Config\Config($configArray);

   // Print a configuration datum (results in 'www.example.com')
   echo $config->webhost;


As illustrated in the example above, ``Zend\Config\Config`` provides nested object property syntax to access configuration data passed to its constructor.

Along with the object oriented access to the data values, ``Zend\Config\Config`` also has ``get()`` which will return the supplied default value if the data element doesn't exist. For example:

.. code-block:: php
   :linenos:

   $host = $config->database->get('host', 'localhost');

.. _zend.config.introduction.example.file.php:

.. rubric:: Using Zend\\Config\\Config with a PHP Configuration File

It is often desirable to use a pure *PHP*-based configuration file. The following code illustrates how easily this can be accomplished:

.. code-block:: php
   :linenos:

   // config.php
   return array(
       'webhost'  => 'www.example.com',
       'database' => array(
           'adapter' => 'pdo_mysql',
           'params'  => array(
               'host'     => 'db.example.com',
               'username' => 'dbuser',
               'password' => 'secret',
               'dbname'   => 'mydatabase'
           )
       )
   );

.. code-block:: php
   :linenos:

   // Configuration consumption
   $config = new Zend\Config\Config(include 'config.php');

   // Print a configuration datum (results in 'www.example.com')
   echo $config->webhost;


