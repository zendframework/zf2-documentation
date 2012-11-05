.. EN-Revision: none
.. _performance.view:

ビューのレンダリング
==========

Zend Frameworkの *MVC*\ レイヤを使うときには、 ``Zend_View``\
を使うようになる機会があります。 ``Zend_View``\ は、
他のビューやテンプレートエンジンに比べて良く機能します。 ビュースクリプトは
*PHP*\ で記述されているので、 *PHP*\
にカスタムで加えたコンパイルのオーバーヘッドを招きませんし、 コンパイルされた
*PHP*\ が最適されていないかどうか心配する必要もありません。 しかしながら、
``Zend_View``\ には特有の問題があります:
エクステンションはオーバーロード経由で実行されます（ビューヘルパ）。
ビューヘルパの多くは重要な機能を担っていますが、 性能面でのコストもあります。

.. _performance.view.pluginloader:

どのようにしたらビューヘルパの解決を速くできますか？
--------------------------

ほとんどの ``Zend_View``\ の "メソッド" は、
実際ヘルパ方式でオーバーロード経由で提供されています。 これのおかげで
``Zend_View`` に重要な柔軟性が与えられています; ``Zend_View``
を拡張してアプリケーションで利用するであろう、
すべてのヘルパメソッドを提供する必要の代わりに、
分離されたクラスにヘルパメソッドを定義して、 まるで ``Zend_View``
そのもののメソッドであるかのように使い切ることができます。
このおかげでビューオブジェクト自身は比較的身軽に保たれ、
オブジェクトが必要なときだけ生成されることが保証されます。

内部的には、 ``Zend_View``\ はヘルパクラスを探すために :ref:`プラグインローダー
<zend.loader.pluginloader>`\ を使います。 これはヘルパを呼び出すたびに ``Zend_View``\
がプラグインローダーに ヘルパ名を渡す必要があることを意味しています。
プラグインローダーはそれからクラス名を決定し、
必要に応じてクラスファイルを読み込み、
さらにインスタンス化されるかもしれないクラス名を返します。
読み込まれたヘルパを ``Zend_View``\ が内部のレジストリに保持するので、
その次にヘルパを使うときにはより速くなります。
ただし、多くのヘルパを使うと呼び出しは増加します。

それでは質問です: どのようにしたらヘルパの解決を速くできますか？

.. _performance.view.pluginloader.cache:

ファイルキャッシュを含むプラグインローダーを使う
^^^^^^^^^^^^^^^^^^^^^^^^

最も簡単で安く済む方法は :ref:`プラグインのパフォーマンスの向上
<performance.classloading.pluginloader>`\ と同じです: プラグインローダーは
:ref:`includeファイルキャッシュ <zend.loader.pluginloader.performance.example>`\ を使います。
不確かな証拠によれば、
この技術のおかげでopcodeキャッシュがないシステム上では25から30%の、
opcodeキャッシュがあるシステム上では40から65%の利得があるそうです。

.. _performance.view.pluginloader.extend:

よく使われるヘルパメソッドを提供するようにZend_Viewを拡張する
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

さらにもっと性能を調整することを探求する他の方法は、
アプリケーションで最も使うヘルパメソッドを手動で ``Zend_View``\
に付加して拡張することです。
そのようなヘルパは簡単に適切なヘルパクラスを手動でインスタンス化して、
その代わりとなり、 あるいはメソッドに完全なヘルパ実装を詰め込みます。

.. code-block:: php
   :linenos:

   class My_View extends Zend_View
   {
       /**
        * @var array 使われたヘルパクラスのレジストリ
        */
       protected $_localHelperObjects = array();

       /**
        * urlビューヘルパの代替
        *
        * @param  array $urlOptions ルートオブジェクトを組み立てるメソッドへ渡されるオプション
        * @param  mixed $name 使用するルート名. nullの場合は現行ルートを使う。
        * @param  bool $reset それら提供されるデフォルトルートをリセットするか否か
        * @return string linkのhref属性のためのUrl
        */
       public function url(array $urlOptions = array(), $name = null,
           $reset = false, $encode = true
       ) {
           if (!array_key_exists('url', $this->_localHelperObjects)) {
               $this->_localHelperObjects['url'] = new Zend\View_Helper\Url();
               $this->_localHelperObjects['url']->setView($this);
           }
           $helper = $this->_localHelperObjects['url'];
           return $helper->url($urlOptions, $name, $reset, $encode);
       }

       /**
        * メッセージを返す
        *
        * 直接実装
        *
        * @param  string $string
        * @return string
        */
       public function message($string)
       {
           return "<h1>" . $this->escape($message) . "</h1>\n";
       }
   }

