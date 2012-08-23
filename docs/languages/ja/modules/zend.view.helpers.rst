.. EN-Revision: none
.. _zend.view.helpers:

ビューヘルパー
=======

ビュースクリプトの中で、複雑な関数を繰り返し実行しなければならないこともあるでしょう
(例えば日付のフォーマット、フォーム要素の作成、リンクの作成など)。
このような作業を行うために、ヘルパークラスを使用できます。

ヘルパーの正体は、単なるクラスです。たとえば 'fooBar'
という名前のヘルパーを使用するとしましょう。
デフォルトでは、クラス名の先頭には 'Zend_View_Helper\_' がつきます
(ヘルパーのパスを設定する際に、これは独自のものに変更できます)。
そしてクラス名の最後の部分がヘルパーの名前となります。
このとき、単語の先頭は大文字にしなければなりません。つまり、
ヘルパーのクラス名は ``Zend_View_Helper_FooBar``
となります。このクラスには、最低限ヘルパー名と同じ名前 (camelCase 形式にしたもの)
のメソッド ``fooBar()`` が含まれていなければなりません。

.. note::

   **大文字小文字の扱い**

   ヘルパー名は常に camelCase 形式となります。
   つまり、最初は常に小文字となります。 クラス名は MixedCase
   形式ですが、実際に実行されるメソッドは camelCase 形式となります。

.. note::

   **デフォルトのヘルパーのパス**

   デフォルトのヘルパーのパスは常に Zend Framework のビューヘルパーのパス、すなわち
   'Zend/View/Helper/' となります。 ``setHelperPath()``
   をコールして既存のパスを上書きしても、 このパスだけは残ります。これにより、
   デフォルトのヘルパーは常に動作することが保証されます。

ビュースクリプト内でヘルパーを使用するには、 ``$this->helperName()``
をコールします。これをコールすると、裏側では ``Zend_View`` が
``Zend_View_Helper_HelperName`` クラスを読み込み、 そのクラスのインスタンスを作成して
``helperName()`` メソッドをコールします。 オブジェクトのインスタンスは ``Zend_View``
インスタンスの中に残り続け、 後で ``$this->helperName()``
がコールされたときには再利用されます。

.. _zend.view.helpers.initial:

付属のヘルパー
-------

``Zend_View`` には、はじめからいくつかのヘルパークラスが付属しています。
これらのほとんどはフォーム要素の生成に関するもので、
適切なエスケープ処理を自動的に行います。 さらに、ルートにもとづいた *URL* と
*HTML* の一覧を作成したり、 変数を宣言したりするものもあります。
現在付属しているヘルパーは、次のとおりです。

- ``declareVars():`` ``strictVars()`` を使用する際に同時に使用します。
  このヘルパーを使用すると、テンプレート変数を宣言できます。
  この変数は、すでにビュースクリプトで設定されているものでもいないものでもかまいません。
  また、同時にデフォルト値も設定します。
  このメソッドへの引数として配列を渡すとデフォルト値を設定します。
  それ以外の場合は、もしその変数が存在しない場合は空文字列を設定します。

- ``fieldset($name, $content, $attribs):`` *XHTML* の fieldset を作成します。 ``$attribs`` に 'legend'
  というキーが含まれる場合、その値をフィールドセットの説明として使用します。
  フィールドセットで囲む内容は、このヘルパーに渡した ``$content`` です。

- ``form($name, $attribs, $content):`` *XHTML* の form を作成します。すべての ``$attribs``
  はエスケープされ、form タグの *XHTML* 属性としてレンダリングされます。 ``$content``
  が存在してその値が ``FALSE`` 以外の場合は、
  その内容がフォームの開始タグと終了タグの間にレンダリングされます。 ``$content``
  が ``FALSE`` (既定値) の場合は、 フォームの開始タグのみを作成します。

- ``formButton($name, $value, $attribs):`` <button /> 要素を作成します。

