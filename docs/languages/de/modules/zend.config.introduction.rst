.. _zend.config.introduction:

Einleitung
==========

``Zend_Config`` wurde entworfen um den Zugriff auf und die Verwendung von Konfigurations-Daten zu vereinfachen. Es
stellt diese Konfigurations-Daten innerhalb der Applikation über eine verschachtelte Objekt-Struktur zur
Verfügung. Die Konfigurations-Daten können aus verschiedenen Datenquellen gelesen werden, die hierarchische
Datenspeicherung unterstützen. Derzeit stellt ``Zend_Config`` mit :ref:`Zend_Config_Ini
<zend.config.adapters.ini>` und :ref:`Zend_Config_Xml <zend.config.adapters.xml>` Adapter für das Einlesen von
Daten aus Textfiles zur Verfügung.

.. _zend.config.introduction.example.using:

.. rubric:: Zend-Config verwenden

In der Regel geht man davon aus, dass Anwender eine der Adapter-Klassen wie :ref:`Zend_Config_Ini
<zend.config.adapters.ini>` oder :ref:`Zend_Config_Xml <zend.config.adapters.xml>` verwenden. Wenn die
Konfigurations-Daten aber als *PHP* Array vorliegen, können diese auch einfach an den ``Zend_Config`` Constructor
übergeben werden, um dann über die objektorientierte Schnittstelle auf sie zugreifen zu können:

.. code-block:: php
   :linenos:

   // Gegeben ist ein Array mit Konfigurations-Daten
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

   // Erstelle das objektorientierte Interface zum Datenzugriff
   $config = new Zend_Config($configArray);

   // Gebe einen Eintrag aus (Ausgabe ist 'www.example.com')
   echo $config->webhost;

   // Konfigurations-Daten benutzen, um eine Datenbank-Verbindung her zu stellen
   $db = Zend_Db::factory($config->database->adapter,
                          $config->database->params->toArray());

   // Alternative Verwendung: einfach das Zend_Config Objekt übergeben.
   // Zend_Db factory weiß wie es zu interpretieren ist.
   $db = Zend_Db::factory($config->database);

Wie das Beispiel oben zeigt, kann man über ``Zend_Config`` auf die Konfigurations-Daten aus dem übergebenen Array
so zugreifen, wie auf die Eigenschaften einer verschachtelten Objekt-Struktur.

Zusätzlich zum objektorientierten Zugriff auf die Daten Werte hat ``Zend_Config`` ``get()`` welches den
unterstützten Standardwert zurückgibt wenn das Daten Element nicht existiert. Zum Beispiel:

.. code-block:: php
   :linenos:

   $host = $config->database->get('host', 'localhost');

.. _zend.config.introduction.example.file.php:

.. rubric:: Zend_Config mit einer PHP Konfigurationsdatei verwenden

Es ist oft gewünscht eine reine *PHP* basierende Konfigurationsdatei zu verwenden. Der folgende Code zeigt wie das
ganz einfach erreicht werden kann:

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
               'password' => 'geheim',
               'dbname'   => 'mydatabase'
           )
       )
   );

.. code-block:: php
   :linenos:

   // Konfiguration konsumieren
   $config = new Zend_Config(require 'config.php');

   // Einen Konfigurationswert ausgeben (führt zu 'www.example.com')
   echo $config->webhost;


