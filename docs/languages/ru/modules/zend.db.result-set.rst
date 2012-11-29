.. EN-Revision: 3728e7b
.. _zend.db.result-set:

Zend\\Db\\ResultSet
===================

``Zend\Db\ResultSet`` подкомпонент Zend\\Db для абстрагирования перебора набора строк, созданных запросами.
Источником данных для этого может быть все, что угодно, что поддерживает перебор, но обычно как источником для
получения данных является объект, основанный на ``Zend\Db\Adapter\Driver\ResultInterface``.

``Zend\Db\ResultSet`` должен реализовывать ``Zend\Db\ResultSet\ResultSetInterface``. Все подкомпоненты Zend\\Db,
возвращающие ResultSet как часть своего  API, предполагают, что должен быть возвращен экземпляр
ResultSetInterface. В большинстве случаев паттерн Prototype используется  для клонирования множественных
прототипов объекта ResultSet и возвращения специализированного ResultSet с уже внедренными нужными данными.
Интерфейс ResultSetInterface выглядит так:

.. code-block:: php
   :linenos:

   interface ResultSetInterface extends \Traversable, \Countable
   {
       public function initialize($dataSource);
       public function getFieldCount();
   }

.. _zend.db.result-set.quickstart:

Быстрый старт
-------------

``Zend\Db\ResultSet\ResultSet`` является основной формой объекта ResultSet, который будет предоставлять
каждую строку как объект ArrayObject или массив строк данных. По умолчанию, ``Zend\Db\Adapter\Adapter`` использует
``Zend\Db\ResultSet\ResultSet`` для итерации строк при вызове метода Zend\Db\Adapter\Adapter::query().

Пример ниже очень похож на то, что можно обнаружить внутри ``Zend\Db\Adapter\Adapter::query()``:

.. code-block:: php
   :linenos:

   use Zend\Db\Adapter\Driver\ResultInterface;
   use Zend\Db\ResultSet\ResultSet;

   $stmt = $driver->createStatement('SELECT * FROM users');
   $stmt->prepare($parameters);
   $result = $stmt->execute();

   if ($result instanceof ResultInterface && $result->isQueryResult()) {
       $resultSet = new ResultSet;
       $resultSet->initialize($result);

       foreach ($resultSet as $row) {
           echo $row->my_column . PHP_EOL;
       }
   }

.. _zend.db.result-set.result-set:

Zend\\Db\\ResultSet\\ResultSet и Zend\\Db\\ResultSet\\AbstractResultSet
-----------------------------------------------------------------------

В большинстве случаев вы будете использовать ``Zend\Db\ResultSet\ResultSet`` или производное от 
``Zend\Db\ResultSet\AbstractResultSet``. Реализация ``AbstractResultSet`` предлагает следующие функциональные
возможности:

.. code-block:: php
   :linenos:

    abstract class AbstractResultSet implements Iterator, ResultSetInterface
    {
        public function initialize($dataSource)
        public function getDataSource()
        public function getFieldCount()
        
        /** Iterator */
        public function next()
        public function key()
        public function current()
        public function valid()
        public function rewind()
        
        /** countable */
        public function count()
        
        /** get rows as array */
        public function toArray()
    }

.. _zend.db.result-set.hydrating-result-set:

Zend\\Db\\ResultSet\\HydratingResultSet
---------------------------------------

Более гибким объектом ``ResultSet`` является ``Zend\Db\ResultSet\HydratingResultSet``, который позволяет
разработчику выбрать подходящую "стратегию наполнения" для помещения данных ряда в нужный объект. В процессе
перебора, ``HydratingResultSet`` берет прототип целевого объекта и клонирует его для каждой последующей строки,
 которые он перебирает. С этой вновь клонированной строкой ``HydratingResultSet`` наполняет целевой
объект данными строки. 

В следующем примере перебираются строки из базы данных. В процессе перебора ``HydratingRowSet`` использует
гидратор, основанный на Отражении (Reflection), для внедрения данных строки непосредственно в защищенные члены
клонированного объекта UserEntity:

.. code-block:: php
   :linenos:

   use Zend\Db\Adapter\Driver\ResultInterface;
   use Zend\Db\ResultSet\HydratingResultSet;
   use Zend\Stdlib\Hydrator\Reflection as ReflectionHydrator;

   class UserEntity {
       protected $first_name;
       protected $last_name;
       public function getFirstName() { return $this->first_name; }
       public function getLastName() { return $this->last_name; }
   }

   $stmt = $driver->createStatement($sql);
   $stmt->prepare($parameters);
   $result = $stmt->execute();

   if ($result instanceof ResultInterface && $result->isQueryResult()) {
       $resultSet = new HydratingResultSet(new ReflectionHydrator, new UserEntity);
       $resultSet->initialize($result);

       foreach ($resultSet as $user) {
           echo $user->getFirstName() . ' ' . $user->getLastName() . PHP_EOL;
       }
   }

Для более полного понимания различных стратегий, которы могут использоваться для наполнения целевого объекта,
обратите свое внимание на раздел документации, описывающий ``Zend\Stdlib\Hydrator``.


