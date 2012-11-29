.. EN-Revision: 3728e7b
.. _zend.db.table-gateway:

Zend\\Db\\TableGateway
======================

Объект TableGateway предназначен для предоставления объекта, который представляет собой таблицу в базе данных, и
методов этого объекта, реализующих наиболее часто используемые операции работы с таблицой базы данных. Интерфейс
выглядит так:

.. code-block:: php
   :linenos:

   interface Zend\Db\TableGateway\TableGatewayInterface
   {
       public function getTable();
       public function select($where = null);
       public function insert($set);
       public function update($set, $where = null);
       public function delete($where);
   }

Есть две основных, наиболее полезных, реализации интерфейса ``TableGatewayInterface``:
``AbstractTableGateway`` и ``TableGateway``. ``AbstractTableGateway`` является абстрактной базовой реализацией,
которая обеспечивает работу ``select()``, ``insert()``, ``update()``, ``delete()`` и дополнительное API для
выполнения этих же задач с явными SQL объектами. Это методы ``selectWith()``, ``insertWith()``, ``updateWith()`` и
``deleteWith()``. Дополнительно AbstractTableGateway реализует API «Feature», которое позволяет расширять
поведение базовой реализации ``TableGateway`` без необходимости создания расширенного класса с этой
функциональностью. ``TableGateway`` является частной реализацией и просто предоставляет разумный конструктор для
класса ``AbstractTableGateway`` прямо "из-коробки", ``TableGateway`` не требует расширения для того, чтобы
пользоваться функциональностью на всю катушку.

.. _zend.db.table-gateway.basic:

Основы использования
--------------------

Самый быстрый способ начать работать с Zend\\Db\\TableGateway - это настройка и использование конкретной
реализации ``TableGateway``. API ``TableGateway`` такой:

.. code-block:: php
   :linenos:

   class TableGateway extends AbstractTableGateway
   {
   	public $lastInsertValue;
   	public $table;
   	public $adapter;

   	public function __construct($table, Adapter $adapter, $features = null, ResultSet $resultSetPrototype = null, Sql $sql = null)

   	/** Inherited from AbstractTableGateway */

       public function isInitialized();
       public function initialize();
       public function getTable();
       public function getAdapter();
       public function getColumns();
       public function getFeatureSet();
       public function getResultSetPrototype();
       public function getSql();
       public function select($where = null);
       public function selectWith(Select $select);
       public function insert($set);
       public function insertWith(Insert $insert);
       public function update($set, $where = null);
       public function updateWith(Update $update);
       public function delete($where);
       public function deleteWith(Delete $delete);
       public function getLastInsertValue();

   }

Объект ``TableGateway`` использует внедрение через конструктор для получения зависимостей и настроек в конкретный
экземпляр. Что бы получить рабочий объект ``TableGateway`` необходимо передать имя таблицы и экземпляр Адаптера.

В самом простом случае, такая реализация не знает о структуре таблицы или метаданных, и когда выполняется,
например, ``select()`` - получаем простой объект ResultSet на основе данных Adapter.

.. code-block:: php
   :linenos:

   use Zend\Db\TableGateway\TableGateway;
   $projectTable = new TableGateway('project', $adapter);
   $rowset = $projectTable->select(array('type' => 'PHP'));

   echo 'Projects of type PHP: ';
   foreach ($rowset as $projectRow) {
   	echo $projectRow['name'] . PHP_EOL;
   }

   // or, when expecting a single row:
   $artistTable = new TableGateway('artist', $adapter);
   $rowset = $artistTable->select(array('id' => 2));
   $artistRow = $rowset->current();

   var_dump($artistRow);

Метод ``select()`` принимает те же аргументы, что и ``Zend\Db\Sql\Select::where()``, с той лишь разницей, что
возможно использование замыкания, которое в свою очередь будет передано в объект Select для создания запроса на
выборку (SELECT). Пример такого использования:

.. code-block:: php
   :linenos:

   use Zend\Db\TableGateway\TableGateway;
   use Zend\Db\Sql\Select;
   $artistTable = new TableGateway('artist', $adapter);

   // search for at most 2 artists who's name starts with Brit, ascending
   $rowset = $artistTable->select(function (Select $select) {
   	$select->where->like('name', 'Brit%');
   	$select->order('name ASC')->limit(2);
   });

.. _zend.db.table-gateway.features:

Особенности TableGateway
------------------------

API "Features" позволяет расширять функциональность базового объекта ``TableGateway`` без полиморфного расширения
базового класса. Это допускает более широкий спектр возможных подмешиваний и соответствия возможностей для
достижения конкретного поведения, которое должно быть достигнуто, чтобы сделать базовую реализацию
``TableGateway`` полезной для конкретной задачи.

В объект `TableGateway`` функционал должны внедряться через конструктор. Конструктор может получать особенности
трех разных форм: единственный объект особенности, объект FeatureSet или массив объектов Feature.

Вот базовый набор особенностей, уже реализованных в Zend\\Db:

- GlobalAdapterFeature: возможность использовать глобальный/статический адаптер без необходимости внедрять их в
экземпляр ``TableGateway``. Это особо полезно при расширении реализации ``AbstractTableGateway``:

  .. code-block:: php
     :linenos:

     class MyTableGateway extends AbstractTableGateway
     {
     	public function __construct()
     	{
     		$this->table = 'my_table';
     		$this->featureSet = new Feature\FeatureSet();
     		$this->featureSet->addFeature(new Feature\GlobalAdapterFeature());
     		$this->initialize();
     	}
     }

     // elsewhere in code, in a bootstrap
     Zend\Db\TableGateway\Feature\GlobalAdapterFeature::setStaticAdapter($adapter);

     // in a controller, or model somewhere
     $table = new MyTableGateway(); // adapter is statially loaded

- MasterSlaveFeature: возможность использовать мастер-адаптер для insert(), update() и delete() при использовании
  слейв-адаптера для операций select().

  .. code-block:: php
     :linenos:

     $table = new TableGateway('artist', $adapter, new Feature\MasterSlaveFeature($slaveAdapter));

- MetadataFeature: возможность заполнения ``TableGateway`` информацией о колонках из объекта Metadata. Также будут
  храниться сведения о первичном ключе, в случае RowGatewayFeature эта информация будет использоваться.

  .. code-block:: php
     :linenos:

     $table = new TableGateway('artist', $adapter, new Feature\MeatadataFeature());

- EventFeature: возможность использовать объект ``TableGateway`` в связке с Zend\\EventManager для обеспечения
  возможности подписываться на различные события в течении жизненного цикла ``TableGateway``.

  .. code-block:: php
     :linenos:

     $table = new TableGateway('artist', $adapter, new Feature\EventFeature($eventManagerInstance));

- RowGatewayFeature: возможность для ``select()`` вернуть объект ResultSet, который в последствии можно
  итерировать.

  .. code-block:: php
     :linenos:

     $table = new TableGateway('artist', $adapter, new Feature\RowGatewayFeature('id'));
     $results = $table->select(array('id' => 2));

     $artistRow = $results->current();
     $artistRow->name = 'New Name';
     $artistRow->save();


