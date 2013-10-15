.. EN-Revision: none
.. _zend.paginator.advanced:

Расширенное использование
=========================

.. _zend.paginator.advanced.adapters:

Создание собственных адаптеров к источникам данных
--------------------------------------------------

Вы можете столкнуться с таким типом источника данных, для
которого в Zend Framework-е не предусмотрено адаптера. В этом случае
нужно создать собственный адаптер.

Для этого нужно реализовать интерфейс ``Zend\Paginator\Adapter\Interface``. Он
включает в себя два метода:

- count()

- getItems($offset, $itemCountPerPage)

Кроме того, нужно реализовать конструктор, который принимает
источник данных в качестве параметра и сохраняет его в
защищенном или закрытом свойстве. Как его обрабатывать -
зависит от вас.

Если вы когда-либо использовали SPL-интерфейс `Countable`_, то вам
должно быть известно о назначении метода ``count()``. В ``Zend_Paginator`` он
возвращает общее количество элементов в наборе данных. Кроме
того, объект ``Zend_Paginator`` предоставляет метод ``countAllItems()`` который
служит посредником к методу адаптера ``count()``.

Метод ``getItems()`` ненамного сложнее. Он должен принимать смещение
и количество элементов на странице и возвращать
соответствующий кусок данных. В случае массива он мог бы
выглядеть следующим образом:

.. code-block:: php
   :linenos:

   return array_slice($this->_array, $offset, $itemCountPerPage);

Посмотрите исходники адаптеров, входящих в поставку Zend Framework
(все они реализуют ``Zend\Paginator\Adapter\Interface``), чтобы получить
представление о том, как можно реализовать свой адаптер.

.. _zend.paginator.advanced.scrolling-styles:

Создание своих стилей прокрутки
-------------------------------

При создании своего стиля прокрутки реализуйте интерфейс
``Zend\Paginator\ScrollingStyle\Interface``, который определяет единственный
метод, ``getPages()``:

.. code-block:: php
   :linenos:

   public function getPages(Zend_Paginator $paginator, $pageRange = null);

Этот метод должен определять номера пограничных страниц в
ряде так называемых "локальных" страниц (т.е. страниц, которые
находятся рядом с текущей страницей).

Если только ваш стиль прокрутки не наследует от уже
существующего (для примера смотрите ``Zend\Paginator\ScrollingStyle\Elastic``), то
этот метод должен иметь в конце что-то вроде следующего:

.. code-block:: php
   :linenos:

   return $paginator->getPagesInRange($lowerBound, $upperBound);

Этим вызовом не делается ничего особенного. Этот метод просто
для удобства - он проверяет на корректность верхний и нижний
пределы и возвращает массив номеров страниц для постраничной
навигации.

Для того, чтобы использовать новый стиль прокрутки, следует
указать ``Zend_Paginator``-у, в какой директории этот стиль находится.
Для этого сделайте следующее:

.. code-block:: php
   :linenos:

   $prefix = 'My_Paginator_ScrollingStyle';
   $path   = 'My/Paginator/ScrollingStyle/';
   Zend\Paginator\Paginator::addScrollingStylePrefixPath($prefix, $path);

.. _zend.paginator.advanced.caching:

Возможности кэширования
-----------------------

Можно указать ``Zend_Paginator``-у, чтобы он кэшировал получаемые
данные, чтобы они не извлекались через адаптер всякий раз,
когда будет в них нужда. Для этого просто передайте его методу
``setCache()`` экземпляр ``Zend\Cache\Core``.



   .. code-block:: php
      :linenos:

      $paginator = Zend\Paginator\Paginator::factory($someData);
      $fO = array('lifetime' => 3600, 'automatic_serialization' => true);
      $bO = array('cache_dir'=>'/tmp');
      $cache = Zend\cache\cache::factory('Core', 'File', $fO, $bO);
      Zend\Paginator\Paginator::setCache($cache);



