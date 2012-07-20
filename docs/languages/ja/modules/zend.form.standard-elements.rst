.. _zend.form.standardElements:

Zend Framework に同梱されている標準のフォーム要素
================================

Zend Framework には標準でいくつかの具象要素クラスが組み込まれており、 HTML
フォーム要素の大半を網羅しています。
そのほとんどは特定のビューヘルパーを指定して要素をデコレートするだけのものですが、
追加機能を提供しているものもあります。
ここでは、標準の要素クラスとその機能についての説明をまとめます。

.. _zend.form.standardElements.button:

Zend_Form_Element_Button
------------------------

HTML の button 要素を作成する際に使用します。 ``Zend_Form_Element_Button`` は
:ref:`Zend_Form_Element_Submit <zend.form.standardElements.submit>`
を継承して独自の機能を追加したものです。 'formButton'
ビューヘルパーでデコレートを行います。

submit 要素と同様、要素のラベルを表示時の値として使用します。
つまり、ボタンのテキストを設定するにはその要素の value を設定します。
翻訳アダプタが存在するときは、ラベルも翻訳されます。

ラベルも要素の一部なので、button 要素は :ref:`ViewHelper <zend.form.standardDecorators.viewHelper>`
デコレータと :ref:`DtDdWrapper <zend.form.standardDecorators.dtDdWrapper>`
デコレータのみを使用します。

フォームの表示や検証の後で、 そのボタンが押されたかどうかを調べたい場合は
``isChecked()`` メソッドを使用します。

.. _zend.form.standardElements.captcha:

Zend_Form_Element_Captcha
-------------------------

CAPTCHAs
は、ボットやその他の自動処理プロセスからの自動送信を防ぐための仕組みです。

Captcha フォーム要素は、フォームの captcha でどの :ref:`Zend_Captcha アダプタ
<zend.captcha.adapters>` を使用するかを選択できます。
それからこのアダプタをオブジェクトのバリデータとして設定し、 CAPTCHA
デコレータを使用してレンダリングを行います (CAPTCHA
アダプタへのプロキシとなります)。

アダプタとしては ``Zend_Captcha``
の任意のアダプタを使用でき、また別途定義したその他のアダプタも使用できます。
そのためには、プラグインローダのプレフィックスパスを指定する際に 追加のキー
'CAPTCHA' あるいは 'captcha' を指定します。

.. code-block:: php
   :linenos:

   $element->addPrefixPath('My_Captcha', 'My/Captcha/', 'captcha');

CAPTCHA を登録するには ``setCaptcha()``
メソッドを使用します。ここには、具象インスタンスあるいは CAPTCHA
アダプタの短い名前を指定します。

.. code-block:: php
   :linenos:

   // 具象インスタンス
   $element->setCaptcha(new Zend_Captcha_Figlet());

   // 短い名前
   $element->setCaptcha('Dumb');

設定経由で要素を読み込みたい場合は、キー 'captcha' の値に配列 (キー 'captcha'
を含むもの) を指定するか、 キー 'captcha' と 'captchaOptions' の両方を指定します。

.. code-block:: php
   :linenos:

   // 単一の captcha キーの使用
   $element = new Zend_Form_Element_Captcha('foo', array(
       'label' => "あなたが人間かどうかを確認します",
       'captcha' => array(
           'captcha' => 'Figlet',
           'wordLen' => 6,
           'timeout' => 300,
       ),
   ));

   // captcha と captchaOptions の使用
   $element = new Zend_Form_Element_Captcha('foo', array(
       'label' => "あなたが人間かどうかを確認します",
       'captcha' => 'Figlet',
       'captchaOptions' => array(
           'captcha' => 'Figlet',
           'wordLen' => 6,
           'timeout' => 300,
       ),
   ));

使用するデコレータは、captcha アダプタの設定によって決まります。 デフォルトでは
:ref:`Captcha デコレータ <zend.form.standardDecorators.captcha>` を使用しますが、 ``getDecorator()``
メソッドで別のアダプタを指定することもできます。

