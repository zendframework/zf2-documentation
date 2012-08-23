.. EN-Revision: none
.. _coding-standard:

*****************************
Zend Framework PHP 標準コーディング規約
*****************************

.. _coding-standard.overview:

概要
--

.. _coding-standard.overview.scope:

対象範囲
^^^^

このドキュメントは、Zend Framework に貢献してくださる開発者個人 (あるいはチーム)
のためにコードの書式やドキュメント作成の指針を示すものです。 Zend Framework
を用いて開発をする人たちにとってもこのコーディング規約は有用でしょう。
これに従えば、Zend Framework のコードとの一貫性が保てるからです。
そのためには、ここで完全なコーディング規約を示す必要があります。

.. note::

   注意: 詳細なレベルまでの設計指針を示すこと以上に、
   それを標準規格として確立することが大切だと考えています。 Zend Framework
   コーディング規約の指針は、 これまで Zend Framework
   プロジェクトでうまく回っていた方針をまとめたものです。 この `ライセンス`_\
   のもとで、 そのまま使用するなり多少変更して使用するなりすることができます。

Zend Framework コーディング規約では、次のような内容を扱います。

- *PHP* ファイルの書式

- 命名規約

- コーディングスタイル

- インラインドキュメント

.. _coding-standard.overview.goals:

目標
^^

どのような開発プロジェクトであっても、コーディング規約は重要です。
特に、複数の開発者が参加するプロジェクトならなおさらです。コーディング規約に従うことで、
コードの品質保持・バグの減少・保守の容易性の確保 などの助けになります。

.. _coding-standard.php-file-formatting:

PHP ファイルの書式
-----------

.. _coding-standard.php-file-formatting.general:

全般
^^

*PHP* コードのみからなるファイルでは、終了タグ ("?>")
は決して含めてはいけません。これは必須なものではなく、
終了タグを省略することで、ファイルの最後にある空白文字が出力に影響することを防ぎます。

.. note::

   **重要:** Zend Framework の *PHP* ファイルやそこから派生したものの中では、
   ``__HALT_COMPILER()`` を使用して任意のバイナリデータを含めることを禁じます。
   この機能は、インストールスクリプトなどの特別な場合にのみ使用します。

.. _coding-standard.php-file-formatting.indentation:

字下げ
^^^

字下げは空白 4 文字で行います。タブ文字を使ってはいけません。

.. _coding-standard.php-file-formatting.max-line-length:

1 行の長さ
^^^^^^

1 行の長さを 80 文字までにすることを目指しましょう。すなわち、
コードの長さを現実的な範囲で 80 文字までにおさめるよう努力すべきです。
しかしながら、場合によっては少々長くなってしまってもかまいません。 *PHP*
コードの行の長さは、最大 120 文字までにするようにしましょう。

.. _coding-standard.php-file-formatting.line-termination:

行末
^^

行末の扱いは、標準的な Unix テキストファイルの方式にあわせます。
行末は、ラインフィード (LF) のみにしなければなりません。 この文字のコードは
10、あるいは 16 進形式で 0x0A となります。

注意: Apple OS のようなキャリッジリターン (CR) (0x0D) や Windows OS
のようなキャリッジリターンとラインフィードの組み合わせ (*CRLF*) (0x0D, 0x0A)
を使用しないでください。

.. _coding-standard.naming-conventions:

命名規約
----

.. _coding-standard.naming-conventions.classes:

クラス
^^^

Zend Framework では、クラスの名前が保存先ディレクトリに直接対応するような
命名規約を採用しています。Zend Framework
標準ライブラリの最上位レベルのディレクトリは "Zend/" ディレクトリです。一方、Zend
Framework 追加ライブラリの最上位レベルのディレクトリは "ZendX/"
ディレクトリです。この配下に、すべてのクラスが階層構造で保存されます。

クラス名には英数字のみが使用できます。クラス名に数字を使用することは可能ですが、
ほとんどの場合はお勧めしません。アンダースコアはパス区切り文字としてのみ使用可能です。
ファイル名が "``Zend/Db/Table.php``" の場合、クラス名を "``Zend_Db_Table``"
としなければなりません。