После того, как ``Zend_Paginator`` получит экземпляр ``Zend\Cache\Core``, все
данные будут кэшироваться. Иногда возникает необходимость
отключать кэширование данных даже после того, как вы передали
эекземпляр ``Zend\Cache\Core``. Для этого вы можете использовать метод
``setCacheEnable()``.



   .. code-block:: php
      :linenos:

      $paginator = Zend\Paginator\Paginator::factory($someData);
      // $cache является экземпляром
      Zend\Paginator\Paginator::setCache($cache);
      // ... ниже в коде
      $paginator->setCacheEnable(false);
      // теперь кэширование отключено



После того, как был установлен объект для кэширования, данные
будут сохраняться и извлекаться через него. Иногда бывает
нужно очищать кэш вручную. Вы можете делать это через вызов
метода ``clearPageItemCache($pageNumber)``. В качестве аргумента метод
принимает номер страницы, кэш которой следует очистить. Если
вызов производится без передачи параметра, то весь кэш будет
очищен:



   .. code-block:: php
      :linenos:

      $paginator = Zend\Paginator\Paginator::factory($someData);
      Zend\Paginator\Paginator::setCache($cache);
      $items = $paginator->getCurrentItems();
      // теперь страница 1 в кэше
      $page3Items = $paginator->getItemsByPage(3);
      // теперь и страница 3 в кэше

      // очищение кэша результатов для страницы 3
      $paginator->clearPageItemCache(3);

      // очищение всего кэша
      $paginator->clearPageItemCache();



Изменение количества элементов на странице приведет к
очищению всего кэша, поскольку после этого он должен потерять
актуальность:



   .. code-block:: php
      :linenos:

      $paginator = Zend\Paginator\Paginator::factory($someData);
      Zend\Paginator\Paginator::setCache($cache);
      // извлечение некоторых элементов
      $items = $paginator->getCurrentItems();

      // весь кэш будет очищен:
      $paginator->setItemCountPerPage(2);



Можно также видеть данные в кэше и запрашивать их напрямую. Для
этого может использоваться метод ``getPageItemCache()``:



   .. code-block:: php
      :linenos:

      $paginator = Zend\Paginator\Paginator::factory($someData);
      $paginator->setItemCountPerPage(3);
      Zend\Paginator\Paginator::setCache($cache);

      // извлечение некоторых элементов
      $items = $paginator->getCurrentItems();
      $otherItems = $paginator->getItemsPerPage(4);

      // просмотр сохраненных в кэше элементов в виде двухмерного массива:
      var_dump($paginator->getPageItemCache());



.. _zend.paginator.advanced.aggregator:

Интерфейс Zend\Paginator\AdapterAggregate
-----------------------------------------

В зависимости от разрабатываемого приложения может
возникнуть потребность разбивать на страницы объекты, у
которых внутренняя структура данных эквивалентна
существующим адаптерам, но при этом вы не хотите нарушать
инкапсуляцию для того, что предоставлять доступ к этим данным.
В других случаях объект может участвовать в связи
"имеет-адаптер" вместо связи "является-адаптером", которую
предлагает ``Zend\Paginator\Adapter\Abstract``. В этих случаях вы можете
использовать интерфейс ``Zend\Paginator\AdapterAggregate``, который по
поведению значительно похож на интерфейс ``IteratorAggregate`` из
расширения SPL.



   .. code-block:: php
      :linenos:

      interface Zend\Paginator\AdapterAggregate
      {
          /**
           * Возвращайте из этого метода полностью сконфигурированный адаптер.
           *
           * @return Zend\Paginator\Adapter\Abstract
           */
          public function getPaginatorAdapter();
      }



Как видно из кода, интерфейс довольно небольшой и от вас
ожидается только возврат экземпляра ``Zend\Paginator\Adapter\Abstract``.
Фабричный метод ``Zend\Paginator\Paginator::factory`` и конструктор класса ``Zend_Paginator``
после этого распознают экземпляр ``Zend\Paginator\AdapterAggregate`` и
обрабатывают его должным образом.



.. _`Countable`: http://www.php.net/~helly/php/ext/spl/interfaceCountable.html
