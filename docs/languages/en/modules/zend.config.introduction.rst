.. _zend.config.introduction:

介绍
============

``Zend\Config``被设计用来简单的读取应用中的配置信息。它提供一个基于属性的嵌套型对象用户接口，以便存取应用中的配置信息。
这里说的配置信息可以是多种格式的。当前``Zend\Config``支持读写.ini, JSON, YAML和XML文件格式。

.. _zend.config.introduction.example.using:

Using Zend\\Config\\Config with a Reader Class
----------------------------------------------

Normally, it is expected that users would use one of the :ref:`reader classes <zend.config.reader>` to read a 
configuration file, but if configuration data are available in a *PHP* array, one may simply pass the data
to ``Zend\Config\Config``'s constructor in order to utilize a simple object-oriented interface:

.. code-block:: php
   :linenos:

   // An array of configuration data is given
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

   // Create the object-oriented wrapper using the configuration data
   $config = new Zend\Config\Config($configArray);

   // Print a configuration datum (results in 'www.example.com')
   echo $config->webhost;


As illustrated in the example above, ``Zend\Config\Config`` provides nested object property syntax to access
configuration data passed to its constructor.

Along with the object oriented access to the data values, ``Zend\Config\Config`` also has ``get()`` method that
returns the supplied value if the data element doesn't exist in the configuration array. For example:

.. code-block:: php
   :linenos:

   $host = $config->database->get('host', 'localhost');

.. _zend.config.introduction.example.file.php:

Using Zend\\Config\\Config with a PHP Configuration File
--------------------------------------------------------

It is often desirable to use a purely *PHP*-based configuration file. The following code illustrates how easily this
can be accomplished:

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

   // Consumes the configuration array
   $config = new Zend\Config\Config(include 'config.php');

   // Print a configuration datum (results in 'www.example.com')
   echo $config->webhost;


