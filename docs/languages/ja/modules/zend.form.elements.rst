.. _zend.form.elements:

Zend_Form_Element を用いたフォーム要素の作成
===============================

フォームは、いくつかの要素から構成されています。 これらの要素は、 *HTML*
フォームの入力項目に対応します。 ``Zend_Form_Element``
は個々のフォーム要素をカプセル化し、 以下の機能を提供します。

- バリデーション (入力されたデータが妥当か?)

  - 検証エラーのコードやメッセージの取得

- フィルタリング (出力用のエスケープや検証前後の正規化をどうするか?)

- レンダリング (要素をどのように表示するか?)

- メタデータおよび属性 (その要素についての詳細な情報は?)

基底クラスである ``Zend_Form_Element`` は、
ほとんどの場合にうまく利用できるデフォルトを定義しています。
しかし、よく使われる特別な要素については
それを継承したクラスを作成するほうがいいでしょう。 さらに、Zend Framework
には数多くの標準 *XHTML* 要素が同梱されています。 :ref:`標準の要素についての章
<zend.form.standardElements>` を参照ください。

.. _zend.form.elements.loaders:

プラグインローダー
---------

``Zend_Form_Element`` は、 :ref:`Zend_Loader_PluginLoader <zend.loader.pluginloader>`
を使用しており、バリデータやフィルタ、デコレータの場所を指定できます。
それぞれに独自のプラグインローダーが関連付けられており、
アクセサを使用して個別に取得したり変更したりできます。

プラグインローダーのメソッドで使用できるローダーの型は 'validate'、'filter' と
'decorator' です。 この型名は大文字小文字を区別しません。

プラグインローダーを使用するためのメソッドを以下にまとめます。

- *setPluginLoader($loader, $type)*: *$loader* はプラグインローダーオブジェクト、 *$type*
  は上であげた型名のいずれかを指定します。
  これは、指定した型に対応するプラグインローダーを新しく設定します。

- *getPluginLoader($type)*: *$type* に対応するプラグインローダーを取得します。

- *addPrefixPath($prefix, $path, $type = null)*: プレフィックスとパスの関連を、 *$type*
  で指定したローダーに追加します。 *$type* が ``NULL``
  の場合は、すべてのローダーにパスを追加します。
  その際には、それぞれプレフィックスに "\_Validate"、"\_Filter" そして "\_Decorator"
  を追加し、 パスには "Validate/"、"Filter/" そして "Decorator/" を追加します。
  追加するフォーム要素クラス群をすべて共通の階層に配置する場合は、
  このメソッドでベースプレフィックスを設定すると便利です。

- *addPrefixPaths(array $spec)*:
  複数のパスを、ひとつあるいは複数のプラグインローダーに追加します。
  配列の各要素は、キー 'path'、'prefix' および 'type' を含む配列とします。

独自のバリデータやフィルタ、デコレータを作成すると、
複数のフォームで機能を共有したり独自の機能をカプセル化したりすることが簡単になります。

.. _zend.form.elements.loaders.customLabel:

.. rubric:: 独自のラベル

プラグインの使用例としてよくあるのは、
既存の標準クラス群のかわりとして使用することです。 たとえば、'Label'
デコレータの実装を変更し、
最後に常にコロンを追加するようにしたくなったとしましょう。
そんな場合は、独自の 'Label' デコレータを クラスプレフィックスつきで作成し、
それをプレフィックスパスに追加します。

では、独自の Label デコレータを作ってみましょう。
ここではクラスプレフィックスを "My_Decorator" とします。
このクラスは、"My/Decorator/Label.php" というファイルで定義されることになります。

.. code-block:: php
   :linenos:

   class My_Decorator_Label extends Zend_Form_Decorator_Abstract
   {
       protected $_placement = 'PREPEND';

       public function render($content)
       {
           if (null === ($element = $this->getElement())) {
               return $content;
           }
           if (!method_exists($element, 'getLabel')) {
               return $content;
           }

           $label = $element->getLabel() . ':';

           if (null === ($view = $element->getView())) {
               return $this->renderLabel($content, $label);
           }

           $label = $view->formLabel($element->getName(), $label);

           return $this->renderLabel($content, $label);
       }

       public function renderLabel($content, $label)
       {
           $placement = $this->getPlacement();
           $separator = $this->getSeparator();

           switch ($placement) {
               case 'APPEND':
                   return $content . $separator . $label;
               case 'PREPEND':
               default:
                   return $label . $separator . $content;
           }
       }
   }

では、デコレータを探す際にこのプラグインパスを考慮するように
要素に指定してみましょう。

.. code-block:: php
   :linenos:

   $element->addPrefixPath('My_Decorator', 'My/Decorator/', 'decorator');

あるいは、フォームレベルでこれを設定してしまうべ、
すべてのデコレータがこのパスを考慮するようになります。