captcha
アダプタそれ自体は、要素のバリデータとして動作することに注意しましょう。
さらに、NotEmpty バリデータは用いず、 その要素は必須指定となります。
ほとんどの場合は、フォームに captcha
を表示させるために特に何もする必要はないでしょう。

.. _zend.form.standardElements.checkbox:

Zend_Form_Element_Checkbox
--------------------------

HTML のチェックボックスは指定した値を返すことができます。 しかし、基本的には
boolean として扱います。 チェックされている場合はその値が送信され、
チェックされていない場合はなにも送信されません。 内部的に、
``Zend_Form_Element_Checkbox`` はこの状態を強制します。

デフォルトでは、チェックされているときの値は '1'
でチェックされていないときの値は '0' です。 使用する値を指定するには、アクセサ
``setCheckedValue()`` および ``setUncheckedValue()``
をそれぞれ使用します。内部的には、この値を設定すると、 渡された値が checked
値と一致する場合はその値を設定しますが、 それ以外の値が渡された場合は unchecked
値を設定します。

さらに、値を設定するとチェックボックスの *checked* プロパティも設定されます。
この内容を確認するには、 ``isChecked()``
を使用するか、単純にそのプロパティにアクセスします。 ``setChecked($flag)``
メソッドを使用すると、 フラグの状態を設定すると同時に checked 値あるいは unchecked
値のいずれか適切なほうを要素の値として設定します。
チェックボックス要素のチェック状態を設定するときには、
このメソッドを使用してプロパティが適切に設定されるようにしましょう。

``Zend_Form_Element_Checkbox`` は 'formCheckbox' ビューヘルパーを使用します。 値としては常に
checked 値を使用します。

.. _zend.form.standardElements.file:

Zend_Form_Element_File
----------------------

File
フォーム要素は、ファイルアップロード用のフィールドをフォームに用意します。
:ref:`Zend_File_Transfer <zend.file.transfer.introduction>`
を内部で使用してこの機能を実現しており、 *FormFile* ビューヘルパーと *File*
デコレータでフォーム要素を表示しています。

デフォルトでは、 *Http* 転送アダプタを使用します。 これは *$_FILES*
配列の中身を読み取り、 バリデータやフィルタを使用できるようにします。
フォーム要素にアタッチされたバリデータおよびアダプタが、
この転送アダプタにアタッチされます。

.. _zend.form.standardElements.file.usage:

.. rubric:: File フォーム要素の使用法

上の説明だけでは File フォーム要素を使うのが難しく感じられるかもしれません。
でも、実際に使ってみると比較的簡単なものです。

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_File('foo');
   $element->setLabel('Upload an image:')
           ->setDestination('/var/www/upload');
   // ファイルはひとつだけ
   $element->addValidator('Count', false, 1);
   // 最大で 100K
   $element->addValidator('Size', false, 102400);
   // JPEG、PNG および GIF のみ
   $element->addValidator('Extension', false, 'jpg,png,gif');
   $form->addElement($element, 'foo');

また、正しいエンコード形式をフォームに指定する必要があります。 'multipart/form-data'
を使用しなければなりません。 これは、フォームの 'enctype' 属性で指定します。

.. code-block:: php
   :linenos:

   $form->setAttrib('enctype', 'multipart/form-data');

フォームの検証が成功したら、 ``receive()``
でファイルを受信して最終的な場所に保存しなければなりません。
さらに、最終的な場所を取得するには ``getFileName()`` を使用します。

.. code-block:: php
   :linenos:

   if (!$form->isValid()) {
       print "あららら... 検証エラー";
   }

   if (!$form->foo->receive()) {
       print "ファイル受信エラー";
   }

   $location = $form->foo->getFileName();

.. note::

   **デフォルトのアップロード先**

   デフォルトでは、システムの temp
   ディレクトリにファイルがアップロードされます。

.. note::

   **File の値**

   *HTTP* 内で、file 要素は値を持ちません。
   したがって、またセキュリティ上の理由もあって、 ``getValue()``
   ではアップロードしたファイル名だけしか取得できません。
   完全パスを取得することはできません。完全な情報が欲しい場合は、 ``getFileName()``
   をコールすればパスおよびファイル名が得られます。

