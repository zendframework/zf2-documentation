.. EN-Revision: none
.. _zend.session.advancedusage:

Расширенное использование
=========================

Хотя базовое использование является совершенно допустимым
вариантом использования сессий Zend Framework, стоит рассмотреть
другие возможности их использования. См. :ref:`пример на Zend_Auth
<zend.auth.introduction.using>`, который по умолчанию неявно использует
Zend\Session\Namespace для сохранения меток аутентификации. Этот пример
показывает один из способов быстрой и легкой интеграции
Zend\Session\Namespace и Zend_Auth.

.. _zend.session.startingasession:

Старт сессии
------------

Если вы хотите, чтобы все запросы имели сессии и использовали
сессии Zend Framework, то стартуйте сессию в файле загрузки:

.. rubric:: Старт общей сессии

.. code-block:: php
   :linenos:

   <?php
   ...
   require_once 'Zend/Session.php';
   Zend\Session\Session::start();
   ...
   ?>
Стартуя сессию в файле загрузки, вы исключаете вероятность
того, что старт сессии произойдет после того, как заголовки
будут отправлены броузеру, что вызвовет исключение и,
возможно, отображение испорченной страницы посетителю сайта.
Некоторые расширенные возможности Zend_Session требуют вызова
*Zend\Session\Core::start()* в начале (больше о расширенных возможностях
будет написано позднее).

Есть четыре способа стартовать сессию, используя Zend_Session. Два
из них - неправильные.

