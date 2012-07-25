.. _zend.view.scripts:

视图脚本
====

Controller完成变量赋值和调用render()之后，Zend_View就会调用视图脚本并在Zend_View的实例内部执行。因此，在你的视图脚本内，$this指向Zend_View的实例。

从控制器传递到视图的变量以Zend_View实例属性的形式来调用。例如，控制器有一个变量"something"
，那么视图代码中就要用$this->something来调用。这样的作法可以让你分清哪些是来自Zend_View实例的变量，哪些是视图自身的变量。

为了说明，这里有一个例子：

.. code-block:: php
   :linenos:

   <?php if ($this->books): ?>

       <!-- A table of some books. -->
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

       <p>There are no books to display.</p>

   <?php endif;

.. _zend.view.scripts.escaping:

转义输出（Escaping Output）
---------------------

View脚本的最重要的工作之一是保证输出的内容是合适的，比如需要避免跨站攻击漏洞(XSS)。除非你已经使用一个函数、类方法或助手类（helper）来转义内容，你需要在输出时对变量进行转义。

Zend_View带有一个escape()方法来提供这个功能：

.. code-block:: php
   :linenos:

   <?php
   // 不好的做法：
   echo $this->variable;

   // 好的做法：
   echo $this->escape($this->variable);


默认地，escape()方法使用PHP函数htmlspecialchars()来过滤，但你也可以通过setEscape()方法来在Controller内告诉Zend_View需要怎么过滤。

.. code-block:: php
   :linenos:

   <?php
   //创建一个Zend_View实例
   $view = new Zend_View();

   //设定要使用的转义回调函数(callback)
   $view->setEscape('htmlentities');

   //或者使用一个静态类方法作为回调函数
   $view->setEscape(array('SomeClass', 'methodName'));

   //或者是一个对象实例的类方法
   $obj = new SomeClass();
   $view->setEscape(array($obj, 'methodName'));

   //最后输出你的视图
   echo $view->render(...);


设定的转义函数会将需要转义的变量作为其第一个参数，其它参数是可选的。

.. _zend.view.scripts.templates:

使用模板系统
------

尽管许多开发者觉得PHP本身就是一个强大的模板系统，但对模板设计师来说，使用PHP标签过于复杂。Zend_View提供了两套机制来同时满足这两种要求，一种是直接通过通过视图脚本，另一种是实现Zend_View_Interface接口。

.. _zend.view.scripts.templates.scripts:

使用View脚本的模板系统
^^^^^^^^^^^^^

View脚本可能要被用来初始化和操作一个其它模板对象的实例，例如PHPLIB风格的模板。这时View脚本可能是这样的：

.. code-block:: php
   :linenos:

   <?php
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

下面是相关的模板文件：

.. code-block:: php
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
   <p>There are no books to display.</p>>

.. _zend.view.scripts.templates.interface:

通过Zend_View_Interface接口使用模板系统
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

实现一个与Zend_View兼容的模板系统是很简单的。你只需要实现 *Zend_View_Interface*\
接口即可，该接口定义了要实现兼容的最低要求。

.. code-block:: php
   :linenos:

   /**
    * Return the actual template engine object
    * 返回实际模板系统的对象
    */
   public function getEngine();

   /**
    * Set the path to view scripts/templates
    * 设置视图脚本/模板的路径
    */
   public function setScriptPath($path);

   /**
    * Set a base path to all view resources
    * 给所有视图资源设置基本路径
    */
   public function setBasePath($path, $prefix = 'Zend_View');

   /**
    * Add an additional base path to view resources
    * 给视图资源添加另外的基本路径
    */
   public function addBasePath($path, $prefix = 'Zend_View');

   /**
    * Retrieve the current script paths
    * 获取当前脚本路径
    */
   public function getScriptPaths();

   /**
    * Overloading methods for assigning template variables as object properties
    * 重载方法，用于将赋值给模板变量，以对象属性的形式
    */
   public function __set($key, $value);
   public function __get($key);
   public function __isset($key);
   public function __unset($key);

   /**
    * Manual assignment of template variables, or ability to assign multiple
    * variables en masse.
    * 手动设置模板变量，或者一次赋值多个变量的功能
    */
   public function assign($spec, $value = null);

   /**
    * Unset all assigned template variables
    * 消除所有已赋值的变量
    */
   public function clearVars();

   /**
    * Render the template named $name
    * 输出参数$name指定的某个模板
    */
   public function render($name);

