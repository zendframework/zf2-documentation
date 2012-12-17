.. EN-Revision: 9e6907f
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
хранящихся в текстовых файлах: :ref:`Zend\Config\Ini <zend.config.adapters.ini>` и
:ref:`Zend\Config\Xml <zend.config.adapters.xml>`.

``Zend\Config`` is designed to simplify access to configuration data within applications. It
provides a nested object property-based user interface for accessing this configuration data within application
code. The configuration data may come from a variety of media supporting hierarchical data storage. Currently,
``Zend\Config`` provides adapters that read and write configuration data stored in .ini, JSON, YAML and XML files.

.. _zend.config.introduction.example.using:

Using Zend\\Config\\Config with a Reader Class
----------------------------------------------

Обычно предполагается, что используется один из классов
адаптеров, например, :ref:`Zend\Config\Ini <zend.config.adapters.ini>` или
:ref:`Zend\Config\Xml <zend.config.adapters.xml>`. Но если конфигурационные данные
доступны в виде массива *PHP*, то можно передавать эти данные
конструктору ``Zend_Config``, чтобы использовать преимущества
простого объектно-ориентированного интерфейса.

Normally, it is expected that users would use one of the :ref:`reader classes <zend.config.reader>` to read a
configuration file, but if configuration data are available in a *PHP* array, one may simply pass the data
to ``Zend\Config\Config``'s constructor in order to utilize a simple object-oriented interface:

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
   $config = new Zend\Config\Config($configArray);

   // Вывод элемента конфигурационных данных (результатом будет 'www.example.com')
   echo $config->webhost;

Как показано в предыдущем примере, в ``Zend_Config`` для доступа к
конфигурационным данным, переданным его конструктору,
используется синтаксис вложенных свойств объектов.

Кроме объектно-ориентированного доступа к значениям данных,
``Zend_Config`` также предоставляет метод ``get()``, который будет
возвращать значение по умолчанию, если элемент данных не
существует. Например:


As illustrated in the example above, ``Zend\Config\Config`` provides nested object property syntax to access
configuration data passed to its constructor.

Along with the object oriented access to the data values, ``Zend\Config\Config`` also has ``get()`` method that
returns the supplied value if the data element doesn't exist in the configuration array. For example:

.. code-block:: php
   :linenos:

   $host = $config->database->get('host', 'localhost');

.. _zend.config.introduction.example.file.php:

Using Zend\\Config\\Config with a PHP Configuration File
--------------------------------------------------------

Часто требуется использовать конфигурационный файл,
основанный на "чистом"*PHP*. Следующий код показывает, как просто
этого достичь:

It is often desirable to use a purely *PHP*-based configuration file. The following code illustrates how easily this
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

   // Использование конфигурации
   $config = new Zend\Config\Config(include 'config.php');

   // Вывод элемента конфигурационных данных (результатом будет 'www.example.com')
   echo $config->webhost;


