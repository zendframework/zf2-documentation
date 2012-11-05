.. EN-Revision: none
.. _zend.validator.introduction:

導入
==

``Zend_Validate`` コンポーネントは、一般的に必要となるバリデータを提供します。
シンプルなバリデータチェイン機能も持っており、
ひとつのデータに対して複数のバリデータを指定した順に適用できます。

.. _zend.validator.introduction.definition:

バリデータとは?
--------

バリデータは、入力が何らかの要件を満たしているかどうかを調べ、 結果を boolean
値で返します。これは、入力が要件を満たしているかどうかを表します。
入力が要件を満たさなかった場合、バリデータは
その入力がどのように要件を満たさなかったのかについての追加情報も提供します。

たとえば、あるウェブアプリケーションでは 「ユーザ名は 6 文字から 12
文字、かつ英数字のみが使用可能」 という要件があるものとします。
このような場合に入力がそれを満たしているかどうかを調べるために
バリデータを使用できます。
選択したユーザ名がいずれかひとつあるいは両方の要件を満たしていない場合に、
どちらの条件に反していたのかを知ることができるので便利です。

.. _zend.validator.introduction.using:

バリデータの基本的な使用法
-------------

ここで考えたバリデータについての定義をもとにして ``Zend\Validate\Interface``
が作成されました。これは、 ``isValid()`` および ``getMessages()``
のふたつのメソッドを定義するものです。 ``isValid()``
メソッドは指定した値に対する検証を行います。
値が検証条件を満たしている場合にのみ ``TRUE`` を返します。

``isValid()`` が ``FALSE`` を返した場合、 ``getMessages()``
がメッセージの配列を提供します。 ここには検証が失敗した理由が含まれます。
配列のキーは、検証に失敗した原因を表す短い文字列となります。
配列の値は、それに対応する人間が読むためのメッセージです。
キーと値はクラスに依存します。 個々のバリデーションクラス内で、
検証失敗時のメッセージとそれを表す一意なキーを定義しています。
個々のクラスでは、検証失敗の原因を表す定数も用意しています。

.. note::

   ``getMessages()`` メソッドが返す情報は、 直近の ``isValid()``
   コールに関するもののみです。 ``isValid()`` をコールすると、それまでに実行された
   ``isValid()`` によるメッセージはすべて消去されます。
   なぜなら、通常は、毎回異なる値に対して ``isValid()``
   をコールするであろうと考えられるからです。

以下の例では、電子メールアドレスの検証方法を説明します。

   .. code-block:: php
      :linenos:

      $validator = new Zend\Validate\EmailAddress();

      if ($validator->isValid($email)) {
          // email は妥当な形式です
      } else {
          // email は無効な形式です。理由を表示します
          foreach ($validator->getMessages() as $messageId => $message) {
              echo "バリデーションエラー '$messageId': $message\n";
          }
      }



.. _zend.validator.introduction.messages:

メッセージのカスタマイズ
------------

バリデータクラスの ``setMessage()`` メソッドを使用すると、 検証に失敗した場合に
``getMessages()`` が返すメッセージの書式を設定できます。
最初の引数にはエラーメッセージを文字列で指定します。
このメッセージに特定のトークンを含めると、
バリデータがそれを実際の値に置き換えます。 トークン **%value%**
はすべてのバリデータがサポートしており、 これは ``isValid()``
に渡した値に置き換えられます。
その他、バリデーションクラスによっていろいろなトークンをサポートしています。
たとえば、 ``Zend\Validate\LessThan`` では **%max%** というトークンをサポートしています。
``getMessageVariables()`` メソッドは、
そのバリデータがサポートする変数トークンの配列を返します。

