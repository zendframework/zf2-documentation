.. _zend.filter.input:

Zend_Filter_Input
=================

``Zend_Filter_Input`` は宣言型のインターフェイスです。
複数のフィルタやバリデータを関連付け、それをデータの集合に適用し、
そのフィルタやバリデータで処理した後の結果を取得できます。
デフォルトでは、HTML 出力に適した形式にエスケープされた結果を返します。

このクラスは、外部からのデータのための「檻」と考えるとよいでしょう。
アプリケーションの外部から渡されたデータとは、たとえば *HTTP*
リクエストのパラメータや *HTTP* ヘッダ、ウェブサービス、
データベースから読み込んだデータや他のファイルから読み込んだデータなどのことです。
これらのデータはいったん檻の中に閉じ込められます。
それ以降、アプリケーションからこれらのデータにアクセスするには、
看守に対して「そのデータが何であって、何の目的で使用するのか」
を説明しなければならなくなります。看守はその説明の内容に応じてデータの妥当性を検証します。
状況に応じて、適切にデータのエスケープも行います。
これらの処理を終えたデータしか、檻の中から外に出ることができません。
シンプルで便利なインターフェイスを提供することで、
開発者がよりよいプログラミング習慣を身につけられるようにします。
また、データの利用法について常に気をつけられるようにします。

- **フィルタ** は入力値を変換します。たとえば、値の中の特定の文字を削除したり
  変更したりします。フィルタの目的は、入力値を "正規化"
  して期待通りの書式にすることです。
  たとえば、数値形式の文字列を必要とする場面で入力値が "abc123"
  だったとしましょう。この場合は、 文字列を "123" に変換するのが妥当でしょう。

- **バリデータ** は入力値が特定の条件を満たしているかどうかを調べ、
  その結果を返します。条件を満たしていなくても、
  値自体には手を加えません。たとえば、
  メールアドレス形式の文字列が必要な場面で入力値が "abc123"
  だったとしましょう。この場合は、
  入力値は妥当なものではないと判断されるでしょう。

- **エスケーパ** は、特定の文字が特殊な働きをしないようにするために
  入力値を変換するものです。
  状況によっては、特定の文字が特殊な意味を持つことがあります。 たとえば、'<'
  および '>' は HTML タグの区切り文字を表します。 もしこれらの文字を含む文字列を
  HTML として出力しようとすると、 これらの文字を含む部分が HTML
  の出力や機能になんらかの影響を与えてしまいます。
  これらの文字をエスケープすることで特殊な意味を除去し、
  通常の文字として出力できるようになります。

``Zend_Filter_Input`` は、以下の手順で使用します。

. フィルタルールおよび検証ルールを宣言する

. フィルタおよびバリデータの処理装置を作成する

. 入力データを渡す

. 検証済みのフィールドやその他の結果情報を取得する

以下のセクションでは、このクラスの使用法について順を追って説明していきます。

.. _zend.filter.input.declaring:

フィルタルールおよび検証ルールの宣言
------------------

``Zend_Filter_Input`` のインスタンスを作成する前に、
フィルタルールと検証ルールの配列を宣言します。
これらの連想配列は、ルールの名前を フィルタやバリデータの名前、
あるいはフィルタチェインやバリデータチェインの名前と関連付けるものです。

次の例のフィルタルールは、'month' フィールドを ``Zend_Filter_Digits``
でフィルタリングし、'account' フィールドを ``Zend_Filter_StringTrim``
でフィルタリングすることを表します。 また、検証ルールでは、'account'
フィールドには英字のみを許可することを指定しています。

.. code-block:: php
   :linenos:

   $filters = array(
       'month'   => 'Digits',
       'account' => 'StringTrim'
   );

   $validators = array(
       'account' => 'Alpha'
   );

*$filters* 配列の各キーは、
特定のデータフィールドにフィルタを適用するルールの名前となります。
デフォルトでは、ルールの名前とそのルールを適用する入力フィールドの名前が等しくなります。

ルールの定義方法には、いくつかの方式があります。

