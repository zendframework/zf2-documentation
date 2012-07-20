.. _zend.form.advanced:

Zend_Form の高度な使用法
=================

``Zend_Form`` にはさまざまな機能があり、
その多くは熟練者向けに用意されています。本章では、
それらの機能について例を交えて説明します。

.. _zend.form.advanced.arrayNotation:

配列記法
----

関連するフォーム要素について、要素名を配列形式にしてグループ化したいこともあるでしょう。
たとえば、配送先と請求先のふたつの住所を受け取りたい場合、
それぞれに同じ要素を使った上で配列でグループ化すれば、
結果を別々に受け取ることができます。
たとえば次のようなフォームを例に考えてみましょう。

.. code-block:: html
   :linenos:

   <form>
       <fieldset>
           <legend>配送先</legend>
           <dl>
               <dt><label for="recipient">氏名:</label></dt>
               <dd><input name="recipient" type="text" value="" /></dd>

               <dt><label for="address">住所:</label></dt>
               <dd><input name="address" type="text" value="" /></dd>

               <dt><label for="municipality">市:</label></dt>
               <dd><input name="municipality" type="text" value="" /></dd>

               <dt><label for="province">州:</label></dt>
               <dd><input name="province" type="text" value="" /></dd>

               <dt><label for="postal">郵便番号:</label></dt>
               <dd><input name="postal" type="text" value="" /></dd>
           </dl>
       </fieldset>

       <fieldset>
           <legend>請求先</legend>
           <dl>
               <dt><label for="payer">氏名:</label></dt>
               <dd><input name="payer" type="text" value="" /></dd>

               <dt><label for="address">住所:</label></dt>
               <dd><input name="address" type="text" value="" /></dd>

               <dt><label for="municipality">市:</label></dt>
               <dd><input name="municipality" type="text" value="" /></dd>

               <dt><label for="province">州:</label></dt>
               <dd><input name="province" type="text" value="" /></dd>

               <dt><label for="postal">郵便番号:</label></dt>
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

この例では、請求先住所と配送先住所に同じフィールドを使用しているため、
一方が他方を上書きしてしまいます。 これを解決するには、配列記法を使用します。

.. code-block:: html
   :linenos:

   <form>
       <fieldset>
           <legend>配送先</legend>
           <dl>
               <dt><label for="shipping-recipient">氏名:</label></dt>
               <dd><input name="shipping[recipient]" id="shipping-recipient"
                   type="text" value="" /></dd>

               <dt><label for="shipping-address">住所:</label></dt>
               <dd><input name="shipping[address]" id="shipping-address"
                   type="text" value="" /></dd>

               <dt><label for="shipping-municipality">市:</label></dt>
               <dd><input name="shipping[municipality]" id="shipping-municipality"
                   type="text" value="" /></dd>

               <dt><label for="shipping-province">州:</label></dt>
               <dd><input name="shipping[province]" id="shipping-province"
                   type="text" value="" /></dd>

               <dt><label for="shipping-postal">郵便番号:</label></dt>
               <dd><input name="shipping[postal]" id="shipping-postal"
                   type="text" value="" /></dd>
           </dl>
       </fieldset>

       <fieldset>
           <legend>請求先</legend>
           <dl>
               <dt><label for="billing-payer">氏名:</label></dt>
               <dd><input name="billing[payer]" id="billing-payer"
                   type="text" value="" /></dd>

               <dt><label for="billing-address">住所:</label></dt>
               <dd><input name="billing[address]" id="billing-address"
                   type="text" value="" /></dd>

               <dt><label for="billing-municipality">市:</label></dt>
               <dd><input name="billing[municipality]" id="billing-municipality"
                   type="text" value="" /></dd>

               <dt><label for="billing-province">州:</label></dt>
               <dd><input name="billing[province]" id="billing-province"
                   type="text" value="" /></dd>

               <dt><label for="billing-postal">郵便番号:</label></dt>
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

上の例では、住所をそれぞれ個別に受け取ることができます。
このフォームを送信すると、受け取り側では 3 つの要素を取得できます。 'save'
が送信ボタン、そしてふたつの配列 'shipping' と 'billing'
の中にはさまざまなキーとそれに対応する要素が含まれています。

