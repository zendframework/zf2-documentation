.. EN-Revision: none
.. _zend.form.quickstart:

Zend_Form - Быстрый старт
=========================

Данное руководство охватывает основы создания форм, проверки
корректности данных и визуализиции с использованием *Zend_Form*.

.. _zend.form.quickstart.create:

Создание объекта формы
----------------------

Объекты форм создаются через простое инстанцирование *Zend_Form*:

.. code-block:: php
   :linenos:

   $form = new Zend_Form;


Для более сложных случаев использования вы можете создавать
подклассы *Zend_Form*, но простые формы вы можете создавать,
используя объект *Zend_Form*.

Если вы хотите указать атрибуты *action* и *method* (что во всех
случаях является хорошей идеей), то можете сделать это с
использованием аксессоров *setAction()* и *setMethod()*:

.. code-block:: php
   :linenos:

   $form->setAction('/resource/process')
        ->setMethod('post');


Приведенный выше код устанавливает значение атрибута *action*
равным "/resource/process" и указывает способ отправки данных - HTTP POST.
Эти атрибуты будут выведены после окончательного рендеринга
формы.

Вы можете установить дополнительные HTML-атрибуты для тега *<form>*,
используя методы *setAttrib()* и *setAttribs()*. Например, если нужно
установить идентификатор элемента формы, то установите
атрибут "id":

.. code-block:: php
   :linenos:

   $form->setAttrib('id', 'login');


.. _zend.form.quickstart.elements:

Добавление элементов в форму
----------------------------

Форма без элементов бесмысленна. *Zend_Form* поставляется с
некоторым начальным набором элементов, которые отвечают за
рендеринг XHTML-кода с использованием помощников *Zend_View*. В этот
список входят элементы:

- button (кнопка)

- checkbox (флажок опций, или несколько флажков опций через multiCheckbox)

- hidden (спрятанное поле)

- image (изображение)

- password (пароль)

- radio (переключатель)

- reset (кнопка сброса)

- select (выпадающий список - как обычный, так multi-select)

- submit (кнопка отправки)

- text (текстовое поле)

- textarea (текстовая область)

Есть два способа добавления элементов в форму - вы можете
инстанцировать нужные элементы и передавать их объекту формы,
или передавать только тип элемента, в этом случае *Zend_Form*
инстанцирует соответствующий объект за вас.

Некоторые примеры:

.. code-block:: php
   :linenos:

   // Инстанцирование элемента и его передача объекту формы:
   $form->addElement(new Zend\Form_Element\Text('username'));

   // Передача типа элемента объекту формы
   $form->addElement('text', 'username');


По умолчанию элементы не имеют никаких валидаторов или
фильтров. Это означает, что вам нужно установить к своим
элементам, как минимум, валидаторы, и, возможно, фильтры. Вы
можете делать это (a) до передачи элементов в форму, (b) через
опции конфигурирования, которые передаются при создании
элемента через *Zend_Form*, или (с) путем извлечения элементов формы
из объекта формы и их конфигурирования.

Сначала рассмотрим создание валидаторов для конкретного
объекта элемента. Вы можете передавать объекты *Zend\Validate\** или
имена валидаторов:

.. code-block:: php
   :linenos:

   $username = new Zend\Form_Element\Text('username');

   // Передача объекта Zend\Validate\*:
   $username->addValidator(new Zend\Validate\Alnum());

   // Передача имени валидатора:
   $username->addValidator('alnum');

В случае использования второго варианта, если валидатор
принимает аргументы конструктора, то вы можете передавать их
через массив как третий параметр:

.. code-block:: php
   :linenos:

   // Передача шаблона
   $username->addValidator('regex', false, array('/^[a-z]/i'));


(Второй параметр используется для указания того, должен ли
валидатор в том случае, если данные не прошли проверку,
прерывать дальнейшую проверку в цепочке валидаторов; по
умолчанию он равен false.)

Вы можете также указать элемент как обязательный для
заполнения. Это может быть сделано как с помощью аксессора, так
и путем передачи определенной опции при создании элемента. В
первом случае:

.. code-block:: php
   :linenos:

   // Указание того, что элемент обязателен для заполнения:
   $username->setRequired(true);


Если элемент обязателен для заполнения, то в начало цепочки
валидаторов добавляется валидатор 'NotEmpty', который проверяет,
имеет ли элемент значение.

Фильтры регистрируются в основном так же, как и валидаторы. Для
демонстрации добавим фильтр для приведения значения к нижнему
регистру:

.. code-block:: php
   :linenos:

   $username->addFilter('StringToLower');


Таким образом, окончательно установка элемента получится
такой, как показано ниже:

.. code-block:: php
   :linenos:

   $username->addValidator('alnum')
            ->addValidator('regex', false, array('/^[a-z]/'))
            ->setRequired(true)
            ->addFilter('StringToLower');

   // или в более компактной форме:
   $username->addValidators(array('alnum',
           array('regex', false, '/^[a-z]/i')
       ))
       ->setRequired(true)
       ->addFilters(array('StringToLower'));


Выполнение этих действий для каждого элемента по отдельности
может показаться несколько утомительным. Попробуем вариант (b)
из перечисленных выше. Когда мы создаем новый элемент,
используя *Zend\Form\Form::addElement()* в качестве фабрики, то можем
опционально передавать опции конфигурирования. Они могут
включать в себя валидаторы и фильтры для использования. Таким
образом, чтобы неявным образом сделать все это, попробуйте
следующее:

.. code-block:: php
   :linenos:

   $form->addElement('text', 'username', array(
       'validators' => array(
           'alnum',
           array('regex', false, '/^[a-z]/i')
       ),
       'required' => true,
       'filters'  => array('StringToLower'),
   ));


.. note::

   Если вы обнаружили, что настраиваете элементы, используя
   одни и те же опции во многих местах, то можете создать
   подкласс *Zend\Form\Element* и использовать его вместо выполнения
   этих процедур; это может избавить от лишней работы по набору
   кода.

.. _zend.form.quickstart.render:

Визуализация формы
------------------

Визуализация формы производится легко. Большинство элементов
использует помощника *Zend_View* для генерации вывода и поэтому
нуждаются в объекте вида для выполнения рендеринга. Есть два
способа запустить рендеринг: использовать метод формы render()
или просто вывести форму с помощью echo.

.. code-block:: php
   :linenos:

   // Явный вызов render() с передачей объекта вида:
   echo $form->render($view);

   // Предполагается, что объект вида уже был установлен ранее через setView():
   echo $form;


По умолчанию *Zend_Form* будет пытаться использовать объект вида,
инициализированный в *ViewRenderer*, это означает, что вам не нужно
будет вручную устанавливать объект вида при использовании MVC
Zend Framework-а. Код для визуализации формы в скрипте вида весьма
прост:

.. code-block:: php
   :linenos:

   <?php echo $this->form ?>


Внутри себя *Zend_Form* использует "декораторы" для выполнения
визуализации. Эти декораторы могут замещать содержимое
переданного элемента, производить добавления в его начало и
конец, производить наблюдение за ним. В результате вы можете
комбинировать несколько декораторов для достижения нужного
эффекта. По умолчанию в *Zend\Form\Element* используется четыре
декоратора для получения нужного вывода; их установка
выглядит приблизительно так:

.. code-block:: php
   :linenos:

   $element->addDecorators(array(
       'ViewHelper',
       'Errors',
       array('HtmlTag', array('tag' => 'dd')),
       array('Label', array('tag' => 'dt')),
   ));


Код выше создает вывод наподобие следующего:

.. code-block:: html
   :linenos:

   <dt><label for="username" class="required">Username</dt>
   <dd>
       <input type="text" name="username" value="123-abc" />
       <ul class="errors">
           <li>'123-abc' has not only alphabetic and digit characters</li>
           <li>'123-abc' does not match against pattern '/^[a-z]/i'</li>
       </ul>
   </dd>


Вы можете изменить набор декораторов, используемый элементом,
если хотите иметь другой результат вывода; более подробную
информацию читайте в разделе о декораторах.