- 単一のスカラー文字列。これはクラス名に対応します。

     .. code-block:: php
        :linenos:

        $validators = array(
            'month'   => 'Digits',
        );



- Zend_Filter_Interface あるいは Zend_Validate_Interface
  を実装したクラスのいずれかのインスタンス。

     .. code-block:: php
        :linenos:

        $digits = new Zend_Validate_Digits();

        $validators = array(
            'month'   => $digits
        );



- フィルタあるいはバリデータのチェインを宣言する配列。
  この配列の要素が、クラス名あるいはフィルタオブジェクト、
  バリデータオブジェクトに対応します。それぞれ上で説明したのと同じ形式です。
  さらに、もうひとつの方法があります。
  クラス名の後にそのコンストラクタに渡す引数を続ける方法です。

     .. code-block:: php
        :linenos:

        $validators = array(
            'month'   => array(
                'Digits',                // 文字列
                new Zend_Validate_Int(), // オブジェクトのインスタンス
                array('Between', 1, 12)  // 文字列とコンストラクタの引数
            )
        );



.. note::

   配列内でコンストラクタへの引数をつけてフィルタやバリデータを宣言すると、
   そのルールの中にフィルタやバリデータがひとつしかない場合でも
   配列形式でルールを作成しなければならなくなります。

ルールのキーとして、特別な "ワイルドカード" 文字 **'*'**
を使用してフィルタ配列やバリデータ配列を作成できます。
このルールで宣言したフィルタやバリデータは、
すべての入力フィールドに適用されます。
フィルタ配列やバリデータ配列内のエントリの並び順には意味があることに注意しましょう。
ルールは、それを宣言した順に適用されます。

.. code-block:: php
   :linenos:

   $filters = array(
       '*'     => 'StringTrim',
       'month' => 'Digits'
   );

.. _zend.filter.input.running:

フィルタおよびバリデータの処理装置の作成
--------------------

フィルタやバリデータの配列を宣言したら、 それを ``Zend_Filter_Input``
のコンストラクタの引数で指定します。
その結果、すべてのフィルタリング規則と検証規則を知っているオブジェクトが返されます。
このオブジェクトを使用して、入力データを処理していきます。

.. code-block:: php
   :linenos:

   $input = new Zend_Filter_Input($filters, $validators);

入力データは、コンストラクタの第三引数として指定できます。
このデータは、連想配列形式で指定します。フィールド名が連想配列のキー、
それに対応する値がデータの値となります。 *PHP* が標準機能として提供している
*$_GET* や *$_POST* といったスーパーグローバル変数がこの形式となります。
つまり、これらのスーパーグローバル変数を、直接 ``Zend_Filter_Input``
への入力として渡すことができます。

.. code-block:: php
   :linenos:

   $data = $_GET;

   $input = new Zend_Filter_Input($filters, $validators, $data);

あるいは、 ``setData()`` メソッドを使用してデータを渡すこともできます。
ここで渡すデータの形式は、先ほど説明したのと同じ形式の連想配列となります。

.. code-block:: php
   :linenos:

   $input = new Zend_Filter_Input($filters, $validators);
   $input->setData($newData);

``setData()`` メソッドは、既存の ``Zend_Filter_Input`` オブジェクトに対して
フィルタルールや検証ルールはそのままで別の入力データを再定義できます。
このメソッドを使用すると、同じルールを
複数の異なる入力データに対して適用できます。

.. _zend.filter.input.results:

検証済みのフィールドやその他の結果情報の取得
----------------------

フィルタやバリデータを宣言し、入力処理装置を作成したら、
次はその結果を取得する番です。存在しないフィールド、
未知のフィールド、無効なフィールドなどの情報のほかに、
フィルタを適用した後の値を含むフィールドの内容も取得できます。

.. _zend.filter.input.results.isvalid:

入力が妥当かどうかの問い合わせ
^^^^^^^^^^^^^^^

すべての入力データがバリデーションルールを通過すると、 ``isValid()`` メソッドは
``TRUE`` を返します。
無効な形式の入力や必須フィールドの未入力がひとつでもあると、 ``isValid()`` は
``FALSE`` を返します。