クラス名が複数の単語から成り立つ場合は、
それぞれの単語の最初の文字を大文字にしなければなりません。
大文字を連続して使用することはできません。例えば "Zend_PDF"
というクラス名は許可されません。代わりに "``Zend_Pdf``" を使用します。

これらの規約によって、Zend Framework 上で擬似名前空間を定義しています。 *PHP*
に名前空間機能が追加されるようになったら、Zend Framework もそれに対応させます。
それにより、開発者は自分のアプリケーションで名前空間を使用できるようになります。

標準ライブラリや追加ライブラリのクラス名を見れば、クラス名の命名規約のよい例となるでしょう。

.. note::

   **重要:** Zend Framework ライブラリとともに配布するが、
   標準ライブラリや拡張ライブラリではないもの
   (たとえば、アプリケーションのコードや Zend 以外が作成したライブラリなど)
   については、"Zend\_" や "ZendX\_" で始まる名前は使用できません。

.. _coding-standard.naming-conventions.abstracts:

抽象クラス
^^^^^

一般に、抽象クラスの規約は通常の :ref:`クラス <coding-standard.naming-conventions.classes>`
と同じものとなります。追加の規則として、抽象クラスの名前は最後が "Abstract"
(そしてその前にはアンダースコアはつけない) でなければなりません。 たとえば
``Zend_Controller_Plugin_Abstract`` は規約にそった名前ではありません。規約に従った名前は
``Zend_Controller_PluginAbstract`` あるいは ``Zend_Controller_Plugin_PluginAbstract`` となります。

.. note::

   この命名規約が適用されるのは、Zend Framework 1.9.0 以降です。
   それより前のバージョンではこの規約に従っていないものもあるかもしれませんが、
   将来のバージョンでは規約に従うよう名前が変わる予定です。

   The rationale for the change is due to namespace usage. As we look towards Zend Framework 2.0 and usage of *PHP*
   5.3, we will be using namespaces. The easiest way to automate conversion to namespaces is to simply convert
   underscores to the namespace separator -- but under the old naming conventions, this leaves the classname as
   simply "Abstract" or "Interface" -- both of which are reserved keywords in *PHP*. If we prepend the
   (sub)component name to the classname, we can avoid these issues.

   To illustrate the situation, consider converting the class ``Zend_Controller_Request_Abstract`` to use
   namespaces:

   .. code-block:: php
      :linenos:

      namespace Zend\Controller\Request;

      abstract class Abstract
      {
          // ...
      }

   Clearly, this will not work. Under the new naming conventions, however, this would become:

   .. code-block:: php
      :linenos:

      namespace Zend\Controller\Request;

      abstract class RequestAbstract
      {
          // ...
      }

   We still retain the semantics and namespace separation, while omitting the keyword issues; simultaneously, it
   better describes the abstract class.

.. _coding-standard.naming-conventions.interfaces:

インターフェイス
^^^^^^^^

一般に、インターフェイスの規約は通常の :ref:`クラス
<coding-standard.naming-conventions.classes>`
と同じものとなります。追加の規則として、インターフェイスの名前の最後は
"Interface" (そしてその前にはアンダースコアはつけない) にすることもできます。
たとえば ``Zend_Controller_Plugin_Interface``
は規約にそった名前ではありません。規約に従った名前は ``Zend_Controller_PluginInterface``
あるいは ``Zend_Controller_Plugin_PluginInterface`` となります。

この規約は必須ではありませんが、強く推奨します。
そのファイルがクラスではなくインターフェイスを含むものであることが
開発者にわかりやすくなるからです。

.. note::

   この命名規約が適用されるのは、Zend Framework 1.9.0 以降です。
   それより前のバージョンではこの規約に従っていないものもあるかもしれませんが、
   将来のバージョンでは規約に従うよう名前が変わる予定です。
   この変更に関連する詳細については :ref:`前節 <coding-standard.naming-conventions.abstracts>`
   をご覧ください。

