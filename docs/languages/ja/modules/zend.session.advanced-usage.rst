.. EN-Revision: none
.. _zend.session.advanced_usage:

高度な使用法
======

基本的な使用法の例で Zend Framework のセッションを完全に使用できますが、
よりよい方法もあります。ここでは、セッションの処理方法や ``Zend_Session``
コンポーネントのより行動な使用法を説明します。

.. _zend.session.advanced_usage.starting_a_session:

セッションの開始
--------

すべてのリクエストで ``Zend_Session`` の機能を使用してセッション管理したい場合は、
起動ファイルでセッションを開始します。

.. _zend.session.advanced_usage.starting_a_session.example:

.. rubric:: グローバルセッションの開始

.. code-block:: php
   :linenos:

   Zend_Session::start();

起動ファイルでセッションを開始する際には、
ヘッダがブラウザに送信される前に確実にセッションが始まるようにします。
そうしないと例外が発生してしまい、おそらくユーザが見るページは崩れてしまうでしょう。
さまざまな高度な機能を使用するには、まず ``Zend_Session::start()`` が必要です
(高度な機能の詳細については後で説明します)。

``Zend_Session`` を使用してセッションを開始する方法は四通りありますが、
そのうち二つは間違った方法です。

. 間違い: *PHP* の `session.auto_start`_ を有効にしてはいけません。 もし mod_php
  (やそれと同等のもの) を使用しており、 *php.ini*
  でこの設定が有効になっている、かつそれを無効にすることができない
  という場合は、 *.htaccess* ファイル (通常は *HTML* のドキュメントルートにあります)
  に以下の内容を追加します。

  .. code-block:: apache
     :linenos:

     php_value session.auto_start 0

. 間違い: *PHP* の `session_start()`_ 関数を直接使用してはいけません。 ``session_start()``
  を直接使用した後で ``Zend_Session_Namespace`` を使用した場合は、 ``Zend_Session::start()``
  が例外 ("session has already been started") をスローします。 ``Zend_Session_Namespace``
  を使用するか 明示的に ``Zend_Session::start()`` で開始した後で ``session_start()``
  をコールすると、 *E_NOTICE* が発生し、そのコールは無視されます。

. 正解: ``Zend_Session::start()`` を使用します。
  すべてのリクエストでセッションを使用したい場合は、
  この関数コールを起動コードの最初のほうで無条件に記述します。
  セッションにはある程度のオーバーヘッドがあります。
  セッションを使用したいリクエストとそうでないリクエストがある場合は、

  - 起動コード内で、 ``Zend_Session::setOptions()`` を使用して 無条件にオプション *strict*
    を ``TRUE`` にします。

  - セッションを必要とするリクエスト内で、 ``Zend_Session_Namespace``
    のインスタンスを作成する前に ``Zend_Session::start()`` をコールします。

  - 通常どおり、必要に応じて "*new Zend_Session_Namespace()*" を使用します。事前に
    ``Zend_Session::start()`` がコールされていることを確認しておきましょう。

  *strict* オプションにより、 *new Zend_Session_Namespace()* が自動的に ``Zend_Session::start()``
  でセッションを開始することがなくなります。
  したがって、このオプションを使用すると、アプリケーションの開発者が
  特定のリクエストにはセッションを使用しないという設計をおこなうことができます。
  このオプションを使用すると、明示的に ``Zend_Session::start()`` をコールする前に
  Zend_Session_Namespace のインスタンスを作成しようとしたときに例外がスローされます。
  開発者は、 ``Zend_Session::setOptions()``
  の使用がユーザにどれだけの影響を与えるかを注意するようにしましょう。
  これらのオプションは (もととなる ext/session のオプションと同様)、
  全体に副作用を及ぼすからです。

. 正解: 必要に応じて ``Zend_Session_Namespace`` のインスタンスを作成します。 *PHP*
  のセッションは、自動的に開始されます。
  これはもっともシンプルな使用法で、たいていの場合にうまく動作します。
  しかし、デフォルトであるクッキーベースのセッション (強く推奨します)
  を使用している場合には、 *PHP* がクライアントに何らかの出力 (`HTTP ヘッダ`_ など)
  をする **前に**\ 、確実に 最初の *new Zend_Session_Namespace()*
  をコールしなければなりません。 詳細は :ref:`
  <zend.session.global_session_management.headers_sent>` を参照ください。

.. _zend.session.advanced_usage.locking:

セッション名前空間のロック
-------------

