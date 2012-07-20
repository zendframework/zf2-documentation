.. _zend.view.introduction:

導入
==

``Zend_View`` は、モデル - ビュー - コントローラ パターンにおける
「ビュー」として働くクラスです。
ビューのスクリプトを、モデルおよびコントローラから分離するために存在します。
このクラスでは、
ヘルパーシステム、出力のフィルタリングおよび変数のエスケープ機能を提供します。

``Zend_View`` は、テンプレートシステムに対しては特にこだわりはありません。
テンプレート言語として *PHP* を使用するか、
あるいは他のテンプレートエンジンのインスタンスを作成して、
それをビュースクリプトの中で操作できます。

基本的に、 ``Zend_View`` を使用する際には 2 つの段階をとることになります。 1.
コントローラスクリプトが ``Zend_View`` のインスタンスを作成し、
そのインスタンスに変数を代入します。 2. コントローラが ``Zend_View``
に対して適切なビューをレンダリングするように指示し、
それによってコントローラがビュースクリプトを制御します。
そこでビューの出力が作成されます。

.. _zend.view.introduction.controller:

コントローラスクリプト
-----------

単純な例として、本の一覧を扱うコントローラがあることにしましょう。
そのデータをビューに表示することを考えます。
コントローラスクリプトは、おそらくこのようになるでしょう。

.. code-block:: php
   :linenos:

   // 本の著者およびタイトルを取得するためにモデルを使用します
   $data = array(
       array(
           'author' => 'Hernando de Soto',
           'title' => 'The Mystery of Capitalism'
       ),
       array(
           'author' => 'Henry Hazlitt',
           'title' => 'Economics in One Lesson'
       ),
       array(
           'author' => 'Milton Friedman',
           'title' => 'Free to Choose'
       )
   );

   // 本のデータを Zend_View インスタンスに代入します
   Zend_Loader::loadClass('Zend_View');
   $view = new Zend_View();
   $view->books = $data;

   // "booklist.php" というビュースクリプトをレンダリングします
   echo $view->render('booklist.php');

.. _zend.view.introduction.view:

ビュースクリプト
--------

次に必要なのは、関連付けるビュースクリプト "booklist.php" です。 これは一般的な
*PHP* スクリプトと同じですが、ひとつだけ違いがあります。 ``Zend_View``
インスタンスのスコープで実行されるということです。 つまり $this への参照は、
``Zend_View`` のインスタンスのプロパティやメソッドを指すことになるのです
(コントローラによってインスタンスに代入された変数は、 ``Zend_View`` インスタンスの
public プロパティとなります)。
したがって、基本的なビュースクリプトはこのようになります。

.. code-block:: php
   :linenos:

    if ($this->books): ?>

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

変数の出力時に、"escape()"
メソッドでエスケープ処理をしていることに注意しましょう。

.. _zend.view.introduction.options:

オプション
-----

``Zend_View`` のオプションを設定すると、
ビュースクリプトの振る舞いを変更できます。

- ``basePath`` は
  スクリプトやヘルパー、そしてフィルタを配置する基底パスを指定します。
  次のようなディレクトリ構成を想定しています。

  .. code-block:: php
     :linenos:

     base/path/
         helpers/
         filters/
         scripts/

  これを設定するには ``setBasePath()`` か ``addBasePath()``\
  、あるいはコンストラクタのオプション ``basePath`` を使用します。

- ``encoding`` は ``htmlentities()`` や ``htmlspecialchars()``
  などで使用する文字エンコーディングを表します。 デフォルトは ISO-8859-1 (latin1)
  です。 ``setEncoding()`` か、コンストラクタのオプション ``encoding`` で設定します。

- ``escape`` は ``escape()`` で使用するコールバックを表します。 ``setEscape()``
  か、コンストラクタのオプション ``escape`` で設定します。

- ``filter``
  は、ビュースクリプトをレンダリングした後で使用するフィルタを表します。
  ``setFilter()`` か ``addFilter()``\ 、 あるいはコンストラクタのオプション ``filter``
  で設定します。

