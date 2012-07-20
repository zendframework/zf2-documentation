.. _zend.form.decorators:

Zend_Form_Decorator による独自のフォームマークアップの作成
=======================================

フォームオブジェクトのレンダリングは、完全に別の処理です。 ``Zend_Form`` の render()
メソッドを使わなくてもかまいません。 しかし、もし使う場合は
フォームオブジェクトのレンダリングにはデコレータを使用します。

任意の数のデコレータを各項目
(要素、表示グループ、サブフォーム、あるいはフォームオブジェクト自体)
にアタッチできます。しかし、
同じ型のデコレータは各項目にひとつだけしかアタッチすることができません。
デコレータは、登録した順にコールされます。
デコレータの種類によっては、渡されたコンテンツを書き換えたり
前後にコンテンツを追加したりするものもあります。

オブジェクトの状態を設定するには、コンストラクタあるいは デコレータの
``setOptions()`` メソッドにオプションを渡します。 各項目の ``addDecorator()``
系のメソッドでデコレータを作成する際には、
そのメソッドの引数でオプションを指定できます。
これを使用して、配置方法や区切り文字などのデコレータ用オプションを指定します。

各デコレータの ``render()`` メソッドがコールされる前に、 ``setElement()``
を使用して現在の項目がデコレータに設定されます。
これで、デコレータがレンダリングすべき項目を知ることができるようになります。
これを使用すると、特定の部分 (ラベルや値、エラーメッセージなど)
だけをレンダリングするデコレータを作成できます。
複数のデコレータにそれぞれ個別の部分をレンダリングさせた結果をまとめることで、
ひとつの項目に対して複雑なマークアップを行うことができます。

.. _zend.form.decorators.operation:

操作方法
----

デコレータを設定するには、オプションの配列あるいは ``Zend_Config``
オブジェクトをコンストラクタに渡します。 あるいは、配列を ``setOptions()``
に渡したり ``Zend_Config`` オブジェクトを ``setConfig()`` に渡すことでも設定できます。

標準のオプションは次のとおりです。

- ``placement``: 配置方法を 'append' あるいは 'prepend' (大文字小文字は区別しません)
  で指定します。 これは、 ``render()`` に渡されたコンテンツを
  先頭に追加するのか末尾に追加するのかを表します。
  デコレータがコンテンツを書き換えるときは、この設定は無視されます。
  デフォルトの設定は append (末尾に追加する) です。

- ``separator``: 区切り文字を指定します。 これは、 ``render()`` に渡されたコンテンツと
  デコレータが新たに作成したコンテンツの区切りとして使用します。
  あるいはデコレータがレンダリングする各項目の区切りにも使用します
  (たとえば、FormElements は各項目の区切りにこの文字を使用します)。
  デコレータがコンテンツを書き換えるときは、この設定は無視されます。
  デフォルト値は ``PHP_EOL`` です。

デコレータのインターフェイスの中にはオプションを操作するメソッドも用意されています。
以下にそれをまとめます。

- ``setOption($key, $value)``: 単一のオプションを設定します。

- ``getOption($key)``: 単一のオプションの値を取得します。

- ``getOptions()``: すべてのオプションを取得します。

- ``removeOption($key)``: 単一のオプションを削除します。

- ``clearOptions()``: すべてのオプションを削除します。

デコレータは、 ``Zend_Form`` のさまざまなクラスで使用できるようになっています。
``Zend_Form`` や ``Zend_Form_Element``\ 、 ``Zend_Form_DisplayGroup``\ 、
そしてその派生クラスのすべてで使用できます。 ``setElement()``
メソッドを使用すると、 デコレータが処理するオブジェクトを指定できます。一方
``getElement()`` で、現在処理中のオブジェクトを取得できます。

各デコレータの ``render()`` メソッドの引数 ``$content`` には文字列が渡されます。
最初のデコレータがコールされたときは、通常はこの文字列は空です。
それ以降のコールの際に、内容が書き込まれていきます。
デコレータの型やオプションに応じて、デコレータはコンテンツを書き換えたり
コンテンツの前後に文字列を追加したりします。
前後に文字列を追加するときには、オプションで指定した区切り文字を使用します。

.. _zend.form.decorators.standard:

標準のデコレータ
--------

``Zend_Form`` には、多くのデコレータが標準で組み込まれています。 詳細は
:ref:`標準のデコレータについての章 <zend.form.standardDecorators>` を参照ください。

.. _zend.form.decorators.custom:

独自のデコレータ
--------

複雑なレンダリングを要したり大幅なカスタマイズが必要な場合は、
独自のデコレータを自作することを考えてみましょう。

デコレータに必要なのは、 ``Zend_Form_Decorator_Interface``
を実装することだけです。このインターフェイスの定義は次のようになります。

.. code-block:: php
   :linenos:

   interface Zend_Form_Decorator_Interface
   {
       public function __construct($options = null);
       public function setElement($element);
       public function getElement();
       public function setOptions(array $options);
       public function setConfig(Zend_Config $config);
       public function setOption($key, $value);
       public function getOption($key);
       public function getOptions();
       public function removeOption($key);
       public function clearOptions();
       public function render($content);
   }

よりお手軽に作成するには、 ``Zend_Form_Decorator_Abstract``
を継承したクラスを作成します。このクラスは、 ``render()``
以外のすべてのメソッドを実装しています。

