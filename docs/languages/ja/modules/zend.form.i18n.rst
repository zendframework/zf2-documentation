.. _zend.form.i18n:

Zend_Form の国際化
==============

作成したコンテンツを複数の言語や地域に対応させるという作業は、
日増しに重要になってきています。 ``Zend_Form``
はそんな作業も簡単にできるように作られており、 :ref:`Zend_Translator <zend.translator>` と
:ref:`Zend_Validate <zend.validate>` の機能を使うことで国際化を実現できます。

デフォルトでは、国際化 (I18n) は行われません。 i18n 機能を ``Zend_Form``
で使うには、まず適切なアダプタを指定して ``Zend_Translator``
のインスタンスを作成し、それを ``Zend_Form`` や ``Zend_Validate``
にアタッチしなければなりません。翻訳オブジェクトや翻訳ファイルの作成方法についての詳細は
:ref:`Zend_Translator のドキュメント <zend.translator>` を参照ください。

.. note::

   **項目単位での翻訳の無効化**

   個々のフォームや要素、表示グループ、サブフォームなどの単位で翻訳を無効にするには、
   ``setDisableTranslator($flag)`` メソッドをコールするか
   あるいはそのオブジェクトにオプション ``disableTranslator``
   を渡します。これは、特定の要素 (あるいは要素群)
   についてだけ翻訳を無効にしたい場合に有用です。

.. _zend.form.i18n.initialization:

フォームでの I18n 機能の初期化
------------------

フォームの I18n 機能を初期化するには ``Zend_Translator`` オブジェクトあるいは
``Zend_Translator_Adapter`` オブジェクトが必要です。詳細は ``Zend_Translator``
のドキュメントを参照ください。
翻訳オブジェクトを作成したら、その後の手順にはいくつかの方法があります。

- **最も簡単な方法:** レジストリに登録します。Zend Framework の I18n
  対応コンポーネントはすべて、レジストリの 'Zend_Translator'
  キーに登録されている翻訳オブジェクトを自動取得して翻訳や地域化を行います。

  .. code-block:: php
     :linenos:

     // 'Zend_Translator' キーを使用します。$translate は Zend_Translator オブジェクトです
     Zend_Registry::set('Zend_Translator', $translate);

  これは、 ``Zend_Form`` や ``Zend_Validate`` そして ``Zend_View_Helper_Translator`` が使用します。

- 検証エラーのメッセージだけを翻訳したいのなら、 翻訳オブジェクトを
  ``Zend_Validate_Abstract`` に登録することもできます。

  .. code-block:: php
     :linenos:

     // すべてのバリデーションクラスに、指定した翻訳アダプタを使用させます
     Zend_Validate_Abstract::setDefaultTranslator($translate);

- あるいは、 ``Zend_Form``
  オブジェクトにアタッチしてグローバルに使用することもできます。
  その副作用として、検証エラーメッセージも翻訳されます。

  .. code-block:: php
     :linenos:

     // すべてのフォームクラスで特定の翻訳アダプタを使用させます。
     // このアダプタは、検証エラーメッセージの翻訳にも用いられます。
     Zend_Form::setDefaultTranslator($translate);

- 最後に、特定のフォームや要素のインスタンスに
  翻訳オブジェクトをアタッチすることもできます。 その場合は ``setTranslator()``
  メソッドを使用します。

  .. code-block:: php
     :linenos:

     // 「この」フォームのインスタンスで特定の翻訳アダプタを使用させます。
     // このアダプタは、すべての要素の検証エラーメッセージの翻訳にも用いられます。
     $form->setTranslator($translate);

     // 「この」要素のインスタンスで特定の翻訳アダプタを使用させます。
     // このアダプタは、この要素の検証エラーメッセージの翻訳にも用いられます。
     $element->setTranslator($translate);

.. _zend.form.i18n.standard:

標準的な I18N の対象
-------------

これで翻訳オブジェクトがアタッチできました。
デフォルトでは、いったい何が翻訳の対象となるのでしょうか?

- **検証エラーメッセージ。** 検証エラーメッセージを翻訳させることができます。
  そのためには、 ``Zend_Validate``
  のバリデーションクラスのエラーコード定数をメッセージ ID として使用します。
  エラーコードについての詳細は :ref:`Zend_Validate <zend.validate>`
  のドキュメントを参照ください。

  1.6.0 以降では、実際のエラーメッセージをメッセージ ID
  とする翻訳文字列を提供することができます。 1.6.0
  以降ではこの方法が推奨となります。
  メッセージキーによる翻訳は将来のバージョンで廃止予定です。

- **ラベル。** 要素のラベルも、翻訳が存在すれば翻訳されます。

- **フィールドセットの説明 (legend)。**
  表示グループやサブフォームは、デフォルトでは fieldset
  としてレンダリングされます。Fieldset デコレータは、 レンダリングの前に legend
  の翻訳を試みます。

- **フォームや要素の説明。** すべての型
  (要素、フォーム、表示グループ、サブフォーム)
  で、オプションとしてその項目の説明を指定することができます。 Description
  デコレータを用いて、これをレンダリングします。
  その際、デフォルトでこの値の翻訳を試みます。

- **選択肢の値。** ``Zend_Form_Element_Multi`` を継承した項目 (MultiCheckbox、Multiselect および
  Radio 要素) で、もし翻訳がある場合に選択肢の値 (キーではありません)
  が翻訳の対象となります。つまり、
  ユーザ向けに表示される選択肢のラベルが翻訳されるということです。

- **ボタンのラベル。** ボタン系の要素 (Button、Submit および Reset)
  で、ユーザ向けに表示されるラベルが翻訳されます。


