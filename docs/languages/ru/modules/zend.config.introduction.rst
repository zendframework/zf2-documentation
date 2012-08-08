.. EN-Revision: none
.. _zend.config.introduction:

Введение
========

``Zend_Config`` создан для того, чтобы сделать более простым доступ к
конфигурационным данным и их использование внутри приложения.
Он предоставляет основанный на вложенных свойствах объектов
пользовательский интерфейс для доступа к конфигурационным
данным внутри приложения. Конфигурационные данные могут
храниться на различных носителях информации, поддерживающих
хранение данных в виде иерархии. На данный момент ``Zend_Config``
предоставляет адаптеры для конфигурационных данных,
хранящихся в текстовых файлах: :ref:`Zend_Config_Ini <zend.config.adapters.ini>` и
:ref:`Zend_Config_Xml <zend.config.adapters.xml>`.

.. _zend.config.introduction.example.using:

.. rubric:: Использование Zend_Config

Обычно предполагается, что используется один из классов
адаптеров, например, :ref:`Zend_Config_Ini <zend.config.adapters.ini>` или
:ref:`Zend_Config_Xml <zend.config.adapters.xml>`. Но если конфигурационные данные
доступны в виде массива *PHP*, то можно передавать эти данные
конструктору ``Zend_Config``, чтобы использовать преимущества
простого объектно-ориентированного интерфейса.

.. code-block:: php
   :linenos:

   // Массив конфигурационных данных
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

   // Создание объектно-ориентированной обертки для конфигурационных данных
   require_once 'Zend/Config.php';
   $config = new Zend_Config($configArray);

   // Вывод элемента конфигурационных данных (результатом будет 'www.example.com')
   echo $config->webhost;

   // Использование конфигурационных данных для соединения с базой данных
   $db = Zend_Db::factory($config->database->adapter,
                          $config->database->params->toArray());

   // Альтернативный способ - просто передавайте объект Zend_Config.
   // Фабрика Zend_Db знает, как его интерпретировать.
   $db = Zend_Db::factory($config->database);

Как показано в предыдущем примере, в ``Zend_Config`` для доступа к
конфигурационным данным, переданным его конструктору,
используется синтаксис вложенных свойств объектов.

Кроме объектно-ориентированного доступа к значениям данных,
``Zend_Config`` также предоставляет метод ``get()``, который будет
возвращать значение по умолчанию, если элемент данных не
существует. Например:

.. code-block:: php
   :linenos:

   $host = $config->database->get('host', 'localhost');

.. _zend.config.introduction.example.file.php:

.. rubric:: Использование Zend_Config с конфигурационным файлом PHP

Часто требуется использовать конфигурационный файл,
основанный на "чистом"*PHP*. Следующий код показывает, как просто
этого достичь:

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

   // Использование конфигурации
   $config = new Zend_Config(require 'config.php');

   // Вывод элемента конфигурационных данных (результатом будет 'www.example.com')
   echo $config->webhost;


