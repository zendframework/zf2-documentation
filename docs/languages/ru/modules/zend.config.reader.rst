.. EN-Revision: 9e6907f
.. _zend.config.reader.introduction:

Zend\\Config\\Reader
====================

``Zend\Config\Reader`` дает вам возможность прочитать конфигурационный файл. Он работает с конкретными
реализациями под различные форматы файлов. ``Zend\Config\Reader`` является просто интерфейсом, который определяюет
два метода: ``fromFile()`` и ``fromString()``. Конкретными реализациями этого интерфейса являются:

- ``Zend\Config\Reader\Ini``

- ``Zend\Config\Reader\Xml``

- ``Zend\Config\Reader\Json``

- ``Zend\Config\Reader\Yaml``

Методы ``fromFile()`` и ``fromString()`` возвращают PHP-массив, содержащий данные конфигурационного файла.

.. note::

   **Отличия от ZF1**

   Компонент ``Zend\Config\Reader`` больше не поддерживает следующие возможности:

   - Наследование разделов.

   - Чтение конкретных разделов.

.. _zend.config.reader.ini:

Zend\\Config\\Reader\\Ini
-------------------------

``Zend\Config\Reader\Ini`` позволяет разработчикам хранить конфигурационные данные в знакомом формате *INI* и
читать их в приложении, используя синтаксис массива.

``Zend\Config\Reader\Ini`` использует *PHP*-функцию `parse_ini_file()`_. Пожалуйста, прочитайте документацию, чтобы
быть в курсе особенностей её поведения, которые распространяются и на ``Zend\Config\Reader\Ini``, таких как
обработка специальных значений "``TRUE``", "``FALSE``", "yes", "no", и "``NULL``".

.. note::

   **Разделитель Ключей**

   По умолчанию, символом-разделителем ключей является символ точки ("**.**"). При необходимости его можно
   изменить, используя метод ``setNestSeparator()``. Например:

   .. code-block:: php
      :linenos:

      $reader = new Zend\Config\Reader\Ini();
      $reader->setNestSeparator('-');

Следующий пример показывает базовое использование ``Zend\Config\Reader\Ini`` для загрузки конфигурационных данных
из *INI*-файла. В этом примере есть конфигурационные данные для двух систем: находящейся в промышленной
эксплуатиции и в подготовительной эксплуатации. Предположим, что у нас есть следующий конфигурационный INI-файл:

.. code-block:: ini
   :linenos:

   webhost                  = 'www.example.com'
   database.adapter         = 'pdo_mysql'
   database.params.host     = 'db.example.com'
   database.params.username = 'dbuser'
   database.params.password = 'secret'
   database.params.dbname   = 'dbproduction'

Для чтения этого INI-файла мы можем использовать ``Zend\Config\Reader\Ini``:

.. code-block:: php
   :linenos:

   $reader = new Zend\Config\Reader\Ini();
   $data   = $reader->fromFile('/path/to/config.ini');

   echo $data['webhost']  // выведет "www.example.com"
   echo $data['database']['params']['dbname'];  // выведет "dbproduction"

``Zend\Config\Reader\Ini`` поддерживает возможность включать содержимое одного INI-файла в определенный раздел
другого INI-файла. Например, предположим, у нас есть INI-файл с конфигурацией подключения к базе данных:

.. code-block:: ini
   :linenos:

   database.adapter         = 'pdo_mysql'
   database.params.host     = 'db.example.com'
   database.params.username = 'dbuser'
   database.params.password = 'secret'
   database.params.dbname   = 'dbproduction'

Мы можем включить эту конфигурацию в другой INI-файл. Напрмиер:

.. code-block:: ini
   :linenos:

   webhost  = 'www.example.com'
   @include = 'database.ini'

Если мы прочтём этот файл используя компонент ``Zend\Config\Reader\Ini``, мы получим такую же структуру
конфигурационных данных, как в предыдущем примере.

``@include = 'file-to-include.ini'`` может применяться и как значение вложенного эелемента. Например, у нас может
быть такой  INI-файл:

.. code-block:: ini
   :linenos:

   adapter         = 'pdo_mysql'
   params.host     = 'db.example.com'
   params.username = 'dbuser'
   params.password = 'secret'
   params.dbname   = 'dbproduction'

И присвоение ``@include`` как вложенного элемента значения базы данных:

.. code-block:: ini
   :linenos:

   webhost           = 'www.example.com'
   database.@include = 'database.ini'

.. _zend.config.reader.xml:

Zend\\Config\\Reader\\Xml
-------------------------

``Zend\Config\Reader\Xml`` позволяет разработчикам читать конфигурационные данные из привычного формата *XML* и
читать его в приложении аналогично массивам. Корневой элемент *XML*-файла или строки не имеет значения и может быть
назван произвольно.

Следующий пример иллюстрирует основное использование ``Zend\Config\Reader\Xml`` для загрузки конфигурационных
данных из *XML*-файла. Предположим, что у нас есть следующий конфигурационный *XML*-файл:

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="utf-8"?>?>
   <config>
       <webhost>www.example.com</webhost>
       <database>
           <adapter value="pdo_mysql"/>
           <params>
               <host value="db.example.com"/>
               <username value="dbuser"/>
               <password value="secret"/>
               <dbname value="dbproduction"/>
           </params>
       </database>
   </config>

Мы можем использовать ``Zend\Config\Reader\Xml`` для чтения этого XML-файла:

.. code-block:: php
   :linenos:

   $reader = new Zend\Config\Reader\Xml();
   $data   = $reader->fromFile('/path/to/config.xml');

   echo $data['webhost']  // выведет "www.example.com"
   echo $data['database']['params']['dbname'];  // выведет "dbproduction"

``Zend\Config\Reader\Xml`` использует *PHP*-класс `XMLReader`_. Пожалуйста, прочитайте документацию, чтобы
быть в курсе особенностей её поведения, которые распространяются и на ``Zend\Config\Reader\Xml``.

Используя ``Zend\Config\Reader\Xml`` мы можем включать содержимое XML-файлов в определенный XML-элемент. Это
обеспечивается с помощью стандартной функции XML `XInclude`_. Что бы воспользоваться этой функцией нужно добавить в
XML-файл пространство имен ``xmlns:xi="http://www.w3.org/2001/XInclude"``. Предположим, у нас есть XML-файлы,
содержщие только настройки соединения с базой данных:

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="utf-8"?>
   <config>
       <database>
           <adapter>pdo_mysql</adapter>
           <params>
               <host>db.example.com</host>
               <username>dbuser</username>
               <password>secret</password>
               <dbname>dbproduction</dbname>
           </params>
       </database>
   </config>

Мы можем включить эти настройки в другой XML-файл. Например:

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="utf-8"?>
   <config xmlns:xi="http://www.w3.org/2001/XInclude">
       <webhost>www.example.com</webhost>
       <xi:include href="database.xml"/>
   </config>

Синтаксис для включения XML-файла в определенный элемент - ``<xi:include href="file-to-include.xml"/>``

.. _zend.config.reader.json:

Zend\\Config\\Reader\\Json
--------------------------

``Zend\Config\Reader\Json`` позволяет разработчикам читать конфигурационные данные из формата *JSON* и читать его в
приложении аналогично массивам.

Следующий пример показвает основы использования ``Zend\Config\Reader\Json`` для загрузки конфигурационных данных
из *JSON*-файла. Предположим, у нас есть следующий конфигурационный файл в формате *JSON*:

.. code-block:: json
   :linenos:

   {
     "webhost"  : "www.example.com",
     "database" : {
       "adapter" : "pdo_mysql",
       "params"  : {
         "host"     : "db.example.com",
         "username" : "dbuser",
         "password" : "secret",
         "dbname"   : "dbproduction"
       }
     }
   }

Мы можем использовать ``Zend\Config\Reader\Json`` для чтения этого JSON-файла:

.. code-block:: php
   :linenos:

   $reader = new Zend\Config\Reader\Json();
   $data   = $reader->fromFile('/path/to/config.json');

   echo $data['webhost']  // выведет "www.example.com"
   echo $data['database']['params']['dbname'];  // выведет "dbproduction"

