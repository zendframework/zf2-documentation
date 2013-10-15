.. EN-Revision: none
.. _zend.xmlrpc.server:

Zend\XmlRpc\Server
==================

.. _zend.xmlrpc.server.introduction:

Введение
--------

``Zend\XmlRpc\Server`` задуман как полнофункциональный XML-RPC сервер,
следующий `спецификациям, приведенным на www.xmlrpc.com`_. Кроме того,
он реализует метод *system.multicall()*, позволяющий объединять
несколько запросов в один.

.. _zend.xmlrpc.server.usage:

Основы использования
--------------------

Простой пример использования:

.. code-block:: php
   :linenos:

   $server = new Zend\XmlRpc\Server();
   $server->setClass('My_Service_Class');
   echo $server->handle();

.. _zend.xmlrpc.server.structure:

Структура сервера
-----------------

``Zend\XmlRpc\Server`` состоит из множества компонент от собственно
сервера до объектов запросов, ответов и сообщений об ошибке.

Для загрузки ``Zend\XmlRpc\Server`` разработчик должен прикрепить
классы или функции к серверу через методы *setClass()* и *addFunction()*.

После этого можно передать объект ``Zend\XmlRpc\Request`` методу
*Zend\XmlRpc\Server::handle()*; если он не был передан, то будет
проинциализирован объект ``Zend\XmlRpc\Request\Http``, при этом данные
запроса берутся из *php://input*.

Затем *Zend\XmlRpc\Server::handle()* пытается определить подходящий
обработчик, основываясь на запрошенном методе. После этого он
возвращает объект ответа, основанный на ``Zend\XmlRpc\Response``, или
объект сообщения об ошибке ``Zend\XmlRpc\Server\Fault``. Эти объекты имеют
метод *__toString()*, который возвращает валидный XML-RPC ответ в
формате XML, что позволяет выводить эти объекты через *echo*.

.. _zend.xmlrpc.server.conventions:

Соглашения
----------

``Zend\XmlRpc\Server`` позволяет прикреплять функции и методы класса -
т.н. доступные для диспетчеризации XML-RPC методы. С помощью
``Zend\Server\Reflection`` он проводит интроспекцию по всем прикрепленным
методам, используя docblock'и функций и методов для установки
текста справки и сигнатур методов.

Не обязательно, чтобы типы в XML-RPC в точности соответствовали
типам в PHP. Тем не менее, для наилучшего результата код пытается
угадать наиболее подходящий тип, основываясь на значениях
дескрипторов @param и @return. Некоторые типы в XML-RPC не имеют
эквивалентов в PHP и должны указываться в PHPDoc. В их список
входят:

- dateTime.iso8601 - дата в формате YYYYMMDDTHH:mm:ss

- base64 - данные, закодированные по алгоритму base64

- struct - любой ассоциативный массив

Пример того, как указывается XML-RPC тип

