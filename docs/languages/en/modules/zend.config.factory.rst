.. _zend.config.factory:

The Factory
===========

The factory gives you the ability to load a configuration file to an array or to ``Zend\Config\Config`` object.
The factory has two purposes

- Loading configuration file(s)
- Storing a configuration file

.. note::

   Storing the configuration will be done to *one* file. The factory is not aware of merging two 
   or more configurations and will not store it into multiple files. If you want to store particular configuration sections to a different file
   you should separate it manually.

Loading configuration file
--------------------------

The next example illustrates how to load a single configuration file

.. code-block:: php
   :linenos:
   
   //Load a php file as array
   $config = Zend\Config\Factory::fromFile(__DIR__.'/config/my.config.php');

   //Load a xml file as Config object
   $config = Zend\Config\Factory::fromFile(__DIR__.'/config/my.config.xml', true);

For merging multiple configuration files

.. code-block::php
   :linenos:

    $config = Zend\Config\Factory::fromFiles(
        array(
            __DIR__.'/config/my.config.php',
            __DIR__.'/config/my.config.xml',
        )
    );

Storing configuration file
--------------------------

Sometimes you want to store the configuration to a file. Also this is really easy to do

.. code-block::php
   :linenos:
   
   $config = new Zend\Config\Config(array(), true);
   $config->settings = array();
   $config->settings->myname = 'framework';
   $config->settings->date	 = '2012-12-12 12:12:12';
   
   //Store the configuration
   Zend\Config\Factory::toFile(__DIR__.'/config/my.config.php', $config);
   
   //Store an array
   $config = array(
       'settings' => array(
           'myname' => 'framework',
           'data'   => '2012-12-12 12:12:12',
       ),
    );

    Zend\Config\Factory::toFile(__DIR__.'/config/my.config.php', $config);

	
