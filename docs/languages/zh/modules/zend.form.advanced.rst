.. _zend.form.advanced:

Zend_Form 的高级用法
=========================

*Zend_Form*
有丰富的函数，其中许多面向有经验的开发者。这一章打算用例子和用例来介绍这些函数。

.. _zend.form.advanced.arrayNotation:

数组符号（Notation）
--------------------------

许多有经验的 web
开发者喜欢在元素名上用数组符号把相关的表单元素组成组。例如，如果有两个地址在表单上，一个邮寄地址和一个帐单地址，你可能会有相同的元素，通过把它们用数组组成组，你可以确保它们能分别被抓取。用下面的表单做个例子：

.. code-block::
   :linenos:

   <form>
       <fieldset>
           <legend>Shipping Address</legend>
           <dl>
               <dt><label for="recipient">Ship to:</label></dt>
               <dd><input name="recipient" type="text" value="" /></dd>

               <dt><label for="address">Address:</label></dt>
               <dd><input name="address" type="text" value="" /></dd>

               <dt><label for="municipality">City:</label></dt>
               <dd><input name="municipality" type="text" value="" /></dd>

               <dt><label for="province">State:</label></dt>
               <dd><input name="province" type="text" value="" /></dd>

               <dt><label for="postal">Postal Code:</label></dt>
               <dd><input name="postal" type="text" value="" /></dd>
           </dl>
       </fieldset>

       <fieldset>
           <legend>Billing Address</legend>
           <dl>
               <dt><label for="payer">Bill To:</label></dt>
               <dd><input name="payer" type="text" value="" /></dd>

               <dt><label for="address">Address:</label></dt>
               <dd><input name="address" type="text" value="" /></dd>

               <dt><label for="municipality">City:</label></dt>
               <dd><input name="municipality" type="text" value="" /></dd>

               <dt><label for="province">State:</label></dt>
               <dd><input name="province" type="text" value="" /></dd>

               <dt><label for="postal">Postal Code:</label></dt>
               <dd><input name="postal" type="text" value="" /></dd>
           </dl>
       </fieldset>

       <dl>
           <dt><label for="terms">I agree to the Terms of Service</label></dt>
           <dd><input name="terms" type="checkbox" value="" /></dd>

           <dt></dt>
           <dd><input name="save" type="submit" value="Save" /></dd>
       </dl>
   </form>

在本例中，帐单地址和邮寄地址包含一些相同的字段，这意味着一个可能会覆盖另一个。我们可以用数组符号来解决这个问题：

.. code-block::
   :linenos:

   <form>
       <fieldset>
           <legend>Shipping Address</legend>
           <dl>
               <dt><label for="shipping-recipient">Ship to:</label></dt>
               <dd><input name="shipping[recipient]" id="shipping-recipient"
                   type="text" value="" /></dd>

               <dt><label for="shipping-address">Address:</label></dt>
               <dd><input name="shipping[address]" id="shipping-address"
                   type="text" value="" /></dd>

               <dt><label for="shipping-municipality">City:</label></dt>
               <dd><input name="shipping[municipality]" id="shipping-municipality"
                   type="text" value="" /></dd>

               <dt><label for="shipping-province">State:</label></dt>
               <dd><input name="shipping[province]" id="shipping-province"
                   type="text" value="" /></dd>

               <dt><label for="shipping-postal">Postal Code:</label></dt>
               <dd><input name="shipping[postal]" id="shipping-postal"
                   type="text" value="" /></dd>
           </dl>
       </fieldset>

       <fieldset>
           <legend>Billing Address</legend>
           <dl>
               <dt><label for="billing-payer">Bill To:</label></dt>
               <dd><input name="billing[payer]" id="billing-payer"
                   type="text" value="" /></dd>

               <dt><label for="billing-address">Address:</label></dt>
               <dd><input name="billing[address]" id="billing-address"
                   type="text" value="" /></dd>

               <dt><label for="billing-municipality">City:</label></dt>
               <dd><input name="billing[municipality]" id="billing-municipality"
                   type="text" value="" /></dd>

               <dt><label for="billing-province">State:</label></dt>
               <dd><input name="billing[province]" id="billing-province"
                   type="text" value="" /></dd>

               <dt><label for="billing-postal">Postal Code:</label></dt>
               <dd><input name="billing[postal]" id="billing-postal"
                   type="text" value="" /></dd>
           </dl>
       </fieldset>

       <dl>
           <dt><label for="terms">I agree to the Terms of Service</label></dt>
           <dd><input name="terms" type="checkbox" value="" /></dd>

           <dt></dt>
           <dd><input name="save" type="submit" value="Save" /></dd>
       </dl>
   </form>

