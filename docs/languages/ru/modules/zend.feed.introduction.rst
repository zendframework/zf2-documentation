.. EN-Revision: none
.. _zend.feed.introduction:

Введение
========

*Zend_Feed* предназначен для работы с лентами RSS и Atom. Он
предоставляет естетственный синтаксис (natural syntax) для доступа к
элементам лент, атрибутам лент и их сообщений, полностью
поддерживает изменение структуры лент и публикаций с
использованием того же синтаксиса и преобразует результаты
изменений обратно в XML. В будущем эта поддержка изменений может
обеспечить добавление поддержки Atom Publishing Protocol.

Программно *Zend_Feed* состоит из базового класса *Zend_Feed*,
абстрактных базовых классов *Zend\Feed\Abstract* и *Zend\Feed\Entry\Abstract* для
представления лент и их сообщений, реализаций лент и сообщений
применительно для RSS и Atom, а также "помощников" для обеспечения
работы естетственного синтаксиса.

В примере ниже мы демонстрируем простое получение ленты RSS и
сохранение нужных данных из ленты в массив PHP, который может
быть использован для распечатки, сохранения в БД и т.д.

.. note::

   **Внимание**

   Многие ленты RSS различаются по набору доступных свойств
   каналов и сообщений. Спецификация RSS предоставляет множество
   необязательных свойств, поэтому имейте это в виду, когда
   пишете код для работы с данными RSS.

.. _zend.feed.introduction.example.rss:

.. rubric:: Использование Zend_Feed в работе с данными ленты RSS

.. code-block:: php
   :linenos:

   // Извлечение последних новостей Slashdot
   try {
       $slashdotRss =
           Zend\Feed\Feed::import('http://rss.slashdot.org/Slashdot/slashdot');
   } catch (Zend\Feed\Exception $e) {
       // неудача при импортировании ленты
       echo "Exception caught importing feed: {$e->getMessage()}\n";
       exit;
   }

   // Инициализация массива данных каналов
   $channel = array(
       'title'       => $slashdotRss->title(),
       'link'        => $slashdotRss->link(),
       'description' => $slashdotRss->description(),
       'items'       => array()
       );

   // Обход каналов и сохранение данных
   foreach ($slashdotRss as $item) {
       $channel['items'][] = array(
           'title'       => $item->title(),
           'link'        => $item->link(),
           'description' => $item->description()
           );
   }