たとえば、使用するデコレータの数を減らすために "複合"
デコレータを作成することにしましょう。
このデコレータでは、ラベルや要素、エラーメッセージ、 そして説明を *HTML* の 'div'
でレンダリングします。 この 'Composite' デコレータは、次のようになります。

.. code-block:: php
   :linenos:

   class My_Decorator_Composite extends Zend_Form_Decorator_Abstract
   {
       public function buildLabel()
       {
           $element = $this->getElement();
           $label = $element->getLabel();
           if ($translator = $element->getTranslator()) {
               $label = $translator->translate($label);
           }
           if ($element->isRequired()) {
               $label .= '*';
           }
           $label .= ':';
           return $element->getView()
                          ->formLabel($element->getName(), $label);
       }

       public function buildInput()
       {
           $element = $this->getElement();
           $helper  = $element->helper;
           return $element->getView()->$helper(
               $element->getName(),
               $element->getValue(),
               $element->getAttribs(),
               $element->options
           );
       }

       public function buildErrors()
       {
           $element  = $this->getElement();
           $messages = $element->getMessages();
           if (empty($messages)) {
               return '';
           }
           return '<div class="errors">' .
                  $element->getView()->formErrors($messages) . '</div>';
       }

       public function buildDescription()
       {
           $element = $this->getElement();
           $desc    = $element->getDescription();
           if (empty($desc)) {
               return '';
           }
           return '<div class="description">' . $desc . '</div>';
       }

       public function render($content)
       {
           $element = $this->getElement();
           if (!$element instanceof Zend_Form_Element) {
               return $content;
           }
           if (null === $element->getView()) {
               return $content;
           }

           $separator = $this->getSeparator();
           $placement = $this->getPlacement();
           $label     = $this->buildLabel();
           $input     = $this->buildInput();
           $errors    = $this->buildErrors();
           $desc      = $this->buildDescription();

           $output = '<div class="form element">'
                   . $label
                   . $input
                   . $errors
                   . $desc
                   . '</div>';

           switch ($placement) {
               case (self::PREPEND):
                   return $output . $separator . $content;
               case (self::APPEND):
               default:
                   return $content . $separator . $output;
           }
       }
   }

そして、これをデコレータのパスに配置します。

.. code-block:: php
   :linenos:

   // 特定の要素向け
   $element->addPrefixPath('My_Decorator',
                           'My/Decorator/',
                           'decorator');

   // すべての要素向け
   $form->addElementPrefixPath('My_Decorator',
                               'My/Decorator/',
                               'decorator');

そうすれば、このデコレータを 'Composite'
として要素にアタッチすることができるようになります。

.. code-block:: php
   :linenos:

   // 既存のデコレータをこのひとつで置き換えます
   $element->setDecorators(array('Composite'));

この例では複数の要素のプロパティをもとに複雑な出力を作成するデコレータの
作り方を示しましたが、要素の特定の側面だけを扱うようなデコレータを作成することもできます。
'Decorator' デコレータや 'Label' デコレータなどは、 この方式のすばらしい例です。
このようにしておけば、複数のデコレータを組み合わせて
複雑な出力を作成できます。
と同時に、必要に応じて出力の一部だけをオーバーライドすることもできるわけです。

たとえば、要素の検証でエラーが発生したことだけをシンプルに表示して、
各要素の個別の検証エラーメッセージは表示しないようにしたい場合は、 独自の
'Errors' デコレータを作成します。

.. code-block:: php
   :linenos:

   class My_Decorator_Errors
   {
       public function render($content = '')
       {
           $output = '<div class="errors">The value you provided was invalid;
               please try again</div>';

           $placement = $this->getPlacement();
           $separator = $this->getSeparator();

           switch ($placement) {
               case 'PREPEND':
                   return $output . $separator . $content;
               case 'APPEND':
               default:
                   return $content . $separator . $output;
           }
       }
   }

この例では、デコレータ名の最後の部分である 'Errors' が ``Zend_Form_Decorator_Errors``
と同じなので、このデコレータの **かわりに** レンダリングに用いられます。
つまり、特にデコレータを変更しなくても出力が変わるということです
既存のデコレータとあわせた名前のデコレータを作成すれば、
要素のデコレータを変更しなくても出力を変更できます。

.. _zend.form.decorators.individual:

個々のデコレータのレンダリング
---------------

デコレータは特定の要素のメタデータやフォームを対象にしてデコレートすることが可能なので、
個別のデコレータをレンダリングすることができると便利です。
幸いにも、各フォーム形式 (フォーム、サブフォーム、表示グループ、要素)
のメソッドをオーバーロードすることでこれが可能となっています。

そのためには ``render[DecoratorName]()`` をコールします。 ここで、"[DecoratorName]"
の部分はデコレータの "短い名前"
となります。オプションで、デコレートしたいコンテンツを渡すこともできます。
たとえば次のようになります。

.. code-block:: php
   :linenos:

   // 要素ラベルデコレータのみをレンダリングします
   echo $element->renderLabel();

   // 表示グループ fieldset とそのコンテンツをレンダリングします
   echo $group->renderFieldset('fieldset content');

   // form HTML タグとそのコンテンツをレンダリングします
   echo $form->renderHtmlTag('wrap this content');

デコレータが存在しない場合は、例外が発生します。

これは、ViewScript
デコレータを使用してフォームをレンダリングする際に特に有用です。
各要素にアタッチされているデコレータでコンテンツを生成させることで、
より手の込んだ制御が可能となります。