在上例中，我们有了两个单独的地址。在提交的表单，我们有三个元素，'save'
元素表示提交，和两个数组 'shipping' 和 'billing'，每个都有键对应它们的元素。

*Zend_Form* 尝试用 :ref:`sub forms <zend.form.forms.subforms>`
自动完成这个过程。缺省地，子表单用前面 HTML 表单列表包括 ids
所示的数组符号来解析，数组名基于子表单名，键基于包含在子表单中的元素。子表单的嵌套有任意深度，这将生成嵌套数组来反映它的结构。另外，
*Zend_Form*
中不同的校验程序遵循数组结构，不论子表单的嵌套有多深，都确保表单校验正确。你不需要做任何事情来获得这些好处，缺省是打开（enabled）的。

另外，有工具让你有条件地打开数组符号，也可以指定特定的数组给元素和集合所属的（子表单或表单）：

- *Zend_Form::setIsArray($flag)*\ ：通过设置标志为
  true，你可以让整个表单当作数组。缺省地，表单名将是数组名，除非调用了
  *setElementsBelongTo()*\ 。如果表单没有名称，或如果 *setElementsBelongTo()*
  没有设置，这个标志将被忽略（因为没有数组名给元素所属于的表单）。

  你可以用 *isArray()* 访问器来决定一个表单是否被当作数组。

- *Zend_Form::setElementsBelongTo($array)*\
  ：用这个方法，你可以指定数组名给元素所属的表单，也可以使用 *getElementsBelongTo()*
  访问器来确定（获得？）它的名字。

另外，在元素一级，你可以用 *Zend_Form_Element::setBelongsTo()*
方法指定可能属于特定的数组的独立的元素。 为了找出这个值是什么 －
是否显式或隐式地通过表单 － 可以用 *getBelongsTo()* 访问器来做。

.. _zend.form.advanced.multiPage:

多页表单
------------

目前， *Zend_Form* 没有正式支持多页表单，然而，可以用一些额外的工具来实现。

生成多页表单的关键是利用子表单，但每个页面只显示一个子表单。这让你一次提交一个单个的表单并校验它，直到所有表单都提交了才处理。

.. _zend.form.advanced.multiPage.registration:

.. rubric:: 注册表单示例

让我们用注册表单作为例子，我们的意图是在第一页上读取期望的用户名和密码，还有用户的元数据
－－ 用户的名字、姓和地点 －－ 最后让他们决定使用哪个邮件列表（如果有的话）。

首先，来生成表单，并在里面定义一些子表单：

