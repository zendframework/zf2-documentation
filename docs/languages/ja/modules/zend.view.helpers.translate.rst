.. _zend.view.helpers.initial.translator:

翻訳ヘルパー
======

ウェブサイトを複数言語で提供することもよくあります。
サイト上のコンテンツを翻訳するには、 :ref:`Zend_Translator <zend.translator.introduction>`
を使用します。 ``Zend_Translator`` をビューと統合するために使用するのが **Translator**
ビューヘルパーです。

これ以降のすべての例では、単純は配列翻訳アダプタを使用します。 もちろん
``Zend_Translator`` の任意のインスタンスやお好みの ``Zend_Translator_Adapter``
のサブクラスを使うことも可能です。 **Translator**
ビューヘルパーのインスタンスを作成するにはいくつかの方法があります。

- 事前に ``Zend_Registry`` に登録済みのインスタンスを使用する

- 流れるようなインターフェイスで後から追加する

- クラスのインスタンスの作成時に直接指定する

登録済みの ``Zend_Translator`` のインスタンスを使用する方法をおすすめします。
アダプタをレジストリに追加する際に、使用するロケールを選択できます。

.. note::

   ここで言語ではなくロケールと言っているのは、
   言語には地域を含む可能性があるからです。
   たとえば英語は様々な地域で話されています。
   イギリス英語やアメリカ英語など複数の翻訳が存在します。 そこで、ここでは
   "言語" と言わずに "ロケール" としているのです。

.. _zend.view.helpers.initial.translator.registered:

.. rubric:: 登録済みのインスタンス

登録済みのインスタンスを使用するには、まず ``Zend_Translator`` あるいは
``Zend_Translator_Adapter`` のインスタンスを作成し、 それを ``Zend_Registry``
に登録します。登録する際のキーとして ``Zend_Translator`` を使用します。

.. code-block:: php
   :linenos:

   // サンプルアダプタ
   $adapter = new Zend_Translator(
       array(
           'adapter' => 'array',
           'content' => array('simple' => 'einfach'),
           'locale'  => 'de'
       )
   );
   Zend_Registry::set('Zend_Translator', $adapter);

   // ビューの中で
   echo $this->translate('simple');
   // これは 'einfach' を返します

流れるようなインターフェイスのほうがなじみがあるという場合は、
ビューの中でインスタンスを作成し、ヘルパーのインスタンスは後で作成することもできます。

.. _zend.view.helpers.initial.translator.afterwards:

.. rubric:: ビューの中で

流れるようなインターフェイスで ``Zend_Translator`` あるいは ``Zend_Translator_Adapter``
のインスタンスを作成するには、
パラメータを指定せずにヘルパーをコールし、それから ``setTranslator()``
メソッドをコールします。

.. code-block:: php
   :linenos:

   // ビューの中で
   $adapter = new Zend_Translator(
       array(
           'adapter' => 'array',
           'content' => array('simple' => 'einfach'),
           'locale'  => 'de'
       )
   );
   $this->translate()->setTranslator($adapter)->translate('simple');
   // これは 'einfach' を返します

ヘルパーを ``Zend_View`` なしで使用すると、 ヘルパーを直接使用することもできます。

.. _zend.view.helpers.initial.translator.directly:

.. rubric:: 直接使用する方法

.. code-block:: php
   :linenos:

   // サンプルアダプタ
   $adapter = new Zend_Translator(
       array(
           'adapter' => 'array',
           'content' => array('simple' => 'einfach'),
           'locale'  => 'de'
       )
   );

   // アダプタを初期化します
   $translate = new Zend_View_Helper_Translator($adapter);
   print $translate->translate('simple'); // これは 'einfach' を返します

``Zend_View`` は使わないけれど、
翻訳した結果がほしいという場合にこの方式を使用します。