``Zend\Config\Reader\Json`` использует класс :ref:`Zend\\Json\\Json <zend.json.introduction>`.

Используя ``Zend\Config\Reader\Json`` мы можем включать содержимое JSON-файла в определенный раздел или элемент
JSON. Это обеспечивается с помощью специальной инструкции ``@include``. Предположим, у нас есть
JSON-файл, который содержит только настройки подключения к базе данных:

.. code-block:: json
   :linenos:

   {
     "database" : {
       "adapter" : "pdo_mysql",
       "params"  : {
         "host"     : "db.example.com",
         "username" : "dbuser",
         "password" : "secret",
         "dbname"   : "dbproduction"
       }
     }
   }


Мы можем включить эту настройку в другой JSON-файл. Пример:

.. code-block:: json
   :linenos:

   {
       "webhost"  : "www.example.com",
       "@include" : "database.json"
   }

.. _zend.config.reader.yaml:

Zend\\Config\\Reader\\Yaml
--------------------------

``Zend\Config\Reader\Yaml`` позволяет разработчикам читать конфигурационные данные в формате *YAML* и использовать
их в приложении аналогично массивам. Для использования читателя YAML нам нужно передать функцию обратного вызова
во внешнюю бибилиотеку PHP или воспользоваться `Yaml PECL extension`_.

Следующий пример показывает основы использования ``Zend\Config\Reader\Yaml`` применяя PECL-расширение Yaml.
Предположим, у нас есть следующий конфигурационный *YAML*-файл:

.. code-block:: yaml
   :linenos:

   webhost: www.example.com
   database:
       adapter: pdo_mysql
       params:
         host:     db.example.com
         username: dbuser
         password: secret
         dbname:   dbproduction

Мы можем использовать ``Zend\Config\Reader\Yaml`` для чтения этого YAML-файла:

.. code-block:: php
   :linenos:

   $reader = new Zend\Config\Reader\Yaml();
   $data   = $reader->fromFile('/path/to/config.yaml');

   echo $data['webhost']  // выведет "www.example.com"
   echo $data['database']['params']['dbname'];  // выведет "dbproduction"

Если вы хотите использовать внешний читатель YAML, вы должны передать в конструктор класса функцию обратного
вызова. Например, если вы хотите использовать библиотеку `Spyc`_:

.. code-block:: php
   :linenos:

   // подключаем библиотеку Spyc
   require_once ('path/to/spyc.php');

   $reader = new Zend\Config\Reader\Yaml(array('Spyc','YAMLLoadString'));
   $data   = $reader->fromFile('/path/to/config.yaml');

   echo $data['webhost']  // выводит "www.example.com"
   echo $data['database']['params']['dbname'];  // выводит "dbproduction"

Так же вы можете инициализировать ``Zend\Config\Reader\Yaml`` вообще без параметров и указать читателя YAML позже
воспользовавшись методом ``setYamlDecoder()``.

Используя ``Zend\Config\ReaderYaml`` вы можете включать содержимое YAML-файла в определенный раздел или элемент
другого YAML-файла. Это обеспечивается с помощью специальной инструкции ``@include``. Предположим, у нас есть
YAML-файл, который содержит только настройки доступа к базе данных:

.. code-block:: yaml
   :linenos:

   database:
       adapter: pdo_mysql
       params:
         host:     db.example.com
         username: dbuser
         password: secret
         dbname:   dbproduction

Мы можем включить эти настройки в другой YAML-файл. Пример:

.. code-block:: yaml
   :linenos:

   webhost:  www.example.com
   @include: database.yaml



.. _`parse_ini_file()`: http://php.net/parse_ini_file
.. _`XMLReader`: http://php.net/xmlreader
.. _`XInclude`: http://www.w3.org/TR/xinclude/
.. _`Yaml PECL extension`: http://www.php.net/manual/en/book.yaml.php
.. _`Spyc`: http://code.google.com/p/spyc/
