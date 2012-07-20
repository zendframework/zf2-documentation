.. _zend.view.scripts:

ビュースクリプト
========

コントローラが変数を代入して ``render()`` をコールすると、
指定されたビュースクリプトを ``Zend_View`` が読み込み、 ``Zend_View``
インスタンスのスコープでそれを実行します。したがって、 ビュースクリプトの中で
$this を参照すると、 実際には ``Zend_View`` のインスタンスを指すことになります。

コントローラからビューに代入された変数は、
ビューインスタンスのプロパティとして参照できます。例えば、 コントローラで変数
'something' を代入したとすると、 ビュースクリプト内ではそれを $this->something
で取得できます (これにより、どの値がコントローラから代入されたもので、
どの値がスクリプト内部で作成されたものなのかを追いかけられるようになります)。

``Zend_View`` の導入の部分で示したビュースクリプトの例を思い出してみましょう。

.. code-block:: php
   :linenos:

   <?php if ($this->books): ?>

       <!-- 本の一覧 -->
       <table>
           <tr>
               <th>著者</th>
               <th>タイトル</th>
           </tr>

           <?php foreach ($this->books as $key => $val): ?>
           <tr>
               <td><?php echo $this->escape($val['author']) ?></td>
               <td><?php echo $this->escape($val['title']) ?></td>
           </tr>
           <?php endforeach; ?>

       </table>

   <?php else: ?>

       <p>表示する本がありません。</p>

   <?php endif;?>

.. _zend.view.scripts.escaping:

出力のエスケープ
--------

ビュースクリプトで行うべき仕事のうち最も重要なもののひとつは、
出力を適切にエスケープすることです。これは、
クロスサイトスクリプティング攻撃を防ぐのを助けます。
それ自身がエスケープを行ってくれるような関数、メソッド、
あるいはヘルパーを使用しているのでない限り、
変数を出力する際には常にそれをエスケープしなければなりません。

``Zend_View`` の escape() というメソッドが、このエスケープを行います。

.. code-block:: php
   :linenos:

   // ビュースクリプトの悪い例
   echo $this->variable;

   // ビュースクリプトのよい例
   echo $this->escape($this->variable);

デフォルトでは、escape() メソッドは *PHP* の htmlspecialchars()
関数でエスケープを行います。しかし環境によっては、
別の方法でエスケープしたくなることもあるでしょう。 コントローラから setEscape()
メソッドを実行することで、 エスケープに使用するコールバックを ``Zend_View``
に通知できます。

.. code-block:: php
   :linenos:

   // Zend_View のインスタンスを作成します
   $view = new Zend_View();

   // エスケープに htmlentities を使用するように通知します
   $view->setEscape('htmlentities');

   // あるいは、クラスの静的メソッドを使用するように通知します
   $view->setEscape(array('SomeClass', 'methodName'));

   // あるいは、インスタンスメソッドを指定することもできます
   $obj = new SomeClass();
   $view->setEscape(array($obj, 'methodName'));

   // そして、ビューをレンダリングします
   echo $view->render(...);

コールバック関数あるいはメソッドは、
エスケープする値を最初のパラメータとして受け取ります。
それ以外のパラメータはオプションとなります。

.. _zend.view.scripts.templates:

別のテンプレートシステムの使用
---------------

*PHP* 自身も強力なテンプレートシステムではありますが、
開発者の多くは、デザイナにとっては高機能すぎる/複雑すぎる
と感じており、別のテンプレートエンジンをほしがっているようです。 ``Zend_View``
では、そのような目的のために二種類の仕組みを提供します。
ビュースクリプトを使用することによるものと、 ``Zend_View_Interface``
実装することによるものです。

.. _zend.view.scripts.templates.scripts:

ビュースクリプトを使用したテンプレートシステム
^^^^^^^^^^^^^^^^^^^^^^^

ビュースクリプトを使用して、PHPLIB 形式のテンプレートのような
別のテンプレートオブジェクトのインスタンスを作成し、
それを操作できます。ビュースクリプトをこのように使用する方法は、
以下のようになります。

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

関連するテンプレートファイルは、このようになります。

.. code-block:: html
   :linenos:

   <!-- booklist.tpl -->
   <table>
       <tr>
           <th>著者</th>
           <th>タイトル</th>
       </tr>
       {books}
   </table>

   <!-- eachbook.tpl -->
       <tr>
           <td>{author}</td>
           <td>{title}</td>
       </tr>

   <!-- nobooks.tpl -->
   <p>表示する本がありません。</p>

.. _zend.view.scripts.templates.interface:

Zend_View_Interface を使用したテンプレート
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_View``
互換のテンプレートエンジンを使用するほうが簡単だという人もいるでしょう。
``Zend_View_Interface`` では、
互換性を保つために最低限必要なインターフェイスを定義しています。

