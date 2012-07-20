.. _zend.form.quickstart:

Zend_Form 快速起步
==============

本快速起步指南覆盖使用 *Zend_Form* 创建、校验和解析表单的基础。

.. _zend.form.quickstart.create:

创建表单对象
------

创建表单对象非常简单：只要实现 *Zend_Form*\ ：

.. code-block::
   :linenos:
   <?php
   $form = new Zend_Form;
   ?>
对于高级用例，需要创建 *Zend_Form* 的子类，但对于简单的表单，程序可以用 *Zend_Form*
的对象来创建。

如果想指定表单的动作和方法（总是好主意），用 *setAction()* 和 *setMethod()* 来完成：

.. code-block::
   :linenos:
   <?php
   $form->setAction('/resource/process')
        ->setMethod('post');
   ?>
上述代码设置表单动作为部分 URL "/resource/process" 和表单方法为 HTTP
POST，这将在解析的最后期间表现出来。

你可以通过使用 setAttrib() 或 setAttribs() 方法为 *<form>* 标签设置另外的 HTML
属性，例如：如果想设置 id, 则设置 "id" 属性：

.. code-block::
   :linenos:
   <?php
   $form->setAttrib('id', 'login');
   ?>
.. _zend.form.quickstart.elements:

添加表单元素
------

没有元素，表单就什么都不是。 *Zend_Form* 带有一些缺省的通过 *Zend_View* 助手解析 XHTML
的元素：

- button

- checkbox (or many checkboxes at once with multiCheckbox)

- hidden

- image

- password

- radio

- reset

- select (both regular and multi-select types)

- submit

- text

- textarea

有两个方法添加表单元素：实例化具体的元素并传递这些对象，或者传递元素类型并使
*Zend_Form* 实例化一个正确类型的对象。

一些例子：

.. code-block::
   :linenos:
   <?php
   // Instantiating an element and passing to the form object:
   $form->addElement(new Zend_Form_Element_Text('username'));

   // Passing a form element type to the form object:
   $form->addElement('text', 'username');
   ?>
缺省地，这些没有校验器和过滤器，你需要用最基本的校验器和可能的过滤器来配置元素。有三个方法：(a)
在传递元素给表单之前，(b) 通过用 *Zend_Form* 创建元素时传递的配置选项，(c)
从表单把元素拉出来并在以后配置。

让我们首先看看为一个具体的元素实例创建校验器。可以传递 *Zend_Validate_**
对象，或校验器的名称：

.. code-block::
   :linenos:
   <?php
   $username = new Zend_Form_Element_Text('username');

   // Passing a Zend_Validate_* object:
   $username->addValidator(new Zend_Validate_Alnum());

   // Passing a validator name:
   $username->addValidator('alnum');
   ?>
当使用第二个方法，如果校验器可接受构造器参数，可以把它们放到数组里作为第三个参数：

.. code-block::
   :linenos:
   <?php
   // Pass a pattern
   $username->addValidator('regex', false, array('/^[a-z]/i'));
   ?>
（第二个参数用来指示是否这个校验失败时停止后面的校验，缺省为 false。）

你也可能希望指定一个必需的元素，可以通过使用访问器或当创建该元素时传递一个选项来完成，在前面的例子中：

.. code-block::
   :linenos:
   <?php
   // 使这个元素成为必需：
   $username->setRequired(true);
   ?>
当一个元素是必需的，一个 'NotEmpty'
校验器被添加到校验器链的顶部，确保该元素有一个值。

过滤器会像校验器一样注册，为了演示，让我们添加一个来把最终值变小写的过滤器：

.. code-block::
   :linenos:
   <?php
   $username->addFilter('StringtoLower');
   ?>
这样，最终元素设置看起来像这样：

.. code-block::
   :linenos:
   <?php
   $username->addValidator('alnum')
            ->addValidator('regex', false, array('/^[a-z]/'))
            ->setRequired(true)
            ->addFilter('StringToLower');

   // or, more compactly:
   $username->addValidators(array('alnum',
           array('regex', false, '/^[a-z]/i')
       ))
       ->setRequired(true)
       ->addFilters(array('StringToLower'));
   ?>
就算这样简单，在表单中为每个元素都做这样的工作也是单调乏味的。让我们试一试上述的方法(b)，当使用工厂模式
*Zend_Form::addElement()*
创建一个新元素，我们可以可选地传递配置选项，包括校验器和过滤器。这样，可以简单地完成上述任务：