これまで見てきたように、 ``translate()`` メソッドは翻訳を返します。
翻訳アダプタのメッセージ ID を指定してこれをコールします。
さらに、翻訳文字列の中のパラメータを置換することも可能です。
パラメータの値を指定する方法には二通りあります。
パラメータのリストを指定する方法か、あるいはパラメータの配列を指定する方法です。
たとえば次のようになります。

.. _zend.view.helpers.initial.translator.parameter:

.. rubric:: 単一のパラメータ

単一のパラメータを使用するには、単にそれをメソッドに追加します。

.. code-block:: php
   :linenos:

   // ビューの中で
   $date = "Monday";
   $this->translate("Today is %1\$s", $date);
   // これは 'Heute ist Monday' を返します

.. note::

   パラメータの値にテキストを使用する場合は、
   このパラメータの値も翻訳しなければならないことに注意しましょう。

.. _zend.view.helpers.initial.translator.parameterlist:

.. rubric:: パラメータのリスト

パラメータのリストを使用して、それをメソッドに追加することもできます。

.. code-block:: php
   :linenos:

   // ビューの中で
   $date = "Monday";
   $month = "April";
   $time = "11:20:55";
   $this->translate("Today is %1\$s in %2\$s. Actual time: %3\$s",
                    $date,
                    $month,
                    $time);
   // これは 'Heute ist Monday in April. Aktuelle Zeit: 11:20:55' を返します

.. _zend.view.helpers.initial.translator.parameterarray:

.. rubric:: パラメータの配列

パラメータの配列を使用して、それをメソッドに追加することもできます。

.. code-block:: php
   :linenos:

   // ビューの中で
   $date = array("Monday", "April", "11:20:55");
   $this->translate("Today is %1\$s in %2\$s. Actual time: %3\$s", $date);
   // これは 'Heute ist Monday in April. Aktuelle Zeit: 11:20:55' を返します

翻訳のロケールを変更しなければならないこともあるでしょう。
翻訳単位で動的に変更することもできますが、
静的に変更してそれ以降のすべての翻訳に適用させることもできます。
そして、パラメータリスト型あるいはパラメータ配列型のどちらの形式でもそれを使用できます。
どひらの形式の場合も、ロケールは最後のパラメータとして指定します。

.. _zend.view.helpers.initial.translator.dynamic:

.. rubric:: ロケールの動的な変更

.. code-block:: php
   :linenos:

   // ビューの中で
   $date = array("Monday", "April", "11:20:55");
   $this->translate("Today is %1\$s in %2\$s. Actual time: %3\$s", $date, 'it');

この例は、指定したメッセージ ID に対応するイタリア語の翻訳を返します。
しかし、イタリア語を返すのはこのときだけです。
次の翻訳では、アダプタに設定されているロケールを使用します。
通常は、使用したいロケールを翻訳アダプタに設定してからレジストリに追加します。
しかし、ロケールの設定をヘルパー内で行うこともできます。

.. _zend.view.helpers.initial.translator.static:

.. rubric:: ロケールの静的な変更

.. code-block:: php
   :linenos:

   // ビューの中で
   $date = array("Monday", "April", "11:20:55");
   $this->translate()->setLocale('it');
   $this->translate("Today is %1\$s in %2\$s. Actual time: %3\$s", $date);

上の例では新しいデフォルトロケールとして **'it'**
を設定しており、これ以降の翻訳ではこのロケールを使用します。

もちろん、現在設定されているロケールを取得するためのメソッド ``getLocale()``
もあります。

.. _zend.view.helpers.initial.translator.getlocale:

.. rubric:: 現在設定されているロケールの取得

.. code-block:: php
   :linenos:

   // ビューの中で
   $date = array("Monday", "April", "11:20:55");

   // これまでの例で設定されているデフォルトロケールである 'de' を返します
   $this->translate()->getLocale();

   $this->translate()->setLocale('it');
   $this->translate("Today is %1\$s in %2\$s. Actual time: %3\$s", $date);

   // 新たに設定されたデフォルトロケールである 'it' を返します
   $this->translate()->getLocale();