Форма сама по себе просто производит обход содержащегося в ней
списка элементов и окружает получившийся вывод тегами *<form>*.
Переданные вами *action* и *method* устанавливаются в качестве
атрибутов тега *<form>*- так же, как и остальные атрибуты,
установленные через семейство методов *setAttribs()*.

Элементы обходятся в том же порядке, в котором они были
зарегистрированы, но если ваш элемент содержит атрибут order, то
он используется для сортировки. Вы можете установить порядок
элемента, используя:

.. code-block:: php
   :linenos:

   $element->setOrder(10);


Или путем передачи в качестве опции при создании элемента:

.. code-block:: php
   :linenos:

   $form->addElement('text', 'username', array('order' => 10));


.. _zend.form.quickstart.validate:

Проверка корректности данных формы
----------------------------------

После того, как получены данные формы, нужно их проверить и
выяснить, правильно ли заполнена форма. Для всех элементов
производится проверка переданных данных на наличие ключа,
соответствующего имени элемента. Если этот ключ не найден, и
элемент при этом помечен как обязательный, то для проверки на
корректность используется значение null.

Откуда идут данные? Вы можете использовать ``$_POST``, ``$_GET``, и любые
другие источники данных (например, запросы веб-сервисов):

.. code-block:: php
   :linenos:

   if ($form->isValid($_POST)) {
       // успех
   } else {
       // неудача
   }


Вам может прийти в голову идея проверять данные одного
элемента или группы элементов с помощью AJAX-запросов. Метод
*isValidPartial()* будет проверять на корректность данные части формы.
Его отличие от *isValid()* состоит в том, что если в данных формы
отсутствует какой-либо ключ, то для этого элемента не будут
производиться проверки на корректность заполнения:

.. code-block:: php
   :linenos:

   if ($form->isValidPartial($_POST)) {
       // все предоставленные элементы прошли все проверки на корректность
   } else {
       // один или более элементов не прошли проверку на корректность
   }


Для проверки части формы может также использоваться метод
*processAjax()*. В отличие от *isValidPartial()*, в случае неуспеха он
возвращает строку в формате JSON, содержащую сообщения об
ошибках заполнения.

Если проверка на корректность заполнения была пройдена
успешно, то вы можете извлечь прошедшие фильтрацию данные:

.. code-block:: php
   :linenos:

   $values = $form->getValues();


Для того, чтобы извлечь нефильтрованные данные, используйте:

.. code-block:: php
   :linenos:

   $unfiltered = $form->getUnfilteredValues();


.. _zend.form.quickstart.errorstatus:

Получение статуса ошибки
------------------------

А что в том случае, если форма не прошла проверку на
корректность? Как правило, вы можете просто вывести ее снова, и
сообщения об ошибках будут отображены, если вы используете
декораторы по умолчанию:

.. code-block:: php
   :linenos:

   if (!$form->isValid($_POST)) {
       echo $form;

       // или присвойте ее объекту вида и произведите его рендеринг...
       $this->view->form = $form;
       return $this->render('form');
   }


