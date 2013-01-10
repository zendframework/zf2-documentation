.. EN-Revision: 39b7eeb
.. _zend.db.sql:

Zend\\Db\\Sql
=============

``Zend\Db\Sql`` представляет собой слой абстракции для SQL, позволяющий строить SQL запросы через
объектно-ориентированный API. Конечным результатом работы объекта ``Zend\Db\Sql``  являются контейнеры Statement
и Parameter (параметры) целевого запроса или полная строка, которая может быть непосредственно выполнена на
платформе базы данных. Для своей работы объектам ``Zend\Db\Sql`` необходим объект ``Zend\Db\Adapter\Adapter``.

.. _zend.db.sql.sql:

Zend\\Db\\Sql\\Sql (Быстрый старт)
----------------------------------

Существует ряд основных задач, выполняемых при работе с базой данных: выборка, вставка, обновление и удаление.
Поэтому реализовано четыре основных обекта, которые разработчики могут использовать для построения запросов:
``Zend\Db\Sql\Select``, ``Insert``, ``Update`` и ``Delete``.

Так как эти четыре задачи тесно связаны и обычно используются вместе в одном приложении, объекты
``Zend\Db\Sql\Sql`` помогут вам создать их и получить результат, который вы пытаетесь достичь.

.. code-block:: php
   :linenos:

   use Zend\Db\Sql\Sql;
   $sql = new Sql($adapter);
   $select = $sql->select(); // @return Zend\Db\Sql\Select
   $insert = $sql->insert(); // @return Zend\Db\Sql\Insert
   $update = $sql->update(); // @return Zend\Db\Sql\Update
   $delete = $sql->delete(); // @return Zend\Db\Sql\Delete

Как разработчик, теперь вы можете взаимодействовать с этими объектами для построения запросов, как показано в
примере ниже. Как только они были заполнены необходимыми значениями, они сразу могут быть использованы для
подготовки (prepared) и выполнения (executed).

Для подготовки (используя объект Select):

.. code-block:: php
   :linenos:

   use Zend\Db\Sql\Sql;
   $sql = new Sql($adapter);
   $select = $sql->select();
   $select->from('foo');
   $select->where(array('id' => 2));

   $statement = $sql->prepareStatementForSqlObject($select);
   $results = $statement->execute();

Для выполнения (используя объект Select)

.. code-block:: php
   :linenos:

   use Zend\Db\Sql\Sql;
   $sql = new Sql($adapter);
   $select = $sql->select();
   $select->from('foo');
   $select->where(array('id' => 2));

   $selectString = $sql->getSqlStringForSqlObject($select);
   $results = $adapter->query($selectString, $adapter::QUERY_MODE_EXECUTE);

Так же объекты Zend\\Db\\Sql\\Sql могут быть привязаны к заданной таблице. Поэтому все действия с объектами
select, insert, update, delete будут выполняются с одной таблицей.

.. code-block:: php
   :linenos:

   use Zend\Db\Sql\Sql;
   $sql = new Sql($adapter, 'foo');
   $select = $sql->select();
   $select->where(array('id' => 2)); // $select already has the from('foo') applied

.. _zend.db.sql.sql-objects:

Zend\\Db\\Sql Select, Insert, Update и Delete
-------------------------------------------------

Каждый из этих объектов реализует следующие (2) интерфейсы:

.. code-block:: php
   :linenos:

   interface PreparableSqlInterface {
        public function prepareStatement(Adapter $adapter, StatementInterface $statement);
   }
   interface SqlInterface {
        public function getSqlString(PlatformInterface $adapterPlatform = null);
   }

Эти функции Вы можете вызывать при создании либо (а) подготовленного выражения, либо (б) полной строки запроса,
которые будут выполнены.

.. _zend.db.sql.select:

Zend\\Db\\Sql\\Select
---------------------

Основная роль ``Zend\Db\Sql\Select`` - это предоставление унифицированного API для создания специфичных для
конкретной платформы SQL запросов SELECT. Этот класс может быть создан и использован без ``Zend\Db\Sql\Sql``:

.. code-block:: php
   :linenos:

   use Zend\Db\Sql\Select;
   $select = new Select();
   // или дял создания $select, привязанного к конкретной таблице
   $select = new Select('foo');

Если вы указали имя таблицы в объекте Select, то уже нельзя будет вызвать метод from() для изменения имени таблицы.

Как только вы получили валидный объект Select, следующее API можно использовать для определения различных частей
выражения:

.. code-block:: php
   :linenos:

   class Select extends AbstractSql implements SqlInterface, PreparableSqlInterface
   {
       const JOIN_INNER = 'inner';
       const JOIN_OUTER = 'outer';
       const JOIN_LEFT = 'left';
       const JOIN_RIGHT = 'right';
       const SQL_STAR = '*';
       const ORDER_ASCENDING = 'ASC';
       const ORDER_DESENDING = 'DESC';

       public $where; // @param Where $where

       public function __construct($table = null);
       public function from($table);
       public function columns(array $columns, $prefixColumnsWithTable = true);
       public function join($name, $on, $columns = self::SQL_STAR, $type = self::JOIN_INNER);
       public function where($predicate, $combination = Predicate\PredicateSet::OP_AND);
       public function group($group);
       public function having($predicate, $combination = Predicate\PredicateSet::OP_AND);
       public function order($order);
       public function limit($limit);
       public function offset($offset);
   }

from():
.......

.. code-block:: php
   :linenos:

   // as a string:
   $select->from('foo');

   // as an array to specify an alias:
   // produces SELECT "t".* FROM "table" AS "t"

   $select->from(array('t' => 'table'));

   // using a Sql\TableIdentifier:
   // same output as above

   $select->from(new TableIdentifier(array('t' => 'table')));

columns():
..........

.. code-block:: php
   :linenos:

   // as array of names
   $select->columns(array('foo', 'bar'));

   // as an associative array with aliases as the keys:
   // produces 'bar' AS 'foo', 'bax' AS 'baz'

   $select->columns(array('foo' => 'bar', 'baz' => 'bax'));

join():
.......

.. code-block:: php
   :linenos:

   $select->join(
   	'foo' // table name,
   	'id = bar.id', // expression to join on (will be quoted by platform object before insertion),
   	array('bar', 'baz'), // (optional) list of columns, same requiremetns as columns() above
   	$select::JOIN_OUTER // (optional), one of inner, outer, left, right also represtned by constants in the API
   );

   $select->from(array('f' => 'foo'))  // base table
       ->join(array('b' => 'bar'),     // join table with alias
       'f.foo_id = b.foo_id');         // join expression

where(), having():
..................

Объект ``Zend\Db\Sql\Select`` предоставляет большую гибкость при выборе способов задания необходимых параметров
для where() и having(). Синтаксис метода следующий:

.. code-block:: php
    :linenos:
    
    /**
     * Create where clause
     *
     * @param  Where|\Closure|string|array $predicate
     * @param  string $combination One of the OP_* constants from Predicate\PredicateSet
     * @return Select
     */
    public function where($predicate, $combination = Predicate\PredicateSet::OP_AND);
    
Как вы смогли убедиться, существует множество различных путей для назначения параметров для where() и having().

Если вы передаете объект ``Zend\Db\Sql\Where`` в метод where()  или объект ``Zend\Db\Sql\Having`` в метод
having(), то внутренние объекты для Select будут полностью заменены. При выполнении метода where/having() он будет
использован для построения секции WHERE или HAVING в выражении SELECT.

Если вы передаете замыкание (``Closure``) в where() или having(), то эта функция будет вызвана с объектом
``Where`` в качестве единственного параметра. Таким образом, возможно следующее:

.. code-block:: php
    :linenos:
    
    $spec = function (Where $where) {
        $where->like('username', 'ralph%');
    };
    
    $select->where($spec);

