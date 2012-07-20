.. _zend.validate.writing_validators:

バリデータの書き方
=========

``Zend_Validate`` には、よく使うバリデータ群が付属しています。しかし、
特定の目的のために使用する独自のバリデータを書くことは避けられないでしょう。
ここでは、独自のバリデータを書く方法について説明します。

``Zend_Validate_Interface`` では、２つのメソッド ``isValid()``\ 、 および ``getMessages()``
を定義しています。これらを自分のクラスで実装して
独自のバリデーションオブジェクトを作成します。 ``Zend_Validate_Interface``
を実装したクラスは、 ``Zend_Validate::addValidator()``
でバリデータチェインに追加できます。 このオブジェクトは :ref:`Zend_Filter_Input
<zend.filter.input>` でも使用します。

上の ``Zend_Validate_Interface`` についての説明からも推測できるように、 Zend Framework
が提供しているバリデーションクラスの返り値は、
検証に成功したか失敗したかを表す boolean 値となります。また、 **なぜ**
検証が失敗したのかについての情報も提供します。この理由がわかると、
アプリケーション側で何かと便利です。たとえば、ユーザビリティ改善のための統計情報として利用することなどができます。　

基本的な検証失敗メッセージ機能を実装しているのが ``Zend_Validate_Abstract`` です。
バリデーションクラスを作成する際にこの機能を組み込むには、 ``Zend_Validate_Abstract``
を継承します。 継承したクラス内で ``isValid()`` メソッドのロジックを実装し、
発生しうる失敗の形式に対応したメッセージ変数とメッセージテンプレートを定義します。
検証に失敗した場合には ``isValid()`` は ``FALSE``
を返さなければなりません。検証を通過した場合は、 ``isValid()`` は ``TRUE``
を返さなければなりません。

一般に、 ``isValid()`` メソッドは例外をスローすべきではありません。
例外をスローするのは、入力値が妥当かそうでないかの判断ができない場合のみとします。
例外をスローすることになる場面としては、たとえばファイルのオープンに失敗したり
*LDAP* サーバとの接続に失敗したり、データベースとの接続に失敗したり
といった原因で入力値が正しいのかどうかが判断できない場合が考えられます。

.. _zend.validate.writing_validators.example.simple:

.. rubric:: 単純なバリデーションクラスの作成

次の例は、非常に単純なバリデータの書き方を説明するものです。
ここで定義している検証規則は非常に単純で、入力値が浮動小数点値かどうかのみを調べています。

.. code-block:: php
   :linenos:

   class MyValid_Float extends Zend_Validate_Abstract
   {
       const FLOAT = 'float';

       protected $_messageTemplates = array(
           self::FLOAT => "'%value%' は浮動小数点値ではありません"
       );

       public function isValid($value)
       {
           $this->_setValue($value);

           if (!is_float($value)) {
               $this->_error(self::FLOAT);
               return false;
           }

           return true;
       }
   }

このクラス内には、検証が失敗したときのメッセージ用のテンプレートがひとつ定義されており、
その中では組み込みのマジックパラメータ **%value%** を使用しています。 ``_setValue()``
のコールによって、検証した値をこのメッセージに自動的に格納します。
これにより、検証に失敗したときに、この値をメッセージに含められるようになります。
``_error()`` のコールによって、検証に失敗した原因を取得します。
このクラスでは失敗時のメッセージをひとつしか用意していないので、 ``_error()``
でメッセージテンプレートの名前を指定する必要はありません。

.. _zend.validate.writing_validators.example.conditions.dependent:

.. rubric:: 依存条件を伴うバリデーションクラスの作成

次の例は、複数の検証規則を組み合わせた複雑なものとなります。
ここでは、まず入力値が数値であること、そして指定した最小値と最大値の間にあることを調べます。
以下のいずれかが発生したときに、検証は失敗します。

- 入力値が数値ではない

- 入力値が最小値より小さい

- 入力値が最大値より大きい

これらの原因に応じて、クラス内でメッセージへの変換が行われます。