Если нужно проанализировать ошибки, то есть два способа их
получения. *getErrors()* возвращает ассоциативный массив имен
элементов и кодов ошибок (где коды ошибок представлены в виде
массива). *getMessages()* возвращает ассоциативный массив имен
элементов и сообщений об ошибках (где сообщения об ошибках
представлены в виде ассоциативного массива пар 'код
ошибки'/'сообщение об ошибке'). Если элемент не имеет ошибок, то
он не будет включен в массив.

.. _zend.form.quickstart.puttingtogether:

Объединяя изложенное
--------------------

Давайте создадим простую форму для входа на сайт. Для нее будут
нужны следующие элементы:

- username

- password

- submit

Для примера предположим, что корректное имя пользователя
должно содержать только буквенно-цифровые символы, начинаться
с буквы, иметь длину не меньше 6 и не больше 20 символов, кроме
этого, имена пользователей должны быть приведены к нижнему
регистру. Пароль должен содержать как минимум 6 символов.
Переданное значение кнопки использоваться не будет, поэтому
проверка для нее может не производиться.

Мы используем мощь конфигурационных опций *Zend_Form* для
построения формы:

.. code-block:: php
   :linenos:

   $form = new Zend\Form\Form();
   $form->setAction('/user/login')
        ->setMethod('post');

   // Создание и конфигурирование элемента username
   $username = $form->createElement('text', 'username');
   $username->addValidator('alnum')
            ->addValidator('regex', false, array('/^[a-z]+/'))
            ->addValidator('stringLength', false, array(6, 20))
            ->setRequired(true)
            ->addFilter('StringToLower');

   // Создание и конфигурирование элемента password
   $password = $form->createElement('password', 'password');
   $password->addValidator('StringLength', false, array(6))
            ->setRequired(true);

   // Добавление элементов в форму:
   $form->addElement($username)
        ->addElement($password)
        // addElement() используется в качестве "фабрики"
        // для создания кнопки 'Login':
        ->addElement('submit', 'login', array('label' => 'Login'));


Затем создается контроллер для отображения формы и ее
обработки:

.. code-block:: php
   :linenos:

   class UserController extends Zend\Controller\Action
   {
       public function getForm()
       {
           // здесь должен быть код для создания формы, приведенный выше
           return $form;
       }

       public function indexAction()
       {
           // рендеринг user/form.phtml
           $this->view->form = $this->getForm();
           $this->render('form');
       }

       public function loginAction()
       {
           if (!$this->getRequest()->isPost()) {
               return $this->_forward('index');
           }
           $form = $this->getForm();
           if (!$form->isValid($_POST)) {
               // проверка на корректность не пройдена, выводим форму снова
               $this->form = $form;
               return $this->render('form');
           }

           $values = $form->getValues();
           // аутентификация...
       }
   }


...и скрипт вида для отображения формы:

.. code-block:: php
   :linenos:

   <h2>Please login:</h2>
   <?= $this->form ?>


Как вы наверное заметили, код контроллера не является полным -
после успешно проведенной проверки должна производиться
авторизация пользователя (например, используя *Zend_Auth*).

.. _zend.form.quickstart.config:

Использование объекта Zend_Config
---------------------------------

Все классы *Zend_Form* можно конфигурировать, используя *Zend_Config*. Вы
можете передавать объект *Zend_Config* либо конструктору, либо через
метод *setConfig()*. Посмотрим, как можно создать описанную выше
форму, используя файл INI. Во-первых, будем следовать
рекомендации размещать конфигурации в разделах, отражающих
местонахождение релиза, и сфокусируемся на разделе 'development'.
Во-вторых, установим раздел для данного контроллера ('user') и
ключ для формы ('login'):

.. code-block:: ini
   :linenos:

   [development]
   ; общие метаданные для формы
   user.login.action = "/user/login"
   user.login.method = "post"

   ; элемент username
   user.login.elements.username.type = "text"
   user.login.elements.username.options.validators.alnum.validator = "alnum"
   user.login.elements.username.options.validators.regex.validator = "regex"
   user.login.elements.username.options.validators.regex.options.pattern = "/^[a-z]/i"
   user.login.elements.username.options.validators.strlen.validator = "StringLength"
   user.login.elements.username.options.validators.strlen.options.min = "6"
   user.login.elements.username.options.validators.strlen.options.max = "20"
   user.login.elements.username.options.required = true
   user.login.elements.username.options.filters.lower.filter = "StringToLower"

   ; элемент password
   user.login.elements.password.type = "password"
   user.login.elements.password.options.validators.strlen.validator = "StringLength"
   user.login.elements.password.options.validators.strlen.options.min = "6"
   user.login.elements.password.options.required = true

   ; элемент кнопки
   user.login.elements.submit.type = "submit"

Вы можете потом передать это конструктору формы:

.. code-block:: php
   :linenos:

   $config = new Zend\Config\Ini($configFile, 'development');
   $form   = new Zend\Form\Form($config->user->login);

... и вся форма будет определена.

.. _zend.form.quickstart.conclusion:

Заключение
----------

Надеемся, что благодаря этому небольшому обучающему
руководству вы смогли получить представление о мощи и
гибкости *Zend_Form*. Для получения более подробной информации
читайте раздел далее.