.. code-block:: php
   :linenos:

   $form->addElementPrefixPath('My_Decorator', 'My/Decorator/', 'decorator');

このパスにデコレータを追加すれば 'My/Decorator/'
にあるデコレータがまず最初に見つけられることになります。 つまり、'Label'
デコレータが必要となる場面ではそのかわりに 'My_Decorator_Label'
が使われることになるわけです。

.. _zend.form.elements.filters:

フィルタ
----

バリデーションの前に、入力の正規化を行えると便利です。
あるいはそれが必要となることもあるでしょう。 たとえば、 *HTML*
タグを除去した後の内容を検証したりといった場合です。
あるいは、入力の前後に含まれるスペースを取り除いてから検証を行わないと
StringLength バリデータが正しい判断をできないなどという場合もあります。
これらの操作は ``Zend_Filter`` が行います。 ``Zend_Form_Element``
はフィルタチェインをサポートしているので、 複数のフィルタを順に適用できます。
フィルタリングは、バリデーションの際や要素の値を *getValue()*
で取得する際に行われます。

.. code-block:: php
   :linenos:

   $filtered = $element->getValue();

フィルタをチェインに追加する方法は、次のふたつです。

- フィルタのインスタンスを渡す

- フィルタの名前 (短い名前、あるいは完全なクラス名) を渡す

では、例を見てみましょう。

.. code-block:: php
   :linenos:

   // フィルタのインスタンス
   $element->addFilter(new Zend_Filter_Alnum());

   // 完全なクラス名
   $element->addFilter('Zend_Filter_Alnum');

   // 短い形式のフィルタ名
   $element->addFilter('Alnum');
   $element->addFilter('alnum');

短い形式の名前とは、通常はフィルタ名からプレフィックスを除いた部分のことです。
デフォルトでは、'Zend_Filter\_' を除いた部分を表します。
また、最初の文字は大文字でも小文字でもかまいません。

.. note::

   **独自のフィルタクラスの使用**

   自作のフィルタクラスを使う場合は、 *addPrefixPath()* を用いてそれを
   ``Zend_Form_Element`` に教えます。 たとえば、'My_Filter'
   プレフィックス配下のフィルタを使う場合は ``Zend_Form_Element``
   に次のように通知します。

   .. code-block:: php
      :linenos:

      $element->addPrefixPath('My_Filter', 'My/Filter/', 'filter');

   (3
   番目の引数が、このアクションを行う際のプラグインローダーであったことを思い出しましょう)

フィルタリング前の値がほしい場合は *getUnfilteredValue()* メソッドを使用します。

.. code-block:: php
   :linenos:

   $unfiltered = $element->getUnfilteredValue();

フィルタについての詳細な情報は :ref:`Zend_Filter のドキュメント <zend.filter.introduction>`
を参照ください。

フィルタ関係のメソッドを以下にまとめます。

- *addFilter($nameOfFilter, array $options = null)*

- *addFilters(array $filters)*

- *setFilters(array $filters)* (すべてのフィルタを上書きします)

- *getFilter($name)* (指定した名前のフィルタオブジェクトを取得します)

- *getFilters()* (すべてのフィルタを取得します)

- *removeFilter($name)* (指定した名前のフィルタを削除します)

- *clearFilters()* (すべてのフィルタを削除します)

.. _zend.form.elements.validators:

バリデータ
-----

セキュリティ界で有名なお言葉 "入力はフィルタリングせよ。
出力はエスケープせよ。" に賛同する人なら、フォームの入力を検証
("入力のフィルタリング") したくなるでしょう。 ``Zend_Form``
では、各要素が個別にバリデータチェインを保持しています。 これは ``Zend_Validate_*``
のバリデータでできています。

バリデータをチェインに追加する方法は、次のふたつです。

- バリデータのインスタンスを渡す

- 短いフィルタ名を渡す

では、例を見てみましょう。

.. code-block:: php
   :linenos:

   // バリデータのインスタンス
   $element->addValidator(new Zend_Validate_Alnum());

   // 短い形式の名前
   $element->addValidator('Alnum');
   $element->addValidator('alnum');

短い形式の名前とは、通常はバリデータ名からプレフィックスを除いた部分のことです。
デフォルトでは、バリデータ名から 'Zend_Validate\_' を除いた部分を表します。
また、最初の文字は大文字でも小文字でもかまいません。

.. note::

   **独自のバリデータクラスの使用**

   自作のバリデータクラスを使う場合は、 *addPrefixPath()* を用いてそれを
   ``Zend_Form_Element`` に教えます。 たとえば、'My_Validator'
   プレフィックス配下のバリデータを使う場合は ``Zend_Form_Element``
   に次のように通知します。

   .. code-block:: php
      :linenos:

      $element->addPrefixPath('My_Validator', 'My/Validator/', 'validate');

   (3
   番目の引数が、このアクションを行う際のプラグインローダーであったことを思い出しましょう)