セッション名前空間をロックし、
それ以降その名前空間のデータに手を加えられないようにできます。
特定の名前空間を読み取り専用にするには ``lock()`` を、そして
読み取り専用の名前空間を読み書きできるようにするには ``unLock()`` を使用します。
``isLocked()`` を使用すると、
その名前空間がロックされているかどうかを調べることができます。
このロックは一時的なものであり、そのリクエスト内でのみ有効となります。
名前空間をロックしても、その名前空間に保存されているオブジェクトの
セッターメソッドには何の影響も及ぼしません。
しかし、名前空間自体のセッターメソッドは使用できず、
名前空間に直接格納されたオブジェクトの削除や置換ができなくなります。同様に、
``Zend_Session_Namespace`` のインスタンスをロックしたとしても、
同じデータをさすシンボルテーブルの使用をとめることはできません (`PHP
のリファレンスについての説明`_\ も参照ください)。

.. _zend.session.advanced_usage.locking.example.basic:

.. rubric:: セッション名前空間のロック

.. code-block:: php
   :linenos:

   $userProfileNamespace = new Zend_Session_Namespace('userProfileNamespace');

   // このセッションに読み取り専用ロックをかけます
   $userProfileNamespace->lock();

   // 読み取り専用ロックを解除します
   if ($userProfileNamespace->isLocked()) {
       $userProfileNamespace->unLock();
   }

.. _zend.session.advanced_usage.expiration:

名前空間の有効期限
---------

名前空間およびその中の個々のキーについて、その寿命を制限できます。
これは、たとえばリクエスト間で一時的な情報を渡す際に使用します。
これにより、認証内容などの機密情報へアクセスできないようにし、
セキュリティリスクを下げます。有効期限の設定は経過秒数によって決めることもできますし、
"ホップ" 数によって決めることもできます。ホップ数とは、
一連のリクエストの回数を表します。

.. _zend.session.advanced_usage.expiration.example:

.. rubric:: 有効期限切れの例

.. code-block:: php
   :linenos:

   $s = new Zend_Session_Namespace('expireAll');
   $s->a = 'apple';
   $s->p = 'pear';
   $s->o = 'orange';

   $s->setExpirationSeconds(5, 'a'); // キー "a" だけは 5 秒で有効期限切れとなります

   // 名前空間全体は、5 "ホップ" で有効期限切れとなります
   $s->setExpirationHops(5);

   $s->setExpirationSeconds(60);
   // "expireAll" 名前空間は、60 秒が経過するか
   // 5 ホップに達するかのどちらかが発生した時点で
   // "有効期限切れ" となります

現在のリクエストで期限切れになったデータを扱うにあたり、
データを取得する際には注意が必要です。
データは参照で返されますが、それを変更したとしても
期限切れのデータを現在のリクエストから持ち越すことはできません。 有効期限を
"リセット" するには、取得したデータをいったん一時変数に格納し、
名前空間上の内容を削除し、あらためて適切なキーで再設定します。

.. _zend.session.advanced_usage.controllers:

コントローラでのセッションのカプセル化
-------------------

名前空間を使用すると、コントローラによるセッションへのアクセスの際に
変数の汚染を防ぐこともできます。
たとえば、認証コントローラでは、セキュリティの観点から
そのセッション状態データを他のコントローラとは別に管理することになるでしょう。

.. _zend.session.advanced_usage.controllers.example:

.. rubric:: コントローラでの名前空間つきセッションによる有効期限の管理

次のコードは、質問を表示するコントローラの一部です。
ここでは論理型の変数を用意して、質問に対する回答を受け付けるかどうかを表しています。
この場合は、表示されている質問に 300 秒以内に答えることになります。

.. code-block:: php
   :linenos:

   // ...
   // 質問を表示するコントローラ
   $testSpace = new Zend_Session_Namespace('testSpace');
   // この変数にだけ有効期限を設定します
   $testSpace->setExpirationSeconds(300, 'accept_answer');
   $testSpace->accept_answer = true;
   //...

次に、回答を処理するコントローラを示します。
時間内に回答したかどうかをもとにして、回答を受け付けるかどうかを判断しています。

.. code-block:: php
   :linenos:

   // ...
   // 回答を処理するコントローラ
   $testSpace = new Zend_Session_Namespace('testSpace');
   if ($testSpace->accept_answer === true) {
       // 時間内
   }
   else {
       // 時間切れ
   }
   // ...

.. _zend.session.advanced_usage.single_instance:

名前空間内あたりのインスタンス数をひとつに絞り込む
-------------------------

:ref:`セッションのロック <zend.session.advanced_usage.locking>`
を利用すれば、名前空間つきセッションデータを予期せず使用してしまうことはある程度防げます。
しかし、 ``Zend_Session_Namespace`` には、
単一の名前空間内で複数のインスタンスを作成することを防ぐ機能もあります。

この機能を有効にするには、 ``Zend_Session_Namespace``
のインスタンスを作成する際に、コンストラクタの第二引数に ``TRUE``
を渡します。それ以降は、同一名前空間でインスタンスを作成しようとすると例外がスローされます。

