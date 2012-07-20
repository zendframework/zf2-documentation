.. _zend.db.profiler:

Zend_Db_Profiler
================

.. _zend.db.profiler.introduction:

導入
--

``Zend_Db_Profiler`` を使用すると、クエリの情報を取得できます。
アダプタが実際に実行したクエリの内容や実行所要時間などが取得でき、
余計なデバッグコードをクラスに追加しなくてもクエリを調べられるようになります。
さらに、条件を指定して特定のクエリだけの情報を取得することもできます。

プロファイラを有効にするには、アダプタのコンストラクタで指定するか、
あるいは後からアダプタに指示します。

.. code-block:: php
   :linenos:

   $params = array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test'
       'profiler' => true  // プロファイラを使用します。
                           // false (デフォルト) にすると無効になります。
   );

   $db = Zend_Db::factory('PDO_MYSQL', $params);

   // プロファイラを無効にします
   $db->getProfiler()->setEnabled(false);

   // プロファイラを有効にします
   $db->getProfiler()->setEnabled(true);

``profiler`` オプションの値には柔軟性があり、
その型に応じて、さまざまな形式で解釈されます。 たいていは単純な boolean
値を指定することになるでしょうが、
その他の型を指定することでプロファイラの振る舞いをカスタマイズすることも可能です。

boolean 引数 ``TRUE`` を指定すると、 プロファイラを有効にします。あるいは ``FALSE``
にすると、プロファイラを無効にします。プロファイラのクラスは、
そのアダプタのデフォルトのプロファイラクラスである ``Zend_Db_Profiler`` となります。

.. code-block:: php
   :linenos:

   $params['profiler'] = true;
   $db = Zend_Db::factory('PDO_MYSQL', $params);

プロファイラオブジェクトのインスタンスを、アダプタで使用します。
このオブジェクトの型は、 ``Zend_Db_Profiler``
あるいはそのサブクラスでなければなりません。
プロファイラを有効にするには、次にようにします。

.. code-block:: php
   :linenos:

   $profiler = MyProject_Db_Profiler();
   $profiler->setEnabled(true);
   $params['profiler'] = $profiler;
   $db = Zend_Db::factory('PDO_MYSQL', $params);

引数は連想配列で、'``enabled``'、 '``instance``' および '``class``' のいずれか
(あるいはすべて) のキーを持ちます。 '``enabled``' と '``instance``' は、 それぞれ boolean
および上で説明したインスタンスです。 '``class``'
は、独自のプロファイラを使用する場合のクラス名を指定します。 このクラスは
``Zend_Db_Profiler`` あるいはそのサブクラスでなければなりません。
このクラスは、コンストラクタに何も引数を渡さないでインスタンス化されます。
'``class``' の内容は、 '``instance``' を指定した際には無視されます。

.. code-block:: php
   :linenos:

   $params['profiler'] = array(
       'enabled' => true,
       'class'   => 'MyProject_Db_Profiler'
   );
   $db = Zend_Db::factory('PDO_MYSQL', $params);

また、引数は ``Zend_Config`` のオブジェクトで渡すこともできます。
このオブジェクトのプロパティが、先ほどの連想配列のキーと同じように解釈されます。
たとえば、次のような内容の "``config.ini``" ファイルがあったとしましょう。

.. code-block:: ini
   :linenos:

   [main]
   db.profiler.class   = "MyProject_Db_Profiler"
   db.profiler.enabled = true

この設定を適用するには、次のような *PHP* コードを書きます。

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Ini('config.ini', 'main');
   $params['profiler'] = $config->db->profiler;
   $db = Zend_Db::factory('PDO_MYSQL', $params);

'``instance``' プロパティは、次のように使用します。

.. code-block:: php
   :linenos:

   $profiler = new MyProject_Db_Profiler();
   $profiler->setEnabled(true);
   $configData = array(
       'instance' => $profiler
       );
   $config = new Zend_Config($configData);
   $params['profiler'] = $config;
   $db = Zend_Db::factory('PDO_MYSQL', $params);