デフォルトでは、フォーム上で ``getValues()``
をコールしたときにファイルが自動的に受信されます。
このような挙動となる理由は、ファイルそのものが file 要素の値となるからです。

.. code-block:: php
   :linenos:

   $form->getValues();

.. note::

   したがって、 ``getValues()`` をコールした後に改めて ``receive()``
   をコールしても何も影響を及ぼしません。また、 ``Zend_File_Transfer``
   のインスタンスを作成しても何も影響を及ぼしません。
   受信すべきファイルはもうないからです。

しかし、ファイルを受信せずに ``getValues()``
をコールしたい場合もあるかもしれません。 そのような場合は ``setValueDisabled(true)``
をコールします。 このフラグの値を取得するには ``isValueDisabled()`` をコールします。

.. _zend.form.standardElements.file.retrievement:

.. rubric:: 明示的なファイルの取得

まずは ``setValueDisabled(true)`` をコールします。

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_File('foo');
   $element->setLabel('Upload an image:')
           ->setDestination('/var/www/upload')
           ->setValueDisabled(true);

これで、 ``getValues()`` をコールしてもファイルは取得されなくなります。
したがって、file 要素上で ``receive()`` をコールするか、 あるいは ``Zend_File_Transfer``
のインスタンスを自分で作成しなければなりません。

.. code-block:: php
   :linenos:

   $values = $form->getValues();

   if ($form->isValid($form->getPost())) {
       if (!$form->foo->receive()) {
           print "Upload error";
       }
   }

アップロードされたファイルの状態については、次のメソッドで調べることができます。

- ``isUploaded()``: file 要素がアップロード済みかどうかを調べます。

- ``isReceived()``: file 要素を既に受信済みかどうかを調べます。

- ``isFiltered()``: フィルタが file 要素に適用済みかどうかを調べます。

.. _zend.form.standardElements.file.isuploaded:

.. rubric:: オプションのファイルがアップロードされたかどうかの確認

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_File('foo');
   $element->setLabel('Upload an image:')
           ->setDestination('/var/www/upload')
           ->setRequired(false);
   $element->addValidator('Size', false, 102400);
   $form->addElement($element, 'foo');

   // file 要素 foo はオプションですが、もしアップロードされた場合はここに到達します
   if ($form->foo->isUploaded()) {
       // foo がアップロードされたので、ここで何かをします
   }

``Zend_Form_Element_File`` は複数のファイルもサポートしています。 ``setMultiFile($count)``
メソッドをコールすると、 作成したい file 要素の数を設定できます。
これを使えば、同じ設定を何度も行う手間が省けます。

.. _zend.form.standardElements.file.multiusage:

.. rubric:: 複数のファイルの設定

複数の要素を作成する方法は、単一の要素を作成する場合と同じで、
作成した後にさらに ``setMultiFile()`` をコールするだけです。

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_File('foo');
   $element->setLabel('Upload an image:')
           ->setDestination('/var/www/upload');
   // ファイルの数を最小で 1、最大で 3 とします
   $element->addValidator('Count', false, array('min' => 1, 'max' => 3));
   // 100K までに制限します
   $element->addValidator('Size', false, 102400);
   // JPEG, PNG, および GIF のみを有効とします
   $element->addValidator('Extension', false, 'jpg,png,gif');
   // 3 つの file 要素を作成します
   $element->setMultiFile(3);
   $form->addElement($element, 'foo');

ビューにおいて、同じ設定のファイルアップロード要素が 3 つ取得できます。
現在設定されている値を取得するには ``getMultiFile()`` をコールします。

.. note::

   **サブフォームにおける File 要素**

   file 要素をサブフォーム内で使う場合は、一意な名前を設定する必要があります。
   subform1 の file 要素を "file" という名前にしたのなら、 subform2
   ではそれと違う名前にしなければなりません。

   同名の file 要素が複数存在した場合、 後から登場した要素は表示 (送信)
   されません。

   さらに、file 要素はサブフォーム内ではレンダリングされません。 file
   要素をサブフォームに追加する場合は、
   要素のレンダリングをメインフォームで行うことになります。