.. _coding-standard.naming-conventions.filenames:

ファイル名
^^^^^

すべてのファイルにおいて、使用可能な文字は英数字・アンダースコア
およびダッシュ文字 ("-") のみです。空白文字は使用できません。

*PHP* コードを含むすべてのファイルの拡張子は "``.php``" でなければなりません。
ただしビュースクリプトは例外です。次の例は、Zend Framework
のクラスに使用できるファイル名を示すものです。

.. code-block:: php
   :linenos:

   Zend/Db.php

   Zend/Controller/Front.php

   Zend/View/Helper/FormRadio.php

ファイル名は、上で説明したとおりの方式でクラス名と対応していなければなりません。

.. _coding-standard.naming-conventions.functions-and-methods:

関数およびメソッド
^^^^^^^^^

関数名に含めることができるのは英数字のみです。
アンダースコアを使用してはいけません。
数字を含めることは可能ですが、ほとんどの場合はお勧めしません。

関数名は小文字で始めなければなりません。
関数名が複数の単語で構成されている場合は、
各単語の最初の文字を大文字にしなければなりません。 一般に、このフォーマットは
"camelCaps" と呼ばれています。

関数名は省略しすぎないようにしましょう。 コードを理解しやすくするため、
現実的な範囲でできるだけ詳細な名前をつけるようにしましょう。

条件を満たす関数名の例を示します。

.. code-block:: php
   :linenos:

   filterInput()

   getElementById()

   widgetFactory()

オブジェクト指向のプログラミングでは、
インスタンス変数や静的変数にアクセスするためのメソッドは "get" あるいは "set"
のいずれかで始めなければなりません。singleton や factory
などのデザインパターンを使用する場合は、
メソッド名にパターンの名前を含めるようにしましょう。こうすることで、
どのパターンを使っているのかがわかりやすくなります。

オブジェクト内で "private" あるいは "protected"
と宣言されているメソッドについては、メソッド名の最初にアンダースコア 1
文字をつけなければなりません。アンダースコアを使用できるのは、
この場合のみです。"public" と宣言されているメソッドについては、
決してアンダースコアで始めてはいけません。

グローバル関数は、できる限り使用しないようにしましょう。
このような関数は、静的クラスにまとめることを推奨します。

.. _coding-standard.naming-conventions.variables:

変数
^^

変数名に含めることができるのは英数字のみです。
アンダースコアを使用してはいけません。
数字を含めることは可能ですが、ほとんどの場合はお勧めしません。

クラス内で "private" あるいは "protected"
と宣言されている変数については、変数名の最初にアンダースコア 1
文字をつけなければなりません。アンダースコアを使用できるのは、
この場合のみです。"public" と宣言されている変数については、
決してアンダースコアで始めてはいけません。

関数名と同様 (上の 3.3 を参照ください)、 変数名も常に小文字で開始する "camelCaps"
方式を使用しなければなりません。

変数名は省略しすぎないようにしましょう。現実的な範囲で、
できるだけ詳細な名前をつけるべきです。"``$i``" や "``$n``"
のような省略形が許されるのは、小さなループ内で使用する場合のみです。 ループが
20 行以上のコードになるようなら、
そのループ変数にはそれなりの名前をつけるべきです。

.. _coding-standard.naming-conventions.constants:

定数
^^

定数名には英数字およびアンダースコアを使用できます。
定数名には数字を使用してもかまいません。

定数名は、常にすべて大文字にします。

定数名の単語の間はアンダースコアで区切らなければなりません。 例えば
``EMBED_SUPPRESS_EMBED_EXCEPTION`` は許されますが、 ``EMBED_SUPPRESSEMBEDEXCEPTION``
は許されません。

定数を宣言する際には、クラスのメンバとして "const"
で定義しなければなりません。"define"
によるグローバル定数の宣言も可能ですが、お勧めしません。

.. _coding-standard.coding-style:

コーディングスタイル
----------

.. _coding-standard.coding-style.php-code-demarcation:

PHP コードの境界
^^^^^^^^^^

*PHP* のコードの区切りには、 標準 *PHP* タグを常に使用しなければなりません。

.. code-block:: php
   :linenos:

   <?php

   ?>

短いタグは決して使用してはいけません。 *PHP*
コードのみからなるファイルでは、終了タグ ("?>") は決して含めてはいけません
(:ref:`全般 <coding-standard.php-file-formatting.general>` を参照ください)。

.. _coding-standard.coding-style.strings:

文字列
^^^

.. _coding-standard.coding-style.strings.literals:

文字列リテラル
^^^^^^^

文字列がリテラルである (変数の展開などが含まれない)
場合は、アポストロフィあるいは「シングルクォート」
で文字列を囲まなければなりません。

.. code-block:: php
   :linenos:

   $a = '文字列の例';

.. _coding-standard.coding-style.strings.literals-containing-apostrophes:

アポストロフィを含む文字列リテラル
^^^^^^^^^^^^^^^^^

リテラル文字列自体にアポストロフィが含まれている場合は、
引用符あるいは「ダブルクォート」で文字列を囲んでもかまいません。 特に *SQL*
文などでこのような場合がよくあるでしょう。

.. code-block:: php
   :linenos:

   $sql = "SELECT `id`, `name` from `people` "
        . "WHERE `name`='Fred' OR `name`='Susan'";

アポストロフィをエスケープするよりも、上の構文のほうが読みやすくなるのでお勧めです。

.. _coding-standard.coding-style.strings.variable-substitution:

変数の展開
^^^^^

変数の展開を行うには、次のような方法を使用します。

.. code-block:: php
   :linenos:

   $greeting = "こんにちは $name さん。ようこそ!";

   $greeting = "こんにちは {$name} さん。ようこそ!";

一貫性を保つため、以下の形式は許可されません。

.. code-block:: php
   :linenos:

   $greeting = "こんにちは ${name} さん。ようこそ!";

.. _coding-standard.coding-style.strings.string-concatenation:

文字列の連結
^^^^^^

文字列の連結には "."
演算子を使用しなければなりません。コードを読みやすくするため、 "."
演算子の前後には常にスペースを入れなければなりません。

.. code-block:: php
   :linenos:

   $company = 'Zend' . ' ' . 'Technologies';

文字列を "." 演算子で連結する際には、コードを読みやすくするために
ひとつの文を複数行に分けることもできます。そのような場合は、 2
行目以降の行頭にスペースを入れ、各行の "." 演算子が最初の行の "="
演算子と同じ位置にくるようにしなければなりません。

.. code-block:: php
   :linenos:

   $sql = "SELECT `id`, `name` FROM `people` "
        . "WHERE `name` = 'Susan' "
        . "ORDER BY `name` ASC ";

.. _coding-standard.coding-style.arrays:

配列
^^

.. _coding-standard.coding-style.arrays.numerically-indexed:

数値添字の配列
^^^^^^^

添字として負の数を使用してはいけません。

数値添字の配列の添字は、0 以上の任意の数から始めることができます。
しかし、常に 0 から始めるようにすることを推奨します。

``Array`` を使用して数値添字の配列を宣言する場合は、
コードを読みやすくするため、
要素を区切るカンマの後にスペースを入れなければなりません。

.. code-block:: php
   :linenos:

   $sampleArray = array(1, 2, 3, 'Zend', 'Studio');

"array" を使用して、複数行にまたがる配列を宣言することも可能です。 その場合は、2
行目以降の行頭にスペースを入れ、
各行の開始位置が以下のようになるようにしなければなりません。

.. code-block:: php
   :linenos:

   $sampleArray = array(1, 2, 3, 'Zend', 'Studio',
                        $a, $b, $c,
                        56.44, $d, 500);

一方、配列の最初の要素を次の行から始めることもできます。
その場合は、配列を宣言した位置からさらに一段インデントした位置で要素をそろえ、
それ以降のすべての要素を同じインデントで記述するようにします。
閉じ括弧はそれ単体でひとつの行に記述し、インデント量は配列の宣言と同じ位置になります。