- ``formCheckbox($name, $value, $attribs, $options):`` <input type="checkbox" /> 要素を作成します。

  デフォルトでは、$value を指定せず $options
  が存在しなかった場合は、未チェックの値として '0' そしてチェック状態の値として
  '1' を使用します。 $value が渡されたけれど $options が存在しなかった場合は、
  渡された値をチェック状態の値とみなします。

  $options は配列でなければなりません。
  数値添字形式の配列の場合は、最初の要素がチェック状態の値となり、
  その次の要素が未チェック状態の値となります。 3
  番目以降の要素の内容は無視されます。 キー 'checked' および 'unChecked'
  を持つ連想配列を指定することもできます。

  $options を渡した場合は、$value
  が「チェック状態の値」と一致した場合にその要素がチェック状態だとみなされます。
  チェック状態あるいは未チェック状態は、 属性 'checked' に boolean
  値を渡して指定することもできます。

  これらの内容を簡単にまとめた例を示します。

  .. code-block:: php
     :linenos:

     // '1' および '0' でチェック状態と未チェック状態を表します。これはチェックされていません
     echo $this->formCheckbox('foo');

     // '1' および '0' でチェック状態と未チェック状態を表します。これはチェックされています
     echo $this->formCheckbox('foo', null, array('checked' => true));

     // 'bar' および '0' でチェック状態と未チェック状態を表します。これはチェックされていません
     echo $this->formCheckbox('foo', 'bar');

     // 'bar' および '0' でチェック状態と未チェック状態を表します。これはチェックされています
     echo $this->formCheckbox('foo', 'bar', array('checked' => true));

     // 'bar' および 'baz' でチェック状態と未チェック状態を表します。これはチェックされていません
     echo $this->formCheckbox('foo', null, null, array('bar', 'baz'));

     // 'bar' および 'baz' でチェック状態と未チェック状態を表します。これはチェックされていません
     echo $this->formCheckbox('foo', null, null, array(
         'checked' => 'bar',
         'unChecked' => 'baz'
     ));

     // 'bar' および 'baz' でチェック状態と未チェック状態を表します。これはチェックされています
     echo $this->formCheckbox('foo', 'bar', null, array('bar', 'baz'));
     echo $this->formCheckbox('foo',
                              null,
                              array('checked' => true),
                              array('bar', 'baz'));

     // 'bar' および 'baz' でチェック状態と未チェック状態を表します。これはチェックされていません
     echo $this->formCheckbox('foo', 'baz', null, array('bar', 'baz'));
     echo $this->formCheckbox('foo',
                              null,
                              array('checked' => false),
                              array('bar', 'baz'));

  どの場合についても、マークアップの先頭に hidden
  要素を追加してそこに「未チェック状態」を表す値を保持します。
  そうすることで、仮に未チェック状態であったとしても
  フォームから何らかの値が返されるようになるのです。

- ``formErrors($errors, $options):`` エラーの表示用に、 *XHTML*
  の順序なしリストを作成します。 ``$errors``
  は、文字列あるいは文字列の配列となります。 ``$options``
  は、リストの開始タグの属性として設定したい内容です。

  エラー出力の開始時、終了時、そして各エラーの区切りとして使用する
  コンテンツを指定することもできます。
  そのためにはヘルパーのこれらのメソッドをコールします。

  - ``setElementStart($string)``; デフォルトは '<ul class="errors"%s"><li>' で、%s の部分には
    ``$options`` で指定した属性が入ります。

  - ``setElementSeparator($string)``; デフォルトは '</li><li>' です。

  - ``setElementEnd($string)``; デフォルトは '</li></ul>' です。

- ``formFile($name, $attribs):`` type="file" /> 要素を作成します。

- ``formHidden($name, $value, $attribs):`` <input type="hidden" /> 要素を作成します。

- ``formLabel($name, $value, $attribs):`` <label> 要素を作成します。 ``for`` 属性の値は ``$name``
  に、そしてラベルのテキストは ``$value`` になります。 ``attribs`` に **disable**
  を渡すと、結果を何も返しません。

