.. EN-Revision: 3728e7b
.. _zend.db.row-gateway:

Zend\\Db\\RowGateway
====================

``Zend\Db\RowGateway`` - это подкомпонент Zend\\Db, реализующий паттерн Row Gateway из PoEAA. Это фактически
означате, что объекты Row Gateway прежде всего моделируют строку в базе данных и имеют такие методы, как save()
и delete(), которые помогают строке-как-объекту сохранять в базе данных самой себя. Кроме того, после извлечения
этой строки из базы данных, её можно изменить и сохранить её обратно на туже позицию(строку) или можно удалить из
таблицы.

Интерфейс для объектов Row Gateway просто добавляет методы save() и delete(), а так же этот интерфейс следует
использовать когда компонент имеет зависимость, которая в свою очередь должна быть объектом RowGateway.

.. code-block:: php
   :linenos:

   interface RowGatewayInterface
   {
       public function save();
       public function delete();
   }

.. _zend.db.row-gateway.row-gateway:

Быстрый старт
-------------

Обычно RowGateway используется совместно с остальными объектами, созданными Zend\\Db\\ResultSet. Но при
необходимости можно использовать и независимо. Для независимого использования необходимо передать Адаптер для
соединения с базой данных. Следующий простой пример демонстрирует использование Zend\\Db\\RowGateway\\RowGateway:

.. code-block:: php
   :linenos:

   use Zend\Db\RowGateway\RowGateway;

   // query the database
   $resultSet = $adapter->query('SELECT * FROM `user` WHERE `id` = ?', array(2));

   // get array of data
   $rowData = $resultSet->current()->getArrayCopy();

   // row gateway
   $rowGateway = new RowGateway('id', 'my_table', $adapter);
   $rowGateway->populate($rowData);

   $rowGateway->first_name = 'New Name';
   $rowGateway->save();

   // or delete this row:
   $rowGateway->delete();

Процесс работы описанный выше можно упростить, если его использовать с TableGateway. То есть, сначала объект
TableGateway делает select() из таблицы, создает объект ResultSet, который затем в состоянии создать объекты
Row Gateway. Такой вариант использования выглядит примерно так:

.. code-block:: php
   :linenos:

   use Zend\Db\TableGateway\Feature\RowGatewayFeature;
   use Zend\Db\TableGateway\TableGateway;

   $table = new TableGateway('artist', $adapter, new RowGatewayFeature('id'));
   $results = $table->select(array('id' => 2));

   $artistRow = $results->current();
   $artistRow->name = 'New Name';
   $artistRow->save();


