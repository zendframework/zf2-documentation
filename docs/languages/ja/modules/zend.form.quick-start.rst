.. EN-Revision: none
.. _zend.form.quickstart:

Zend_Form クイックスタート
==================

このクイックスタートガイドでは、 ``Zend_Form``
を用いたフォームの作成や検証、そしてレンダリングについての基本を扱います。

.. _zend.form.quickstart.create:

フォームオブジェクトの作成
-------------

フォームオブジェクトを作成するのは非常に簡単で、 単に ``Zend_Form``
のインスタンスを作成するだけです。

.. code-block:: php
   :linenos:

   $form = new Zend_Form;

より高度に使いこなす際には ``Zend_Form``
のサブクラスを作成することになるかもしれません。
しかし、単純なフォームの場合は ``Zend_Form``
オブジェクトをそのまま使えばプログラム上でフォームを作成できます。

フォームのアクションやメソッドを指定したい場合は (普通はするでしょうね)、
``setAction()`` メソッドおよび ``setMethod()`` メソッドを使用します。

.. code-block:: php
   :linenos:

   $form->setAction('/resource/process')
        ->setMethod('post');

このコードは、フォームのアクションをパーシャル *URL*"``/resource/process``"
に設定し、メソッドに *HTTP* *POST*
を指定します。これは、最終的なレンダリングの際に反映されます。

さらに、 **<form>** タグ用のその他の *HTML* 属性を設定することもできます。
その場合は ``setAttrib()`` メソッドあるいは ``setAttribs()`` メソッド使用します。
たとえば id を指定したい場合は、"``id``" 属性を使用します。

.. code-block:: php
   :linenos:

   $form->setAttrib('id', 'login');

.. _zend.form.quickstart.elements:

フォームへの要素の追加
-----------

要素がなければフォームには何の意味もありません。 ``Zend_Form``
にデフォルトで組み込まれている要素を使用すると、 ``Zend_View`` ヘルパーを用いて
*XHTML* 形式でレンダリングできます。 以下のような要素が組み込まれています。

- button

- checkbox (あるいは複数チェックボックスを一度にレンダリングする multiCheckbox)

- hidden

- image

- password

- radio

- reset

- select (通常のものと複数選択形式のものの両方)

- submit

- text

- textarea

フォームに要素を追加するには、二通りの方法があります。
フォーム要素のインスタンスを作成してそのオブジェクトを渡す方法と、
単に要素の型だけを渡して ``Zend_Form``
にその型のオブジェクトを作成させる方法です。

いくつか例を示します。

.. code-block:: php
   :linenos:

   // 要素のインスタンスを作成してフォームオブジェクトに渡します
   $form->addElement(new Zend_Form_Element_Text('username'));

   // フォーム要素の型をフォームオブジェクトに渡します
   $form->addElement('text', 'username');

デフォルトでは、バリデータやフィルタは一切含まれません。
つまり、追加した要素に対して最低でもバリデータを指定し、
おそらくフィルタも指定しなければならないということです。 これは、(a)
要素をフォームに追加する前に行う、 (b) ``Zend_Form``
で要素を作成する際のオプションで指定する、 あるいは (c)
要素を追加した後でフォームオブジェクトから要素を取り出し、 それを設定する
のいずれかの方法で行います。

まずは要素のインスタンスにバリデータを追加する例を見てみましょう。
``Zend_Validate_*`` オブジェクトそのものを渡すか、
あるいは使用するバリデータの名前を渡すことになります。

.. code-block:: php
   :linenos:

   $username = new Zend_Form_Element_Text('username');

   // Zend_Validate_* オブジェクトを渡します
   $username->addValidator(new Zend_Validate_Alnum());

   // バリデータ名を渡します
   $username->addValidator('alnum');

2 番目の方法を使用する場合、
もしバリデータのコンストラクタに引数を指定するのならば それを配列形式で 3
番目のパラメータとして指定します。

.. code-block:: php
   :linenos:

   // 正規表現パターンを渡します
   $username->addValidator('regex', false, array('/^[a-z]/i'));