.. code-block::
   :linenos:
   <?php
   class My_Form_Registration extends Zend_Form
   {
       public function init()
       {
           // Create user sub form: username and password
           $user = new Zend_Form_SubForm();
           $user->addElements(array(
               new Zend_Form_Element_Text('username', array(
                   'required'   => true,
                   'label'      => 'Username:',
                   'filters'    => array('StringTrim', 'StringToLower'),
                   'validators' => array(
                       'Alnum',
                       array('Regex', false, array('/^[a-z][a-z0-9]{2,}$/'))
                   )
               )),

               new Zend_Form_Element_Password('password', array(
                   'required'   => true,
                   'label'      => 'Password:',
                   'filters'    => array('StringTrim'),
                   'validators' => array(
                       'NotEmpty',
                       array('StringLength', false, array(6))
                   )
               )),
           ));

           // Create demographics sub form: given name, family name, and location
           $demog = new Zend_Form_SubForm();
           $demog->addElements(array(
               new Zend_Form_Element_Text('givenName', array(
                   'required'   => true,
                   'label'      => 'Given (First) Name:',
                   'filters'    => array('StringTrim'),
                   'validators' => array(
                       array('Regex', false, array('/^[a-z][a-z0-9., \'-]{2,}$/i'))
                   )
               )),

               new Zend_Form_Element_Text('familyName', array(
                   'required'   => true,
                   'label'      => 'Family (Last) Name:',
                   'filters'    => array('StringTrim'),
                   'validators' => array(
                       array('Regex', false, array('/^[a-z][a-z0-9., \'-]{2,}$/i'))
                   )
               )),

               new Zend_Form_Element_Text('location', array(
                   'required'   => true,
                   'label'      => 'Your Location:',
                   'filters'    => array('StringTrim'),
                   'validators' => array(
                       array('StringLength', false, array(2))
                   )
               )),
           ));

           // Create mailing lists sub form
           $listOptions = array(
               'none'        => 'No lists, please',
               'fw-general'  =>  'Zend Framework General List',
               'fw-mvc'      =>  'Zend Framework MVC List',
               'fw-auth'     =>  'Zend Framwork Authentication and ACL List',
               'fw-services' => 'Zend Framework Web Services List',
           );
           $lists = new Zend_Form_SubForm();
           $lists->addElements(array(
               new Zend_Form_Element_MultiCheckbox('subscriptions', array(
                   'label'        => 'Which lists would you like to subscribe to?',
                   'multiOptions' => $listOptions,
                   'required'     => true,
                   'filters'      => array('StringTrim'),
                   'validators'   => array(
                       array('InArray', false, array(array_keys($listOptions)))
                   )
               )),
           ));

           // Attach sub forms to main form
           $this->addSubForms(array(
               'user'  => $user,
               'demog' => $demog,
               'lists' => $lists
           ));
       }
   }

注意还没有提交按钮，而起我们对子表单的装饰器也没有做任何事情 －－
意思是缺省地他们作为字段（fieldsets）显示。我们将能够 override
这些因为我们显示每个独立的子表单，并加入提交按钮这样我们就可以处理它们了 －－
也要求有动作和方法（注：这里的方法是 'post' 或
'get'）属性。来给我们的类添砖加瓦让它提供那些信息：

.. code-block::
   :linenos:

   class My_Form_Registration extends Zend_Form
   {
       // ...

       /**
        * Prepare a sub form for display
        *
        * @param  string|Zend_Form_SubForm $spec
        * @return Zend_Form_SubForm
        */
       public function prepareSubForm($spec)
       {
           if (is_string($spec)) {
               $subForm = $this->{$spec};
           } elseif ($spec instanceof Zend_Form_SubForm) {
               $subForm = $spec;
           } else {
               throw new Exception('Invalid argument passed to ' . __FUNCTION__ . '()');
           }
           $this->setSubFormDecorators($subForm)
                ->addSubmitButton($subForm)
                ->addSubFormActions($subForm);
           return $subForm;
       }

       /**
        * Add form decorators to an individual sub form
        *
        * @param  Zend_Form_SubForm $subForm
        * @return My_Form_Registration
        */
       public function setSubFormDecorators(Zend_Form_SubForm $subForm)
       {
           $subForm->setDecorators(array(
               'FormElements',
               array('HtmlTag', array('tag' => 'dl', 'class' => 'zend_form')),
               'Form',
           ));
           return $this;
       }

       /**
        * Add a submit button to an individual sub form
        *
        * @param  Zend_Form_SubForm $subForm
        * @return My_Form_Registration
        */
       public function addSubmitButton(Zend_Form_SubForm $subForm)
       {
           $subForm->addElement(new Zend_Form_Element_Submit(
               'save',
               array(
                   'label'    => 'Save and continue',
                   'required' => false,
                   'ignore'   => true,
               )
           ));
           return $this;
       }

       /**
        * Add action and method to sub form
        *
        * @param  Zend_Form_SubForm $subForm
        * @return My_Form_Registration
        */
       public function addSubFormActions(Zend_Form_SubForm $subForm)
       {
           $subForm->setAction('/registration/process')
                   ->setMethod('post');
           return $this;
       }
   }

