.. EN-Revision: none
.. _zend.uri.chapter:

Zend_Uri
========

.. _zend.uri.overview:

Обзор
-----

``Zend_Uri`` является компонентой, которая призвана облегчить
работу с URI (`Uniform Resource Identifiers`_) и их валидацию. ``Zend_Uri`` был создан
для обслуживания других компонент, таких, как ``Zend\Http\Client``, но
полезен и как отдельная утилита.

URI всегда начинаются со схемы, после которой следует двоеточие.
Структура для разных схем может сильно отличаться. Класс
``Zend_Uri`` предоставляет фабрику (паттерн factory), которая
возвращает его подклассы, специализирующиеся в различных
схемах. Подклассы называются ``Zend\Uri\<scheme>``, где *<scheme>*- схема в
нижнем регистре, с прописной первой буквой. Исключением из
этого правила является HTTPS, который обрабатывается подклассом
``Zend\Uri\Http``.

.. _zend.uri.creation:

Создание нового URI
-------------------

``Zend_Uri`` будет строить с нуля новый URI, если *Zend\Uri\Uri::factory()* была
передана только схема.

.. _zend.uri.creation.example-1:

.. rubric:: Создание нового URI с Zend\Uri\Uri::factory()

.. code-block:: php
   :linenos:

   // Для того, чтобы создать с нуля новый URI, передайте только схему.
   $uri = Zend\Uri\Uri::factory('http');

   // $uri является экземпляром Zend\Uri\Http

Для того, чтобы создать с нуля новый URI, передайте *Zend\Uri\Uri::factory()*
только схему. [#]_. При передаче не поддерживаемой схемы
генерируется исключение ``Zend\Uri\Exception``.

Если переданные схема или URI поддерживаются, то *Zend\Uri\Uri::factory()*
вернет свой подкласс, который специализируется на данной
схеме.

.. _zend.uri.manipulation:

Работа с существующим URI
-------------------------

Для того, чтобы работать с существующим URI, передайте его весь
целиком *Zend\Uri\Uri::factory()*.

.. _zend.uri.manipulation.example-1:

.. rubric:: Работа с существующим URI через Zend\Uri\Uri::factory()

.. code-block:: php
   :linenos:

   // Чтобы работать с существующим URI, передайте его как параметр
   $uri = Zend\Uri\Uri::factory('http://www.zend.com');

   // $uri является экземпляром Zend\Uri\Http

URI будет распарсен и проверен на валидность. Если он оказался
невалидным, то сразу же будет сгенерировано исключение
``Zend\Uri\Exception``. Иначе *Zend\Uri\Uri::factory()* вернет свой подкласс, который
специализируется на данной схеме.

.. _zend.uri.validation:

Проверка URI
------------

Функция *Zend\Uri\Uri::check()* может использоваться в том случае, когда
нужна только проверка существующего URI.

.. _zend.uri.validation.example-1:

.. rubric:: Проверка URI с помощью Zend\Uri\Uri::check()

.. code-block:: php
   :linenos:

   // Проверка, является ли данный URI синтаксически корректным
   $valid = Zend\Uri\Uri::check('http://uri.in.question');

   // $valid равен TRUE при валидном URI, иначе FALSE

*Zend\Uri\Uri::check()* возвращает булево значение, использование этой
функции более удобно, чем вызов *Zend\Uri\Uri::factory()* и отлов исключения.

.. _zend.uri.validation.allowunwise:

Разрешение использования "неумных" символов в URI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

По умолчанию ``Zend_Uri`` не будет принимать следующие символы,
которые в спецификации определены как "неумные" (unwise) и
невалидные: *"{", "}", "|", "\", "^", "`"*. Тем не менее, многие реализации
принимают эти символы как валидные.

Можно заставить ``Zend_Uri`` принимать эти символы путем установки
'allow_unwise' в TRUE, используя метод *Zend\Uri\Uri::setConfig()*:

.. _zend.uri.validation.allowunwise.example-1:

.. rubric:: Разрешение использования спецсимволов в URI

.. code-block:: php
   :linenos:

   // Содержит символ '|'
   // Обычно такой вызов будет возвращать 'false':
   $valid = Zend\Uri\Uri::check('http://example.com/?q=this|that');

   // Тем не менее, вы можете разрешить "неумные" символы
   Zend\Uri\Uri::setConfig(array('allow_unwise' => true));
   // будет возвращать 'true'
   $valid = Zend\Uri\Uri::check('http://example.com/?q=this|that');

   // Установка 'allow_unwise' обратно в FALSE
   Zend\Uri\Uri::setConfig(array('allow_unwise' => false));

.. note::

   *Zend\Uri\Uri::setConfig()* глобально устанавливает опции конфигурации.
   Рекомендуется сбрасывать опцию 'allow_unwise' в 'false', как показано в
   примере выше, если только вы не хотите разрешить
   использование "неумных" символов на все время во всем
   приложении.

.. _zend.uri.instance-methods:

Общие методы экземпляров
------------------------

Каждый экземпляр подкласса ``Zend_Uri`` (например, ``Zend\Uri\Http``) имеет
несколько методов, полезных для работы с любыми видами URI.

.. _zend.uri.instance-methods.getscheme:

Получение схемы URI
^^^^^^^^^^^^^^^^^^^

Схема URI – часть URI, завершающаяся двоеточием. Например, схемой
в *http://www.zend.com* является *http*.

.. _zend.uri.instance-methods.getscheme.example-1:

.. rubric:: Получение схемы из объекта Zend\Uri\*

.. code-block:: php
   :linenos:

   $uri = Zend\Uri\Uri::factory('http://www.zend.com');

   $scheme = $uri->getScheme();  // "http"

Метод экземпляра *getScheme()* возвращает схему из URI.

.. _zend.uri.instance-methods.geturi:

Получение всего URI
^^^^^^^^^^^^^^^^^^^

.. _zend.uri.instance-methods.geturi.example-1:

.. rubric:: Получение всего URI из объекта Zend\Uri\*

.. code-block:: php
   :linenos:

   $uri = Zend\Uri\Uri::factory('http://www.zend.com');

   echo $uri->getUri();  // "http://www.zend.com"

Метод *getUri()* возвращает строковое представление всего URI.

.. _zend.uri.instance-methods.valid:

Проверка URI на валидность
^^^^^^^^^^^^^^^^^^^^^^^^^^

*Zend\Uri\Uri::factory()* всегда производит синтаксическую проверку
переданных ему URI и не будет создавать новый экземпляр
подкласса ``Zend_Uri``, если данный URI не прошел проверку. Тем не
менее, после того, как был инстанцирован подкласс ``Zend_Uri`` для
нового URI или на основе уже существующего, в результате
манипуляций с ним этот URI может стать невалидным.

.. _zend.uri.instance-methods.valid.example-1:

.. rubric:: Проверка объекта Zend\Uri\*

.. code-block:: php
   :linenos:

   $uri = Zend\Uri\Uri::factory('http://www.zend.com');

   $isValid = $uri->valid();  // TRUE

Метод *valid()* дает возможность проверить, является ли URI
по-прежнему валидным.



.. _`Uniform Resource Identifiers`: http://www.w3.org/Addressing/

.. [#] На момент написания этой документации Zend_Uri поддерживает
       только схемы HTTP и HTTPS.