(2 番目のパラメータの意味は、
このバリデータの検証に失敗した場合にそれ以降のバリデータの実行を防止するか否かを表します。
デフォルトではこの設定は ``FALSE`` です)

特定の要素を必須項目として指定したいこともあるでしょう。
その場合は、アクセサメソッドで指定するか、
要素を作成する際のオプションとして指定します。
ここでは前者の方法の例を示します。

.. code-block:: php
   :linenos:

   // この要素は必須です
   $username->setRequired(true);

要素が必須な場合は、'NotEmpty' バリデータが
バリデータチェインの先頭に追加されます。
これで、必須要素には値が入力されていることが保証されます。

フィルタの登録方法は、基本的にはバリデータと同じです。
例として、最終的な値を小文字変換するフィルタを追加してみましょう。

.. code-block:: php
   :linenos:

   $username->addFilter('StringtoLower');

これまでの内容をまとめると、要素の設定はこのようになります。

.. code-block:: php
   :linenos:

   $username->addValidator('alnum')
            ->addValidator('regex', false, array('/^[a-z]/'))
            ->setRequired(true)
            ->addFilter('StringToLower');

   // あるいは、もうすこしコンパクトに書くなら
   $username->addValidators(array('alnum',
           array('regex', false, '/^[a-z]/i')
       ))
       ->setRequired(true)
       ->addFilters(array('StringToLower'));

シンプルといえばシンプルですが、
フォームのすべての要素についてこれを行うというのも
ちょっと面白くありません。上で説明した (b) の方法を試してみましょう。
``Zend_Form::addElement()``
をファクトリメソッドとして使用して新しい要素を作成する際に、
設定オプションを渡すことができます。
たとえば、使用するバリデータやフィルタをここで指定することが可能です。
先ほどと同じ設定を行うには、次のように書きます。

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

   同じオプションを指定した要素をいろんな場所で使用するような場合は、
   ``Zend_Form_Element`` のサブクラスを作成してそれを使用するといいでしょう。
   長い目で見れば、そのほうがタイピング量を軽減できます。

.. _zend.form.quickstart.render:

フォームのレンダリング
-----------

フォームのレンダリングの方法は簡単です。 ほとんどの要素は ``Zend_View``
ヘルパーを用いて自身のレンダリングを行うので、
ビューオブジェクトが必要となります。 それ以外の方法としては、フォームの render()
メソッドを使う方法と単純に echo する方法があります。

.. code-block:: php
   :linenos:

   // 明示的に render() をコールし、オプションでビューオブジェクトを渡します
   echo $form->render($view);

   // 事前に setView() でビューオブジェクトが設定されているものとします
   echo $form;

デフォルトでは、 ``Zend_Form`` と ``Zend_Form_Element`` は ``ViewRenderer``
が初期化したビューオブジェクトを使おうと試みます。 つまり、Zend Framework の *MVC*
を使用している場合は、自分でビューを設定する必要はないということです。
フォームをビュースクリプト内でレンダリングするには、
単に次のように書くだけです。

.. code-block:: php
   :linenos:

   <?php echo $this->form ?>

水面下では、 ``Zend_Form`` は "デコレータ" を用いてレンダリングを行っています。
このデコレータが、コンテンツの置換や 先頭 (あるいは末尾)
へのコンテンツの追加、 その他コンテンツに対する操作を行うことになります。
複数のデコレータを組み合わせることで、 さまざまな効果を適用できます。
デフォルトでは、 ``Zend_Form_Element`` は 4
つのデコレータを組み合わせて出力を行います。
その設定は、次のようになっています。

.. code-block:: php
   :linenos:

   $element->addDecorators(array(
       'ViewHelper',
       'Errors',
       array('HtmlTag', array('tag' => 'dd')),
       array('Label', array('tag' => 'dt')),
   ));

(<HELPERNAME> は使用しているビューヘルパーの名前で、 これは要素によって異なります)

上の設定で出力した結果は次のようになります。

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

(フォーマットは異なるかもしれません)

出力を変えたい場合は、その要素で使用するデコレータを変更することもできます。
詳細な情報は、デコレータのセクションを参照ください。