どれかひとつのバリデーションに失敗したときに
それ以降のバリデータを実行しないようにさせるには、2 番目のパラメータに ``TRUE``
を渡します。

.. code-block:: php
   :linenos:

   $element->addValidator('alnum', true);

バリデータの名前を指定して追加する場合で
そのバリデータクラスのコンストラクタが引数を受け付ける場合は、 *addValidator()* の
3 番目のパラメータに配列形式で指定します。

.. code-block:: php
   :linenos:

   $element->addValidator('StringLength', false, array(6, 20));

この方式で引数を渡す場合は、コンストラクタで定義されているとおりの順で指定する必要があります。
上の例では、 ``Zend_Validate_StringLenth`` クラスのインスタンスを作成する際にパラメータ
*$min* と *$max* を指定しています。

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_StringLength(6, 20);

.. note::

   **独自のバリデートエラーメッセージの指定**

   バリデータのエラーメッセージをカスタマイズしたいこともあるでしょう。
   その場合は、 ``Zend_Form_Element::addValidator()`` の引数 *$options* で、キー 'messages'
   にメッセージテンプレートを指定します。 これは キー/値
   のペアの配列となります。
   これを使用するには、そのバリデータのさまざまな検証エラーに対応する
   エラーコードを知っておく必要があります。

   もっとよいやりかたは、 ``Zend_Translator_Adapter``
   をフォームで使用することでしょう。エラーコードは、
   デフォルトのエラーデコレータが自動的にアダプタに渡します。
   そこで、バリデータのエラーコードに対応する翻訳文字列を設定すればいいのです。

複数のバリデータを一度に設定するには *addValidators()* を使用します。
このメソッドには、配列の配列を渡します。 各配列の要素は 1 から 3 となり、これが
*addValidator()* に渡されます。

.. code-block:: php
   :linenos:

   $element->addValidators(array(
       array('NotEmpty', true),
       array('alnum'),
       array('stringLength', false, array(6, 20)),
   ));

もうすこし詳しくはっきりと書きたい場合は、キー 'validator'、'breakChainOnFailure' そして
'options' を持つ配列を使用することもできます。

.. code-block:: php
   :linenos:

   $element->addValidators(array(
       array(
           'validator'           => 'NotEmpty',
           'breakChainOnFailure' => true),
       array('validator' => 'alnum'),
       array(
           'validator' => 'stringLength',
           'options'   => array(6, 20)),
   ));

この使用法は、設定ファイルを用いてバリデータを設定する場合に便利です。

.. code-block:: ini
   :linenos:

   element.validators.notempty.validator = "NotEmpty"
   element.validators.notempty.breakChainOnFailure = true
   element.validators.alnum.validator = "Alnum"
   element.validators.strlen.validator = "StringLength"
   element.validators.strlen.options.min = 6
   element.validators.strlen.options.max = 20

それが必要か否かにかかわらず、すべての項目がキーを持つことに注意しましょう。
これは、設定ファイルを使用する場合の制限事項となります。
しかし、これにより、その引数がどういう意味なのかをきちんと明示できるようになります。
バリデータのオプションは、正しい順で指定しなければならないことに注意しましょう。

要素を検証するには、その値を *isValid()* に渡します。

.. code-block:: php
   :linenos:

   if ($element->isValid($value)) {
       // 有効
   } else {
       // 無効
   }

.. note::

   **フィルタリング後の値の検証**

   ``Zend_Form_Element::isValid()`` は、 フィルタチェインを通した後の値を検証します。
   詳細は :ref:`フィルタの説明 <zend.form.elements.filters>` を参照ください。

.. note::

   **バリデーションコンテキスト**

   ``Zend_Form_Element::isValid()`` は、 追加の引数 *$context* をサポートしています。
   ``Zend_Form::isValid()`` は、 フォームをバリデートする際にデータの配列を *$context*
   に渡します。一方、 ``Zend_Form_Element::isValid()``
   はそれを個々のバリデータに渡します。
   つまり、他の要素に渡された内容を使用するバリデータも作成できるということです。
   たとえば、パスワードの確認用の入力欄を持つ登録フォームを考えてみましょう。
   この場合、「パスワード」欄と「パスワード (確認)」
   欄の内容が一致するかどうかを確認することになります。
   このようなバリデータは、次のように書きます。

   .. code-block:: php
      :linenos:

      class My_Validate_PasswordConfirmation extends Zend_Validate_Abstract
      {
          const NOT_MATCH = 'notMatch';

          protected $_messageTemplates = array(
              self::NOT_MATCH => 'パスワード (確認) の内容がパスワードと一致しません'
          );

          public function isValid($value, $context = null)
          {
              $value = (string) $value;
              $this->_setValue($value);

              if (is_array($context)) {
                  if (isset($context['password_confirm'])
                      && ($value == $context['password_confirm']))
                  {
                      return true;
                  }
              } elseif (is_string($context) && ($value == $context)) {
                  return true;
              }

              $this->_error(self::NOT_MATCH);
              return false;
          }
      }

