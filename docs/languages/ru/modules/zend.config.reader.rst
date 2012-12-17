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

``Zend\Config\Reader\Xml`` enables developers to read configuration data in a familiar *XML* format and read them
in the application by using an array syntax. The root element of the *XML* file or string is irrelevant and may be
named arbitrarily.

The following example illustrates a basic use of ``Zend\Config\Reader\Xml`` for loading configuration data from an
*XML* file. Suppose we have the following *XML* configuration file:

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

We can use the ``Zend\Config\Reader\Xml`` to read this XML file:

.. code-block:: php
   :linenos:

   $reader = new Zend\Config\Reader\Xml();
   $data   = $reader->fromFile('/path/to/config.xml');

   echo $data['webhost']  // prints "www.example.com"
   echo $data['database']['params']['dbname'];  // prints "dbproduction"

``Zend\Config\Reader\Xml`` utilizes the `XMLReader`_ *PHP* class. Please review this documentation to be aware of
its specific behaviors, which propagate to ``Zend\Config\Reader\Xml``.

Using ``Zend\Config\Reader\Xml`` we can include the content of XML files in a specific XML element. This is
provided using the standard function `XInclude`_ of XML. To use this function you have to add the namespace
``xmlns:xi="http://www.w3.org/2001/XInclude"`` to the XML file. Suppose we have an XML files that contains only the
database configuration:

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

We can include this configuration in another XML file, for instance:

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="utf-8"?>
   <config xmlns:xi="http://www.w3.org/2001/XInclude">
       <webhost>www.example.com</webhost>
       <xi:include href="database.xml"/>
   </config>

The syntax to include an XML file in a specific element is ``<xi:include href="file-to-include.xml"/>``

.. _zend.config.reader.json:

Zend\\Config\\Reader\\Json
--------------------------

``Zend\Config\Reader\Json`` enables developers to read configuration data in a *JSON* format and read them in the
application by using an array syntax.

The following example illustrates a basic use of ``Zend\Config\Reader\Json`` for loading configuration data from a
*JSON* file. Suppose we have the following *JSON* configuration file:

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

We can use the ``Zend\Config\Reader\>Json`` to read this JSON file:

.. code-block:: php
   :linenos:

   $reader = new Zend\Config\Reader\Json();
   $data   = $reader->fromFile('/path/to/config.json');

   echo $data['webhost']  // prints "www.example.com"
   echo $data['database']['params']['dbname'];  // prints "dbproduction"

``Zend\Config\Reader\Json`` utilizes the :ref:`Zend\\Json\\Json <zend.json.introduction>` class.

Using ``Zend\Config\Reader\Json`` we can include the content of a JSON file in a specific JSON section or element.
This is provided using the special syntax ``@include``. Suppose we have a JSON file that contains only the database
configuration:

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

We can include this configuration in another JSON file, for instance:

.. code-block:: json
   :linenos:

   {
       "webhost"  : "www.example.com",
       "@include" : "database.json"
   }

.. _zend.config.reader.yaml:

Zend\\Config\\Reader\\Yaml
--------------------------

``Zend\Config\Reader\Yaml`` enables developers to read configuration data in a *YAML* format and read them in the
application by using an array syntax. In order to use the YAML reader we need to pass a callback to an external PHP
library or use the `Yaml PECL extension`_.

The following example illustrates a basic use of ``Zend\Config\Reader\Yaml`` that use the Yaml PECL extension.
Suppose we have the following *YAML* configuration file:

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

We can use the ``Zend\Config\Reader\Yaml`` to read this YAML file:

.. code-block:: php
   :linenos:

   $reader = new Zend\Config\Reader\Yaml();
   $data   = $reader->fromFile('/path/to/config.yaml');

   echo $data['webhost']  // prints "www.example.com"
   echo $data['database']['params']['dbname'];  // prints "dbproduction"

If you want to use an external YAML reader you have to pass the callback function in the constructor of the class.
For instance, if you want to use the `Spyc`_ library:

.. code-block:: php
   :linenos:

   // include the Spyc library
   require_once ('path/to/spyc.php');

   $reader = new Zend\Config\Reader\Yaml(array('Spyc','YAMLLoadString'));
   $data   = $reader->fromFile('/path/to/config.yaml');

   echo $data['webhost']  // prints "www.example.com"
   echo $data['database']['params']['dbname'];  // prints "dbproduction"

You can also instantiate the ``Zend\Config\Reader\Yaml`` without any parameter and specify the YAML reader in a
second moment using the ``setYamlDecoder()`` method.

Using ``Zend\Config\ReaderYaml`` we can include the content of a YAML file in a specific YAML section or element.
This is provided using the special syntax ``@include``. Suppose we have a YAML file that contains only the database
configuration:

.. code-block:: yaml
   :linenos:

   database:
       adapter: pdo_mysql
       params:
         host:     db.example.com
         username: dbuser
         password: secret
         dbname:   dbproduction

We can include this configuration in another YAML file, for instance:

.. code-block:: yaml
   :linenos:

   webhost:  www.example.com
   @include: database.yaml



.. _`parse_ini_file()`: http://php.net/parse_ini_file
.. _`XMLReader`: http://php.net/xmlreader
.. _`XInclude`: http://www.w3.org/TR/xinclude/
.. _`Yaml PECL extension`: http://www.php.net/manual/en/book.yaml.php
.. _`Spyc`: http://code.google.com/p/spyc/