オプションの 2 番目の引数は、
使用する検証エラーメッセージテンプレートを表す文字列です。
これはバリデーションクラスで複数の原因を定義している場合に便利です。
この引数を省略すると、バリデーションクラス内で最初に宣言されているメッセージテンプレートを使用します。
多くのバリデーションクラスはエラーメッセージをひとつだけしか持っていないので、
あえてどのメッセージを使用するかを指定する必要はありません。



   .. code-block:: php
      :linenos:

      $validator = new Zend\Validate\StringLength(8);

      $validator->setMessage(
          '文字列 \'%value%\' は短すぎます。最低 %min% 文字以上必要です',
          Zend\Validate\StringLength::TOO_SHORT);

      if (!$validator->isValid('word')) {
          $messages = $validator->getMessages();
          echo current($messages);

          // "文字列 'word' は短すぎます。最低 8 文字以上必要です"
      }



複数のメッセージを ``setMessages()`` メソッドで設定することもできます。
その場合の引数は、キー/メッセージ のペアの配列です。

   .. code-block:: php
      :linenos:

      $validator = new Zend\Validate\StringLength(array('min' => 8, 'max' => 12));

      $validator->setMessages( array(
          Zend\Validate\StringLength::TOO_SHORT => '文字列 \'%value%\' は短すぎます',
          Zend\Validate\StringLength::TOO_LONG  => '文字列 \'%value%\' は長すぎます'
      ));



より柔軟な検証失敗報告をしたい場合のために、
バリデーションクラスがサポートするメッセージトークンと同じ名前のプロパティを使用できます。
どのバリデータでも常に使用可能なプロパティは ``value`` です。 これは、 ``isValid()``
の引数として渡した値を返します。
その他のプロパティについては、バリデーションクラスによって異なります。

   .. code-block:: php
      :linenos:

      require_once 'Zend/Validate/StringLength.php';

      $validator = new Zend\Validate\StringLength(array('min' => 8, 'max' => 12));

      if (!validator->isValid('word')) {
          echo 'これは、単語として無効です: '
              . $validator->value
              . '。その長さが '
              . $validator->min
              . ' から '
              . $validator->max
              . " までの間ではありません\n";
      }



.. _zend.validator.introduction.static:

静的メソッド is() の使用法
----------------

指定したバリデーションクラスを読み込んでそのインスタンスを作成するというのが面倒ならば、
もうひとつの方法として、静的メソッド ``Zend\Validate\Validate::is()``
を実行する方法もあります。このメソッドの最初の引数には、 ``isValid()``
メソッドに渡す入力値を指定します。
二番目の引数は文字列で、バリデーションクラスのベースネーム (``Zend_Validate``
名前空間における相対的な名前) を指定します。 ``is()``
メソッドは自動的にクラスを読み込んでそのインスタンスを作成し、
指定した入力に対して ``isValid()`` メソッドを適用します。

   .. code-block:: php
      :linenos:

      if (Zend\Validate\Validate::is($email, 'EmailAddress')) {
          // email は妥当な形式です
      }



バリデータクラスのコンストラクタにオプションを指定する必要がある場合は、
それを配列で渡すことができます。

   .. code-block:: php
      :linenos:

      require_once 'Zend/Validate.php';

      if (Zend\Validate\Validate::is($value, 'Between', array('min' => 1, 'max' => 12))) {
          // $value は 1 から 12 までの間です
      }



``is()`` メソッドは boolean 値を返します。これは ``isValid()``
メソッドと同じです。静的メソッド ``is()``
を使用した場合は、検証失敗メッセージの内容は使用できません。

この静的な使用法は、その場限りの検証には便利です。
ただ、複数の入力に対してバリデータを適用するのなら、
最初の例の方式、つまりバリデータオブジェクトのインスタンスを作成して その
``isValid()`` メソッドをコールする方式のほうがより効率的です。

また、 ``Zend\Filter\Input`` クラスでも、特定の入力データのセットを処理する際に
複数のフィルタやバリデータを必要に応じて実行させる機能も提供しています。
詳細は :ref:` <zend.filter.input>` を参照ください。

.. _zend.validator.introduction.static.namespaces:

名前空間
^^^^

自分で定義したバリデータを使う際に、 ``Zend\Validate\Validate::is()`` に 4
番目のパラメータを指定できます。
これは、バリデータを探すための名前空間となります。