バリデータは、順番どおりに処理されます。 すべてのバリデータが実行されますが、
``$breakChainOnFailure`` が true
の場合はどれかひとつのバリデータが検証に失敗した時点で処理を終了します。
バリデータは、適切な順で指定するようにしましょう。

検証に失敗したときは、バリデータチェインから
エラーコードとメッセージを取得できます。

.. code-block:: php
   :linenos:

   $errors   = $element->getErrors();
   $messages = $element->getMessages();

(注意: 返されるエラーメッセージは連想配列形式で、
エラーコードとエラーメッセージのペアとなります)

バリデータに加えて、ある要素が必須である場合は ``setRequired($flag)``
を使用できます。 デフォルトではこのフラグは ``FALSE`` です。 In combination with
``setAllowEmpty($flag)`` (``TRUE`` by default) and ``setAutoInsertNotEmptyValidator($flag)`` (``TRUE`` by default),
the behavior of your validator chain can be modified in a number of ways:

- Using the defaults, validating an Element without passing a value, or passing an empty string for it, skips all
  validators and validates to ``TRUE``.

- ``setAllowEmpty(false)`` leaving the two other mentioned flags untouched, will validate against the validator
  chain you defined for this Element, regardless of the value passed to ``isValid()``.

- ``setRequired(true)`` leaving the two other mentioned flags untouched, will add a 'NotEmpty' validator on top of
  the validator chain (if none was already set)), with the ``$breakChainOnFailure`` flag set.
  これにより、必須フラグがその意味どおりに動作するようになります。
  入力が渡されなかった場合は検証がその時点で失敗し、
  結果をユーザに返します。それ以降のバリデータは実行されません。
  値が空である時点で無効な内容であることが確定しているからです。

  この振る舞いが気に入らない場合は、 *setAutoInsertNotEmptyValidator($flag)* に ``FALSE``
  を渡せばこの機能を無効にできます。 この場合、 *isValid()*
  がバリデータチェインに勝手に 'NotEmpty'
  バリデータを追加することはなくなります。

バリデータについての詳細な情報は :ref:`Zend_Validate のドキュメント
<zend.validate.introduction>` を参照ください。

.. note::

   **Zend_Form_Elements の汎用バリデータとしての使用法**

   ``Zend_Form_Element`` は ``Zend_Validate_Interface`` を実装しています。
   つまり、フォーム以外のバリデータチェインでも
   フォーム要素を使用できるということです。

.. note::

   **When is an element detected as empty?**

   As mentioned the 'NotEmpty' validator is used to detect if an element is empty or not. But
   ``Zend_Validate_NotEmpty`` does, per default, not work like *PHP*'s method ``empty()``.

   This means when an element contains an integer **0** or an string **'0'** then the element will be seen as not
   empty. If you want to have a different behaviour you must create your own instance of
   ``Zend_Validate_NotEmpty``. There you can define the behaviour of this validator. See `Zend_Validate_NotEmpty`_
   for details.

検証関係のメソッドを以下にまとめます。

- *setRequired($flag)* および *isRequired()* は、'required'
  フラグの状態を設定あるいは取得します。 これを ``TRUE`` に設定すると、 ``Zend_Form``
  が処理したデータにその要素が必須であるものとします。

- *setAllowEmpty($flag)* および *getAllowEmpty()* は、オプション要素 (required フラグが ``FALSE``
  に設定されている要素) の挙動を変更します。'allow empty' フラグが ``TRUE`` の場合、
  値が未入力のときはバリデータチェインに渡しません。

- *setAutoInsertNotEmptyValidator($flag)* は、 その要素が必須項目であるときに 'NotEmpty'
  バリデータをバリデータチェインの先頭に追加するかどうかを指定します。
  デフォルトでは、このフラグは ``TRUE`` です。

- ``addValidator($nameOrValidator, $breakChainOnFailure = false, array $options = null)``

- ``addValidators(array $validators)``

- ``setValidators(array $validators)`` (すべてのバリデータを上書きします)

- ``getValidator($name)`` (指定した名前のバリデータオブジェクトを取得します)

- ``getValidators()`` (すべてのバリデータを取得します)

- ``removeValidator($name)`` (指定した名前のバリデータを削除します)

- ``clearValidators()`` (すべてのバリデータを削除します)

.. _zend.form.elements.validators.errors:

独自のエラーメッセージ
^^^^^^^^^^^

時には、要素にアタッチされたバリデータが生成するエラーメッセージではなく
独自のエラーメッセージを指定したくなることもあるでしょう。
さらに、時には自分自身でフォームを無効だとマークしたいこともあるでしょう。
1.6.0 以降、次のメソッドでこの機能を使用できるようになりました。