.. code-block:: php
   :linenos:

   if ($input->isValid()) {
     echo "OK\n";
   }

このメソッドには、オプションで文字列の引数を指定できます。
ここには、フィールドの名前を指定します。
指定したフィールドがバリデーションを通過して取得可能になると、
``isValid('fieldName')`` は ``TRUE`` を返します。

.. code-block:: php
   :linenos:

   if ($input->isValid('month')) {
     echo "'month' フィールドの内容は正しい形式です\n";
   }

.. _zend.filter.input.results.reports:

無効なフィールド、存在しないフィールド、未知のフィールドの取得
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **無効な (invalid)** フィールドとは、検証を通過しなかったフィールドのことです。

- **存在しない (missing)** フィールドとは、入力データ中には存在しないが
  メタコマンドでは ``'presence'=>'required'``
  のように定義されているフィールドのことです (メタコマンドについては
  :ref:`後のセクション <zend.filter.input.metacommands.presence>` を参照ください)。

- **未知の (unknown)**
  フィールドとは、バリデータの配列のルールとしては宣言されていないが
  入力データには存在するフィールドのことです。

.. code-block:: php
   :linenos:

   if ($input->hasInvalid() || $input->hasMissing()) {
     $messages = $input->getMessages();
   }

   // getMessages() は単に、getInvalid() と getMissing() を
   // マージしたものを返します

   if ($input->hasInvalid()) {
     $invalidFields = $input->getInvalid();
   }

   if ($input->hasMissing()) {
     $missingFields = $input->getMissing();
   }

   if ($input->hasUnknown()) {
     $unknownFields = $input->getUnknown();
   }

``getMessages()`` メソッドの返り値は連想配列となります。
ルール名と、そのルールに関連するエラーメッセージの配列を関連付けたものです。
この配列のインデックスは、ルールを宣言したときに使用したルール名であることに注意しましょう。
これは、そのルールによるチェックを行ったフィールド名とは異なります。

``getMessages()`` メソッドが返す配列は、 ``getInvalid()`` と ``getMissing()``
の結果をマージしたものとなります。
これらのメソッドは、それぞれバリデーションに失敗したときのメッセージと
必須入力項目が未入力の場合のメッセージを返すものです。

``getErrors()`` メソッドは、 ルールの名前とエラー ID
の配列を対応させた連想配列を返します。 エラー ID
は固定文字列で、検証に失敗した原因を表します。
エラーメッセージは変更可能です。詳細は :ref:` <zend.validate.introduction.using>`
を参照ください。

``getMissing()`` が返すメッセージは、オプション 'missingMessage' で指定できます。
これは、 ``Zend_Filter_Input`` のコンストラクタへの引数か、あるいは ``setOptions()``
メソッドで指定します。

.. code-block:: php
   :linenos:

   $options = array(
       'missingMessage' => "Field '%field%' is required"
   );

   $input = new Zend_Filter_Input($filters, $validators, $data, $options);

   // もうひとつの方法

   $input = new Zend_Filter_Input($filters, $validators, $data);
   $input->setOptions($options);

``Zend_Filter_Input`` によって返されるメッセージで、
複数の言語を提供できるようにするトランスレータも追加できます。