接着，我们也需要为动作控制器添加一些辅助东西，并有若干考虑。首先，我们需要确保在请求之间保持表单数据，这样可以确定何时退出。第二，我们需要一些逻辑来确定表单的哪部分已经提交，哪个子表单需要基于这些信息来显示。我们使用
*Zend_Session_Namespace* 来保持数据，它也会告诉我们提交哪个表单。

让我们来创建控制器，并添加用于获取表单实例的方法：

.. code-block::
   :linenos:
   <?php
   class RegistrationController extends Zend_Controller_Action
   {
       protected $_form;

       public function getForm()
       {
           if (null === $this->_form) {
               require_once 'My/Form/Registration.php';
               $this->_form = new My_Form_Registration();
           }
           return $this->_form;
       }
   }

现在，添加一些函数来确定显示哪个表单。基本上，直到整个表单被认为有效，我们才需要继续显示表单片段。另外，我们可能想确保它们是按一定的顺序：用户、demog
和
列表。我们在可以通过检查出现在每个子表单上的特定键的会话命名空间确定哪个数据被提交。

.. code-block::
   :linenos:

   class RegistrationController extends Zend_Controller_Action
   {
       // ...

       protected $_namespace = 'RegistrationController';
       protected $_session;

       /**
        * Get the session namespace we're using
        *
        * @return Zend_Session_Namespace
        */
       public function getSessionNamespace()
       {
           if (null === $this->_session) {
               require_once 'Zend/Session/Namespace.php';
               $this->_session = new Zend_Session_Namespace($this->_namespace);
           }

           return $this->_session;
       }

       /**
        * Get a list of forms already stored in the session
        *
        * @return array
        */
       public function getStoredForms()
       {
           $stored = array();
           foreach ($this->getSessionNamespace() as $key => $value) {
               $stored[] = $key;
           }

           return $stored;
       }

       /**
        * Get list of all subforms available
        *
        * @return array
        */
       public function getPotentialForms()
       {
           return array_keys($this->getForm()->getSubForms());
       }

       /**
        * What sub form was submitted?
        *
        * @return false|Zend_Form_SubForm
        */
       public function getCurrentSubForm()
       {
           $request = $this->getRequest();
           if (!$request->isPost()) {
               return false;
           }

           foreach ($this->getPotentialForms() as $name) {
               if ($data = $request->getPost($name, false)) {
                   if (is_array($data)) {
                       return $this->getForm()->getSubForm($name);
                       break;
                   }
               }
           }

           return false;
       }

       /**
        * Get the next sub form to display
        *
        * @return Zend_Form_SubForm|false
        */
       public function getNextSubForm()
       {
           $storedForms    = $this->getStoredForms();
           $potentialForms = $this->getPotentialForms();

           foreach ($potentialForms as $name) {
               if (!in_array($name, $storedForms)) {
                   return $this->getForm()->getSubForm($name);
               }
           }

           return false;
       }
   }

上述方法让我们使用符合如 "*$subForm = $this->getCurrentSubForm();*"
来读取当前子表单来校验，或者 "*$next = $this->getNextSubForm();*" 来获得下一个来显示。

现在，让我们看一下如何处理和显示不同的子表单。我们可以使用 *getCurrentSubForm()*
来确定表单是否提交（返回 false 值表示没有显示或提交），并且用 *getNextSubForm()*
来获取表单来显示。我们还可以用表单的 *prepareSubForm()*
方法来确保表单已准备好显示。

