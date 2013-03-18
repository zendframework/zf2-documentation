.. EN-Revision: 3728e7b
.. _zend.db.adapter:

Zend\Db\Adapter
===============

Объект Adapter является одним из самых важных компонентов, входящих в ``Zend\Db``. Он отвечает за адаптацию
написанного кода на или для ``Zend\Db`` к целевым расширениям PHP и поставщикам баз данных.
При этом, он создает уровень абстракции для расширений PHP, которая называется «Driver»  адаптера ``Zend\Db``.
Так же создается легкий слой абстракции, называемый «Platform» (Платформа) адаптера, для различных 
особенностей, которые каждый конкретный производитель платформы может иметь в своей  реализации SQL/СУБД.

.. _zend.db.adapter.quickstart:

Создание адаптера (быстрый старт)
---------------------------------

Создание адаптера может быть сделано просто  путем создания экземпляра класса ``Zend\Db\Adapter\Adapter``.
Самым распространненным способом использования, хотя и не самым явным, является передача массива с параметрами
конфигурации в ``Adapter``.

.. code-block:: php
   :linenos:

   $adapter = new Zend\Db\Adapter\Adapter($configArray);

Этот массив драйвера является абстракцией для расширения уровня требуемых параметров. Вот таблица с парами
ключ-значени, которые должны быть в конфигурационном массиве.

.. table:: 

   +------------+----------------------+-------------------------------------------------------------+
   |Key         |Is Required?          |Value                                                        |
   +============+======================+=============================================================+
   |driver      |обязательно           |Mysqli, Sqlsrv, Pdo_Sqlite, Pdo_Mysql, Pdo=OtherPdoDriver    |
   +------------+----------------------+-------------------------------------------------------------+
   |database    |обычно необходимо     |имя базы данных (схема)                                      |
   +------------+----------------------+-------------------------------------------------------------+
   |username    |обычно необходимо     |имя пользователя базы данных                                 |
   +------------+----------------------+-------------------------------------------------------------+
   |password    |обычно необходимо     |пароль                                                       |
   +------------+----------------------+-------------------------------------------------------------+
   |hostname    |обычно не требуется   |IP-адрес или имя хост для подключения к базе данных          |
   +------------+----------------------+-------------------------------------------------------------+
   |port        |обычно не требуется   |порт для соединения                                          |
   +------------+----------------------+-------------------------------------------------------------+
   |charset     |обычно не требуется   |кодировка соединения                                         |
   +------------+----------------------+-------------------------------------------------------------+

.. note:: 

   Другие имена также будут распознаны. Фактически, если в PHP руководстве используются конкретные имена, то эти
   имена так же будут поддерживаться драйвером. Например, «dbname» в большинстве случаев также будет работать для
   «database». Еще как пример, в случае с «Sqlsrv», «UID» будет работать вместо «username». Вы сами решаете с
   каким форматом имен работать, но в таблице выше были представлены официальные именования.

Так, например, подключение к MySQL с использованием ext/mysqli:

.. code-block:: php
   :linenos:

    $adapter = new Zend\Db\Adapter\Adapter(array(
       'driver' => 'Mysqli',
       'database' => 'zend_db_example',
       'username' => 'developer',
       'password' => 'developer-password'
    ));

Другой пример, подключение к Sqlite через PDO:

.. code-block:: php
   :linenos:

    $adapter = new Zend\Db\Adapter\Adapter(array(
       'driver' => 'Pdo_Sqlite',
       'database' => 'path/to/sqlite.db'
    ));

Важно понимать, что при использовании такого стиля подключения ``Adapter`` будет пытаться создать зависимости,
которые прямо не предусмотрены. Объект Driver будет создан из данных, которые были переданы в массиве $driver в
конструктор. Объект Platform будет создан основываясь на типе созданного объекта Driver. И наконец, будет создан
и доступен для использования объект по-умолчанию ResultSet. Любой из этих объектов может быть внедрен. Как это
сделать, смотрите следующий раздел.

Список официально поддерживаемых драйверов:

* ``Mysqli``: ext/mysqli драйвер
* ``Pgsql``: ext/pgsql драйвер
* ``Sqlsrv``: ext/sqlsrv драйвер (from Microsoft)
* ``Pdo_Mysql``: MySQL через расширение PDO
* ``Pdo_Sqlite``: SQLite через расширение PDO
* ``Pdo_Pgsql``: PostgreSQL через расширение PDO

.. _zend.db.adapter.instantiating:

Создание адаптера используя введение зависимостей
-------------------------------------------------

Более выразительным и красивым способом создания адаптера является использование введения зависимостей.
``Zend\Db\Adapter\Adapter`` использует инъекции через конструктор, и все необходимые зависимости внедряются через
конструктор, который использует следующий синтаксис (на псевдо-коде):

.. code-block:: php
   :linenos:

   use Zend\Db\Adapter\Platform\PlatformInterface;
   use Zend\Db\ResultSet\ResultSet;

   class Zend\Db\Adapter\Adapter {
       public function __construct($driver, PlatformInterface $platform = null, ResultSet $queryResultSetPrototype = null)
   }

Что может быть внедрено:

* $driver - массив параметров для соединения (смотрите ранее) или экземпляр ``Zend\Db\Adapter\Driver\DriverInterface``
* $platform - (опционально) экземпляр ``Zend\Db\Platform\PlatformInterface``, по-умолчанию создается на основе реализации драйвера.
* $queryResultSetPrototype - (опционально) экземпляр ``Zend\Db\ResultSet\ResultSet``. Для понимания роли этого объекта смотрите раздел ниже о запросах через адаптер.

.. _zend.db.adapter.query-preparing:

Подготовка запроса с помощью Zend\\Db\\Adapter\\Adapter::query()
----------------------------------------------------------------

По умолчанию, query() предпочитает использовать «preparation» (подготовку) в качестве средства для обработки SQL.
Это обычно означает, что вы будете формировать запрос со значениями замещенными заполнителями (обычно знаки
вопросов), а потом соответствующие параметры для этих заполнителей будет подставлены на свои места. Пример
такого подхода с ``Zend\Db\Adapter\Adapter``:

.. code-block:: php
   :linenos:

   $adapter->query('SELECT * FROM `artist` WHERE `id` = ?', array(5));

Предыдущий пример проходит через такие этапы:

* создание нового объекта Statement
* подготовка массива в ParameterContainer (при необходимости)
* внедрение ParameterContainer в объект Statement
* исполнение объекта Statement, создание объекта Result
* проверка объекта Result, был ли переданный запрос действительно sql запросом (query) или результат устанавливает произведенное выражение
* если Result создал запрос, клонирование прототипа ResultSet, внедрение ResultSet как источника данных и его возвращение
* иначе возвращение Result

.. _zend.db.adapter.query-execution:

Выполнение запросов через Zend\\Db\\Adapter\\Adapter::query()
-------------------------------------------------------------

Иногда бывают ситуации, когда необходимо выполнять запросы напрямую. В большинстве случаев необходимость выполнения
запросов напрямую вместо их подготовки и последующего выполнения возникает при использовании DDL выражений (в
большинстве расширений и платформ), которые не поддерживают предподготовку. Пример исполнения: 

.. code-block:: php
   :linenos:

   $adapter->query('ALTER TABLE ADD INDEX(`foo_index`) ON (`foo_column`)', Adapter::QUERY_MODE_EXECUTE);

Главное отличие этого подхода в том, что вторым параметром необходимо передать Adapter::QUERY_MODE_EXECUTE (выполнение). 

.. _zend.db.adapter.statement-creation:

Создание выражений (Statements)
-------------------------------

Пока query() является весьма полезным для разовых и быстрых запросов к базе данных через адаптер, как правило
имеет смысл создавать выражения (Statements) и взаимодействовать с ним напрямую. Таким образом вы получаете
максимальный контроль над процессом подготовки-выполнения запроса. Для реализации выше сказанного, адаптер
(Adapter) предоставляет вам возможность вызова createStatement(), который позволяет создавать Выражение,
специфичное для конкретного Драйвера, что в итоге позволяет контролировать процесс подгтовки-выполнения запроса.

.. code-block:: php
   :linenos:

   // with optional parameters to bind up-front
   $statement = $adapter->createStatement($sql, $optionalParameters);
   $result = $statement->execute();

.. _zend.db.adapter.driver:

Использование объекта Driver
----------------------------

Объект Driver является основным местом, где ``Zend\Db\Adapter\Adapter`` реализует уровень абстракции соединения,
позволяющий использовать все интерфейсы Zend\Db через различные ext/mysqli, ext/sqlsrv, PDO и другие PHP драйверы.
Поэтому каждый драйвер состоит из трех (3) объектов:

* Соединение: ``Zend\Db\Adapter\Driver\ConnectionInterface``
* Выражение: ``Zend\Db\Adapter\Driver\StatementInterface``
* Результат: ``Zend\Db\Adapter\Driver\ResultInterface``

Каждый из встроенных драйверов поддерживает прототопирование (prototyping), что означает создание объекта когда
запрашивается новый экземпляр. Рабочий процесс выглядит следующим образом:

* Адаптер создан с набором параметров соединения
* Адаптер выбирает соответствующий драйвер для инициализации, например, ``Zend\Db\Adapter\Driver\Mysqli``
* Объект драйвера инициализирован
* Если нет соединения, внедряются выражение или объект результата, инициализированные значениями по умолчанию

Этот драйвер теперь готов к вызову когда будет запрошен конкретный рабочий процесс. Так выглядит Driver API:

.. code-block:: php
   :linenos:

   namespace Zend\Db\Adapter\Driver;

    interface DriverInterface
    {
        const PARAMETERIZATION_POSITIONAL = 'positional';
        const PARAMETERIZATION_NAMED = 'named';
        const NAME_FORMAT_CAMELCASE = 'camelCase';
        const NAME_FORMAT_NATURAL = 'natural';
        public function getDatabasePlatformName($nameFormat = self::NAME_FORMAT_CAMELCASE);
        public function checkEnvironment();
        public function getConnection();
        public function createStatement($sqlOrResource = null);
        public function createResult($resource);
        public function getPrepareType();
        public function formatParameterName($name, $type = null);
        public function getLastGeneratedValue();
    }

Этот DriverInterface предоставляет Вам следующие возможности:

* Узнать поддерживаемое этим драйвером имя платформы (полезно для выбора надлежащего объекта платформы)
* Убедиться, что окружение может поддерживать этот драйвер
* Вернуть объект Connection
* Создание объекта Statement, который необязательно будет инициализирован SQL-выражением (в таком случае будет клоном прототопированого объекта выражения)
* Создать объект Result, который необязательно будет инициализирован ресурсом выражения (в таком случае будет клоном прототопированого объекта Result)
* Изменить формат имен параметров, является важным для определения разницы между различными способами именования между расширениями.
* Получить последнее сгенерированное значение (такое как значение auto-increment)


Объект Statement обычно выглядит так:

.. code-block:: php
   :linenos:
   
   namespace Zend\Db\Adapter\Driver;

   interface StatementInterface extends StatementContainerInterface
   {
       public function getResource();
       public function prepare($sql = null);
       public function isPrepared();
       public function execute($parameters = null);

       /** Inherited from StatementContainerInterface */
       public function setSql($sql);
       public function getSql();
       public function setParameterContainer(ParameterContainer $parameterContainer);
       public function getParameterContainer();
   }
   
Объект Result выглядит так:

.. code-block:: php
   :linenos:
   
   namespace Zend\Db\Adapter\Driver;

   interface ResultInterface extends \Countable, \Iterator
   {
       public function buffer();
       public function isQueryResult();
       public function getAffectedRows();
       public function getGeneratedValue();
       public function getResource();
       public function getFieldCount();
   }

.. _zend.db.adapter.platform:

Использование объекта Platform
------------------------------

Объект Platform предоставляет API для упрощения создания SQL запросов учитывая особенности различных платформ.
Например, заключение в кавычки различных идентификаторов и значений или обработка разделителя в идентификаторах.
Объект Platform выглядит следующим образом:

.. code-block:: php
   :linenos:
   
   namespace Zend\Db\Adapter\Platform;

   interface PlatformInterface
   {
       public function getName();
       public function getQuoteIdentifierSymbol();
       public function quoteIdentifier($identifier);
       public function quoteIdentifierChain($identiferChain)
       public function getQuoteValueSymbol();
       public function quoteValue($value);
       public function quoteValueList($valueList);
       public function getIdentifierSeparator();
       public function quoteIdentifierInFragment($identifier, array $additionalSafeWords = array());
   }

Хотя существует возможность создавать свой собственный  объект Platform, намного проще получать его из заранее
сконфигурированного адаптера (по умолчанию, тип Платформы будет совпадать с базовой реализацией драйвера):

.. code-block:: php
   :linenos:

   $platform = $adapter->getPlatform();
   // or
   $platform = $adapter->platform; // magic property access

Несколько примеров использования Platform:

.. code-block:: php
  :linenos:

  /** @var $adapter Zend\Db\Adapter\Adapter */
  /** @var $platform Zend\Db\Adapter\Platform\Sql92 */
  $platform = $adapter->getPlatform();
  
  // "first_name"
  echo $platform->quoteIdentifier('first_name');
  
  // " 
  echo $platform->getQuoteIdentifierSymbol(); 
  
  // "schema"."mytable"
  echo $platform->quoteIdentifierChain(array('schema','mytable')));
  
  // '
  echo $platform->getQuoteValueSymbol();
  
  // 'myvalue'
  echo $platform->quoteValue('myvalue');
  
  // 'value', 'Foo O\\'Bar'
  echo $platform->quoteValueList(array('value',"Foo O'Bar")));
  
  // .
  echo $platform->getIdentifierSeparator();
  
  // "foo" as "bar"
  echo $platform->quoteIdentifierInFragment('foo as bar');
  
  // additionally, with some safe words:
  // ("foo"."bar" = "boo"."baz")
  echo $platform->quoteIdentifierInFragment('(foo.bar = boo.baz)', array('(', ')', '='));
  
.. _zend.db.adapter.parameter-container:

Использование контейнера параметров
-----------------------------

Объект ParameterContainer представляет собой контейнер для различных параметров, которые должны быть переданы в
объект Statement для выполнения всех параметризированных частей SQL-выражениея. Этот объект реализует интерфейс
ArrayAccess. Ниже приведен API ParameterContainer:

.. code-block:: php

   namespace Zend\Db\Adapter;

    class ParameterContainer implements \Iterator, \ArrayAccess, \Countable {
        public function __construct(array $data = array())
        
        /** methods to interact with values */
        public function offsetExists($name)
        public function offsetGet($name)
        public function offsetSetReference($name, $from)
        public function offsetSet($name, $value, $errata = null)
        public function offsetUnset($name)
        
        /** set values from array (will reset first) */
        public function setFromArray(Array $data)
        
        /** methods to interact with value errata */
        public function offsetSetErrata($name, $errata)
        public function offsetGetErrata($name)
        public function offsetHasErrata($name)
        public function offsetUnsetErrata($name)
        
        /** errata only iterator */
        public function getErrataIterator()
        
        /** get array with named keys */
        public function getNamedArray()
        
        /** get array with int keys, ordered by position */
        public function getPositionalArray()
        
        /** iterator: */
        public function count()
        public function current()
        public function next()
        public function key()
        public function valid()
        public function rewind()
        
        /** merge existing array of parameters with existing parameters */
        public function merge($parameters)    
    }

В дополнение к обработке имен параметров и значений, контейнер так же помогает в отслеживании типов параметров
при обработке  PHP-типов в SQL-типы. Например, это может быть важным когда:

.. code-block:: php
    
    $container->offsetSet('limit', 5);
    
должен быть целым числом. Для этого передайте константу ParameterContainer::TYPE_INTEGER третьим параметром:

.. code-block:: php
    
    $container->offsetSet('limit', 5, $container::TYPE_INTEGER);
    
Это будет гарантировать, что если основной драйвер поддерживает типизацию связанных параметров, то переведенная
информация будет передана дальше в актуальный php-драйвер базы данных.

.. _zend.db.adapter.parameter-container.examples:

Примеры
-------

Создание переносимых между драйверами и поставщиками запросов, подготовка и проход по результату

.. code-block:: php
   :linenos:

   $adapter = new Zend\Db\Adapter\Adapter($driverConfig);

   $qi = function($name) use ($adapter) { return $adapter->platform->quoteIdentifier($name); };
   $fp = function($name) use ($adapter) { return $adapter->driver->formatParameterName($name); };

   $sql = 'UPDATE ' . $qi('artist')
       . ' SET ' . $qi('name') . ' = ' . $fp('name')
       . ' WHERE ' . $qi('id') . ' = ' . $fp('id');

   /** @var $statement Zend\Db\Adapter\Driver\StatementInterface */
   $statement = $adapter->query($sql);

   $parameters = array(
       'name' => 'Updated Artist',
       'id' => 1
   );

   $statement->execute($parameters);

   // DATA INSERTED, NOW CHECK

   /* @var $statement Zend\Db\Adapter\DriverStatementInterface */
   $statement = $adapter->query('SELECT * FROM '
       . $qi('artist')
       . ' WHERE id = ' . $fp('id'));

   /* @var $results Zend\Db\ResultSet\ResultSet */
   $results = $statement->execute(array('id' => 1));

   $row = $results->current();
   $name = $row['name'];


