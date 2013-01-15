.. EN-Revision: 9e6907f
.. _zend.config.introduction:

Введение
========

``Zend\Config`` создан для упрощения доступа к конфигурационным данным приложения. Для доступа к
конфигурационным данным внутри приложения он предоставляет пользовательский интерфейс,
основанный на вложенных свойствах объектов. Конфигурационные данные могут поступать из различных источников,
поддерживающих иерархическое хранение данных. На данный момент ``Zend\Config`` предоставляет
адаптеры, которые могут читать и записывать данные сохраненные в .ini, JSON, YAML и XML файлах.

.. _zend.config.introduction.example.using:

Использование Zend\\Config\\Config с классом-читателем
------------------------------------------------------

Как правило, предполагается, что пользователи будут использовать один из
:ref:`классов для чтения <zend.config.reader>` конфигурационного файла, однако, если конфигурационные данные
доступны в виде *PHP*-массива, достаточно передать его в конструктор ``Zend\Config\Config`` для использования
простого объектно-ориентированного интерфейса:

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

Как показано в примере выше, ``Zend\Config\Config`` предоставляет возможность использовать вложенных свойств для
доступа к конфигурационным данным, переданным в конструктор.

Наравне с объектно-ориентированным доступом к данным, ``Zend\Config\Config`` так же имеет метод ``get()``,
который возвращает значение по умолчанию, если такого элемента нет в конфигурационном массиве. Например:

.. code-block:: php
   :linenos:

   $host = $config->database->get('host', 'localhost');

.. _zend.config.introduction.example.file.php:

Использование Zend\\Config\\Config с конфигурационным файлом на PHP
----------------------------------------------------------------

Часто возникает необходимость использовать конфигурационный файл на "чистом" *PHP*. В следующем примере показано
на сколько легко это можно сделать:

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