- ``formMultiCheckbox($name, $value, $attribs, $options, $listsep):``
  チェックボックスのリストを作成します。 ``$options``
  は連想配列で、任意の深さにできます。 ``$value``
  は単一の値か複数の値の配列で、これが ``$options`` 配列のキーにマッチします。
  ``$listsep`` は、デフォルトでは *HTML* の改行 ("<br />") です。デフォルトでは、
  この要素は配列として扱われます。
  つまり、すべてのチェックボックスは同じ名前となり、
  入力内容は配列形式で送信されます。

- ``formPassword($name, $value, $attribs):`` <input type="password" /> 要素を作成します。

- ``formRadio($name, $value, $attribs, $options):`` 一連の <input type="radio" /> 要素を、 $options
  の要素ごとに作成します。$options は、
  ラジオボタンの値をキー、ラベルを値とする配列となります。 $value
  はラジオボタンの初期選択状態を設定します。

- ``formReset($name, $value, $attribs):`` <input type="reset" /> 要素を作成します。

- ``formSelect($name, $value, $attribs, $options):`` <select>...</select> ブロックを作成します。
  $options の要素ごとに <option> を作成します。 $options は、選択肢の値をキー、
  ラベルを値とする配列となります。$value は初期選択状態を設定します。

- ``formSubmit($name, $value, $attribs):`` <input type="submit" /> 要素を作成します。

- ``formText($name, $value, $attribs):`` <input type="text" /> 要素を作成します。

- ``formTextarea($name, $value, $attribs):`` <textarea>...</textarea> ブロックを作成します。

- ``url($urlOptions, $name, $reset):`` 指定したルートにもとづく *URL* 文字列を作成します。
  ``$urlOptions`` は、そのルートで使用する キー/値 のペアの配列となります。

- ``htmlList($items, $ordered, $attribs, $escape):`` ``$items`` で渡した内容をもとに
  順序つきリストあるいは順序なしリストを作成します。 ``$items``
  が多次元配列の場合は、入れ子状のリストとなります。 ``$escape`` フラグを ``TRUE``
  (既定値) にすると、
  各項目はビューオブジェクトに登録されているエスケープ方式でエスケープされます。
  リスト内でマークアップを行いたい場合は ``FALSE`` を渡します。

これらをビュースクリプト内で使用するのはとても簡単です。
以下に例を示します。ただ単に、ヘルパーをコールするだけでよいことに注意しましょう。
読み込みやインスタンス作成は、必要に応じて自動的に行われます。

.. code-block:: php
   :linenos:

   // ビュースクリプト内では、$this は Zend_View のインスタンスを指します。
   //
   // select の選択肢を、変数 $countries に
   // array('us' => 'United States', 'il' => 'Israel', 'de' => 'Germany')
   // として設定済みであることにします。
   ?>
   <form action="action.php" method="post">
       <p><label>メールアドレス:
   <?php echo $this->formText('email', 'you@example.com', array('size' => 32)) ?>
       </label></p>
       <p><label>国:
   <?php echo $this->formSelect('country', 'us', null, $this->countries) ?>
       </label></p>
       <p><label>メールを受け取りますか?
   <?php echo $this->formCheckbox('opt_in', 'yes', null, array('yes', 'no')) ?>
       </label></p>
   </form>

ビュースクリプトの出力結果は、次のようになります。

.. code-block:: php
   :linenos:

   <form action="action.php" method="post">
       <p><label>メールアドレス:
           <input type="text" name="email" value="you@example.com" size="32" />
       </label></p>
       <p><label>国:
           <select name="country">
               <option value="us" selected="selected">United States</option>
               <option value="il">Israel</option>
               <option value="de">Germany</option>
           </select>
       </label></p>
       <p><label>メールを受け取りますか?
           <input type="hidden" name="opt_in" value="no" />
           <input type="checkbox" name="opt_in" value="yes" checked="checked" />
       </label></p>
   </form>

