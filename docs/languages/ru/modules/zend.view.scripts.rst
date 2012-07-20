.. _zend.view.scripts:

Скрипты видов
=============

После того, как ваш контроллер определил переменные и вызвал
метод *render()*, ``Zend_View`` включает требуемый скрипт вида и
выполняет его в области видимости экземпляра ``Zend_View``. Поэтому
в вашем скрипте вида ссылки на $this в действительности будут
ссылаться на сам экземляр ``Zend_View``.

Переменные, устанавливаемые в контроллере для скрипта вида,
являются свойствами экземпляра ``Zend_View``. Например, если
контроллер установил переменную 'something', то в скрипте вида вы
можете ссылаться на нее следующим образом: ``$this->something``. Это
дает возможность отслеживать, какие переменные были
установлены извне для скрипта, и какие были установлены в
самом скрипте.

Ниже приведен пример скрипта вида из введения:

.. code-block:: php
   :linenos:

   <?php if ($this->books): ?>

       <!-- Таблица из нескольких книг. -->
       <table>
           <tr>
               <th>Author</th>
               <th>Title</th>
           </tr>

           <?php foreach ($this->books as $key => $val): ?>
           <tr>
               <td><?php echo $this->escape($val['author']) ?></td>
               <td><?php echo $this->escape($val['title']) ?></td>
           </tr>
           <?php endforeach; ?>

       </table>

   <?php else: ?>

       <p>Нет книг для отображения.</p>

   <?php endif;?>

.. _zend.view.scripts.escaping:

Экранирование вывода
--------------------

Одной из наиважнейших задач, которую должен решать скрипт
вида, является обеспечение того, что вывод должным образом
экранирован; помимо прочего, это помогает предотвратить
XSS-атаки. За исключением тех случаев, когда используются
функции, методы или помощники, которые сами производят
экранирование, вы должны всегда экранировать переменные,
когда выводите их.

``Zend_View`` снабжен методом *escape()*, который выполняет
экранирование.

.. code-block:: php
   :linenos:

   // плохая практика
   echo $this->variable;

   // хорошая практика
   echo $this->escape($this->variable);

По умолчанию метод *escape()* использует функцию PHP *htmlspecialchars()* для
экранирования. Но, в зависимости от вашего окружения, может
потребоваться выполнять экранирование по-иному. Используйте
метод *setEscape()* на уровне контроллера, чтобы указать ``Zend_View``,
какую экранирующую функцию обратного вызова использовать.

.. code-block:: php
   :linenos:

   // создание экземпляра Zend_View
   $view = new Zend_View();

   // приказываем ему использовать htmlentities
   // в качестве экранирующей функции обратного вызова
   $view->setEscape('htmlentities');

   // либо приказываем ему использовать статический метод класса
   $view->setEscape(array('SomeClass', 'methodName'));

   // или даже метод экземпляра
   $obj = new SomeClass();
   $view->setEscape(array($obj, 'methodName'));

   // и затем воспроизводим вид
   echo $view->render(...);

Функции или методы обратного вызова должны принимать
значение, которое требуется экранировать, как первый параметр,
все остальные параметры должны быть необязательными.

.. _zend.view.scripts.templates:

Использование других шаблонизаторов
-----------------------------------

Хотя PHP сам по себе представляет собой мощный шаблонизатор,
многие разработчики считают его избыточным или сложным для
верстальщиков и предпочитают использовать другие
шаблонизаторы. ``Zend_View`` предоставляет два пути для этого:
первый - через скрипты вида, второй - посредством реализации
интерфейса ``Zend_View_Interface``.

.. _zend.view.scripts.templates.scripts:

Шаблонизаторы c использованием скриптов видов
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Скрипт вида может использоваться для инстанцирования и
манипулирования отдельным объектом шаблона (это могут быть
шаблоны в стиле PHPLIB).

