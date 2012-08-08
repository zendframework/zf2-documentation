.. EN-Revision: none
.. _zend.console.getopt.configuration:

Zend_Console_Getopt の設定
=======================

.. _zend.console.getopt.configuration.addrules:

オプションの規則の追加
-----------

``Zend_Console_Getopt`` のコンストラクタで指定するもの以外にも、
追加でオプションの規則を指定できます。その際には ``addRules()``
メソッドを使用します。 ``addRules()``
に渡す引数は、コンストラクタの最初の引数と同じです。
短い形式のオプション指定を表す文字列、
あるいは長い形式のオプション指定を表す連想配列となります。
オプションを指定する構文の詳細は、 :ref:`Getopt の規則の宣言 <zend.console.getopt.rules>`\
を参照ください。

.. _zend.console.getopt.configuration.addrules.example:

.. rubric:: addRules() の使用法

.. code-block:: php
   :linenos:

   $opts = new Zend_Console_Getopt('abp:');
   $opts->addRules(
     array(
       'verbose|v' => '詳細な出力を表示する'
     )
   );

上の例は、 ``--verbose`` というオプションと そのエイリアス ``-v`` を
コンストラクタで定義したオプションに追加しています。 ``Zend_Console_Getopt``
のインスタンスには、
短い形式のオプションと長い形式のオプションが共存可能であることに注意しましょう。

.. _zend.console.getopt.configuration.addhelp:

ヘルプメッセージの追加
-----------

長い形式のオプション規則を宣言する際に指定するヘルプ文字列に加え、 ``setHelp()``
メソッドでもヘルプ文字列を規則と関連付けることができます。 ``setHelp()``
メソッドの引数は連想配列で、
キーがフラグ名、値が対応するヘルプ文字列となります。

.. _zend.console.getopt.configuration.addhelp.example:

.. rubric:: setHelp() の使用法

.. code-block:: php
   :linenos:

   $opts = new Zend_Console_Getopt('abp:');
   $opts->setHelp(
       array(
           'a' => 'リンゴです。パラメータは不要です。',
           'b' => 'バナナです。整数パラメータが必須です。',
           'p' => '洋ナシです。オプションで文字列パラメータを指定します。'
       )
   );

エイリアスつきでオプションを宣言した場合は、
どのエイリアスでも連想配列のキーに使用できます。

オプションを短い構文で宣言した場合、ヘルプ文字列を設定するには ``setHelp()``
メソッドが唯一の手段となります。

.. _zend.console.getopt.configuration.addaliases:

オプションのエイリアスの追加
--------------

オプションのエイリアスを宣言するには ``setAliases``
メソッドを使用します。引数は連想配列で、
先ほど宣言したフラグがキー、そしてそのフラグのエイリアスが値となります。
ここで指定したエイリアスが、既存のエイリアスにマージされます。
言い換えると、もともと定義されていたエイリアスもそのまま有効であるということです。

エイリアスは一度しか宣言できません。既存のエイリアスを再定義しようとすると
``Zend_Console_Getopt_Exception`` がスローされます。

.. _zend.console.getopt.configuration.addaliases.example:

.. rubric:: setAliases() の使用法

.. code-block:: php
   :linenos:

   $opts = new Zend_Console_Getopt('abp:');
   $opts->setAliases(
       array(
           'a' => 'apple',
           'a' => 'apfel',
           'p' => 'pear'
       )
   );

上の例では ``-a``\ 、 ``--apple`` および ``--apfel`` をお互いエイリアス指定した後で、
``-p`` と ``--pear`` もエイリアスとしています。

オプションを短い構文で宣言した場合、エイリアスを定義するには ``setAliases()``
メソッドが唯一の手段となります。

.. _zend.console.getopt.configuration.addargs:

引数リストの追加
--------

デフォルトでは、 ``Zend_Console_Getopt`` は ``$_SERVER['argv']`` の配列を使用して
コマンドライン引数をパースします。
コンストラクタの二番目の引数として、引数を含む別の配列を指定することもできます。
さらに、もっと別の引数を追加するには ``addArguments()`` メソッドを使用し、
既存の引数配列を置き換えるには ``setArguments()``
メソッドを使用します。どちらの場合についても、
これらのメソッドのパラメータは単純な文字列の配列となります。 ``addArguments()``
は現在の引数にその配列を追加し、 ``setArguments()``
は現在の引数をその配列で置き換えます。