.. code-block:: php
   :linenos:

   $translate = new Zend_Translator_Adapter_Array(array(
       'content' => array(
           Zend_Filter_Input::MISSING_MESSAGE => "Where is the field?"
       )
   );

   $input = new Zend_Filter_Input($filters, $validators, $data);
   $input->setTranslator($translate);

アプリケーション全体のトランスレータを使っているときは、 それは
``Zend_Filter_Input`` でも使われます。
この場合、手動でトランスレータを設定する必要はありません。

``getUnknown()`` メソッドの結果は、
フィールド名とフィールドの値を対応させた連想配列となります。
ここで配列のキーとして使われるのはフィールド名であり、
ルールの名前ではありません。
どれが未知のフィールドなのかを表すのに、ルール名では具合が悪いからです。

.. _zend.filter.input.results.escaping:

有効なフィールドの取得
^^^^^^^^^^^

無効でもなければ存在しないわけでもなく、
かつ未知でもないフィールドが、有効なフィールドとみなされます。
有効なフィールドの値を取得するためのマジックメソッドが用意されています。
また、それ以外にも ``getEscaped()`` および ``getUnescaped()`` というメソッドがあります。

.. code-block:: php
   :linenos:

   $m = $input->month;                 // エスケープ済み (マジックメソッド)
   $m = $input->getEscaped('month');   // エスケープ済み
   $m = $input->getUnescaped('month'); // エスケープ前

デフォルトでは、値を取得する際には ``Zend_Filter_HtmlEntities``
によるフィルタリングが行われます。
これがデフォルトとなっている理由は、ほとんどの場合は フィールドの値を HTML
に出力するであろうと考えられるからです。 HtmlEntities フィルタを使用すると、 HTML
に予期せぬ出力が現れないようにして セキュリティ上の問題を防ぎます。

.. note::

   上で見たように、エスケープしていない値も ``getUnescaped()``
   メソッドで取得できます。 しかし、この値を使用する際は注意が必要です。
   クロスサイトスクリプティング攻撃に対する脆弱性のような
   セキュリティ上の問題を発生させないようにしましょう。

.. warning::

   **検証していないフィールドのエスケープ**

   先ほど説明したように、 ``getEscaped()`` が返すのは検証済みのフィールドだけです。
   バリデータに関連づけられていないフィールドは、この方法では取得できません。
   しかし、それを解決する方法もあります。
   何もしないバリデータをすべてのフィールドに追加すればいいのです。

   .. code-block:: php
      :linenos:

      $validators = array('*' => array());

      $input = new Zend_Filter_Input($filters, $validators, $data, $options);

   この方式はセキュリティ面で問題があり、
   クロスサイトスクリプティング攻撃に使われる可能性があることに注意しましょう。
   各フィールドに対して個別にバリデータを設定しておくべきです。

別のフィルタによるエスケープを行うことも可能です。
その場合は、それをコンストラクタのオプション配列で指定します。

.. code-block:: php
   :linenos:

   $options = array('escapeFilter' => 'StringTrim');
   $input = new Zend_Filter_Input($filters, $validators, $data, $options);

あるいは、 ``setDefaultEscapeFilter()`` メソッドを使用することもできます。

.. code-block:: php
   :linenos:

   $input = new Zend_Filter_Input($filters, $validators, $data);
   $input->setDefaultEscapeFilter(new Zend_Filter_StringTrim());

どちらの場合についても、エスケープフィルタの指定方法は
フィルタクラスのベース名を表す文字列かフィルタクラスのインスタンスの
いずれかとなります。エスケープフィルタとして使用できるのは、
フィルタチェインのインスタンスか ``Zend_Filter`` クラスのオブジェクトです。

出力をエスケープするフィルタは、このように
バリデーションの終了後に適用しなければなりません。
フィルタルールで指定したその他のフィルタは、
バリデーションの前に適用されます。
エスケープフィルタをバリデーションの前に適用してしまうと、
バリデーション作業がより複雑になってしまい、
エスケープ前の値とエスケープ後の値を両方管理するのが難しくなります。
出力をエスケープするフィルタは、 *$filters* 配列ではなく ``setDefaultEscapeFilter()``
で宣言することをお勧めします。

``getEscaped()`` というメソッドがひとつあるだけなので、
エスケープ用のフィルタはひとつだけしか指定できません
(とはいえ、そのフィルタとしてフィルタチェインを指定することもできます)。
ひとつの ``Zend_Filter_Input`` のインスタンスから
複数のフィルタリングメソッドの結果を返したい場合は、 ``Zend_Filter_Input``
を継承したサブクラスで新しいメソッドを実装して対応しましょう。

.. _zend.filter.input.metacommands:

メタコマンドによるフィルタルールやバリデータルールの制御
----------------------------

フィールドとフィルタやバリデータの対応を宣言するのに加えて、
配列を宣言する際に "メタコマンド" を指定できます。 これは、 ``Zend_Filter_Input``
の挙動を制御するオプションです。
メタコマンドは、フィルタ配列やバリデータ配列の値として指定する
文字列インデックスのエントリとなります。

.. _zend.filter.input.metacommands.fields:

FIELDS メタコマンド
^^^^^^^^^^^^^

フィルタやバリデータの名前がそれを適用するフィールドの名前と異なる場合は、
'fields' メタコマンドでフィールド名を指定できます。

このメタコマンドを指定する際に、文字列ではなくクラス定数 ``Zend_Filter_Input::FIELDS``
を使用できます。

.. code-block:: php
   :linenos:

   $filters = array(
       'month' => array(
           'Digits',        // 数値インデックスのフィルタ名 [0]
           'fields' => 'mo' // 文字列インデックスのフィールド名 ['fields']
       )
   );

上の例では、'digits' フィルタを 'mo' という名前の入力フィールドに適用しています。
文字列 'month' は、単なるこのフィルタリングルールのニモニックキーとなります。
'fields' メタコマンドでフィールドを指定した場合は、
これはフィールド名としては使われず、単なるルール名となります。

'fields' メタコマンドのデフォルト値は、現在のルールのインデックスとなります。
上の例の場合は、'fields' メタコマンドを指定しなかった場合は、 'month'
という名前のフィールドにこのルールが適用されます。

'fields' メタコマンドのもうひとつの使用法は、
複数のフィールドの入力を要求するフィルタやバリデータで
フィールドを指定することです。 'fields' メタコマンドに配列を指定すると、
指定したフィールドの配列がフィルタやバリデータへの引数となります。
たとえば、パスワードを登録する場合に、ふたつのフィールドに入力させて
その値が一致することを確認するなどといった処理は、よくあるものです。
配列の引数を受け取り、それらの入力フィールドの値が等しいときにだけ ``TRUE``
を返すバリデータを考えてみましょう。

.. code-block:: php
   :linenos:

   $validators = array(
       'password' => array(
           'StringEquals',
           'fields' => array('password1', 'password2')
       )
   );
   // 仮想クラス Zend_Validate_StringEquals に、
   // ふたつのフィールド 'password1' および 'password2'
   // の値を含む配列を渡します

このルールのバリデーションに失敗した場合は、 ``getInvalid()``
の返り値はルールのキー ('password') となります。'fields'
メタコマンドのフィールド名は用いられません。

.. _zend.filter.input.metacommands.presence:

PRESENCE メタコマンド
^^^^^^^^^^^^^^^

バリデータ配列の各エントリでは、メタコマンド 'presence' を指定できます。
このメタコマンドの値が 'required' の場合は、 そのフィールドの値が必須となります。
未入力の場合は「存在しないフィールド」として報告されます。

このメタコマンドを指定する際に、文字列ではなくクラス定数
``Zend_Filter_Input::PRESENCE`` を使用できます。

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'digits',
           'presence' => 'required'
       )
   );

