.. EN-Revision: none
.. _zend.filter.introduction:

導入
==

``Zend_Filter``
コンポーネントは、データのフィルタリングに必要となる一般的な機能を提供します。
シンプルなフィルタチェイン機能も持っており、
ひとつのデータに対して複数のフィルタを指定した順に適用できます。

.. _zend.filter.introduction.definition:

フィルタとは?
-------

自然界におけるフィルタの典型的な使用法は、
入力から不要な部分を除去して必要なものだけを出力することです (例:
コーヒーのフィルタ)。
このような場合、フィルタは入力の一部を取り出すための演算子となります。
この型のフィルタリングはウェブアプリケーションで有用です。
たとえば不正な入力を除去したり、余分な空白を除去したりといったことが考えられます。

この基本的なフィルタの定義を拡張して、入力に一般的な変換を加える処理もフィルタに含めることにしましょう。
ウェブアプリケーションでよくある変換は、HTML
エンティティのエスケープ処理です。 たとえば (ウェブブラウザなどからの)
信頼できない入力をもとにして
フォームのフィールドに値を自動的に埋め込む場合は、その値には HTML
エンティティが含まれてはいけません。あるいはもし含むならそれをエスケープしておかなければなりません。
これにより、予期せぬ振る舞いを起こすことを防ぎ、
セキュリティ上の脆弱性も防ぎます。 この要求を満たすには、入力に含まれる HTML
エンティティを削除あるいはエスケープしなければなりません。
もちろん、どちらの方式が適切かはその場の状況に依存します。 HTML
エンティティを除去するフィルタは、最初に定義したフィルタの考え方 -
入力の一部を取り出すための演算子 - にもとづくものです。 一方、HTML
エンティティをエスケープするフィルタは、入力を変換するタイプのものです
(たとえば "&" は "&amp;" に変換されます)。
これらの例のような処理はウェブ開発者にとって重要です。 ``Zend_Filter`` で
"フィルタリングする" という場合、
それは入力データに対して何らかの変換を行うことを意味します。

.. _zend.filter.introduction.using:

フィルタの基本的な使用法
------------

ここで考えたフィルタについての定義をもとにして ``Zend\Filter\Interface``
が作成されました。 これは、フィルタクラスに対して ``filter()``
という名前のメソッドを実装するよう強制するものです。

以下の例は、アンパサンド (**&**) およびダブルクォート (**"**)
の二つの入力データに対してフィルタを適用するものです。

   .. code-block:: php
      :linenos:

      $htmlEntities = new Zend\Filter\HtmlEntities();

      echo $htmlEntities->filter('&'); // &
      echo $htmlEntities->filter('"'); // "



.. _zend.filter.introduction.static:

静的メソッド staticFilter() の使用法
--------------------------

指定したフィルタクラスを読み込んでそのインスタンスを作成するというのが面倒ならば、
もうひとつの方法として、静的メソッド ``Zend\Filter\Filter::filterStatic()``
を実行する方法もあります。このメソッドの最初の引数には、 ``filter()``
メソッドに渡す入力値を指定します。
二番目の引数は文字列で、フィルタクラスのベースネーム (Zend_Filter
名前空間における相対的な名前) を指定します。 ``staticFilter()``
メソッドは自動的にクラスを読み込んでそのインスタンスを作成し、
指定した入力に対して ``filter()`` メソッドを適用します。

   .. code-block:: php
      :linenos:

      echo Zend\Filter\Filter::filterStatic('&', 'HtmlEntities');



フィルタクラスのコンストラクタにオプションを指定する必要がある場合は、
それを配列で渡すことができます。

   .. code-block:: php
      :linenos:

      echo Zend\Filter\Filter::filterStatic('"',
                                     'HtmlEntities',
                                     array('quotestyle' => ENT_QUOTES));



この静的な使用法は、その場限りのフィルタリングには便利です。
ただ、複数の入力に対してフィルタを適用するのなら、
最初の例の方式、つまりフィルタオブジェクトのインスタンスを作成して その
``filter()`` メソッドをコールする方式のほうがより効率的です。

また、 ``Zend\Filter\Input`` クラスでも、特定の入力データのセットを処理する際に
複数のフィルタやバリデータを必要に応じて実行させる機能も提供しています。
詳細は :ref:` <zend.filter.input>` を参照ください。

.. _zend.filter.introduction.static.namespaces:

名前空間
^^^^

自分で定義したフィルタを使う際に、 ``Zend\Filter\Filter::filterStatic()`` に 4
番目のパラメータを指定できます。
これは、フィルタを探すための名前空間となります。

.. code-block:: php
   :linenos:

   echo Zend\Filter\Filter::filterStatic(
       '"',
       'MyFilter',
       array($parameters),
       array('FirstNamespace', 'SecondNamespace')
   );

``Zend_Filter`` には、名前空間をデフォルトで設定することもできます。
つまり、起動時に一度設定しておけば ``Zend\Filter\Filter::filterStatic()``
のたびに指定する必要がなくなるということです。
次のコード片は、上のコードと同じ意味となります。

.. code-block:: php
   :linenos:

   Zend\Filter\Filter::setDefaultNamespaces(array('FirstNamespace', 'SecondNamespace'));
   echo Zend\Filter\Filter::filterStatic('"', 'MyFilter', array($parameters));
   echo Zend\Filter\Filter::filterStatic('"', 'OtherFilter', array($parameters));

名前空間の操作のために、次のような便利なメソッド群が用意されています。

- **Zend\Filter\Filter::getDefaultNamespaces()**: 設定されているすべての名前空間を配列で返します。

- **Zend\Filter\Filter::setDefaultNamespaces()**:
  新たなデフォルト名前空間を設定し、既存の名前空間を上書きします。
  単一の名前空間の場合は文字列、複数の場合は配列で指定できます。

- **Zend\Filter\Filter::addDefaultNamespaces()**:
  新たな名前空間を、既に設定されているものに追加します。
  単一の名前空間の場合は文字列、複数の場合は配列で指定できます。

- **Zend\Filter\Filter::hasDefaultNamespaces()**: デフォルトの名前空間が設定されている場合は ``TRUE``
  、 設定されていない場合は ``FALSE`` を返します。


