.. EN-Revision: none
.. _zend.session.basic_usage:

基本的な使用法
=======

``Zend\Session\Namespace`` のインスタンスが、Zend Framework
のセッションデータを操作するための基本的な *API* を提供します。
名前空間を使用するとセッションデータを個別に扱うことができますが、
セッションデータ全体をひとつの名前空間で扱いたい人のためのデフォルト名前空間も用意されています。
``Zend\Session\Namespace`` は、ext/session およびスーパーグローバル変数 *$_SESSION*
を使用して、セッション状態のデータを保存します。 *$_SESSION*
はグローバルにアクセス可能ですが、
開発者はこれに対して直接アクセスするのはやめるべきです。 ``Zend_Session`` および
``Zend\Session\Namespace`` を用いることで、
セッション関連の機能をより効率的かつ安全に使用できるようになります。

``Zend\Session\Namespace`` の各インスタンスが、 スーパーグローバル配列 *$_SESSION*
のエントリに対応します。 名前空間をキーとして使用します。

   .. code-block:: php
      :linenos:

      $myNamespace = new Zend\Session\Namespace('myNamespace');

      // $myNamespace は $_SESSION['myNamespace'] に対応します

Zend_Session は、 *$_SESSION*
を直接使用するその他のコードと組み合わせて使用することもできます。
しかし、問題が起こることをさけるために、 *$_SESSION* を直接使用するのは
``Zend\Session\Namespace`` のインスタンスに関連しないキーに限るようにしましょう。

.. _zend.session.basic_usage.basic_examples:

チュートリアル
-------

何も名前空間を指定せずに ``Zend\Session\Namespace`` のインスタンスを作成すると、
すべてのデータは透過的に "*Default*" という名前の名前空間に保存されます。
``Zend_Session`` は、セッション名前空間コンテナの内容を
直接操作するためのものではあります。そのかわりとして ``Zend\Session\Namespace``
を使用します。 以下の例は、このデフォルトの名前空間を使用して
セッション内でのクライアントからのリクエストの回数を数えるものです。

.. _zend.session.basic_usage.basic_examples.example.counting_page_views:

.. rubric:: ページビューの数え方

.. code-block:: php
   :linenos:

   $defaultNamespace = new Zend\Session\Namespace('Default');

   if (isset($defaultNamespace->numberOfPageRequests)) {
       // これが、ページが読み込まれるたびに加算されます
       $defaultNamespace->numberOfPageRequests++;
   } else {
       $defaultNamespace->numberOfPageRequests = 1; // 一回目
   }

   echo "このセッションでページがリクエストされた回数: ",
       $defaultNamespace->numberOfPageRequests;

複数のモジュールが別々の名前空間で ``Zend\Session\Namespace``
のインスタンスを使用するようにすると、各モジュールのデータをセッション内でカプセル化できます。
``Zend\Session\Namespace`` のコンストラクタでオプションの引数 *$namespace* を指定すると、
セッションデータを個別の名前空間に分割できます。
名前空間は、セッションデータで名前の衝突による事故を防ぐための方法として、
効率的で人気のある方法です。

名前空間名に使用できるのは、空文字列以外の *PHP* の文字列です。ただし、
最初の文字にアンダースコア ("*_*") を使用することはできません。 "*Zend*"
で始まる名前空間を使えるのは、 Zend Framework
に同梱されるコアコンポーネントだけです。

.. _zend.session.basic_usage.basic_examples.example.namespaces.new:

.. rubric:: 新しい方法: 名前空間の衝突を避ける

.. code-block:: php
   :linenos:

   // Zend_Auth コンポーネント用
   $authNamespace = new Zend\Session\Namespace('Zend_Auth');
   $authNamespace->user = "myusername";

   // ウェブサービスコンポーネント用
   $webServiceNamespace = new Zend\Session\Namespace('Some_Web_Service');
   $webServiceNamespace->user = "mywebusername";

上の例は、この下のコードと同じ結果になります。
ただ、上の例ではセッションデータがそれぞれの名前空間でカプセル化されています。

.. _zend.session.basic_usage.basic_examples.example.namespaces.old:

.. rubric:: 古い方法: PHP のセッションへのアクセス

.. code-block:: php
   :linenos:

   $_SESSION['Zend_Auth']['user'] = "myusername";
   $_SESSION['Some_Web_Service']['user'] = "mywebusername";

.. _zend.session.basic_usage.iteration:

セッション名前空間の順次処理
--------------

``Zend\Session\Namespace`` は `IteratorAggregate インターフェイス`_ を完全に実装しており、
*foreach* 文をサポートしています。

.. _zend.session.basic_usage.iteration.example:

.. rubric:: セッションの順次処理

.. code-block:: php
   :linenos:

   $aNamespace =
       new Zend\Session\Namespace('some_namespace_with_data_present');

   foreach ($aNamespace as $index => $value) {
       echo "aNamespace->$index = '$value';\n";
   }

.. _zend.session.basic_usage.accessors:

セッション名前空間へのアクセス方法
-----------------

``Zend\Session\Namespace`` は ``__get()``\ 、 ``__set()``\ 、 ``__isset()`` そして ``__unset()`` といった
`マジックメソッド`_
を実装しています。これらは、自分のサブクラス以外から直接コールされることはありません。
次の例に示すように、通常の演算の際に自動的にコールされることになります。

.. _zend.session.basic_usage.accessors.example:

.. rubric:: セッションデータへのアクセス

.. code-block:: php
   :linenos:

   $namespace = new Zend\Session\Namespace(); // デフォルトの名前空間

   $namespace->foo = 100;

   echo "\$namespace->foo = $namespace->foo\n";

   if (!isset($namespace->bar)) {
       echo "\$namespace->bar not set\n";
   }

   unset($namespace->foo);



.. _`IteratorAggregate インターフェイス`: http://www.php.net/~helly/php/ext/spl/interfaceIteratorAggregate.html
.. _`マジックメソッド`: http://www.php.net/manual/ja/language.oop5.overloading.php