- *addErrorMessage($message)*:
  フォームの検証エラーの際に表示するエラーメッセージを追加します。
  複数回コールすると、新しいメッセージはスタックに追加されます。

- *addErrorMessages(array $messages)*:
  フォームの検証エラーの際に表示する複数のエラーメッセージを追加します。

- *setErrorMessages(array $messages)*:
  フォームの検証エラーの際に表示する複数のエラーメッセージを追加します。
  それまでに設定されていたすべてのメッセージを上書きします。

- *getErrorMessages()*: 定義済みのカスタムエラーメッセージの一覧を取得します。

- *clearErrorMessages()*: 定義済みのカスタムエラーメッセージをすべて削除します。

- *markAsError()*: 検証に失敗したものとしてフォームにマークします。

- *hasErrors()*:
  要素が、検証失敗か無効とマークのいずれかの状態になっているかどうかを取得します。

- *addError($message)*: add a message to the custom
  エラーメッセージをカスタムエラーメッセージスタックに追加し、
  要素を無効とマークします。

- *addErrors(array $messages)*:
  複数のエラーメッセージをカスタムエラーメッセージスタックに追加し、
  要素を無効とマークします。

- *setErrors(array $messages)*:
  指定したメッセージでカスタムエラーメッセージスタックを上書きし、
  要素を無効とマークします。

この方式で設定したすべてのエラーは翻訳されることになります。
さらに、プレースホルダ "%value%" を使用して要素の値を表すこともできます。
エラーメッセージを取得する際に、この部分が現在の要素の値に置き換えられます。

.. _zend.form.elements.decorators:

デコレータ
-----

多くのウェブ開発者にとって、 *XHTML* のフォームを作成することは悩みの種です。
フォームの要素ひとつひとつに対して ラベルなどのマークアップが必要ですし、
ユーザの使いやすさを考慮して検証エラーメッセージも表示させなければなりません。
要素の数が増えれば増えるほど、この作業量は無視できなくなります。

``Zend_Form_Element`` は、この問題を解決するために "デコレータ"
を使用します。デコレータは、
要素にアクセスしてその中身をレンダリングするためのメソッドを持つクラスです。
デコレータの動作原理については、 :ref:`Zend_Form_Decorator <zend.form.decorators>`
のセクションを参照ください。

``Zend_Form_Element`` がデフォルトで使用するデコレータは次のとおりです。

- **ViewHelper**: 要素のレンダリング用のビューヘルパーを指定します。 要素の 'helper'
  属性を使用して、どのヘルパーを使用するのかを指定します。 デフォルトで
  ``Zend_Form_Element`` は 'formText' ビューヘルパーを使用しますが、
  サブクラスで別のヘルパーを指定することもできます。

- **Errors**: ``Zend_View_Helper_FormErrors``
  を用いて要素の後にエラーメッセージを追加します。
  エラーが発生していない場合は何も行いません。

- **Description**: 要素の後に説明を追加します。
  説明が存在しない場合は何も追加されません。デフォルトでは、 クラス 'description'
  を指定した <p> タグでレンダリングされます。

- **HtmlTag**: ラベルや要素、そしてエラーメッセージを *HTML* の <dd> タグで囲みます。

- **Label**: ``Zend_View_Helper_FormLabel`` を用いて要素の前にラベルを追加し、それを <dt>
  タグで囲みます。
  ラベルが存在しない場合は、用語定義タグのみをレンダリングします。

.. note::

   **読み込み不要なデフォルトのデコレータ**

   デフォルトのデコレータは、
   オブジェクトの初期化時に読み込まれるようになっています。
   この機能を無効にするには、コンストラクタでオプション 'disableLoadDefaultDecorators'
   を指定します。

   .. code-block:: php
      :linenos:

      $element = new Zend_Form_Element('foo',
                                       array('disableLoadDefaultDecorators' =>
                                            true)
                                      );

   このオプションは、他のオプションと混用することもできます。
   その場合はオプションの配列や ``Zend_Config`` オブジェクトを使用します。

デコレータの実行順序は登録された順によって決まります。
つまり、最初に登録したデコレータから順に実行することになります。
したがって、デコレータを登録するときにはその順番に気をつけなければなりません。
あるいは、placement オプションを明示的に指定して順序を決めることもできます。
例として、デフォルトのデコレータを登録するコードを示します。

.. code-block:: php
   :linenos:

   $this->addDecorators(array(
       array('ViewHelper'),
       array('Errors'),
       array('Description', array('tag' => 'p', 'class' => 'description')),
       array('HtmlTag', array('tag' => 'dd')),
       array('Label', array('tag' => 'dt')),
   ));