フォームオブジェクトが各要素を順に処理し、 *HTML* **<form>**
タグの中に出力していきます。
フォームを設定した際に指定したアクションとメソッドが **<form>**
タグに設定されます。 また同時に、 ``setAttribs()``
系のメソッドで設定した属性もここで設定されます。

要素の処理は、登録した順に行われます。 要素の中に order
属性が指定されている場合は、 そこで指定した順に従います。 order
を指定するには次のようにします。

.. code-block:: php
   :linenos:

   $element->setOrder(10);

あるいは、要素を作成する際にオプションとして指定します。

.. code-block:: php
   :linenos:

   $form->addElement('text', 'username', array('order' => 10));

.. _zend.form.quickstart.validate:

フォームの妥当性の検証
-----------

フォームが送信されたら、
その内容をチェックしてバリデーションを通過したかどうかを確認しなければなりません。
各要素に入力されたデータについてチェックを行います。
要素名にマッチするキーが存在しない場合、
もしその項目が必須指定されているのなら ``NULL``
値が指定されたものとしてバリデーションを行います。

データはどこから取得するのでしょう? たとえば *$_POST* や *$_GET*\
、あるいはその他のデータソース (ウェブサービスへのリクエストなど) からです。

.. code-block:: php
   :linenos:

   if ($form->isValid($_POST)) {
       // 成功!
   } else {
       // 失敗!
   }

*AJAX* リクエストの場合は、特定の要素や要素群だけを検証することもあります。
``isValidPartial()`` はフォームの一部を検証します。 しかし、 ``isValid()``
とは異なり、キーが存在しない場合はその要素のバリデーションを行いません。

.. code-block:: php
   :linenos:

   if ($form->isValidPartial($_POST)) {
       // 存在する要素はすべてバリデーションに通過しました
   } else {
       // いくつかの要素がバリデーションに失敗しました
   }

さらに、 ``processAjax()`` メソッドでもフォームの一部の検証を行うことができます。
``isValidPartial()`` とは異なり、 このメソッドでは失敗時のエラーメッセージを *JSON*
形式の文字列で返します。

バリデーションを通過したとしましょう。
これで、フィルタリング済みの値を取得できるようになりました。

.. code-block:: php
   :linenos:

   $values = $form->getValues();

フィルタリング前の値を取得したい場合は次のようにします。

.. code-block:: php
   :linenos:

   $unfiltered = $form->getUnfilteredValues();

If you on the other hand need all the valid and filtered values of a partially valid form, you can call:

.. code-block:: php
   :linenos:

   $values = $form->getValidValues($_POST);

.. _zend.form.quickstart.errorstatus:

エラー情報の取得
--------

バリデーションに失敗したらどうしたらいいのでしょう?
たいていの場合は、フォームを再度レンダリングすることになるでしょう。
デフォルトのデコレータを使用している場合は、
エラーメッセージも表示されるようになります。

.. code-block:: php
   :linenos:

   if (!$form->isValid($_POST)) {
       echo $form;

       // あるいは、ビューオブジェクトを代入してビューをレンダリングします...
       $this->view->form = $form;
       return $this->render('form');
   }

エラーの内容を調べるには二通りの方法があります。 ``getErrors()``
は、要素名とコードを対応させた連想配列を返します
(コードは、エラーコードの配列となります)。 ``getMessages()``
は、要素名とメッセージを対応させた連想配列を返します
(メッセージは、エラーコードとエラーメッセージを対応させた連想配列となります)。
エラーが発生していない要素については、 結果の配列には含められません。

.. _zend.form.quickstart.puttingtogether:

まとめ
---

では、シンプルなログイン画面を作ってみましょう。
この画面では、以下の項目に対応する要素が必要となります。

- ユーザ名

- パスワード

- 送信ボタン

今回の例では、ユーザ名として使用できるのは英数字のみであるとします。
また、最初は必ず英字であること、長さは 6 文字から 20
文字までの間であることとし、
入力された内容はすべて小文字に変換することにします。 パスワードは 6
文字以上でなければならないようにします。 We'll simply toss the submit value when done, so it
can remain unvalidated.