Если же вы передаете строку, то она будет использована для создания экземпляра объекта
``Zend\Db\Sql\Predicate\Expression`` и её содержимое будет использоваться без обработки. Это означает, что
фрагмент не будет заключен в кавычки.

Рассмотрим следующий код:

.. code-block:: php
    :linenos:
    
    // SELECT "foo".* FROM "foo" WHERE x = 5
    $select->from('foo')->where('x = 5');

Если вы передаете массив, где ключами являются целые числа, значениями могут быть либо строки, которые будут
использованы для построения ``Predicate\Expression``, либо любые объекты, реализующие
``Predicate\PredicateInterface``. Эти объекты помещаются в очередь Where с предоставленным $combination
(условием объединения).

Рассмотрим следующий код:

.. code-block:: php
    :linenos:
    
    // SELECT "foo".* FROM "foo" WHERE x = 5 AND y = z
    $select->from('foo')->where(array('x = 5', 'y = z'));

Если вы передаете массив, где ключами являются строки, то эти значения будут обрабатываться следующим образом:

* значение PHP-типа NULL будет преобразовано в объект ``Predicate\IsNull``
* значение PHP-типа array() будет преобразовано в объект ``Predicate\In``
* значение PHP-типа string  будет преобразовано в объект ``Predicate\Operator`` так, что строковой ключ будет
  идентификатором, значение будет соответствовать целевому значению

Рассмотрим следующий код:

.. code-block:: php
    :linenos:
    
    // SELECT "foo".* FROM "foo" WHERE "c1" IS NULL AND "c2" IN (?, ?, ?) AND "c3" IS NOT NULL
    $select->from('foo')->where(array(
        'c1' => null,
        'c2' => array(1, 2, 3),
        new \Zend\Db\Sql\Predicate\IsNotNull('c3')
    ));
        

order():
........

.. code-block:: php
   :linenos:

   $select = new Select;
   $select->order('id DESC'); // produces 'id' DESC

   $select = new Select;
   $select->order('id DESC')
   	->order('name ASC, age DESC'); // produces 'id' DESC, 'name' ASC, 'age' DESC

   $select = new Select;
   $select->order(array('name ASC', 'age DESC')); // produces 'name' ASC, 'age' DESC

limit() and offset():
.....................

.. code-block:: php
   :linenos:

   $select = new Select;
   $select->limit(5); // always takes an integer/numeric
   $select->offset(10); // similarly takes an integer/numeric

.. _zend.db.sql.insert:

Zend\\Db\\Sql\\Insert
---------------------

Insert API:

.. code-block:: php
   :linenos:

   class Insert implements SqlInterface, PreparableSqlInterface
   {
   	const VALUES_MERGE = 'merge';
   	const VALUES_SET   = 'set';

   	public function __construct($table = null);
   	public function into($table);
   	public function columns(array $columns);
   	public function values(array $values, $flag = self::VALUES_SET);
   }

Так же как и в объекте Select, имя таблицы можно указывать в конструкторе или в методе into().

columns():
..........

.. code-block:: php
   :linenos:

   $insert->columns(array('foo', 'bar')); // set the valid columns

values():
.........

.. code-block:: php
   :linenos:

   // default behavior of values is to set the values
   // succesive calls will not preserve values from previous calls
   $insert->values(array(
   	'col_1' => 'value1',
   	'col_2' => 'value2'
   ));

.. code-block:: php
   :linenos:

   // merging values with previous calls
   $insert->values(array('col_2' => 'value2'), $insert::VALUES_MERGE);

.. _zend.db.sql.update:

Zend\\Db\\Sql\\Update
---------------------

.. code-block:: php
   :linenos:

   class Update
   {
       const VALUES_MERGE = 'merge';
       const VALUES_SET   = 'set';

       public $where; // @param Where $where
       public function __construct($table = null);
       public function table($table);
       public function set(array $values, $flag = self::VALUES_SET);
       public function where($predicate, $combination = Predicate\PredicateSet::OP_AND);
   }

set():
......