.. code-block:: php
   :linenos:

   $sampleArray = array(
       1, 2, 3, 'Zend', 'Studio',
       $a, $b, $c,
       56.44, $d, 500,
   );

この宣言を使用する際は、配列の最後の要素の後にもカンマをつけておくようにしましょう。
そうすることで、配列に新たな要素を追加したときにパースエラーが発生する危険性を
少なくできます。

.. _coding-standard.coding-style.arrays.associative:

連想配列
^^^^

連想配列を ``Array`` で宣言する場合には、
適宜改行をいれて複数行で宣言するようにしましょう。その場合は、 2
行目以降の行頭などにスペースを入れ、
キーと値の位置がそれぞれ揃うようにしなければなりません。

.. code-block:: php
   :linenos:

   $sampleArray = array('firstKey'  => 'firstValue',
                        'secondKey' => 'secondValue');

一方、配列の最初の要素を次の行から始めることもできます。
その場合は、配列を宣言した位置からさらに一段インデントした位置で要素をそろえ、
それ以降のすべての要素を同じインデントで記述するようにします。
閉じ括弧はそれ単体でひとつの行に記述し、インデント量は配列の宣言と同じ位置になります。
可読性を高めるため、代入演算子 "=>" の位置はそろえておかなければなりません。

.. code-block:: php
   :linenos:

   $sampleArray = array(
       'firstKey'  => 'firstValue',
       'secondKey' => 'secondValue',
   );

この宣言を使用する際は、配列の最後の要素の後にもカンマをつけておくようにしましょう。
そうすることで、配列に新たな要素を追加したときにパースエラーが発生する危険性を
少なくできます。

.. _coding-standard.coding-style.classes:

クラス
^^^

.. _coding-standard.coding-style.classes.declaration:

クラス宣言
^^^^^

クラス宣言は、以下の Zend Framework 命名規約に従わなければなりません。

開始波括弧は常にクラス名の下に書かなければなりません。

PHPDocumentor の標準形式のドキュメントブロックがなければなりません。

クラス内のコードは、すべて空白 4 文字で字下げします。

ひとつの *PHP* ファイルにはクラス定義をひとつだけ含めるようにします。

クラスファイルの中にクラス以外のコードを追加することもできますが、
お勧めしません。このような場合には、クラス定義とその他のコードの間に 空行を 2
行挿入しなければなりません。

これらの条件を満たすクラス宣言の例です。

.. code-block:: php
   :linenos:

   /**
    * これがドキュメントブロックです
    */
   class SampleClass
   {
       // クラスのすべての内容は、
       // 空白 4 文字の字下げを使用します。
   }

他のクラスを継承したりインターフェイスを実装したりしているクラスの宣言は、
可能な限りその依存関係も同じ行に含めるようにしなければなりません。

.. code-block:: php
   :linenos:

   class SampleClass extends FooAbstract implements BarInterface
   {
   }

このように宣言しようとした結果、もし行の長さが :ref:`最大文字数
<coding-standard.php-file-formatting.max-line-length>` を超えてしまう場合は、キーワード "extends"
や "implements" の前で改行してインデント量を一段増やします。

.. code-block:: php
   :linenos:

   class SampleClass
       extends FooAbstract
       implements BarInterface
   {
   }

複数のインターフェイスを実装していて宣言が行の最大長を超える場合は、
インターフェイスを区切るカンマの後で改行して
インターフェイス名の位置がそろうようにインデントします。

.. code-block:: php
   :linenos:

   class SampleClass
       implements BarInterface,
                  BazInterface
   {
   }

.. _coding-standard.coding-style.classes.member-variables:

クラスのメンバ変数
^^^^^^^^^

メンバ変数は、以下の Zend Framework 変数命名規約に従わなければなりません。

クラスの内部で使用する変数は、クラスの先頭 (あらゆるメソッド宣言より前)
で宣言する必要があります。

