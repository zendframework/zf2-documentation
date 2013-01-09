.. EN-Revision: 94093e3
.. _zend.config.writer:

Zend\\Config\\Writer
====================

``Zend\Config\Writer`` предоставляет вам возможность создавать конфигурационные файлы из PHP-массива,
``Zend\Config\Config`` и любого объекта, реализующиего интерфейс Traversable. ``Zend\Config\Writer`` является
интерфейсом, в котором объявлены два метода: ``toFile()`` и ``toString()``. У нас есть пять конкретных реализаций
этого интерфейса:

- ``Zend\Config\Writer\Ini``

- ``Zend\Config\Writer\Xml``

- ``Zend\Config\Writer\PhpArray``

- ``Zend\Config\Writer\Json``

- ``Zend\Config\Writer\Yaml``

.. _zend.config.writer.ini:

Zend\\Config\\Writer\\Ini
-------------------------

У *INI*-писателя есть два режима работы в отношении разделов. По умолчанию, настройки верхнего уровня всегда
записываются в качестве названий разделов. При вызове ``$writer->setRenderWithoutSectionsFlags(true);`` все
настройки будут записываться в общее пространство имен *INI*-файла без создания разделов.

В дополнение ``Zend\Config\Writer\Ini`` имеет дополнительный параметр **nestSeparator**, который определяет
символ-разделитель отдельных узлов. По умолчанию, таким символом является точка.

При изменении или создании объекта ``Zend\Config\Config``, следует знать о некоторых вещах. Для создания или
изменения значения вы просто устанавливаете параметр объекта ``Config`` через механизм доступа к параметру (**->**).
Для создания раздела в корне или для создания ветки вы просто создаете новый массив
("``$config->branch = array();``").

.. _zend.config.writer.ini.example:

.. rubric:: Использование Zend\\Config\\Writer\\Ini

Этот пример демонстрирует основы использования ``Zend\Config\Writer\Ini`` для создания нового конфигурационного
файла:

.. code-block:: php
   :linenos:

   // Создаем конфигурационный объект
   $config = new Zend\Config\Config(array(), true);
   $config->production = array();

   $config->production->webhost = 'www.example.com';
   $config->production->database = array();
   $config->production->database->params = array();
   $config->production->database->params->host = 'localhost';
   $config->production->database->params->username = 'production';
   $config->production->database->params->password = 'secret';
   $config->production->database->params->dbname = 'dbproduction';

   $writer = new Zend\Config\Writer\Ini();
   echo $writer->toString($config);

Результатом работы этого кода станет строка в формате INI, содержащая следующее:

.. code-block:: ini
   :linenos:

   [production]
   webhost = "www.example.com"
   database.params.host = "localhost"
   database.params.username = "production"
   database.params.password = "secret"
   database.params.dbname = "dbproduction"

Вы можете использовать метод ``toFile()`` чтобы сохранить INI-данные в файл.

.. _zend.config.writer.xml:

Zend\\Config\\Writer\\Xml
-------------------------

``Zend\Config\Writer\Xml`` может использоваться для создания XML-строки или файла основываясь на объекте
``Zend\Config\Config``.

.. _zend.config.writer.xml.example:

.. rubric:: Использование Zend\\Config\\Writer\\Ini

Этот пример показывает основы использования ``Zend\Config\Writer\Xml`` для создания нового конфигурационного
файла:

.. code-block:: php
   :linenos:

   // Создаем конфигурационный объект
   $config = new Zend\Config\Config(array(), true);
   $config->production = array();

   $config->production->webhost = 'www.example.com';
   $config->production->database = array();
   $config->production->database->params = array();
   $config->production->database->params->host = 'localhost';
   $config->production->database->params->username = 'production';
   $config->production->database->params->password = 'secret';
   $config->production->database->params->dbname = 'dbproduction';

   $writer = new Zend\Config\Writer\Xml();
   echo $writer->toString($config);

Результатом работы этого кода станет строка в формате XML, содержащая следующее:

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <zend-config>
       <production>
           <webhost>www.example.com</webhost>
           <database>
               <params>
                   <host>localhost</host>
                   <username>production</username>
                   <password>secret</password>
                   <dbname>dbproduction</dbname>
               </params>
           </database>
       </production>
   </zend-config>

Вы можете использовать метод ``toFile()`` для сохранения XML-данных в файл.

.. _zend.config.writer.phparray:

Zend\\Config\\Writer\\PhpArray
------------------------------

``Zend\Config\Writer\PhpArray`` можно использовать для генерации PHP кода, который возвращает представленный в
виде массива объект ``Zend\Config\Config``.

.. _zend.config.writer.phparray.example:

.. rubric:: Использование Zend\\Config\\Writer\\PhpArray

Этот пример демонстрирует основы использования ``Zend\Config\Writer\PhpArray`` для создания нового
конфигурационного файла:

.. code-block:: php
   :linenos:

   // Создаем конфигурационный объект
   $config = new Zend\Config\Config(array(), true);
   $config->production = array();

   $config->production->webhost = 'www.example.com';
   $config->production->database = array();
   $config->production->database->params = array();
   $config->production->database->params->host = 'localhost';
   $config->production->database->params->username = 'production';
   $config->production->database->params->password = 'secret';
   $config->production->database->params->dbname = 'dbproduction';

   $writer = new Zend\Config\Writer\PhpArray();
   echo $writer->toString($config);

Результатом работы этого кода станет PHP-скрипт, возвращающий массив:

.. code-block:: php
   :linenos:

   <?php
   return array (
     'production' =>
     array (
       'webhost' => 'www.example.com',
       'database' =>
       array (
         'params' =>
         array (
           'host' => 'localhost',
           'username' => 'production',
           'password' => 'secret',
           'dbname' => 'dbproduction',
         ),
       ),
     ),
   );

Вы можете использовать метод ``toFile()`` для сохранения PHP-скрипта в файл.

.. _zend.config.writer.json:

Zend\\Config\\Writer\\Json
--------------------------

``Zend\Config\Writer\Json`` можно использовать для генерации PHP кода, который возвращает представленный в виде
JSON-строки объект ``Zend\Config\Config``.

.. _zend.config.writer.json.example:

.. rubric:: Использование Zend\\Config\\Writer\\Json

Этот пример демонстрирует основы использования ``Zend\Config\Writer\Json`` для создания нового конфигурационного
файла:

.. code-block:: php
   :linenos:

   // создаем конфигурационный объект
   $config = new Zend\Config\Config(array(), true);
   $config->production = array();

   $config->production->webhost = 'www.example.com';
   $config->production->database = array();
   $config->production->database->params = array();
   $config->production->database->params->host = 'localhost';
   $config->production->database->params->username = 'production';
   $config->production->database->params->password = 'secret';
   $config->production->database->params->dbname = 'dbproduction';

   $writer = new Zend\Config\Writer\Json();
   echo $writer->toString($config);

Результатом работы этого кода станет JSON-строка, содержащая следующее:

.. code-block:: json
   :linenos:

   { "webhost"  : "www.example.com",
     "database" : {
       "params"  : {
         "host"     : "localhost",
         "username" : "production",
         "password" : "secret",
         "dbname"   : "dbproduction"
       }
     }
   }

Вы можете использовать метод ``toFile()`` для сохранения JSON-данных в файл.

Класс ``Zend\Config\Writer\Json`` использует компонент ``Zend\Json\Json`` для конвертации данных в формат JSON.

.. _zend.config.writer.yaml:

Zend\\Config\\Writer\\Yaml
--------------------------

``Zend\Config\Writer\Yaml`` можно использовать для генерации PHP кода, который возвращает представленный в виде
YAML объект ``Zend\Config\Config``. Для использования писателя YAML нам нужно передать функцию обратного вызова
во внешнюю бибилиотеку PHP или воспользоваться `Yaml PECL extension`_.

.. _zend.config.writer.yaml.example:

.. rubric:: Использование Zend\\Config\\Writer\\Yaml

Этот пример демонстрирует основы использования ``Zend\Config\Writer\Yaml`` для создания нового файла с
использованием PECL-расширения Yaml:

.. code-block:: php
   :linenos:

   // Создаем конфигурационный объект
   $config = new Zend\Config\Config(array(), true);
   $config->production = array();

   $config->production->webhost = 'www.example.com';
   $config->production->database = array();
   $config->production->database->params = array();
   $config->production->database->params->host = 'localhost';
   $config->production->database->params->username = 'production';
   $config->production->database->params->password = 'secret';
   $config->production->database->params->dbname = 'dbproduction';

   $writer = new Zend\Config\Writer\Yaml();
   echo $writer->toString($config);

Результатом работы этого кода станет YAML-строка, содержащая следующее:

.. code-block:: yaml
   :linenos:

   webhost: www.example.com
   database:
       params:
         host:     localhost
         username: production
         password: secret
         dbname:   dbproduction

Вы можете использовать метод ``toFile()`` для сохранения YAML-данных в файл.

Если вы хотите использовать внешнюю библиотеку для записи YAML, вам нужно передать функцию обратного вызова в
конструктор класса. Например, если вы хотите использовать библиотеку `Spyc`_:

.. code-block:: php
   :linenos:

   // подключаем библиотеку Spyc
   require_once ('path/to/spyc.php');

   $writer = new Zend\Config\Writer\Yaml(array('Spyc','YAMLDump'));
   echo $writer->toString($config);



.. _`Yaml PECL extension`: http://www.php.net/manual/en/book.yaml.php
.. _`Spyc`: http://code.google.com/p/spyc/