.. code-block::
   :linenos:
   <?php
   $form->addElement('text', 'username', array(
       'validators' => array(
           'alnum',
           array('regex', false, '/^[a-z]/i')
       ),
       'required' => true,
       'filters'  => array('StringToLower'),
   ));
   ?>
.. note::

   如果你发现在许多地方用同样的选项来设置元素，可以考虑创建自己的
   *Zend_Form_Element* 的子类并使用它，这样长远来说会减少很多打字的任务。

.. _zend.form.quickstart.render:

解析（Render）表单
------------

解析表单很简单，大部分元素使用 *Zend_View*
助手来解析，这样需要视图对象来解析。除了这以外，还有两个方法：使用表单的
render() 方法或简单地 echo 它。

.. code-block::
   :linenos:
   <?php
   // Explicitly calling render(), and passing an optional view object:
   echo $form->render($view);

   // Assuming a view object has been previously set via setView():
   echo $form;
   ?>
缺省地， *Zend_Form* 和 *Zend_Form_Element* 将企图使用在 *ViewRenderer*
中初始化过的视图对象，你不需要在Zend Framework MVC
中手工设置视图。在视图脚本中解析表单是如此的简单：

.. code-block::
   :linenos:

   <?= $this->form ?>

在内部， *Zend_Form* 使用 "decorators" （装饰器）
来执行解析，这些装饰器可以替换内容、追加内容或预先准备内容，并拥有传递给它们的元素的
full introspection 。结果，你可以组合多个装饰器来完成定制效果。缺省地，
*Zend_Form_Element* 实际上组合了四个装饰器来完成输出，参见下例的设置：

.. code-block::
   :linenos:
   <?php
   $element->addDecorators(array(
       'ViewHelper',
       'Errors',
       array('HtmlTag', array('tag' => 'dd')),
       array('Label', array('tag' => 'dt')),
   ));
   ?>
（ <HELPERNAME> 是视图助手的名称，并根据元素不同而不同）

上述的例子创建的输出如下：

.. code-block::
   :linenos:

   <dt><label for="username" class="required">Username</dt>
   <dd>
       <input type="text" name="username" value="123-abc" />
       <ul class="errors">
           <li>'123-abc' has not only alphabetic and digit characters</li>
           <li>'123-abc' does not match against pattern '/^[a-z]/i'</li>
       </ul>
   </dd>

（虽然没有使用相同的格式。）

如果你想输出不同的东西，可以修改由元素使用的装饰器，参见装饰器一节有更多内容。

表单循环检查所有元素，并把它们放到 HTML *<form>*\
。当设置表单时，你提供的动作和方法被提供给 *<form>* 标签，还有任何通过 *setAttribs()*
和它的家族设置的属性。

元素或者按注册的顺序循环，或者如果元素包含顺序属性，就按这个顺序循环。可以使用下列方法设置元素顺序：

.. code-block::
   :linenos:
   <?php
   $element->setOrder(10);
   ?>
或者，当创建元素，作为一个选项传递给它：

.. code-block::
   :linenos:
   <?php
   $form->addElement('text', 'username', array('order' => 10));
   ?>
.. _zend.form.quickstart.validate:

检查表单是否有效
--------

表单提交之后，需要检查它是否能通过校验。每个元素根据提供的数据来检查，如果匹配元素名的键没有出现，并该条目被标记为必需，就用
null 值来校验。

数据从哪里来？用 *$_POST* 或 *$_GET* 或者其它手头上的数据源 （例如 web 服务请求）：

.. code-block::
   :linenos:
   <?php
   if ($form->isValid($_POST)) {
       // success!
   } else {
       // failure!
   }
   ?>
用 AJAX 请求， 有时候可以侥幸成功校验单个元素或一组元素。 *isValidPartial()*
将校验局部的表单，不像 *isValid()*\
，如果特定的键没有出现，那个特定部分的元素就不校验：

.. code-block::
   :linenos:
   <?php
   if ($form->isValidPartial($_POST)) {
       // elements present all passed validations
   } else {
       // one or more elements tested failed validations
   }
   ?>
一个可选的方法， *processAjax()*\ ，也可以用来校验局部表单，不像 *isValidPartial()*\
，如果失败，它返回一个包含错误消息的 JSON 格式的字符串。

假设校验都通过，现在就可以取得过滤后的值：

.. code-block::
   :linenos:
   <?php
   $values = $form->getValues();
   ?>
如果任何时候需要没有过滤的值，使用：

.. code-block::
   :linenos:
   <?php
   $unfiltered = $form->getUnfilteredValues();
   ?>
.. _zend.form.quickstart.errorstatus:

获得错误状态
------