**var** 構文を使ってはいけません。メンバ変数を宣言する際には ``private``\ 、
``protected`` あるいは ``public``
のいずれかの修飾子を用いてアクセス範囲を指定します。 メンバ変数を public
宣言して外部からアクセスさせることもできますが、 それよりはアクセサメソッド
(set & get) を使用する方式のほうを推奨します。

.. _coding-standard.coding-style.functions-and-methods:

関数およびメソッド
^^^^^^^^^

.. _coding-standard.coding-style.functions-and-methods.declaration:

関数およびメソッドの宣言
^^^^^^^^^^^^

関数は、以下の Zend Framework 関数命名規約に従わなければなりません。

クラス内でメソッドを宣言する際には、常に ``private``\ 、 ``protected`` あるいは ``public``
のいずれかの修飾子を用いてアクセス範囲を指定しなければなりません。

クラスと同様、波括弧は関数名の次の行に書かなければなりません。
関数名と引数定義用の開始括弧の間にはスペースを入れてはいけません。

グローバルスコープの関数は、できるだけ使わないようにしましょう。

クラス内の関数宣言の例として適切なものを次に示します。

.. code-block:: php
   :linenos:

   /**
    * これがドキュメントブロックです
    */
   class Foo
   {
       /**
        * これがドキュメントブロックです
        */
       public function bar()
       {
           // 関数のすべての内容は、
           // 空白 4 文字の字下げを使用します。
       }
   }

引数リストが :ref:`行の最大文字数 <coding-standard.php-file-formatting.max-line-length>`
を超える場合は改行できます。 関数やメソッドの引数を改行して続ける場合は、
その宣言部よりさらに一段インデントしなければなりません。
そして、閉じ括弧の前にさらに改行を入れます。
宣言部の閉じ括弧と本体の開始波括弧はスペースをひとつはさんで同じ行に記述し、
そのインデント量は関数やメソッドの宣言位置と同じになります。
そんな場合の例を次に示します。

.. code-block:: php
   :linenos:

   /**
    * これがドキュメントブロックです
    */
   class Foo
   {
       /**
        * これがドキュメントブロックです
        */
       public function bar($arg1, $arg2, $arg3,
           $arg4, $arg5, $arg6
       ) {
           // 関数のすべての内容は、
           // 空白 4 文字の字下げを使用します。
       }
   }

.. note::

   **注意:** 値の参照渡しは、
   メソッドの宣言時にパラメータを渡す部分においてのみ可能です。

.. code-block:: php
   :linenos:

   /**
    * これがドキュメントブロックです
    */
   class Foo
   {
       /**
        * これがドキュメントブロックです
        */
       public function bar(&$baz)
       {}
   }

実行時の参照渡しは禁止されています。

返り値は括弧で囲んではいけません。これは可読性を下げますし、
将来そのメソッドが参照を返すようになった場合にコードが壊れてしまいます。

.. code-block:: php
   :linenos:

   /**
    * これがドキュメントブロックです
    */
   class Foo
   {
       /**
        * 間違いです
        */
       public function bar()
       {
           return($this->bar);
       }

       /**
        * 正しい形式です
        */
       public function bar()
       {
           return $this->bar;
       }
   }

.. _coding-standard.coding-style.functions-and-methods.usage:

関数およびメソッドの使用法
^^^^^^^^^^^^^

関数の引数を指定する際は、引数を区切るカンマの後に空白をひとつ入れます。
例えば 3 つの引数を受け取る関数をコールする場合の例は、 以下のようになります。

.. code-block:: php
   :linenos:

   threeArguments(1, 2, 3);

コール時に引数を参照渡しすることは禁じます。
関数への引数を参照渡しにする方法は、 関数宣言についての節を参照ください。

引数として配列を受け取る関数については、関数コールの中に "array"
構文を含め、それを複数行に分けることもできます。
そのような場合の記述法は、以下のようになります。