このメタコマンドのデフォルト値は 'optional' です。

.. _zend.filter.input.metacommands.default:

DEFAULT_VALUE メタコマンド
^^^^^^^^^^^^^^^^^^^^

入力データにそのフィールドが存在しない場合に、もしメタコマンド 'default'
がルールで指定されていれば そのメタコマンドの値がフィールドの値となります。

このメタコマンドを指定する際に、文字列ではなくクラス定数
``Zend_Filter_Input::DEFAULT_VALUE`` を使用できます。

このデフォルト値は、バリデータを適用する前にフィールドの代入されます。
また、そのフィールドのデフォルト値は現在のルールでのみ適用されます。
もしそのフィールドが別のルールから参照されていた場合には、
別のルールを評価する際にはそのフィールドには値が入っていないことになります。
つまり、個々のルールで別々のデフォルト値を宣言できるということです。

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'digits',
           'default' => '1'
       )
   );

   // 'month' フィールドの値がありません
   $data = array();

   $input = new Zend_Filter_Input(null, $validators, $data);
   echo $input->month; // 1 を出力します

*FIELDS* メタコマンドで複数のフィールドをルールに定義している場合、 *DEFAULT_VALUE*
メタコマンドに配列を指定できます。
対応するキーのフィールドの値が存在しない場合に、デフォルト値が用いられます。
*FIELDS* で複数のフィールドを定義しているのに *DEFAULT_VALUE*
がスカラーだった場合は、
配列内のすべてのフィールドに対してその値がデフォルト値として用いられます。

