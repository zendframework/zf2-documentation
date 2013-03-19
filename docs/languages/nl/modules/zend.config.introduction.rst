.. EN-Revision: ae1fe7a64187111097c0d18a0e800e1084299e48
.. _zend.config.introduction:

Inleiding
=========

``Zend\Config`` is ontwikkeld om de toegang tot configuratiegegevens binnen een applicatie te vereenvoudigen.
Het biedt een genestelde object property-based gebruikersinterface om de configuratiegegevens binnen een applicatie te
raadplegen. De configuratiegegevens kunnen afkomstig zijn van verschillende media met ondersteuning voor
hiërarchische opslag. Op dit moment biedt ``Zend\Config`` de mogelijkheid om gegevens in te lezen uit en weg te
schrijven naar .ini, JSON, YAML en XML bestanden.

.. _zend.config.introduction.example.using:

Zend\\Config\\Config gebruiken met een Reader Class
---------------------------------------------------

Normaal gezien wordt er verondersteld dat je één van de :ref:`reader classes <zend.config.reader>` gebruikt
om een configuratiebestand in te lezen, maar als de configuratiegegevens beschikbaar zijn in een *PHP* array, dan
kan je die gewoon meegeven aan de ``Zend\Config\Config`` constructor en op die manier gebruik maken van de eenvoudige
object-oriented interface:

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


Zoals blijkt uit het voorbeeld hierboven, biedt ``Zend\Config\Config`` een genestelde object property syntax om
de configuratiegegevens, die aan de constructor werden meegegeven, te raadplegen.

Naast de object georiënteerde toegang tot de gegevens, biedt ``Zend\Config\Config`` ook een ``get()`` methode die
een bepaalde waarde kan teruggeven indien het gevraagde element niet bestaat. Bijvoorbeeld:

.. code-block:: php
   :linenos:

   $host = $config->database->get('host', 'localhost');

.. _zend.config.introduction.example.file.php:

Zend\\Config\\Config gebruiken met een PHP configuratiebestand
--------------------------------------------------------------

Indien je een puur *PHP* configuratiebestand wenst te gebruiken, dan kan dit ook heel eenvoudig als volgt:

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