``Zend_Form`` は、この処理を :ref:`サブフォーム <zend.form.forms.subforms>` で自動化します。
By default, sub forms render using the array notation as shown in the previous *HTML* form listing, complete with
ids. 配列の名前はサブフォーム名からとられ、
配列のキーはサブフォーム内に含まれる要素となります。
サブフォームは、何段階でもネストさせることができます。
その場合も、ネストした配列形式でその構造を表します。 さらに、 ``Zend_Form``
のさまざまなバリデーション機能は、この配列構造をきちんと処理するようにできています。
サブフォームをどれだけ深くネストさせたとしても、
フォームの検証は正しく行ってくれます。
この機能を使うために特に何かしなければならないということはありません。
この機能はデフォルトで有効になっています。

さらに、条件付きで配列記法を有効にしたり
特定の配列を指定してそこに要素やコレクションを所属させたりといった機能もあります。

- ``Zend_Form::setIsArray($flag)``: このフラグを ``TRUE``
  にすると、フォーム全体を配列として扱うことができます。 デフォルトでは、
  ``setElementsBelongTo()`` がコールされていない限りはフォーム名を配列の名前とします。
  フォームに名前が設定されていない場合や ``setElementsBelongTo()``
  が設定されていない場合は、 このフラグは無視されます
  (要素が属する配列の名前がないからです)。

  フォームが配列として扱われているかどうかを知りたい場合には ``isArray()``
  アクセサを使用します。

- ``Zend_Form::setElementsBelongTo($array)``:
  このメソッドを使用すると、フォームの全要素が属する
  配列の名前を指定できます。現在設定されている値を調べるには ``getElementsBelongTo()``
  アクセサを使用します。

さらに、要素レベルでは、特定の要素を特定の配列に属させるために
``Zend_Form_Element::setBelongsTo()`` メソッドを使うこともできます。 この値が何者なのか
(明示的に設定されたものなのか フォームを経由して暗黙的に設定されたものなのか)
を知るには ``getBelongsTo()`` アクセサを使用します。

.. _zend.form.advanced.multiPage:

複数ページのフォーム
----------

現在、複数ページのフォームは ``Zend_Form`` では公式にはサポートしていません。
しかし、それを実装するための機能の大半はサポートしており、
ほんの少し手を加えるだけでこの機能を実現できます。

複数ページのフォームを作成する鍵となるのが、
サブフォームの活用です。各ページに、ひとつのサブフォームだけを表示させるわけです。
こうすれば、それぞれのサブフォームの内容を各ページで検証し、
かつすべてのサブフォームの入力を終えるまでフォームの処理を行わないということができます。

.. _zend.form.advanced.multiPage.registration:

.. rubric:: 登録フォームの例

例として、登録フォームを考えてみましょう。
まず最初のページでユーザ名とパスワードを入力してもらい、
次のページではユーザのメタデータ (姓、名、住所など)、そして最後のページでは
参加したいメーリングリストを選択するといったものです。

まずはフォームを作成し、 その中でサブフォームをいくつか定義します。