当我们收到表单提交，可以校验子表单并接着检查是否整个表单有效。为完成这些任务，我们需要另外的方法确保提交的数据添加到会话和什么时候校验整个表单，我们依靠从会话来的所有片段（segments）来校验：

.. code-block::
   :linenos:
   <?php
   class My_Form_Registration extends Zend_Form
   {
       // ...

       /**
        * Is the sub form valid?
        *
        * @param  Zend_Form_SubForm $subForm
        * @param  array $data
        * @return bool
        */
       public function subFormIsValid(Zend_Form_SubForm $subForm, array $data)
       {
           $name = $subForm->getName();
           if ($subForm->isValid($data)) {
               $this->getSessionNamespace()->$name = $subForm->getValues();
               return true;
           }

           return false;
       }

       /**
        * Is the full form valid?
        *
        * @return bool
        */
       public function formIsValid()
       {
           $data = array();
           foreach ($this->getSessionNamespace() as $key => $info) {
               $data[$key] = $info;
           }

           return $this->getForm()->isValid($data);
       }
   }

八字已经画了一撇，让我们来为控制器构造一个动作。我们需要为表单做一个 landing
页面，接着'process' 动作来处理表单。

.. code-block::
   :linenos:
   <?php
   class RegistrationController extends Zend_Controller_Action
   {
       // ...

       public function indexAction()
       {
           // Either re-display the current page, or grab the "next" (first)
           // sub form
           if (!$form = $this->getCurrentSubForm()) {
               $form = $this->getNextSubForm();
           }
           $this->view->form = $this->getForm()->prepareSubForm($form);
       }

       public function processAction()
       {
           if (!$form = $this->getCurrentSubForm()) {
               return $this->_forward('index');
           }

           if (!$this->subFormIsValid($form, $this->getRequest()->getPost())) {
               $this->view->form = $this->getForm()->prepareSubForm($form);
               return $this->render('index');
           }

           if (!$this->formIsValid()) {
               $form = $this->getNextSubForm();
               $this->view->form = $this->getForm()->prepareSubForm($form);
               return $this->render('index');
           }

           // Valid form!
           // Render information in a verification page
           $this->view->info = $this->getSessionNamespace();
           $this->render('verification');
       }
   }

正如你注意到的，处理表单的代码相当简单。我们检查是否有一个子表单提交，如果没有，就回到
landing
页面。如果我们确实有一个子表单，就尝试校验它，如果失败，重新显示。如果子表单有效，那么我们就检查表单是否有效，它将指示我们是否完成，如果没有，我们就显示下一个表单片段。最后，我们显示一个确认过的带有会话内容的页面。

The view scripts are very simple:

.. code-block::
   :linenos:

   <? // registration/index.phtml ?>
   <h2>Registration</h2>
   <?= $this->form ?>

   <? // registration/verification.phtml ?>
   <h2>Thank you for registering!</h2>
   <p>
       这里是你所提供的信息：
   </p>

   <?
   // Have to do this construct due to how items are stored in session namespaces
   foreach ($this->info as $info):
       foreach ($info as $form => $data): ?>
   <h4><?= ucfirst($form) ?>:</h4>
   <dl>
       <? foreach ($data as $key => $value): ?>
       <dt><?= ucfirst($key) ?></dt>
       <? if (is_array($value)):
           foreach ($value as $label => $val): ?>
       <dd><?= $val ?></dd>
           <? endforeach;
          else: ?>
       <dd><?= $this->escape($value) ?></dd>
       <? endif;
       endforeach; ?>
   </dl>
   <? endforeach;
   endforeach ?>

Zend Framework
的下次发行将通过抽象会话和顺序逻辑来提供制作多页面表单的组件。在这期间，上述例子对如何为你的站点生成多页面是个合理的指南。