最初のコンテンツを作成するのは 'ViewHelper'
デコレータで、これはフォーム要素そのものを作成します。 次に 'Errors'
デコレータがその要素のエラーメッセージを取得し、
もしエラーが発生していた場合はそれをビューヘルパー 'FormErrors'
に渡してレンダリングさせます。 説明が存在する場合は、'Description'
デコレータがクラス 'description'
の段落を追加します。ここには、そのコンテンツの内容を説明するテキストが書き込まれます。
その次のデコレータである 'HtmlTag' は、要素とエラーと説明文を *HTML* の <dd>
タグで囲みます。最後に、'label'
が要素のラベルを取得します。それをビューヘルパー 'FormLabel' に渡し、 *HTML* の <dt>
で囲みます。 ラベルの内容は、デフォルトでコンテンツの前に付加されます。
出力結果は、基本的にはこのようになります。

.. code-block:: html
   :linenos:

   <dt><label for="foo" class="optional">Foo</label></dt>
   <dd>
       <input type="text" name="foo" id="foo" value="123" />
       <ul class="errors">
           <li>"123" is not an alphanumeric value</li>
       </ul>
       <p class="description">
           This is some descriptive text regarding the element.
       </p>
   </dd>

デコレータについての詳細な情報は :ref:`Zend_Form_Decorator のセクション
<zend.form.decorators>` を参照ください。

.. note::

   **同じ型の複数のデコレータの使用法**

   内部的には、 ``Zend_Form_Element``
   はデコレータのクラス名をもとにしてデコレータを取得しています。
   つまり、同じ型のデコレータを複数登録することはできないということです。
   複数回登録すると、それまでに登録されていたデコレータを上書きします。

   これを回避するには、 **エイリアス** を使用します。 デコレータやデコレータ名を
   *addDecorator()*
   の最初の引数として渡すのではなく、ひとつの要素からなる配列を渡します。
   この配列には、デコレータオブジェクトあるいはデコレータ名を指すエイリアスを指定します。

   .. code-block:: php
      :linenos:

      // 'FooBar' へのエイリアス
      $element->addDecorator(array('FooBar' => 'HtmlTag'),
                             array('tag' => 'div'));

      // 後で、このように取得できます
      $decorator = $element->getDecorator('FooBar');

   *addDecorators()* メソッドおよび *setDecorators()* メソッドでは、
   デコレータを表す配列を 'decorator' オプションに渡す必要があります。

   .. code-block:: php
      :linenos:

      // ふたつの 'HtmlTag' デコレータを使用するため、片方に 'FooBar' というエイリアスを指定します
      $element->addDecorators(
          array('HtmlTag', array('tag' => 'div')),
          array(
              'decorator' => array('FooBar' => 'HtmlTag'),
              'options' => array('tag' => 'dd')
          ),
      );

      // 後で、このように取得できます
      $htmlTag = $element->getDecorator('HtmlTag');
      $fooBar  = $element->getDecorator('FooBar');

デコレータ関連のメソッドを以下にまとめます。

- *addDecorator($nameOrDecorator, array $options = null)*

- *addDecorators(array $decorators)*

- *setDecorators(array $decorators)* (すべてのデコレータを上書きします)

- *getDecorator($name)* (指定した名前のデコレータオブジェクトを取得します)

- *getDecorators()* (すべてのデコレータを取得します)

- *removeDecorator($name)* (指定した名前のデコレータを削除します)

- *clearDecorators()* (すべてのデコレータを削除します)

``Zend_Form_Element`` は、
オーバーロードを使用して特定のデコレータをレンダリングすることもできます。
'render' で始まる名前のメソッドを *__call()*
で捕捉し、メソッド名の残りの部分にもとづいてデコレータを探します。
見つかった場合は、そのデコレータ **だけ** をレンダリングします。
引数を渡すと、それがデコレータの *render()*
メソッドにコンテンツとして渡されます。次の例を参照ください。

.. code-block:: php
   :linenos:

   // ViewHelper デコレータのみをレンダリングします
   echo $element->renderViewHelper();

   // HtmlTag デコレータにコンテンツを渡してレンダリングします
   echo $element->renderHtmlTag("This is the html tag content");

デコレータが存在しない場合は、例外が発生します。

.. _zend.form.elements.metadata:

メタデータおよび属性
----------

``Zend_Form_Element`` は、 要素の属性やメタデータを処理できます。
基本的な属性には次のようなものがあります。

- **name**: 要素名。 *setName()* および *getName()* でアクセスします。

- **label**: 要素のラベル。 *setLabel()* および *getLabel()* でアクセスします。

- **order**: 要素がフォーム内で登場する際のインデックス。 *setOrder()* および *getOrder()*
  でアクセスします。

- **value**: 現在の要素の値。 *setValue()* および *getValue()* でアクセスします。

- **description**: 要素の説明。 ツールチップや javascript
  のコンテキストヒントで用いられるもので、
  その要素の使用目的などを説明します。 *setDescription()* および *getDescription()*
  でアクセスします。