このメタコマンドにはデフォルト値はありません。

.. _zend.filter.input.metacommands.allow-empty:

ALLOW_EMPTY メタコマンド
^^^^^^^^^^^^^^^^^^

デフォルトでは、入力データ中にフィールドが存在すれば、 たとえそれが空文字列
(**''**) であったとしてもバリデータを適用します。
その結果、検証に失敗することもありえます。
たとえば、数値かどうかを調べるバリデータは、
空文字列を通すとエラーを報告します。 空の文字列 (長さゼロの文字列)
の中には文字が含まれないので、 数値を表す文字も含まれないからです。

空の文字列も有効であるとみなしたい場合は、メタコマンド 'allowEmpty' を ``TRUE``
に設定します。
すると、入力データとして空の文字列が渡された場合も検証を通過します。

このメタコマンドを指定する際に、文字列ではなくクラス定数
``Zend_Filter_Input::ALLOW_EMPTY`` を使用できます。

.. code-block:: php
   :linenos:

   $validators = array(
       'address2' => array(
           'Alnum',
           'allowEmpty' => true
       )
   );

このメタコマンドのデフォルト値は ``FALSE`` です。

非常に珍しいケースですが、バリデータは一切登録せずにメタコマンド 'allowEmpty' を
``FALSE`` (つまり、空の値は無効とみなす) と設定した検証ルールを定義すると、
``Zend_Filter_Input`` はデフォルトのエラーメッセージを返します。 このメッセージは
``getMessages()`` で取得できます。 このメッセージは、'notEmptyMessage'
オプションで設定します。 このオプションは、 ``Zend_Filter_Input``
のコンストラクタへの引数か、 あるいは ``setOptions()`` メソッドで指定します。

.. code-block:: php
   :linenos:

   $options = array(
       'notEmptyMessage' => "'%field%' に何か値を入力してください"
   );

   $input = new Zend_Filter_Input($filters, $validators, $data, $options);

   // 別の方法

   $input = new Zend_Filter_Input($filters, $validators, $data);
   $input->setOptions($options);

.. _zend.filter.input.metacommands.break-chain:

BREAK_CHAIN メタコマンド
^^^^^^^^^^^^^^^^^^

デフォルトでは、ひとつのルールに複数のバリデータが登録されている場合は
それをすべて適用し、すべてのエラーメッセージが結果のメッセージに含まれるようになります。

一方、メタコマンド 'breakChainOnFailure' を ``TRUE`` とすると、
どれかひとつのバリデータが失敗すると、
その時点でバリデータチェインが終了するようになります。
チェイン内のそれ以降のバリデータによる入力チェックは行いません。
つまり、指摘されたエラーを修正したとしても、
さらに別のエラーが発生する可能性があるということです。

このメタコマンドを指定する際に、文字列ではなくクラス定数
``Zend_Filter_Input::BREAK_CHAIN`` を使用できます。

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'Digits',
           new Zend_Validate_Between(1,12),
           new Zend_Validate_GreaterThan(0),
           'breakChainOnFailure' => true
       )
   );
   $input = new Zend_Filter_Input(null, $validators);

このメタコマンドのデフォルト値は ``FALSE`` です。

バリデータチェインクラスである ``Zend_Validate``
は、チェインの実行を中断できるという点で ``Zend_Filter_Input`` よりも柔軟です。
バリデータチェインクラスでは、チェイン内のバリデータのひとつが失敗したときに
即時に処理を終了させるオプションが設定できます。 ``Zend_Filter_Input``
の場合は、メタコマンド 'breakChainOnFailure'
の設定がルール内のすべてのバリデータに適用されます。
より柔軟にしたい場合は、バリデータチェインを自前で作成して
それをバリデータルールの定義時に指定します。

