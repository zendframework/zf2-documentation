.. _zend.view.controllers:

コントローラスクリプト
===========

``Zend_View`` のインスタンスを作成して設定を行うのがコントローラの役目です。
その後でビューに変数を代入し、
適切なスクリプトを使用して出力をレンダリングするように指示します。

.. _zend.view.controllers.assign:

変数の代入
-----

ビュースクリプトに制御を移す前に、
必要な変数をコントローラスクリプトからビューに代入しなければなりません。
通常は、ビューインスタンスのプロパティへの代入を行います。

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   $view->a = "Hay";
   $view->b = "Bee";
   $view->c = "Sea";

しかし、代入する値がすでに配列やオブジェクトの形式になっている場合は、
このような方法は面倒です。

assign() メソッドを使用すると、配列やオブジェクトの内容を
「一括して」代入できます。以下の例は、
上でひとつひとつプロパティを代入していたのと同じように動作します。

.. code-block:: php
   :linenos:

   $view = new Zend_View();

   // キー/値 の組み合わせからなる配列を作成します。
   // 変数名がキー、その変数に代入する値が配列の値となります。
   $array = array(
       'a' => "Hay",
       'b' => "Bee",
       'c' => "Sea",
   );
   $view->assign($array);

   // オブジェクトのプロパティも同じように扱えます。
   // 代入の際に、配列形式にキャストしていることに注意しましょう。
   $obj = new StdClass;
   $obj->a = "Hay";
   $obj->b = "Bee";
   $obj->c = "Sea";
   $view->assign((array) $obj);

別の方法として、assign メソッドを使用してひとつひとつ代入することもできます。
この場合は最初の引数が変数名、そしてその次に変数の値を指定します。

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   $view->assign('a', "Hay");
   $view->assign('b', "Bee");
   $view->assign('c', "Sea");

.. _zend.view.controllers.render:

ビュースクリプトのレンダリング
---------------

必要な変数にすべて値を代入したら、コントローラは ``Zend_View`` に、
適切なビュースクリプトをレンダリングするよう指示しなければなりません。
そのためには render() メソッドをコールします。
このメソッドは、ビューを表示するのではなく、
レンダリング後の結果を返すだけであることに注意しましょう。
適切な時点で、返された結果を print あるいは echo する必要があります。

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   $view->a = "Hay";
   $view->b = "Bee";
   $view->c = "Sea";
   echo $view->render('someView.php');

.. _zend.view.controllers.script-paths:

ビュースクリプトのパス
-----------

デフォルトでは、 ``Zend_View`` は、
ビュースクリプトが呼び出し元スクリプトからの相対パス上にあることを想定しています。
例えばコントローラスクリプトが "/path/to/app/controllers" にあった場合に、そこで
$view->render('someView.php') をコールすると、 ``Zend_View`` は "/path/to/app/controllers/someView.php"
を探します。

たいていの場合、ビュースクリプトはどこかほかの場所にあることは明らかでしょう。
``Zend_View`` にビュースクリプトの場所を教えるには、 setScriptPath()
メソッドを使用します。

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   $view->setScriptPath('/path/to/app/views');

こうすると、$view->render('someView.php') がコールされた場合に "/path/to/app/views/someView.php"
を探すようになります。

実は、addScriptPath() メソッドを使用すると、検索パスを
「積み重ねる」ことができます。これを使用すると、 ``Zend_View``
は一番最後に追加されたパスからビュースクリプトを探し始めます。
この仕組みを利用すると、デフォルトのビューを独自のビューで上書きできるようになります。
いくつかのビューに対して独自の「テーマ」あるいは「スキン」
を作成し、その他のビューはそのままにしておくことが可能となります。

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   $view->addScriptPath('/path/to/app/views');
   $view->addScriptPath('/path/to/custom/');

   // $view->render('booklist.php') をコールすると、Zend_View は
   // まず最初に "/path/to/custom/booklist.php" を探し、
   // 次に "/path/to/app/views/booklist.php"、そして最後に
   // カレントディレクトリから "booklist.php" を探します。

.. note::

   **ユーザの入力内容をスクリプトパスに設定してはいけません**

   ``Zend_View`` は、
   スクリプトパスを見てビュースクリプトを探したりレンダリングしたりします。
   そのため、ここに何が設定されているのかを事前にきちんと把握し、
   自分の管理下においておく必要があります。 **決して**
   ユーザの入力した内容をもとにスクリプトパスを設定などしてはいけません。
   もしそこに親ディレクトリをたどる指定などが含まれていたら、
   ローカルファイル読み込みの脆弱性の被害を受ける可能性があります。
   たとえば、次のようなスクリプトが問題を引き起こします。

   .. code-block:: php
      :linenos:

      // $_GET['foo'] == '../../../etc'
      $view->addScriptPath($_GET['foo']);
      $view->render('passwd');

   あまりにもできすぎた例に見えるかもしれませんが、
   単に起こりうる問題をわかりやすく示しただけのことです。 **どうしても**\
   ユーザの入力を使わざるを得ないのなら、
   入力をきちんとフィルタリングしてチェックし、
   アプリケーションできちんと管理できるパスが指定されていることを確認するようにしましょう。