- **required**: バリデーション時にその要素を必須とみなすかどうか。 *setRequired()*
  および *getRequired()* でアクセスします。このフラグはデフォルトでは ``FALSE`` です。

- **allowEmpty**: 必須でない (オプションの) 要素が未入力のときに検証を行うかどうか。
  このフラグが ``TRUE`` で required フラグが ``FALSE`` の場合は、
  値が未入力ならバリデータチェインにその要素を渡さず、
  検証に成功したものとみなします。 *setAllowEmpty()* および *getAllowEmpty()*
  でアクセスします。このフラグはデフォルトでは ``TRUE`` です。

- **autoInsertNotEmptyValidator**: 要素が必須であるときに 'NotEmpty'
  バリデータを追加するかどうかを表すフラグ。 デフォルトではこのフラグは ``TRUE``
  です。フラグを設定するには *setAutoInsertNotEmptyValidator($flag)*\ 、 値を調べるには
  *autoInsertNotEmptyValidator()* を使用します。

フォームの要素の中にはメタデータを要するものもあります。たとえば *XHTML*
のフォーム要素では、class や id といった属性を指定することになるでしょう。
これは、次のメソッドで行います。

- **setAttrib($name, $value)**: 属性を追加します。

- **setAttribs(array $attribs)**: addAttribs() と似ていますが、すべて上書きします。

- **getAttrib($name)**: 特定の属性の値を取得します。

- **getAttribs()**: すべての属性を キー/値 のペアで取得します。

しかし、たいていの場合はもっとシンプルにオブジェクトのプロパティとしてアクセスすることになるでしょう。
``Zend_Form_Element`` はオーバーロードを使用してこの機能を実現しています。

.. code-block:: php
   :linenos:

   // $element->setAttrib('class', 'text') と同じ意味です
   $element->class = 'text;

デフォルトでは、すべての属性がビューヘルパーに渡され、
要素の描画時に使用します。これらの属性は、要素タグの *HTML*
属性として設定されます。

.. _zend.form.elements.standard:

標準の要素
-----

``Zend_Form`` には、標準的な要素が同梱されています。詳細は :ref:`標準要素
<zend.form.standardElements>` の章を参照ください。

.. _zend.form.elements.methods:

Zend_Form_Element のメソッド
-----------------------

``Zend_Form_Element`` には非常にたくさんのメソッドがあります。
以下に、それらのシグネチャを種類別に分けて簡単にまとめました。

- 設定

  - ``setOptions(array $options)``

  - ``setConfig(Zend_Config $config)``

- I18n

  - ``setTranslator(Zend_Translator_Adapter $translator = null)``

  - ``getTranslator()``

  - ``setDisableTranslator($flag)``

  - ``translatorIsDisabled()``

- プロパティ

  - ``setName($name)``

  - ``getName()``

  - ``setValue($value)``

  - ``getValue()``

  - ``getUnfilteredValue()``

  - ``setLabel($label)``

  - ``getLabel()``

  - ``setDescription($description)``

  - ``getDescription()``

  - ``setOrder($order)``

  - ``getOrder()``

  - ``setRequired($flag)``

  - ``getRequired()``

  - ``setAllowEmpty($flag)``

  - ``getAllowEmpty()``

  - ``setAutoInsertNotEmptyValidator($flag)``

  - ``autoInsertNotEmptyValidator()``

  - ``setIgnore($flag)``

  - ``getIgnore()``

  - ``getType()``

  - ``setAttrib($name, $value)``

  - ``setAttribs(array $attribs)``

  - ``getAttrib($name)``

  - ``getAttribs()``

- プラグインローダーとパス

  - ``setPluginLoader(Zend_Loader_PluginLoader_Interface $loader, $type)``

  - ``getPluginLoader($type)``

  - ``addPrefixPath($prefix, $path, $type = null)``

  - ``addPrefixPaths(array $spec)``

- 検証

  - ``addValidator($validator, $breakChainOnFailure = false, $options = array())``

  - ``addValidators(array $validators)``

  - ``setValidators(array $validators)``

  - ``getValidator($name)``

  - ``getValidators()``

  - ``removeValidator($name)``

  - ``clearValidators()``

  - ``isValid($value, $context = null)``

  - ``getErrors()``

  - ``getMessages()``

- フィルタ

  - ``addFilter($filter, $options = array())``

  - ``addFilters(array $filters)``

  - ``setFilters(array $filters)``

  - ``getFilter($name)``

  - ``getFilters()``

  - ``removeFilter($name)``

  - ``clearFilters()``

- レンダリング

  - ``setView(Zend_View_Interface $view = null)``

  - ``getView()``

  - ``addDecorator($decorator, $options = null)``

  - ``addDecorators(array $decorators)``

  - ``setDecorators(array $decorators)``

  - ``getDecorator($name)``

  - ``getDecorators()``

  - ``removeDecorator($name)``

  - ``clearDecorators()``

  - ``render(Zend_View_Interface $view = null)``