.. include:: zend.view.helpers.action.rst
.. include:: zend.view.helpers.base-url.rst
.. include:: zend.view.helpers.currency.rst
.. include:: zend.view.helpers.cycle.rst
.. include:: zend.view.helpers.partial.rst
.. include:: zend.view.helpers.placeholder.rst
.. include:: zend.view.helpers.doctype.rst
.. include:: zend.view.helpers.head-link.rst
.. include:: zend.view.helpers.head-meta.rst
.. include:: zend.view.helpers.head-script.rst
.. include:: zend.view.helpers.head-style.rst
.. include:: zend.view.helpers.head-title.rst
.. include:: zend.view.helpers.html-object.rst
.. include:: zend.view.helpers.inline-script.rst
.. include:: zend.view.helpers.json.rst
.. include:: zend.view.helpers.navigation.rst
.. include:: zend.view.helpers.translator.rst
.. _zend.view.helpers.paths:

ヘルパーのパス
-------

ビュースクリプトと同様、 ``Zend_View``
がヘルパークラスを探すパスをコントローラから積み重ねて指定できます。
デフォルトでは、 ``Zend_View`` は "Zend/View/Helper/\*" からヘルパークラスを探します。
``Zend_View`` に別の場所を探すように指定するには ``setHelperPath()`` および ``addHelperPath()``
メソッドを使用します。 さらに、クラスプレフィックスを指定することもできます。
これにより、ヘルパークラスに名前空間を設定できるようになります。
デフォルトでクラスプレフィックスを指定しなかった場合は、 'Zend_View_Helper\_'
であると見なされます。

.. code-block:: php
   :linenos:

   $view = new Zend_View();

   // パスを /path/to/more/helpers 、プレフィックスを 'My_View_Helper' と設定します
   $view->setHelperPath('/path/to/more/helpers', 'My_View_Helper');

``addHelperPath()`` メソッドを使用すると、検索パスを「積み重ねる」
ことができます。これを使用すると、 ``Zend_View``
は一番最後に追加されたパスからヘルパークラスを探し始めます。
これにより、付属しているヘルパーの内容を上書きしたり、
新しいヘルパーを追加したりすることができるようになります。

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   // /path/to/some/helpers をクラスプレフィックス 'My_View_Helper' で追加します
   $view->addHelperPath('/path/to/some/helpers', 'My_View_Helper');
   // /other/path/to/helpers をクラスプレフィックス 'Your_View_Helper' で追加します
   $view->addHelperPath('/other/path/to/helpers', 'Your_View_Helper');

   // $this->helperName() をコールすると、Zend_View は
   // まず最初に "/path/to/some/helpers/HelperName" で
   // "Your_View_Helper_HelperName" という名前のクラスを探し、
   // 次に "/other/path/to/helpers/HelperName.php" で
   // "My_View_Helper_HelperName" という名前のクラスを探し、
   // そして最後に "Zend/View/Helpers/HelperName.php" で
   // "Zend_View_Helper_HelperName" という名前のクラスを探します。

.. _zend.view.helpers.custom:

独自のヘルパーを書く
----------

独自のヘルパーを書くのは簡単です。以下の規則に従ってください。

- 絶対条件というわけではありませんが、ヘルパーを作成する際には
  ``Zend_View_Helper_Interface`` を実装するか ``Zend_View_Helper_Abstract``
  を継承することを推奨します。 1.6.0 以降、これらには ``setView()``
  メソッドが定義されています。 しかし、将来のリリースでは Strategy
  パターンを実装することを検討しており、
  以下に示す命名規約の多くを単純化する予定です。
  今のうちにこのようにしておくと、
  将来のバージョンでもあなたの書いたコードがそのまま動くようになるでしょう。

- クラス名は、少なくとも最後はヘルパーの名前と同じである必要があります。
  MixedCaps 方式を使用します。たとえば "specialPurpose"
  という名前のヘルパーを作成した場合は、そのクラス名には 最低限 "SpecialPurpose"
  が含まれている必要があります。 このクラス名にプレフィックスを指定できます。
  プレフィックスの一部に 'View_Helper' を含めることを推奨します。たとえば
  "My_View_Helper_SpecialPurpose" のようになります (``addHelperPath()`` や ``setHelperPath()``
  にはプレフィックスを指定する必要があります。
  最後のアンダースコアは含めても含めなくてもかまいません)。