.. code-block:: php
   :linenos:

   include_once 'template.inc';
   $tpl = new Template();

   if ($this->books) {
       $tpl->setFile(array(
           "booklist" => "booklist.tpl",
           "eachbook" => "eachbook.tpl",
       ));

       foreach ($this->books as $key => $val) {
           $tpl->set_var('author', $this->escape($val['author']);
           $tpl->set_var('title', $this->escape($val['title']);
           $tpl->parse("books", "eachbook", true);
       }

       $tpl->pparse("output", "booklist");
   } else {
       $tpl->setFile("nobooks", "nobooks.tpl")
       $tpl->pparse("output", "nobooks");
   }

Это может соответствовать следующему файлу шаблона:

.. code-block:: html
   :linenos:

   <!-- booklist.tpl -->
   <table>
       <tr>
           <th>Author</th>
           <th>Title</th>
       </tr>
       {books}
   </table>

   <!-- eachbook.tpl -->
       <tr>
           <td>{author}</td>
           <td>{title}</td>
       </tr>

   <!-- nobooks.tpl -->
   <p>Нет книг для отображения.</p>

.. _zend.view.scripts.templates.interface:

Шаблонизаторы с использованием Zend_View_Interface
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Некоторые считают более удобным использовать совместимый с
``Zend_View`` шаблонизатор. ``Zend_View_Interface`` предоставляет минимально
необходимый для совместимости интерфейс:

.. code-block:: php
   :linenos:

   /**
    * Возвращает объект используемого шаблонизатора
    */
   public function getEngine();

   /**
    * Устанавливает путь к шаблонам или скриптам вида
    */
   public function setScriptPath($path);

   /**
    * Устанавливает базовый путь ко всем необходимым скрипту вида ресурсам
    */
   public function setBasePath($path, $prefix = 'Zend_View');

   /**
    * Устанавливает дополнительный базовый путь к необходимым скрипту вида ресурсам
    */
   public function addBasePath($path, $prefix = 'Zend_View');

   /**
    * Возвращает текущие пути к скриптам
    */
   public function getScriptPaths();

   /**
    * Переопределение методов для присвоения значений переменным шаблонов как
    * свойствам объекта
    */
   public function __set($key, $value);
   public function __get($key);
   public function __isset($key);
   public function __unset($key);

   /**
    * "Ручная" установка значения переменной шаблона или одновременное присвоение
    * значений нескольким переменным
    */
   public function assign($spec, $value = null);

   /**
    * Удаление всех переменных шаблона
    */
   public function clearVars();

   /**
    * Вывод шаблона с именем $name
    */
   public function render($name);

Используя этот интерфейс, относительно легко сделать "обертку"
для шаблонизаторов сторонних разработчиков. В примере показан
вариант "обертки" для Smarty:

.. code-block:: php
   :linenos:

   class Zend_View_Smarty implements Zend_View_Interface
   {
       /**
        * Объект Smarty
        * @var Smarty
        */
       protected $_smarty;

       /**
        * Конструктор
        *
        * @param string $tmplPath
        * @param array $extraParams
        * @return void
        */
       public function __construct($tmplPath = null, $extraParams = array())
       {
           $this->_smarty = new Smarty;

           if (null !== $tmplPath) {
               $this->setScriptPath($tmplPath);
           }

           foreach ($extraParams as $key => $value) {
               $this->_smarty->$key = $value;
           }
       }

       /**
        * Возвращение объекта шаблонизатора
        *
        * @return Smarty
        */
       public function getEngine()
       {
           return $this->_smarty;
       }

       /**
        * Установка пути к шаблонам
        *
        * @param string $path Директория, устанавливаемая как путь к шаблонам
        * @return void
        */
       public function setScriptPath($path)
       {
           if (is_readable($path)) {
               $this->_smarty->template_dir = $path;
               return;
           }

           throw new Exception('Invalid path provided');
       }

       /**
        * Извлечение текущего пути к шаблонам
        *
        * @return string
        */
       public function getScriptPaths()
       {
           return array($this->_smarty->template_dir);
       }

       /**
        * Метод-"псевдоним" для setScriptPath
        *
        * @param string $path
        * @param string $prefix Не используется
        * @return void
        */
       public function setBasePath($path, $prefix = 'Zend_View')
       {
           return $this->setScriptPath($path);
       }

       /**
        * Метод-"псевдоним" для setScriptPath
        *
        * @param string $path
        * @param string $prefix Не используется
        * @return void
        */
       public function addBasePath($path, $prefix = 'Zend_View')
       {
           return $this->setScriptPath($path);
       }

       /**
        * Присвоение значения переменной шаблона
        *
        * @param string $key Имя переменной
        * @param mixed $val Значение переменной
        * @return void
        */
       public function __set($key, $val)
       {
           $this->_smarty->assign($key, $val);
       }

       /**
        * Получение значения переменной
        *
        * @param string $key Имя переменной
        * @return mixed Значение переменной
        */
       public function __get($key)
       {
           return $this->_smarty->get_template_vars($key);
       }

       /**
        * Позволяет проверять переменные через empty() и isset()
        *
        * @param string $key
        * @return boolean
        */
       public function __isset($key)
       {
           return (null !== $this->_smarty->get_template_vars($key));
       }

       /**
        * Позволяет удалять свойства объекта через unset()
        *
        * @param string $key
        * @return void
        */
       public function __unset($key)
       {
           $this->_smarty->clear_assign($key);
       }

       /**
        * Присвоение переменных шаблону
        *
        * Позволяет установить значение к определенному ключу или передать массив
        * пар ключ => значение
        *
        * @see __set()
        * @param string|array $spec Ключ или массив пар ключ => значение
        * @param mixed $value (необязательный) Если присваивается значение одной
        * переменной, то через него передается значение переменной
        * @return void
        */
       public function assign($spec, $value = null)
       {
           if (is_array($spec)) {
               $this->_smarty->assign($spec);
               return;
           }

           $this->_smarty->assign($spec, $value);
       }

       /**
        * Удаление всех переменных
        *
        * @return void
        */
       public function clearVars()
       {
           $this->_smarty->clear_all_assign();
       }

       /**
        * Обрабатывает шаблон и возвращает вывод
        *
        * @param string $name Шаблон для обработки
        * @return string Вывод
        */
       public function render($name)
       {
           return $this->_smarty->fetch($name);
       }
   }

В этом примере вы можете инстанцировать класс ``Zend_View_Smarty``
вместо ``Zend_View`` и использовать его так же, как используется
``Zend_View``.

.. code-block:: php
   :linenos:

   //Пример 1. В initView() инициализатора
   $view = new Zend_View_Smarty('/path/to/templates');
   $viewRenderer =
       new Zend_Controller_Action_HelperBroker::getStaticHelper('ViewRenderer');
   $viewRenderer->setView($view)
                ->setViewBasePathSpec($view->_smarty->template_dir)
                ->setViewScriptPathSpec(':controller/:action.:suffix')
                ->setViewScriptPathNoControllerSpec(':action.:suffix')
                ->setViewSuffix('tpl');

   //Пример 2. Использование в контроллере действии остается тем же
   class FooController extends Zend_Controller_Action
   {
       public function barAction()
       {
           $this->view->book   = 'Zend PHP 5 Certification Study Guide';
           $this->view->author = 'Davey Shafik and Ben Ramsey'
       }
   }

   //Пример 3. Инициализация вида в контроллере действий
   class FooController extends Zend_Controller_Action
   {
       public function init()
       {
           $this->view   = new Zend_View_Smarty('/path/to/templates');
           $viewRenderer = $this->_helper->getHelper('viewRenderer');
           $viewRenderer->setView($this->view)
                        ->setViewBasePathSpec($view->_smarty->template_dir)
                        ->setViewScriptPathSpec(':controller/:action.:suffix')
                        ->setViewScriptPathNoControllerSpec(':action.:suffix')
                        ->setViewSuffix('tpl');
       }
   }


