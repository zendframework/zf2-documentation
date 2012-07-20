.. _zend.auth.adapter.dbtable:

データベースのテーブルでの認証
===============

.. _zend.auth.adapter.dbtable.introduction:

導入
--

``Zend_Auth_Adapter_DbTable`` は、
データベースのテーブルに保存された証明情報に基づいた認証の機能を提供します。
``Zend_Auth_Adapter_DbTable`` のコンストラクタには ``Zend_Db_Adapter_Abstract``
のインスタンスを渡す必要があるので、
各インスタンスは特定のデータベース接続に関連付けられます。
コンストラクタではその他の設定オプションも指定できます。
これらは個別にインスタンスメソッドで指定することもできます。

次のような設定オプションが使用可能です。

- **tableName**: これはデータベースのテーブル名です。証明情報が含まれ、
  認証クエリの問い合わせ先となるテーブル名を指定します。

- **identityColumn**: これは、ID を表すデータベーステーブルのカラム名です。
  このカラムには、ユーザ名やメールアドレスのような一意な値が含まれている必要があります。

- **credentialColumn**: これは、証明情報を表すデータベーステーブルのカラム名です。
  単純な ID
  およびパスワードによる認証方式では、この値がパスワードに対応します。
  ``credentialTreatment`` オプションも参照ください。

- **credentialTreatment**:
  多くの場合、パスワードやその他機密情報は、何らかの関数やアルゴリズムで
  暗号化、ハッシュ化、符号化、ぼかしなどの処理が行われています。
  これらの処理を表すパラメータつきの文字列、たとえば '``MD5(?)``' や '``PASSWORD(?)``'
  を指定することで、 証明データに対して任意の *SQL* を適用できるようになります。
  これらの関数は *RDBMS* によって異なります。
  データベースシステムでどのような関数が使えるのかについては、
  データベースのマニュアルをご確認ください。

.. _zend.auth.adapter.dbtable.introduction.example.basic_usage:

.. rubric:: 基本的な使用法

導入部で説明したとおり、 ``Zend_Auth_Adapter_DbTable`` のコンストラクタには
``Zend_Db_Adapter_Abstract``
のインスタンスを渡す必要があります。これは、認証アダプタのインスタンスと
関連付けるデータベース接続を表します。
まず、データベース接続を作成する必要があります。

次のコードは、メモリ内データベースのアダプタを作成し、
簡単なテーブルスキーマを作成し、そして後で認証クエリを実行するための行を追加します。
この例を実行するには、 *PDO* SQLite
拡張モジュールが有効になっている必要があります。

.. code-block:: php
   :linenos:

   // メモリ内で SQLite データベース接続を作成します
   $dbAdapter = new Zend_Db_Adapter_Pdo_Sqlite(array('dbname' =>
                                                     ':memory:'));

   // 単純なテーブルを作成するクエリ
   $sqlCreate = 'CREATE TABLE [users] ('
              . '[id] INTEGER  NOT NULL PRIMARY KEY, '
              . '[username] VARCHAR(50) UNIQUE NOT NULL, '
              . '[password] VARCHAR(32) NULL, '
              . '[real_name] VARCHAR(150) NULL)';

   // 認証情報テーブルを作成します
   $dbAdapter->query($sqlCreate);

   // 認証を成功させるために行を追加します
   $sqlInsert = "INSERT INTO users (username, password, real_name) "
              . "VALUES ('my_username', 'my_password', 'My Real Name')";

   // データを挿入します
   $dbAdapter->query($sqlInsert);
データベース接続およびテーブルが使用可能となったので ``Zend_Auth_Adapter_DbTable``
のインスタンスが作成できます。 設定オプションの値は、コンストラクタで渡すか、
あるいはインスタンスを作成した後に設定用メソッドで指定します。

.. code-block:: php
   :linenos:

   // コンストラクタにパラメータを渡し、インスタンスを設定します
   $authAdapter = new Zend_Auth_Adapter_DbTable(
       $dbAdapter,
       'users',
       'username',
       'password'
   );

   // あるいは、設定用メソッドでインスタンスの設定を行います
   $authAdapter = new Zend_Auth_Adapter_DbTable($dbAdapter);

   $authAdapter
       ->setTableName('users')
       ->setIdentityColumn('username')
       ->setCredentialColumn('password')
   ;
この時点で、認証アダプタのインスタンスは認証クエリを受け付ける準備ができました。
認証クエリを処理するには、入力された証明情報をアダプタに渡してから
``authenticate()`` メソッドをコールします。

.. code-block:: php
   :linenos:

   // 入力情報 (ログインフォームからの値など) を設定します
   $authAdapter
       ->setIdentity('my_username')
       ->setCredential('my_password')
   ;

   // 認証クエリを実行し、結果を保存します

認証結果オブジェクトでの ``getIdentity()`` メソッドに加え、 ``Zend_Auth_Adapter_DbTable``
は認証の成功時にテーブルの行を取得する機能もサポートしています。

.. code-block:: php
   :linenos:

   // ID を表示します
   echo $result->getIdentity() . "\n\n";

   // 結果の行を表示します
   print_r($authAdapter->getResultRowObject());

   /* 出力結果
   my_username

   Array
   (
       [id] => 1
       [username] => my_username
       [password] => my_password
       [real_name] => My Real Name
   )
   */