アップロードされるファイルのサイズを制限するには、
フォームで受け付けるファイルサイズの最大値も設定しなければなりません。
受け付けるサイズをクライアント側で制限するには、form のオプション ``MAX_FILE_SIZE``
を設定します。この値を ``setMaxFileSize($size)`` メソッドで設定すると、 それが file
要素のレンダリング時に用いられます。

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_File('foo');
   $element->setLabel('Upload an image:')
           ->setDestination('/var/www/upload')
           ->addValidator('Size', false, 102400) // 100K までに制限します
           ->setMaxFileSize(102400); // ファイルサイズをクライアント側で制限します
   $form->addElement($element, 'foo');

.. note::

   **複数の file 要素がある場合の MaxFileSize**

   複数の file 要素をフォームで使用する場合は、 ``MAX_FILE_SIZE``
   を設定する必要があるのは一度だけです。
   複数回設定すると、後から設定した値がそれまでの値を上書きします。

   また、複数のフォームを使用する場合であってもこれがあてはまることに注意しましょう。

.. _zend.form.standardElements.hidden:

Zend_Form_Element_Hidden
------------------------

Hidden 要素はただ単にデータを送信するだけのもので、
ユーザはその値を変更してはいけません。 ``Zend_Form_Element_Hidden`` は、この機能を
'formHidden' ビューヘルパーで実現します。

.. _zend.form.standardElements.hash:

Zend_Form_Element_Hash
----------------------

この要素は CSRF 攻撃からフォームを保護するものです。
送信されたデータがもとのフォームのユーザセッションからのものである
(悪意のあるスクリプトからのものではない) ことを保証できるようにします。
これを実現するために、フォームにハッシュ要素を追加して
あとでそのハッシュを検証するようにしています。

ハッシュ要素の名前は一意なものでなければなりません。 この要素ではオプション
``salt`` を使うことを推奨します。 名前が同じでも salt
が異なればハッシュは衝突しません。

.. code-block:: php
   :linenos:

   $form->addElement('hash', 'no_csrf_foo', array('salt' => 'unique'));

salt は、後から ``setSalt($salt)`` メソッドを使って設定することもできます。

内部的には、この要素は一意な ID を ``Zend_Session_Namespace`` を用いて保存しており、
送信されたときにその内容 (TTL が期限切れになっていないかどうか)
をチェックしています そして、'Identical' バリデータを使用して、
送信されたハッシュと保存されているハッシュを比較します。

'formHidden' ビューヘルパーを使用して要素をフォームにレンダリングします。

.. _zend.form.standardElements.Image:

Zend_Form_Element_Image
-----------------------

画像もフォーム要素として使用できます。
これを用いると、フォームのボタンにグラフィカルな要素を指定したりできます。

この要素には、元となる画像が必要です。 ``Zend_Form_Element_Image`` では、それを
``setImage()`` アクセサ (あるいは設定キー 'image') で設定します。 また、画像を submit
したときに使用する値は、 ``setImageValue()`` アクセサ (あるいは設定キー 'imageValue')
でオプションとして設定できます。 その要素に設定された値が *imageValue*
とマッチした場合、アクセサ ``isChecked()`` は ``TRUE`` を返します。

Image 要素はその value を元画像として使用し、 :ref:`Image デコレータ
<zend.form.standardDecorators.image>` でレンダリングを行います (それ以外に標準のデコレータ
Errors、HtmlTag および Label も使用します)。 オプションのタグを *Image*
デコレータに指定すると、 それで image 要素をラップできます。

.. _zend.form.standardElements.multiCheckbox:

Zend_Form_Element_MultiCheckbox
-------------------------------

関連する複数のチェックボックスをひとまとめにし、
結果をグループ化して扱いたいこともあるでしょう。ちょうど :ref:`Multiselect
<zend.form.standardElements.multiselect>` に似ていますが、ドロップダウンリストではなく
チェックボックス形式で表示させたいのです。

