.. EN-Revision: none
.. _zend.config.introduction:

Introducción
============

``Zend_Config`` está diseñado para simplificar el acceso y el uso de datos de configuración dentro de
aplicaciones. Provee una interfaz de usuario basada en propiedades de objetos anidadas para acceder a datos de
configuración dentro del código de la aplicación. Los datos de configuración pueden venir de multitud de medios
que soporten almacenamiento de datos de forma jerárquica. Actualmente ``Zend_Config`` provee adaptadores para
datos de configuración que están almacenados en archivos de texto con :ref:`Zend_Config_Ini
<zend.config.adapters.ini>` y :ref:`Zend_Config_Xml <zend.config.adapters.xml>`.

.. _zend.config.introduction.example.using:

.. rubric:: Usando Zend_Config Per Se

Normalmente, se espera que los usuarios usen una de las clases adaptadoras como :ref:`Zend_Config_Ini
<zend.config.adapters.ini>` o :ref:`Zend_Config_Xml <zend.config.adapters.xml>`, pero si los datos de
configuración están disponibles en un array *PHP*, se puede simplemente pasar los datos al constructor
``Zend_Config`` para utilizar una interfaz simple orientada a objetos:

.. code-block:: php
   :linenos:

   // Dado un array de datos de configuración
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

   // Crea el objeto a partir de los datos de configuración
   $config = new Zend_Config($configArray);

   // Muestra un dato de configuración (resultado: 'www.example.com')
   echo $config->webhost;

   // Use los datos de configuración para conectarse a la base de datos
   $db = Zend_Db::factory($config->database->adapter,
                          $config->database->params->toArray());

   // Uso alternativo: simplemente pase el objeto Zend_Config.
   // La Zend_Db factory sabe cómo interpretarlo.
   $db = Zend_Db::factory($config->database);

Como se ilustra en el ejemplo de arriba, ``Zend_Config`` provee una sintáxis de propiedades de objetos anidados
para acceder a datos de configuración pasados a su constructor.

Junto al acceso a valores de datos orientado a objetos, ``Zend_Config`` también tiene el método ``get()`` que
devolverá el valor por defecto suministrado si el elemento de datos no existe. Por ejemplo:

.. code-block:: php
   :linenos:

   $host = $config->database->get('host', 'localhost');

.. _zend.config.introduction.example.file.php:

.. rubric:: Usando Zend_Config con un Archivo de Configuración PHP

A veces, es deseable usar un archivo de configuración puramente *PHP*. El código siguiente ilustra cómo podemos
conseguir esto fácilmente:

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

   // Lectura de la configuración
   $config = new Zend_Config(require 'config.php');

   // Muestra un dato de configuración (resultado: 'www.example.com')
   echo $config->webhost;


