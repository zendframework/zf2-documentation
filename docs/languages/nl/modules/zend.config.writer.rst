.. EN-Revision: 5fa5412be487bfa6e3735d357db3d26c568cba64
.. _zend.config.writer:

Zend\\Config\\Writer
====================

``Zend\Config\Writer`` biedt de mogelijkheid om een array, ``Zend\Config\Config`` object of Traversable object weg
te schrijven naar een string of een bestand. ``Zend\Config\Writer`` is een interface die twee methoden definieert: ``toFile()`` en
``toString()``. Er zijn vijf concrete implementaties:

- ``Zend\Config\Writer\Ini``

- ``Zend\Config\Writer\Xml``

- ``Zend\Config\Writer\PhpArray``

- ``Zend\Config\Writer\Json``

- ``Zend\Config\Writer\Yaml``

.. _zend.config.writer.ini:

Zend\\Config\\Writer\\Ini
-------------------------

De *INI* writer biedt twee manieren om secties weg te schrijven. Standaard worden de elementen uit de top-level configuratie
weggeschreven als aparte secties. Door ``$writer->setRenderWithoutSectionsFlags(true);`` uit te voeren, worden alle
elementen weggeschreven in de globale namespace van het *INI* bestand en worden er geen secties aangemaakt.

Daarnaast biedt ``Zend\Config\Writer\Ini`` ook nog een extra parameter **nestSeparator**, die definieert met welk
letterteken de nodes worden onderverdeeld. Standaard is dit een punt, zoals het in ook in ``Zend\Config\Reader\Ini``
standaard wordt gebruikt.

Er zijn een aantal zaken die je moet weten voor het aanmaken of wijzigen van een ``Zend\Config\Config`` object. Om een
waarde aan te maken of te wijzigen, kan je rechtstreek de property van het ``Zend\Config\Config`` object benaderen
met behulp van de property accessor (**->**). Om een sectie aan te maken in de root of om een branch aan te maken,
moet je gewoon een nieuwe array aanmaken ("``$config->branch = array();``").

.. _zend.config.writer.ini.example:

.. rubric:: Gebruik Zend\\Config\\Writer\\Ini

Het volgende voorbeeld illustreert het gebruik van ``Zend\Config\Writer\Ini`` om een nieuw configuratiebestand aan te maken:

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

Het resultaat is een INI string die er als volgt uitziet:

.. code-block:: ini
   :linenos:

   [production]
   webhost = "www.example.com"
   database.params.host = "localhost"
   database.params.username = "production"
   database.params.password = "secret"
   database.params.dbname = "dbproduction"

De INI string kan nu met de ``toFile()`` methode worden weggeschreven naar een bestand.

.. _zend.config.writer.xml:

Zend\\Config\\Writer\\Xml
-------------------------

``Zend\Config\Writer\Xml`` kan gebruikt worden om een ``Zend\Config\Config`` object weg te schrijven
naar een XML string of bestand.

.. _zend.config.writer.xml.example:

.. rubric:: Gebruik Zend\\Config\\Writer\\Ini

Het volgende voorbeeld illustreert het gebruik van ``Zend\Config\Writer\Xml`` om een nieuw configuratiebestand aan te maken:

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

Het resultaat is een XML string die er als volgt uitziet:

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

De XML string kan nu met de ``toFile()`` methode worden weggeschreven naar een bestand.

.. _zend.config.writer.phparray:

Zend\\Config\\Writer\\PhpArray
------------------------------

``Zend\Config\Writer\PhpArray`` kan gebruikt worden om een ``Zend\Config\Config`` object weg te schrijven
naar een PHP script dat een array teruggeeft.

.. _zend.config.writer.phparray.example:

.. rubric:: Gebruik Zend\\Config\\Writer\\PhpArray

Het volgende voorbeeld illustreert het gebruik van ``Zend\Config\Writer\PhpArray`` om een nieuw configuratiebestand aan te maken:

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

Het resultaat is een PHP script dat een array teruggeeft:

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

Het PHP script kan nu met de ``toFile()`` methode worden weggeschreven naar een bestand.

.. _zend.config.writer.json:

Zend\\Config\\Writer\\Json
--------------------------

``Zend\Config\Writer\Json`` kan gebruikt worden om een ``Zend\Config\Config`` object weg te schrijven
naar een JSON string of bestand.

.. _zend.config.writer.json.example:

.. rubric:: Gebruik Zend\\Config\\Writer\\Json

Het volgende voorbeeld illustreert het gebruik van ``Zend\Config\Writer\Json`` om een nieuw configuratiebestand aan te maken:

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

Het resultaat is een JSON string die er als volgt uitziet:

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

De JSON string kan nu met de ``toFile()`` methode worden weggeschreven naar een bestand.

``Zend\Config\Writer\Json`` maakt gebruik van de ``Zend\Json\Json`` component om gegevens om te zetten naar JSON formaat.

.. _zend.config.writer.yaml:

Zend\\Config\\Writer\\Yaml
--------------------------

``Zend\Config\Writer\Yaml`` kan gebruikt worden om een ``Zend\Config\Config`` object weg te schrijven
naar een YAML string of bestand. Om de YAML writer te kunnen gebruiken, moet je een callback specifiëren uit
een externe PHP library of de `Yaml PECL extension`_ gebruiken.

.. _zend.config.writer.yaml.example:

.. rubric:: Gebruik Zend\\Config\\Writer\\Yaml

Het volgende voorbeeld illustreert het gebruik van ``Zend\Config\Writer\Yaml`` en de Yaml Pecl extensie om een nieuw configuratiebestand aan te maken:

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

Het resultaat is een YAML string die er als volgt uitziet:

.. code-block:: yaml
   :linenos:

   webhost: www.example.com
   database:
       params:
         host:     localhost
         username: production
         password: secret
         dbname:   dbproduction

De YAML string kan nu met de ``toFile()`` methode worden weggeschreven naar een bestand.

Als je een externe YAML writer wenst te gebruiken, dan moet je een callback functie specifiëren in de
constructor. Stel dat je de `Spyc`_ library wenst te gebruiken:

.. code-block:: php
   :linenos:

   // include the Spyc library
   require_once ('path/to/spyc.php');

   $writer = new Zend\Config\Writer\Yaml(array('Spyc','YAMLDump'));
   echo $writer->toString($config);



.. _`Yaml PECL extension`: http://www.php.net/manual/en/book.yaml.php
.. _`Spyc`: http://code.google.com/p/spyc/