.. code-block:: php
   :linenos:

   class My_Form_Registration extends Zend_Form
   {
       public function init()
       {
           // ユーザサブフォーム (ユーザ名とパスワード) を作成します
           $user = new Zend_Form_SubForm();
           $user->addElements(array(
               new Zend_Form_Element_Text('username', array(
                   'required'   => true,
                   'label'      => 'Username:',
                   'filters'    => array('StringTrim', 'StringToLower'),
                   'validators' => array(
                       'Alnum',
                       array('Regex',
                             false,
                             array('/^[a-z][a-z0-9]{2,}$/'))
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

           // 詳細サブフォーム (姓、名、住所) を作成します
           $demog = new Zend_Form_SubForm();
           $demog->addElements(array(
               new Zend_Form_Element_Text('givenName', array(
                   'required'   => true,
                   'label'      => 'Given (First) Name:',
                   'filters'    => array('StringTrim'),
                   'validators' => array(
                       array('Regex',
                             false,
                             array('/^[a-z][a-z0-9., \'-]{2,}$/i'))
                   )
               )),

               new Zend_Form_Element_Text('familyName', array(
                   'required'   => true,
                   'label'      => 'Family (Last) Name:',
                   'filters'    => array('StringTrim'),
                   'validators' => array(
                       array('Regex',
                             false,
                             array('/^[a-z][a-z0-9., \'-]{2,}$/i'))
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

           // メーリングリストサブフォームを作成します
           $listOptions = array(
               'none'        => 'No lists, please',
               'fw-general'  => 'Zend Framework General List',
               'fw-mvc'      => 'Zend Framework MVC List',
               'fw-auth'     => 'Zend Framwork Authentication and ACL List',
               'fw-services' => 'Zend Framework Web Services List',
           );
           $lists = new Zend_Form_SubForm();
           $lists->addElements(array(
               new Zend_Form_Element_MultiCheckbox('subscriptions', array(
                   'label'        =>
                       'Which lists would you like to subscribe to?',
                   'multiOptions' => $listOptions,
                   'required'     => true,
                   'filters'      => array('StringTrim'),
                   'validators'   => array(
                       array('InArray',
                             false,
                             array(array_keys($listOptions)))
                   )
               )),
           ));

           // サブフォームをメインフォームにアタッチします
           $this->addSubForms(array(
               'user'  => $user,
               'demog' => $demog,
               'lists' => $lists
           ));
       }
   }

submit ボタンがないこと、
またサブフォームのデコレータではなにもしていないことに注意しましょう。
そのままでは、これらのサブフォームはフィールドセットとして表示されることになります。
つまり、処理をオーバーライドしてそれらを個別のサブフォームになるようにし、
さらに submit ボタンを追加して処理を進められるようにする必要があります。 submit
ボタンには action プロパティと method プロパティも必要です。
では、これらの機能のとっかかりを先ほどのクラスに追加してみましょう。

.. code-block:: php
   :linenos:

   class My_Form_Registration extends Zend_Form
   {
       // ...

       /**
        * 表示用のサブフォームを準備する
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
               throw new Exception('Invalid argument passed to ' .
                                   __FUNCTION__ . '()');
           }
           $this->setSubFormDecorators($subForm)
                ->addSubmitButton($subForm)
                ->addSubFormActions($subForm);
           return $subForm;
       }

       /**
        * Form デコレータを各サブフォームに追加する
        *
        * @param  Zend_Form_SubForm $subForm
        * @return My_Form_Registration
        */
       public function setSubFormDecorators(Zend_Form_SubForm $subForm)
       {
           $subForm->setDecorators(array(
               'FormElements',
               array('HtmlTag', array('tag' => 'dl',
                                      'class' => 'zend_form')),
               'Form',
           ));
           return $this;
       }

       /**
        * submit ボタンを各サブフォームに追加する
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
        * action と method をサブフォームに追加する
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

次に、アクションコントローラ用の仕組みを追加する必要があります。
さらにいくつか考えなければならないこともあります。
まず、フォームの入力内容をリクエスト間で持続させなければなりません。
次に、フォームの情報のうちどの部分が入力済みなのか、
そしてその部分に対応するサブフォームがどれなのか
といった情報を取得するロジックも必要です。今回は ``Zend_Session_Namespace``
を使用してデータを持続させることにします。
そうすれば、二番目の問題に対応するのも簡単になるでしょう。

それではコントローラを作成していきましょう。
そして、フォームのインスタンスを取得するためのメソッドを追加します。

.. code-block:: php
   :linenos:

   class RegistrationController extends Zend_Controller_Action
   {
       protected $_form;

       public function getForm()
       {
           if (null === $this->_form) {
               $this->_form = new My_Form_Registration();
           }
           return $this->_form;
       }
   }

それでは、どのフォームを表示するのかを決める機能を追加していきましょう。
基本的に、フォーム全体の入力内容の検証を終えるまでは
フォームの一部の表示を続けることになります。
さらに、普通はそれを決まった順序で表示することになるでしょう。 今回の場合は
user、demog、そして最後に lists といった具合です。
どのデータが入力済みかを調べるには、セッションの名前空間を調べます。
各サブフォームに対応するキーが存在するかどうかを調べるというわけです。

.. code-block:: php
   :linenos:

   class RegistrationController extends Zend_Controller_Action
   {
       // ...

       protected $_namespace = 'RegistrationController';
       protected $_session;

       /**
        * 使用するセッション名前空間を取得する
        *
        * @return Zend_Session_Namespace
        */
       public function getSessionNamespace()
       {
           if (null === $this->_session) {
               $this->_session =
                   new Zend_Session_Namespace($this->_namespace);
           }

           return $this->_session;
       }

       /**
        * すでにセッションに保存済みであるフォームの一覧を取得する
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
        * 使用できるすべてのサブフォームの一覧を取得する
        *
        * @return array
        */
       public function getPotentialForms()
       {
           return array_keys($this->getForm()->getSubForms());
       }

       /**
        * 今どのサブフォームが送信されたのか?
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
        * 次に表示するサブフォームを取得する
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

上のメソッドを使用すると、たとえば "``$subForm = $this->getCurrentSubForm();``"
で現在のサブフォームを取得してそれを検証したり "``$next = $this->getNextSubForm();``"
で次に表示するフォームを取得したりできます。

では、実際にサブフォームを処理したり表示したりする方法を考えてみましょう。
``getCurrentSubForm()`` を使用すれば、
今送信されてきたデータがどのサブフォームのものなのかがわかります (``FALSE``
が返された場合は、まだ何も表示あるいは送信されていないことを表します)。
また、 ``getNextSubForm()`` を使用すれば次に表示すべきフォームを取得できます。
そして、フォームの ``prepareSubForm()``
メソッドを使用すれば、フォームを表示するための準備を行えます。

フォームを送信したら、サブフォームのデータを検証し、
そしてフォーム全体の入力が完了したかどうかを調べることができます。
これらの作業を行うためには、さらにいくつかのメソッドを追加しなければなりません。
送信されたデータをセッションに追加するメソッドや、
フォーム全体の検証を行う際にセッションの全セグメントを検証するメソッドなどです。

.. code-block:: php
   :linenos:

   class RegistrationController extends Zend_Controller_Action
   {
       // ...

       /**
        * サブフォームの入力は妥当か?
        *
        * @param  Zend_Form_SubForm $subForm
        * @param  array $data
        * @return bool
        */
       public function subFormIsValid(Zend_Form_SubForm $subForm,
                                      array $data)
       {
           $name = $subForm->getName();
           if ($subForm->isValid($data)) {
               $this->getSessionNamespace()->$name = $subForm->getValues();
               return true;
           }

           return false;
       }

       /**
        * フォーム全体の入力は妥当か?
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

これで足場は固まりました。
ではこのコントローラのアクションを作っていきましょう。
まずこのフォームの最初のページ、 それからフォームを処理するための 'process'
アクションが必要となります。

.. code-block:: php
   :linenos:

   class RegistrationController extends Zend_Controller_Action
   {
       // ...

       public function indexAction()
       {
           // 現在のページを再表示するか、"次の" (最初の)
           // サブフォームを取得します
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

           if (!$this->subFormIsValid($form,
                                      $this->getRequest()->getPost())) {
               $this->view->form = $this->getForm()->prepareSubForm($form);
               return $this->render('index');
           }

           if (!$this->formIsValid()) {
               $form = $this->getNextSubForm();
               $this->view->form = $this->getForm()->prepareSubForm($form);
               return $this->render('index');
           }

           // フォームの入力が完了しました!
           // 確認ページに情報を表示します
           $this->view->info = $this->getSessionNamespace();
           $this->render('verification');
       }
   }

お気づきのとおり、実際にフォームを処理する部分のコードは比較的シンプルです。
注目すべき点は、どのサブフォームが送信されてきたのかを調べ、
何も送信されていない場合は先頭ページに飛ばしている部分です。
サブフォームが送信されてきた場合はそれを検証し、
問題がある場合は同じサブフォームを再表示します。
問題がない場合は、フォーム全体の入力が妥当か
(つまりすべての入力が終わっているか) を調べ、
問題がある場合は次のサブフォームを表示します。
最後に、セッションの中身を確認ページに表示します。

ビュースクリプトは非常にシンプルなものになります。

.. code-block:: php
   :linenos:

   <?php // registration/index.phtml ?>
   <h2>登録</h2>
   <?php echo $this->form ?>

   <?php // registration/verification.phtml ?>
   <h2>登録ありがとうございます!</h2>
   <p>
       入力された情報は次のとおりです。
   </p>

   <?
   // 入力内容はセッション名前空間に格納されているので、
   // このようにしなければなりません
   foreach ($this->info as $info):
       foreach ($info as $form => $data): ?>
   <h4><?php echo ucfirst($form) ?>:</h4>
   <dl>
       <?php foreach ($data as $key => $value): ?>
       <dt><?php echo ucfirst($key) ?></dt>
       <?php if (is_array($value)):
           foreach ($value as $label => $val): ?>
       <dd><?php echo $val ?></dd>
           <?php endforeach;
          else: ?>
       <dd><?php echo $this->escape($value) ?></dd>
       <?php endif;
       endforeach; ?>
   </dl>
   <?php endforeach;
   endforeach ?>

将来的に、Zend Framework には複数ページのフォームを
より簡単に作成するためのコンポーネントが用意される予定です。
このコンポーネントは、
セッションや各フォームの順序などの管理を抽象化したものとなります。
現時点では、複数ページのフォームをあなたのサイトで使用するには
上の例のようにするのが最も無難でしょう。