.. code-block:: php
   :linenos:

   if (Zend\Validate\Validate::is($value, 'MyValidator', array('min' => 1, 'max' => 12),
                         array('FirstNamespace', 'SecondNamespace')) {
       // $value は妥当な値です
   }

``Zend_Validate`` には、名前空間をデフォルトで設定することもできます。
つまり、起動時に一度設定しておけば ``Zend\Validate\Validate::is()``
のたびに指定する必要がなくなるということです。
次のコード片は、上のコードと同じ意味となります。

.. code-block:: php
   :linenos:

   Zend\Validate\Validate::setDefaultNamespaces(array('FirstNamespace', 'SecondNamespace'));
   if (Zend\Validate\Validate::is($value, 'MyValidator', array('min' => 1, 'max' => 12)) {
       // $value は妥当な値です
   }

   iif (Zend\Validate\Validate::is($value, 'OtherValidator', array('min' => 1, 'max' => 12)) {
       // $value は妥当な値です
   }

名前空間の操作のために、次のような便利なメソッド群が用意されています。

- **Zend\Validate\Validate::getDefaultNamespaces()**:
  設定されているすべての名前空間を配列で返します。

- **Zend\Validate\Validate::setDefaultNamespaces()**:
  新たなデフォルト名前空間を設定し、既存の名前空間を上書きします。
  単一の名前空間の場合は文字列、複数の場合は配列で指定できます。

- **Zend\Validate\Validate::addDefaultNamespaces()**:
  新たな名前空間を、既に設定されているものに追加します。
  単一の名前空間の場合は文字列、複数の場合は配列で指定できます。

- **Zend\Validate\Validate::hasDefaultNamespaces()**: デフォルトの名前空間が設定されている場合は
  ``TRUE`` 、 設定されていない場合は ``FALSE`` を返します。

.. _zend.validator.introduction.translation:

メッセージの翻訳
--------

Validate クラスには ``setTranslator()`` メソッドがあり、 ``Zend_Translator``
のインスタンスを指定できます。
これが、検証に失敗したときのメッセージを翻訳します。 ``getTranslator()``
メソッドは、設定されているインスタンスを返します。

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\StringLength(array('min' => 8, 'max' => 12));
   $translate = new Zend\Translator\Translator(
       array(
           'adapter' => 'array',
           'content' => array(
               Zend\Validate\StringLength::TOO_SHORT => 'Translated \'%value%\''
           ),
           'locale' => 'en'
       )
   );

   $validator->setTranslator($translate);

静的メソッド ``setDefaultTranslator()`` で ``Zend_Translator`` のインスタンスを設定すると、
それをすべての検証クラスで使用できます。この設定内容を取得するのが
``getDefaultTranslator()`` です。これを使用すると、
個々のバリデータクラスで手動で翻訳器を設定せずに済むのでコードがシンプルになります。

.. code-block:: php
   :linenos:

   $translate = new Zend\Translator\Translator(
       array(
           'adapter' => 'array',
           'content' => array(
               Zend\Validate\StringLength::TOO_SHORT => 'Translated \'%value%\''
           ),
           'locale' => 'en'
       )
   );
   Zend\Validate\Validate::setDefaultTranslator($translate);

.. note::

   アプリケーション単位のロケールをレジストリで設定している場合は、
   このロケールがデフォルトの翻訳器に適用されます。

時には、検証時に翻訳器を無効にしなければならないこともあるでしょう。
そんな場合は ``setDisableTranslator()`` メソッドを使用します。 このメソッドには boolean
パラメータを指定します。また ``isTranslatorDisabled()`` で現在の値を取得できます。

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\StringLength(array('min' => 8, 'max' => 12));
   if (!$validator->isTranslatorDisabled()) {
       $validator->setDisableTranslator();
   }

``setMessage()``
で独自のメッセージを設定するかわりに翻訳器を使うこともできますが、
その場合は独自に設定したメッセージについても翻訳器が動作することに注意しましょう。


