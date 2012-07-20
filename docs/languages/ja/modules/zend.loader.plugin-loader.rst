.. _zend.loader.pluginloader:

プラグインのロード
=========

Zend Framework の多くのコンポーネントはプラグイン方式を採用しており、
クラスのプレフィックスとクラスファイルへのパスを指定して動的に機能を読み込むことができます。
このファイルは *include_path* にある必要がなく、
また標準の命名規約に従っている必要もありません。 ``Zend_Loader_PluginLoader``
は、この処理のための共通機能を提供します。

*PluginLoader* の基本的な使用法は Zend Framework
の命名規約に従った形式です。各クラスを個別のファイルに分けて、
アンダースコアをディレクトリ区切り文字としてパスを解決します。
オプションのクラスプレフィックスを指定して、
特定のプラグインクラスをロードする際の先頭にそれを付加できます。
また、パスの検索は LIFO (後入れ先出し) 方式で行います。 LIFO
方式の検索とクラスプレフィックスを用いることで、
プラグインに独自の名前空間を指定できます。
そして、事前に登録されているプラグインを上書きできるようになります。

.. _zend.loader.pluginloader.usage:

基本的な使用例
-------

次のようなディレクトリ構造とクラスファイル群の構成を考えてみましょう。
トップディレクトリと library ディレクトリは include_path
に含まれているものとします。

.. code-block:: text
   :linenos:

   application/
       modules/
           foo/
               views/
                   helpers/
                       FormLabel.php
                       FormSubmit.php
           bar/
               views/
                   helpers/
                       FormSubmit.php
   library/
       Zend/
           View/
               Helper/
                   FormLabel.php
                   FormSubmit.php
                   FormText.php

では、プラグインローダーを作成してビューヘルパー群の場所を指定しましょう。

.. code-block:: php
   :linenos:

   $loader = new Zend_Loader_PluginLoader();
   $loader->addPrefixPath('Zend_View_Helper', 'Zend/View/Helper/')
          ->addPrefixPath('Foo_View_Helper',
                          'application/modules/foo/views/helpers')
          ->addPrefixPath('Bar_View_Helper',
                          'application/modules/bar/views/helpers');

こうしておけば、クラス名のプレフィックスを除いた部分を指定するだけで
ビューヘルパーをロードできるようになります。

.. code-block:: php
   :linenos:

   // 'FormText' ヘルパーをロードします
   $formTextClass = $loader->load('FormText'); // 'Zend_View_Helper_FormText';

   // 'FormLabel' ヘルパーをロードします
   $formLabelClass = $loader->load('FormLabel'); // 'Foo_View_Helper_FormLabel'

   // 'FormSubmit' ヘルパーをロードします
   $formSubmitClass = $loader->load('FormSubmit'); // 'Bar_View_Helper_FormSubmit'

クラスを読み込めたら、次はそのインスタンスを作成します。

.. note::

   時には、同じプレフィックスを複数のパスで使用することもあるかもしれません。
   ``Zend_Loader_PluginLoader``
   は、実際には各プレフィックスに対応するパスを配列で管理しています。
   そして、最後に登録されたパスから順に検索を行います。 これは、incubator
   のコンポーネントを使用する場合などに便利です。

.. note::

   **インスタンス作成時のパスの定義**

   プレフィックスとパス (あるいはプレフィックスと複数のパス) のペアの配列を、
   オプションのパラメータとしてコンストラクタに渡すことができます。

   .. code-block:: php
      :linenos:

      $loader = new Zend_Loader_PluginLoader(array(
          'Zend_View_Helper' => 'Zend/View/Helper/',
          'Foo_View_Helper'  => 'application/modules/foo/views/helpers',
          'Bar_View_Helper'  => 'application/modules/bar/views/helpers'
      ));

``Zend_Loader_PluginLoader`` には、
複数のプラグインの間でオブジェクトを共有する機能もあります。
その際にシングルトンインスタンスを作成する必要はありません。
この機能は、静的レジストリを用いて実現しています。
インスタンスを作成する際に、 コンストラクタの 2
番目のパラメータでレジストリを指定します。

.. code-block:: php
   :linenos:

   // プラグインを静的レジストリ 'foobar' に保存します
   $loader = new Zend_Loader_PluginLoader(array(), 'foobar');

*PluginLoader* がインスタンス化したその他のコンポーネントで
このレジストリ名を使用すると、すでに読み込まれているパスやプラグインを使用できます。

