.. _zend.form.standardDecorators:

Zend Framework に同梱されている標準のデコレータ
===============================

``Zend_Form`` には、標準でいくつかのデコレータが組み込まれています。
デコレータの一般的な使用法については :ref:`デコレータの説明 <zend.form.decorators>`
を参照ください。

.. _zend.form.standardDecorators.callback:

Zend_Form_Decorator_Callback
----------------------------

Callback
デコレータは、コンテンツをレンダリングする際に任意のコールバックを実行します。
コールバックは、デコレータのオプション 'callback' で指定します。 *PHP*
のコールバック型の値を指定できます。 指定するコールバックは、3 つの引数
*$content* (デコレータに渡されたコンテンツ)、 *$element* (処理する項目)、 *$options*
(オプションの配列) を受け取るものでなければなりません。
コールバックの例は、次のようになります。

.. code-block:: php
   :linenos:

   class Util
   {
       public static function label($content, $element, array $options)
       {
           return '<span class="label">' . $element->getLabel() . "</span>";
       }
   }

このコールバックは ``array('Util', 'label')`` のように指定します。 そして、ラベル用の
(間違った) *HTML* マークアップを生成します。 Callback
デコレータはコンテンツの内容を書き換えることもできますし、
コンテンツの前後に文字列を追加することもできます。

Callback デコレータにより ``NULL`` 値を placement オプションに指定できます。
それは、元のコンテンツをコールバックの返り値で上書きします。 'prepend' や 'append'
を指定した場合も正しく動作します。

.. _zend.form.standardDecorators.captcha:

Zend_Form_Decorator_Captcha
---------------------------

Captcha デコレータは :ref:`CAPTCHA フォーム要素 <zend.form.standardElements.captcha>`
と組み合わせて使用します。 これは、CAPTCHA アダプタの ``render()``
メソッドを使用して出力を生成します。

Captcha デコレータの別版である 'Captcha_Word' もよく用いられます。 これは id と input
のふたつの要素を作成します。 id は比較対象のセッション識別子、そして input は
CAPTCHA のユーザ入力を表します。 これらは単一の要素として検証されます。

.. _zend.form.standardDecorators.description:

Zend_Form_Decorator_Description
-------------------------------

Description デコレータは ``Zend_Form``\ 、 ``Zend_Form_Element`` あるいは ``Zend_Form_DisplayGroup``
の説明を表示します。 説明は、各オブジェクトの ``getDescription()``
メソッドで取得します。 各要素の操作説明を提供するためなどに使用します。

デフォルトでは、説明が存在しない場合は何も出力を生成しません。
説明が存在する場合は、デフォルトではそれを *HTML* の **p**
タグで囲んで表示します。このタグを変更するには、
デコレータを作成する際にオプション *tag* を渡すか、あるいは ``setTag()``
をコールします。
さらに、そのタグにクラスを指定することもできます。これは、オプション *class*
あるいはメソッド ``setClass()`` で指定します。 デフォルトで使用するクラスは 'hint'
です。

説明は、デフォルトでビューオブジェクトのエスケープ機構を使って
エスケープされます。これを無効にするには、デコレータのオプション 'escape' に
``FALSE`` を渡すか、あるいは ``setEscape()`` メソッドをコールします。

.. _zend.form.standardDecorators.dtDdWrapper:

Zend_Form_Decorator_DtDdWrapper
-------------------------------

デフォルトのデコレータで、フォームの要素を定義リスト (*<dl>*)
を用いて装飾します。 フォームの項目は任意の順序であらわれるので、
表示グループやサブフォームがその他のフォーム項目の中に点在することがあり得ます。
表示グループやサブフォームなどの特定の項目を定義リスト内でも保持するために、
DtDdWrapper は新しい空の用語定義 (*<dt>*) を作成し、コンテンツを新しい定義データ
(*<dd>*) としてラップします。出力は、次のようになります。

.. code-block:: html
   :linenos:

   <dt></dt>
   <dd><fieldset id="subform">
       <legend>User Information</legend>
       ...
   </fieldset></dd>

このデコレータは、元のコンテンツを上書きし、 *<dd>*
要素でラップしたもので置き換えます。

