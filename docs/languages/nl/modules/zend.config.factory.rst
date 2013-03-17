.. EN-Revision: b02c7c75f2799d305e067ab084b0c091b9f36a9a
.. _zend.config.factory:

De Factory
===========

Deze factory stelt je in staat een configuratiebestand te laden als een array of als een ``Zend\Config\Config`` object.

De factory heeft twee doelen

- Configuratiebestand(en) laden
- Configuratiebestand opslaan

.. opmerking::

   Een configuratie opslaan gebeurt naar *één* bestand. De factory is zich niet bewust van het feit dat
   er meerdere configuraties worden samengevoegd en zal deze dus niet afzonderlijk opslaan. Indien je specifieke
   secties van de configuratie in verschillende bestanden wilt opslaan, dan dien je die manueel te splitsen.

Configuratiebestand laden
--------------------------

Het volgende voorbeeld illustreert hoe je een configuratiebestand kan laden

.. code-block:: php
   :linenos:
   
   //Load a php file as array
   $config = Zend\Config\Factory::fromFile(__DIR__.'/config/my.config.php');

   //Load a xml file as Config object
   $config = Zend\Config\Factory::fromFile(__DIR__.'/config/my.config.xml', true);

Om meerdere configuratiebestanden samen te voegen

.. code-block::php
   :linenos:

    $config = Zend\Config\Factory::fromFiles(
        array(
            __DIR__.'/config/my.config.php',
            __DIR__.'/config/my.config.xml',
        )
    );

Configuratiebestand opslaan
----------------------------

Soms wil je je configuratie opslaan als een bestand. Dit is tevens heel makkelijk

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

	
