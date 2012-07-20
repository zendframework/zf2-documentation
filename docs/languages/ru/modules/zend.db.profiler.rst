.. _zend.db.profiler:

Zend_Db_Profiler
================

.. _zend.db.profiler.introduction:

Введение
--------

*Zend_Db_Profiler* может быть включен для профилирования запросов.
Профили включают в себя запросы, обработанные адаптером, а
также время, затраченное на обработку запроса. Это позволяет
исследовать выполненные запросы без добавления
дополнительного отладочного кода в классы. Расширенное
использование также позволяет разработчикам указывать,
профилирование каких запросов производить.

Включение профилировщика производится либо передачей
директивы конструктору при создании адаптера, либо
последующим обращением к адаптеру для включения.

.. code-block:: php
   :linenos:

   $params = array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test'
       'profiler' => true  // включение профилировщика;
                           // для отключения устанавливайте в false
                           // (значение по умолчанию)
   );

   $db = Zend_Db::factory('PDO_MYSQL', $params);

   // отключение профилировщика:
   $db->getProfiler()->setEnabled(false);

   // включение профилировщика:
   $db->getProfiler()->setEnabled(true);


Значение опции '*profiler*' является гибким. Оно интерпретируется
по-разному в зависимости от его типа. В большинстве случаев
достаточно использовать простое булево значение, но с помощью
других типов можно управлять поведением профилировщика

Аргумент булевого типа включает профилировщик, если имеет
значение ``TRUE``, и выключает его, если имеет значение ``FALSE``. По
умолчанию адаптер использует класс профилировщика *Zend_Db_Profiler*.

   .. code-block:: php
      :linenos:

      $params['profiler'] = true;
      $db = Zend_Db::factory('PDO_MYSQL', $params);




Передача объекта профилировщика заставляет адаптер
использовать его. Объект должен принадлежать классу *Zend_Db_Profiler*
или его производному.

   .. code-block:: php
      :linenos:

      $profiler = MyProject_Db_Profiler();
      $profiler->setEnabled(true);
      $params['profiler'] = $profiler;
      $db = Zend_Db::factory('PDO_MYSQL', $params);




Аргумент может быть ассоциативным массивом, содержащим ключи
'*enabled*', '*instance*' и '*class*'. Ключи '*enabled*' и '*instance*' соответствуют
булевому типу и объекту, описанным выше. Ключ '*class*'
используется для имени класса профилировщика, который
требуется установить. Класс должен быть *Zend_Db_Profiler* или его
производным. Класс инстанцируется конструктором без передачи
аргументов. Опция '*class*' игнорируется, если установлена опция
'*instance*'.

   .. code-block:: php
      :linenos:

      $params['profiler'] = array(
          'enabled' => true,
          'class'   => 'MyProject_Db_Profiler'
      );
      $db = Zend_Db::factory('PDO_MYSQL', $params);




И наконец, аргумент может быть объектом типа *Zend_Config*,
содержащим свойства, аналогичные ключам массива, описанного
выше. К примеру, файл "config.ini" может содержать следующие данные:

   .. code-block:: ini
      :linenos:

      [main]
      db.profiler.class   = "MyProject_Db_Profiler"
      db.profiler.enabled = true


Эта конфигурация может быть применена так, как показано в коде
ниже:

   .. code-block:: php
      :linenos:

      $config = new Zend_Config_Ini('config.ini', 'main');
      $params['profiler'] = $config->db->profiler;
      $db = Zend_Db::factory('PDO_MYSQL', $params);


Свойство '*instance*' может быть использовано следующим образом:

   .. code-block:: php
      :linenos:

      $profiler = new MyProject_Db_Profiler();
      $profiler->setEnabled(true);
      $configData = array(
          'instance' => $profiler
          );
      $config = new Zend_Config($configData);
      $params['profiler'] = $config;
      $db = Zend_Db::factory('PDO_MYSQL', $params);




.. _zend.db.profiler.using:

Использование профилировщика
----------------------------

Извлечение профилировщика производится в любой момент через
метод *getProfiler()* адаптера:

.. code-block:: php
   :linenos:

   $profiler = $db->getProfiler();


Он вернет экземпляр класса *Zend_Db_Profiler*. С помощью этого
экземпляра разработчик может изучать запросы, используя
различные методы:

- *getTotalNumQueries()* возвращает общее количество запросов,
  обработанных профилировщиком.

- *getTotalElapsedSecs()* возвращает общее количество секунд, затраченное
  на все запросы, обработанные профилировщиком.

- *getQueryProfiles()* возвращает массив всех профилей запросов.

- *getLastQueryProfile()* возвращает последний созданный (самый недавний)
  профиль запроса, безотносительно того, был ли запрос завершен
  (если не был завершен, то конечное время будет равно null).

- *clear()* удаляет все профили запросов из стека.

Возвращаемое *getLastQueryProfile()* значение и отдельные элементы
*getQueryProfiles()* являются объектами *Zend_Db_Profiler_Query*, которые дают
возможность исследовать запросы по отдельности:

- *getQuery()* возвращает SQL-текст запроса. SQL-текст подготовленного
  оператора с параметрами является текстом в то время, когда
  запрос подготавливается, поэтому он содержит метки
  заполнения, а не значения, используемые во время выполнения
  запроса.

- *getQueryParams()* возвращает массив значений параметров, которые
  используются во время выполненения подготовленного запроса.
  Этот массив включает в себя как связанные параметры, так и
  аргументы для метода оператора *execute()*. Ключами массива
  являются позиционные (начинающиеся с 1) или именованные
  (строковые) индексы параметров.

