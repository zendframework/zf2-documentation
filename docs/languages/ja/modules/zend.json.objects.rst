.. EN-Revision: none
.. _zend.json.advanced:

Zend_Json の高度な使用法
=================

.. _zend.json.advanced.objects1:

JSON オブジェクト
-----------

*PHP* オブジェクトを *JSON* にエンコードすると、 オブジェクトの public
プロパティがすべて *JSON* オブジェクトにエンコードされます。

*JSON* はオブジェクトへの参照を扱うことができません。
再帰的な参照を伴うオブジェクトをエンコードしないように気をつけましょう。
再帰に関する問題が発生しないよう、 ``Zend\Json\Json::encode()`` および
``Zend\Json\Encoder::encode()``
のオプションの二番目のパラメータで再帰をチェックできます。
オブジェクトが二度シリアライズされると、例外がスローされるようになります。

*JSON* オブジェクトのデコードは、さらに大変です。Javascript のオブジェクトを *PHP*
に対応させるなら、連想配列にするのが一番近いでしょう。
しかし、中には「クラスの ID を渡してそのインスタンスを作成し、 *JSON*
オブジェクトの キー/値 をそのインスタンスに代入すべきだという人もいます。
また、そんなことをするとセキュリティ上問題があるという人もいるでしょう。

デフォルトでは、 ``Zend_Json`` は *JSON*
オブジェクトを連想配列にデコードします。しかし、
もしオブジェクトとして受け取りたいのなら、そのように指定することもできます。

.. code-block:: php
   :linenos:

   // JSONオブジェクトをPHPオブジェクトにデコードします
   $phpNative = Zend\Json\Json::decode($encodedValue, Zend\Json\Json::TYPE_OBJECT);

このようにしてデコードされたオブジェクトは *StdClass* オブジェクトとなり、 *JSON*
の キー/値 のペアに対応するプロパティを保持します。

Zend Framework の推奨する方法は、各開発者が *JSON*
オブジェクトのデコード方法を決めるべきだというものです。
もし特定の型のオブジェクトを返してほしいのなら、
お望みの型のオブジェクトを開発者自身が作成したうえで、 ``Zend_Json``
がデコードした値をそこに代入していけばいいのです。

.. _zend.json.advanced.objects2:

PHP オブジェクトのエンコード
----------------

*PHP* オブジェクトをエンコードする際に、
デフォルトでエンコードメカニズムがアクセスできるのはオブジェクトの public
プロパティのみです。エンコードするオブジェクトに ``toJson()``
メソッドが実装されていれば、 ``Zend_Json`` はこのメソッドを実行します。
このメソッドは、オブジェクトの内部状態を *JSON*
表現で返すものと期待されています。

.. _zend.json.advanced.internal:

内部エンコーダ/デコーダ
------------

``Zend_Json`` には二通りのモードがあり、 *PHP* 環境で ext/json
が有効になっているかどうかによってどちらを使うかが変わります。 ext/json
がインストールされていれば、デフォルトで ``json_encode()`` 関数および ``json_decode()``
関数を使用して *JSON* のエンコード/デコードを行います。 ext/json
がインストールされていない場合は、 *PHP* コードによる Zend Framework
の実装を用いてエンコード/デコードを行います。 これは *PHP*
拡張モジュールを使う場合にくらべて相当遅くなりますが、
まったく同じ挙動になります。

しかし、ext/json がインストール環境で敢えて内部エンコーダ/
デコーダを使いたくなる場合もあるかもしれません。
そんなときは次のようにコールします。

.. code-block:: php
   :linenos:

   Zend\Json\Json::$useBuiltinEncoderDecoder = true:

.. _zend.json.advanced.expr:

JSON 式
------

Javascript では無名関数のコールバックを多用します。 そしてそれが *JSON*
オブジェクト変数内に保存されます。
これが動作するのはダブルクォートの中で返されていない場合のみであり、
``Zend_Json`` は当然そのようにします。 ``Zend_Json`` の式サポートを使用すれば、 *JSON*
オブジェクトを javascript コールバックとして正しい形式でエンコードできます。
これは、 ``json_encode()`` と内部エンコーダの両方で動作します。

javascript コールバックは ``Zend\Json\Expr`` オブジェクトで表されます。 これは value object
パターンを実装しており、不変 (immutable) です。 javascript
の式を、コンストラクタの最初の引数として指定できます。 デフォルトでは
``Zend\Json\Json::encode`` は javascript
コールバックをエンコードしません。エンコードするには、 オプション
*'enableJsonExprFinder' = true* を *encode*
関数に渡さなければなりません。これを有効にすると、
大きなオブジェクト構造の中の入れ子状の式に対しても式サポートが有効となります。
次のようにして使用します。

.. code-block:: php
   :linenos:

   $data = array(
       'onClick' => new Zend\Json\Expr('function() {'
                 . 'alert("I am a valid javascript callback '
                 . 'created by Zend_Json"); }'),
       'other' => 'no expression',
   );
   $jsonObjectWithExpression = Zend\Json\Json::encode(
       $data,
       false,
       array('enableJsonExprFinder' => true)
   );


