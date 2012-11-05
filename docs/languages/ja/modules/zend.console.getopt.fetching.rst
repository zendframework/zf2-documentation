.. EN-Revision: none
.. _zend.console.getopt.fetching:

オプションおよび引数の取得
=============

``Zend\Console\Getopt`` オブジェクトでオプションを宣言し、
コマンドラインあるいは配列から引数を受け取ったら、
このオブジェクトを使用して、ユーザがプログラムを起動した際に
指定したオプションを取得できます。
このクラスはマジックメソッドを実装しているので、
オプションの名前を指定して問い合わせることができます。

実際にデータをパースするのは、 ``Zend\Console\Getopt``
に対する最初の問い合わせを行ったときです。
つまり、パースを行う前にいくつかのメソッドで
オプションや引数、ヘルプ文字列や設定項目を変更することができるということです。

.. _zend.console.getopt.fetching.exceptions:

Getopt の例外処理
------------

ユーザがコマンドラインで無効な引数を指定すると、 パース関数は
``Zend\Console_Getopt\Exception``
をスローします。この例外を、アプリケーションのコードで処理する必要があります。
``parse()`` メソッドを使用して、オブジェクトに引数をパースさせます。 **try**
ブロック内で ``parse()`` を実行できるので、便利です。
パースに成功すると、それ以降で再度例外がスローされることはありません。
スローされた例外オブジェクトで、独自のメソッド ``getUsageMessage()``
が使用できます。これは、宣言されているすべてのオプションについての
使用法を説明した文字列を返します。

.. _zend.console.getopt.fetching.exceptions.example:

.. rubric:: Getopt の例外処理

.. code-block:: php
   :linenos:

   try {
       $opts = new Zend\Console\Getopt('abp:');
       $opts->parse();
   } catch (Zend\Console_Getopt\Exception $e) {
       echo $e->getUsageMessage();
       exit;
   }

例外が発生するのは、次のような場合です。

- 指定したオプションが認識できない場合。

- パラメータが必要なオプションで、パラメータが指定されていない場合。

- オプションのパラメータの型が不正な場合。
  たとえば整数型を要求するオプションで非数値文字列が渡された場合など。

.. _zend.console.getopt.fetching.byname:

名前によるオプションの取得
-------------

``getOption()`` メソッドを使用すると、
オプションの値を問い合わせることができます。
そのオプションがパラメータを持っている場合は、
このメソッドはパラメータの値を返します。
パラメータを持っていないオプションでユーザがパラメータを指定した場合は、
このメソッドは ``TRUE`` を返します。 それ以外の場合は、このメソッドは ``NULL``
を返します。

.. _zend.console.getopt.fetching.byname.example.setoption:

.. rubric:: getOption() の使用法

.. code-block:: php
   :linenos:

   $opts = new Zend\Console\Getopt('abp:');
   $b = $opts->getOption('b');
   $p_parameter = $opts->getOption('p');

あるいは、マジックメソッド ``__get()`` を使用して、
まるでクラスのメンバ変数であるかのようにオプションの値を取得することもできます。
また、マジックメソッド ``__isset()`` も実装しています。

.. _zend.console.getopt.fetching.byname.example.magic:

.. rubric:: マジックメソッド \__get() および \__isset() の使用例

.. code-block:: php
   :linenos:

   $opts = new Zend\Console\Getopt('abp:');
   if (isset($opts->b)) {
       echo "オプション b を取得しました。\n";
   }
   $p_parameter = $opts->p; // 設定されていない場合は null となります

オプションにエイリアスが指定されている場合は、
上の方法でそのエイリアスを使用することもできます。

.. _zend.console.getopt.fetching.reporting:

オプションの取得
--------

ユーザがコマンドラインで入力したオプションの全一覧を取得するには、
いくつかの方法があります。

- 文字列で取得: ``toString()`` メソッドを使用します。
  オプションの内容が、空白で区切られた ``flag=value``
  形式の文字列で返されます。パラメータを持たないオプションの場合、 value
  の部分はリテラル文字列 "``TRUE``" となります。

- 配列で取得: ``toArray()`` メソッドを使用します。
  オプションは、数値インデックスの配列で返されます。
  配列の各要素の値は文字列で、フラグの後に (もしあれば) パラメータが続きます。

- *JSON* データを含む文字列として取得: ``toJson()`` メソッドを使用します。

- *XML* データを含む文字列として取得: ``toXml()`` メソッドを使用します。

これらのすべての出力メソッドで、フラグ文字列として使用するのは
エイリアスリストの先頭にあるものです。たとえば あるオプションのエイリアスが
``verbose|v`` のように宣言されていたとすると、最初の文字列である ``verbose``
をオプション名として使用します。
オプションフラグ名には、先頭のダッシュは含みません。

.. _zend.console.getopt.fetching.remainingargs:

非オプション引数の取得
-----------

オプション引数およびそのパラメータをコマンドラインからパースした後も、
まだ追加の引数が残っているかも知れません。これらの引数を取得するには
``getRemainingArgs()`` メソッドを使用します。このメソッドは、
どのオプションにも属さない文字列の配列を返します。

.. _zend.console.getopt.fetching.remainingargs.example:

.. rubric:: getRemainingArgs() の使用法

.. code-block:: php
   :linenos:

   $opts = new Zend\Console\Getopt('abp:');
   $opts->setArguments(array('-p', 'p_parameter', 'filename'));
   $args = $opts->getRemainingArgs(); // array('filename') を返します

``Zend\Console\Getopt`` は、 *GNU* の慣習である「ダッシュふたつだけの引数があったら、
オプションはそこで終わりとみなす」をサポートしています。
その後に続く引数は、非オプション引数として扱わなければなりません。
これは、オプションではない引数がダッシュで始まる場合などに有用です。 たとえば
"``rm -- -filename-with-dash``" のような場合です。


