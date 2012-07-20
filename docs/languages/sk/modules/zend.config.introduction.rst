.. _zend.config.introduction:

Úvod
====

*Zend_Config* je navrhnutý pre zjednodušenie prístupu a použitia konfiguračných údajov v rámci aplikácie.
Poskytuje vnorené vlastnosti pre prístup ku konfigurácii v rámci aplikácie. Konfiguračné údaje môžu byt z
rozličných zdrojov a je podporované aj hierarchické uloženie. Momentálne *Zend_Config* poskytuje adaptéry
pre prístup k konfiguračným dátam uloženým v textových súboroch pomocou :ref:`Zend_Config_Ini
<zend.config.adapters.ini>` a :ref:`Zend_Config_Xml <zend.config.adapters.xml>`.

.. _zend.config.introduction.example.using:

.. rubric:: Použitie Zend_Config

Očakáva sa, že sa použije jeden z adaptérov ako napríklad :ref:`Zend_Config_Ini <zend.config.adapters.ini>`,
alebo :ref:`Zend_Config_Xml <zend.config.adapters.xml>`, ale ak sú konfiguračné dáta prístupné ako PHP pole,
je možné predať toto pole *Zend_Config* konštruktoru a zužitkovať jednoduchý objektovo-orientovaný
prístup:

.. code-block::
   :linenos:
   <?php
   // konfigurácia uložená v poli
   $configArray = array(
       'webhost' => 'www.example.com',
       'database' => array(
           'type'     => 'pdo_mysql',
           'host'     => 'db.example.com',
           'username' => 'dbuser',
           'password' => 'secret',
           'name'     => 'dbname'
       )
   );

   // Vytvorenie Zend_Config
   require_once 'Zend/Config.php';
   $config = new Zend_Config($configArray);

   // vypísanie položky z konfigurácie (výsledok: 'www.example.com')
   echo $config->webhost;

   // Použitie dát na pripojenie k databáze
   $myApplicationObject->databaseConnect($config->database->type,
                                         $config->database->host,
                                         $config->database->username,
                                         $config->database->password,
                                         $config->database->name);
V uvedenom príklade, *Zend_Config* poskytuje pomocou vnorených objektov prístup ku konfiguračným dátam,
ktoré mu boli predané v konštruktore.

Popri objektovo-orientovanom prístupe *Zend_Config* poskytuje metódu *get()* ktorá umožňuje vrátiť zadanú
východziu hodnotu. Na príklad:

.. code-block::
   :linenos:
   <?php
       $host = $config->database->get('host', 'localhost');