テーブルの行には証明情報が含まれているので、
予期せぬアクセスからその内容を守ることが重要となります。

.. _zend.auth.adapter.dbtable.advanced.storing_result_row:

応用例: 持続的な DbTable 結果オブジェクト
--------------------------

デフォルトでは ``Zend_Auth_Adapter_DbTable`` は、
認証に成功した際に認証情報を返します。場合によっては、 ``Zend_Auth``
の持続ストレージの仕組みを利用して
別の有用な情報を格納したいこともあるでしょう。その場合は、 ``getResultRowObject()``
メソッドを使用して **stdClass** オブジェクトを返します。
次のコードで、使用法をご確認ください。

.. code-block:: php
   :linenos:

   // Zend_Auth_Adapter_DbTable による認証を行います
   $result = $this->_auth->authenticate($adapter);

   if ($result->isValid()) {
       // 認証情報をオブジェクトとして保存し、username と real_name のみを返します
       $storage = $this->_auth->getStorage();
       $storage->write($adapter->getResultRowObject(array(
           'username',
           'real_name',
       )));

       // 認証情報をオブジェクトとして保存し、password のみを省略します
       $storage->write($adapter->getResultRowObject(
           null,
           'password'
       ));

       /* ... */

   } else {

       /* ... */

   }
.. _zend.auth.adapter.dbtable.advanced.advanced_usage:

高度な使用例
------

``Zend_Auth`` (そして ``Zend_Auth_Adapter_DbTable``) の主な目的は **認証 (authentication)** であって
**認可 (authorization)**, ではありませんが、認可にもかかわる問題も多少あります。
問題によっては、認証アダプタの中で認可にかかわる問題を解決することもあるでしょう。

ちょっとしたおまけとして ``Zend_Auth_Adapter_DbTable``
に組み込まれている仕組みを使用すると、
認証時にありがちな問題を解決するチェックを加えることができます。

.. code-block:: php
   :linenos:

   // アカウントの status フィールドが "compromised" ではない
   $adapter = new Zend_Auth_Adapter_DbTable(
       $db,
       'users',
       'username',
       'password',
       'MD5(?) AND status != "compromised"'
   );

   // アカウントの active フィールドが "TRUE" に等しい
   $adapter = new Zend_Auth_Adapter_DbTable(
       $db,
       'users',
       'username',
       'password',
       'MD5(?) AND active = "TRUE"'
   );
もうひとつの例として、salt メカニズムの実装を見てみましょう。 salt
とは、アプリケーションのセキュリティを格段に向上させるテクニックを指す用語です。
パスワードにランダムな文字列を連結することで、
辞書を用いた総当たり攻撃からパスワードを保護するという仕組みになっています。

salt 文字列を格納するために、テーブルの構造を変更する必要があります。

.. code-block:: php
   :linenos:

   $sqlAlter = "ALTER TABLE [users] "
             . "ADD COLUMN [password_salt] "
             . "AFTER [password]";

   $dbAdapter->query($sqlAlter);
すべてのユーザに対して登録時に salt 文字列を生成するシンプルな方法を示します。

.. code-block:: php
   :linenos:

   for ($i = 0; $i < 50; $i++) {
       $dynamicSalt .= chr(rand(33, 126));
   }
それではアダプタを作成してみましょう。

.. code-block:: php
   :linenos:

   $adapter = new Zend_Auth_Adapter_DbTable(
       $db,
       'users',
       'username',
       'password',
       "MD5(CONCAT('"
       . Zend_Registry::get('staticSalt')
       . "', ?, password_salt))"
   );
.. note::

   salt がたとえハードコーディングされた固定文字列であったとしても、
   セキュリティを向上させることができます。 仮に (*SQL*
   インジェクション攻撃などで) データベースに侵入されたとしても、
   ウェブサーバは無傷なのでデータを攻撃者に悪用されることはありません。

もうひとつの方法は、アダプタを作成したあとで ``Zend_Auth_Adapter_DbTable`` の
``getDbSelect()`` メソッドを使うことです。 このメソッドが返す ``Zend_Db_Select``
オブジェクトのインスタンスで ``authenticate()`` を実行します。このメソッドは、
``authenticate()``
をコールしたかどうかにかかわらず同じオブジェクトを返すことに注意しましょう。
このオブジェクトには識別や認証のための情報は含まれておらず、 ``authenticate()``
によってそれらが組み込まれます。

``getDbSelect()`` メソッドを使いたくなるひとつの例としては、
たとえばユーザの状態のチェック、
つまりそのユーザアカウントが有効になっているかどうかの確認などがあります。

.. code-block:: php
   :linenos:

   // 上の例の続き
   $adapter = new Zend_Auth_Adapter_DbTable(
       $db,
       'users',
       'username',
       'password',
       'MD5(?)'
   );

   // select オブジェクトを (参照として) 取得します
   $select = $adapter->getDbSelect();
   $select->where('active = "TRUE"');

   // 認証。これにより、users.active = TRUE であることを保証します
   $adapter->authenticate();