使用这个接口，把第三方的模板系统封装成Zend_View兼容的类是相当容易的。例如，下面是封装Smarty的示例代码：

.. code-block:: php
   :linenos:

   require_once 'Zend/View/Interface.php';
   require_once 'Smarty.class.php';

   class Zend_View_Smarty implements Zend_View_Interface
   {
       /**
        * Smarty object
        * @var Smarty
        */
       protected $_smarty;

       /**
        * Constructor
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
        * Return the template engine object
        *
        * @return Smarty
        */
       public function getEngine()
       {
           return $this->_smarty;
       }

       /**
        * Set the path to the templates
        *
        * @param string $path The directory to set as the path.
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
        * Retrieve the current template directory
        *
        * @return string
        */
       public function getScriptPaths()
       {
           return array($this->_smarty->template_dir);
       }

       /**
        * Alias for setScriptPath
        *
        * @param string $path
        * @param string $prefix Unused
        * @return void
        */
       public function setBasePath($path, $prefix = 'Zend_View')
       {
           return $this->setScriptPath($path);
       }

       /**
        * Alias for setScriptPath
        *
        * @param string $path
        * @param string $prefix Unused
        * @return void
        */
       public function addBasePath($path, $prefix = 'Zend_View')
       {
           return $this->setScriptPath($path);
       }

       /**
        * Assign a variable to the template
        *
        * @param string $key The variable name.
        * @param mixed $val The variable value.
        * @return void
        */
       public function __set($key, $val)
       {
           $this->_smarty->assign($key, $val);
       }

       /**
        * Retrieve an assigned variable
        *
        * @param string $key The variable name.
        * @return mixed The variable value.
        */
       public function __get($key)
       {
           return $this->_smarty->get_template_vars($key);
       }

       /**
        * Allows testing with empty() and isset() to work
        *
        * @param string $key
        * @return boolean
        */
       public function __isset($key)
       {
            return (null !== $this->_smarty->get_template_vars($key));
       }

       /**
        * Allows unset() on object properties to work
        *
        * @param string $key
        * @return void
        */
       public function __unset($key)
       {
           $this->_smarty->clear_assign($key);
       }

       /**
        * Assign variables to the template
        *
        * Allows setting a specific key to the specified value, OR passing an array
        * of key => value pairs to set en masse.
        *
        * @see __set()
        * @param string|array $spec The assignment strategy to use (key or array of key
        * => value pairs)
        * @param mixed $value (Optional) If assigning a named variable, use this
        * as the value.
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
        * Clear all assigned variables
        *
        * Clears all variables assigned to Zend_View either via {@link assign()} or
        * property overloading ({@link __get()}/{@link __set()}).
        *
        * @return void
        */
       public function clearVars()
       {
           $this->_smarty->clear_all_assign();
       }

       /**
        * Processes a template and returns the output.
        *
        * @param string $name The template to process.
        * @return string The output.
        */
       public function render($name)
       {
           return $this->_smarty->fetch($name);
       }
   }

在这个示例中，实例化 *Zend_View_Smarty*\ 而不是 *Zend_View*\ ，然后就像使用 *Zend_View*\
一样地使用它。

.. code-block:: php
   :linenos:

   $view = new Zend_View_Smarty();
   $view->setScriptPath('/path/to/templates');
   $view->book = 'Zend PHP 5 Certification Study Guide';
   $view->author = 'Davey Shafik and Ben Ramsey'
   $rendered = $view->render('bookinfo.tpl');


