.. _zend.auth.introduction:

導入
==

``Zend_Auth`` は、認証のための *API* を提供します。
また、一般的な使用例に対応する具象認証アダプタも用意しています。

``Zend_Auth`` が扱うのはあくまでも **認証 (authentication)** であり、 **承認 (authorization)**
ではありません。 認証 (authentication)
とはつまり、あるエンティティが何者であるのかを示す (識別する)
ことです。これを、なんらかの条件にもとづいて行います。 承認 (authorization)
とは、あるエンティティが他のエンティティに対して
アクセスしたり何らかの操作をしたりする権限があるかどうかを判定する処理です。
これは ``Zend_Auth`` の対象外となります。 Zend Framework
における認証やアクセス制御の詳細については、 :ref:`Zend_Acl <zend.acl>`
を参照ください。

.. note::

   ``Zend_Auth`` クラスはシングルトンパターン
   (クラスのインスタンスは常にひとつだけ) を実装しており、静的メソッド
   ``getInstance()`` でそれを使用します。 つまり、 **new** 演算子や **clone** キーワードは
   ``Zend_Auth`` クラスでは動作しないということです。そのかわりに
   ``Zend_Auth::getInstance()`` を使用します。

.. _zend.auth.introduction.adapters:

アダプタ
----

``Zend_Auth`` アダプタの使用目的は、 *LDAP* や *RDBMS* あるいはファイル
のような特定の型の認証サービスに対する認証を行うことです。
アダプタによってそのオプションや挙動は大きくことなるでしょうが、
いくつかの基本処理は、あらゆる認証アダプタで共通となります。 たとえば認証条件
(いわゆる ID) を受け取り、 認証サービスに対する問い合わせを行い、
結果を返すという処理は、すべての ``Zend_Auth`` アダプタで共通です。

各 ``Zend_Auth`` アダプタクラスは、 ``Zend_Auth_Adapter_Interface``
を実装しています。このインターフェイスで定義されているメソッドが ``authenticate()``
で、アダプタクラスは 認証クエリを実行するためにこれを実装する必要があります。
各アダプタクラスは、 ``authenticate()``
をコールする前に準備を済ませておく必要があります。
つまり、アダプタ側で用意しなければならない機能としては 認証条件
(ユーザ名およびパスワードなど) の取得や アダプタ固有のオプションの設定
(データベースのテーブルを使用するアダプタならデータベースへの接続設定など)
があるということです。

以下にあげるのは認証アダプタのサンプルで、
これはユーザ名とパスワードを受け取って認証を行います。
その他の詳細、例えば認証サービスへの実際の問い合わせなどは、
例を簡潔にするため省略しています。

.. code-block:: php
   :linenos:

   class MyAuthAdapter implements Zend_Auth_Adapter_Interface
   {
       /**
        * 認証用のユーザ名とパスワードを設定します
        *
        * @return void
        */
       public function __construct($username, $password)
       {
           // ...
       }

       /**
        * 認証を試みます
        *
        * @throws Zend_Auth_Adapter_Exception が、認証処理をできなかった場合に発生します
        * @return Zend_Auth_Result
        */
       public function authenticate()
       {
           // ...
       }
   }

docblock コメントで説明しているとおり、 ``authenticate()`` は ``Zend_Auth_Result`` (あるいは
``Zend_Auth_Result`` の派生クラス)
のインスタンスを返す必要があります。何らかの理由で認証の問い合わせができなかった場合は、
``authenticate()`` は ``Zend_Auth_Adapter_Exception``
から派生した例外をスローしなければなりません。

.. _zend.auth.introduction.results:

結果
--

``Zend_Auth`` アダプタは、 ``authenticate()`` の結果として ``Zend_Auth_Result``
のインスタンスを返します。
これにより、認証を試みた結果を表します。アダプタのインスタンスを作成した際に
``Zend_Auth_Result`` オブジェクトが作成され、 以下の 4 つのメソッドで ``Zend_Auth``
アダプタの結果に対する共通の操作ができます。

- ``isValid()``- その結果が 認証の成功を表している場合にのみ ``TRUE`` を返します。

- ``getCode()``-``Zend_Auth_Result`` の定数を返します。
  これは、認証に失敗したのか成功したのかを表すものです。
  これを使用する場面としては、認証の結果をいくつかの結果から区別したい場合などがあります。
  これにより、たとえば認証結果について、より詳細な情報を管理することができるようになります。
  別の使用法としては、ユーザに示すメッセージを変更し、より詳細な情報を伝えられるようにすることなどがあります。
  しかし、一般的な「認証失敗」メッセージではなく
  ユーザに対して詳細な情報を示す際には、そのリスクを知っておくべきです。
  詳細な情報は、以下の注意を参照ください。