この技術はプラグインローダーの呼び出しを完全に避けたり、
オートローディングの恩恵を受けたり、 あるいはまったくそれを迂回したり、
いずれかの方法でヘルパシステムのオーバーヘッドを十分に減らすでしょう。

.. _performance.view.partial:

どのようにしたらビューを部分的に高速化できますか？
-------------------------

部分的に頻繁に利用したり、アプリケーションのプロファイルを実行したりする人は、
しばしばすぐにビューオブジェクトのクローンを必要とすることになっている、
``partial()``
ビューヘルパがオーバーヘッドの大部分を占めていることに気付くでしょう。
これを速度向上させられるでしょうか？

.. _performance.view.partial.render:

本当に必要な時だけpartial()を使う
^^^^^^^^^^^^^^^^^^^^^

``partial()`` ビューヘルパには３つの引数があります:

- ``$name``: レンダリングするビュースクリプトの名前

- ``$module``: 表示スクリプトが位置するモジュールの名前;
  または３番目の引数が渡されない場合、配列またはオブジェクトで、 ``$model``\ 引数

- ``$model``:
  ビューにアサインする純粋なデータを示す部分に渡す配列またはオブジェクト

``partial()`` の威力や使い道は２番目と３番目の引数に依存します。 ``$module``
引数のおかげで partialビュースクリプトがモジュールを解決するために、
与えられたモジュールに ``partial()`` が一時的にスクリプトパスを追加できる。;
``$model``
引数のおかげでpartialビューを使うために引数を明示的に渡すことができます。
もしどちらの引数も渡さないのならば、 **替わりに** ``render()`` を使ってください！

基本的に、あなたが実際に変数をその部分に渡して、純粋な変数の範囲を必要とするか、
または他の *MVC*\ モジュールからビュースクリプトをレンダリングするまで、
``partial()``\ のオーバーヘッドを受け入れる理由がありません。;
その代わり、ビュースクリプトをレンダリングするために、 ``Zend_View``\ 組込みの
``render()``\ メソッドを使ってください。

.. _performance.view.action:

どのようにしたらアクションメソッドのビューヘルパの呼び出しを速くできますか？
--------------------------------------

バージョン1.5.0で ``action()`` ビューヘルパが導入されました。 それにより *MVC*\
のアクションをディスパッチして、
レンダリングされたコンテンツを入手できるようになります。 これは *DRY*\
原則に向かう重要なステップで、コードの再利用を促します。
しかしながら、アプリケーションをプロファイルする人がすぐ実感するように、
これも高くつく操作です。 内部的に、 ``action()``
ビューヘルパでは新しいリクエスト及びレスポンスオブジェクトを複製して、
ディスパッチャを呼び出し、求められたコントローラとアクションなどを呼び出す必要があります。

どうしたら速くできるでしょう？

.. _performance.view.action.actionstack:

可能な場合はアクションスタックを使う
^^^^^^^^^^^^^^^^^^

``action()`` ビューヘルパと同時期に導入されましたが、 :ref:`アクションスタック
<zend.controller.actionhelpers.actionstack>`
はアクションヘルパとフロントコントローラプラグインから成り立ちます。
共に、それらのおかげでディスパッチサイクルの間に呼び出すべき、
追加のアクションをスタックに押し込むことができます。
もしレイアウトビュースクリプトから ``action()`` を呼び出しているなら、
アクションスタックを使うかわりに、
ディスクリートなレスポンスセグメントにビューをレンダリングしたいかもしれません。
例えば、各画面にログインフォームの枠を付け加える下記の様な ``dispatchLoopStartup()``
プラグインを書けるでしょう。:

.. code-block:: php
   :linenos:

   class LoginPlugin extends Zend\Controller_Plugin\Abstract
   {
       protected $_stack;

       public function dispatchLoopStartup(
           Zend\Controller_Request\Abstract $request
       ) {
           $stack = $this->getStack();
           $loginRequest = new Zend\Controller_Request\Simple();
           $loginRequest->setControllerName('user')
                        ->setActionName('index')
                        ->setParam('responseSegment', 'login');
           $stack->pushStack($loginRequest);
       }

       public function getStack()
       {
           if (null === $this->_stack) {
               $front = Zend\Controller\Front::getInstance();
               if (!$front->hasPlugin('Zend\Controller_Plugin\ActionStack')) {
                   $stack = new Zend\Controller_Plugin\ActionStack();
                   $front->registerPlugin($stack);
               } else {
                   $stack = $front->getPlugin('ActionStack')
               }
               $this->_stack = $stack;
           }
           return $this->_stack;
       }
   }

それから ``UserController::indexAction()`` メソッドは
レンダリングするのがどのレスポンスセグメントかを示す ``$responseSegment``
パラメータを使うかもしれません。
レイアウトスクリプトでそのレスポンスセグメントを単純にレンダリングするでしょう。

.. code-block:: php
   :linenos:

   <?php $this->layout()->login ?>

アクションスタックがまだディスパッチサイクルを必要とするのに対して、
オブジェクトを複製して内部状態をリセットする必要がないので、 ``action()``
ビューヘルパよりもっと安くつきます。 さらに、それはすべてのプレディスパッチ、
またはポストディスパッチのプラグインが呼び出されることを保証します。
それは、特別なアクションのために *ACL*\
を処理するフロントコントローラプラグインをもし使っているなら、
特別に関心があることかもしれません。

.. _performance.view.action.model:

action()を通じてモデルに問い合わせるお好みヘルパ
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

ほとんどの場合、 ``action()`` を使うのは過剰です。
もしモデルの中に業務ロジックをはなはだしく折り重ねていて、
モデルに単純に問い合わせて、ビュースクリプトに結果を渡すなら、
モデルを引き出してきて問合せを行い、
その情報で何かを行うビューヘルパを単純に書くことが、
一般的により速くて誤りがないでしょう。

ひとつの例として、下記のようなコントローラーアクションと
ビュースクリプトを考えてみましょう:

.. code-block:: php
   :linenos:

   class BugController extends Zend\Controller\Action
   {
       public function listAction()
       {
           $model = new Bug();
           $this->view->bugs = $model->fetchActive();
       }
   }

   // bug/list.phtml:
   echo "<ul>\n";
   foreach ($this->bugs as $bug) {
       printf("<li><b>%s</b>: %s</li>\n",
           $this->escape($bug->id),
           $this->escape($bug->summary)
       );
   }
   echo "</ul>\n";

それから ``action()`` を使って、 下記のようにして呼び出すでしょう:

.. code-block:: php
   :linenos:

   <?php $this->action('list', 'bug') ?>

これは下記のように見えるビューヘルパにリファクタリングできるでしょう。:

.. code-block:: php
   :linenos:

   class My_View_Helper_BugList extends Zend\View_Helper\Abstract
   {
       public function bugList()
       {
           $model = new Bug();
           $html  = "<ul>\n";
           foreach ($model->fetchActive() as $bug) {
               $html .= sprintf(
                   "<li><b>%s</b>: %s</li>\n",
                   $this->view->escape($bug->id),
                   $this->view->escape($bug->summary)
               );
           }
           $html .= "</ul>\n";
           return $html;
       }
   }

それからヘルパを下記のように呼び出すでしょう:

.. code-block:: php
   :linenos:

   <?php $this->bugList() ?>

これには２つの利点があります: それはもはや ``action()``
ビューヘルパのオーバーヘッドを受けず、 より意味的に理解できる *API*\
も表現します。