.. code-block:: php
   :linenos:

   threeArguments(array(1, 2, 3), 2, 3);

   threeArguments(array(1, 2, 3, 'Zend', 'Studio',
                        $a, $b, $c,
                        56.44, $d, 500), 2, 3);

   threeArguments(array(
       1, 2, 3, 'Zend', 'Studio',
       $a, $b, $c,
       56.44, $d, 500
   ), 2, 3);

.. _coding-standard.coding-style.control-statements:

制御構造
^^^^

.. _coding-standard.coding-style.control-statements.if-else-elseif:

If/Else/Elseif
^^^^^^^^^^^^^^

**if** および **elseif** 系の制御構造では、
条件を指定する括弧の前に空白をひとつ入れなければなりません。
また、条件指定の括弧を閉じた後にも空白をひとつ入れなければなりません。

括弧で囲まれた条件文の中では、演算子の前後にも空白をいれなければなりません。
また、条件の論理的な区切りを明確にするため、
条件文の中でも積極的に括弧を使用することを推奨します。

開始波括弧は、条件文と同じ行に記述します。
終了波括弧は、常に改行してそれのみで記述します。 波括弧の中では、空白 4
文字の字下げを使用します。

.. code-block:: php
   :linenos:

   if ($a != 2) {
       $a = 2;
   }

条件文が :ref:`行の最大文字数 <coding-standard.php-file-formatting.max-line-length>`
を超え、さらに複数の条件がある場合は、
それらを複数行にわけて記述できます。その場合は論理演算子の前で改行し、
条件句の最初の文字がそろうように位置を合わせます。
条件部の閉じ括弧と本体の開始波括弧はスペースをひとつはさんで同じ行に記述し、
そのインデント量は制御構文の開始位置と同じになります。

.. code-block:: php
   :linenos:

   if (($a == $b)
       && ($b == $c)
       || (Foo::CONST == $d)
   ) {
       $a = $d;
   }

後者の記法の意図は、
後から条件句を追加したり削除したりしたときに問題が起こりにくくすることにあります。

"elseif" あるいは "else" を含む "if" 文の場合の決まりは、通常の "if" と同じです。
次の例は、"if" 文に "else" や "elseif" が含まれる場合のものです。

.. code-block:: php
   :linenos:

   if ($a != 2) {
       $a = 2;
   } else {
       $a = 7;
   }

   if ($a != 2) {
       $a = 2;
   } elseif ($a == 3) {
       $a = 4;
   } else {
       $a = 7;
   }

   if (($a == $b)
       && ($b == $c)
       || (Foo::CONST == $d)
   ) {
       $a = $d;
   } elseif (($a != $b)
             || ($b != $c)
   ) {
       $a = $c;
   } else {
       $a = $b;
   }

場合によっては、これらの文で波括弧が必要ないこともあります。
しかし、このコーディング規約では、このような例外を認めません。 "if"、"elseif"
あるいは "else" 文では、常に波括弧を使用しなければなりません。

.. _coding-standards.coding-style.control-statements.switch:

Switch
^^^^^^

"switch" を使用した制御文では、
条件を指定する括弧の前に空白をひとつ入れなければなりません。
また、条件指定の括弧を閉じた後にも空白をひとつ入れなければなりません。

"switch" 文の中身は、空白 4 文字の字下げを使用します。 各 "case" 文の中身は、さらに
4 文字ぶん字下げします。

.. code-block:: php
   :linenos:

   switch ($numPeople) {
       case 1:
           break;

       case 2:
           break;

       default:
           break;
   }

``switch`` 文の ``default`` は、 決して省略してはいけません。

.. note::

   **注意:** 各 ``case`` の最後に ``break`` や ``return`` を記述せず、意図的に 次の ``case``
   に処理を流すという書き方をする場合もあるでしょう。
   これらの場合を単なる記述漏れと区別するために、 ``case`` 文で ``break`` あるいは
   ``return`` を指定しなかった場合は 「意図的に break
   を省略した」というコメントを含めるようにします。

.. _coding-standards.inline-documentation:

インラインドキュメント
^^^^^^^^^^^

.. _coding-standards.inline-documentation.documentation-format:

ドキュメントの書式
^^^^^^^^^

