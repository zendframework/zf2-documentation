.. EN-Revision: none
.. _zend.config.introduction:

Introduction
============

``Zend_Config`` est conçu pour simplifier l'accès et l'utilisation des données de configuration dans les
applications. Il fournit une interface utilisateur basée sur des propriétés d'objets imbriquées. Les données
de configuration peuvent venir de sources variées supportant une organisation hiérarchique des données.
Actuellement ``Zend_Config`` fournit des adaptateurs pour les données de configuration qui sont stockées dans des
fichier textes avec :ref:`Zend_Config_Ini <zend.config.adapters.ini>` et :ref:`Zend_Config_Xml
<zend.config.adapters.xml>`.

.. _zend.config.introduction.example.using:

.. rubric:: Utilisation native de Zend_Config

Normalement on s'attend à ce que les utilisateurs emploient une des classes d'adaptateur telles que
:ref:`Zend_Config_Ini <zend.config.adapters.ini>` ou :ref:`Zend_Config_Xml <zend.config.adapters.xml>`, mais si les
données de configuration sont disponibles dans un tableau *PHP*, on peut simplement passer les données au
constructeur de ``Zend_Config`` afin d'utiliser une interface orientée objet simple :

.. code-block:: php
   :linenos:

   // Fourni un tableau de configuration
   $configArray = array(
       'webhost' => 'www.example.com',
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

   // Crée un objet à partir des données de configuration
   $config = new Zend_Config($configArray);

   // Affiche une donnée de configuration en particulier
   // (résultat : 'www.example.com')
   echo $config->webhost;

   // Utilise les données de configuration pour se connecter
   // à une base de données
   $db = Zend_Db::factory($config->database->adapter,
                          $config->database->params->toArray());

   // Autre possibilité : fournir simplement l'objet Zend_Config.
   // Zend_Db factory sait comment l'interpréter.
   $db = Zend_Db::factory($config->database);

Comme illustré dans l'exemple ci-dessus, ``Zend_Config`` fournit une syntaxe de propriétés d'objets imbriquées
pour accéder aux données de configuration passées à son constructeur.

Avec l'accès de type orienté-objet aux données, ``Zend_Config`` a aussi la méthode ``get()`` qui retournera la
valeur par défaut si l'élément n'existe pas. Par exemple :

.. code-block:: php
   :linenos:

   $host = $config->database->get('host', 'localhost');

.. _zend.config.introduction.example.file.php:

.. rubric:: Utilisez Zend_Config avec un fichier de configuration en PHP

Il est souvent souhaitable d'utiliser une fichier de configuration en pur *PHP*. Le code suivant illustre comment
ceci peut être facilement réalisé :

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

   // Lecture de la configuration
   $config = new Zend_Config(require 'config.php');

   // Affiche une donnée de configuration ('www.example.com')
   echo $config->webhost;