.. code-block:: php
   :linenos:

   /**
   * Это пример функции
   *
   * @param base64 $val1 Закодированные в base64 данные
   * @param dateTime.iso8601 $val2 Дата в ISO-формате
   * @param struct $val3 Ассоциативный массив
   * @return struct
   */
   function myFunc($val1, $val2, $val3)
   {

PhpDocumentor не проводит валидацию типов, определенных для
параметров или возвращаемых значений, поэтому это не должно
влиять на вашу документацию по API. Указание типов необходимо,
если сервер проводит валидацию передаваемых методу
параметров.

Будет совершенно корректным с точки зрения синтаксиса
определять набор возможных типов как для параметров, так и для
возвращаемых значений; спецификация XML-RPC даже рекомендует,
чтобы system.methodSignature возвращал массив всех возможных сигнатур
метода (т.е. все возможные комбинации параметров и
возвращаемых значений). Вы можете делать это в точности так же,
как это обычно делается для PhpDocumentor - с использованием
оператора '\|':

.. code-block:: php
   :linenos:

   /**
   * Это пример функции
   *
   * @param string|base64 $val1 Строка или закодированные в base64 данные
   * @param string|dateTime.iso8601 $val2 Строка или дата в ISO-формате
   * @param array|struct $val3 Обычный нумерованный массив или ассоциативный массив
   * @return boolean|struct
   */
   function myFunc($val1, $val2, $val3)
   {
   }

Тем не менее, следует учесть, что обилие сигнатур может сбивать
с толку разработчиков, использующих данный веб-сервис. Другими
словами, следует стремится к тому, чтобы XML-RPC метод имел только
одну сигнатуру.

.. _zend.xmlrpc.server.namespaces:

Использование пространств имен
------------------------------

В XML-RPC есть такое понятие, как пространства имен. Они позволяют
группировать методы посредством разделенных точкой имен
пространств. Это позволяет предотвратить конфликты имен
методов, предоставляемых разными классами. Например, обычно
XML-RPC сервер предоставляет несколько методов в пространстве
имен 'system':

- system.listMethods

- system.methodHelp

- system.methodSignature

В нашем случае они соответствуют методам с теми же именами в
``Zend\XmlRpc\Server``.

Если необходимо добавить пространства имен для обслуживаемых
методов, то просто укажите пространство имен в качестве
параметра при вызове соответствующего метода для
прикрепления функции или класса:

.. code-block:: php
   :linenos:

   // Все открытые методы в My_Service_Class можно будет вызывать как
   // myservice.имя_метода
   $server->setClass('My_Service_Class', 'myservice');

   // Функцию 'somefunc' можно будет вызывать как funcs.somefunc
   $server->addFunction('somefunc', 'funcs');

.. _zend.xmlrpc.server.request:

Использование своих объектов запросов
-------------------------------------

В большинстве случаев вы можете использовать включенный по
умолчанию в ``Zend\XmlRpc\Server`` тип запроса – ``Zend\XmlRpc\Request\Http``. Тем не
менее, может потребоваться использование XML-RPC в окружениях CLI,
GUI и т.п., журналирование приходящих запросов. Для этого вы
можете создавать свои классы запросов, которые наследуют от
``Zend\XmlRpc\Request``. Важно помнить при этом, что методы *getMethod()* и
*getParams()* должны быть реализованы таким образом, чтобы XML-RPC
сервер мог получить из них ту информацию, которая необходима
для обработки запроса.

.. _zend.xmlrpc.server.response:

Использование своих объектов ответов
------------------------------------

Как и в случае объектов запросов, ``Zend\XmlRpc\Server`` может возвращать
объекты других типов; по умолчанию возвращается объект
``Zend\XmlRpc\Response\Http``, который отправляет соответствующий XML-RPC
заголовок *Content-Type*. Целью создания своих типов ответов могут
быть возможность журналирования ответов или отправки ответов
обратно в STDOUT.

Для того чтобы использовать свой класс ответа, вызывайте метод
*Zend\XmlRpc\Server::setResponseClass()* до вызова метода *handle()*.

.. _zend.xmlrpc.server.fault:

Обработка исключений через сообщения об ошибке
----------------------------------------------

``Zend\XmlRpc\Server`` отлавливает исключения, сгенерированные
вызываемым методом и генерирует ответ с сообщением об ошибке
сразу, как только исключение поймано. Однако по умолчанию
сообщение и код исключения не используются в ответе с
сообщением об ошибке. Это сделано намеренно для того, чтобы
защитить ваш код, т.к. многие исключения могут выдавать
информацию о коде приложения или среде выполнения, обычно
предназначенные разработчику.

Тем не менее, можно включать классы исключений в список
разрешенных к отображению в ответах с сообщением об ошибке.
Для этого используйте *Zend\XmlRpc\Server\Fault::attachFaultException()* для
включения данного класса исключения в список разрешенных.

.. code-block:: php
   :linenos:

   Zend\XmlRpc\Server\Fault::attachFaultException('My_Project_Exception');

Если вы используете класс исключения, от которого наследуют
другие исключения в проекте, то можете cразу включить все
"семейство" исключений в список разрешенных. Исключения
``Zend\XmlRpc\Server\Exception`` всегда находится в списке разрешенных
исключений для того, чтобы сообщать об отдельных внутренних
ошибках (вызов несуществующего метода и т.д.).

На любое исключение, не включенное в список разрешенных, будет
генерироваться ответ с кодом ошибки '404' и сообщением 'Unknown error'.

.. _zend.xmlrpc.server.caching:

Кэширование определений сервера между запросами
-----------------------------------------------

Прикрепление большого количества классов к экземпляру XML-RPC
сервера может отнимать много ресурсов – каждый класс должен
проверяться с использованием Reflection API (через ``Zend\Server\Reflection``),
который создает список всех возможных сигнатур методов для
передачи классу сервера.

Чтобы снизить ущерб производительности, можно использовать
``Zend\XmlRpc\Server\Cache`` для кэширования определений сервера между
запросами. Если комбинировать его с *__autoload()*, то это может дать
значительный прирост производительности.

Пример использования:

.. code-block:: php
   :linenos:

   function __autoload($class)
   {
       Zend\Loader\Loader::loadClass($class);
   }

   $cacheFile = dirname(__FILE__) . '/xmlrpc.cache';
   $server = new Zend\XmlRpc\Server();

   if (!Zend\XmlRpc\Server\Cache::get($cacheFile, $server)) {
       require_once 'My/Services/Glue.php';
       require_once 'My/Services/Paste.php';
       require_once 'My/Services/Tape.php';

       $server->setClass('My_Services_Glue', 'glue');   // пространство имен glue
       $server->setClass('My_Services_Paste', 'paste'); // пространство имен paste
       $server->setClass('My_Services_Tape', 'tape');   // пространство имен tape

       Zend\XmlRpc\Server\Cache::save($cacheFile, $server);
   }

   echo $server->handle();

В этом примере производится попытка получить определение
сервера из файла xmlrpc.cache, находящегося в той же директории, что
и скрипт. Если попытка не удалась, то загружаются нужные классы
и прикрепляются к экземпляру сервера, затем создается новый
файл кэша с определением сервера.

.. _zend.xmlrpc.server.use:

Примеры использования
---------------------

Здесь приведены несколько примеров использования,
демонстрирующих полный набор возможностей, доступных
разработчикам. Примеры построены на основе предоставленных
ранее примеров.

.. _zend.xmlrpc.server.use.case1:

Основы использования
^^^^^^^^^^^^^^^^^^^^

В примере ниже прикрепляется функция в качестве доступного
для диспетчеризации XML-RPC метода и обрабатываются входящие
вызовы.

.. code-block:: php
   :linenos:

   /**
    * Возвращает сумму MD5 переданного значения
    *
    * @param string $value Value to md5sum
    * @return string MD5 sum of value
    */
   function md5Value($value)
   {
       return md5($value);
   }

   $server = new Zend\XmlRpc\Server();
   $server->addFunction('md5Value');
   echo $server->handle();

.. _zend.xmlrpc.server.use.case2:

Прикрепление класса
^^^^^^^^^^^^^^^^^^^

Пример ниже иллюстрирует прикрепление открытых методов
класса в качестве доступных для диспетчеризации XML-RPC методов.

.. code-block:: php
   :linenos:

   require_once 'Services/Comb.php';

   $server = new Zend\XmlRpc\Server();
   $server->setClass('Services_Comb');
   echo $server->handle();

.. _zend.xmlrpc.server.use.case3:

Прикрепление нескольких классов с использованием пространств имен
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Пример ниже демонстрирует прикрепление нескольких классов,
каждый со своим пространством имен.

.. code-block:: php
   :linenos:

   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   $server = new Zend\XmlRpc\Server();
   $server->setClass('Services_Comb', 'comb');   // методы, вызываемые как comb.*
   $server->setClass('Services_Brush', 'brush'); // методы, вызываемые как brush.*
   $server->setClass('Services_Pick', 'pick');   // методы, вызываемые как pick.*
   echo $server->handle();

.. _zend.xmlrpc.server.use.case4:

Указание исключений в качестве используемых для ответов с сообщением об ошибке
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Пример ниже позволяет любым наследующим от *Services_Exception* классам
предоставлять свои коды и сообщения для подстановки в ответ с
сообщением об ошибке.

.. code-block:: php
   :linenos:

   require_once 'Services/Exception.php';
   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   // Allow Services_Exceptions to report as fault responses
   Zend\XmlRpc\Server\Fault::attachFaultException('Services_Exception');

   $server = new Zend\XmlRpc\Server();
   $server->setClass('Services_Comb', 'comb');   // методы, вызываемые как comb.*
   $server->setClass('Services_Brush', 'brush'); // методы, вызываемые как brush.*
   $server->setClass('Services_Pick', 'pick');   // методы, вызываемые как pick.*
   echo $server->handle();

.. _zend.xmlrpc.server.use.case5:

Использование своих объектов запроса
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

В примере ниже инстанцируется специальный объект запроса и
передается серверу для обработки.

.. code-block:: php
   :linenos:

   require_once 'Services/Request.php';
   require_once 'Services/Exception.php';
   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   // Включение Services_Exceptions в список разрешенных исключений
   Zend\XmlRpc\Server\Fault::attachFaultException('Services_Exception');

   $server = new Zend\XmlRpc\Server();
   $server->setClass('Services_Comb', 'comb');   // методы, вызываемые как comb.*
   $server->setClass('Services_Brush', 'brush'); // методы, вызываемые как brush.*
   $server->setClass('Services_Pick', 'pick');   // методы, вызываемые как pick.*

   // Создание объекта запроса
   $request = new Services_Request();

   echo $server->handle($request);

.. _zend.xmlrpc.server.use.case6:

Использование своих объектов ответа
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Пример ниже демонстрирует указание специального класса
ответа для возвращаемого ответа.

.. code-block:: php
   :linenos:

   require_once 'Services/Request.php';
   require_once 'Services/Response.php';
   require_once 'Services/Exception.php';
   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   // Включение Services_Exceptions в список разрешенных исключений
   Zend\XmlRpc\Server\Fault::attachFaultException('Services_Exception');

   $server = new Zend\XmlRpc\Server();
   $server->setClass('Services_Comb', 'comb');   // методы, вызываемые как comb.*
   $server->setClass('Services_Brush', 'brush'); // методы, вызываемые как brush.*
   $server->setClass('Services_Pick', 'pick');   // методы, вызываемые как pick.*

   // Создание объекта запроса
   $request = new Services_Request();

   // Установка другого класса ответа
   $server->setResponseClass('Services_Response');

   echo $server->handle($request);

.. _zend.xmlrpc.server.use.case7:

Кэширование определений сервера между запросами
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Пример ниже демонстрирует кэширование определений сервера
между запросами.

.. code-block:: php
   :linenos:

   // Указание файла кэша
   $cacheFile = dirname(__FILE__) . '/xmlrpc.cache';

   // Включение Services_Exceptions в список разрешенных исключений
   Zend\XmlRpc\Server\Fault::attachFaultException('Services_Exception');

   $server = new Zend\XmlRpc\Server();

   // Попытка получить определение сервера из кэша
   if (!Zend\XmlRpc\Server\Cache::get($cacheFile, $server)) {
       $server->setClass('Services_Comb', 'comb');   // методы, вызываемые как comb.*
       $server->setClass('Services_Brush', 'brush'); // методы, вызываемые как brush.*
       $server->setClass('Services_Pick', 'pick');   // методы, вызываемые как pick.*

       // Сохранение в кэш
       Zend\XmlRpc\Server\Cache::save($cacheFile, $server);
   }

   // Создание объекта запроса
   $request = new Services_Request();

   // Установка другого класса ответа
   $server->setResponseClass('Services_Response');

   echo $server->handle($request);



.. _`спецификациям, приведенным на www.xmlrpc.com`: http://www.xmlrpc.com/spec