.. code-block:: php
   :linenos:

   $update->set(array('foo' => 'bar', 'baz' => 'bax'));

where():
........

Смотрите раздел where далее.

.. _zend.db.sql.delete:

Zend\\Db\\Sql\\Delete
---------------------

.. code-block:: php
   :linenos:

   class Delete
   {
       public $where; // @param Where $where
       public function __construct($table = null);
       public function from($table);
       public function where($predicate, $combination = Predicate\PredicateSet::OP_AND);
   }

where():
........

Смотрите раздел where далее.

.. _zend.db.sql.where:

Zend\\Db\\Sql\\Where и Zend\\Db\\Sql\\Having
--------------------------------------------

Далее, говоря о Where, будем подразумевать, что они с Having имеют одинаковый API. 

Очевидно, что Where и Having наследуются от одного объекта - Predicate (и PredicateSet). Все части Where и Having
которые могут быть соединены через «AND» или «OR» называются предикатами (predicates). Полный набор предикатов
называется PredicateSet. Этот объект обычно содержит контейнер со значениями (и идентификаторами) отдельно от
фрагментов к которым они принадлежат до того момента, когда выражение должно быть подготовлено (параметризировано)
или выполнено.  При  параметризации параметры замещают заполнители (placeholder), а сами значения хранятся внутри
Adapter\\ParameterContainer. А при выполении значения будут интерполированы в принадлежащие им фрагменты и
заключены в кавычки если это необходимо.

Важно помнить, что в этом API есть различия между элементами являющимися идентификаторами (TYPE_IDENTIFIER) и
значениями (TYPE_VALUE). Так же есть специальная методика использования для типа литерального типа - TYPE_LITERAL.
Все выше перечисленное доступно через интерфейс Zend\Db\Sql\ExpressionInterface. 

Zend\\Db\\Sql\\Where (Predicate/PredicateSet) API:

.. code-block:: php
   :linenos:

   // Where & Having:
   class Predicate extends PredicateSet
   {
        public $and;
        public $or;
        public $AND;
        public $OR;
        public $NEST;
        public $UNNSET;

        public function nest();
        public function setUnnest(Predicate $predicate);
        public function unnest();
        public function equalTo($left, $right, $leftType = self::TYPE_IDENTIFIER, $rightType = self::TYPE_VALUE);
        public function lessThan($left, $right, $leftType = self::TYPE_IDENTIFIER, $rightType = self::TYPE_VALUE);
        public function greaterThan($left, $right, $leftType = self::TYPE_IDENTIFIER, $rightType = self::TYPE_VALUE);
        public function lessThanOrEqualTo($left, $right, $leftType = self::TYPE_IDENTIFIER, $rightType = self::TYPE_VALUE);
        public function greaterThanOrEqualTo($left, $right, $leftType = self::TYPE_IDENTIFIER, $rightType = self::TYPE_VALUE);
        public function like($identifier, $like);
        public function literal($literal, $parameter);
        public function isNull($identifier);
        public function isNotNull($identifier);
        public function in($identifier, array $valueSet = array());
        public function between($identifier, $minValue, $maxValue);


        // Inherited From PredicateSet

        public function addPredicate(PredicateInterface $predicate, $combination = null);
        public function getPredicates();
        public function orPredicate(PredicateInterface $predicate);
        public function andPredicate(PredicateInterface $predicate);
        public function getExpressionData();
        public function count();
   }

Каждый метод Where API производит соответствующий объект предиката (Predicate) одноименных типов, описанных ниже,
в полном API:

equalTo(), lessThan(), greaterThan(), lessThanOrEqualTo(), greaterThanOrEqualTo():
..................................................................................