- *getElapsedSecs()* возвращает время выполнения запроса в секундах.

Информация, предоставляемая *Zend_Db_Profiler*, полезна для выявления
"узких мест" в приложениях и отладки запросов. Например, чтобы
посмотреть, какой запрос выполнялся последним:

.. code-block:: php
   :linenos:

   $query = $profiler->getLastQueryProfile();

   echo $query->getQuery();


Возможно, страница генерируется медленно. Используйте
профилировщик для того, чтобы сначала определить общее
количество секунд для всех запросов, затем выполните обход
всех запросов, чтобы найти тот, который выполняется дольше
всех:

.. code-block:: php
   :linenos:

   $totalTime    = $profiler->getTotalElapsedSecs();
   $queryCount   = $profiler->getTotalNumQueries();
   $longestTime  = 0;
   $longestQuery = null;

   foreach ($profiler->getQueryProfiles() as $query) {
       if ($query->getElapsedSecs() > $longestTime) {
           $longestTime  = $query->getElapsedSecs();
           $longestQuery = $query->getQuery();
       }
   }

   echo 'Executed ' . $queryCount . ' queries in ' . $totalTime .
        ' seconds' . "\n";
   echo 'Average query length: ' . $totalTime / $queryCount .
        ' seconds' . "\n";
   echo 'Queries per second: ' . $queryCount / $totalTime . "\n";
   echo 'Longest query length: ' . $longestTime . "\n";
   echo "Longest query: \n" . $longestQuery . "\n";


.. _zend.db.profiler.advanced:

Расширенное использование профилировщика
----------------------------------------

Кроме исследования запросов, профилировщик также позволяет
фильтровать запросы, для которых создаются профили. Следующие
методы работают на экземпляре *Zend_Db_Profiler*:

.. _zend.db.profiler.advanced.filtertime:

Фильтрация по времени выполнения запроса
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*setFilterElapsedSecs()* дает возможность разработчику устанавливать
минимальное время запроса, после которого будет проводиться
профилирование запросов. Для того, чтобы убрать фильтрацию,
передайте методу значение null.

.. code-block:: php
   :linenos:

   // Профилировать только те запросы, которые отнимают не менее 5 секунд:
   $profiler->setFilterElapsedSecs(5);

   // Профилировать все запросы безотносительно времени выполнения:
   $profiler->setFilterElapsedSecs(null);


.. _zend.db.profiler.advanced.filtertype:

Фильтрация по типу запроса
^^^^^^^^^^^^^^^^^^^^^^^^^^

*setFilterQueryType()* дает разработчику возможность указывать, для
каких типов запросов должны создаваться профили; для
обработки нескольких типов запросов используйте логическое
*OR*. Типы запросов определены в следующих константах *Zend_Db_Profiler*:

- *Zend_Db_Profiler::CONNECT*: операции по установке соединения или выбора
  базы данных.

- *Zend_Db_Profiler::QUERY*: общие запросы к базе данных, которые не
  соответствуют другим типам.

- *Zend_Db_Profiler::INSERT*: любые запросы, через которые добавляются
  новые данные в базу данных, как правило, это команда INSERT.

- *Zend_Db_Profiler::UPDATE*: любые запросы, которые обновляют существующие
  данные, обычно это команда UPDATE.

- *Zend_Db_Profiler::DELETE*: любые запросы, которые удаляют существующие
  данные, обычно это команда DELETE.

- *Zend_Db_Profiler::SELECT*: любые запросы, через которые извлекаются
  существующие данные, обычно это команда SELECT.

- *Zend_Db_Profiler::TRANSACTION*: любые операции с транзакциями, такие, как
  начало транзакции, фиксация транзакции или откат.

Как и в случае *setFilterElapsedSecs()*, вы можете удалить все фильтры,
передав ``NULL`` в качестве единственного аргумента.

.. code-block:: php
   :linenos:

   // профилирование только запросов SELECT
   $profiler->setFilterQueryType(Zend_Db_Profiler::SELECT);

   // профилирование запросов SELECT, INSERT и UPDATE
   $profiler->setFilterQueryType(Zend_Db_Profiler::SELECT |
                                 Zend_Db_Profiler::INSERT |
                                 Zend_Db_Profiler::UPDATE);

   // профилирование запросов DELETE
   $profiler->setFilterQueryType(Zend_Db_Profiler::DELETE);

   // удалить все фильтры
   $profiler->setFilterQueryType(null);


.. _zend.db.profiler.advanced.getbytype:

Получение профилей по типу запроса
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Использование метода *setFilterQueryType()* может сократить количество
генерируемых профилей. Тем не менее, иногда может быть
полезным хранить все профили, но просматривать только те,
которые нужны в данный момент. Другой метод *getQueryProfiles()* может
производить такую фильтрацию "на лету", ему передается тип
запроса (или логическая комбинация типов запросов) в качестве
первого аргумента; список констант типов запросов см. :ref:`
<zend.db.profiler.advanced.filtertype>`.

.. code-block:: php
   :linenos:

   // Получение только профилей запросов SELECT
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::SELECT);

   // Получение только профилей запросов SELECT, INSERT и UPDATE
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::SELECT |
                                           Zend_Db_Profiler::INSERT |
                                           Zend_Db_Profiler::UPDATE);

   // Получение профилей запросов DELETE
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::DELETE);


.. _zend.db.profiler.profilers:

Специализированные профилировщики
---------------------------------

Специализированный профилировщик - это объект, который
наследует от *Zend_Db_Profiler*. Специализированные профилировщики
предназначены для специальной обработки данных
профилирования.

.. include:: zend.db.profiler.firebug.rst