.. code-block:: php
   :linenos:

   // breakChainOnFailure 属性を個別に設定した
   // バリデータチェインを作成します
   $chain = new Zend_Validate();
   $chain->addValidator(new Zend_Validate_Digits(), true);
   $chain->addValidator(new Zend_Validate_Between(1,12), false);
   $chain->addValidator(new Zend_Validate_GreaterThan(0), true);

   // さきほど作成したチェインを用いるバリデータルールを宣言します
   $validators = array(
       'month' => $chain
   );
   $input = new Zend_Filter_Input(null, $validators);

.. _zend.filter.input.metacommands.messages:

MESSAGES メタコマンド
^^^^^^^^^^^^^^^

ルール内の個々のバリデータのエラーメッセージを指定するには、メタコマンド
'messages'
を使用します。このメタコマンドの値には、さまざまなものが指定できます。
たとえばひとつのルールの中に複数のバリデータがある場合に
それぞれ別のメッセージを指定したり、
指定したバリデータで特定のエラー条件のときにのみ指定したメッセージを返したりといったことが考えられます。

このメタコマンドを指定する際に、文字列ではなくクラス定数
``Zend_Filter_Input::MESSAGES`` を使用できます。

以下に示すのは、あるバリデータにデフォルトのエラーメッセージを設定する例です。

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'digits',
           'messages' => '月として指定できるのは数字のみです'
       )
   );

エラーメッセージを設定したいバリデータが複数ある場合は、 'messages'
メタコマンドの値として配列を指定します。

この配列の各要素は、それぞれ同じインデックスのバリデータに適用されます。
つまり、 **n** 番目のバリデータのメッセージを指定するには 配列のインデックスに
**n** を指定します。
これを使用して、チェイン内の特定のバリデータにだけメッセージを設定して
それ以外はデフォルトのメッセージを使用するということができます。

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'digits',
           new Zend_Validate_Between(1, 12),
           'messages' => array(
               // バリデータ [0] はデフォルトのメッセージを使用し、
               // バリデータ [1] のみ独自のメッセージを指定します
               1 => '月として指定できるのは 1 から 12 までの値です'
           )
       )
   );

ひとつのバリデータに複数のエラーメッセージが存在する場合は、
メッセージのキーで識別します。
各バリデータクラスにはそれぞれ異なるキーが存在し、そのキーを用いて
それぞれのバリデータクラスが生成するエラーメッセージを識別します。
バリデータクラスでは、メッセージのキーに対応する定数が定義されています。
これらのキーを 'messages' メタコマンドで使用できます。
この場合、文字列ではなく連想配列形式で渡します。

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'digits', new Zend_Validate_Between(1, 12),
           'messages' => array(
               '月として指定できるのは数字のみです',
               array(
                   Zend_Validate_Between::NOT_BETWEEN =>
                       '月の値 %value% は、' .
                       '%min% 以上 %max% 以下の値でなければなりません',
                   Zend_Validate_Between::NOT_BETWEEN_STRICT =>
                       '月の値 %value% は、%min% より大きく、' .
                       'かつ %max% より小さい値でなければなりません'
               )
           )
       )
   );

各バリデータクラスがエラーメッセージを複数持っているかどうかや
それらのメッセージのキー、そしてメッセージのテンプレートで使用できるトークン
等についての情報については、各バリデータクラスのドキュメントを参照ください。

検証ルールのなかにバリデータがひとつだけしかない場合、
あるいはすべてのバリデータで同じメッセージセットを使用する場合は、
配列構造で追加しなくても参照できます。

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           new Zend_Validate_Between(1, 12),
           'messages' => array(
                           Zend_Validate_Between::NOT_BETWEEN =>
                               '月の値 %value% は、' .
                               '%min% 以上 %max% 以下の値でなければなりません',
                           Zend_Validate_Between::NOT_BETWEEN_STRICT =>
                               '月の値 %value% は、%min% より大きく、' .
                               'かつ %max% より小さい値でなければなりません'
           )
       )
   );

.. _zend.filter.input.metacommands.global:

オプションの使用による、全ルールへのメタコマンドの設定
^^^^^^^^^^^^^^^^^^^^^^^^^^^

メタコマンド 'allowEmpty' や 'breakChainOnFailure'、 'presence'
の全ルール共通のデフォルト値は、 ``Zend_Filter_Input`` のコンストラクタの引数 *$options*
で設定できます。これを使用すると、 個別のルールにメタコマンドを設定しなくても
全ルール共通のデフォルト値を設定できます。

.. code-block:: php
   :linenos:

   // デフォルトで、全フィールドに空文字列を許可するようにします
   $options = array('allowEmpty' => true);

   // 空文字列を禁止したいフィールドがある場合は、
   // 個別のルール定義で、この設定を上書きできます
   $validators = array(
       'month' => array(
           'Digits',
           'allowEmpty' => false
       )
   );

   $input = new Zend_Filter_Input($filters, $validators, $data, $options);

メタコマンド 'fields'、'messages' と 'default' については、
このテクニックを使うことができません。

.. _zend.filter.input.namespaces:

フィルタクラスへの名前空間の追加
----------------

デフォルトでは、フィルタやバリデータを文字列で指定した場合は、
対応するクラスを ``Zend_Filter`` 名前空間あるいは ``Zend_Validate``
名前空間から探します。 たとえば、文字列 'digits' でフィルタを指定すると、
``Zend_Filter_Digits`` クラスを探すことになります。

独自のフィルタクラスやバリデータクラスを作成したり、
サードパーティのフィルタやバリデータを使用したりする場合は、
そのクラスの名前空間は ``Zend_Filter`` や ``Zend_Validate`` とは異なるでしょう。
その場合は、 ``Zend_Filter_Input`` に別の名前空間を通知できます。
名前空間は、コンストラクタのオプションで指定できます。

.. code-block:: php
   :linenos:

   $options = array('filterNamespace' => 'My_Namespace_Filter',
                    'validatorNamespace' => 'My_Namespace_Validate');
   $input = new Zend_Filter_Input($filters, $validators, $data, $options);

あるいは、 ``addValidatorPrefixPath($prefix, $path)`` メソッドや ``addFilterPrefixPath($prefix, $path)``
メソッドを使うこともできます。 これらは、 ``Zend_Filter_Input``
が使うプラグインローダへの直接のプロキシとなります。

.. code-block:: php
   :linenos:

   $input->addValidatorPrefixPath('Other_Namespace', 'Other/Namespace');
   $input->addFilterPrefixPath('Foo_Namespace', 'Foo/Namespace');

   // この結果、バリデータの検索順は次のとおりとなります
   // 1. My_Namespace_Validate
   // 2. Other_Namespace
   // 3. Zend_Validate

   // また、フィルタの検索順は次のとおりとなります
   // 1. My_Namespace_Filter
   // 2. Foo_Namespace
   // 3. Zend_Filter

名前空間 ``Zend_Filter`` と ``Zend_Validate`` は削除することができません。
新しい名前空間を追加することだけが可能となっています。
追加した名前空間を先に探し、Zend 名前空間を最後に探すという順序になります。

.. note::

   バージョン 1.5 で関数 ``addNamespace($namespace)`` は非推奨となり、
   代わりにプラグインローダと ``addFilterPrefixPath`` および ``addValidatorPrefixPath``
   が追加されました。 また、定数 ``Zend_Filter_Input::INPUT_NAMESPACE``
   も非推奨となりました。 定数 ``Zend_Filter_Input::VALIDATOR_NAMESPACE`` および
   ``Zend_Filter_Input::FILTER_NAMESPACE`` が 1.7.0 以降のリリースで使用可能です。

.. note::

   バージョン 1.0.4 で、値 ``namespace`` をもつ定数 ``Zend_Filter_Input::NAMESPACE`` が値
   ``inputNamespace`` を持つ定数 ``Zend_Filter_Input::INPUT_NAMESPACE`` に変わりました。 これは、
   *PHP* 5.3 以降の予約語 ``namespace`` に対応させるためです。