.. code-block:: php
   :linenos:

   $where->equalTo('id', 5);

   // same as the following workflow
   $where->addPredicate(
   	new Predicate\Operator($left, Operator::OPERATOR_EQUAL_TO, $right, $leftType, $rightType)
   );

   class Operator implements PredicateInterface
   {
       const OPERATOR_EQUAL_TO                  = '=';
       const OP_EQ                              = '=';
       const OPERATOR_NOT_EQUAL_TO              = '!=';
       const OP_NE                              = '!=';
       const OPERATOR_LESS_THAN                 = '<';
       const OP_LT                              = '<';
       const OPERATOR_LESS_THAN_OR_EQUAL_TO     = '<=';
       const OP_LTE                             = '<=';
       const OPERATOR_GREATER_THAN              = '>';
       const OP_GT                              = '>';
       const OPERATOR_GREATER_THAN_OR_EQUAL_TO  = '>=';
       const OP_GTE                             = '>=';

       public function __construct($left = null, $operator = self::OPERATOR_EQUAL_TO, $right = null, $leftType = self::TYPE_IDENTIFIER, $rightType = self::TYPE_VALUE);
       public function setLeft($left);
       public function getLeft();
       public function setLeftType($type);
       public function getLeftType();
       public function setOperator($operator);
       public function getOperator();
       public function setRight($value);
       public function getRight();
       public function setRightType($type);
       public function getRightType();
       public function getExpressionData();
   }

like($identifier, $like):
.........................

.. code-block:: php
   :linenos:

   $where->like($identifier, $like):

   // same as
   $where->addPredicate(
   	new Predicate\Like($identifier, $like)
   );

   // full API

   class Like implements PredicateInterface
   {
       public function __construct($identifier = null, $like = null);
       public function setIdentifier($identifier);
       public function getIdentifier();
       public function setLike($like);
       public function getLike();
   }

literal($literal, $parameter);
..............................

.. code-block:: php
   :linenos:

   $where->literal($literal, $parameter);

   // same as
   $where->addPredicate(
       new Predicate\Expression($literal, $parameter)
   );

   // full API
   class Expression implements ExpressionInterface, PredicateInterface
   {
       const PLACEHOLDER = '?';
   	public function __construct($expression = null, $valueParameter = null /*[, $valueParameter, ... ]*/);
       public function setExpression($expression);
       public function getExpression();
       public function setParameters($parameters);
       public function getParameters();
       public function setTypes(array $types);
       public function getTypes();
   }

isNull($identifier);
....................

.. code-block:: php
   :linenos:

   $where->isNull($identifier);

   // same as
   $where->addPredicate(
       new Predicate\IsNull($identifier)
   );

   // full API
   class IsNull implements PredicateInterface
   {
       public function __construct($identifier = null);
       public function setIdentifier($identifier);
       public function getIdentifier();
   }

isNotNull($identifier);
.......................

.. code-block:: php
   :linenos:

   $where->isNotNull($identifier);

   // same as
   $where->addPredicate(
       new Predicate\IsNotNull($identifier)
   );

   // full API
   class IsNotNull implements PredicateInterface
   {
       public function __construct($identifier = null);
       public function setIdentifier($identifier);
       public function getIdentifier();
   }

in($identifier, array $valueSet = array());
...........................................

.. code-block:: php
   :linenos:

   $where->in($identifier, array $valueSet = array());

   // same as
   $where->addPredicate(
       new Predicate\In($identifier, $valueSet)
   );

   // full API
   class In implements PredicateInterface
   {
       public function __construct($identifier = null, array $valueSet = array());
       public function setIdentifier($identifier);
       public function getIdentifier();
       public function setValueSet(array $valueSet);
       public function getValueSet();
   }

between($identifier, $minValue, $maxValue);
...........................................

.. code-block:: php
   :linenos:

   $where->between($identifier, $minValue, $maxValue);

   // same as
   $where->addPredicate(
       new Predicate\Between($identifier, $minValue, $maxValue)
   );

   // full API
   class Between implements PredicateInterface
   {
       public function __construct($identifier = null, $minValue = null, $maxValue = null);
       public function setIdentifier($identifier);
       public function getIdentifier();
       public function setMinValue($minValue);
       public function getMinValue();
       public function setMaxValue($maxValue);
       public function getMaxValue();
       public function setSpecification($specification);
   }