.. _zend.console.getopt.configuration.addargs.example:

.. rubric:: addArguments() および setArguments() の使用法

.. code-block:: php
   :linenos:

   // デフォルトでは、コンストラクタは $_SERVER['argv'] を使用します
   $opts = new Zend_Console_Getopt('abp:');

   // 既存の引数に配列を追加します
   $opts->addArguments(array('-a', '-p', 'p_parameter', 'non_option_arg'));

   // 新しい配列で既存の引数を置き換えます
   $opts->setArguments(array('-a', '-p', 'p_parameter', 'non_option_arg'));

.. _zend.console.getopt.configuration.config:

設定の追加
-----

``Zend_Console_Getopt`` コンストラクタの 三番目の引数は、設定オプションの配列です。
これは、返り値となるオブジェクトのインスタンスの挙動を設定するものです。
設定オプションを指定するために ``setOptions()``
メソッドを指定することもできます。あるいは、 オプションを個別に設定するには
``setOption()`` メソッドを使用します。

.. note::

   **"オプション" という用語について**

   ここでいう "オプション" は、 ``Zend_Console_Getopt``
   クラスの設定に使用するもののことを指しています。
   オプションという言葉の意味自体は、Zend Framework
   のその他の部分で使用している意味と同じです。 ``Zend_Console_Getopt`` がパースする
   コマンドラインオプションのことではありません。

現在サポートしているオプションには、 クラス定数が定義されています。
オプションとそれに対応する定数 (およびリテラル値) の一覧を以下にまとめます。

- ``Zend_Console_Getopt::CONFIG_DASHDASH`` ("dashDash") を ``TRUE``
  にすると、フラグの終了を表す特殊フラグ ``--``
  を有効にします。ダブルダッシュの後に続くコマンドライン引数は、
  たとえダッシュで始まっていてもオプションとはみなされません。
  この設定オプションは、デフォルトで ``TRUE`` となっています。

- ``Zend_Console_Getopt::CONFIG_IGNORECASE`` ("ignoreCase") を ``TRUE`` にすると、
  大文字小文字が違うだけのフラグをお互いエイリアスとして扱います。 つまり、
  ``-a`` と ``-A`` は同じフラグとみなされます。
  この設定オプションは、デフォルトでは ``FALSE`` となっています。

- ``Zend_Console_Getopt::CONFIG_RULEMODE`` ("ruleMode") には ``Zend_Console_Getopt::MODE_ZEND`` ("zend")
  あるいは ``Zend_Console_Getopt::MODE_GNU`` ("gnu") のいずれかを指定します。
  独自の構文を使用するためにクラスを拡張する場合を除き、
  このオプションを使用する必要はありません。 ``Zend_Console_Getopt``
  でサポートされている二つのモードは明確です。 文字列を指定した場合は
  ``MODE_GNU``\ 、 それ以外の場合は ``MODE_ZEND`` とみなします。
  もしクラスを拡張して別の構文形式を追加した場合は、
  そのモードをこのオプションで指定する必要があります。

将来は、さらに多くの設定オプションがこのクラスに追加される予定です。

``setOption()`` メソッドに渡す引数は、設定オプション名とその値のふたつです。

.. _zend.console.getopt.configuration.config.example.setoption:

.. rubric:: setOption() の使用法

.. code-block:: php
   :linenos:

   $opts = new Zend_Console_Getopt('abp:');
   $opts->setOption('ignoreCase', true);

``setOptions()`` メソッドに渡す引数は連想配列です。
そのキーが設定オプション名、そして値として設定値を指定します。
これは、クラスのコンストラクタで使用するフォーマットでもあります。
指定した設定項目が既存の設定にマージされるので、
すべてのオプションを指定する必要はありません。

.. _zend.console.getopt.configuration.config.example.setoptions:

.. rubric:: setOptions() の使用法

.. code-block:: php
   :linenos:

   $opts = new Zend_Console_Getopt('abp:');
   $opts->setOptions(
       array(
           'ignoreCase' => true,
           'dashDash'   => false
       )
   );


