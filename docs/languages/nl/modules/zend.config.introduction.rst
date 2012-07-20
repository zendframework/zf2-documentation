.. _zend.config.introduction:

Introductie
===========

*Zend_Config* is ontworpen om de toegang tot en het gebruik van configuratiedata te vereenvoudigen voor
webapplicaties. Het levert een op geneste object eigenschap gebaseerde gebruikers interface om toegang te krijgen
tot de configuratie data vanuit de webapplicatie. De configuratie data kan van verschillende media komen die
ondersteuning hebben van hiërarchische data opslag. Momenteel levert *Zend_Config* hulpklassen voor
configuratiedata die in tekstbestanden wordt opgeslagen via :ref:`Zend_Config_Ini <zend.config.adapters.ini>` en
:ref:`Zend_Config_Xml <zend.config.adapters.xml>`.

.. _zend.config.introduction.example.using:

.. rubric:: Zend_Config gebruiken zonder hulpklasse

Normaal gesproken wordt er verondersteld dat gebruikers één van de hulpklassen als :ref:`Zend_Config_Ini
<zend.config.adapters.ini>` of :ref:`Zend_Config_Xml <zend.config.adapters.xml>` zullen gebruiken, maar indien de
configuratiedata in een PHP array is opgeslaan, kan je de data direct aan *Zend_Config* doorgeven om een eenvoudig
object geörienteerde interface te gebruiken:

.. code-block::
   :linenos:
   <?php
   // Gegeven een array van configuratiedata
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

   // De object geörienteerde wrapper over de configuratiedata aanmaken
   require_once 'Zend/Config.php';
   $config = new Zend_Config($configArray);

   // Configuratiedata weergeven (resulteert in 'www.example.com')
   echo $config->webhost;

   // De configuratiedata gebruiken om een verbinding met de database
   // tot stand te brenegen
   $db = Zend_Db::factory($config->database->adapter,
                          $config->database->params->toArray());

   // Alternatief gebruik: geef simpelweg het Zend_Config object mee.
   // Zend_Db factory weet hoe het geinterpreteerd moet worden.
   $db = Zend_Db::factory($config->database);
Zoals in het voorbeeld hierboven is geïllustreerd, verstrekt *Zend_Config* een geneste objecteigenschap syntax om
de configuratiedata aan te spreken die aan zijn constructor werd doorgegeven.

Samen met de object geörienteerde toegang tot de data waardes, heeft *Zend_Config* ook *get()* welke de gegeven
standaard waarde zal terug geven, als het data element niet bestaat. Als voorbeeld:

.. code-block::
   :linenos:
   <?php
   $host = $config->database->get('host', 'localhost');

.. _zend.config.introduction.example.file.php:

.. rubric:: Zend_Config gebruiken met een PHP configuratie bestand

Het is vaak wenselijk om een puur op PHP gebaseerd configuratie bestand te gebruiken. De volgende code illustreerd
hoe dat bereikt kan worden:

.. code-block::
   :linenos:
   <?php
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
.. code-block::
   :linenos:
   <?php
   // Configuratie gebruiken
   require_once 'Zend/Config.php';
   $config = new Zend_Config(require 'config.php');

   // Geeft een configuratie waarde weer (resulteert in 'www.example.com')
   echo $config->webhost;