.. _zend.form.standardDecorators.errors:

Zend_Form_Decorator_Errors
--------------------------

要素のエラーを処理するのが Errors デコレータです。 このデコレータは FormErrors
ビューヘルパーへのプロキシとなり、 エラーメッセージを順序なしリスト (*<ul>*)
にレンダリングします。 *<ul>* 要素のクラスは "errors" となります。

Errors デコレータは、元のコンテンツの先頭あるいは末尾に文字列を追加します。

.. _zend.form.standardDecorators.fieldset:

Zend_Form_Decorator_Fieldset
----------------------------

グループやサブフォームの内容を、デフォルトで fieldset の中にレンダリングします。
Fieldset デコレータは、オプション 'legend' の内容あるいは要素の ``getLegend()``
メソッドの内容を確認し、 何かが指定されていればそれを legend として使用します。
渡されたコンテンツは HTML の fieldset でラップされ、
その内容で元のコンテンツを上書きします。
元の項目に設定されていた属性は、すべて fieldset の HTML 属性として設定されます。

.. _zend.form.standardDecorators.file:

Zend_Form_Decorator_File
------------------------

File 要素には特殊な記法があり、 複数の file
要素やサブフォームを利用する際にそれを使用します。 File デコレータは
``Zend_Form_Element_File`` が使用するもので、複数の file
要素を一度のメソッドコールで設定できます。
自動的に使用され、要素名を自動的に修正します。

.. _zend.form.standardDecorators.form:

Zend_Form_Decorator_Form
------------------------

``Zend_Form`` オブジェクトは HTML の form タグをレンダリングするものです。 Form
デコレータは Form ビューヘルパーへのプロキシとなります。
これは、渡されたコンテンツを HTML の form 要素でラップします。 その際に ``Zend_Form``
オブジェクトの action や method、 そして属性を使用します。

.. _zend.form.standardDecorators.formElements:

Zend_Form_Decorator_FormElements
--------------------------------

フォームや表示グループ、サブフォームはいくつかの要素のコレクションです。
これらの要素をレンダリングする際には FormElements デコレータを使用します。
これは、各構成要素を順次処理して個別に ``render()``
をコールし、登録されている区切り文字で結果を連結します。
このデコレータは、元のコンテンツの先頭あるいは末尾に文字列を追加します。

.. _zend.form.standardDecorators.formErrors:

Zend_Form_Decorator_FormErrors
------------------------------

開発者やデザイナの中には、
すべてのエラーメッセージをフォームの最上部にまとめて表示させることを好む人もいます。
FormErrors デコレータは、そのためのものです。

デフォルトでは、生成されるエラー一覧は次のようなマークアップになります。