.. _zend.session.advanced_usage.single_instance.example:

.. rubric:: セッション名前空間へのアクセスを単一のインスタンスに制限する

.. code-block:: php
   :linenos:

   // 名前空間のインスタンスを作成します
   $authSpaceAccessor1 = new Zend_Session_Namespace('Zend_Auth');

   // 同じ名前空間で別のインスタンスを作成します。
   // しかし今後はインスタンスを作成できないようにします
   $authSpaceAccessor2 = new Zend_Session_Namespace('Zend_Auth', true);

   // 参照をすることは可能です
   $authSpaceAccessor3 = $authSpaceAccessor2;

   $authSpaceAccessor1->foo = 'bar';

   assert($authSpaceAccessor2->foo, 'bar');

   try {
       $aNamespaceObject = new Zend_Session_Namespace('Zend_Auth');
   } catch (Zend_Session_Exception $e) {
       echo 'この名前空間ではインスタンスを作成できません。すでに ' .
            '$authSpaceAccessor2 があるからです\n';
   }

上の例では、コンストラクタの第二引数を用いて "``Zend_Auth``"
名前空間では今後インスタンスを作成させないよう ``Zend_Session_Namespace``
に指示しています。
インスタンスを作成しようとすると、コンストラクタから例外がスローされます。
したがって、このセッション名前空間へのアクセスが必要となった場合は、
今後は現在あるインスタンス (上の例の場合なら *$authSpaceAccessor1*\ 、 *$authSpaceAccessor2*
あるいは *$authSpaceAccessor3*) のどれかを使うことになるわけです。
たとえば、名前空間への参照を静的変数に格納したり、 `レジストリ`_ (:ref:`
<zend.registry>` を参照ください) に格納したり、
あるいは名前空間へのアクセスを必要とするその他のメソッドで使用したりします。

.. _zend.session.advanced_usage.arrays:

配列の使用
-----

*PHP* のマジックメソッドの実装上の理由で、バージョン 5.2.1 より前の *PHP*
では名前空間内の配列の修正ができません。 もし *PHP* 5.2.1
以降を使っている場合は、 :ref:`このセクションは読み飛ばしてください
<zend.session.advanced_usage.objects>`\ 。

.. _zend.session.advanced_usage.arrays.example.modifying:

.. rubric:: セッション名前空間内での配列データの修正

問題の再現手順は、このようになります。

.. code-block:: php
   :linenos:

   $sessionNamespace = new Zend_Session_Namespace();
   $sessionNamespace->array = array();

   // PHP 5.2.1 より前のバージョンでは、期待通りに動作しません
   $sessionNamespace->array['testKey'] = 1;
   echo $sessionNamespace->array['testKey'];

.. _zend.session.advanced_usage.arrays.example.building_prior:

.. rubric:: セッションに保存する前に配列を作成する

可能なら、先に配列のすべての値を設定してからセッションに格納するようにすればこの問題を回避できます。

.. code-block:: php
   :linenos:

   $sessionNamespace = new Zend_Session_Namespace('Foo');
   $sessionNamespace->array = array('a', 'b', 'c');

この問題の影響を受けるバージョンの *PHP* を使っている場合で、
セッション名前空間に代入した後に配列を修正したい場合は、
以下の回避策のうちのいずれかを使用します。

.. _zend.session.advanced_usage.arrays.example.workaround.reassign:

.. rubric:: 回避策: 修正した配列を再度代入する

以下のコードでは、保存されている配列のコピーを作成してそれを修正し、
修正したコピーを再度代入してもとの配列を上書きします。

.. code-block:: php
   :linenos:

   $sessionNamespace = new Zend_Session_Namespace();

   // 配列を代入します
   $sessionNamespace->array = array('tree' => 'apple');

   // そのコピーを作成します
   $tmp = $sessionNamespace->array;

   // コピーのほうを修正します
   $tmp['fruit'] = 'peach';

   // 修正したコピーをセッション名前空間に書き戻します
   $sessionNamespace->array = $tmp;

   echo $sessionNamespace->array['fruit']; // prints "peach"

.. _zend.session.advanced_usage.arrays.example.workaround.reference:

.. rubric:: 回避策: 参照を含む配列を格納する

あるいは、実際の配列への参照を含む配列を格納しておき、
間接的にアクセスするようにします。

.. code-block:: php
   :linenos:

   $myNamespace = new Zend_Session_Namespace('myNamespace');
   $a = array(1, 2, 3);
   $myNamespace->someArray = array( &$a );
   $a['foo'] = 'bar';
   echo $myNamespace->someArray['foo']; // "bar" と表示されます