``Zend_Form_Element_MultiCheckbox`` は それを行うためのものです。Multi
要素を継承したその他の要素を同様に、
選択肢のリストを指定してそれらを同じ方法で検証できます。 'formMultiCheckbox'
ビューヘルパーを使用して、 フォームの送信内容を配列で返すようにします。

デフォルトでは、この要素は *InArray* バリデータを登録します。このバリデータは、
登録されたオプションの配列のキーに対して検証を行います。
この振る舞いを無効にするには ``setRegisterInArrayValidator(false)``
をコールするか、あるいは設定キー *registerInArrayValidator* に ``FALSE`` 値を渡します。

チェックボックスのオプションを操作するには、 次のメソッドを使用します。

- ``addMultiOption($option, $value)``

- ``addMultiOptions(array $options)``

- ``setMultiOptions(array $options)`` (既存のオプションを上書きします)

- ``getMultiOption($option)``

- ``getMultiOptions()``

- ``removeMultiOption($option)``

- ``clearMultiOptions()``

チェックされた項目を指定するには、値の配列を ``setValue()`` に渡す必要があります。
次の例は、値 "bar" と "bat" をチェックします。

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_MultiCheckbox('foo', array(
       'multiOptions' => array(
           'foo' => 'Foo Option',
           'bar' => 'Bar Option',
           'baz' => 'Baz Option',
           'bat' => 'Bat Option',
       );
   ));

   $element->setValue(array('bar', 'bat'));

値をひとつだけ指定する場合でも、配列形式でなければならないことに注意しましょう。

.. _zend.form.standardElements.multiselect:

Zend_Form_Element_Multiselect
-----------------------------

*XHTML* の *select* 要素には 'multiple' 属性を指定できます。
これは、普通の要素ではなく複数項目を選択できる要素を表します。
``Zend_Form_Element_Multiselect`` は、 :ref:`Zend_Form_Element_Select <zend.form.standardElements.select>`
を継承して *multiple* 要素を 'multiple' に設定したものです。基底クラス
``Zend_Form_Element_Multi``
を継承したその他のクラスと同様、以下のメソッドでオプションを操作できます。

- ``addMultiOption($option, $value)``

- ``addMultiOptions(array $options)``

- ``setMultiOptions(array $options)`` (既存のオプションを上書きします)

- ``getMultiOption($option)``

- ``getMultiOptions()``

- ``removeMultiOption($option)``

- ``clearMultiOptions()``

フォームや要素に翻訳アダプタが登録されている場合は、
表示時にオプションの値が翻訳されます。

デフォルトでは、この要素は *InArray* バリデータを登録します。このバリデータは、
登録されたオプションの配列のキーに対して検証を行います。
この振る舞いを無効にするには ``setRegisterInArrayValidator(false)``
をコールするか、あるいは設定キー *registerInArrayValidator* に ``FALSE`` 値を渡します。

.. _zend.form.standardElements.password:

Zend_Form_Element_Password
--------------------------

Password 要素は、基本的には通常の text 要素と同じです。
しかし、フォームの再描画時やエラーメッセージなどに
入力内容を表示させないようにします。

``Zend_Form_Element_Password`` は、これを実現するために 各バリデータ上で
``setValueObscured(true)`` (検証エラーの際のメッセージでパスワードを表示させない)
をコールし、'formPassword' ビューヘルパー (渡された値を表示しない) を使用します。

.. _zend.form.standardElements.radio:

Zend_Form_Element_Radio
-----------------------

Radio 要素は、いくつかの選択肢を指定してその中から
ひとつを選ばせるためのものです。 ``Zend_Form_Element_Radio`` は規定クラス
``Zend_Form_Element_Multi`` を継承したもので、
複数のオプションを指定できます。そして、それを表示するために *formRadio*
ビューヘルパーを使用します。

デフォルトでは、この要素は *InArray* バリデータを登録します。このバリデータは、
登録されたオプションの配列のキーに対して検証を行います。
この振る舞いを無効にするには ``setRegisterInArrayValidator(false)``
をコールするか、あるいは設定キー *registerInArrayValidator* に ``FALSE`` 値を渡します。