- クラスは、ヘルパーと同じ名前の public メソッドを持っている必要があります。
  テンプレートが "$this->specialPurpose()" をコールした際に、
  このメソッドがコールされます。"specialPurpose" ヘルパーの例では、 "public function
  specialPurpose()" というメソッドが必要です。

- 一般に、クラスでは echo や print その他の出力を行ってはいけません。
  その代わりに、print あるいは echo される内容を返します。
  返り値は、適切にエスケープしなければなりません。

- クラスは、ヘルパークラスと同じ名前のファイルに作成しなければなりません。
  再び "specialPurpose" ヘルパーを例にとると、ファイル名は "SpecialPurpose.php"
  でなければなりません。

指定したヘルパーパスのどこかにヘルパークラスのファイルを配置すると、
``Zend_View`` は自動的にそれを読み込んでインスタンスを作成し、
必要に応じて実行します。

``SpecialPurpose`` ヘルパーのコードの例を示します。

.. code-block:: php
   :linenos:

   class My_View_Helper_SpecialPurpose extends Zend_View_Helper_Abstract
   {
       protected $_count = 0;
       public function specialPurpose()
       {
           $this->_count++;
           $output = "'The Jerk' を {$this->_count} 回見ました。";
           return htmlspecialchars($output);
       }
   }

そして、ビュースクリプト内で ``SpecialPurpose``
ヘルパーを必要なだけコールします。いちどインスタンスが作成された後は、
``Zend_View`` インスタンスの中でそれが持続します。

.. code-block:: php
   :linenos:

   // ビュースクリプト内では、$this は Zend_View インスタンスを指すことを覚えておきましょう。
   echo $this->specialPurpose();
   echo $this->specialPurpose();
   echo $this->specialPurpose();

出力結果は、次のようになります。

.. code-block:: php
   :linenos:

   'The Jerk' を 1 回見ました。
   'The Jerk' を 2 回見ました。
   'The Jerk' を 3 回見ました。

時には ``Zend_View`` オブジェクトを使用したくなることもあるでしょう。
たとえば登録されているエンコーディングを使用する必要があったり、
ヘルパー内で別のビュースクリプトをレンダリングしたくなったりといった場合です。
ビューオブジェクトにアクセスするには、ヘルパークラス内で次のような
``setView($view)`` メソッドを定義しなければなりません。

.. code-block:: php
   :linenos:

   class My_View_Helper_ScriptPath
   {
       public $view;

       public function setView(Zend_View_Interface $view)
       {
           $this->view = $view;
       }

       public function scriptPath($script)
       {
           return $this->view->getScriptPath($script);
       }
   }

ヘルパークラスで ``setView()`` メソッドを定義しておくと、
最初にインスタンスが作成される際に自動的にこのメソッドがコールされ、
現在のビューオブジェクトが引数として渡されます。
渡されたオブジェクトをクラス内でどのように管理するかは特に決まっていません。
お好みの方法で管理してください。

``Zend_View_Helper_Abstract`` を継承する場合は、
このメソッドはすでに定義済みであるため定義する必要はありません。

.. _zend.view.helpers.registering-concrete:

Registering Concrete Helpers
----------------------------

Sometimes it is convenient to instantiate a view helper, and then register it with the view. As of version 1.10.0,
this is now possible using the ``registerHelper()`` method, which expects two arguments: the helper object, and the
name by which it will be registered.

.. code-block:: php
   :linenos:

   $helper = new My_Helper_Foo();
   // ...do some configuration or dependency injection...

   $view->registerHelper($helper, 'foo');

If the helper has a ``setView()`` method, the view object will call this and inject itself into the helper on
registration.

.. note::

   **Helper name should match a method**

   The second argument to ``registerHelper()`` is the name of the helper. A corresponding method name should exist
   in the helper; otherwise, ``Zend_View`` will call a non-existent method when invoking the helper, raising a
   fatal *PHP* error.