- 1. Неправильно: Устанавливать опцию session.auto_start в php.ini или .htaccess
  (http://www.php.net/manual/en/ref.session.php#ini.session.auto-start). Если вы не имеете
  возможность отключить эту опцию в php.ini, то, если используется
  mod_php (или его эквивалент) и в php.ini уже установлена эта опция,
  добавьте строку *php_value session.auto_start 0* в ваш файл .htaccess (обычно
  находится в корневой директории для HTML-документов).

- 2. Неправильно: Непосредственно использовать функцию
  `session_start()`_. Если вы вызываете *session_start()* напрямую и начинаете
  использование Zend\Session\Namespace, то при вызове метода *Zend\Session\Session::start()*
  будет сгенерировано исключение ("session has already been started"). Если вы
  вызываете *session_start()* после использования Zend\Session\Namespace или
  явного вызова *Zend\Session\Session::start()*, то будет сгенерирована ошибка
  уровня E_NOTICE и проигнорирован вызов функции.

- 3. Правильно: Используйте *Zend\Session\Session::start()*. Если необходимо, чтобы
  все запросы имели и использовали сессии, то поместите вызов
  этой функции в коде загрузки близко к точке входа и без
  условной логики. При этом присутствуют некоторые издержки за
  счет сессий. Если для одних запросов нужны сессии, а для
  других - нет, то:

  - Установите опцию *strict* в true (см. :ref:`Zend\Session\Session::setOptions()
    <zend.session.startingasession>`) в коде загрузки.

  - Вызывайте *Zend\Session\Session::start()* только при тех запросах, для которых
    нужны сессии, и до того, как будет произведен первый вызов *new
    Zend\Session\Namespace()*.

  - Используйте *new Zend\Session\Namespace()* как обычно и там, где это нужно,
    но при этом необходимо убедиться, что *Zend\Session\Session::start()* был
    вызван ранее.

  Опция *strict* предотвращает автоматический старт сессии с
  использованием *Zend\Session\Session::start()* при вызове *new Zend\Session\Namespace()*. Эта
  опция помогает разработчикам пользовательских областей
  приложений ZF следовать принятому при проектировании решению
  не использовать сессии для определенных запросов, т.к. при
  установке этой опции и последующем инстанцировании
  Zend\Session\Namespace до явного вызова *Zend\Session\Session::start()* будет
  сгенерировано исключение. Не используйте эту опцию в коде
  библиотек ZF, поскольку проектные решения должны принимать
  только разработчики пользовательской области. Аналогичным
  образом, все разработчики "библиотек" должны осторожно
  подходить к использованию *Zend\Session\Session::setOptions()* в коде их
  библиотек, поскольку эти опции имеют глобальную область
  действия (как и лежащие в основе опции расширения ext/session).

- 4. Правильно: Просто используйте *new Zend\Session\Namespace()* где
  необходимо, и сессия будет автоматически запущена в Zend_Session.
  Это наиболее простой вариант использования, подходящий для
  большинства случаев. Но необходимо будет следить за тем,
  чтобы первый вызов *new Zend\Session\Namespace()()* всегда происходил **до
  того**, как выходные данные будут отправлены клиенту (т.е. до
  того, как агенту пользователя будут отправлены HTTP-заголовки),
  если используются основанные на куках сессии (очень
  рекомендуется). Использование `буферизации вывода`_ может
  быть удачным решением, при этом может быть улучшена
  производительность. Например, в *php.ini*"*output_buffering = 65535*" включает
  буферизацию вывода с размером буфера 64K.

.. _zend.session.locking:

Блокировка пространств имен
---------------------------

Можно применять блокировку к пространствам имен для
предотвращения изменения данных в этом пространстве имен.
Используйте метод *Zend\Session\Namespace::lock()* для того, чтобы сделать
определенное пространство имен доступным только для чтения,
*unLock()*- чтобы сделать пространство имен доступным для чтения и
изменений, а *isLocked()* для проверки того, не было ли пространство
имен заблокировано ранее. Блокировка не сохраняется от одного
запроса к другому. Блокировка пространства имен не действует
на методы установки (setter methods) в объектах, сохраненных в
пространстве имен, но предотвращает использование методов
установки пространства имен сессии для удаления или замены
объектов, сохраненных непосредственно в пространстве имен.
Также блокирование пространств имен Zend\Session\Namespace не
препятствует использованию ссылок на те же данные (см. `PHP
references`_).

.. rubric:: Блокировка пространств имен

.. code-block:: php
   :linenos:

   <?php
       // assuming:
       $userProfileNamespace = new Zend\Session\Namespace('userProfileNamespace');

       // marking session as read only locked
       $userProfileNamespace->lock();

       // unlocking read-only lock
       if ($userProfileNamespace->isLocked()) {
           $userProfileNamespace->unLock();
       }
   ?>
Есть некоторые идеи по поводу того, как организовывать модели
в парадигме MVC для Веб, включая создание моделей представления
для использования видами (views). Иногда имеющиеся данные,
являются ли они частью вашей доменной модели или нет, являются
подходящими для этой задачи. Для того, чтобы предотвратить
изменение таких данных, используйте блокировку пространств
имен сессий до того, как предоставить видам доступ к этим
подмножествам вашей модели представления.

.. rubric:: Блокировка сессий в видах

.. code-block:: php
   :linenos:

   <?php
   class FooModule_View extends Zend_View
   {
       public function show($name)
       {
           if (!isset($this->mySessionNamespace)) {
               $this->mySessionNamespace = Zend::registry('FooModule');
           }

           if ($this->mySessionNamespace->isLocked()) {
               return parent::render($name);
           }

           $this->mySessionNamespace->lock();
           $return = parent::render($name);
           $this->mySessionNamespace->unLock();

           return $return;
       }
   }
   ?>
.. _zend.session.expiration:

Время жизни пространства имен
-----------------------------

Время жизни может быть ограничено как у пространства имен в
целом, так и у отдельных ключей. Общие случаи использования
включают в себя передачу временной информации между запросами
и повышение защищенности от определенных угроз безопасности
посредством устранения доступа к потенциально чувствительной
информации по прошествии некоторого времени после
аутентификации. Истечение времени жизни может быть основано
на количестве секунд или на концепции "прыжков" (hops), в которой
"прыжком" считается каждый успешный запрос, в котором
активируется пространство имен через, как минимум, один ``$space =
new Zend\Session\Namespace('myspace');``.

.. rubric:: Примеры установки времени жизни

.. code-block:: php
   :linenos:

   <?php
   $s = new Zend\Session\Namespace('expireAll');
   $s->a = 'apple';
   $s->p = 'pear';
   $s->o = 'orange';

   // Время жизни установлено только для ключа "a" (5 секунд)
   $s->setExpirationSeconds(5, 'a');

   // Время жизни всего пространства имен - 5 "прыжков"
   $s->setExpirationHops(5);

   $s->setExpirationSeconds(60);
   // Пространство имен "expireAll" будет помечено как с истекшим временем жизни
   // при первом запросе, произведенном после того, как прошло 60 секунд,
   // или после 5 "прыжков" - в зависимости от того, что произошло раньше
   ?>
При работе с данными, время жизни которых истекает в текущем
запросе, будьте внимательны при их извлечении. Несмотря на то,
что данные возвращаются по ссылке, изменение этих данных не
приведет к их сохранению после текущего запроса. Для "сброса"
времени истечения извлеките данные во временные переменные,
уничтожьте эти данные в пространстве имен и затем установите
соответствующий ключ снова.

.. _zend.session.controllers:

Инкапсуляция сессий и контроллеры
---------------------------------

Пространства имен могут также использоваться для разделения
доступа контроллеров к сессиям, чтобы защитить переменные от
повреждения. Например, контроллер 'Zend_Auth' может хранить свои
постоянные данные сессии отдельно от всех остальных
контроллеров.

.. rubric:: Сессии с пространствами имен для контроллеров с автоматическим истечением времени

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Session.php';
   // контроллер для вывода вопроса
   $testSpace = new Zend\Session\Namespace('testSpace');
   // установка времени жизни только для этой переменной
   $testSpace->setExpirationSeconds(300, "accept_answer");
   $testSpace->accept_answer = true;

   --

   // контроллер для обработки ответа на вопрос
   $testSpace = new Zend\Session\Namespace('testSpace');

   if ($testSpace->accept_answer === true) {
       // время не истекло
   }
   else {
       // время истекло
   }
   ?>
.. _zend.session.limitinginstances:

Ограничение количества экземпляров Zend\Session\Namespace до одного на каждое пространство имен
-----------------------------------------------------------------------------------------------

Мы рекомендуем использовать блокировку сессии (см. выше)
вместо этой функциональной возможности, которая накладывает
дополнительное бремя на разработчика, состоящее в передаче
экземпляров Zend\Session\Namespace во все функции и объекты, нуждающихся
в использовании этих пространств имен.

Когда создается первый экземпляр Zend\Session\Namespace, связанный с
определенным пространством имен, вы можете дать команду
Zend\Session\Namespace больше не создавать объекты для этого
пространства имен. Таким образом, в дальнейшем попытка создать
экземпляр Zend\Session\Namespace для того же пространства имен вызовет
генерацию исключения. Это поведение является опциональным и
не принято по умолчанию, но остается доступным для тех, кто
предпочитает передавать по коду единственный объект для
каждого пространства имен. Это повышает защиту пространства
имен от изменений компонентами, которые не должны делать
этого, поскольку тогда они не будут иметь свободного доступа к
пространствам имен. Тем не менее, ограничение пространства
имен до одного экземпляра модет привести к большему объему
кода или к его усложнению, поскольку он отменяет возможность
использования директив вида ``$aNamespace = new Zend\Session\Namespace('aNamespace');``
после того, как был создан первый экземпляр. Это
продемонстрировано в примере ниже:

.. rubric:: Ограничение до единичных экземпляров

.. code-block:: php
   :linenos:

   <?php
       require_once 'Zend/Session.php';
       $authSpaceAccessor1 = new Zend\Session\Namespace('Zend_Auth');
       $authSpaceAccessor2 = new Zend\Session\Namespace('Zend_Auth', Zend\Session\Namespace::SINGLE_INSTANCE);
       $authSpaceAccessor1->foo = 'bar';
       assert($authSpaceAccessor2->foo, 'bar');
       doSomething($options, $authSpaceAccessor2);
       .
       .
       .
       $aNamespaceObject = new Zend\Session\Namespace('Zend_Auth'); // это вызовет ошибку
   ?>
Второй параметр в конструкторе выше говорит Zend_Session, что в
будущем создание любых других экземпляров Zend\Session\Namespace с
пространством имен 'Zend_Auth' не допустимо. Поскольку директиву *new
Zend\Session\Namespace('Zend_Auth')* нельзя использовать после того, как будет
выполнен приведенный выше код, то разработчику нужно будет
где-либо сохранять объект (``$authSpaceAccessor2`` в примере выше), если в
дальнейшем при обработке того же запроса необходим доступ к
этому пространству имен сессии. Например, вы можете сохранять
экземпляр в статической переменной или передавать его другим
методам, которым нужен доступ к данному пространству имен.

.. _zend.session.modifyingarray:

Работа с массивами в пространствах имен
---------------------------------------

Изменение массива внутри пространства имен невозможно.
Простейшим решением является сохранение массивов после того,
как все желаемые значения были установлены. `ZF-800`_ подтверждает
известный баг, затрагивающий многие PHP-приложения,
использующие "магические" методы и массивы.

.. rubric:: Известные проблемы с массивами

.. code-block:: php
   :linenos:

   <?php
       $sessionNamespace = new Zend\Session\Namespace('Foo');
       $sessionNamespace->array = array();
       $sessionNamespace->array['testKey'] = 1; // Не работает в версиях ниже PHP 5.2.1
   ?>
Если вам нужно изменить массив после того, как добавили его в
пространство имен, извлеките массив, произведите необходимые
изменения и сохраните его под тем же ключом в пространстве
имен.

.. rubric:: Обходной путь: извлечение, изменение и сохранение

.. code-block:: php
   :linenos:

   <?php
       $sessionNamespace = new Zend\Session\Namespace('Foo');
       $sessionNamespace->array = array('tree' => 'apple');
       $tmp = $sessionNamespace->array;
       $tmp['fruit'] = 'peach';
       $sessionNamespace->array = $tmp;
   ?>
Можно также сохранить массив, содержащий ссылку на желаемый
массив и косвенно работать с ним.

.. rubric:: Обходной путь: сохранение массива, содержащего ссылку

.. code-block:: php
   :linenos:

   <?php
       $myNamespace = new Zend\Session\Namespace('mySpace');

       // работает даже с версиями PHP, содержащими баг
       $a = array(1,2,3);
       $myNamespace->someArray = array( & $a ) ;
       $a['foo'] = 'bar';
   ?>
.. _zend.session.auth:

Использование сессий вместе с аутентификацией
---------------------------------------------

Если ваш адаптер аутентификации для *Zend_Auth* возвращает
результат, в котором идетификатором авторизации является
объект (не рекомендуется) вместо массива, то выполняйте
проверку класса идентификатора авторизации до того, как
стартовать сессию. Вместо этого мы рекомендуем хранить
идентификаторы авторизации, вычисленные в адаптере
авторизации, под хорошо известным ключом в пространстве имен
сессии. Например, по умолчанию *Zend_Auth* размещает идентификаторы
под ключом 'storage' пространства имен 'Zend_Auth'.

Если вы приказали *Zend_Auth* не сохранять метку сессии в сессиях,
то можете вручную сохранять ID авторизации под хорошо
известным ключом в любом пространстве имен сессии. Часто
приложения имеют свои требования к тому, где хранить "мандат"
(учетная запись с праметрами доступа пользователя) и
идентификатор авторизации. Приложения часто устанавливают
соответствие идентификаторов аутентификации (например, имена
пользователей) и идентификаторов авторизации (например,
присвоенное уникальное целое число) во время аутентификации,
которая должна производится внутри метода *authenticate()* адаптера
аутентификации Zend_Auth.

.. rubric:: Пример: Простой доступ к ID авторизации

.. code-block:: php
   :linenos:

   <?php
       // pre-authentication request
       require_once 'Zend/Auth/Adapter/Digest.php';
       $adapter = new Zend\Auth_Adapter\Digest($filename, $realm, $username, $password);
       $result = $adapter->authenticate();
       require_once 'Zend/Session/Namespace.php';
       $namespace = new Zend\Session\Namespace('Zend_Auth');
       if ($result->isValid()) {
           $namespace->authorizationId = $result->getIdentity();
           $namespace->date = time();
       } else {
           $namespace->attempts++;
       }

       // subsequent requests
       require_once 'Zend/Session.php';
       Zend\Session\Session::start();
       $namespace = new Zend\Session\Namespace('Zend_Auth');

       echo "Valid: ", (empty($namespace->authorizationId) ? 'No' : 'Yes'), "\n"';
       echo "Authorization / user Id: ", (empty($namespace->authorizationId)
           ? 'none' : print_r($namespace->authorizationId, true)), "\n"';
       echo "Authentication attempts: ", (empty($namespace->attempts)
           ? '0' : $namespace->attempts), "\n"';
       echo "Authenticated on: ",
           (empty($namespace->date) ? 'No' : date(DATE_ATOM, $namespace->date), "\n"';
   ?>
Идентификаторы авторизации, хранящиеся на клиентской стороне,
могут использоваться в атаках на поднятие привилегий, если им
доверяет серверная сторона и если они, например, не
дублируются на серверной стороне (например, в данных сессии) и
затем сверяются с идентификатором авторизации,
предоставленным клентом для действующией сессии. Мы различаем
понятия "идентификаторов аутентификации" (например, имена
пользователей) и "идентификаторов авторизации" (например, ID
пользователя #101 в таблице БД для пользователей).

Последнее часто используется для повышения
производительности - например, для выборки из пула серверов,
кеширующих данные сессии, чтобы решить проблему "курицы и
яйца". Часто возникают дебаты о том, использовать ли настоящий
ID авторизации в куках или некую замену, которая помогает
установить соответствие с настоящим ID авторизации (или сессии
сервера(ов), хранящего сессию/профиль пользователя и т.д.), в то
время как некоторые архитекторы системной безопасности
предпочитают избегать публикования истинных значений
первичных ключей, пытаясь достичь некоторого дополнительного
уровня защиты в случае наличия уязвимостей к SQL-инъекциям.

.. _zend.session.testing:

Использование сессий с юнит-тестами
-----------------------------------

Zend Framework использует PHPUnit для своего тестирования. Многие
разработчики расширяют существующие наборы юнит-тестов для
покрытия кода в своих приложениях. Если при выполнении
юнит-тестирований после завершения сессии были использованы
любые связанные с записью методы, то генерируется исключение
"**Zend_Session is currently marked as read-only**" ("Zend_Session помечен как доступный
только для чтения"). Тем не менее, юнит-тесты, использующие
Zend_Session, требуют особого внимания в разработке, поскольку
закрытие (*Zend\Session\Session::writeClose()*) или уничтожение сессии
(*Zend\Session\Session::destroy()*) не дает впоследствии устанавливать или
сбрасывать ключи в любом объекте Zend\Session\Namespace. Это поведение
является прямым следствием использования лежащего в основе
расширения ext/session, функций *session_destroy()* и *session_write_close()*, которые
не имеют механизма "отмены" для облегчения установки/демонтажа
в юнит-тестировании.

Чтобы обойти это, см. юнит-тест *testSetExpirationSeconds()* в
*tests/Zend/Session/SessionTest.php* и *SessionTestHelper.php*, которые используют *exec()*
для запуска отдельного процесса. Новый процесс более точно
имитирует второй, последующий, запрос из броузера. Отдельный
процесс начинается с "чистой" сессии, так же, как при выполнении
любого PHP-скрипта для веб-запроса. Кроме этого, любые изменения
в ``$_SESSION[]``, произведенные при вызове процесса, становятся
доступными и в дочернем процессе, что дает родительскому
процессу возможность закрыть сессию до использования *exec()*.

.. rubric:: Использование PHPUnit для тестирования кода, написанного с использованием Zend_Session*

.. code-block:: php
   :linenos:

   <?php
           // testing setExpirationSeconds()
           require 'tests/Zend/Session/SessionTestHelper.php'; // also see SessionTest.php in trunk/
           $script = 'SessionTestHelper.php';
           $s = new Zend\Session\Namespace('space');
           $s->a = 'apple';
           $s->o = 'orange';
           $s->setExpirationSeconds(5);

           Zend\Session\Session::regenerateId();
           $id = Zend\Session\Session::getId();
           session_write_close(); // release session so process below can use it
           sleep(4); // not long enough for things to expire
           exec($script . "expireAll $id expireAll", $result);
           $result = $this->sortResult($result);
           $expect = ';a === apple;o === orange;p === pear';
           $this->assertTrue($result === $expect,
               "iteration over default Zend_Session namespace failed; expecting result === '$expect', but got '$result'");

           sleep(2); // long enough for things to expire (total of 6 seconds waiting, but expires in 5)
           exec($script . "expireAll $id expireAll", $result);
           $result = array_pop($result);
           $this->assertTrue($result === '',
               "iteration over default Zend_Session namespace failed; expecting result === '', but got '$result')");
           session_start(); // resume artificially suspended session

           // We could split this into a separate test, but actually, if anything leftover from above
           // contaminates the tests below, that is also a bug that we want to know about.
           $s = new Zend\Session\Namespace('expireGuava');
           $s->setExpirationSeconds(5, 'g'); // now try to expire only 1 of the keys in the namespace
           $s->g = 'guava';
           $s->p = 'peach';
           $s->p = 'plum';

           session_write_close(); // release session so process below can use it
           sleep(6); // not long enough for things to expire
           exec($script . "expireAll $id expireGuava", $result);
           $result = $this->sortResult($result);
           session_start(); // resume artificially suspended session
           $this->assertTrue($result === ';p === plum',
               "iteration over named Zend_Session namespace failed (result=$result)");
   ?>


.. _`session_start()`: http://www.php.net/session_start
.. _`буферизации вывода`: http://php.net/outcontrol
.. _`PHP references`: http://www.php.net/references
.. _`ZF-800`: http://framework.zend.com/issues/browse/ZF-800