Multi 要素基底クラスを継承したその他のクラスと同様、
以下のメソッドでラジオボタンの表示オプションを操作できます。

- ``addMultiOption($option, $value)``

- ``addMultiOptions(array $options)``

- ``setMultiOptions(array $options)`` (既存のオプションを上書きします)

- ``getMultiOption($option)``

- ``getMultiOptions()``

- ``removeMultiOption($option)``

- ``clearMultiOptions()``

.. _zend.form.standardElements.reset:

Zend_Form_Element_Reset
-----------------------

Reset ボタンはフォームの入力内容をクリアするために使用します。
データは送信されません。しかし、表示時の役割があるため、
標準要素のひとつとして組み込まれています。

``Zend_Form_Element_Reset`` は :ref:`Zend_Form_Element_Submit <zend.form.standardElements.submit>`
を継承しています。ボタンの表示時にはラベルを使用し、
翻訳アダプタが存在する場合はそれが翻訳されます。
この要素が使用するデコレータは 'ViewHelper' と 'DtDdWrapper' のみです。
この要素にはエラーメッセージがなく、またラベルも必須ではないからです。

.. _zend.form.standardElements.select:

Zend_Form_Element_Select
------------------------

セレクトボックスは、指定したデータの中から選択させたいときに使用するものです。
``Zend_Form_Element_Select`` は、 セレクトボックスをお手軽に作成します。

デフォルトでは、この要素は *InArray* バリデータを登録します。このバリデータは、
登録されたオプションの配列のキーに対して検証を行います。
この振る舞いを無効にするには ``setRegisterInArrayValidator(false)``
をコールするか、あるいは設定キー *registerInArrayValidator* に ``FALSE`` 値を渡します。

Multi 要素を継承したその他のクラスと同様、
以下のメソッドでオプションを操作できます。

- ``addMultiOption($option, $value)``

- ``addMultiOptions(array $options)``

- ``setMultiOptions(array $options)`` (既存のオプションを上書きします)

- ``getMultiOption($option)``

- ``getMultiOptions()``

- ``removeMultiOption($option)``

- ``clearMultiOptions()``

``Zend_Form_Element_Select`` は 'formSelect' ビューヘルパーでデコレートを行います。

.. _zend.form.standardElements.submit:

Zend_Form_Element_Submit
------------------------

Submit ボタンはフォームの内容を送信するための要素です。 複数の submit
ボタンを使用することもできます。 どの submit
ボタンでデータを送信したかによって、
どのアクションを実行するのかを切り替えることができます。 ``Zend_Form_Element_Submit``
では、この判断をしやすくするために ``isChecked()`` メソッドを用意しています。
フォームから送信される submit ボタンはひとつだけなので、 各 submit
要素に対してこのメソッドをコールすることで
どのボタンが押されたのかを判断できます。

``Zend_Form_Element_Submit`` はラベルを submit ボタンの "値"
として使用します。翻訳アダプタが存在する場合はこれを翻訳します。 ``isChecked()``
は、送信された値をこのラベルと比較し、
そのボタンが押されたのかどうかを判断します。

:ref:`ViewHelper <zend.form.standardDecorators.viewHelper>` デコレータと :ref:`DtDdWrapper
<zend.form.standardDecorators.dtDdWrapper>`
デコレータを使用して要素をレンダリングします。label
デコレータは使用しません。要素のレンダリング時にはボタンのラベルを使用するからです。
また、一般的には submit 要素にはエラーを関連付けません。

.. _zend.form.standardElements.text:

Zend_Form_Element_Text
----------------------

最もよく用いられているフォーム要素は text 要素です。
これはテキスト入力用の要素で、大半の入力項目に適しています。
``Zend_Form_Element_Text`` は、単純に 'formText'
ビューヘルパーを使用して要素を表示します。

.. _zend.form.standardElements.textarea:

Zend_Form_Element_Textarea
--------------------------

Textarea は大量のテキストを入力させるために使用します。
テキストの量に制限を設けません (サーバや *PHP* の設定による制限は除きます)。
``Zend_Form_Element_Textarea`` は 'textArea'
ビューヘルパーを使用して要素とその値を表示します。


