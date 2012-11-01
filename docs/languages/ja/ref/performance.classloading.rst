.. EN-Revision: none
.. _performance.classloading:

クラスの読み込み
========

Zend Frameworkアプリケーションのプロファイルをとってみた人は誰でも、 Zend
Frameworkではクラスの読み込みが比較的高くつくことにすぐ気がつくでしょう。
多くのコンポーネントのために読み込まれる必要があるクラスファイルの本当の数、
クラス名とファイルシステムとの間に１対１の関係が成立しないプラグインの利用、
``include_once()`` や ``require_once()`` などの呼び出し、
これらの間には検討の余地があり得ます。
この章ではこれらの問題に対して確立したいくつかの解決方法を提示するつもりです。

.. _performance.classloading.includepath:

どのようにしたらinclude_pathを最適化できますか？
------------------------------

クラスの読み込み速度を向上させるためにできる、
ささやかな最適化のひとつはinclude_pathに注意をはらうことです。
特に４つのことをすべきでしょう:
絶対パスを使うこと（または相対パスを絶対パスに変えること）、
定義したincludeパスの数を減らすこと、 include_pathにZend
Frameworkをできる限り先に設定すること、
そして現行ディレクトリパスをinclude_pathの最後にだけincludeすることです。

.. _performance.classloading.includepath.abspath:

絶対パスを使う
^^^^^^^

これは些細な最適化に見えますが、 実は、やらなければ *PHP*\
のrealpathキャッシュの恩恵がほとんど受けられません。
結果として、あなたが期待するようにはopcodeキャッシュもほとんど動作しません。

このことを確かめる易しい方法が２つあります。 ひとつはパスを ``php.ini``\ や
``httpd.conf``\ 、 もしくは ``.htaccess``\ でハードコーディングすることです。
もうひとつは *PHP*\ の ``realpath()`` 関数を使ってinclude_pathを設定することです:

.. code-block:: php
   :linenos:

   $paths = array(
       realpath(dirname(__FILE__) . '/../library'),
       '.',
   );
   set_include_path(implode(PATH_SEPARATOR, $paths);

とある絶対パスとの関連性がある限り、 相対パスを使用することが **できます**\ 。

.. code-block:: php
   :linenos:

   define('APPLICATION_PATH', realpath(dirname(__FILE__)));
   $paths = array(
       APPLICATION_PATH . '/../library'),
       '.',
   );
   set_include_path(implode(PATH_SEPARATOR, $paths);

しかしながらそうであっても、 ``realpath()``
にパスを単純に渡すことが一般的にありふれたやり方でしょう。

.. _performance.classloading.includepath.reduce:

定義したincludeパスの数を減らす
^^^^^^^^^^^^^^^^^^^

includeパスはinclude_pathに記載された順番にスキャンされます。
ファイルが後からではなく最初のほうのスキャンで見つかれば、
結果を早く得られることをこのことは明らかに意味します。
従って、やや分かりやすい高速化方法は、
include_path上のパスの数を必要とするものだけに単純に減らすことです。
定義したinclude_pathそれぞれを精査して、
アプリケーションで使われるパスに何らかの機能が実際にあるのか判断してください。
もし無いのであれば削除してください。

他の最適化にはパスの合併があります。 例えば、Zend Frameworkは *PEAR*\
の命名規則に従っています。 そのため、もし *PEARの*\ ライブラリを使うなら、
（または *PEARの*\ 命名規則に従うほかのフレームワークやライブラリを使うなら）
それらすべてのライブラリを同じinclude_pathに入れてみてください。
１つ以上のライブラリを共通のディレクトリにsymlinkでまとめるのと同じくらい簡単に、
しばしば目標に達することができます。

.. _performance.classloading.includepath.early:

Zend Frameworkのinclude_pathを出来るだけ先に定義する
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

前述の提案に引き続き、 Zend
Frameworkのパスをinclude_pathの中でできる限り先に定義することも明らかな別の最適化です。
多くの場合、そのリストの中の一番最初のパスになるでしょう。 このことにより、
Zend Frameworkからincludeされるファイルが最初のスキャンで見つかることを保証します。

.. _performance.classloading.includepath.currentdir:

現行ディレクトリは最後に定義するか、または定義しない
^^^^^^^^^^^^^^^^^^^^^^^^^^

ほとんどの例でinclude_pathに現行ディレクトリ、つまり '.' が見受けられます。
スクリプトを必要とするファイルとしては、
同じディレクトリにあるスクリプトを確実に読み込めるので便利です。
しかしながら同じくそれらの例では、
現行ディレクトリが一般的にinclude_pathの最初の要素として見つかります。
このことは現行ディレクトリの配下がいつも最初にスキャンされることを意味しています。
Zend Frameworkアプリケーションでは多くの場合望ましくありません。
間違いなく現行ディレクトリはリストの最後の要素に入れても良いでしょう。

.. _performance.classloading.includepath.example:

.. rubric:: 例: 最適化されたinclude_path

それではこれらすべての提案を一緒に実施してみましょう。 仮にZend
Frameworkと一緒にひとつ以上の *PEAR* ライブラリを使っていると仮定します。
ひっとするとPHPUnitや ``Archive_Tar``\ ライブラリかもしれませんし、
場合によっては現行のファイルに関連してincludeする必要のあるファイルかもしれません。

初めに、プロジェクト内にライブラリのディレクトリを作成します。
ディレクトリの中にはZend Frameworkの ``library/Zend`` ディレクトリをsymlinkで設定し、
同様にインストールした *PEAR*\ から必要なディレクトリを設定します。

.. code-block:: php
   :linenos:

   library
       Archive/
       PEAR/
       PHPUnit/
       Zend/

これで必要に応じて共有ライブラリをそのままに保ちながら、
独自のライブラリのコードを追加できるようになります。

次に ``public/index.php`` ファイルで予定通りinclude_pathを作成します。
これでinclude_pathを毎回編集しなくても、
コードをファイルシステム内で移動させることができます。

それぞれの提案のアイデアは上記から取り入れています。: 絶対パスを使います。
``realpath()`` を使う判断がされています。; include_pathの先のほうでZend
Frameworkをincludeします。; さらにまたinclude_pathを併合します。;
そして現行ディレクトリをパスの最後にします。
思い切って本当にうまくするとこのようになります。
結果としてパス２つだけに到達します。

.. code-block:: php
   :linenos:

   $paths = array(
       realpath(dirname(__FILE__) . '/../library'),
       '.'
   );
   set_include_path(implode(PATH_SEPARATOR, $paths));

.. _performance.classloading.striprequires:

どのようにしたら不要なrequire_once文を除去できますか？
---------------------------------

Lazy loadingとは、
高くつくクラスファイルの読み込み操作をできるだけ最後の時にさせるように構想された最適化技術です。
つまり、クラスのオブジェクトのインスタンス化、
静的なクラスメソッドの呼び出し、
あるいはクラスの定数や静的プロパティを参照するときです。 これは *PHP*\
ではオートローディングを通じてサポートされます。 それにより、
クラス名をファイルに紐付けるために実行するひとつ以上のcallback関数を定義できます。

しかしながら、 ライブラリのコードがまだ ``require_once()``\
呼び出しを行なっているなら、
オートローディングから受け取るであろう利益のほとんどは失われます。 Zend
Frameworkの場合もまさにその通りです。 そこで質問があります:
オートローダーの性能を最大化するために、 それらの ``require_once()``\
呼び出しをどのようにしたら除去できるでしょう？

.. _performance.classloading.striprequires.sed:

findおよびsedコマンドを使ってrequire_onceの呼び出しを取り去る
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``require_once()``\ 呼び出しを除去する簡単な方法は、 *UNIX*\
のユーティリテイーのfindとsedコマンドを組み合わせて、
各呼び出し箇所をコメントアウトすることです。
下記の命令を試しに実行してみてください。 ('%'記号はシェルプロンプトを示します):

.. code-block:: console
   :linenos:

   % cd path/to/ZendFramework/library
   % find . -name '*.php' -not -wholename '*/Loader/Autoloader.php' \
     -not -wholename '*/Application.php' -print0 | \
     xargs -0 sed --regexp-extended --in-place 's/(require_once)/\/\/ \1/g'

(読みやすくするために２行に分けていますが) この一行コマンドは各 *PHP*\
ファイルを繰り返し処理しながら、 'require_once' を '// require_once' で置換し、
効果的にその命令をコメントアウトします (``Zend_Application`` と ``Zend\Loader\Autoloader``
の中にある ``require_once`` はそのままにしてあります。
そうしないと処理が失敗するからです)。

製品のアプリケーションの性能向上を助けるために、
このコマンドは自動化されたビルドやリリース工程にささやかに付け加えられます。
しかしながら、もしこの技術を使う場合は、 オートローディングを使わ
**なければいけない**\ 、 ということを記載しておかなければいけません。;
"``public/index.php``"ファイルで下記のコードを記述することにより実施できます。

.. code-block:: php
   :linenos:

   require_once 'Zend/Loader/Autoloader.php';
   Zend\Loader\Autoloader::getInstance();

.. _performance.classloading.pluginloader:

どのようにしたらプラグインの読み込みを速く出来ますか？
---------------------------

多くのコンポーネントにはプラグインがあり、 Zend
Frameworkとともに出荷された既存の標準プラグインを上書きして、
そのコンポーネントで利用する独自のクラスを作成できます。
このことにより、さほどの犠牲を払わなくても、
フレームワークに重要な柔軟性が得られます。:
プラグインローディングはある程度高くつく作業です。

プラグインローダーによりクラスのプレフィックスやパスのペアを登録したり、
標準的ではないパスでクラスファイルを指定できます。
各プレフィックスはそれに関連した複数のパスを持つことができます。
内部的にはプラグインローダーは各プレフィックスごとに繰り返して、
各パスをそれに追加し、ファイルが存在するかどうか、
およびそのパスが読み込み可能かどうかをテストします。
読み込むと探しているクラスが利用可能かどうかテストします。
そのためご想像の通り、
ファイルシステム上で多数のstat呼び出しが引き起こされます。

プラグインローダーを使うコンポーネントの数によってこれをどんどん増やしてください。
そしてこの問題の範囲のアイデアが得られます。
この文章を記載した時点では、下記のコンポーネントがプラグインローダーを使います。

- ``Zend\Controller_Action\HelperBroker``: ヘルパ

- ``Zend\File\Transfer``: アダプタ

- ``Zend\Filter\Inflector``: フィルタ (ViewRendererアクションヘルパおよび ``Zend_Layout``
  に使用されます)

- ``Zend\Filter\Input``: フィルタおよびバリデータ

- ``Zend_Form``: 要素、バリデータ、フィルタ、
  デコレータ、キャプチャ、ファイル転送アダプタ

- ``Zend_Paginator``: アダプタ

- ``Zend_View``: ヘルパ、フィルタ

どのようにしたらそのような生成された呼び出しの数を減らせますか？

.. _performance.classloading.pluginloader.includefilecache:

ファイルキャッシュを含むプラグインローダーを使う
^^^^^^^^^^^^^^^^^^^^^^^^

Zend Frameworkの1.7.0でプラグインローダーにincludeファイルキャッシュが
追加されました。 この機能は"``include_once()``"呼び出しをファイルに書き出します。
そのファイルはブートストラップでincludeできます。 これは追加の ``include_once()``\
呼び出しをコードに導入しますが、
またそのことはプラグインローダーができるだけ早く結果を戻すことを保証します。

プラグインローダーのドキュメントに :ref:`その使い方の完全な例があります
<zend.loader.pluginloader.performance.example>`\ 。