如果表单校验失败，在大多数情况下，可以再次解析表单，如果使用了缺省的装饰器，错误信息就会显示出来：

.. code-block::
   :linenos:
   <?php
   if (!$form->isValid($_POST)) {
       echo $form;

       // or assign to the view object and render a view...
       $this->view->form = $form;
       return $this->render('form');
   }
   ?>
如果想插入错误消息，有两个方法： *getErrors()*
返回一个元素名/代码对的联合数组（这里的代码是指一个错误代码数组）。
*getMessages()*
返回一个元素名/消息对的联合数组（这里的消息是指错误代码/错误消息对的联合数组）。如果给定的元素没有任何错误，数组就不包含它。

.. _zend.form.quickstart.puttingtogether:

放到一起
----

来创建一个简单的登录表单，我们需要这些元素：

- username

- password

- submit

让我们假设有效的用户名应当只是字母数字字符，以字母开头，最少 6 个字符，最长 20
个字符，最后格式化成小写；密码最少 6
个字符，当完成这些，我们就提交，保持未校验。

我们使用 *Zend_Form* 的配置选项的能力来建立表单：

.. code-block::
   :linenos:
   <?php


   $form = new Zend_Form();
   $form->setAction('/user/login')
        ->setMethod('post');

   // Create and configure username element:
   $username = $form->createElement('text', 'username');
   $username->addValidator('alnum')
            ->addValidator('regex', false, array('/^[a-z]+/'))
            ->addValidator('stringLength', false, array(6, 20))
            ->setRequired(true)
            ->addFilter('StringToLower');

   // Create and configure password element:
   $password = $form->createElement('password', 'password');
   $password->addValidator('StringLength', false, array(6))
            ->setRequired(true);

   // Add elements to form:
   $form->addElement($username)
        ->addElement($password)
        // use addElement() as a factory to create 'Login' button:
        ->addElement('submit', 'login', array('label' => 'Login'));
   ?>
接着，我们将创建控制器来处理这些：

.. code-block::
   :linenos:
   <?php
   class UserController extends Zend_Controller_Action
   {
       public function getForm()
       {
           // create form as above
           return $form;
       }

       public function indexAction()
       {
           // render user/form.phtml
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
               // Failed validation; redisplay form
               $this->view->form = $form;
               return $this->render('form');
           }

           $values = $form->getValues();
           // now try and authenticate....
       }
   }
   ?>
和一个视图脚本来显示表单：

.. code-block::
   :linenos:

   <h2>Please login:</h2>
   <?= $this->form ?>

注意在控制器代码中，还有很多需要做：例如在提交后，需要用 *Zend_Auth* 来认证。

.. _zend.form.quickstart.config:

使用 Zend_Config 对象
-----------------

所有 *Zend_Form* 类可以用 *Zend_Config* 来配置，可以传递 *Zend_Config* 对象给构造器或者通过
*setConfig()* 来传递。来看一下如何用 INI
文件来创建上述表单，首先，遵循建议，把配置放到反映发行位置的节里面，并集中到
'development'
节，接着，为给定控制器（'user'）设置一个节，为表单（'login'）设置一个键：

.. code-block::
   :linenos:

   [development]
   ; general form metainformation
   user.login.action = "/user/login"
   user.login.method = "post"

   ; username element
   user.login.elements.username.type = "text"
   user.login.elements.username.options.validators.alnum.validator = "alnum"
   user.login.elements.username.options.validators.regex.validator = "regex"
   user.login.elements.username.options.validators.regex.options.pattern = "/^[a-z]/i"
   user.login.elements.username.options.validators.strlen.validator = "StringLength"
   user.login.elements.username.options.validators.strlen.options.min = "6"
   user.login.elements.username.options.validators.strlen.options.max = "20"
   user.login.elements.username.options.required = true
   user.login.elements.username.options.filters.lower.filter = "StringToLower"

   ; password element
   user.login.elements.password.type = "password"
   user.login.elements.password.options.validators.strlen.validator = "StringLength"
   user.login.elements.password.options.validators.strlen.options.min = "6"
   user.login.elements.password.options.required = true

   ; submit element
   user.login.elements.submit.type = "submit"

接着，你可以把它传递给表单构造器：

.. code-block::
   :linenos:
   <?php
   $config = new Zend_Config_Ini($configFile, 'development');
   $form   = new Zend_Form($config->user->login);
   ?>
整个表单就定义好了。

.. _zend.form.quickstart.conclusion:

结论
--

希望通过这个小教程，你能接触和理解 *Zend_Form*
的强大和灵活性，然后接着读更深的资料！


