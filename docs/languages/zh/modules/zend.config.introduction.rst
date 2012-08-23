.. EN-Revision: none
.. _zend.config.introduction:

简介
==

*Zend_Config*\
被设计在应用程序中简化访问和使用配置数据。它为在应用程序代码中访问这样的配置数据提供了一个基于用户接口的嵌入式对象属性。配置数据可能来自于各种支持等级结构数据存储的媒体。当前
*Zend_Config*\ 为存储在 :ref:`Zend_Config_Ini <zend.config.adapters.ini>` 和 :ref:`Zend_Config_Xml
<zend.config.adapters.xml>`\ 的文本文件中的配置数据提供了适配器。

.. _zend.config.introduction.example.using:

.. rubric:: 使用 Zend_Config 本身

通常用户可以使用象 :ref:`Zend_Config_Ini <zend.config.adapters.ini>` 或 :ref:`Zend_Config_Xml
<zend.config.adapters.xml>`\
适配器类的其中之一，但如果配置数据在PHP数组里可用，为了使用一个简单的面向对象的接口，可以简单地传递数据到
*Zend_Config*\ 构造器：

.. code-block:: php
   :linenos:

   // 给出一个配置数据的数组
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

   // 基于配置数据创建面向对象的 wrapper
   $config = new Zend_Config($configArray);

   // 输出配置数据 (结果在'www.example.com'中)
   echo $config->webhost;

   // 使用配置数据来连接数据库
   $db = Zend_Db::factory($config->database->adapter,
                          $config->database->params->toArray());

   // 另外的用法：简单地传递 Zend_Config 对象。
   // Zend_Db factory 知道如何翻译它。
   $db = Zend_Db::factory($config->database);


如上例所示， *Zend_Config*
提供嵌套的对象属性语句来访问传递给它的构造器的配置数据。

连同面向对象访问数据值， *Zend_Config*\ 也有 *get()*\
方法，如果数据元素不存在，它将返回提供的缺省值，例如：

.. code-block:: php
   :linenos:

   $host = $config->database->get('host', 'localhost');


.. _zend.config.introduction.example.file.php:

.. rubric:: Using Zend_Config with a PHP Configuration File

It is often desirable to use a pure PHP-based configuration file. The following code illustrates how easily this
can be accomplished:

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

   // Configuration consumption
   $config = new Zend_Config(require 'config.php');

   // Print a configuration datum (results in 'www.example.com')
   echo $config->webhost;



