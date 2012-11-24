.. EN-Revision: 3728e7b
.. _zend.db.metadata:

Zend\\Db\\Metadata
==================

``Zend\Db\Metadata`` это подкомпонент Zend\\Db, который делает возможным получение информации о метаданнх таблиц,
колонок, ограничений, триггеров, и другую информацию из базы данных стандартизированным образом. Основной интерфейс
объектов Metadata такой:

.. code-block:: php
   :linenos:

   interface MetadataInterface
   {
       public function getSchemas();

       public function getTableNames($schema = null, $includeViews = false);
       public function getTables($schema = null, $includeViews = false);
       public function getTable($tableName, $schema = null);

       public function getViewNames($schema = null);
       public function getViews($schema = null);
       public function getView($viewName, $schema = null);

       public function getColumnNames($table, $schema = null);
       public function getColumns($table, $schema = null);
       public function getColumn($columnName, $table, $schema = null);

       public function getConstraints($table, $schema = null);
       public function getConstraint($constraintName, $table, $schema = null);
       public function getConstraintKeys($constraint, $table, $schema = null);

       public function getTriggerNames($schema = null);
       public function getTriggers($schema = null);
       public function getTrigger($triggerName, $schema = null);
   }

.. _zend.db.metadata.metadata:

Основное использование
----------------------

Использовать ``Zend\Db\Metadata`` очень просто. Класс верхнего уровня Zend\\Db\\Metadata\\Metadata, опираясь на
полученный адаптер, выбирает лучшую стратегию извлечения метаданных (основываясь на используемой платформе базы
данных). В большинстве случаев, информация поступит из запроса к таблицам INFORMATION_SCHEMA, общедоступных для
всех соединений с базой данных, о текущей доступной схеме.

Методы Metadata::get*Names() вернут массив строк, в то время как остальные методы возвращают особые
объекты-значения, содержащие информацю. Это наилучшим образом демонстрируется скриптом ниже.

.. code-block:: php
   :linenos:

   $metadata = new Zend\Db\Metadata\Metadata($adapter);

   // get the table names
   $tableNames = $metadata->getTableNames();

   foreach ($tableNames as $tableName) {
       echo 'In Table ' . $tableName . PHP_EOL;

       $table = $metadata->getTable($tableName);


       echo '    With columns: ' . PHP_EOL;
       foreach ($table->getColumns() as $column) {
           echo '        ' . $column->getName()
               . ' -> ' . $column->getDataType()
               . PHP_EOL;
       }

       echo PHP_EOL;
       echo '    With constraints: ' . PHP_EOL;

       foreach ($metadata->getConstraints($tableName) as $constraint) {
           /** @var $constraint Zend\Db\Metadata\Object\ConstraintObject */
           echo '        ' . $constraint->getName()
               . ' -> ' . $constraint->getType()
               . PHP_EOL;
           if (!$constraint->hasColumns()) {
               continue;
           }
           echo '            column: ' . implode(', ', $constraint->getColumns());
           if ($constraint->isForeignKey()) {
               $fkCols = array();
               foreach ($constraint->getReferencedColumns() as $refColumn) {
                   $fkCols[] = $constraint->getReferencedTableName() . '.' . $refColumn;
               }
               echo ' => ' . implode(', ', $fkCols);
           }
           echo PHP_EOL;

       }

       echo '----' . PHP_EOL;
   }

Metadata возвращает объекты-значения, которые предоставляют интерфейс для помощи разработчикам лучше исследовать
метаданные. Ниже расположен API для различных объектов-значений:

TableObject:

.. code-block:: php
   :linenos:

   class Zend\Db\Metadata\Object\TableObject
   {
       public function __construct($name);
       public function setColumns(array $columns);
       public function getColumns();
       public function setConstraints($constraints);
       public function getConstraints();
       public function setName($name);
       public function getName();
   }

ColumnObject:

.. code-block:: php
   :linenos:

   class Zend\Db\Metadata\Object\ColumnObject {
       public function __construct($name, $tableName, $schemaName = null);
       public function setName($name);
       public function getName();
       public function getTableName();
       public function setTableName($tableName);
       public function setSchemaName($schemaName);
       public function getSchemaName();
       public function getOrdinalPosition();
       public function setOrdinalPosition($ordinalPosition);
       public function getColumnDefault();
       public function setColumnDefault($columnDefault);
       public function getIsNullable();
       public function setIsNullable($isNullable);
       public function isNullable();
       public function getDataType();
       public function setDataType($dataType);
       public function getCharacterMaximumLength();
       public function setCharacterMaximumLength($characterMaximumLength);
       public function getCharacterOctetLength();
       public function setCharacterOctetLength($characterOctetLength);
       public function getNumericPrecision();
       public function setNumericPrecision($numericPrecision);
       public function getNumericScale();
       public function setNumericScale($numericScale);
       public function getNumericUnsigned();
       public function setNumericUnsigned($numericUnsigned);
       public function isNumericUnsigned();
       public function getErratas();
       public function setErratas(array $erratas);
       public function getErrata($errataName);
       public function setErrata($errataName, $errataValue);
   }

ConstraintObject:

.. code-block:: php
   :linenos:

   class Zend\Db\Metadata\Object\ConstraintObject
   {
       public function __construct($name, $tableName, $schemaName = null);
       public function setName($name);
       public function getName();
       public function setSchemaName($schemaName);
       public function getSchemaName();
       public function getTableName();
       public function setTableName($tableName);
       public function setType($type);
       public function getType();
       public function hasColumns();
       public function getColumns();
       public function setColumns(array $columns);
       public function getReferencedTableSchema();
       public function setReferencedTableSchema($referencedTableSchema);
       public function getReferencedTableName();
       public function setReferencedTableName($referencedTableName);
       public function getReferencedColumns();
       public function setReferencedColumns(array $referencedColumns);
       public function getMatchOption();
       public function setMatchOption($matchOption);
       public function getUpdateRule();
       public function setUpdateRule($updateRule);
       public function getDeleteRule();
       public function setDeleteRule($deleteRule);
       public function getCheckClause();
       public function setCheckClause($checkClause);
       public function isPrimaryKey();
       public function isUnique();
       public function isForeignKey();
       public function isCheck();

   }

TriggerObject:

.. code-block:: php
   :linenos:

   class Zend\Db\Metadata\Object\TriggerObject
   {
       public function getName();
       public function setName($name);
       public function getEventManipulation();
       public function setEventManipulation($eventManipulation);
       public function getEventObjectCatalog();
       public function setEventObjectCatalog($eventObjectCatalog);
       public function getEventObjectSchema();
       public function setEventObjectSchema($eventObjectSchema);
       public function getEventObjectTable();
       public function setEventObjectTable($eventObjectTable);
       public function getActionOrder();
       public function setActionOrder($actionOrder);
       public function getActionCondition();
       public function setActionCondition($actionCondition);
       public function getActionStatement();
       public function setActionStatement($actionStatement);
       public function getActionOrientation();
       public function setActionOrientation($actionOrientation);
       public function getActionTiming();
       public function setActionTiming($actionTiming);
       public function getActionReferenceOldTable();
       public function setActionReferenceOldTable($actionReferenceOldTable);
       public function getActionReferenceNewTable();
       public function setActionReferenceNewTable($actionReferenceNewTable);
       public function getActionReferenceOldRow();
       public function setActionReferenceOldRow($actionReferenceOldRow);
       public function getActionReferenceNewRow();
       public function setActionReferenceNewRow($actionReferenceNewRow);
       public function getCreated();
       public function setCreated($created);
   }