.. _zend.loader.pluginloader.paths:

プラグインのパスの操作
-----------

先ほどのセクションの例では、プラグインローダーでパスを追加する方法を示しました。
では、すでに読み込まれているパスを調べたりそれを削除したりしたい場合は、
いったいどうすればいいのでしょうか?

- ``getPaths($prefix = null)`` は、 *$prefix* を省略した場合は すべてのパスをプレフィックス
  / パスのペアで返します。 *$prefix* を指定した場合は、
  そのプレフィックスに対応するパスのみを返します。

- ``clearPaths($prefix = null)`` は、 デフォルトですべての登録済みパスをクリアします。
  *$prefix* を指定した場合は、
  そのプレフィックスに関連づけられたパスが登録されている場合にそれだけをクリアします。

- ``removePrefixPath($prefix, $path = null)`` は、
  指定したプレフィックスに関連づけられた特定のパスを削除します。 *$path*
  を省略した場合は、 そのプレフィックスのすべてのパスを削除します。 *$path*
  を指定した場合は、 そのパスが存在すればそのパスだけを削除します。

.. _zend.loader.pluginloader.checks:

プラグインの確認とクラス名の取得
----------------

時には、プラグインクラスがロードされているかどうかを調べてから何かを行いたいこともあるでしょう。
``isLoaded()`` は、プラグイン名を受け取ってその状態を返します。

*PluginLoader* の使用法としてもうひとつよくあるのが、
読み込まれているクラスの完全なクラス名を調べることです。 ``getClassName()``
がこの機能を実現しています。 一般に、これは ``isLoaded()``
と組み合わせて使用します。

.. code-block:: php
   :linenos:

   if ($loader->isLoaded('Adapter')) {
       $class   = $loader->getClassName('Adapter');
       $adapter = call_user_func(array($class, 'getInstance'));
   }

.. _zend.loader.pluginloader.performance:

プラグインのパフォーマンスの向上
----------------

プラグインの読み込みは、非常に重い操作となりえます。
まず各プレフィックスについてループ処理をする必要があり、
各プレフィックス上のパスをすべて調べ、
期待通りのクラスに対応するファイルを探すという操作になるからです。
ファイルは存在するもののそこでクラスが定義されていないといった場合は *PHP*
のエラースタックにエラーが追加されますが、 これもまた負荷のかかる操作です。
ここで問題となるのが「プラグイン機能の柔軟性を保ちつつ
パフォーマンスも向上させるにはどうすればいいか？」ということです。

``Zend_Loader_PluginLoader`` では、このような場合のためのオプトイン機能として
ファイルインクルードキャッシュを提供しています。
これを有効にすると、インクルードに成功したすべてのファイルを含む
単一のファイルを作成します。起動ファイルからこれをコールできます。
この方式を使用すると、実運用サーバ上でのパフォーマンスが劇的に向上します。

.. _zend.loader.pluginloader.performance.example:

.. rubric:: PluginLoader クラスのファイルインクルードキャッシュの使用法

クラスファイルのインクルードキャッシュを使用するには、
次のコードを起動ファイルに追加します。

.. code-block:: php
   :linenos:

   $classFileIncCache = APPLICATION_PATH .  '/../data/pluginLoaderCache.php';
   if (file_exists($classFileIncCache)) {
       include_once $classFileIncCache;
   }
   Zend_Loader_PluginLoader::setIncludeFileCache($classFileIncCache);

もちろん、パスやファイル名は必要に応じて変更することになります。
このコードはできるだけ早い段階で実行されるようにしなければなりません。
そうすることで、プラグイン機構をもつコンポーネントが確実にキャッシュを使用できるようにします。

開発段階ではキャッシュを無効にしたいこともあるでしょう。
その方法のひとつとしては、ある設定項目を切り替えることで
プラグインローダーがキャッシュするかしないかを指定するというものがあります。

.. code-block:: php
   :linenos:

   $classFileIncCache = APPLICATION_PATH .  '/../data/pluginLoaderCache.php';
   if (file_exists($classFileIncCache)) {
       include_once $classFileIncCache;
   }
   if ($config->enablePluginLoaderCache) {
       Zend_Loader_PluginLoader::setIncludeFileCache($classFileIncCache);
   }

これを使えば、コードを直接変更しなくても設定ファイルだけの変更だけですませることができます。