.. code-block:: html
   :linenos:

   <ul class="form-errors>
       <li><b>[要素の label あるいは name]</b><ul>
               <li>[エラーメッセージ]</li>
               <li>[エラーメッセージ]</li>
           </ul>
       </li>
       <li><ul>
           <li><b>[サブフォーム要素の label あるいは name</b><ul>
                   <li>[エラーメッセージ]</li>
                   <li>[エラーメッセージ]</li>
               </ul>
           </li>
       </ul></li>
   </ul>

さまざまなオプションを渡すことで、生成される出力を変更できます。

- *ignoreSubForms*: サブフォームの再帰を無効にするかどうか。 デフォルト値: ``FALSE``
  (再帰を許可する)

- *markupElementLabelEnd*: 要素のラベルの後につけるマークアップ。 デフォルト値: '</b>'

- *markupElementLabelStart*: 要素のラベルの前につけるマークアップ。 デフォルト値: '<b>'

- *markupListEnd*: エラーメッセージ一覧の後につけるマークアップ。 デフォルト値:
  '</ul>'

- *markupListItemEnd*: 個々のエラーメッセージの後につけるマークアップ。 デフォルト値:
  '</li>'

- *markupListItemStart*: 個々のエラーメッセージの前につけるマークアップ。
  デフォルト値: '<li>'

- *markupListStart*: エラーメッセージ一覧の前につけるマークアップ。 デフォルト値: '<ul
  class="form-errors">'

FormErrors デコレータは、コンテンツの前と後の両方に追加できます。

.. _zend.form.standardDecorators.htmlTag:

Zend_Form_Decorator_HtmlTag
---------------------------

HtmlTag デコレータは、HTML タグを使ってコンテンツを装飾します。 使用するタグを
'tag' オプションで指定します。
それ以外に指定したオプションは、そのタグの属性として用いられます。
デフォルトのタグはブロックレベルのものであり、
指定したタグでコンテンツをラップして元のコンテンツを上書きします。
しかし、placement に append あるいは prepend を指定することもできます。

.. _zend.form.standardDecorators.image:

Zend_Form_Decorator_Image
-------------------------

Image デコレータは、HTML の image input (*<input type="image" ... />*)
を作成し、オプションでそれを他の HTML タグの中にレンダリングします。

デフォルトでは、このデコレータは要素の src プロパティを使用します。 これは、
``setImage()`` で画像ソースとして指定できます。 さらに、要素のラベルは alt
タグとして使用します。また *imageValue* (Image 要素のアクセサ ``setImageValue()`` および
``getImageValue()`` で操作します) を値として使用します。

この要素をラップする HTML タグを指定するには、デコレータのオプション 'tag'
を指定するか、あるいは ``setTag()`` をコールします。

.. _zend.form.standardDecorators.label:

Zend_Form_Decorator_Label
-------------------------

フォーム要素には通常ラベルがあります。Label
デコレータは、このラベルをレンダリングするものです。 FormLabel
ビューヘルパーへのプロキシとして働き、 要素の ``getLabel()``
メソッドを使用してラベルを取得します。
ラベルが存在しない場合は、何もレンダリングしません。
デフォルトでは、翻訳アダプタが存在して
ラベルの翻訳が存在する場合には、ラベルの翻訳を行います。

オプション 'tag' を指定することもできます。
指定した場合は、そのブロックレベルタグでラベルをラップします。 'tag'
が指定されているがラベルが存在しないという場合は、
指定したタグを中身なしでレンダリングします。
このタグにクラスを指定するには、オプション 'class' を指定するか、あるいは
``setClass()`` をコールします。

さらに、要素の表示の際に使用するプレフィックスおよびサフィックスを指定することもできます。
これは、任意要素のラベルか必須要素のラベルかを表す際などに使用します。
一般的な使用法は、ラベルの最後に ':' を追加したり 必須項目に '\*'
を追加したりといったものです。 次のようなオプションやメソッドを使用します。

- *optionalPrefix*:
  その要素がオプション要素である場合にラベルの先頭に付加するテキストを設定します。
  ``setOptionalPrefix()`` および ``getOptionalPrefix()`` で操作します。

- *optionalSuffix*:
  その要素がオプション要素である場合にラベルの末尾に付加するテキストを設定します。
  ``setOptionalSuffix()`` および ``getOptionalSuffix()`` で操作します。

- *requiredPrefix*:
  その要素が必須要素である場合にラベルの先頭に付加するテキストを設定します。
  ``setRequiredPrefix()`` および ``getRequiredPrefix()`` で操作します。

- *requiredSuffix*:
  その要素が必須要素である場合にラベルの末尾に付加するテキストを設定します。
  ``setRequiredSuffix()`` および ``getRequiredSuffix()`` で操作します。

デフォルトでは、Label デコレータは元のコンテンツの先頭に結果を追加します。
'placement' オプションを 'append' にすると、 コンテンツの末尾に追加できます。

.. _zend.form.standardDecorators.prepareElements:

Zend_Form_Decorator_PrepareElements
-----------------------------------

フォーム、表示グループそしてサブフォームは、要素のコレクションです。
:ref:`ViewScript <zend.form.standardDecorators.viewScript>`
デコレータをフォームやサブフォームで使用する際に、
ビューオブジェクトやトランスレータ、完全修飾名
(サブフォームの配列記法で定義されるもの) を再帰的に設定できたら便利です。
'PrepareElements' デコレータはそのためのものです。
一般的には、これをリスト内の最初のデコレータとして設定します。

.. code-block:: php
   :linenos:

   $form->setDecorators(array(
       'PrepareElements',
       array('ViewScript', array('viewScript' => 'form.phtml')),
   ));

.. _zend.form.standardDecorators.viewHelper:

Zend_Form_Decorator_ViewHelper
------------------------------

大半の要素のレンダリングには ``Zend_View`` ヘルパーを使用します。これを行うのが
ViewHelper デコレータです。 このデコレータでは、'helper'
タグで明示的にビューヘルパーを指定できます。
指定しなかった場合は、要素のクラス名の最後の部分をもとに使用するヘルパーを決定します。
この最後の部分の先頭に 'form' をつけたものを使います。 たとえば 'Zend_Form_Element_Text'
の場合は 'formText' というビューヘルパーを探すことになります。

渡された要素のすべての属性は、要素の属性としてビューヘルパーに渡されます。

デフォルトでは、このデコレータはコンテンツの末尾に結果を追加します。 'placement'
オプションを指定すれば、先頭に追加させることもできます。

.. _zend.form.standardDecorators.viewScript:

Zend_Form_Decorator_ViewScript
------------------------------

ビュースクリプトを使用して要素を作成したくなることもあるでしょう。
これにより、作成する要素をよりきめ細やかに設定できるようになります。
またビュースクリプトでデザインを行ったり
使用するモジュールにあわせて設定を簡単にオーバーライドしたりできるようになります
(各モジュールで、要素のビュースクリプトを必要に応じてオーバーライドできます)。
ViewScript デコレータが、この問題を解決します。

ViewScript デコレータには 'viewScript' オプションが必須です。
これは、デコレータ側で指定するか、あるいは要素の属性で指定します。
そのビュースクリプトをパーシャルスクリプトとしてレンダリングします。
各コールごとに独自の変数スコープを保持するので、
その要素の変数以外にビューからの変数が注入されることはありません。
いくつかの変数が設定されます。

- *element*: デコレートする要素の名前

- *content*: デコレータに渡されたコンテンツ

- *decorator*: デコレータオブジェクト自身

- さらに、デコレータに ``setOptions()``
  で渡されたすべてのオプションのうち内部的に使用しないもの (placement や separator
  など) は、 ビュースクリプトにビュー変数として渡されます。

例として、次のような要素を考えてみましょう。

.. code-block:: php
   :linenos:

   // 要素のデコレータとして、ViewScript デコレータを指定し、
   // ビュースクリプトとその他のオプションを設定します
   $element->setDecorators(array(array('ViewScript', array(
       'viewScript' => '_element.phtml',
       'class'      => 'form element'
   ))));

   // あるいはビュースクリプトを要素の属性として指定します
   $element->viewScript = '_element.phtml';
   $element->setDecorators(array(array('ViewScript',
                                       array('class' => 'form element'))));

そして、次のようなビュースクリプトを作成します

.. code-block:: php
   :linenos:

   <div class="<?php echo $this->class ?>">
       <?php echo $this->formLabel($this->element->getName(),
                            $this->element->getLabel()) ?>
       <?php echo $this->{$this->element->helper}(
           $this->element->getName(),
           $this->element->getValue(),
           $this->element->getAttribs()
       ) ?>
       <?php echo $this->formErrors($this->element->getMessages()) ?>
       <div class="hint"><?php echo $this->element->getDescription() ?></div>
   </div>

.. note::

   **ビュースクリプトによるコンテンツの置換**

   デコレータに渡されたコンテンツをビュースクリプトで置換したいこともあるでしょう。
   たとえばコンテンツをラップしたい場合などです。
   その場合は、デコレータのオプション 'placement' に ``FALSE`` を設定します。

   .. code-block:: php
      :linenos:

      // デコレータの作成時
      $element->addDecorator('ViewScript', array('placement' => false));

      // 既存のデコレータインスタンスへの適用
      $decorator->setOption('placement', false);

      // 既に要素にアタッチされているデコレータへの適用
      $element->getDecorator('ViewScript')->setOption('placement', false);

      // デコレータが使用するビュースクリプト内
      $this->decorator->setOption('placement', false);

ViewScript デコレータは、
要素のレンダリングをよりきめ細やかに設定したい場合に使用することをおすすめします。