.. _zend.db.profiler.using:

プロファイラの使用
---------

好きなところでアダプタの ``getProfiler()`` メソッドを使用すれば、
プロファイラを取得できます。

.. code-block:: php
   :linenos:

   $profiler = $db->getProfiler();

これは、 ``Zend_Db_Profiler`` オブジェクトのインスタンスを返します。
このインスタンスのさまざまなメソッドを使用することで、
クエリの内容を調べることができます。

- ``getTotalNumQueries()`` は、 情報を取得したクエリの総数を返します。

- ``getTotalElapsedSecs()`` は、 情報を取得したクエリの実行所要時間の合計を返します。

- ``getQueryProfiles()`` は、 すべてのクエリ情報を配列で返します。

- ``getLastQueryProfile()`` は、最後に (直近に) 実行されたクエリの情報を (そのクエリが
  完了したか否かにかかわらず) 返します
  (クエリが完了していない場合は、終了時刻が ``NULL`` となります)。

- ``clear()`` は、スタック上に残っている 過去のクエリ情報をすべて消去します。

``getLastQueryProfile()`` の返り値、および ``getQueryProfiles()`` の個々の要素は
``Zend_Db_Profiler_Query`` オブジェクトで、
これを使用すると個々のクエリ自体の情報を調べられます。

- ``getQuery()`` は、クエリの *SQL* テキストを返します。
  パラメータつきのプリペアドステートメントの場合、
  クエリがプリペアされた時点のテキストを返します。
  つまり、プレースホルダを含んだままの形式ということです。
  実行時に置き換えられた値を知ることはできません。

- ``getQueryParams()`` は、
  プリペアドクエリを実行する際に使用する、パラメータの値の配列を返します。
  ここには、バインドパラメータだけでなく ``execute()``
  メソッドへの引数も含まれます。 配列のキーは、(1 から始まる) 数値かあるいは
  (文字列の) パラメータ名となります。

- ``getElapsedSecs()`` は、 クエリの実行所要時間を返します。

``Zend_Db_Profiler`` の提供する情報は、 アプリケーションのボトルネックを調査したり
クエリをデバッグしたりする場合に有用です。
例えば、直近に実行されたクエリが実際のところどんなものだったのかを知るには次のようにします。

.. code-block:: php
   :linenos:

   $query = $profiler->getLastQueryProfile();

   echo $query->getQuery();

ページの生成に時間がかかっているとしましょう。この場合、
プロファイラを使用してまず全クエリの実行所要秒数を取得します。
それから、個々のクエリを調べ、一番時間がかかっているのはどれかを見つけます。

.. code-block:: php
   :linenos:

   $totalTime    = $profiler->getTotalElapsedSecs();
   $queryCount   = $profiler->getTotalNumQueries();
   $longestTime  = 0;
   $longestQuery = null;

   foreach ($profiler->getQueryProfiles() as $query) {
       if ($query->getElapsedSecs() > $longestTime) {
           $longestTime  = $query->getElapsedSecs();
           $longestQuery = $query->getQuery();
       }
   }

   echo '全部で ' . $queryCount . ' 件のクエリが ' . $totalTime .
        ' 秒で実行されました' . "\n";
   echo '平均の所要時間: ' . $totalTime / $queryCount . ' 秒' . "\n";
   echo '1 秒あたりのクエリ実行数: ' . $queryCount / $totalTime . "\n";
   echo '所要時間の最大値: ' . $longestTime . "\n";
   echo "一番時間のかかっているクエリ: \n" . $longestQuery . "\n";

.. _zend.db.profiler.advanced:

プロファイラの高度な使用法
-------------

単にクエリを調べるだけでなく、どのクエリを調べるのかという
条件を指定することも可能です。以下で説明するメソッドは、 ``Zend_Db_Profiler``
インスタンスのメソッドです。

.. _zend.db.profiler.advanced.filtertime:

クエリの実行所要時間による絞り込み
^^^^^^^^^^^^^^^^^

``setFilterElapsedSecs()`` は、クエリの情報を取得する条件として
実行所要時間の最小値を指定します。このフィルタを削除するには、 メソッドに
``NULL`` 値を渡します。

.. code-block:: php
   :linenos:

   // 所要時間が 5 秒以上のクエリのみ調べます
   $profiler->setFilterElapsedSecs(5);

   // 所要時間にかかわらず、すべてのクエリを調べます
   $profiler->setFilterElapsedSecs(null);

.. _zend.db.profiler.advanced.filtertype:

クエリの形式による絞り込み
^^^^^^^^^^^^^

``setFilterQueryType()`` は、クエリの情報を取得する条件として
クエリの形式を指定します。複数の形式を扱うには、それらの論理 OR を指定します。
クエリの形式は、 ``Zend_Db_Profiler``
のクラス定数として以下のように定義されています。

- ``Zend_Db_Profiler::CONNECT``: 接続操作、あるいはデータベースの選択。

- ``Zend_Db_Profiler::QUERY``: 他の形式にあてはまらないクエリ。

- ``Zend_Db_Profiler::INSERT``: 新しいデータをデータベースに追加するクエリ。 一般的には
  *SQL* の *INSERT*\ 。

- ``Zend_Db_Profiler::UPDATE``: 既存のデータを更新するクエリ。通常は *SQL* の *UPDATE*\ 。

- ``Zend_Db_Profiler::DELETE``: 既存のデータを削除するクエリ。通常は *SQL* の ``DELETE``\ 。

- ``Zend_Db_Profiler::SELECT``: 既存のデータを取得するクエリ。通常は *SQL* の *SELECT*\ 。

- ``Zend_Db_Profiler::TRANSACTION``:
  トランザクションに関する操作。例えばトランザクションの開始や
  コミット、ロールバックなど。

既存のフィルタを削除するには、 ``setFilterElapsedSecs()`` の引数に ``NULL``
だけを渡します。

.. code-block:: php
   :linenos:

   // SELECT クエリのみを調べます
   $profiler->setFilterQueryType(Zend_Db_Profiler::SELECT);

   // SELECT、INSERT そして UPDATE クエリを調べます
   $profiler->setFilterQueryType(Zend_Db_Profiler::SELECT |
                                 Zend_Db_Profiler::INSERT |
                                 Zend_Db_Profiler::UPDATE);

   // DELETE クエリを調べます
   $profiler->setFilterQueryType(Zend_Db_Profiler::DELETE);

   // すべてのフィルタを削除します
   $profiler->setFilterQueryType(null);

.. _zend.db.profiler.advanced.getbytype:

クエリの型を指定することによる情報の取得
^^^^^^^^^^^^^^^^^^^^

``setFilterQueryType()`` を使用すると、 生成される情報を減らすことができます。
すべての情報を保持しておくほうがよい場合もありますが、
普通はそのときに必要な情報のみが見られればよいでしょう。 ``getQueryProfiles()``
のもうひとつの機能として、 最初の引数にクエリの型 (あるいは複数の型の論理和)
を指定することによるその場での絞り込みが可能です。
クエリの型を表す定数については :ref:`この節 <zend.db.profiler.advanced.filtertype>`
を参照ください。

.. code-block:: php
   :linenos:

   // SELECT クエリの情報のみを取得します
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::SELECT);

   // SELECT、INSERT そして UPDATE クエリの情報のみを取得します
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::SELECT |
                                           Zend_Db_Profiler::INSERT |
                                           Zend_Db_Profiler::UPDATE);

   // DELETE クエリの情報を取得します
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::DELETE);

.. _zend.db.profiler.profilers:

特化型のプロファイラ
----------

特化型のプロファイラは ``Zend_Db_Profiler`` を継承したオブジェクトです。
プロファイリング情報を特別な方法で処理します。

.. include:: zend.db.profiler.firebug.rst