- ``strictVars:`` は、初期化していない変数に ``Zend_View`` からアクセスしようとした際に
  notice や warning を発生させるようにします。 ``strictVars(true)``
  か、あるいはコンストラクタのオプション ``strictVars`` で設定します。

.. _zend.view.introduction.shortTags:

ビュースクリプトでの短いタグ
--------------

我々が用意する例では、 *PHP* の長いタグ **<?php** を用います。 我々はまた、
`制御構造に関する別の構文`_\ の使用に賛成します。
これらはビュースクリプトを書く際に便利なものです。
より簡潔に書くことができ、文を１行にまとめられ、 *HTML*
内で括弧を捜す必要を削減するからです。

以前の版では、ビュー・スクリプトをわずかにより冗長にしないように、
我々はしばしば短いタグ (**<?** 及び **<?=**)を使うことを推奨しました。
しかしながら、 ``php.ini`` の ``short_open_tag``
設定のデフォルト値は製品において、または共有ホストでは一般的にオフです。
その結果、それらの使用は全く移植可能ではありません。 もしビュースクリプト内で
*XML* のテンプレート、 短い形式の開始タグは検証エラーの元となります。 結局、
``short_open_tag`` がオフの時に短いタグを使うと、
ビュー・スクリプトはエラーを起こすか、または単純にビューアーに *PHP*
コードを返します。

もしもこれらの警告にもかかわらず、「短いタグを使いたいけれど設定でそれが無効になっている」
場合は、次のいずれかの方法を使用します。

- 短いタグを、 ``.htaccess`` ファイルで有効にします。

  .. code-block:: apache
     :linenos:

     php_value "short_open_tag" "on"

  これは、 ``.htaccess`` ファイルの作成と使用を許可されている場合にのみ可能です。
  この項目は、 ``httpd.conf`` ファイルに記述することもできます。

- オプションのストリームラッパーを有効にして、
  短いタグを逐次長いタグに変換します。

  .. code-block:: php
     :linenos:

     $view->setUseStreamWrapper(true);

  これは、 ``Zend_View_Stream``
  をビュースクリプトのストリームラッパーとして登録します。
  そして、まるで短いタグが有効になっているかのようにコードを動作させることができます。

.. warning::

   **ビューストリームラッパーによるパフォーマンスの低下**

   ストリームラッパーを使用すると、アプリケーションのパフォーマンスは
   **おそらく** 低下するでしょう。
   しかし、実際のところどれくらい低下するのかについては
   はっきりと数値化することはできません。 短いタグを有効にしてしまうか、
   スクリプトを書き換えてすべて完全なタグにしてしまう、
   あるいはコンテンツのキャッシュをうまく行うなどの対策を推奨します。

.. _zend.view.introduction.accessors:

ユーティリティメソッド
-----------

通常は、 ``assign()`` と ``render()``\ 、
あるいはフィルタ、ヘルパー、スクリプトのパス用の設定メソッドだけで十分事足りるでしょう。
しかし、 ``Zend_View`` を独自に拡張したい場合や
その内部にアクセスしたい場合のために、さらにいくつかのメソッドを用意しています。

- ``getVars()`` は、設定されているすべての変数を返します。

- ``clearVars()`` は、すべての変数の値を消去します。
  ビュースクリプトを再利用する際に、
  これまで使用していた変数を残しておきたいときなどに便利です。

- ``getScriptPath($script)`` は、指定したビュースクリプトのパスを取得します。

- ``getScriptPaths()`` は、登録されているすべてのスクリプトパスを取得します。 script
  paths.

- ``getHelperPath($helper)`` は、指定したヘルパークラスのパスを取得します。

- ``getHelperPaths()`` は、登録されているすべてのヘルパーパスを取得します。

- ``getFilterPath($filter)`` は、指定したフィルタクラスのパスを取得します。

- ``getFilterPaths()`` は、登録されているすべてのフィルタパスを取得します。



.. _`制御構造に関する別の構文`: http://www.php.net/manual/ja/control-structures.alternative-syntax.php