- ``getIdentity()``- 認証を試みた ID 情報を返します。

- ``getMessages()``- 認証に失敗した場合に、 関連するメッセージの配列を返します。

認証の結果によって処理を分岐させ、より決め細やかな処理を行いたいこともあるでしょう。
有用な処理としては、たとえば間違ったパスワードを繰り返し入力したアカウントをロックしたり、
存在しない ID を何度も入力した IP アドレスに印をつけたり、
ユーザに対してよりわかりやすいメッセージを返したりといったことがあります。
次の結果コードが使用可能です。

.. code-block:: php
   :linenos:

   Zend_Auth_Result::SUCCESS
   Zend_Auth_Result::FAILURE
   Zend_Auth_Result::FAILURE_IDENTITY_NOT_FOUND
   Zend_Auth_Result::FAILURE_IDENTITY_AMBIGUOUS
   Zend_Auth_Result::FAILURE_CREDENTIAL_INVALID
   Zend_Auth_Result::FAILURE_UNCATEGORIZED

次の例は、結果コードを処理する方法を示すものです。

.. code-block:: php
   :linenos:

   // AuthController / loginAction の中の処理
   $result = $this->_auth->authenticate($adapter);

   switch ($result->getCode()) {

       case Zend_Auth_Result::FAILURE_IDENTITY_NOT_FOUND:
           /** ID が存在しない場合の処理 **/
           break;

       case Zend_Auth_Result::FAILURE_CREDENTIAL_INVALID:
           /** 認証に失敗した場合の処理 **/
           break;

       case Zend_Auth_Result::SUCCESS:
           /** 認証に成功した場合の処理 **/
           break;

       default:
           /** その他の原因で失敗した場合の処理 **/
           break;
   }

.. _zend.auth.introduction.persistence:

ID の永続性
-------

認証情報 (パスワードなど) を含む認証を要求するのは便利なものですが、
リクエストごとにいちいち認証情報を引き回すのではなく、 認証済みの ID
を保持し続けることも重要です。

*HTTP* はステートレスなプロトコルです。しかし、
クッキーやセッションといった技術によって、
サーバサイドのウェブアプリケーションでも 複数リクエスト間でステート (状態)
を保持し続けられるようになりました。

.. _zend.auth.introduction.persistence.default:

PHP セッションにおけるデフォルトの持続性
^^^^^^^^^^^^^^^^^^^^^^

デフォルトでは、 ``Zend_Auth`` は、 認証に成功した際の ID 情報を *PHP*
のセッションを使用して保存します。 認証に成功すると、 ``Zend_Auth::authenticate()``
は認証結果を持続ストレージに保存します。何も指定しなければ、 ``Zend_Auth``
が使用するストレージクラスは ``Zend_Auth_Storage_Session`` となります。これは
:ref:`Zend_Session <zend.session>` を使用しています。 独自のクラスを使用するには、
``Zend_Auth_Storage_Interface`` を実装したクラスのオブジェクトを ``Zend_Auth::setStorage()``
で設定します。

.. note::

   もし ID が自動的に持続ストレージに保存されるのが気に入らない場合は、
   ``Zend_Auth`` クラスをまるごと使用するのを控え、
   アダプタクラスを直接使用します。

.. _zend.auth.introduction.persistence.default.example:

.. rubric:: セッション名前空間の変更

``Zend_Auth_Storage_Session`` は、セッション名前空間として '``Zend_Auth``'
を使用します。これを変更するには、別の値を ``Zend_Auth_Storage_Session``
のコンストラクタで指定します。 この値が、内部で ``Zend_Session_Namespace``
のコンストラクタに渡されます。これは認証を試みる前に行う必要があります。
なぜなら、 ``Zend_Auth::authenticate()`` は ID を自動的に保存するからです。

.. code-block:: php
   :linenos:

   // Zend_Auth のシングルトンインスタンスへの参照を保存します
   $auth = Zend_Auth::getInstance();

   // 'Zend_Auth' のかわりに 'someNamespace' を使用します
   $auth->setStorage(new Zend_Auth_Storage_Session('someNamespace'));

   /**
    * @todo 認証アダプタ $authAdapter を設定します
    */

   // 認証と結果の保存、そして成功時に ID を持続させます
   $result = $auth->authenticate($authAdapter);

.. _zend.auth.introduction.persistence.custom:

独自のストレージの実装
^^^^^^^^^^^

``Zend_Auth_Storage_Session`` とは異なる形式で、 ID
を持続させたくなることもあるでしょう。そのような場合は、
``Zend_Auth_Storage_Interface`` を実装したクラスのインスタンスを ``Zend_Auth::setStorage()``
で設定します。