.. code-block:: php
   :linenos:

   /**
    * テンプレートエンジンオブジェクトを返します
    */
   public function getEngine();

   /**
    * ビュースクリプト/テンプレートへのパスを設定します
    */
   public function setScriptPath($path);

   /**
    * すべてのビューリソースへのベースパスを設定します
    */
   public function setBasePath($path, $prefix = 'Zend_View');

   /**
    * ビューリソースへのベースパスを追加します
    */
   public function addBasePath($path, $prefix = 'Zend_View');

   /**
    * 現在のスクリプトのパスを取得します
    */
   public function getScriptPaths();

   /**
    * テンプレート変数をオブジェクトのプロパティとして代入するためのオーバーロードメソッド
    */
   public function __set($key, $value);
   public function __isset($key);
   public function __unset($key);

   /**
    * テンプレート変数を手動で代入したり、複数の変数を
    * 一括設定したりします
    */
   public function assign($spec, $value = null);

   /**
    * 代入済みのテンプレート変数を削除します
    */
   public function clearVars();

   /**
    * $name というテンプレートをレンダリングします
    */
   public function render($name);

このインターフェイスを使用すると、
サードパーティのテンプレートエンジンをラップして ``Zend_View``
互換のクラスを作成することが簡単になります。 例として、Smarty
用のラッパーはこのようになります。

.. code-block:: php
   :linenos:

   class Zend_View_Smarty implements Zend_View_Interface
   {
       /**
        * Smarty object
        * @var Smarty
        */
       protected $_smarty;

       /**
        * コンストラクタ
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
        * テンプレートエンジンオブジェクトを返します
        *
        * @return Smarty
        */
       public function getEngine()
       {
           return $this->_smarty;
       }

       /**
        * テンプレートへのパスを設定します
        *
        * @param string $path パスとして設定するディレクトリ
        * @return void
        */
       public function setScriptPath($path)
       {
           if (is_readable($path)) {
               $this->_smarty->template_dir = $path;
               return;
           }

           throw new Exception('無効なパスが指定されました');
       }

       /**
        * 現在のテンプレートディレクトリを取得します
        *
        * @return string
        */
       public function getScriptPaths()
       {
           return array($this->_smarty->template_dir);
       }

       /**
        * setScriptPath へのエイリアス
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
        * setScriptPath へのエイリアス
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
        * 変数をテンプレートに代入します
        *
        * @param string $key 変数名
        * @param mixed $val 変数の値
        * @return void
        */
       public function __set($key, $val)
       {
           $this->_smarty->assign($key, $val);
       }

       /**
        * empty() や isset() のテストが動作するようにします
        *
        * @param string $key
        * @return boolean
        */
       public function __isset($key)
       {
           return (null !== $this->_smarty->get_template_vars($key));
       }

       /**
        * オブジェクトのプロパティに対して unset() が動作するようにします
        *
        * @param string $key
        * @return void
        */
       public function __unset($key)
       {
           $this->_smarty->clear_assign($key);
       }

       /**
        * 変数をテンプレートに代入します
        *
        * 指定したキーを指定した値に設定します。あるいは、
        * キー => 値 形式の配列で一括設定します
        *
        * @see __set()
        * @param string|array $spec 使用する代入方式 (キー、あるいは キー => 値 の配列)
        * @param mixed $value (オプション) 名前を指定して代入する場合は、ここで値を指定します
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
        * 代入済みのすべての変数を削除します
        *
        * Zend_View に {@link assign()} やプロパティ
        * ({@link __get()}/{@link __set()}) で代入された変数をすべて削除します
        *
        * @return void
        */
       public function clearVars()
       {
           $this->_smarty->clear_all_assign();
       }

       /**
        * テンプレートを処理し、結果を出力します
        *
        * @param string $name 処理するテンプレート
        * @return string 出力結果
        */
       public function render($name)
       {
           return $this->_smarty->fetch($name);
       }
   }

この例では、 ``Zend_View`` ではなく ``Zend_View_Smarty`` クラスのインスタンスを作成し、
それを使用して ``Zend_View`` と同じようなことをしています。

.. code-block:: php
   :linenos:

   //例 1. InitializerのinitView()で
   $view = new Zend_View_Smarty('/path/to/templates');
   $viewRenderer =
       Zend_Controller_Action_HelperBroker::getStaticHelper('ViewRenderer');
   $viewRenderer->setView($view)
                ->setViewBasePathSpec($view->_smarty->template_dir)
                ->setViewScriptPathSpec(':controller/:action.:suffix')
                ->setViewScriptPathNoControllerSpec(':action.:suffix')
                ->setViewSuffix('tpl');

   //例 2. アクションコントローラでも同様に...
   class FooController extends Zend_Controller_Action
   {
       public function barAction()
       {
           $this->view->book   = 'Zend PHP 5 Certification Study Guide';
           $this->view->author = 'Davey Shafik and Ben Ramsey'
       }
   }

   //例 3. アクションコントローラでのビューの初期化
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