.. _zend.form.elements.config:

設定
--

``Zend_Form_Element`` のコンストラクタには、配列あるいは ``Zend_Config``
オブジェクトでオプションを指定できます。 また、 ``setOptions()`` や ``setConfig()``
で設定を変更することもできます。 一般に、キーの名前は次のようになります。

- 'set' + キーの名前のメソッドが ``Zend_Form_Element``
  にあれば、値をそのメソッドに渡します。

- それ以外の場合は、属性を使用して値を設定します。

このルールには、次のような例外があります。

- ``prefixPath`` は ``addPrefixPaths()`` に渡されます。

- 以下のセッターはこの方式では設定できません。

  - ``setAttrib`` (ただし、 ``setAttribs`` は **動作します**)

  - ``setConfig``

  - ``setOptions``

  - ``setPluginLoader``

  - ``setTranslator``

  - ``setView``

例として、すべての型の設定データを渡すファイルを見てみましょう。

.. code-block:: ini
   :linenos:

   [element]
   name = "foo"
   value = "foobar"
   label = "Foo:"
   order = 10
   required = true
   allowEmpty = false
   autoInsertNotEmptyValidator = true
   description = "Foo elements are for examples"
   ignore = false
   attribs.id = "foo"
   attribs.class = "element"
   ; sets 'onclick' attribute
   onclick = "autoComplete(this, '/form/autocomplete/element')"
   prefixPaths.decorator.prefix = "My_Decorator"
   prefixPaths.decorator.path = "My/Decorator/"
   disableTranslator = 0
   validators.required.validator = "NotEmpty"
   validators.required.breakChainOnFailure = true
   validators.alpha.validator = "alpha"
   validators.regex.validator = "regex"
   validators.regex.options.pattern = "/^[A-F].*/$"
   filters.ucase.filter = "StringToUpper"
   decorators.element.decorator = "ViewHelper"
   decorators.element.options.helper = "FormText"
   decorators.label.decorator = "Label"

.. _zend.form.elements.custom:

カスタム要素
------

独自の要素を作成するには ``Zend_Form_Element`` クラスを継承したクラスを作成します。
独自の要素を作成することになるのは、たとえば次のような場合です。

- 共通のバリデータやフィルタを持つ要素を作成する

- 独自のデコレータ機能を持つ要素を作成する

要素を継承する際に主に使用するメソッドは次の 2 つです。 ``init()``
で独自の初期化ロジックをあなたの要素に追加し、 ``loadDefaultDecorators()``
でデフォルトのデコレータのリストをあなたの要素に設定します。,

たとえば、あなたが作成するフォーム上のテキストボックスでは、すべて ``StringTrim``
フィルタが必要で、 かつ正規表現による入力検証を行うことになるとしましょう。
ついでに、表示用に独自のデコレータ 'My_Decorator_TextItem'
も使用するものとします。さらに、標準の属性 'size' や 'maxLength'、そして 'class'
なども設定します。 このような要素は、次のように定義します。

.. code-block:: php
   :linenos:

   class My_Element_Text extends Zend_Form_Element
   {
       public function init()
       {
           $this->addPrefixPath('My_Decorator', 'My/Decorator/', 'decorator')
                ->addFilters('StringTrim')
                ->addValidator('Regex', false, array('/^[a-z0-9]{6,}$/i'))
                ->addDecorator('TextItem')
                ->setAttrib('size', 30)
                ->setAttrib('maxLength', 45)
                ->setAttrib('class', 'text');
       }
   }

それから、フォームオブジェクトに対して
この要素のプレフィックスパスを登録した上で要素を作成します。

.. code-block:: php
   :linenos:

   $form->addPrefixPath('My_Element', 'My/Element/', 'element')
        ->addElement('text', 'foo');

'foo' 要素はこれで ``My_Element_Text``
型となりました。先ほど説明したような機能を持つテキストボックスです。

``Zend_Form_Element`` を継承したクラスでオーバーライドしたくなる
その他のメソッドとして、 ``loadDefaultDecorators()``
があります。このメソッドは、条件付きで
要素にデフォルトのデコレータセットを読み込みます。
継承したクラスで、このデコレータ群を置き換えることができます。

.. code-block:: php
   :linenos:

   class My_Element_Text extends Zend_Form_Element
   {
       public function loadDefaultDecorators()
       {
           $this->addDecorator('ViewHelper')
                ->addDecorator('DisplayError')
                ->addDecorator('Label')
                ->addDecorator('HtmlTag',
                               array('tag' => 'div', 'class' => 'element'));
       }
   }

要素のカスタマイズにはさまざまな方法があります。 ``Zend_Form_Element`` の *API*
ドキュメントを熟読し、 どんな機能が使用できるのかを覚えていきましょう。



.. _`Zend_Validate_NotEmpty`: zend.validate.set.notempty