.. _zend.auth.introduction.persistence.custom.example:

.. rubric:: 独自のストレージクラスの使用法

ID を持続させるストレージクラスを ``Zend_Auth_Storage_Session`` の代わりに使用するには、
``Zend_Auth_Storage_Interface`` を実装します。

.. code-block:: php
   :linenos:

   class MyStorage implements Zend_Auth_Storage_Interface
   {
       /**
        * ストレージが空の場合にのみ true を返す
        *
        * @throws Zend_Auth_Storage_Exception 空かどうか判断できないとき
        * @return boolean
        */
       public function isEmpty()
       {
           /**
            * @todo 実装が必要
            */
       }

       /**
        * ストレージの中身を返す
        *
        * ストレージが空の場合に挙動は未定義
        *
        * @throws Zend_Auth_Storage_Exception ストレージの中身を読み込めない場合
        * @return mixed
        */
       public function read()
       {
           /**
            * @todo 実装が必要
            */
       }

       /**
        * $contents をストレージに書き込む
        *
        * @param  mixed $contents
        * @throws Zend_Auth_Storage_Exception $contents をストレージに書き込めない場合
        * @return void
        */
       public function write($contents)
       {
           /**
            * @todo 実装が必要
            */
       }

       /**
        * ストレージの中身を消去する
        *
        * @throws Zend_Auth_Storage_Exception ストレージの中身を消去できない場合
        * @return void
        */
       public function clear()
       {
           /**
            * @todo 実装が必要
            */
       }
   }

このストレージクラスを使用するには、認証クエリの前に ``Zend_Auth::setStorage()``
を実行します。

.. code-block:: php
   :linenos:

   // Zend_Auth に、独自のストレージクラスを使うよう指示します
   Zend_Auth::getInstance()->setStorage(new MyStorage());

   /**
    * @todo 認証アダプタ $authAdapter を設定します
    */

   // 認証と結果の保存、そして成功時に ID を持続させます
   $result = Zend_Auth::getInstance()->authenticate($authAdapter);

.. _zend.auth.introduction.using:

使用法
---

``Zend_Auth`` の使用法には、次の二通りがあります。

. 間接的に ``Zend_Auth::authenticate()`` 経由で使用する

. 直接、アダプタの ``authenticate()`` メソッドを使用する

次の例は、 ``Zend_Auth`` アダプタを間接的に ``Zend_Auth`` クラスから使用するものです。

.. code-block:: php
   :linenos:

   // Zend_Auth のシングルトンインスタンスへの参照を取得します
   $auth = Zend_Auth::getInstance();

   // 認証アダプタを設定します
   $authAdapter = new MyAuthAdapter($username, $password);

   // 認証を試み、その結果を取得します
   $result = $auth->authenticate($authAdapter);

   if (!$result->isValid()) {
       // 認証に失敗したので、原因を表示します
       foreach ($result->getMessages() as $message) {
           echo "$message\n";
       }
   } else {
       // 認証に成功しました。ID ($username) がセッションに保存されます
       // $result->getIdentity() === $auth->getIdentity()
       // $result->getIdentity() === $username
   }

上の例においてリクエスト内で認証が行われると、 認証に成功した際にその ID
を取得するのは簡単なことです。

.. code-block:: php
   :linenos:

   $auth = Zend_Auth::getInstance();
   if ($auth->hasIdentity()) {
       // ID があるのでそれを取得します
       $identity = $auth->getIdentity();
   }

永続ストレージから認証 ID を削除するには、単純に ``clearIdentity()``
メソッドを使用します。 これは、アプリケーションの "ログアウト"
処理を実装するためのものです。

.. code-block:: php
   :linenos:

   Zend_Auth::getInstance()->clearIdentity();

自動的に永続ストレージが用いられるのがまずい場合もあるでしょう。
そんな場合は、 ``Zend_Auth`` クラスをバイパスして アダプタクラスを直接使用します。
アダプタクラスを直接使用するとは、アダプタオブジェクトの設定と準備を行い、
その ``authenticate()`` メソッドをコールするということです。
アダプタ固有の詳細情報については、各アダプタのドキュメントで説明します。
以下の例は、 ``MyAuthAdapter`` を直接使用するものです。

.. code-block:: php
   :linenos:

   // 認証アダプタを設定します
   $authAdapter = new MyAuthAdapter($username, $password);

   // 認証を試み、その結果を取得します
   $result = $authAdapter->authenticate();

   if (!$result->isValid()) {
       // 認証に失敗したので、原因を表示します
       foreach ($result->getMessages() as $message) {
           echo "$message\n";
       }
   } else {
       // 認証に成功しました
       // $result->getIdentity() === $username
   }