.. _zend.session.advanced_usage.objects:

セッションでのオブジェクトの使用
----------------

オブジェクトを *PHP* セッション内で持続的に使用したい場合は、 `シリアライズ`_
を使用します。したがって、 *PHP* セッションから永続オブジェクトを取得したら、
そのシリアライズを解除しなければなりません。
ということは、永続オブジェクトをセッションから読み出す前に、
そのオブジェクトのクラスが定義されていなければならないということです。
クラスが定義されていない場合は、 *stdClass* のオブジェクトとして復元されます。

.. _zend.session.advanced_usage.testing:

ユニットテストでのセッションの使用
-----------------

Zend Framework 自体のテストには PHPUnit を使用しています。
多くの開発者は、このテストスイートを拡張して自分のアプリケーションのコードをテストしています。
ユニットテスト中で、セッションの終了後に書き込み関連のメソッドを使用すると
"**Zend_Session is currently marked as read-only**" という例外がスローされます。しかし、
``Zend_Session`` を使用するユニットテストには要注意です。 セッションを閉じたり
(``Zend_Session::writeClose()``) 破棄したり (``Zend_Session::destroy()``) したら、 それ以降は
``Zend_Session_Namespace`` のインスタンスへのキーの設定や削除ができなくなります。
これは、ext/session や、 *PHP* の ``session_destroy()`` および ``session_write_close()``
の仕様によるものです, これらには、ユニットテストの setup/teardown
時に使用できるような、いわゆる "undo" 機能が備わっていないのです。

この問題の回避策は、 *SessionTest.php* および *SessionTestHelper.php* (どちらも
*tests/Zend/Session* にあります) のユニットテストテスト ``testSetExpirationSeconds()``
を参照ください。 これは、 *PHP* の ``exec()`` によって別プロセスを起動しています。
新しいプロセスが、ブラウザからの二番目以降のリクエストをシミュレートします。
この別プロセスの開始時にはセッションを "初期化" します。 ちょうど、ふつうの
*PHP* スクリプトがウェブリクエストを実行する場合と同じような動作です。
また、呼び出し元のプロセスで *$_SESSION* を変更すると、
子プロセスでそれが反映されます。親側では ``exec()``
を使用する前にセッションを閉じています。

.. _zend.session.advanced_usage.testing.example:

.. rubric:: PHPUnit で Zend_Session を使用したコードをテストする例

.. code-block:: php
   :linenos:

   // testing setExpirationSeconds()
   $script = 'SessionTestHelper.php';
   $s = new Zend_Session_Namespace('space');
   $s->a = 'apple';
   $s->o = 'orange';
   $s->setExpirationSeconds(5);

   Zend_Session::regenerateId();
   $id = Zend_Session::getId();
   session_write_close(); // release session so process below can use it
   sleep(4); // not long enough for things to expire
   exec($script . "expireAll $id expireAll", $result);
   $result = $this->sortResult($result);
   $expect = ';a === apple;o === orange;p === pear';
   $this->assertTrue($result === $expect,
       "iteration over default Zend_Session namespace failed; " .
       "expecting result === '$expect', but got '$result'");

   sleep(2); // long enough for things to expire (total of 6 seconds
             // waiting, but expires in 5)
   exec($script . "expireAll $id expireAll", $result);
   $result = array_pop($result);
   $this->assertTrue($result === '',
       "iteration over default Zend_Session namespace failed; " .
       "expecting result === '', but got '$result')");
   session_start(); // resume artificially suspended session

   // We could split this into a separate test, but actually, if anything
   // leftover from above contaminates the tests below, that is also a
   // bug that we want to know about.
   $s = new Zend_Session_Namespace('expireGuava');
   $s->setExpirationSeconds(5, 'g'); // now try to expire only 1 of the
                                     // keys in the namespace
   $s->g = 'guava';
   $s->p = 'peach';
   $s->p = 'plum';

   session_write_close(); // release session so process below can use it
   sleep(6); // not long enough for things to expire
   exec($script . "expireAll $id expireGuava", $result);
   $result = $this->sortResult($result);
   session_start(); // resume artificially suspended session
   $this->assertTrue($result === ';p === plum',
       "iteration over named Zend_Session namespace failed (result=$result)");



.. _`session.auto_start`: http://www.php.net/manual/ja/ref.session.php#ini.session.auto-start
.. _`session_start()`: http://www.php.net/session_start
.. _`HTTP ヘッダ`: http://www.php.net/headers_sent
.. _`PHP のリファレンスについての説明`: http://www.php.net/references
.. _`レジストリ`: http://www.martinfowler.com/eaaCatalog/registry.html
.. _`シリアライズ`: http://www.php.net/manual/ja/language.oop.serialization.php