``Zend_Form`` のオプションを駆使して、 フォームを作成してみましょう。

.. code-block:: php
   :linenos:

   $form = new Zend_Form();
   $form->setAction('/user/login')
        ->setMethod('post');

   // username 要素を作成・設定します
   $username = $form->createElement('text', 'username');
   $username->addValidator('alnum')
            ->addValidator('regex', false, array('/^[a-z]+/'))
            ->addValidator('stringLength', false, array(6, 20))
            ->setRequired(true)
            ->addFilter('StringToLower');

   // password 要素を作成・設定します
   $password = $form->createElement('password', 'password');
   $password->addValidator('StringLength', false, array(6))
            ->setRequired(true);

   // 要素をフォームに追加します
   $form->addElement($username)
        ->addElement($password)
        // addElement() をファクトリとして使用して 'Login' ボタンを作成します
        ->addElement('submit', 'login', array('label' => 'Login'));

次に、これを処理するためのコントローラを作成します。

.. code-block:: php
   :linenos:

   class UserController extends Zend_Controller_Action
   {
       public function getForm()
       {
           // 先ほどのようなフォームを作成します
           return $form;
       }

       public function indexAction()
       {
           // user/form.phtml をレンダリングします
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
               // バリデーションに失敗したので、フォームを再描画します
               $this->view->form = $form;
               return $this->render('form');
           }

           $values = $form->getValues();
           // ここで認証処理を行います
       }
   }

フォームを表示するためのビュースクリプトは次のようになります。

.. code-block:: php
   :linenos:

   <h2>Please login:</h2>
   <?php echo $this->form ?>

コントローラのコードをご覧になってお気づきの通り、
やるべき作業がまだ残っています。 入力された内容が妥当な形式であったとしても、
たとえば ``Zend_Auth`` などを用いた認証処理が必要です。

.. _zend.form.quickstart.config:

Zend_Config オブジェクトの使用法
----------------------

``Zend_Form`` のすべてのクラスは ``Zend_Config`` を用いて設定できます。
コンストラクタに ``Zend_Config`` オブジェクトを渡すか、あるいは ``setConfig()``
を使用して渡すことになります。先ほどのようなフォームを *INI*
ファイルを用いて作成できないかどうかを検討してみましょう。 First, let's follow the
recommendations, and place our configurations into sections reflecting the release location, and focus on the
'development' section. 次に、指定したコントローラ ('user') 用のセクションとフォーム
('login') 用のキーを作成します。

.. code-block:: ini
   :linenos:

   [development]
   ; フォーム全般のメタ情報
   user.login.action = "/user/login"
   user.login.method = "post"

   ; username 要素
   user.login.elements.username.type = "text"
   user.login.elements.username.options.validators.alnum.validator = "alnum"
   user.login.elements.username.options.validators.regex.validator = "regex"
   user.login.elements.username.options.validators.regex.options.pattern = "/^[a-z]/i"
   user.login.elements.username.options.validators.strlen.validator = "StringLength"
   user.login.elements.username.options.validators.strlen.options.min = "6"
   user.login.elements.username.options.validators.strlen.options.max = "20"
   user.login.elements.username.options.required = true
   user.login.elements.username.options.filters.lower.filter = "StringToLower"

   ; password 要素
   user.login.elements.password.type = "password"
   user.login.elements.password.options.validators.strlen.validator = "StringLength"
   user.login.elements.password.options.validators.strlen.options.min = "6"
   user.login.elements.password.options.required = true

   ; submit 要素
   user.login.elements.submit.type = "submit"

そしてこれをフォームのコンストラクタに渡します。

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Ini($configFile, 'development');
   $form   = new Zend_Form($config->user->login);

これでフォームの定義が完了しました。

.. _zend.form.quickstart.conclusion:

結論
--

ここまで読み進めてこられたみなさんは、 ``Zend_Form``
のさまざまな機能を駆使するだけの準備ができたことでしょう。
さらに詳細な情報に進んでいきましょう!