ドキュメントブロック ("docblocks") は、phpDocumentor
と互換性のある書式でなければなりません。 phpDocumentor
の書式については、このドキュメントの対象範囲外です。 詳細な情報は
`http://phpdoc.org/`_ を参照ください。

Zend Framework
のために書かれたコード、あるいはフレームワーク上で操作するコードは、
各ファイルの最初に「ファイルレベル」の docblock、
そして各クラスの直前に「クラスレベル」の docblock
を含めなければなりません。以下に docblock の例を示します。

.. _coding-standards.inline-documentation.files:

ファイル
^^^^

*PHP* コードを含むすべてのファイルは、最低限これらの phpDocumentor
タグを含むドキュメントブロックを、 ファイルの先頭に記述しなければなりません。

.. code-block:: php
   :linenos:

   /**
    * ファイルについての短い説明
    *
    * ファイルについての長い説明 (もしあれば)...
    *
    * LICENSE: ライセンスに関する情報
    *
    * @category   Zend
    * @package    Zend_Magic
    * @subpackage Wand
    * @copyright  Copyright (c) 2005-2012 Zend Technologies USA Inc. (http://www.zend.com)
    * @license    http://framework.zend.com/license   BSD License
    * @link       http://framework.zend.com/package/PackageName
    * @since      File available since Release 1.5.0
   */

``@category`` アノテーションの値は "Zend" でなければなりません。

``@package`` アノテーションも必須で、
ファイルに含まれるクラスのコンポーネント名と同じでなければなりません。
一般的には、これは "Zend"
プレフィックスとコンポーネント名のふたつの部分からなります。

``@subpackage`` アノテーションはオプションです。
指定する場合は、サブコンポーネント名からクラスのプレフィックスを除いたものとしなければなりません。
上の例の場合は、ファイルに含まれるクラス名が "``Zend_Magic_Wand``" であるか、
そのクラス名をプレフィックスの一部として使っているのでしょう。

.. _coding-standards.inline-documentation.classes:

クラス
^^^

各クラスには、最低限これらの phpDocumentor タグを含む docblock が必要です。

.. code-block:: php
   :linenos:

   /**
    * クラスについての短い説明
    *
    * クラスについての長い説明 (もしあれば)...
    *
    * @category   Zend
    * @package    Zend_Magic
    * @subpackage Wand
    * @copyright  Copyright (c) 2005-2012 Zend Technologies USA Inc. (http://www.zend.com)
    * @license    http://framework.zend.com/license   BSD License
    * @version    Release: @package_version@
    * @link       http://framework.zend.com/package/PackageName
    * @since      Class available since Release 1.5.0
    * @deprecated Class deprecated in Release 2.0.0
    */

``@category`` アノテーションの値は "Zend" でなければなりません。

``@package`` アノテーションも必須で、
そのクラスが属するコンポーネントの名前と同じでなければなりません。
一般的には、これは "Zend"
プレフィックスとコンポーネント名のふたつの部分からなります。

``@subpackage`` アノテーションはオプションです。
指定する場合は、サブコンポーネント名からクラスのプレフィックスを除いたものとしなければなりません。
上の例の場合は、ファイルに含まれるクラス名が "``Zend_Magic_Wand``" であるか、
そのクラス名をプレフィックスの一部として使っているのでしょう。

.. _coding-standards.inline-documentation.functions:

関数
^^

オブジェクトのメソッドを含めたすべての関数には、 最低限以下の内容を含む docblock
が必要です。

- 関数についての説明

- すべての引数

- 返り値

"@access" タグは必要ありません。なぜなら、
アクセスレベルについては関数宣言の際の "public"、"private" あるいは "protected"
によってわかっているからです。

関数/メソッドが例外をスローする場合には、すべての既知の例外クラスに対して
@throws を使用します。

.. code-block:: php
   :linenos:

   @throws exceptionclass [description]



.. _`ライセンス`: http://framework.zend.com/license
.. _`http://phpdoc.org/`: http://phpdoc.org/
