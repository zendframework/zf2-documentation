.. _zend.config.writer:

Zend\\Config\\Writer
====================

``Zend\Config\Writer`` gives you the ability to write config files out of array, ``Zend\Config\Config`` and any
Traversable object. The ``Zend\Config\Writer`` is an interface that defines two methods: ``toFile()`` and
``toString()``. We have five specific writers that implement this interface:

- ``Zend\Config\Writer\Ini``

- ``Zend\Config\Writer\Xml``

- ``Zend\Config\Writer\PhpArray``

- ``Zend\Config\Writer\Json``

- ``Zend\Config\Writer\Yaml``

.. _zend.config.writer.ini:

Zend\\Config\\Writer\\Ini
-------------------------

The *INI* writer has two modes for rendering with regard to sections. By default the top-level configuration is
always written into section names. By calling ``$writer->setRenderWithoutSectionsFlags(true);`` all options are
written into the global namespace of the *INI* file and no sections are applied.

As an addition ``Zend\Config\Writer\Ini`` has an additional option parameter **nestSeparator**, which defines with
which character the single nodes are separated. The default is a single dot, like it is accepted by
``Zend\Config\Reader\Ini`` by default.

When modifying or creating a ``Zend\Config\Config`` object, there are some things to know. To create or modify a
value, you simply say set the parameter of the ``Config`` object via the parameter accessor (**->**). To create a
section in the root or to create a branch, you just create a new array ("``$config->branch = array();``").

.. _zend.config.writer.ini.example:

.. rubric:: Using Zend\\Config\\Writer\\Ini

This example illustrates the basic use of ``Zend\Config\Writer\Ini`` to create a new config file:

.. code-block:: php
   :linenos:

   // Create the config object
   $config = new Zend\Config\Config(array(), true);
   $config->production = array();

   $config->production->webhost = 'www.example.com';
   $config->production->database = array();
   $config->production->database->params = array();
   $config->production->database->params->host = 'localhost';
   $config->production->database->params->username = 'production';
   $config->production->database->params->password = 'secret';
   $config->production->database->params->dbname = 'dbproduction';

   $writer = new Zend\Config\Writer\Ini();
   echo $writer->toString($config);

The result of this code is an INI string contains the following values:

.. code-block:: ini
   :linenos:

   [production]
   webhost = "www.example.com"
   database.params.host = "localhost"
   database.params.username = "production"
   database.params.password = "secret"
   database.params.dbname = "dbproduction"

You can use the method ``toFile()`` to store the INI data in a file.

.. _zend.config.writer.xml:

Zend\\Config\\Writer\\Xml
-------------------------

The ``Zend\Config\Writer\Xml`` can be used to generate an XML string or file starting from a
``Zend\Config\Config`` object.

.. _zend.config.writer.xml.example:

.. rubric:: Using Zend\\Config\\Writer\\Xml

This example illustrates the basic use of ``Zend\Config\Writer\Xml`` to create a new config file:

.. code-block:: php
   :linenos:

   // Create the config object
   $config = new Zend\Config\Config(array(), true);
   $config->production = array();

   $config->production->webhost = 'www.example.com';
   $config->production->database = array();
   $config->production->database->params = array();
   $config->production->database->params->host = 'localhost';
   $config->production->database->params->username = 'production';
   $config->production->database->params->password = 'secret';
   $config->production->database->params->dbname = 'dbproduction';

   $writer = new Zend\Config\Writer\Xml();
   echo $writer->toString($config);

The result of this code is an XML string contains the following data:

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <zend-config>
       <production>
           <webhost>www.example.com</webhost>
           <database>
               <params>
                   <host>localhost</host>
                   <username>production</username>
                   <password>secret</password>
                   <dbname>dbproduction</dbname>
               </params>
           </database>
       </production>
   </zend-config>

You can use the method ``toFile()`` to store the XML data in a file.

.. _zend.config.writer.phparray:

Zend\\Config\\Writer\\PhpArray
------------------------------

The ``Zend\Config\Writer\PhpArray`` can be used to generate a PHP code that returns an array representation of an
``Zend\Config\Config`` object.

.. _zend.config.writer.phparray.example:

.. rubric:: Using Zend\\Config\\Writer\\PhpArray

This example illustrates the basic use of ``Zend\Config\Writer\PhpArray`` to create a new config file:

.. code-block:: php
   :linenos:

   // Create the config object
   $config = new Zend\Config\Config(array(), true);
   $config->production = array();

   $config->production->webhost = 'www.example.com';
   $config->production->database = array();
   $config->production->database->params = array();
   $config->production->database->params->host = 'localhost';
   $config->production->database->params->username = 'production';
   $config->production->database->params->password = 'secret';
   $config->production->database->params->dbname = 'dbproduction';

   $writer = new Zend\Config\Writer\PhpArray();
   echo $writer->toString($config);

The result of this code is a PHP script that returns an array as follow:

.. code-block:: php
   :linenos:

   <?php
   return array (
     'production' =>
     array (
       'webhost' => 'www.example.com',
       'database' =>
       array (
         'params' =>
         array (
           'host' => 'localhost',
           'username' => 'production',
           'password' => 'secret',
           'dbname' => 'dbproduction',
         ),
       ),
     ),
   );

You can use the method ``toFile()`` to store the PHP script in a file.

.. _zend.config.writer.json:

Zend\\Config\\Writer\\Json
--------------------------

The ``Zend\Config\Writer\Json`` can be used to generate a PHP code that returns the JSON representation of a
``Zend\Config\Config`` object.

.. _zend.config.writer.json.example:

.. rubric:: Using Zend\\Config\\Writer\\Json

This example illustrates the basic use of ``Zend\Config\Writer\Json`` to create a new config file:

.. code-block:: php
   :linenos:

   // Create the config object
   $config = new Zend\Config\Config(array(), true);
   $config->production = array();

   $config->production->webhost = 'www.example.com';
   $config->production->database = array();
   $config->production->database->params = array();
   $config->production->database->params->host = 'localhost';
   $config->production->database->params->username = 'production';
   $config->production->database->params->password = 'secret';
   $config->production->database->params->dbname = 'dbproduction';

   $writer = new Zend\Config\Writer\Json();
   echo $writer->toString($config);

The result of this code is a JSON string contains the following values:

.. code-block:: json
   :linenos:

   { "webhost"  : "www.example.com",
     "database" : {
       "params"  : {
         "host"     : "localhost",
         "username" : "production",
         "password" : "secret",
         "dbname"   : "dbproduction"
       }
     }
   }

You can use the method ``toFile()`` to store the JSON data in a file.

The ``Zend\Config\Writer\Json`` class uses the ``Zend\Json\Json`` component to convert the data in a JSON format.

.. _zend.config.writer.yaml:

Zend\\Config\\Writer\\Yaml
--------------------------

The ``Zend\Config\Writer\Yaml`` can be used to generate a PHP code that returns the YAML representation of a
``Zend\Config\Config`` object. In order to use the YAML writer we need to pass a callback to an external PHP
library or use the `Yaml PECL extension`_.

.. _zend.config.writer.yaml.example:

.. rubric:: Using Zend\\Config\\Writer\\Yaml

This example illustrates the basic use of ``Zend\Config\Writer\Yaml`` to create a new config file using the Yaml
PECL extension:

.. code-block:: php
   :linenos:

   // Create the config object
   $config = new Zend\Config\Config(array(), true);
   $config->production = array();

   $config->production->webhost = 'www.example.com';
   $config->production->database = array();
   $config->production->database->params = array();
   $config->production->database->params->host = 'localhost';
   $config->production->database->params->username = 'production';
   $config->production->database->params->password = 'secret';
   $config->production->database->params->dbname = 'dbproduction';

   $writer = new Zend\Config\Writer\Yaml();
   echo $writer->toString($config);

The result of this code is a YAML string contains the following values:

.. code-block:: yaml
   :linenos:

   webhost: www.example.com
   database:
       params:
         host:     localhost
         username: production
         password: secret
         dbname:   dbproduction

You can use the method ``toFile()`` to store the YAML data in a file.

If you want to use an external YAML writer library you have to pass the callback function in the constructor of the
class. For instance, if you want to use the `Spyc`_ library:

.. code-block:: php
   :linenos:

   // include the Spyc library
   require_once ('path/to/spyc.php');

   $writer = new Zend\Config\Writer\Yaml(array('Spyc','YAMLDump'));
   echo $writer->toString($config);



.. _`Yaml PECL extension`: http://www.php.net/manual/en/book.yaml.php
.. _`Spyc`: http://code.google.com/p/spyc/
