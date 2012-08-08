.. EN-Revision: none
.. _zend.session.basicusage:

Базовое использование
=====================

*Zend_Session_Namespace* создает экземпляры контейнеров, предоставляющих
основной API для работы с данными сессии в Zend Framework. Пространства
имен используются для разделения всех данных сессии, несмотря
на то, что есть пространство имен по умолчанию для тех, кому
нужно только одно пространство имен для всех данных сессии.
*Zend_Session* использует расширение ext/session и его суперглобальный
массив ``$_SESSION`` в качестве механизма хранения постоянных
данных сессии. Несмотря на то, что ``$_SESSION`` остается доступным в
глобальном пространстве имен, разработчики должны избегать
прямого обращения к нему с тем, чтобы можно было наиболее
безопасно и эффективно использовать возможности *Zend_Session* и
*Zend_Session_Namespace* для работы с сессиями.

.. _zend.session.basicexamples:

Учебные примеры
---------------

Если при инстанцировании Zend_Session не было указано пространство
имен, то все данные будут неявным образом сохранены в
пространстве имен "*Default*". *Zend_Session* не предназначен для работы с
содержимым контейнера пространства имен сессии напрямую.
Вместо этого мы используем *Zend_Session_Namespace*. Пример ниже
демонстрирует использование пространства имен по умолчанию и
показывает, как подсчитывать количество просмотров страниц
пользователем на сайте. Для тестирования этого примера
добавьте следующий код в файл загрузки:

.. rubric:: Подсчет количества просмотров страниц

.. code-block:: php
   :linenos:

   <?php
       require_once 'Zend/Session.php';

       $defaultNamespace = new Zend_Session_Namespace('Default');

       // используется "магический" метод __isset() в Zend_Session_Namespace:
       if (isset($defaultNamespace->numberOfPageRequests)) {
           // будет увеличиваться на единицу при каждой загрузке страницы.
           $defaultNamespace->numberOfPageRequests++;
       } else {
           $defaultNamespace->numberOfPageRequests = 1; // начальное значение
       }

       echo "Запросов к странице за эту сессию: ", $defaultNamespace->numberOfPageRequests;
   ?>
Одним из многих преимуществ Zend_Session_Namespace является то, что при
его использовании различными модулями приложения достигается
инкапсуляциия принадлежащих им данных сессий. Конструктору
Zend_Session можно передавать необязательный аргумент $namespace,
который позволяет другим компонентам, модулям и разрабочикам
кода быть уверенным в том, что их данные защищены отделением от
других областей данных, используемых другими компонентами,
модулями и кодами разработчиков. Пространства имен
представляют собой эффективный и доступный способ защиты
данных сессий от случайных изменений. Имена пространств имен
должны быть непустыми строками, не начинающимися со знака
подчеркивания. Только основные компоненты, включенные в Zend
Framework, должны использовать имена пространств имен,
начинающиеся с 'Zend\_'.

.. rubric:: Новый подход: избежание конфликтов с помощью пространств имен

.. code-block:: php
   :linenos:

   <?php
       // in the Zend_Auth component
       require_once 'Zend/Session.php';
       $authNamespace = new Zend_Session_Namespace('Zend_Auth');
       $authNamespace->user = "myusername";

       // in a web services component
       $webServiceNamespace = new Zend_Session_Namespace('Some_Web_Service');
       $webServiceNamespace->user = "mywebusername";
   ?>
Пример выше приводит к тому же результату, что и код ниже, за
тем исключением, что объекты сессий сохраняют инкапсуляцию
сессионных данных внутри их пространств имен.

.. rubric:: Старый подход: обращение к сессиям PHP

.. code-block:: php
   :linenos:

   <?php
       $_SESSION['Zend_Auth']['user'] = "myusername";
       $_SESSION['Some_Web_Service']['user'] = "mywebusername";
   ?>
.. _zend.session.iteration:

Итерация по пространствам имен
------------------------------

*Zend_Session_Namespace* предоставляет полный интерфейс `IteratorAggregate`_,
включая поддержку выражения *foreach*:

.. rubric:: Итерация по сессии

.. code-block:: php
   :linenos:

   <?php
       // Zend_Session is iteratable
       require_once 'Zend/Session.php';
       $aNamespace = new Zend_Session_Namespace('some_namespace_with_data_present');
       foreach ($aNamespace as $index => $value) {
           echo "aNamespace->$index = '$value';\n";
       }
   ?>
.. _zend.session.accessors:

Методы доступа для пространств имен
-----------------------------------

Обычные методы доступа доступны через "магические" методы (magic
methods) \__set(), \__unset(), \__isset() и \__get(). "Магические" методы не должны
использоваться напрямую, кроме как внутри подклассов Zend_Session.
Вместо этого используйте обычные операторы для вызова этих
"магических" методов, например:

.. rubric:: Доступ к сессионным данным

.. code-block:: php
   :linenos:

   <?php
               $object->property = $value;
               echo (isset($object->property) ? 'set' : 'unset');
   ?>


.. _`IteratorAggregate`: http://www.php.net/~helly/php/ext/spl/interfaceIteratorAggregate.html