.. code-block:: php
   :linenos:

   class MyValid_NumericBetween extends Zend_Validate_Abstract
   {
       const MSG_NUMERIC = 'msgNumeric';
       const MSG_MINIMUM = 'msgMinimum';
       const MSG_MAXIMUM = 'msgMaximum';

       public $minimum = 0;
       public $maximum = 100;

       protected $_messageVariables = array(
           'min' => 'minimum',
           'max' => 'maximum'
       );

       protected $_messageTemplates = array(
           self::MSG_NUMERIC => "'%value%' は数値ではありません",
           self::MSG_MINIMUM => "'%value%' は '%min%' 以上でなければなりません",
           self::MSG_MAXIMUM => "'%value%' は '%max%' 以下でなければなりません"
       );

       public function isValid($value)
       {
           $this->_setValue($value);

           if (!is_numeric($value)) {
               $this->_error(self::MSG_NUMERIC);
               return false;
           }

           if ($value < $this->minimum) {
               $this->_error(self::MSG_MINIMUM);
               return false;
           }

           if ($value > $this->maximum) {
               $this->_error(self::MSG_MAXIMUM);
               return false;
           }

           return true;
       }
   }

パブリックプロパティ *$minimum* および *$maximum*
でそれぞれ最小値と最大値を定義し、値がこの間にあった場合に検証が成功したことにしています。
このクラスではまた、それぞれのパブリックプロパティに対応するふたつのメッセージ変数を定義しています。
そしてメッセージテンプレートの中で ``value``
と同様に使えるマジックパラメータとして ``min`` および ``max`` も用意しています。

``isValid()`` での妥当性チェックのいずれかが失敗すると、
適切なメッセージを準備して即時に ``FALSE`` を返すことに注意しましょう。
つまり、これらの検証は、その並び順に依存します。
どれかひとつのチェックが失敗すると、それ以降の検証規則を確認する必要はなくなるからです。
しかし、時にはこのような処理が不要な場合もあります。
次の例は、個々の検証規則を独立させたクラスを書く方法を示すものです。
このバリデーションオブジェクトは、検証に失敗したときに複数の理由を返すことがあります。

.. _zend.validate.writing_validators.example.conditions.independent:

.. rubric:: 個々に独立した条件による検証を行い、失敗時に複数の原因を返す

パスワードの強度を確認するバリデーションクラスを書くことを考えてみましょう。
ユーザに対して、安全なユーザアカウントを発行するために
ある条件を満たしたパスワードを設定してもらう際に使用するものです。
パスワードの条件としては、次のようなものを前提とします。

- 最低 8 文字以上であること

- 最低ひとつの大文字を含むこと

- 最低ひとつの小文字を含むこと

- 最低ひとつの数字を含むこと

この検証規則を実装したクラスは、次のようになります。

.. code-block:: php
   :linenos:

   class MyValid_PasswordStrength extends Zend_Validate_Abstract
   {
       const LENGTH = 'length';
       const UPPER  = 'upper';
       const LOWER  = 'lower';
       const DIGIT  = 'digit';

       protected $_messageTemplates = array(
           self::LENGTH => "'%value%' は少なくとも 8 文字以上でなければなりません",
           self::UPPER  => "'%value%' には最低ひとつの大文字が必要です",
           self::LOWER  => "'%value%' には最低ひとつの小文字が必要です",
           self::DIGIT  => "'%value%' には最低ひとつの数字が必要です"
       );

       public function isValid($value)
       {
           $this->_setValue($value);

           $isValid = true;

           if (strlen($value) < 8) {
               $this->_error(self::LENGTH);
               $isValid = false;
           }

           if (!preg_match('/[A-Z]/', $value)) {
               $this->_error(self::UPPER);
               $isValid = false;
           }

           if (!preg_match('/[a-z]/', $value)) {
               $this->_error(self::LOWER);
               $isValid = false;
           }

           if (!preg_match('/\d/', $value)) {
               $this->_error(self::DIGIT);
               $isValid = false;
           }

           return $isValid;
       }
   }

``isValid()`` では四つのチェックを行っていますが、 チェックに失敗してもその場では
``FALSE`` を返していないことに注目しましょう。
これにより、入力されたパスワードが満たしていない条件を **すべて**
示すことができるようになります。たとえば、パスワードとして入力された値が "#$%"
だったとすると、 ``isValid()`` は四つのメッセージをすべて作成し、後で ``getMessages()``
をコールした際にすべて取得できるようになります。


